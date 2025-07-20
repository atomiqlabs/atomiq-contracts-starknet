use execution_contract::{IExecutionContractSafeDispatcherTrait, IExecutionContractReadOnlyDispatcherTrait, ExecutionContract};
use execution_contract::state::Execution;
use execution_contract::events;
use execution_contract::structs::ContractCall;
use execution_contract::utils::{SpanHashImpl};

use core::hash::{HashStateTrait, HashStateExTrait};
use core::poseidon::PoseidonTrait;

use snforge_std::{
    cheat_caller_address, CheatSpan, spy_events, EventSpyAssertionsTrait
};

use starknet::contract_address::{ContractAddress, contract_address_const};

use openzeppelin_token::erc20::ERC20ABIDispatcherTrait;

use crate::utils::contract::Context;
use crate::utils::erc20;

pub fn create_execution(
    context: Context,
    owner: ContractAddress,
    amount: u256,
    fee: u256,
    expiry: u64,
    creator_salt: felt252,
    calls: Span<ContractCall>,
    drain_tokens: Span<ContractAddress>
) -> felt252 {
    let funder = contract_address_const::<'funder'>();

    erc20::mint(context.token0, funder, amount + fee);
    cheat_caller_address(context.token0.contract_address, funder, CheatSpan::TargetCalls(1));
    context.token0.approve(context.contract.contract_address, amount + fee);

    let execution_hash = PoseidonTrait::new().update_with(calls).update_with(drain_tokens).finalize();

    create_and_assert(context, funder, owner, amount, fee, execution_hash, expiry, creator_salt)
}

pub fn create_and_assert(
    context: Context,
    funder: ContractAddress,
    owner: ContractAddress,
    amount: u256,
    fee: u256,
    execution_hash: felt252,
    expiry: u64,
    creator_salt: felt252
) -> felt252 {
    let balance_erc20_funder = context.token0.balance_of(funder);
    let balance_erc20_contract = context.token0.balance_of(context.contract.contract_address);

    let mut spy = spy_events();

    cheat_caller_address(context.contract.contract_address, funder, CheatSpan::TargetCalls(1));
    let result = context.contract.create(owner, creator_salt, context.token0.contract_address, amount, fee, execution_hash, expiry);

    if result.is_err() {
        panic(result.unwrap_err());
    }

    //Compute the actual salt from the sender address and provided creator_salt,
    // this ensures that no one else can try to front-run the execution creation
    // and block the actual execution from being created
    let salt = PoseidonTrait::new()
        .update_with(funder)
        .update(creator_salt)
        .finalize();

    //Assert event emitted
    spy.assert_emitted(
        @array![(context.contract.contract_address, ExecutionContract::Event::ExecutionCreated(events::ExecutionCreated {
            owner: owner,
            salt: salt,
            execution_hash: execution_hash,
            token: context.token0.contract_address,
            amount: amount,
            execution_fee: fee,
            expiry: expiry
        }))]
    );

    //Asert state saved
    assert_eq!(context.contract_read.get_execution(owner, salt), Execution {
        token: context.token0.contract_address,
        execution_hash: execution_hash,
        amount: amount,
        execution_fee: fee,
        expiry: expiry
    });

    //Assert tokens transfered
    assert_eq!(balance_erc20_funder - amount - fee, context.token0.balance_of(funder));
    assert_eq!(balance_erc20_contract + amount + fee, context.token0.balance_of(context.contract.contract_address));

    salt
}
