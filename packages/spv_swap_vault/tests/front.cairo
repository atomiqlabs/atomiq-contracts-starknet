use starknet::contract_address::{ContractAddress, contract_address_const};

use openzeppelin_token::erc20::interface::{ERC20ABIDispatcherTrait};

use snforge_std::{
    cheat_caller_address, CheatSpan
};

use spv_swap_vault::structs::{BitcoinVaultTransactionDataImpl};
use spv_swap_vault::utils::{U32ArrayToU256ParserTrait};

use btc_utils::bitcoin_tx::BitcoinTransactionTrait;

use crate::utils::contract::{Context, get_context};
use crate::utils::btc_relay::get_btc_relay_with_txs;
use crate::utils::spv_vault::{get_funded_spv_vault, mint_and_front, front_and_assert};
use crate::utils::erc20;
use crate::utils::btc_tx::get_valid_tx;


#[test]
fn valid_front() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let (_, relay_contract) = get_btc_relay_with_txs(array![].span(), 1);
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let fronter = contract_address_const::<'fronter'>();
    let recipient = contract_address_const::<'recipient'>();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(448);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (_, btc_tx) = get_valid_tx(
        utxo, recipient.try_into().unwrap(), raw_withdraw_amount_0, raw_withdraw_amount_1, execution_hash,
        caller_fee_u20, fronting_fee_u20, execution_fee_u20,
        execution_expiry
    );

    mint_and_front(context, fronter, owner, vault_id, token_0_multiplier, token_1_multiplier, 0, @btc_tx);
}

#[test]
fn valid_front_only_token0() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let (_, relay_contract) = get_btc_relay_with_txs(array![].span(), 1);
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 5324;
    let token_1_multiplier: felt252 = 23532;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let fronter = contract_address_const::<'fronter'>();
    let recipient = contract_address_const::<'recipient'>();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::None;
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (_, btc_tx) = get_valid_tx(
        utxo, recipient.try_into().unwrap(), raw_withdraw_amount_0, raw_withdraw_amount_1, execution_hash,
        caller_fee_u20, fronting_fee_u20, execution_fee_u20,
        execution_expiry
    );

    mint_and_front(context, fronter, owner, vault_id, token_0_multiplier, token_1_multiplier, 0, @btc_tx);
}

#[test]
fn valid_front_exec_hash() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let (_, relay_contract) = get_btc_relay_with_txs(array![].span(), 1);
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 5124;
    let token_1_multiplier: felt252 = 6435;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let fronter = contract_address_const::<'fronter'>();
    let recipient = contract_address_const::<'recipient'>();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(448);
    let execution_hash: Option<felt252> = Option::Some(0x88666767c6767c76c67);
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (_, btc_tx) = get_valid_tx(
        utxo, recipient.try_into().unwrap(), raw_withdraw_amount_0, raw_withdraw_amount_1, execution_hash,
        caller_fee_u20, fronting_fee_u20, execution_fee_u20,
        execution_expiry
    );

    mint_and_front(context, fronter, owner, vault_id, token_0_multiplier, token_1_multiplier, 0, @btc_tx);
}

#[test]
fn valid_front_exec_hash_only_token0() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let (_, relay_contract) = get_btc_relay_with_txs(array![].span(), 1);
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 5214;
    let token_1_multiplier: felt252 = 6235;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let fronter = contract_address_const::<'fronter'>();
    let recipient = contract_address_const::<'recipient'>();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::None;
    let execution_hash: Option<felt252> = Option::Some(0x88666767c6767c76c67);
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (_, btc_tx) = get_valid_tx(
        utxo, recipient.try_into().unwrap(), raw_withdraw_amount_0, raw_withdraw_amount_1, execution_hash,
        caller_fee_u20, fronting_fee_u20, execution_fee_u20,
        execution_expiry
    );

    mint_and_front(context, fronter, owner, vault_id, token_0_multiplier, token_1_multiplier, 0, @btc_tx);
}

