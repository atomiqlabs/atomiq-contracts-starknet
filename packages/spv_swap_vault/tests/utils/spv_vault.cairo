use starknet::SyscallResultTrait;
use spv_swap_vault::{ISpvVaultManagerReadOnlyDispatcherTrait, ISpvVaultManagerSafeDispatcherTrait, SpvVaultManager};
use spv_swap_vault::state::SpvVaultState;
use spv_swap_vault::events;
use spv_swap_vault::structs::{BitcoinVaultTransactionData, BitcoinVaultTransactionDataImpl, BitcoinVaultTransactionDataTrait};
use spv_swap_vault::utils::{U32ArrayToU256ParserTrait};

use btc_utils::bitcoin_tx::{BitcoinTransaction, BitcoinTransactionTrait};

use snforge_std::{
    cheat_caller_address, CheatSpan, spy_events, EventSpyAssertionsTrait
};

use starknet::contract_address::{ContractAddress};

use crate::utils::contract::{Context};
use crate::utils::erc20;

use openzeppelin_token::erc20::interface::{ERC20ABIDispatcherTrait};

pub fn create_spv_vault(
    context: Context,
    owner: ContractAddress,
    vault_id: felt252,
    relay_contract: ContractAddress,
    utxo: (u256, u32),
    confirmations: u8,
    token_0_multiplier: felt252,
    token_1_multiplier: felt252
) {
    let mut spy = spy_events();

    cheat_caller_address(context.contract.contract_address, owner, CheatSpan::TargetCalls(1));
    let result = context.contract.open(vault_id, relay_contract, utxo, confirmations, context.token0.contract_address, context.token1.contract_address, token_0_multiplier, token_1_multiplier);

    if result.is_err() {
        panic(result.unwrap_err());
    }

    let (btc_tx_hash, vout) = utxo;
    //Assert event emitted
    spy.assert_emitted(
        @array![(context.contract.contract_address, SpvVaultManager::Event::Opened(events::Opened {
            btc_tx_hash: btc_tx_hash,
            owner: owner,
            vault_id: vault_id,
            vout: vout
        }))]
    );

    //Asert state saved
    assert_eq!(context.contract_read.get_vault(owner, vault_id), SpvVaultState {
        relay_contract: relay_contract,
        token_0: context.token0.contract_address,
        token_1: context.token1.contract_address,
        token_0_multiplier: token_0_multiplier,
        token_1_multiplier: token_1_multiplier,
        utxo: utxo,
        confirmations: confirmations,
        withdraw_count: 0,
        token_0_amount: 0,
        token_1_amount: 0
    });
}

