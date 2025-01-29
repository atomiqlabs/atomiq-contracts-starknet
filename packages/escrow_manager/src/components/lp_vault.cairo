use starknet::ContractAddress;

#[starknet::interface]
pub trait ILPVault<TContractState> {
    //Deposit funds to the LP vault
    fn deposit(ref self: TContractState, token: ContractAddress, amount: u256);
    //Withdraw funds from the LP vault
    fn withdraw(ref self: TContractState, token: ContractAddress, amount: u256, destination: ContractAddress);
    //Returns LP vault balances, the data parameter is in the format (owner, token_address)
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
        //Transfers escrow funds to the LP vault
        fn _transfer_out(ref self: ComponentState<TContractState>, token: ContractAddress, dst: ContractAddress, amount: u256) {
            let current_balance = self.lp_vault.entry(dst).entry(token).read();
            self.lp_vault.entry(dst).entry(token).write(current_balance + amount);
        }

        //Takes funds from the LP vault to fund the escrow
        fn _transfer_in(ref self: ComponentState<TContractState>, token: ContractAddress, src: ContractAddress, amount: u256) {
            let current_balance = self.lp_vault.entry(src).entry(token).read();
            assert(current_balance >= amount, '_xfer_in: not enough balance');
            self.lp_vault.entry(src).entry(token).write(current_balance - amount);
        }
    }

}
