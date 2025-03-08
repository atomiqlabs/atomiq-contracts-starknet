pub mod structs;
pub mod state;
pub mod utils;
pub mod execution_proxy;
pub mod events;

use crate::structs::ContractCall;
use starknet::contract_address::ContractAddress;
use crate::state::Execution;

#[starknet::interface]
pub trait IExecutionContract<TContractState> {
    //Creates a new execution
    fn create(
        ref self: TContractState, 
        owner: ContractAddress, salt: felt252, token: ContractAddress, 
        amount: u256, execution_fee: u256,
        execution_hash: felt252, expiry: u64
    );

    //The reason for clear_all flag is to save on data storage gas, if the post & execute/refund_expired/refund is executed in a single
    // transaction clear_all should be set to true, such that all the data is cleared resulting in no state diff, when calling the
    // execute/refund_expired/refund later, clear_all should be set to false, such that the state diff is only a single felt

    //Execute calls on behalf of owner, draining all the drain_tokens to the owner
    fn execute(ref self: TContractState, owner: ContractAddress, salt: felt252, calls: Span<ContractCall>, drain_tokens: Span<ContractAddress>, clear_all: bool);
    //Reclaims the deposited tokens held by the execution contract, anyone can call after expiry
    fn refund_expired(ref self: TContractState, owner: ContractAddress, salt: felt252, clear_all: bool);
    //Reclaims the deposited tokens held by the execution contract, only callable by owner
    fn refund(ref self: TContractState, salt: felt252, clear_all: bool);
}

#[starknet::interface]
pub trait IExecutionContractReadOnly<TContractState> {
    fn get_execution(self: @TContractState, owner: ContractAddress, salt: felt252) -> Execution;
}

#[starknet::contract]
pub mod ExecutionContract {
    use starknet::contract_address::ContractAddress;
    use starknet::syscalls::deploy_syscall;

