use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait, load
};
use starknet::contract_address::{ContractAddress};

use openzeppelin_token::erc20::{ERC20ABIDispatcher};
use crate::utils::erc20;
use execution_contract::{IExecutionContractSafeDispatcher, IExecutionContractReadOnlyDispatcher};

pub fn deploy() -> (IExecutionContractReadOnlyDispatcher, IExecutionContractSafeDispatcher) {
    println!("{:x}", *declare("ExecutionProxy").unwrap().contract_class().class_hash);
    // First declare and deploy a contract
    let contract = declare("ExecutionContract").unwrap().contract_class();

    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    
    // Create a Dispatcher object that will allow interacting with the deployed contract
    (IExecutionContractReadOnlyDispatcher{contract_address: contract_address}, IExecutionContractSafeDispatcher{contract_address: contract_address})
}

pub fn deploy_test_contract() -> ContractAddress {
    // First declare and deploy a contract
    let contract = declare("TestContract").unwrap().contract_class();

    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    
    // Create a Dispatcher object that will allow interacting with the deployed contract
    contract_address
}

#[derive(Copy, Drop)]
pub struct Context {
    pub contract_read: IExecutionContractReadOnlyDispatcher,
    pub contract: IExecutionContractSafeDispatcher,
    pub test_contract: ContractAddress,
    pub execution_proxy: ContractAddress,
    pub token0: ERC20ABIDispatcher,
    pub token1: ERC20ABIDispatcher
}

pub fn get_context() -> Context {
    let (contract_read, contract) = deploy();

    let execution_proxy: ContractAddress = (*load(
        contract.contract_address,
        selector!("execution_proxy"),
        1
    )[0]).try_into().unwrap();

    Context {
        contract_read: contract_read,
        contract: contract,
        execution_proxy: execution_proxy,
        token0: erc20::deploy(),
        token1: erc20::deploy(),
        test_contract: deploy_test_contract()
    }
}
