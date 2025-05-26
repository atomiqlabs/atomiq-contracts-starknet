#[starknet::contract]
pub mod MockExecutionContract {
    use starknet::contract_address::ContractAddress;

    use core::starknet::{get_caller_address};
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    
    use execution_contract::structs::ContractCall;
    use execution_contract::state::Execution;
    use execution_contract::utils::SpanHashImpl;
    use execution_contract::events::{ExecutionProcessed, ExecutionCreated};
    use execution_contract::{IExecutionContract, IExecutionContractReadOnly};
    
    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        ExecutionCreated: ExecutionCreated,
        ExecutionProcessed: ExecutionProcessed
    }

    #[storage]
    struct Storage {
        //Scheduled executions saved in this contract
        executions: Map<ContractAddress, Map<felt252, Execution>>
    }

    #[abi(embed_v0)]
    impl ExecutionContractImpl of IExecutionContract<ContractState> {
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
            // self.emit(ExecutionCreated {
            //     owner: owner,
            //     salt: salt,
            //     execution_hash: execution_hash,
            //     token: token,
            //     amount: amount,
            //     expiry: expiry,
            //     execution_fee: execution_fee
            // });
        }

        fn execute(ref self: ContractState, owner: ContractAddress, salt: felt252, calls: Span<ContractCall>, drain_tokens: Span<ContractAddress>, clear_all: bool) {
        }

        //Reclaims the deposited tokens held by the execution contract, anyone can call after expiry
        fn refund_expired(ref self: ContractState, owner: ContractAddress, salt: felt252, clear_all: bool) {
        }

        //Reclaims the deposited tokens held by the execution contract, only callable by owner
        fn refund(ref self: ContractState, salt: felt252, clear_all: bool) {
        }
    }

    #[abi(embed_v0)]
    impl ExecutionContractReadOnlyImpl of IExecutionContractReadOnly<ContractState> {
        
        fn get_execution(self: @ContractState, owner: ContractAddress, salt: felt252) -> Execution {
            self.executions.entry(owner).entry(salt).read()
        }

    }

}
