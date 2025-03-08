use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait
};
use starknet::contract_address::{ContractAddress};

use openzeppelin_token::erc20::{ERC20ABIDispatcher};
use crate::utils::erc20;
use spv_swap_vault::{ISpvVaultManagerReadOnlyDispatcher, ISpvVaultManagerSafeDispatcher};

pub fn deploy() -> (ISpvVaultManagerReadOnlyDispatcher, ISpvVaultManagerSafeDispatcher, ContractAddress) {
    let execution_contract = declare("ExecutionContract").unwrap().contract_class();

    let (execution_contract_address, _) = execution_contract.deploy(@array![]).unwrap();

    // First declare and deploy a contract
    let contract = declare("SpvVaultManager").unwrap().contract_class();

    let (contract_address, _) = contract.deploy(@array![execution_contract_address.into()]).unwrap();
    
    // Create a Dispatcher object that will allow interacting with the deployed contract
    (
        ISpvVaultManagerReadOnlyDispatcher{contract_address: contract_address}, 
        ISpvVaultManagerSafeDispatcher{contract_address: contract_address},
        execution_contract_address
    )
}

#[derive(Copy, Drop)]
pub struct Context {
    pub contract_read: ISpvVaultManagerReadOnlyDispatcher,
    pub contract: ISpvVaultManagerSafeDispatcher,
    pub execution_contract: ContractAddress,
    pub token0: ERC20ABIDispatcher,
    pub token1: ERC20ABIDispatcher
}

pub fn get_context() -> Context {
    let (contract_read, contract, execution_contract) = deploy();

    Context {
        contract_read: contract_read,
        contract: contract,
        execution_contract: execution_contract,
        token0: erc20::deploy(),
        token1: erc20::deploy()
    }
}
