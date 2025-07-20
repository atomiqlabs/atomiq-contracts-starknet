use execution_contract::{IExecutionContractSafeDispatcherTrait, ExecutionContract, IExecutionContractReadOnlyDispatcherTrait};
use execution_contract::structs::ContractCall;
use execution_contract::state::Execution;
use execution_contract::events;
use execution_contract::utils::SpanHashImpl;

use core::hash::{HashStateTrait, HashStateExTrait};
use core::poseidon::PoseidonTrait;

use snforge_std::{
    cheat_caller_address, CheatSpan, spy_events, EventSpyAssertionsTrait, EventSpy
};

use starknet::contract_address::{ContractAddress, contract_address_const};

use openzeppelin_token::erc20::ERC20ABIDispatcherTrait;

use crate::utils::contract::{Context, get_context};
use crate::utils::execution::create_execution;
use crate::contracts::test_contract::{TestContract, TestEvent};
use crate::utils::erc20;

fn execute_and_assert(
    context: Context,
    owner: ContractAddress,
    amount: u256,
    fee: u256,
    salt: felt252,
    calls: Span<ContractCall>,
    drain_tokens: Span<ContractAddress>,
    clear_all: bool,
    expected_error: Span<felt252>,
    expected_success: bool
) -> EventSpy {
    let executor = contract_address_const::<'executor'>();
    let execution_hash = PoseidonTrait::new().update_with(calls).update_with(drain_tokens).finalize();

    let balance_erc20_executor = context.token0.balance_of(executor);
    let balance_erc20_owner = context.token0.balance_of(owner);
    let balance_erc20_contract = context.token0.balance_of(context.contract.contract_address);

    let mut spy = spy_events();

    cheat_caller_address(context.contract.contract_address, executor, CheatSpan::TargetCalls(1));
    let result = context.contract.execute(owner, salt, calls, drain_tokens, clear_all);
    if result.is_err() {
        panic(result.unwrap_err());
    }

    //Assert event emitted
    spy.assert_emitted(
        @array![(context.contract.contract_address, ExecutionContract::Event::ExecutionProcessed(events::ExecutionProcessed {
            owner: owner,
            salt: salt,
            execution_hash: execution_hash,
            error: expected_error,
            success: expected_success
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
    assert_eq!(balance_erc20_executor + fee, context.token0.balance_of(executor));
    assert_eq!(balance_erc20_owner + amount, context.token0.balance_of(owner));
    assert_eq!(balance_erc20_contract - amount - fee, context.token0.balance_of(context.contract.contract_address));

    spy
}

//Valid execute call, with no calls
#[test]
fn valid_execute_empty() {
    let context = get_context();

    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    let creator_salt = 0;
    
    let calls: Span<ContractCall> = array![].span();
    let drain_tokens: Span<ContractAddress> = array![].span();

    let salt = create_execution(context, owner, amount, fee, 10, creator_salt, calls, drain_tokens);
    execute_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, false, array![].span(), true);
    
    let salt = create_execution(context, owner, amount, fee, 10, creator_salt, calls, drain_tokens);
    execute_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, true, array![].span(), true);
}

//Valid execute call, calling test contract, which emits an event
#[test]
fn valid_execute_test_contract() {
    let context = get_context();

    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    let creator_salt = 0;
    
    let event_data = 0123481284124123412213123;
    let calls: Span<ContractCall> = array![ContractCall {
        address: context.test_contract,
        entrypoint: selector!("event"),
        calldata: array![event_data].span()
    }].span();
    let drain_tokens: Span<ContractAddress> = array![].span();

    let salt = create_execution(context, owner, amount, fee, 10, creator_salt, calls, drain_tokens);
    let mut spy = execute_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, false, array![].span(), true);

    //Assert test event emitted
    spy.assert_emitted(
        @array![(context.test_contract, TestContract::Event::TestEvent(TestEvent {
            data: event_data
        }))]
    );
}

//Valid execute call, calling test contract, which emits an event,
// also tests the draining function of the execution proxy
#[test]
fn valid_execute_test_contract_drain() {
    let context = get_context();

    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    let creator_salt = 0;
    
    let event_data = 0123481284124123412213123;
    let calls: Span<ContractCall> = array![ContractCall {
        address: context.test_contract,
        entrypoint: selector!("event"),
        calldata: array![event_data].span()
    }].span();
    let drain_tokens: Span<ContractAddress> = array![context.token1.contract_address].span();

    //Mint some tokens straight to the execution proxy
    erc20::mint(context.token1, context.execution_proxy, 1000);

    let salt = create_execution(context, owner, amount, fee, 10, creator_salt, calls, drain_tokens);
    let mut spy = execute_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, false, array![].span(), true);

    //Make sure tokens were drained back to owner
    assert_eq!(context.token1.balance_of(owner), 1000);

    //Assert test event emitted
    spy.assert_emitted(
        @array![(context.test_contract, TestContract::Event::TestEvent(TestEvent {
            data: event_data
        }))]
    );
}

//Valid execute call, calling test contract, which should panic and therefore emit event with success=false
//IMPORTANT NOTE: This test doesn't work because snforge doesn't properly handle SafeDispatcher (try-catch) logic
#[test]
fn valid_execute_panic_test_contract() {
    let context = get_context();

    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    let creator_salt = 0;
    
    let panic_err = 'panic here!';
    let calls: Span<ContractCall> = array![ContractCall {
        address: context.test_contract,
        entrypoint: selector!("panic"),
        calldata: array![panic_err].span()
    }].span();
    let drain_tokens: Span<ContractAddress> = array![].span();

    let salt = create_execution(context, owner, amount, fee, 10, creator_salt, calls, drain_tokens);
    execute_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, false, array![panic_err, 'ENTRYPOINT_FAILED', 'ENTRYPOINT_FAILED'].span(), false);
}

