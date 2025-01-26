use super::super::contracts::mock_erc20::ERC20MintBurnDispatcherTrait;

use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait, cheat_caller_address, CheatSpan
};
use starknet::contract_address::{ContractAddress, contract_address_const};

use crate::contracts::mock_erc20::{ERC20MintBurnDispatcher};
use openzeppelin_token::erc20::{ERC20ABIDispatcher, ERC20ABIDispatcherTrait};

pub fn deploy() -> ERC20ABIDispatcher {
    // First declare and deploy a contract
    let contract = declare("MockToken").unwrap().contract_class();

    let (contract_address, _) = contract.deploy(@array![contract_address_const::<'erc20 owner'>().into()]).unwrap();
    
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
