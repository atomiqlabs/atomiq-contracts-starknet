use crate::structs::ContractCall;
use starknet::contract_address::ContractAddress;

#[starknet::interface]
pub trait IExecutionProxy<TContractState> {
    //Execute
    fn execute(ref self: TContractState, data: Span<ContractCall>);
    //Reclaims erc20 tokens held by the execution proxy
    fn drain_tokens(ref self: TContractState, token: ContractAddress, other_tokens: Span<ContractAddress>, recipient: ContractAddress);
}

#[starknet::contract]
pub mod ExecutionProxy {
    use core::starknet::{get_contract_address};
    use starknet::contract_address::ContractAddress;
    use crate::structs::ContractCall;
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

        fn drain_tokens(ref self: ContractState, token: ContractAddress, other_tokens: Span<ContractAddress>, recipient: ContractAddress) {
            let balance = erc20_utils::balance_of(token, get_contract_address());
            if balance != 0 {
                erc20_utils::transfer_out(token, recipient, balance);
            }
            for token in other_tokens {
                let balance = erc20_utils::balance_of(*token, get_contract_address());
                if balance != 0 {
                    erc20_utils::transfer_out(*token, recipient, balance);
                }
            }
        }
    }

}
