pub mod events;
pub mod state;
pub mod utils;

use starknet::ContractAddress;
use btc_utils::byte_array::ByteArrayReader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

use crate::state::{SpvVaultStateStorePacking, SpvVaultState, SpvVaultImplTrait};


#[starknet::interface]
pub trait ISpvVaultManager<TContractState> {
    //Creates the vault and initiates it with the first UTXO in the chain
    fn open(
        ref self: TContractState, vault_id: felt252, 
        relay_contract: ContractAddress, utxo: (u256, u32), confirmations: u8,
        token_0: ContractAddress, token_1: ContractAddress, token_0_multiplier: felt252, token_1_multiplier: felt252
    );
    
    //Deposits funds into the specific vault
    fn deposit(
        ref self: TContractState, owner: ContractAddress, vault_id: felt252, 
        token_0_amount: u256, token_1_amount: u256
    );

    //Claim funds from the vault, given a proper bitcoin transaction as verified through the relay contract
    fn claim(
        ref self: TContractState, owner: ContractAddress, vault_id: felt252,
        transaction: ByteArray, blockheader: StoredBlockHeader, merkle_proof: Span<[u32; 8]>, position: u32
    );
}

#[starknet::interface]
pub trait ISpvVaultManagerReadOnly<TContractState> {
    //Returns the current LP vault state
    fn get_vault(self: @TContractState, owner: ContractAddress, vault_id: felt252) -> SpvVaultState;
}

#[starknet::contract]
pub mod SpvVaultManager {
    use core::integer::{u512_safe_div_rem_by_u256};
    use core::num::traits::WideMul;

