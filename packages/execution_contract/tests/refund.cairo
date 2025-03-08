use execution_contract::{IExecutionContractSafeDispatcherTrait, ExecutionContract, IExecutionContractReadOnlyDispatcherTrait};
use execution_contract::structs::ContractCall;
use execution_contract::state::Execution;
use execution_contract::events;
use execution_contract::utils::SpanHashImpl;

use core::hash::{HashStateTrait, HashStateExTrait};
use core::poseidon::PoseidonTrait;

use snforge_std::{
    cheat_caller_address, CheatSpan, spy_events, EventSpyAssertionsTrait, cheat_block_timestamp
};

use starknet::contract_address::{ContractAddress, contract_address_const};

use openzeppelin_token::erc20::ERC20ABIDispatcherTrait;

use crate::utils::contract::{Context, get_context};
use crate::utils::execution::create_execution;

fn refund_and_assert(
    context: Context,
    owner: ContractAddress,
    amount: u256,
    fee: u256,
    salt: felt252,
    calls: Span<ContractCall>,
    drain_tokens: Span<ContractAddress>,
    clear_all: bool,
    current_time: u64
) {
    let execution_hash = PoseidonTrait::new().update_with(calls).update_with(drain_tokens).finalize();

    let balance_erc20_owner = context.token0.balance_of(owner);
    let balance_erc20_contract = context.token0.balance_of(context.contract.contract_address);

    let mut spy = spy_events();

    cheat_caller_address(context.contract.contract_address, owner, CheatSpan::TargetCalls(1));
    cheat_block_timestamp(context.contract.contract_address, current_time, CheatSpan::TargetCalls(1));
    let result = context.contract.refund(salt, clear_all);
    if result.is_err() {
        panic(result.unwrap_err());
    }

    //Assert event emitted
    spy.assert_emitted(
        @array![(context.contract.contract_address, ExecutionContract::Event::ExecutionProcessed(events::ExecutionProcessed {
            owner: owner,
            salt: salt,
            execution_hash: execution_hash,
            error: array![].span(),
            success: false
        }))]
    );

    //Asert state saved
    if clear_all {
        assert_eq!(context.contract_read.get_execution(owner, salt), Execution {
            token: 0.try_into().unwrap(),
            execution_hash: 0,
            amount: 0,
            execution_fee: 0,
            expiry: 0
        });
    } else {
        assert_eq!(context.contract_read.get_execution(owner, salt).execution_hash, 0);
    }

    //Assert tokens transfered
    assert_eq!(balance_erc20_owner + amount + fee, context.token0.balance_of(owner));
    assert_eq!(balance_erc20_contract - amount - fee, context.token0.balance_of(context.contract.contract_address));
}

//Valid refund, already expired
#[test]
fn valid_refund_expired() {
    let context = get_context();

    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    let salt = 0;
    let expiry = 10;
    let current_timestamp = 1000;
    
    let calls: Span<ContractCall> = array![].span();
    let drain_tokens: Span<ContractAddress> = array![].span();

    create_execution(context, owner, amount, fee, expiry, salt, calls, drain_tokens);
    refund_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, false, current_timestamp);
    
    create_execution(context, owner, amount, fee, expiry, salt, calls, drain_tokens);
    refund_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, true, current_timestamp);
}

//Valid refund, not expired, but owner can refund at any time
#[test]
fn valid_refund_not_expired() {
    let context = get_context();

    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    let salt = 0;
    let expiry = 10000;
    let current_timestamp = 0;
    
    let calls: Span<ContractCall> = array![].span();
    let drain_tokens: Span<ContractAddress> = array![].span();

    create_execution(context, owner, amount, fee, expiry, salt, calls, drain_tokens);
    refund_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, false, current_timestamp);
    
    create_execution(context, owner, amount, fee, expiry, salt, calls, drain_tokens);
    refund_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, true, current_timestamp);
}

//Invalid refund, execution not created
#[test]
#[should_panic(expected: 'refund: Already processed')]
fn invalid_not_initiated() {
    let context = get_context();

    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    let salt = 0;
    let _expiry = 10;
    let current_timestamp = 1000;
    
    let calls: Span<ContractCall> = array![].span();
    let drain_tokens: Span<ContractAddress> = array![].span();

    refund_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, false, current_timestamp);
}

//Invalid refund, execution already processed
#[test]
#[should_panic(expected: 'refund: Already processed')]
fn invalid_already_processed() {
    let context = get_context();

    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    let salt = 0;
    let expiry = 10;
    let current_timestamp = 1000;
    
    let calls: Span<ContractCall> = array![].span();
    let drain_tokens: Span<ContractAddress> = array![].span();

    create_execution(context, owner, amount, fee, expiry, salt, calls, drain_tokens);
    refund_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, false, current_timestamp);
    refund_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, false, current_timestamp);
}
