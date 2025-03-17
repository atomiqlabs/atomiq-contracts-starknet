use starknet::contract_address::{ContractAddress, contract_address_const};

use openzeppelin_token::erc20::interface::{ERC20ABIDispatcherTrait};

use snforge_std::{
    cheat_caller_address, CheatSpan
};

use crate::utils::contract::{Context, get_context};
use crate::utils::btc_relay::get_btc_relay_with_txs;
use crate::utils::spv_vault::{create_spv_vault, get_funded_spv_vault, deposit_and_assert};
use crate::utils::erc20;

#[test]
fn valid_deposit_single() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let (_, relay_contract) = get_btc_relay_with_txs(array![].span(), 1);
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 1;
    let token_1_multiplier: felt252 = 1;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);
}

#[test]
fn valid_deposit_multiple() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let (_, relay_contract) = get_btc_relay_with_txs(array![].span(), 1);
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 1;
    let token_1_multiplier: felt252 = 1;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    erc20::mint(context.token0, owner, 123132);
    cheat_caller_address(context.token0.contract_address, owner, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, 123132);
    
    erc20::mint(context.token1, owner, 3123);
    cheat_caller_address(context.token1.contract_address, owner, CheatSpan::TargetCalls(1));
    context.token1.approve(context.contract.contract_address, 3123);

    deposit_and_assert(context, owner, vault_id, token_0_multiplier, token_1_multiplier, 123132, 3123);
}

#[test]
#[should_panic(expected: 'deposit: vault closed')]
fn invalid_deposit_not_opened() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let token_0_multiplier: felt252 = 854845;
    let token_1_multiplier: felt252 = 434345;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let amount_0: u256 = raw_amount_0.into() * token_0_multiplier.into();
    let amount_1: u256 = raw_amount_1.into() * token_1_multiplier.into();

    erc20::mint(context.token0, owner, amount_0);
    cheat_caller_address(context.token0.contract_address, owner, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, amount_0);
    
    erc20::mint(context.token1, owner, amount_1);
    cheat_caller_address(context.token1.contract_address, owner, CheatSpan::TargetCalls(1));
    context.token1.approve(context.contract.contract_address, amount_1);

    deposit_and_assert(context, owner, vault_id, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);
}

#[test]
#[should_panic(expected: 'ERC20: insufficient balance')]
fn invalid_balance_token0() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let (_, relay_contract) = get_btc_relay_with_txs(array![].span(), 1);
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 854845;
    let token_1_multiplier: felt252 = 434345;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let amount_0: u256 = raw_amount_0.into() * token_0_multiplier.into();
    let amount_1: u256 = raw_amount_1.into() * token_1_multiplier.into();

    create_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier);

    erc20::mint(context.token0, owner, 123);
    cheat_caller_address(context.token0.contract_address, owner, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, amount_0);
    
    erc20::mint(context.token1, owner, amount_1);
    cheat_caller_address(context.token1.contract_address, owner, CheatSpan::TargetCalls(1));
    context.token1.approve(context.contract.contract_address, amount_1);

    deposit_and_assert(context, owner, vault_id, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);
}

#[test]
#[should_panic(expected: 'ERC20: insufficient balance')]
fn invalid_balance_token1() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let (_, relay_contract) = get_btc_relay_with_txs(array![].span(), 1);
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 854845;
    let token_1_multiplier: felt252 = 434345;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let amount_0: u256 = raw_amount_0.into() * token_0_multiplier.into();
    let amount_1: u256 = raw_amount_1.into() * token_1_multiplier.into();

    create_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier);

    erc20::mint(context.token0, owner, amount_0);
    cheat_caller_address(context.token0.contract_address, owner, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, amount_0);
    
    erc20::mint(context.token1, owner, 8445);
    cheat_caller_address(context.token1.contract_address, owner, CheatSpan::TargetCalls(1));
    context.token1.approve(context.contract.contract_address, amount_1);

    deposit_and_assert(context, owner, vault_id, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);
}

#[test]
#[should_panic(expected: 'ERC20: insufficient allowance')]
fn invalid_allowance_token0() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let (_, relay_contract) = get_btc_relay_with_txs(array![].span(), 1);
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 854845;
    let token_1_multiplier: felt252 = 434345;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let amount_0: u256 = raw_amount_0.into() * token_0_multiplier.into();
    let amount_1: u256 = raw_amount_1.into() * token_1_multiplier.into();

    create_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier);

    erc20::mint(context.token0, owner, amount_0);
    cheat_caller_address(context.token0.contract_address, owner, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, 123);
    
    erc20::mint(context.token1, owner, amount_1);
    cheat_caller_address(context.token1.contract_address, owner, CheatSpan::TargetCalls(1));
    context.token1.approve(context.contract.contract_address, amount_1);

    deposit_and_assert(context, owner, vault_id, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);
}

#[test]
#[should_panic(expected: 'ERC20: insufficient allowance')]
fn invalid_allowance_token1() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let (_, relay_contract) = get_btc_relay_with_txs(array![].span(), 1);
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 854845;
    let token_1_multiplier: felt252 = 434345;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let amount_0: u256 = raw_amount_0.into() * token_0_multiplier.into();
    let amount_1: u256 = raw_amount_1.into() * token_1_multiplier.into();

    create_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier);

    erc20::mint(context.token0, owner, amount_0);
    cheat_caller_address(context.token0.contract_address, owner, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, amount_0);
    
    erc20::mint(context.token1, owner, amount_1);
    cheat_caller_address(context.token1.contract_address, owner, CheatSpan::TargetCalls(1));
    context.token1.approve(context.contract.contract_address, 4541);

    deposit_and_assert(context, owner, vault_id, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);
}
