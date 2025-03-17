use snforge_std::{
    cheat_caller_address, CheatSpan
};

use starknet::contract_address::contract_address_const;

use openzeppelin_token::erc20::ERC20ABIDispatcherTrait;

use crate::utils::contract::get_context;
use crate::utils::erc20;
use crate::utils::execution::create_and_assert;

//Valid creation of execution
#[test]
fn valid_create() {
    let context = get_context();

    let funder = contract_address_const::<'funder'>();
    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    
    erc20::mint(context.token0, funder, amount + fee);
    cheat_caller_address(context.token0.contract_address, funder, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, amount + fee);

    create_and_assert(context, funder, owner, amount, fee, 1, 10, 0);
}

//Invalid creation of execution, because of execution hash == 0
#[test]
#[should_panic(expected: 'create: execution_hash=0')]
fn invalid_execution_hash_0() {
    let context = get_context();

    let funder = contract_address_const::<'funder'>();
    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    
    erc20::mint(context.token0, funder, amount + fee);
    cheat_caller_address(context.token0.contract_address, funder, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, amount + fee);

    create_and_assert(context, funder, owner, amount, fee, 0, 10, 0);
}

//Invalid creation of execution, because execution already exists
#[test]
#[should_panic(expected: 'create: Already initiated')]
fn invalid_execution_already_initiated() {
    let context = get_context();

    let funder = contract_address_const::<'funder'>();
    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    
    erc20::mint(context.token0, funder, amount + fee);
    cheat_caller_address(context.token0.contract_address, funder, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, amount + fee);

    create_and_assert(context, funder, owner, amount, fee, 1, 10, 0);
    create_and_assert(context, funder, owner, amount, fee, 2, 10, 0);
}

//Invalid creation of execution, not enough balance to fund it
#[test]
#[should_panic(expected: 'ERC20: insufficient balance')]
fn invalid_execution_not_enough_funds() {
    let context = get_context();

    let funder = contract_address_const::<'funder'>();
    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    
    erc20::mint(context.token0, funder, 500);
    cheat_caller_address(context.token0.contract_address, funder, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, amount + fee);

    create_and_assert(context, funder, owner, amount, fee, 1, 10, 0);
}

//Invalid creation of execution, not enough allowance to fund it
#[test]
#[should_panic(expected: 'ERC20: insufficient allowance')]
fn invalid_execution_not_enough_allowance() {
    let context = get_context();

    let funder = contract_address_const::<'funder'>();
    let owner = contract_address_const::<'owner'>();
    let amount = 1000;
    let fee = 100;
    
    erc20::mint(context.token0, funder, amount + fee);
    cheat_caller_address(context.token0.contract_address, funder, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, 500);

    create_and_assert(context, funder, owner, amount, fee, 1, 10, 0);
}