    use core::starknet::{get_caller_address, get_block_timestamp};
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::poseidon::PoseidonTrait;
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    
    use crate::execution_proxy::{IExecutionProxySafeDispatcher, IExecutionProxySafeDispatcherTrait};
    use crate::structs::ContractCall;
    use crate::state::{Execution, ExecutionImplTrait};
    use crate::utils::SpanHashImpl;
    use crate::events::{ExecutionProcessed, ExecutionCreated};
    
    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        ExecutionCreated: ExecutionCreated,
        ExecutionProcessed: ExecutionProcessed
    }

    #[storage]
    struct Storage {
        //Execution proxy to separate this contract's balance
        execution_proxy: ContractAddress,
        //Scheduled executions saved in this contract
        executions: Map<ContractAddress, Map<felt252, Execution>>
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        let (execution_proxy_address, _) = deploy_syscall(
            0x5b4644a8bc1cafc820a7937b77af9cdf11472c764fe6636c0eaeef2a08032ca.try_into().unwrap(),
            0,
            array![].span(),
            false
        ).unwrap();
        self.execution_proxy.write(execution_proxy_address);
    }

    #[abi(embed_v0)]
    impl ExecutionContractImpl of super::IExecutionContract<ContractState> {
        fn create(
            ref self: ContractState, 
            owner: ContractAddress, salt: felt252, token: ContractAddress, 
            amount: u256, execution_fee: u256,
            execution_hash: felt252, expiry: u64
        ) {
            //Make sure the execution hash not 0, we use 0 to indicate that the saved execution is empty
            assert(execution_hash != 0, 'create: execution_hash=0');

            //Make sure execution not yet initialized
            let execution_ptr = self.executions.entry(owner).entry(salt);
            assert(execution_ptr.read().execution_hash == 0, 'create: Already initiated');

            let execution = Execution {
                token: token,
                execution_hash: execution_hash,
                amount: amount,
                execution_fee: execution_fee,
                expiry: expiry
            };
            execution_ptr.write(execution);
            
            //Transfer amount to the contract
            let total_amount = amount + execution_fee;
            erc20_utils::transfer_in(token, get_caller_address(), total_amount);

            //Emit event
            self.emit(ExecutionCreated {
                owner: owner,
                salt: salt,
                execution_hash: execution_hash,
                token: token,
                amount: amount,
                expiry: expiry,
                execution_fee: execution_fee
            });
        }

        fn execute(ref self: ContractState, owner: ContractAddress, salt: felt252, calls: Span<ContractCall>, drain_tokens: Span<ContractAddress>, clear_all: bool) {
            let execution_ptr = self.executions.entry(owner).entry(salt);
            let mut execution = execution_ptr.read();

            //Check if already processed
            assert(execution.execution_hash != 0, 'execute: Already processed');

            //Check if hash matches
            let execution_hash = PoseidonTrait::new().update_with(calls).update_with(drain_tokens).finalize();
            assert(
                execution.execution_hash == execution_hash,
                'execute: Invalid calls/tokens'
            );

            //Retrieve caller & the fee to be paid to caller
            let caller = get_caller_address();
            let token = execution.token;
            let amount = execution.amount;
            let execution_fee = execution.execution_fee;

            //Clear execution (set to processed)
            execution.clear(clear_all);
            execution_ptr.write(execution);

            //Transfer execution fee to caller
            erc20_utils::transfer_out(token, caller, execution_fee);

            //Transfer the amount to execution proxy contract
            let execution_proxy = IExecutionProxySafeDispatcher{contract_address: self.execution_proxy.read()};
            erc20_utils::transfer_out(token, execution_proxy.contract_address, amount);

            //Execute external calls through the execution proxy
            let call_result = execution_proxy.execute(calls);

            //Check for error during call
            let (call_err, success) = if call_result.is_err() {
                (call_result.unwrap_err(), false)
            } else {
                (array![], true)
            };

            //Drain all the tokens from the execution proxy straight to the owner
            execution_proxy.drain_tokens(token, drain_tokens, owner).unwrap();

            //Emit event
            self.emit(ExecutionProcessed {
                owner: owner,
                salt: salt,
                execution_hash: execution_hash,
                error: call_err.span(),
                success: success
            });
        }

        //Reclaims the deposited tokens held by the execution contract, anyone can call after expiry
        fn refund_expired(ref self: ContractState, owner: ContractAddress, salt: felt252, clear_all: bool) {
            let execution_ptr = self.executions.entry(owner).entry(salt);
            let mut execution = execution_ptr.read();

            //Check if already expired
            assert(execution.expiry <= get_block_timestamp(), 'refund_exp: Not expired yet');

            //Check if already processed
            let execution_hash = execution.execution_hash;
            assert(execution_hash != 0, 'refund_exp: Already processed');

            //Retrieve caller & the fee to be paid to caller
            let caller = get_caller_address();
            let token = execution.token;
            let execution_fee = execution.execution_fee;
            let amount = execution.amount;

            //Clear execution (set to processed)
            execution.clear(clear_all);
            execution_ptr.write(execution);

            //Transfer execution fee to caller
            erc20_utils::transfer_out(token, caller, execution_fee);

            //Transfer funds back to owner
            erc20_utils::transfer_out(token, owner, amount);

            //Emit event
            self.emit(ExecutionProcessed {
                owner: owner,
                salt: salt,
                execution_hash: execution_hash,
                error: array![].span(),
                success: false
            });
        }

        //Reclaims the deposited tokens held by the execution contract, only callable by owner
        fn refund(ref self: ContractState, salt: felt252, clear_all: bool) {
            //Owner needs to be caller in this case!
            let owner = get_caller_address();

            let execution_ptr = self.executions.entry(owner).entry(salt);
            let mut execution = execution_ptr.read();

            //Check if already processed
            let execution_hash = execution.execution_hash;
            assert(execution_hash != 0, 'refund: Already processed');

            //Retrieve caller & the fee to be paid to caller
            let token = execution.token;
            let execution_fee = execution.execution_fee;
            let amount = execution.amount;

            //Clear execution (set to processed)
            execution.clear(clear_all);
            execution_ptr.write(execution);

            //Transfer all the funds back to owner
            erc20_utils::transfer_out(token, owner, amount + execution_fee);

            //Emit event
            self.emit(ExecutionProcessed {
                owner: owner,
                salt: salt,
                execution_hash: execution_hash,
                error: array![].span(),
                success: false
            });
        }
    }

    #[abi(embed_v0)]
    impl ExecutionContractReadOnlyImpl of super::IExecutionContractReadOnly<ContractState> {
        
        fn get_execution(self: @ContractState, owner: ContractAddress, salt: felt252) -> Execution {
            self.executions.entry(owner).entry(salt).read()
        }

    }

}
