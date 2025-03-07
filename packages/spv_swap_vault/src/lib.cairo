pub mod events;
pub mod state;
pub mod utils;
pub mod structs;

use starknet::{ContractAddress};
use btc_utils::byte_array::ByteArrayReader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

use crate::state::{SpvVaultStateStorePacking, SpvVaultState, SpvVaultImplTrait};
use crate::structs::{BitcoinVaultTransactionData};


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
        raw_token_0_amount: u64, raw_token_1_amount: u64
    );

    //Fronts the liquidity for a specific bitcoin transaction
    fn front(
        ref self: TContractState, owner: ContractAddress, vault_id: felt252,
        withdraw_sequence: u32, btc_tx: u256, data: BitcoinVaultTransactionData
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
    use super::SpvVaultImplTrait;
    use core::num::traits::Zero;

    use core::starknet::{get_caller_address, ContractAddress};
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };

    use btc_utils::bitcoin_merkle_tree;
    use btc_relay::{IBtcRelayReadOnlyDispatcher, IBtcRelayReadOnlyDispatcherTrait};
    use btc_utils::bitcoin_tx::{BitcoinTransactionImpl, BitcoinTransactionTrait, BitcoinTxInputTrait};

    use crate::utils;
    use crate::utils::{U32ArrayToU256ParserTrait};
    use crate::structs::{BitcoinVaultTransactionDataImpl};
    use super::*;

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Claim: events::Claim
    }

    #[storage]
    struct Storage {
        vaults: Map<ContractAddress, Map<felt252, SpvVaultState>>,
        liquidity_fronts: Map<ContractAddress, Map<felt252, Map<felt252, ContractAddress>>>
    }

    #[abi(embed_v0)]
    impl SpvVaultManagerImpl of super::ISpvVaultManager<ContractState> {
        
        fn open(
            ref self: ContractState, vault_id: felt252, 
            relay_contract: ContractAddress, utxo: (u256, u32), confirmations: u8,
            token_0: ContractAddress, token_1: ContractAddress, token_0_multiplier: felt252, token_1_multiplier: felt252
        ) {
            //Check vault is not opened
            let owner: ContractAddress = get_caller_address();
            let storage_ptr = self.vaults.entry(owner).entry(vault_id);
            assert(!storage_ptr.read().is_opened(), 'create: already opened');

            //Initialize new vault
            storage_ptr.write(SpvVaultState {
                relay_contract: relay_contract,
                token_0: token_0,
                token_1: token_1,
            
                utxo: utxo,
                confirmations: confirmations,
                withdraw_count: 0,
            
                token_0_amount: 0,
                token_1_amount: 0,
                
                token_0_multiplier: token_0_multiplier,
                token_1_multiplier: token_1_multiplier
            });
        }

        //Deposits funds into the specific vault
        fn deposit(
            ref self: ContractState, owner: ContractAddress, vault_id: felt252, 
            raw_token_0_amount: u64, raw_token_1_amount: u64
        ) {
            let caller = get_caller_address();

            //Check vault is opened
            let storage_ptr = self.vaults.entry(owner).entry(vault_id);
            let mut current_state = storage_ptr.read();
            assert(current_state.is_opened(), 'claim: vault closed');

            //Update the state with newly deposited tokens
            let (token_0_amount, token_1_amount) = current_state.deposit(raw_token_0_amount, raw_token_1_amount);

            //Save the state
            storage_ptr.write(current_state);

            //Transfer funds
            if token_0_amount != 0 {
                erc20_utils::transfer_in(current_state.token_0, caller, token_0_amount);
            }
            if token_1_amount != 0 {
                erc20_utils::transfer_in(current_state.token_1, caller, token_1_amount);
            }
        }

        //Fronts the liquidity for a specific withdrawal bitcoin transaction
        fn front(
            ref self: ContractState, owner: ContractAddress, vault_id: felt252,
            withdraw_sequence: u32, btc_tx: u256, data: BitcoinVaultTransactionData
        ) {
            let caller = get_caller_address();

            //Check vault is opened
            let storage_ptr = self.vaults.entry(owner).entry(vault_id);
            let current_state = storage_ptr.read();
            assert(current_state.is_opened(), 'front: vault closed');

            //This is to make sure that the caller doesn't front an already processed
            // withdraw, this would essentially make him loose funds
            assert(current_state.withdraw_count <= withdraw_sequence, 'front: already processed');

            let fronting_id = data.get_hash(btc_tx);

            //Check if this was already fronted
            let front_storage_ptr = self.liquidity_fronts.entry(owner).entry(vault_id).entry(fronting_id);
            assert(front_storage_ptr.read().is_zero(), 'front: already fronted');

            //Mark as fronted
            front_storage_ptr.write(caller);

            //Transfer funds to contract - minus watchtower & fronting fee
            let (amount_0, amount_1) = current_state.to_token_amounts(data.amount_0, data.amount_1);

            if amount_0 != 0 {
                let execution_fee = utils::fee_amount(amount_1, data.execution_handler_fee);
                erc20_utils::transfer_in(current_state.token_0, caller, amount_0);
                if data.execution_hash == 0 {
                    erc20_utils::transfer_out(current_state.token_0, data.recipient, amount_0);
                } else {

                }
            }
            if amount_1 != 0 {
                erc20_utils::transfer_in(current_state.token_1, caller, amount_1);
                erc20_utils::transfer_out(current_state.token_1, data.recipient, amount_1);
            }
        }

        //Claim funds from the vault, given a proper bitcoin transaction as verified through the relay contract
        fn claim(
            ref self: ContractState, owner: ContractAddress, vault_id: felt252,
            transaction: ByteArray, blockheader: StoredBlockHeader, merkle_proof: Span<[u32; 8]>, position: u32
        ) {
            let caller = get_caller_address();

            //Check vault is opened
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
            let tx_data_result = BitcoinVaultTransactionDataImpl::from_tx(result);

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

            let tx_data = tx_data_result.unwrap();

            let tx_id_u256 = transaction_hash.to_u256();

            //Returns clamped amount to the maximum that's currently in the vault, to prevent
            // funds from getting frozen
            let (amount_0, amount_1) = current_state.withdraw(tx_id_u256, 0, tx_data.amount_0, tx_data.amount_1);

            //Save state
            storage_ptr.write(current_state);
            
            //Check if fronted
            let fronting_id = tx_data.get_hash(tx_id_u256);

            //Check if this was already fronted
            let front_storage_ptr = self.liquidity_fronts.entry(owner).entry(vault_id).entry(fronting_id);
            let fronting_address: ContractAddress = front_storage_ptr.read();

            if !fronting_address.is_zero() {
                //Pay the funds to the address that fronted
                if amount_0 != 0 {
                    let caller_fee = utils::fee_amount(amount_0, tx_data.caller_fee);
                    let fronting_fee = utils::fee_amount(amount_0, tx_data.fronting_fee);
                    let execution_fee = utils::fee_amount(amount_0, tx_data.execution_handler_fee);
                    erc20_utils::transfer_out(current_state.token_0, caller, caller_fee);
                    erc20_utils::transfer_out(current_state.token_0, fronting_address, amount_0 + fronting_fee + execution_fee);
                }
                if amount_1 != 0 {
                    let caller_fee = utils::fee_amount(amount_1, tx_data.caller_fee);
                    let fronting_fee = utils::fee_amount(amount_1, tx_data.fronting_fee);
                    erc20_utils::transfer_out(current_state.token_1, caller, caller_fee);
                    erc20_utils::transfer_out(current_state.token_1, fronting_address, amount_1 + fronting_fee);
                }
                return;
            }

            //Transfer funds to recipient/execution contract
            
        }
    }

    #[abi(embed_v0)]
    impl SpvVaultManagerReadOnlyImpl of super::ISpvVaultManagerReadOnly<ContractState> {
        fn get_vault(self: @ContractState, owner: ContractAddress, vault_id: felt252) -> SpvVaultState {
            self.vaults.entry(owner).entry(vault_id).read()
        }
    }

    #[generate_trait]
    impl SpvVaultManagerPriv of SpvVaultManagerPrivTrait {

    }

}
