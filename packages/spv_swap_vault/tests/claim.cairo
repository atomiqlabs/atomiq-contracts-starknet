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
use crate::utils::spv_vault::{get_funded_spv_vault, mint_and_front, front_and_assert, claim_and_assert};
use crate::utils::erc20;
use crate::utils::btc_tx::get_valid_tx;

#[test]
fn valid_claim() {
    let context: Context = get_context();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    let vault_id: felt252 = 0;
    let utxo: (u256, u32) = (1, 1);
    let confirmations: u8 = 3;
    let token_0_multiplier: felt252 = 643523;
    let token_1_multiplier: felt252 = 5322;
    let raw_amount_0: u64 = 123123;
    let raw_amount_1: u64 = 4848;

    let fronter = contract_address_const::<'fronter'>();
    let recipient = contract_address_const::<'recipient'>();
    let raw_withdraw_amount_0: u64 = 48485;
    let raw_withdraw_amount_1: Option<u64> = Option::Some(448);
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

    let res = claim_and_assert(context, fronter, owner, recipient, vault_id, token_0_multiplier, token_1_multiplier, @raw_tx, blockheader, array![].span(), 0, 0);
    if res.is_err() {
        panic(array![res.unwrap_err()]);
    }
}