    use core::starknet::{get_caller_address, ContractAddress};
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };

    use btc_utils::bitcoin_merkle_tree;
    use btc_relay::{IBtcRelayReadOnlyDispatcher, IBtcRelayReadOnlyDispatcherTrait};
    use btc_utils::bitcoin_tx::{BitcoinTransactionImpl, BitcoinTransactionTrait, BitcoinTxInputTrait};

    use crate::utils;
    use super::*;

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Claim: events::Claim
    }

    #[storage]
    struct Storage {
        vaults: Map<ContractAddress, Map<felt252, SpvVaultState>>
    }

    #[abi(embed_v0)]
    impl SpvVaultManagerImpl of super::ISpvVaultManager<ContractState> {
        
        fn open(
            ref self: ContractState, vault_id: felt252, 
            relay_contract: ContractAddress, utxo: (u256, u32), confirmations: u8,
            token_0: ContractAddress, token_1: ContractAddress, token_0_multiplier: felt252, token_1_multiplier: felt252
        ) {
            let owner: ContractAddress = get_caller_address();
            let storage_ptr = self.vaults.entry(owner).entry(vault_id);
            assert(!storage_ptr.read().is_opened(), 'create: already opened');

            storage_ptr.write(SpvVaultState {
                relay_contract: relay_contract,
                token_0: token_0,
                token_1: token_1,
            
                utxo: utxo,
                confirmations: confirmations,
            
                token_0_amount: 0,
                token_1_amount: 0,
                
                token_0_multiplier: token_0_multiplier,
                token_1_multiplier: token_1_multiplier
            });
        }

        //Deposits funds into the specific vault
        fn deposit(
            ref self: ContractState, owner: ContractAddress, vault_id: felt252, 
            token_0_amount: u256, token_1_amount: u256
        ) {
            let caller = get_caller_address();

            let storage_ptr = self.vaults.entry(owner).entry(vault_id);
            let mut current_state = storage_ptr.read();
            assert(current_state.is_opened(), 'claim: vault closed');

            if token_0_amount != 0 {
                current_state.token_0_amount += token_0_amount;
            }
            if token_1_amount != 0 {
                current_state.token_1_amount += token_1_amount;
            }

            storage_ptr.write(current_state);

            if token_0_amount != 0 {
                erc20_utils::transfer_in(current_state.token_0, caller, token_0_amount);
            }
            if token_1_amount != 0 {
                erc20_utils::transfer_in(current_state.token_1, caller, token_1_amount);
            }
        }

        //Claim funds from the vault, given a proper bitcoin transaction as verified through the relay contract
        fn claim(
            ref self: ContractState, owner: ContractAddress, vault_id: felt252,
            transaction: ByteArray, blockheader: StoredBlockHeader, merkle_proof: Span<[u32; 8]>, position: u32
        ) {
            let caller = get_caller_address();

            let storage_ptr = self.vaults.entry(owner).entry(vault_id);
            let mut current_state = storage_ptr.read();
            assert(current_state.is_opened(), 'claim: vault closed');

            //Parse transaction
            let result = BitcoinTransactionImpl::from_byte_array(@transaction);
            
            //Make sure the transaction properly spends last vault UTXO
            assert(result.get_in(0).expect('claim: empty inputs').unbox().get_utxo()==current_state.utxo, 'claim: incorrect in_0 utxo');

            //Verify blockheader against the light client
            let block_confirmations = IBtcRelayReadOnlyDispatcher{contract_address: current_state.relay_contract}.verify_blockheader(blockheader);
            assert(block_confirmations>=current_state.confirmations.into(), 'claim: confirmations');

            let transaction_hash = result.get_hash();

            //Verify merkle proof
            bitcoin_merkle_tree::verify(
                blockheader.blockheader.merkle_root,
                transaction_hash,
                merkle_proof,
                position
            );

            //Extract data from transaction
            let tx_data_result = utils::extract_tx_data(result, current_state.token_0_multiplier, current_state.token_1_multiplier);

            //Make sure we send the funds to owner in the case when there is some issue with the transaction,
            // such that funds don't get frozen
            if tx_data_result.is_err() {
                //Close the vault and return all the funds to owner
                let (token_0_amount, token_1_amount) = current_state.close();

                //Save state
                storage_ptr.write(current_state);

                //Payout funds back to owner
                if token_0_amount != 0 {
                    erc20_utils::transfer_out(current_state.token_0, owner, token_0_amount);
                }
                if token_1_amount != 0 {
                    erc20_utils::transfer_out(current_state.token_1, owner, token_1_amount);
                }
                return;
            }

            let (recipient, raw_amount_0, raw_amount_1, caller_fee_u16) = tx_data_result.unwrap();

            //Clamp the amount to the maximum that's currently in the vault, to prevent
            // funds from getting frozen
            let amount_0 = if raw_amount_0 > current_state.token_0_amount {current_state.token_0_amount} else {raw_amount_0};
            let amount_1 = if raw_amount_1 > current_state.token_1_amount {current_state.token_1_amount} else {raw_amount_1};

            //Update the state
            current_state.token_0_amount -= amount_0;
            current_state.token_1_amount -= amount_1;
            current_state.set_utxo(transaction_hash, 0);

            //Save state
            storage_ptr.write(current_state);
            
            //Transfer out funds
            if amount_0 != 0 {
                let (quotient, _) = u512_safe_div_rem_by_u256(amount_0.wide_mul(caller_fee_u16.into()), 65535);
                //Note that this is a safe cast, since we are passing u16 value to the multiplication & dividing by 2^16 - 1,
                // such that the resulting value will always be at most 2^256 - 1
                let caller_fee: u256 = quotient.try_into().unwrap();
                let leaves_amount = amount_0 - caller_fee;
                erc20_utils::transfer_out(current_state.token_0, caller, caller_fee);
                erc20_utils::transfer_out(current_state.token_0, recipient, leaves_amount);
            }
            if amount_1 != 0 {
                let (quotient, _) = u512_safe_div_rem_by_u256(amount_1.wide_mul(caller_fee_u16.into()), 65535);
                //Note that this is a safe cast, since we are passing u16 value to the multiplication & dividing by 2^16 - 1,
                // such that the resulting value will always be at most 2^256 - 1
                let caller_fee: u256 = quotient.try_into().unwrap();
                let leaves_amount = amount_1 - caller_fee;
                erc20_utils::transfer_out(current_state.token_1, caller, caller_fee);
                erc20_utils::transfer_out(current_state.token_1, recipient, leaves_amount);
            }
        }
    }

    #[abi(embed_v0)]
    impl SpvVaultManagerReadOnlyImpl of super::ISpvVaultManagerReadOnly<ContractState> {
        fn get_vault(self: @ContractState, owner: ContractAddress, vault_id: felt252) -> SpvVaultState {
            self.vaults.entry(owner).entry(vault_id).read()
        }
    }
}
