use crate::structs::ContractCall;
use starknet::contract_address::ContractAddress;

#[starknet::interface]
pub trait IExecutionProxy<TContractState> {
    //Execute
    fn execute(ref self: TContractState, data: Span<ContractCall>);
    //Reclaims erc20 tokens held by the execution proxy
    fn drain_tokens(ref self: TContractState, main_token: ContractAddress, other_tokens: Span<ContractAddress>, recipient: ContractAddress);
}

#[starknet::contract]
pub mod ExecutionProxy {
    use core::starknet::{get_contract_address};
    use starknet::contract_address::ContractAddress;
    use crate::structs::ContractCall;
    use starknet::syscalls::call_contract_syscall;
    use starknet::SyscallResultTrait;
    
    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl ExecutionProxyImpl of super::IExecutionProxy<ContractState> {
        fn execute(ref self: ContractState, data: Span<ContractCall>) {
            for call in data {
                call_contract_syscall(*call.address, *call.entrypoint, *call.calldata).unwrap_syscall();
            }
        }

        fn drain_tokens(ref self: ContractState, main_token: ContractAddress, other_tokens: Span<ContractAddress>, recipient: ContractAddress) {
            let balance = erc20_utils::balance_of(main_token, get_contract_address());
            if balance != 0 {
                erc20_utils::transfer_out(main_token, recipient, balance);
            }
            for other_token in other_tokens {
                let balance = erc20_utils::balance_of(*other_token, get_contract_address());
                if balance != 0 {
                    erc20_utils::transfer_out(*other_token, recipient, balance);
                }
            }
        }
    }

}
