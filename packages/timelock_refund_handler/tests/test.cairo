use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait,
    cheat_block_timestamp, CheatSpan
};
use starknet::contract_address::{ContractAddress};

use common::handlers::refund::{
    IRefundHandlerDispatcher, IRefundHandlerDispatcherTrait,
    IRefundHandlerSafeDispatcher, IRefundHandlerSafeDispatcherTrait
};

pub fn deploy() -> (ContractAddress, IRefundHandlerDispatcher) {
    // First declare and deploy a contract
    let contract = declare("TimelockRefundHandler").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();

    // Create a Dispatcher object that will allow interacting with the deployed contract
    let dispatcher = IRefundHandlerDispatcher { contract_address };

    (contract_address, dispatcher)
}

pub fn execute(dispatcher: IRefundHandlerDispatcher, refund_data: felt252, current_time: u64) {
    cheat_block_timestamp(dispatcher.contract_address, current_time, CheatSpan::Indefinite);
    let result = dispatcher.refund(refund_data, array![]);
    assert!(result==array![refund_data].span());
}

pub fn execute_should_fail(dispatcher: IRefundHandlerDispatcher, refund_data: felt252, current_time: u64, panic_reason: felt252) {
    cheat_block_timestamp(dispatcher.contract_address, current_time, CheatSpan::Indefinite);
    let safe_dispatcher = IRefundHandlerSafeDispatcher { contract_address: dispatcher.contract_address };
    let result = safe_dispatcher.refund(refund_data, array![]);
    let error = result.unwrap_err();
    assert!(error==array![panic_reason]);
}

pub fn deploy_and_execute(refund_data: felt252, current_time: u64) {
    let (_, dispatcher) = deploy();
    execute(dispatcher, refund_data, current_time);
}

#[test]
fn test_success_manual() {
    let (_, dispatcher) = deploy();
    execute(dispatcher, 1000, 1100);
    execute(dispatcher, 0xFFFFFFFFFFFFFFFE, 0xFFFFFFFFFFFFFFFF);
    execute(dispatcher, 0, 1);
    execute(dispatcher, 0, 1100);
    execute(dispatcher, 0, 0xFFFFFFFFFFFFFFFF);
}

#[test]
fn test_success_random() {
    let (_, dispatcher) = deploy();
    for element in crate::data::valid::TEST_DATA.span() {
        let (expiry_timestamp, current_timestamp) = *element;
        execute(dispatcher, expiry_timestamp, current_timestamp);
    }
}

#[test]
#[should_panic(expected: 'timestamp_lock: Not expired')]
fn test_fail_not_expired_1_manual() {
    deploy_and_execute(1100, 1000);
}

#[test]
#[should_panic(expected: 'timestamp_lock: Not expired')]
fn test_fail_not_expired_2_manual() {
    deploy_and_execute(0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFE);
}

#[test]
#[should_panic(expected: 'timestamp_lock: Not expired')]
fn test_fail_not_expired_3_manual() {
    deploy_and_execute(0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF);
}

#[test]
#[should_panic(expected: 'timestamp_lock: Not expired')]
fn test_fail_not_expired_4_manual() {
    deploy_and_execute(0, 0);
}

#[test]
fn test_fail_not_expired_random() {
    let (_, dispatcher) = deploy();
    for element in crate::data::invalid::TEST_DATA.span() {
        let (expiry_timestamp, current_timestamp) = *element;
        execute_should_fail(dispatcher, expiry_timestamp, current_timestamp, 'timestamp_lock: Not expired');
    }
}

#[test]
#[should_panic(expected: 'timestamp_lock: u64 parse')]
fn test_fail_overflow_1_manual() {
    let (_, dispatcher) = deploy();
    execute(dispatcher, 0x10000000000000000, 0xFFFFFFFFFFFFFFFF);
}

#[test]
#[should_panic(expected: 'timestamp_lock: u64 parse')]
fn test_fail_overflow_2_manual() {
    let (_, dispatcher) = deploy();
    execute(dispatcher, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 0);
}

#[test]
#[should_panic(expected: 'timestamp_lock: witness len!=0')]
fn test_fail_non_empty_witness() {
    let (_, dispatcher) = deploy();
    dispatcher.refund(0, array![0xfacb3adc]);
}
