use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait
};
use starknet::contract_address::{ContractAddress};

use common::handlers::claim::{
    IClaimHandlerDispatcher, IClaimHandlerDispatcherTrait,
    IClaimHandlerSafeDispatcher, IClaimHandlerSafeDispatcherTrait
};

pub fn deploy() -> (ContractAddress, IClaimHandlerDispatcher) {
    // First declare and deploy a contract
    let contract = declare("HashlockClaimHandler").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();

    // Create a Dispatcher object that will allow interacting with the deployed contract
    let dispatcher = IClaimHandlerDispatcher { contract_address };

    (contract_address, dispatcher)
}

pub fn execute(dispatcher: IClaimHandlerDispatcher, hash: felt252, secret: [u32; 8]) {
    let mut secret_arr = array![];
    secret.serialize(ref secret_arr);
    let secret_arr_span = secret_arr.span();
    let result = dispatcher.claim(hash, secret_arr);
    assert!(result==secret_arr_span);
}

pub fn execute_should_fail(dispatcher: IClaimHandlerDispatcher, hash: felt252, secret: [u32; 8], panic_reason: felt252) {
    let safe_dispatcher = IClaimHandlerSafeDispatcher { contract_address: dispatcher.contract_address };
    let mut secret_arr = array![];
    secret.serialize(ref secret_arr);
    let result = safe_dispatcher.claim(hash, secret_arr);
    let error = result.unwrap_err();
    assert!(error==array![panic_reason]);
}

pub fn deploy_and_execute(hash: felt252, secret: [u32; 8]) {
    let (_, dispatcher) = deploy();
    execute(dispatcher, hash, secret);
}


#[test]
fn test_valid_manual() {
    let (_, dispatcher) = deploy();
    for element in crate::data::valid_manual::TEST_DATA.span() {
        let (hash, secret) = *element;
        execute(dispatcher, hash, secret);
    }
}

#[test]
fn test_valid_random() {
    let (_, dispatcher) = deploy();
    for element in crate::data::valid_random::TEST_DATA.span() {
        let (hash, secret) = *element;
        execute(dispatcher, hash, secret);
    }
}

#[test]
fn test_invalid_wrong_secret_random() {
    let (_, dispatcher) = deploy();
    for element in crate::data::invalid_wrong_secret::TEST_DATA.span() {
        let (hash, secret) = *element;
        execute_should_fail(dispatcher, hash, secret, 'hashlock: Invalid witness');
    }
}

#[test]
fn test_invalid_wrong_hash_random() {
    let (_, dispatcher) = deploy();
    for element in crate::data::invalid_wrong_hash::TEST_DATA.span() {
        let (hash, secret) = *element;
        execute_should_fail(dispatcher, hash, secret, 'hashlock: Invalid witness');
    }
}

#[test]
#[should_panic(expected: 'hashlock: Deserialize witness')]
fn test_invalid_empty_witness() {
    let (_, dispatcher) = deploy();
    dispatcher.claim(0, array![]);
}

#[test]
#[should_panic(expected: 'hashlock: Large witness')]
fn test_invalid_wrong_witness_large() {
    let (_, dispatcher) = deploy();
    dispatcher.claim(0, array![0, 1, 2, 3, 4, 5, 6, 7, 8]);
}

#[test]
#[should_panic(expected: 'hashlock: Deserialize witness')]
fn test_invalid_wrong_witness_small() {
    let (_, dispatcher) = deploy();
    dispatcher.claim(0, array![0, 1, 2, 3, 4, 5, 6]);
}

#[test]
#[should_panic(expected: 'hashlock: Deserialize witness')]
fn test_invalid_wrong_witness_overflow() {
    let (_, dispatcher) = deploy();
    dispatcher.claim(0, array![0, 1, 2, 0xffffffffffff, 4, 5, 6, 7]);
}
