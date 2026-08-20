use spv_swap_vault::utils::U32ArrayToU256ParserTrait;
use starknet::contract_address::ContractAddress;

use spv_swap_vault::structs::{BitcoinVaultTransactionDataImpl, BitcoinVaultTransactionData};
use spv_swap_vault::ISpvVaultManagerSafeDispatcherTrait;

use btc_utils::bitcoin_tx::BitcoinTransactionTrait;

use crate::utils::contract::{Context, get_context};
use crate::utils::btc_relay::{get_btc_relay_with_txs, deploy_malicious_btc_relay};
use crate::utils::spv_vault::{get_funded_spv_vault, mint_and_front, claim_and_assert, front_and_assert};
use crate::utils::btc_tx::{get_valid_tx, get_btc_tx};

fn test_create_and_claim(
    context: Context,
    vault_id: felt252,
    raw_withdraw_amount_1: Option<u64>,
    execution_hash: Option<felt252>,
    front: bool
) {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter: ContractAddress = if front {
        'fronter'.try_into().unwrap()
    } else {
        0.try_into().unwrap()
    };
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 48485;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.try_into().unwrap(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);

    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    if front {
        mint_and_front(context, fronter, owner, vault_id, token_0_multiplier, token_1_multiplier, 0, @btc_tx);
    }

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 0);
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn valid_claim() {
    let context: Context = get_context();
    //Try with all possible combinations
    test_create_and_claim(context, 0, Option::Some(2343), Option::None, false);
    test_create_and_claim(context, 1, Option::None, Option::None, false);
    test_create_and_claim(context, 2, Option::Some(2343), Option::Some(0x82148391872437bc88d67e679af6d9), false);
    test_create_and_claim(context, 3, Option::None, Option::Some(0x82148391872437bc88d67e679af6d9), false);
}

#[test]
fn valid_claim_fronted() {
    let context: Context = get_context();
    //Try with all possible combinations
    test_create_and_claim(context, 0, Option::Some(2343), Option::None, true);
    test_create_and_claim(context, 1, Option::None, Option::None, true);
    test_create_and_claim(context, 2, Option::Some(2343), Option::Some(0x82148391872437bc88d67e679af6d9), true);
    test_create_and_claim(context, 3, Option::None, Option::Some(0x82148391872437bc88d67e679af6d9), true);
}

