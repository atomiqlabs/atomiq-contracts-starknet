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
        withdraw_sequence: u32, btc_tx_hash: u256, data: BitcoinVaultTransactionData
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

    //Returns the address of the fronter for a specific btc tx (if any)
    fn get_fronter_address(
        self: @TContractState,
        owner: ContractAddress, vault_id: felt252,
        btc_tx_hash: u256, data: BitcoinVaultTransactionData
    ) -> ContractAddress;

    //Returns the address of the fronter for a fronting id (if any)
    fn get_fronter_address_by_id(
        self: @TContractState,
        owner: ContractAddress, vault_id: felt252,
        fronting_id: felt252
    ) -> ContractAddress;

    //Utility sanity call to check if the given bitcoin transaction is parsable
    fn parse_bitcoin_tx(self: @TContractState, transaction: ByteArray) -> Option<BitcoinVaultTransactionData>;
}

#[starknet::contract]
pub mod SpvVaultManager {
    use super::structs::BitcoinVaultTransactionDataTrait;
    use super::SpvVaultImplTrait;
    use core::num::traits::Zero;

    use core::starknet::{get_caller_address, ContractAddress};
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map, StoragePath, Mutable
    };
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::poseidon::PoseidonTrait;

    use btc_utils::bitcoin_merkle_tree;
    use btc_relay::{IBtcRelayReadOnlyDispatcher, IBtcRelayReadOnlyDispatcherTrait};
    use btc_utils::bitcoin_tx::{BitcoinTransactionImpl, BitcoinTransactionTrait, BitcoinTxInputTrait};
    use execution_contract::{IExecutionContractDispatcher, IExecutionContractDispatcherTrait};

    use crate::utils::{U32ArrayToU256ParserTrait, U64TupleAdd};
    use crate::structs::{BitcoinVaultTransactionDataImpl};
    use super::*;

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Opened: events::Opened,
        Deposited: events::Deposited,
        Claimed: events::Claimed,
        Fronted: events::Fronted,
        Closed: events::Closed
    }

    #[storage]
    struct Storage {
        execution_contract: ContractAddress,
        vaults: Map<ContractAddress, Map<felt252, SpvVaultState>>,
        liquidity_fronts: Map<ContractAddress, Map<felt252, Map<felt252, ContractAddress>>>
    }

    #[constructor]
    fn constructor(ref self: ContractState, execution_contract: ContractAddress) {
        self.execution_contract.write(execution_contract);
    }

    #[abi(embed_v0)]
    impl SpvVaultManagerImpl of super::ISpvVaultManager<ContractState> {
        
        fn open(
            ref self: ContractState, vault_id: felt252, 
            relay_contract: ContractAddress, utxo: (u256, u32), confirmations: u8,
            token_0: ContractAddress, token_1: ContractAddress, token_0_multiplier: felt252, token_1_multiplier: felt252
        ) {
            assert(utxo != (0, 0), 'utxo is zero');

            //Check vault is not opened
            let owner: ContractAddress = get_caller_address();
            let storage_ptr = self.vaults.entry(owner).entry(vault_id);
            assert(!storage_ptr.read().is_opened(), 'open: already opened');

            //Initialize new vault
            storage_ptr.write(SpvVaultState {
                relay_contract: relay_contract,
                token_0: token_0,
                token_1: token_1,
            
                utxo: utxo,
                confirmations: confirmations,
                withdraw_count: 0,
                deposit_count: 0,
            
                token_0_amount: 0,
                token_1_amount: 0,
                
                token_0_multiplier: token_0_multiplier,
                token_1_multiplier: token_1_multiplier
            });

            let (transaction_hash, vout) = utxo;
            self.emit(events::Opened {
                btc_tx_hash: transaction_hash,
                owner: owner,
                vault_id: vault_id,
                vout: vout
            });
        }

        //Deposits funds into the specific vault
        fn deposit(
            ref self: ContractState, owner: ContractAddress, vault_id: felt252, 
            raw_token_0_amount: u64, raw_token_1_amount: u64
        ) {
            //Check vault is opened
            let storage_ptr = self.vaults.entry(owner).entry(vault_id);
            let mut current_state = storage_ptr.read();
            assert(current_state.is_opened(), 'deposit: vault closed');

            //Update the state with newly deposited tokens
            let amounts = current_state.from_raw((raw_token_0_amount, raw_token_1_amount)).unwrap();
            current_state.deposit(raw_token_0_amount, raw_token_1_amount);

            //Save the state
            storage_ptr.write(current_state);

            //Transfer tokens in
            self._transfer_in((current_state.token_0, current_state.token_1), amounts);

            self.emit(events::Deposited {
                owner: owner,
                vault_id: vault_id,
                amounts: (raw_token_0_amount, raw_token_1_amount),
                deposit_count: current_state.deposit_count
            });
        }

        //Fronts the liquidity for a specific withdrawal bitcoin transaction
        fn front(
            ref self: ContractState, owner: ContractAddress, vault_id: felt252,
            withdraw_sequence: u32, btc_tx_hash: u256, data: BitcoinVaultTransactionData
        ) {
            let caller = get_caller_address();

            //Check vault is opened
            let storage_ptr = self.vaults.entry(owner).entry(vault_id);
            let current_state = storage_ptr.read();
            assert(current_state.is_opened(), 'front: vault closed');

            //This is to make sure that the caller doesn't front an already processed
            // withdraw, this would essentially make him loose funds
            assert(current_state.withdraw_count <= withdraw_sequence, 'front: already processed');

            let fronting_id = data.get_hash(btc_tx_hash);

            //Check if this was already fronted
            let front_storage_ptr = self.liquidity_fronts.entry(owner).entry(vault_id).entry(fronting_id);
            assert(front_storage_ptr.read().is_zero(), 'front: already fronted');

            //Mark as fronted
            front_storage_ptr.write(caller);

            let raw_amount = data.amount + (data.execution_handler_fee_amount_0, 0);

            //Transfer funds from caller to contract
            let amounts = current_state.from_raw(raw_amount).unwrap();
            self._transfer_in((current_state.token_0, current_state.token_1), amounts);

            //Transfer funds
            if data.execution_hash == 0 {
                //Pass funds straight to recipient
                self._transfer_out((current_state.token_0, current_state.token_1), amounts, data.recipient);
            } else {
                let (_, amount_raw_1) = data.amount;
                if amount_raw_1 != 0 {
                    erc20_utils::transfer_out(current_state.token_1, data.recipient, current_state.from_raw_token1(amount_raw_1).unwrap());
                }
                self._to_execution_contract(current_state, data, btc_tx_hash);
            }

            self.emit(events::Fronted {
                owner: owner,
                vault_id: vault_id,
                recipient: data.recipient,
                execution_hash: data.execution_hash,
                btc_tx_hash: btc_tx_hash,
                caller: caller,
                amounts: raw_amount
            });
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

            //Bitcoin transaction parsing and checks
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

            let btc_tx_hash_u256 = transaction_hash.to_u256();

            //IMPORTANT NOTE: It is very important that the following part has no way of panicing, since if this will panic
            // there is no way for LP to recover his funds, as he cannot just create an alternate transaction on BTC since the
            // previous vault UTXO is already spent and the transaction that should be used to withdraw funds was malformed, etc.
            // therefore we make sure that in case any error occurs we gracefully return all the funds to owner and close the
            // vault.

            //Make sure we send the funds to owner in the case when there is some issue with the transaction parsing or withdrawal,
            // such that funds don't get frozen
            //NOTE: Also verifies that full amounts are in bounds of u256 integer, such that we can use
            // .unwrap() on all .from_raw() calculations
            let withdrawal_result = current_state.parse_and_withdraw(btc_tx_hash_u256, @result);
            if withdrawal_result.is_err() {
                self._close(owner, vault_id, btc_tx_hash_u256, ref current_state, storage_ptr, withdrawal_result.unwrap_err());
                return;
            }
            let (total_raw_amounts, tx_data) = withdrawal_result.unwrap();

            //Save state
            storage_ptr.write(current_state);

            //Check if this was already fronted
            let fronting_id = tx_data.get_hash(btc_tx_hash_u256);
            let fronting_address: ContractAddress = self.liquidity_fronts.entry(owner).entry(vault_id).entry(fronting_id).read();
            if !fronting_address.is_zero() {
                //Transfer funds to caller
                self._transfer_out((current_state.token_0, current_state.token_1), current_state.from_raw(tx_data.caller_fee).unwrap(), caller);

                let fronting_amounts = tx_data.amount + tx_data.fronting_fee + (tx_data.execution_handler_fee_amount_0, 0);
                //Transfer funds to the account that fronted
                self._transfer_out((current_state.token_0, current_state.token_1), current_state.from_raw(fronting_amounts).unwrap(), fronting_address);
            } else {
                //Transfer caller fee + fronting fee to caller
                //NOTE: The reason we are also sending fronting fee to the caller here is that even if we wouldn't an
                // economically rational caller would just do a multical with front() & claim() in a single transaction
                // essentially claiming both fees anyway, we therefore align this functionality with the economically
                // rational behaviour of the caller
                self._transfer_out((current_state.token_0, current_state.token_1), current_state.from_raw(tx_data.caller_fee + tx_data.fronting_fee).unwrap(), caller);
                
                if tx_data.execution_hash == 0 {
                    //Payout the whole amount to the recipient
                    let payout_amounts = tx_data.amount + (tx_data.execution_handler_fee_amount_0, 0);
                    self._transfer_out((current_state.token_0, current_state.token_1), current_state.from_raw(payout_amounts).unwrap(), tx_data.recipient);
                } else {
                    let (_, amount_raw_1) = tx_data.amount;
                    //Pay out the gas token straight to recipient
                    if amount_raw_1 != 0 {
                        erc20_utils::transfer_out(current_state.token_1, tx_data.recipient, current_state.from_raw_token1(amount_raw_1).unwrap());
                    }
                    //Instantiate the execution contract
                    self._to_execution_contract(current_state, tx_data, btc_tx_hash_u256);
                }
            }

            self.emit(events::Claimed {
                owner: owner,
                vault_id: vault_id,
                recipient: tx_data.recipient,
                execution_hash: tx_data.execution_hash,
                btc_tx_hash: btc_tx_hash_u256,
                caller: caller,
                amounts: total_raw_amounts,
                fronting_address: fronting_address
            });
        }
    }

    #[abi(embed_v0)]
    impl SpvVaultManagerReadOnlyImpl of super::ISpvVaultManagerReadOnly<ContractState> {
        //Returns the current LP vault state
        fn get_vault(self: @ContractState, owner: ContractAddress, vault_id: felt252) -> SpvVaultState {
            self.vaults.entry(owner).entry(vault_id).read()
        }

        //Returns the address of the fronter for a specific btc tx (if any)
        fn get_fronter_address(
            self: @ContractState,
            owner: ContractAddress, vault_id: felt252,
            btc_tx_hash: u256, data: BitcoinVaultTransactionData
        ) -> ContractAddress {
            self.get_fronter_address_by_id(owner, vault_id, data.get_hash(btc_tx_hash))
        }

        //Returns the address of the fronter for a fronting id (if any)
        fn get_fronter_address_by_id(
            self: @ContractState,
            owner: ContractAddress, vault_id: felt252,
            fronting_id: felt252
        ) -> ContractAddress {
            self.liquidity_fronts.entry(owner).entry(vault_id).entry(fronting_id).read()
        }

        //Utility sanity call to check if the given bitcoin transaction is parsable
        fn parse_bitcoin_tx(self: @ContractState, transaction: ByteArray) -> Option<BitcoinVaultTransactionData> {
            let parsed_tx = BitcoinTransactionImpl::from_byte_array(@transaction);
            let tx_data = BitcoinVaultTransactionDataImpl::from_tx(@parsed_tx);
            if tx_data.is_err() {
                Option::None
            } else {
                Option::Some(tx_data.unwrap())
            }
        }
    }

    #[generate_trait]
    impl SpvVaultManagerPriv of SpvVaultManagerPrivTrait {

        //Close the vault and return all the funds to owner
        fn _close(ref self: ContractState, owner: ContractAddress, vault_id: felt252, btc_tx_hash: u256, ref current_state: SpvVaultState, storage_ptr: StoragePath<Mutable<SpvVaultState>>, err: felt252) {
            let amounts = current_state.from_raw((current_state.token_0_amount, current_state.token_1_amount)).unwrap();
            current_state.close();

            //Save state
            storage_ptr.write(current_state);

            //Payout funds back to owner
            self._transfer_out((current_state.token_0, current_state.token_1), amounts, owner);

            self.emit(events::Closed {
                btc_tx_hash: btc_tx_hash,
                owner: owner,
                vault_id: vault_id,
                error: err
            });
        }

        fn _transfer_in(self: @ContractState, tokens: (ContractAddress, ContractAddress), amounts: (u256, u256)) {
            let caller = get_caller_address();
            let (token_0, token_1) = tokens;
            let (amount_0, amount_1) = amounts;

            //Transfer funds
            if amount_0 != 0 {
                erc20_utils::transfer_in(token_0, caller, amount_0);
            }
            if amount_1 != 0 {
                erc20_utils::transfer_in(token_1, caller, amount_1);
            }
        }

        fn _transfer_out(self: @ContractState, tokens: (ContractAddress, ContractAddress), amounts: (u256, u256), recipient: ContractAddress) {
            let (token_0, token_1) = tokens;
            let (amount_0, amount_1) = amounts;

            //Transfer funds
            if amount_0 != 0 {
                erc20_utils::transfer_out(token_0, recipient, amount_0);
            }
            if amount_1 != 0 {
                erc20_utils::transfer_out(token_1, recipient, amount_1);
            }
        }

        //Create the execution in execution contract
        fn _to_execution_contract(self: @ContractState, current_state: SpvVaultState, data: BitcoinVaultTransactionData, btc_tx_hash: u256) {
            let (amount_raw_0, _) = data.amount;

            let amount_0 = current_state.from_raw_token0(amount_raw_0).unwrap();
            let execution_handler_fee = current_state.from_raw_token0(data.execution_handler_fee_amount_0).unwrap();
            let execution_contract = IExecutionContractDispatcher{contract_address: self.execution_contract.read()};

            erc20_utils::approve(current_state.token_0, execution_contract.contract_address, amount_0 + execution_handler_fee);
            
            //Generate salt from bitcoin transaction hash - as this has to be unique
            let salt = PoseidonTrait::new().update_with(btc_tx_hash).finalize();
            execution_contract.create(data.recipient, salt, current_state.token_0, amount_0, execution_handler_fee, data.execution_hash, data.execution_expiry.into());
        }

    }

}
