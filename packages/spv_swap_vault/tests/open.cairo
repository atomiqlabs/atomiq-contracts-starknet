use starknet::contract_address::{ContractAddress, contract_address_const};

use crate::utils::contract::{Context, get_context};
use crate::utils::btc_relay::get_btc_relay_with_txs;
use crate::utils::spv_vault::create_spv_vault;

#[test]
fn valid_create() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let (_, relay_contract) = get_btc_relay_with_txs(array![].span(), 1);
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 1;
    let token_1_multiplier: felt252 = 1;

    create_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier);
}

#[test]
#[should_panic(expected: 'open: already opened')]
fn invalid_already_opened() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let (_, relay_contract) = get_btc_relay_with_txs(array![].span(), 1);
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 1;
    let token_1_multiplier: felt252 = 1;

    create_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier);
    create_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier);
}

#[test]
#[should_panic(expected: 'utxo is zero')]
fn invalid_zero_utxo() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let (_, relay_contract) = get_btc_relay_with_txs(array![].span(), 1);
    let utxo: (u256, u32) = (0, 0);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 1;
    let token_1_multiplier: felt252 = 1;

    create_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier);
}