#[test]
#[should_panic(expected: 'claim: vault closed')]
fn invalid_closed_vault() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(1232);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.try_into().unwrap(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    //Don't open the vault
    let (blockheader, _) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    // get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 0);
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
#[should_panic(expected: 'claim: empty inputs')]
fn invalid_btc_tx_empty_inputs() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();

    let (raw_tx, btc_tx) = get_btc_tx((0, 0), array![], array!["\x6a", "\x6a"], 132831812);

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 0);
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
#[should_panic(expected: 'claim: incorrect in_0 utxo')]
fn invalid_btc_tx_in_0_utxo() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    //Correct utxo
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(1232);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        (0, 0), //Pass incorrect UTXO to tx generator
        recipient.try_into().unwrap(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 0);
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
#[should_panic(expected: 'merkle_tree: verify failed')]
fn invalid_btc_tx_merkle_proof() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(1232);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.try_into().unwrap(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    //Use arbitrary merkle path and position
    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![
        [1, 2, 3, 4, 5, 6, 7, 8],
        [0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff]
    ].span(), 2, 0);
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
#[should_panic(expected: 'claim: confirmations')]
fn invalid_btc_tx_confirmations() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    //Required number of confirmations set to 3
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(1232);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.try_into().unwrap(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    //Initialize BTC relay such that the block only has 2 confirmations yet
    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 2);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 0);
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_btc_output_1_not_found() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();

    let (raw_tx, btc_tx) = get_btc_tx(
        (1, 1),
        array![1, 2],
        array!["\x6a"], //Only single output
        132831812
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'tx_data: output 1 not found');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_btc_output_1_empty_script() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();

    let (raw_tx, btc_tx) = get_btc_tx((1, 1), array![1, 2], array![
        "\x6a",
        "" //Output 1 empty script
    ], 132831812);

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'tx_data: output 1 empty script');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_btc_output_1_not_opreturn() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();

    let (raw_tx, btc_tx) = get_btc_tx((1, 1), array![1, 2], array![
        "\x6a",
        "\x65" //Output 1 not OP_RETURN (0x6a op code)
    ], 132831812);

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'tx_data: output 1 not OP_RETURN');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_btc_input_1_notfound() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();

    let (raw_tx, btc_tx) = get_btc_tx(
        (1, 1), 
        array![1], //Only single input
        array!["\x6a", "\x6a"],
        132831812
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'tx_data: input 1 not found');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_btc_output_1_length() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();

    let (raw_tx, btc_tx) = get_btc_tx((1, 1), array![1, 2], array![
        "\x6a",
        "\x6a\x04\x0c\x4d\x4f\x1d" //Output 1 with invalid length
    ], 132831812);

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'tx_data: output 1 invalid len');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_btc_invalid_recipient() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(1232);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        0x08000000000000000000000000000000000000000000000000000000000000ff, //Recipient is out of range of addresses (< 2^251 - 1)
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'tx_data: invalid recipient');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_caller_fee_0_overflow() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 0xFFFFFFFFFFFFFFFF; //Use maximum value for withdrawal
    let raw_withdraw_amount_1: Option<u64> = Option::Some(1232);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 1000000; //Make sure the caller fee is 1000% of the withdraw amount
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.into(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'tx_data: caller fee 0');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_fronting_fee_0_overflow() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 0xFFFFFFFFFFFFFFFF; //Use maximum value for withdrawal
    let raw_withdraw_amount_1: Option<u64> = Option::Some(1232);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 1024;
    let fronting_fee_u20 = 1000000; //Make sure the fronting fee is 1000% of the withdraw amount
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.into(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'tx_data: fronting fee 0');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_execution_fee_0_overflow() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 0xFFFFFFFFFFFFFFFF; //Use maximum value for withdrawal
    let raw_withdraw_amount_1: Option<u64> = Option::Some(1232);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 1024;
    let fronting_fee_u20 = 231; 
    let execution_fee_u20 = 1000000; //Make sure the execution fee is 1000% of the withdraw amount
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.into(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'tx_data: execution fee 0');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_caller_fee_1_overflow() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 123132; 
    let raw_withdraw_amount_1: Option<u64> = Option::Some(0xFFFFFFFFFFFFFFFF); //Use maximum value for withdrawal
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 1000000; //Make sure the caller fee is 1000% of the withdraw amount
    let fronting_fee_u20 = 231; 
    let execution_fee_u20 = 3213;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.into(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'tx_data: caller fee 1');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_fronting_fee_1_overflow() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 123132; 
    let raw_withdraw_amount_1: Option<u64> = Option::Some(0xFFFFFFFFFFFFFFFF); //Use maximum value for withdrawal
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1000000; //Make sure the caller fee is 1000% of the withdraw amount
    let execution_fee_u20 = 3213;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.into(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'tx_data: fronting fee 1');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_amounts_overflow_0_0() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 0x9FFFFFFFFFFFFFFF; //Use high amount for withdrawal
    let raw_withdraw_amount_1: Option<u64> = Option::Some(1232);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 112845; //Make sure the caller fee is 112% of the initial amount, such that when it's summed up it overflows u64
    let fronting_fee_u20 = 584;
    let execution_fee_u20 = 3213;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.into(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'get_full_amts: amt0-0');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_amounts_overflow_0_1() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 0x9FFFFFFFFFFFFFFF; //Use high amount for withdrawal
    let raw_withdraw_amount_1: Option<u64> = Option::Some(1232);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 451; 
    let fronting_fee_u20 = 152415; //Make sure the caller fee is 152% of the initial amount, such that when it's summed up it overflows u64
    let execution_fee_u20 = 3213;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.into(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'get_full_amts: amt0-1');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_amounts_overflow_0_2() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 0x9FFFFFFFFFFFFFFF; //Use high amount for withdrawal
    let raw_withdraw_amount_1: Option<u64> = Option::Some(1232);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 451; 
    let fronting_fee_u20 = 6525;
    let execution_fee_u20 = 134824; //Make sure the caller fee is 134% of the initial amount, such that when it's summed up it overflows u64
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.into(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'get_full_amts: amt0-2');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_amounts_overflow_1_0() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 231234; 
    let raw_withdraw_amount_1: Option<u64> = Option::Some(0x9FFFFFFFFFFFFFFF); //Use high amount for withdrawal
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 112845; //Make sure the caller fee is 112% of the initial amount, such that when it's summed up it overflows u64
    let fronting_fee_u20 = 584;
    let execution_fee_u20 = 3213;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.into(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);
    
    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'get_full_amts: amt1-0');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_amounts_overflow_1_1() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 231234; 
    let raw_withdraw_amount_1: Option<u64> = Option::Some(0x9FFFFFFFFFFFFFFF); //Use high amount for withdrawal
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 451; 
    let fronting_fee_u20 = 152415; //Make sure the caller fee is 152% of the initial amount, such that when it's summed up it overflows u64
    let execution_fee_u20 = 3213;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.into(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'get_full_amts: amt1-1');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_withdraw_too_much_token0() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 845414; //Use higher amount thant what is in the vault
    let raw_withdraw_amount_1: Option<u64> = Option::Some(1213);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 451; 
    let fronting_fee_u20 = 4245;
    let execution_fee_u20 = 3213;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.into(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'withdraw: amount 0');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

