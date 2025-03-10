use openzeppelin_access::ownable::interface::IOwnableDispatcherTrait;
use super::super::contracts::mock_erc20::ERC20MintBurnDispatcherTrait;

use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait, cheat_caller_address, CheatSpan, generate_random_felt
};
use starknet::contract_address::{ContractAddress, contract_address_const};

use crate::contracts::mock_erc20::{ERC20MintBurnDispatcher};
use openzeppelin_token::erc20::{ERC20ABIDispatcher, ERC20ABIDispatcherTrait};
use openzeppelin_access::ownable::interface::{IOwnableDispatcher};

pub fn deploy() -> ERC20ABIDispatcher {
    // First declare and deploy a contract
    let contract = declare("MockToken").unwrap().contract_class();

    //Use random owner for deployment, such that the contract address is always different
    let random_owner: ContractAddress = generate_random_felt().try_into().expect('deploy: random owner');
    let (contract_address, _) = contract.deploy(@array![random_owner.into()]).unwrap();
    cheat_caller_address(contract_address, random_owner, CheatSpan::TargetCalls(1));
    IOwnableDispatcher{contract_address}.transfer_ownership(contract_address_const::<'erc20 owner'>());

    // Create a Dispatcher object that will allow interacting with the deployed contract
    ERC20ABIDispatcher { contract_address }
}

pub fn mint(erc20: ERC20ABIDispatcher, to: ContractAddress, amount: u256) {
    cheat_caller_address(erc20.contract_address, contract_address_const::<'erc20 owner'>(), CheatSpan::TargetCalls(1));
    ERC20MintBurnDispatcher {contract_address: erc20.contract_address}.mint(to, amount);
}

pub fn deploy_mint_and_assert(to: ContractAddress, amount: u256) -> ERC20ABIDispatcher {
    let dispatcher = deploy();
    mint(dispatcher, to, amount);
    assert_eq!(dispatcher.balance_of(to), amount);
    dispatcher
}
