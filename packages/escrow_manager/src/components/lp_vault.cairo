use starknet::ContractAddress;

#[starknet::interface]
pub trait ILPVault<TContractState> {
    fn deposit(ref self: TContractState, token: ContractAddress, amount: u256);
    fn withdraw(ref self: TContractState, token: ContractAddress, amount: u256, destination: ContractAddress);
    fn get_balance(self: @TContractState, data: Span<(ContractAddress, ContractAddress)>) -> Array<u256>;
}

#[starknet::component]
pub mod lp_vault {
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use core::starknet::{get_caller_address, ContractAddress};
    use crate::utils::erc20;

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {}

    #[storage]
    pub struct Storage {
        lp_vault: Map<ContractAddress, Map<ContractAddress,u256>>
    }

    #[embeddable_as(LPVault)]
    pub impl LPVaultImpl<
        TContractState, +HasComponent<TContractState>,
    > of super::ILPVault<ComponentState<TContractState>> {
        //LP vault
        fn deposit(ref self: ComponentState<TContractState>, token: ContractAddress, amount: u256) {
            let caller = get_caller_address();
            let current_balance = self.lp_vault.entry(caller).entry(token).read();
            self.lp_vault.entry(caller).entry(token).write(current_balance + amount);
            
            erc20::transfer_in(token, caller, amount);
        }

        fn withdraw(ref self: ComponentState<TContractState>, token: ContractAddress, amount: u256, destination: ContractAddress) {
            let caller = get_caller_address();
            let current_balance = self.lp_vault.entry(caller).entry(token).read();
            assert(current_balance >= amount, 'withdraw: not enough balance');
            self.lp_vault.entry(caller).entry(token).write(current_balance - amount);

            erc20::transfer_out(token, destination, amount);
        }

        fn get_balance(self: @ComponentState<TContractState>, data: Span<(ContractAddress, ContractAddress)>) -> Array<u256> {
            let mut balances: Array<u256> = array![];
            for (owner, token) in data {
                balances.append(self.lp_vault.entry(*owner).entry(*token).read());
            };
            balances
        }
    }


    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>,
    > of InternalTrait<TContractState> {
        fn _pay_out(ref self: ComponentState<TContractState>, dst: ContractAddress, token: ContractAddress, amount: u256, pay_out: bool) {
            if pay_out {
                erc20::transfer_out(token, dst, amount);
            } else {
                let current_balance = self.lp_vault.entry(dst).entry(token).read();
                self.lp_vault.entry(dst).entry(token).write(current_balance + amount);
            }
        }

        fn _pay_in(ref self: ComponentState<TContractState>, src: ContractAddress, token: ContractAddress, amount: u256, pay_in: bool) {
            if pay_in {
                erc20::transfer_in(token, src, amount);
            } else {
                let current_balance = self.lp_vault.entry(src).entry(token).read();
                assert(current_balance >= amount, '_pay_in: not enough balance');
                self.lp_vault.entry(src).entry(token).write(current_balance - amount);
            }
        }
    }

}