#[test]
#[should_panic(expected: 'front: vault closed')]
fn invalid_vault_not_opened() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let utxo: (u256, u32) = (1, 1);
    let token_0_multiplier: felt252 = 6325;
    let token_1_multiplier: felt252 = 23412;

    let fronter = contract_address_const::<'fronter'>();
    let recipient = contract_address_const::<'recipient'>();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(448);
    let execution_hash: Option<felt252> = Option::Some(0x88666767c6767c76c67);
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (_, btc_tx) = get_valid_tx(
        utxo, recipient.try_into().unwrap(), raw_withdraw_amount_0, raw_withdraw_amount_1, execution_hash,
        caller_fee_u20, fronting_fee_u20, execution_fee_u20,
        execution_expiry
    );

    mint_and_front(context, fronter, owner, vault_id, token_0_multiplier, token_1_multiplier, 0, @btc_tx);
}

#[test]
#[should_panic(expected: 'front: already fronted')]
fn invalid_front_already_fronted() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let (_, relay_contract) = get_btc_relay_with_txs(array![].span(), 1);
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 123121;
    let token_1_multiplier: felt252 = 5214;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let fronter = contract_address_const::<'fronter'>();
    let recipient = contract_address_const::<'recipient'>();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(448);
    let execution_hash: Option<felt252> = Option::Some(0x88666767c6767c76c67);
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (_, btc_tx) = get_valid_tx(
        utxo, recipient.try_into().unwrap(), raw_withdraw_amount_0, raw_withdraw_amount_1, execution_hash,
        caller_fee_u20, fronting_fee_u20, execution_fee_u20,
        execution_expiry
    );

    mint_and_front(context, fronter, owner, vault_id, token_0_multiplier, token_1_multiplier, 0, @btc_tx);
    mint_and_front(context, fronter, owner, vault_id, token_0_multiplier, token_1_multiplier, 0, @btc_tx);
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
    let token_0_multiplier: felt252 = 521412;
    let token_1_multiplier: felt252 = 12312;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let fronter = contract_address_const::<'fronter'>();
    let recipient = contract_address_const::<'recipient'>();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(448);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (_, btc_tx) = get_valid_tx(
        utxo, recipient.try_into().unwrap(), raw_withdraw_amount_0, raw_withdraw_amount_1, execution_hash,
        caller_fee_u20, fronting_fee_u20, execution_fee_u20,
        execution_expiry
    );

    let execution_handler_fee_amount_0: u128 = raw_withdraw_amount_0.into() * execution_fee_u20.into() / 100000;

    let amount_0: u256 = (raw_amount_0.into() + execution_handler_fee_amount_0.into()) * token_0_multiplier.into();
    let amount_1: u256 = raw_amount_1.into() * token_1_multiplier.into();

    erc20::mint(context.token0, fronter, 231);
    cheat_caller_address(context.token0.contract_address, fronter, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, amount_0);
    
    erc20::mint(context.token1, fronter, amount_1);
    cheat_caller_address(context.token1.contract_address, fronter, CheatSpan::TargetCalls(1));
    context.token1.approve(context.contract.contract_address, amount_1);

    let btc_tx_hash: u256 = btc_tx.get_hash().to_u256();
    let data = BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap();

    front_and_assert(context, fronter, owner, vault_id, token_0_multiplier, token_1_multiplier, 0, btc_tx_hash, data);
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
    let token_0_multiplier: felt252 = 521412;
    let token_1_multiplier: felt252 = 12312;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let fronter = contract_address_const::<'fronter'>();
    let recipient = contract_address_const::<'recipient'>();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(448);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (_, btc_tx) = get_valid_tx(
        utxo, recipient.try_into().unwrap(), raw_withdraw_amount_0, raw_withdraw_amount_1, execution_hash,
        caller_fee_u20, fronting_fee_u20, execution_fee_u20,
        execution_expiry
    );

    let execution_handler_fee_amount_0: u128 = raw_withdraw_amount_0.into() * execution_fee_u20.into() / 100000;

    let amount_0: u256 = (raw_amount_0.into() + execution_handler_fee_amount_0.into()) * token_0_multiplier.into();
    let amount_1: u256 = raw_amount_1.into() * token_1_multiplier.into();

    erc20::mint(context.token0, fronter, amount_0);
    cheat_caller_address(context.token0.contract_address, fronter, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, amount_0);
    
    erc20::mint(context.token1, fronter, 5445);
    cheat_caller_address(context.token1.contract_address, fronter, CheatSpan::TargetCalls(1));
    context.token1.approve(context.contract.contract_address, amount_1);

    let btc_tx_hash: u256 = btc_tx.get_hash().to_u256();
    let data = BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap();

    front_and_assert(context, fronter, owner, vault_id, token_0_multiplier, token_1_multiplier, 0, btc_tx_hash, data);
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
    let token_0_multiplier: felt252 = 521412;
    let token_1_multiplier: felt252 = 12312;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let fronter = contract_address_const::<'fronter'>();
    let recipient = contract_address_const::<'recipient'>();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(448);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (_, btc_tx) = get_valid_tx(
        utxo, recipient.try_into().unwrap(), raw_withdraw_amount_0, raw_withdraw_amount_1, execution_hash,
        caller_fee_u20, fronting_fee_u20, execution_fee_u20,
        execution_expiry
    );

    let execution_handler_fee_amount_0: u128 = raw_withdraw_amount_0.into() * execution_fee_u20.into() / 100000;

    let amount_0: u256 = (raw_amount_0.into() + execution_handler_fee_amount_0.into()) * token_0_multiplier.into();
    let amount_1: u256 = raw_amount_1.into() * token_1_multiplier.into();

    erc20::mint(context.token0, fronter, amount_0);
    cheat_caller_address(context.token0.contract_address, fronter, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, 231);
    
    erc20::mint(context.token1, fronter, amount_1);
    cheat_caller_address(context.token1.contract_address, fronter, CheatSpan::TargetCalls(1));
    context.token1.approve(context.contract.contract_address, amount_1);

    let btc_tx_hash: u256 = btc_tx.get_hash().to_u256();
    let data = BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap();

    front_and_assert(context, fronter, owner, vault_id, token_0_multiplier, token_1_multiplier, 0, btc_tx_hash, data);
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
    let token_0_multiplier: felt252 = 521412;
    let token_1_multiplier: felt252 = 12312;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let fronter = contract_address_const::<'fronter'>();
    let recipient = contract_address_const::<'recipient'>();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(448);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (_, btc_tx) = get_valid_tx(
        utxo, recipient.try_into().unwrap(), raw_withdraw_amount_0, raw_withdraw_amount_1, execution_hash,
        caller_fee_u20, fronting_fee_u20, execution_fee_u20,
        execution_expiry
    );

    let execution_handler_fee_amount_0: u128 = raw_withdraw_amount_0.into() * execution_fee_u20.into() / 100000;

    let amount_0: u256 = (raw_amount_0.into() + execution_handler_fee_amount_0.into()) * token_0_multiplier.into();
    let amount_1: u256 = raw_amount_1.into() * token_1_multiplier.into();

    erc20::mint(context.token0, fronter, amount_0);
    cheat_caller_address(context.token0.contract_address, fronter, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, amount_0);
    
    erc20::mint(context.token1, fronter, amount_1);
    cheat_caller_address(context.token1.contract_address, fronter, CheatSpan::TargetCalls(1));
    context.token1.approve(context.contract.contract_address, 5445);

    let btc_tx_hash: u256 = btc_tx.get_hash().to_u256();
    let data = BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap();

    front_and_assert(context, fronter, owner, vault_id, token_0_multiplier, token_1_multiplier, 0, btc_tx_hash, data);
}

