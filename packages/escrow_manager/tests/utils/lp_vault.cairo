use snforge_std::{
    cheat_caller_address, CheatSpan
};
use starknet::contract_address::{ContractAddress, contract_address_const};

use escrow_manager::components::lp_vault::{ILPVaultDispatcher, ILPVaultDispatcherTrait};

use crate::utils::contract::{deploy};
use crate::utils::erc20;

use openzeppelin_token::erc20::{ERC20ABIDispatcher, ERC20ABIDispatcherTrait};

pub fn mint_to_lp_vault(contract_address: ContractAddress, user: ContractAddress, token: ERC20ABIDispatcher, amount: u256) {
    erc20::mint(token, user, amount);

    cheat_caller_address(token.contract_address, user, CheatSpan::TargetCalls(1));
    token.approve(contract_address, amount);
    
    let balance_erc20 = token.balance_of(user);
    let balance_contract = *ILPVaultDispatcher{contract_address}.get_balance(array![(user, token.contract_address)].span()).span()[0];

    ILPVaultDispatcher{contract_address}.deposit(token.contract_address, amount);

    assert_eq!(token.balance_of(user), balance_erc20-amount);
    assert_eq!(ILPVaultDispatcher{contract_address}.get_balance(array![(user, token.contract_address)].span()), array![balance_contract+amount]);
}