#[test]
fn close_withdraw_too_much_token1() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = 0.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 5342;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(634523523); //Use higher amount than what is in the vault
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 451; 
    let fronting_fee_u20 = 4245;
    let execution_fee_u20 = 3213;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.into(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 'withdraw: amount 1');
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}

//Possible exploit on spv swap vault by using a malicious btc relay contract which reenter the claim() when the
// verify_header() is called on it
#[test]
#[feature("safe_dispatcher")]
fn exploit_reentrant_claim_from_btc_relay() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let vault_id = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(1232);
    let execution_hash: Option<felt252> = Option::None;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.into(),
        raw_withdraw_amount_0,
        raw_withdraw_amount_1,
        execution_hash,
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );

    let (blockheader, _) = get_btc_relay_with_txs(array![btc_tx.get_hash()].span(), 3);
    let relay_contract = deploy_malicious_btc_relay(
        context.contract.contract_address,
        owner,
        vault_id,
        raw_tx.clone()
    );
    get_funded_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let res = context.contract.claim(owner, vault_id, raw_tx.clone(), blockheader, array![].span(), 0);

    assert!(res.is_err(), "Reentrancy successful!");
    assert_eq!(*res.unwrap_err()[0], 'ReentrancyGuard: reentrant call');
}

//Possible exploit on the spv vault, where a malicious fronter pre-occupies the execution contract's slot
// of the actual genuine withdrawal request. This is possible because the front() function doesn't check
// whether the provided btc tx hash is correct or not, but instead just takes the provided withdrawal data
// from the fronter, this is fine for the sake of fronting, as the withdrawal data are hashed, but
// for execution salt, only the btc tx hash is taken into account.
#[test]
fn exploit_malicous_claim_execution_fronting() {
    let context: Context = get_context();
    let owner: ContractAddress = 'owner'.try_into().unwrap();
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter: ContractAddress = 'fronter'.try_into().unwrap();
    let recipient: ContractAddress = 'recipient'.try_into().unwrap();
    let raw_withdraw_amount_0: u64 = 48485;
    let caller_fee_u20 = 2312;
    let fronting_fee_u20 = 1245;
    let execution_fee_u20 = 4484;
    let execution_expiry = 1501454187;

    let execution_hash = 0x1429125823328589345340;

    let (raw_tx, btc_tx) = get_valid_tx(
        utxo,
        recipient.try_into().unwrap(),
        raw_withdraw_amount_0,
        Option::None,
        Option::Some(execution_hash),
        caller_fee_u20,
        fronting_fee_u20,
        execution_fee_u20,
        execution_expiry
    );
    let btc_tx_hash = btc_tx.get_hash();

    let (blockheader, relay_contract) = get_btc_relay_with_txs(array![btc_tx_hash].span(), 3);

    get_funded_spv_vault(context, owner, 0, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier, raw_amount_0, raw_amount_1);

    let malicious_tx_data_for_fronting = BitcoinVaultTransactionData {
        recipient: recipient,
        amount: (0, 0),
        caller_fee: (0, 0),
        fronting_fee: (0, 0),
        execution_handler_fee_amount_0: 0,
        execution_hash: 0x1, //This might use a different execution hash even
        execution_expiry: 100
    };
    
    //Front with the malicious data, which still includes the same execution_hash
    front_and_assert(context, fronter, owner, 0, token_0_multiplier, token_1_multiplier, 0, btc_tx_hash.to_u256(), malicious_tx_data_for_fronting);

    //Now the claim should fail! Effectively blocking the vault forever
    let res = claim_and_assert(context, 0.try_into().unwrap(), owner, recipient, 0, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 0);

    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}
