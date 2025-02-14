use crate::structs::contract_call::ContractCall;
use starknet::contract_address::ContractAddress;

#[starknet::interface]
pub trait IExecutionProxy<TContractState> {
    //Execute
    fn execute(ref self: TContractState, data: Span<ContractCall>);
    //Reclaims specific erc20 token held by the execution proxy
    fn reclaim_erc20(ref self: TContractState, token: ContractAddress, amount: u256);
}

#[starknet::contract]
pub mod ExecutionProxy {
    use core::starknet::get_caller_address;
    use starknet::contract_address::ContractAddress;
    use crate::structs::contract_call::ContractCall;
    use crate::utils::erc20;
    use starknet::syscalls::call_contract_syscall;
    
    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl ExecutionProxyImpl of super::IExecutionProxy<ContractState> {
        fn execute(ref self: ContractState, data: Span<ContractCall>) {
            for call in data {
                call_contract_syscall(*call.address, *call.entrypoint, *call.calldata).unwrap();
            }
        }

        fn reclaim_erc20(ref self: ContractState, token: ContractAddress, amount: u256) {
            erc20::transfer_out(token, get_caller_address(), amount);
        }
    }

}
