use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait
};
use starknet::contract_address::{ContractAddress};

use openzeppelin_token::erc20::{ERC20ABIDispatcher};
use snforge_std::signature::stark_curve::{StarkCurveKeyPairImpl, StarkCurveSignerImpl};
use snforge_std::signature::KeyPair;
use crate::utils::erc20;

pub fn deploy() -> ContractAddress {
    // First declare and deploy a contract
    let contract = declare("EscrowManager").unwrap().contract_class();

    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    
    // Create a Dispatcher object that will allow interacting with the deployed contract
    contract_address
}

pub fn deploy_account() -> (ContractAddress, KeyPair<felt252, felt252>) {
    // First declare and deploy a contract
    let contract = declare("MockAccount").unwrap().contract_class();

    let keypair = StarkCurveKeyPairImpl::generate();

    let (contract_address, _) = contract.deploy(@array![keypair.public_key]).unwrap();

    return (contract_address, keypair);
}

pub fn deploy_refund_handler() -> ContractAddress {
    // First declare and deploy a contract
    let contract = declare("MockRefundHandler").unwrap().contract_class();

    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    
    // Create a Dispatcher object that will allow interacting with the deployed contract
    contract_address
}

pub fn deploy_claim_handler() -> ContractAddress {
    // First declare and deploy a contract
    let contract = declare("MockClaimHandler").unwrap().contract_class();

    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    
    // Create a Dispatcher object that will allow interacting with the deployed contract
    contract_address
}

pub fn deploy_execution_contract() -> ContractAddress {
    // First declare and deploy a contract
    let contract = declare("MockExecutionContract").unwrap().contract_class();

    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    
    // Create a Dispatcher object that will allow interacting with the deployed contract
    contract_address
}

#[derive(Copy, Drop)]
pub struct Context {
    pub contract_address: ContractAddress,
    pub token: ERC20ABIDispatcher,
    pub gas_token: ERC20ABIDispatcher,
    pub refund_handler: ContractAddress,
    pub claim_handler: ContractAddress,
    pub execution_contract: ContractAddress
}

pub fn get_context() -> Context {
    Context {
        contract_address: deploy(),
        token: erc20::deploy(),
        gas_token: erc20::deploy(),
        refund_handler: deploy_refund_handler(),
        claim_handler: deploy_claim_handler(),
        execution_contract: deploy_execution_contract()
    }
}
