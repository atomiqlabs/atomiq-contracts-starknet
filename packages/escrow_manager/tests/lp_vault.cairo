use snforge_std::{
    cheat_caller_address, CheatSpan
};
use starknet::contract_address::{ContractAddress, contract_address_const};

use escrow_manager::components::lp_vault::{ILPVaultDispatcher, ILPVaultDispatcherTrait};

use crate::utils::contract::{get_context};
use crate::utils::erc20;

use openzeppelin_token::erc20::{ERC20ABIDispatcher, ERC20ABIDispatcherTrait};

fn deploy_all(mint_amount: u256) -> (ContractAddress, ContractAddress, ERC20ABIDispatcher) {
    let user = contract_address_const::<'depositor'>();

    let contract_address = get_context().contract_address;
    let erc20_dispatcher = erc20::deploy_mint_and_assert(user, mint_amount);

    cheat_caller_address(erc20_dispatcher.contract_address, user, CheatSpan::TargetCalls(1));
    erc20_dispatcher.approve(contract_address, 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe);

    cheat_caller_address(contract_address, user, CheatSpan::Indefinite);

    (user, contract_address, erc20_dispatcher)
}

fn deposit_and_assert(user: ContractAddress, contract_address: ContractAddress, erc20_dispatcher: ERC20ABIDispatcher, amount: u256) {
    let balance_erc20 = erc20_dispatcher.balance_of(user);
    let balance_contract = *ILPVaultDispatcher{contract_address}.get_balance(array![(user, erc20_dispatcher.contract_address)].span()).span()[0];
    let balance_erc20_contract = erc20_dispatcher.balance_of(contract_address);
    
    ILPVaultDispatcher{contract_address}.deposit(erc20_dispatcher.contract_address, amount);

    assert_eq!(erc20_dispatcher.balance_of(user), balance_erc20-amount);
    assert_eq!(ILPVaultDispatcher{contract_address}.get_balance(array![(user, erc20_dispatcher.contract_address)].span()), array![balance_contract+amount]);
    assert_eq!(erc20_dispatcher.balance_of(contract_address), balance_erc20_contract+amount);
}

//Valid deposit to the LP vault
#[test]
fn valid_deposit() {
    let (user, contract_address, erc20_dispatcher) = deploy_all(100);
    deposit_and_assert(user, contract_address, erc20_dispatcher, 50);
}

//Deposit to LP vault without sufficient erc20 allowance
#[test]
#[should_panic(expected: 'ERC20: insufficient allowance')]
fn invalid_deposit_no_allowance() {
    let (user, contract_address, erc20_dispatcher) = deploy_all(100);

    cheat_caller_address(erc20_dispatcher.contract_address, user, CheatSpan::TargetCalls(1));
    erc20_dispatcher.approve(contract_address, 0);
    deposit_and_assert(user, contract_address, erc20_dispatcher, 50);
}

//Deposit to LP vault without sufficient erc20 balance
#[test]
#[should_panic(expected: 'ERC20: insufficient balance')]
fn invalid_deposit_no_balance() {
    let (user, contract_address, erc20_dispatcher) = deploy_all(100);
    deposit_and_assert(user, contract_address, erc20_dispatcher, 200);
}

//Valid partial withdrawal from the LP vault (leaves funds in the LP vault)
#[test]
fn valid_withdraw_partial() {
    let (user, contract_address, erc20_dispatcher) = deploy_all(100);
    deposit_and_assert(user, contract_address, erc20_dispatcher, 50);

    ILPVaultDispatcher{contract_address}.withdraw(erc20_dispatcher.contract_address, 25, user);
    assert_eq!(erc20_dispatcher.balance_of(user), 75);
    assert_eq!(ILPVaultDispatcher{contract_address}.get_balance(array![(user, erc20_dispatcher.contract_address)].span()), array![25]);
}

//Valid full withdrawal from the LP vault (leaves no funds in the LP vault)
#[test]
fn valid_withdraw_full() {
    let (user, contract_address, erc20_dispatcher) = deploy_all(100);
    deposit_and_assert(user, contract_address, erc20_dispatcher, 50);

    ILPVaultDispatcher{contract_address}.withdraw(erc20_dispatcher.contract_address, 50, user);
    assert_eq!(erc20_dispatcher.balance_of(user), 100);
    assert_eq!(ILPVaultDispatcher{contract_address}.get_balance(array![(user, erc20_dispatcher.contract_address)].span()), array![0]);
}

//Valid partial withdrawal from the LP vault (leaves funds in the LP vault) to the external 3rd party address
#[test]
fn valid_withdraw_partial_external() {
    let (user, contract_address, erc20_dispatcher) = deploy_all(100);
    deposit_and_assert(user, contract_address, erc20_dispatcher, 50);
    let external = contract_address_const::<'external'>();

    ILPVaultDispatcher{contract_address}.withdraw(erc20_dispatcher.contract_address, 25, external);
    assert_eq!(erc20_dispatcher.balance_of(user), 50);
    assert_eq!(erc20_dispatcher.balance_of(external), 25);
    assert_eq!(ILPVaultDispatcher{contract_address}.get_balance(array![(user, erc20_dispatcher.contract_address)].span()), array![25]);
}

//Valid full withdrawal from the LP vault (leaves no funds in the LP vault) to the external 3rd party address
#[test]
fn valid_withdraw_full_external() {
    let (user, contract_address, erc20_dispatcher) = deploy_all(100);
    deposit_and_assert(user, contract_address, erc20_dispatcher, 50);
    let external = contract_address_const::<'external'>();

    ILPVaultDispatcher{contract_address}.withdraw(erc20_dispatcher.contract_address, 50, external);
    assert_eq!(erc20_dispatcher.balance_of(user), 50);
    assert_eq!(erc20_dispatcher.balance_of(external), 50);
    assert_eq!(ILPVaultDispatcher{contract_address}.get_balance(array![(user, erc20_dispatcher.contract_address)].span()), array![0]);
}

//Try to withdraw more than balance in the LP vault
#[test]
#[should_panic(expected: 'withdraw: not enough balance')]
fn invalid_withdraw_no_balance() {
    let (user, contract_address, erc20_dispatcher) = deploy_all(100);
    deposit_and_assert(user, contract_address, erc20_dispatcher, 50);

    ILPVaultDispatcher{contract_address}.withdraw(erc20_dispatcher.contract_address, 100, user);
}