pub fn get_funded_spv_vault(
    context: Context,
    owner: ContractAddress,
    vault_id: felt252,
    relay_contract: ContractAddress,
    utxo: (u256, u32),
    confirmations: u8,
    token_0_multiplier: felt252,
    token_1_multiplier: felt252,
    raw_amount_0: u64,
    raw_amount_1: u64
) {
    create_spv_vault(context, owner, vault_id, relay_contract, utxo, confirmations, token_0_multiplier, token_1_multiplier);

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

pub fn deposit_and_assert(
    context: Context,
    owner: ContractAddress,
    vault_id: felt252,
    token_0_multiplier: felt252,
    token_1_multiplier: felt252,
    raw_amount_0: u64,
    raw_amount_1: u64
) {
    let mut spy = spy_events();

    let balance_token0_owner = context.token0.balance_of(owner);
    let balance_token0_contract = context.token0.balance_of(context.contract.contract_address);

    let balance_token1_owner = context.token1.balance_of(owner);
    let balance_token1_contract = context.token1.balance_of(context.contract.contract_address);

    let mut prev_state = context.contract_read.get_vault(owner, vault_id);

    cheat_caller_address(context.contract.contract_address, owner, CheatSpan::TargetCalls(1));
    context.contract.deposit(owner, vault_id, raw_amount_0, raw_amount_1).unwrap_syscall();

    prev_state.token_0_amount += raw_amount_0;
    prev_state.token_1_amount += raw_amount_1;

    //Assert event emitted
    spy.assert_emitted(
        @array![(context.contract.contract_address, SpvVaultManager::Event::Deposited(events::Deposited {
            owner: owner,
            vault_id: vault_id,
            amounts: (raw_amount_0, raw_amount_1)
        }))]
    );

    //Asert state saved
    assert_eq!(context.contract_read.get_vault(owner, vault_id), prev_state);

    let amount_0: u256 = raw_amount_0.into() * token_0_multiplier.into();
    let amount_1: u256 = raw_amount_1.into() * token_1_multiplier.into();

    assert_eq!(balance_token0_owner - amount_0, context.token0.balance_of(owner));
    assert_eq!(balance_token1_owner - amount_1, context.token1.balance_of(owner));

    assert_eq!(balance_token0_contract + amount_0, context.token0.balance_of(context.contract.contract_address));
    assert_eq!(balance_token1_contract + amount_1, context.token1.balance_of(context.contract.contract_address));
}

pub fn mint_and_front(
    context: Context,
    fronter: ContractAddress,
    owner: ContractAddress,
    vault_id: felt252,
    token_0_multiplier: felt252,
    token_1_multiplier: felt252,
    withdraw_sequence: u32,
    btc_tx: @BitcoinTransaction
) {
    let btc_tx_hash: u256 = btc_tx.get_hash().to_u256();
    let data = BitcoinVaultTransactionDataImpl::from_tx(btc_tx).unwrap();

    let (raw_amount_0, raw_amount_1) = data.amount;

    let amount_0: u256 = (raw_amount_0.into() + data.execution_handler_fee_amount_0.into()) * token_0_multiplier.into();
    let amount_1: u256 = raw_amount_1.into() * token_1_multiplier.into();

    erc20::mint(context.token0, fronter, amount_0);
    cheat_caller_address(context.token0.contract_address, fronter, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, amount_0);
    
    erc20::mint(context.token1, fronter, amount_1);
    cheat_caller_address(context.token1.contract_address, fronter, CheatSpan::TargetCalls(1));
    context.token1.approve(context.contract.contract_address, amount_1);

    front_and_assert(
        context,
        fronter,
        owner,
        vault_id,
        token_0_multiplier,
        token_1_multiplier,
        withdraw_sequence,
        btc_tx_hash,
        data
    );
}

pub fn front_and_assert(
    context: Context,
    fronter: ContractAddress,
    owner: ContractAddress,
    vault_id: felt252,
    token_0_multiplier: felt252,
    token_1_multiplier: felt252,
    withdraw_sequence: u32,
    btc_tx_hash: u256,
    data: BitcoinVaultTransactionData
) {
    let mut spy = spy_events();

    let balance_token0_fronter = context.token0.balance_of(fronter);
    let balance_token0_recipient = context.token0.balance_of(data.recipient);
    let balance_token0_execution_contract = context.token0.balance_of(context.execution_contract);

    let balance_token1_fronter = context.token1.balance_of(fronter);
    let balance_token1_recipient = context.token1.balance_of(data.recipient);

    let (raw_amount_0, raw_amount_1) = data.amount;

    cheat_caller_address(context.contract.contract_address, fronter, CheatSpan::TargetCalls(1));
    context.contract.front(owner, vault_id, withdraw_sequence, btc_tx_hash, data).unwrap_syscall();

    //Assert event emitted
    spy.assert_emitted(
        @array![(context.contract.contract_address, SpvVaultManager::Event::Fronted(events::Fronted {
            btc_tx_hash: btc_tx_hash,
            owner: owner,
            vault_id: vault_id,
            recipient: data.recipient,
            execution_hash: data.execution_hash,
            caller: fronter,
            amounts: (raw_amount_0 + data.execution_handler_fee_amount_0, raw_amount_1)
        }))]
    );

    let fronting_id = data.get_hash(btc_tx_hash);

    //Asert state saved
    assert_eq!(context.contract_read.get_fronter_address(owner, vault_id, btc_tx_hash, data), fronter);
    assert_eq!(context.contract_read.get_fronter_address_by_id(owner, vault_id, fronting_id), fronter);

    if data.execution_hash == 0 {
        //Assert tokens sent
        let amount_0: u256 = (raw_amount_0.into() + data.execution_handler_fee_amount_0.into()) * token_0_multiplier.into();
        let amount_1: u256 = raw_amount_1.into() * token_1_multiplier.into();

        assert_eq!(balance_token0_fronter - amount_0, context.token0.balance_of(fronter));
        assert_eq!(balance_token1_fronter - amount_1, context.token1.balance_of(fronter));

        assert_eq!(balance_token0_recipient + amount_0, context.token0.balance_of(data.recipient));
        assert_eq!(balance_token1_recipient + amount_1, context.token1.balance_of(data.recipient));
    } else {
        let amount_0: u256 = (raw_amount_0.into() + data.execution_handler_fee_amount_0.into()) * token_0_multiplier.into();
        let amount_1: u256 = raw_amount_1.into() * token_1_multiplier.into();

        assert_eq!(balance_token0_fronter - amount_0, context.token0.balance_of(fronter));
        assert_eq!(balance_token1_fronter - amount_1, context.token1.balance_of(fronter));

        assert_eq!(balance_token0_execution_contract + amount_0, context.token0.balance_of(context.execution_contract));
        assert_eq!(balance_token1_recipient + amount_1, context.token1.balance_of(data.recipient));
    }
}