//Invalid execute call, execution not created
#[test]
#[should_panic(expected: 'execute: Already processed')]
fn invalid_not_initiated() {
    let context = get_context();

    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    let salt = 0;
    
    let calls: Span<ContractCall> = array![].span();
    let drain_tokens: Span<ContractAddress> = array![].span();

    execute_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, false, array![].span(), true);
}

//Invalid execute call, execution already processed
#[test]
#[should_panic(expected: 'execute: Already processed')]
fn invalid_already_processed() {
    let context = get_context();

    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    let creator_salt = 0;
    
    let calls: Span<ContractCall> = array![].span();
    let drain_tokens: Span<ContractAddress> = array![].span();

    let salt = create_execution(context, owner, amount, fee, 10, creator_salt, calls, drain_tokens);
    execute_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, false, array![].span(), true);
    execute_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, false, array![].span(), true);
}

//Invalid execute call, invalid drain_tokens param passed (different than the execution hash)
#[test]
#[should_panic(expected: 'execute: Invalid calls/tokens')]
fn invalid_drain_tokens() {
    let context = get_context();

    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    let creator_salt = 0;
    
    let calls: Span<ContractCall> = array![].span();
    let drain_tokens: Span<ContractAddress> = array![].span();

    let salt = create_execution(context, owner, amount, fee, 10, creator_salt, calls, drain_tokens);

    let calls: Span<ContractCall> = array![].span();
    let drain_tokens: Span<ContractAddress> = array![12312.try_into().unwrap()].span();

    execute_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, false, array![].span(), true);
}

//Invalid execute call, invalid calls param passed (different than the execution hash)
#[test]
#[should_panic(expected: 'execute: Invalid calls/tokens')]
fn invalid_calls() {
    let context = get_context();

    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    let creator_salt = 0;
    
    let calls: Span<ContractCall> = array![].span();
    let drain_tokens: Span<ContractAddress> = array![].span();

    let salt = create_execution(context, owner, amount, fee, 10, creator_salt, calls, drain_tokens);

    let calls: Span<ContractCall> = array![ContractCall {
        address: 8468464612144.try_into().unwrap(),
        entrypoint: 454648884848,
        calldata: array![].span()
    }].span();
    let drain_tokens: Span<ContractAddress> = array![].span();

    execute_and_assert(context, owner, amount, fee, salt, calls, drain_tokens, false, array![].span(), true);
}
