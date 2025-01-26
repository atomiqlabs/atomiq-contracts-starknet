use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait
};
use starknet::contract_address::{ContractAddress};

use snforge_std::signature::stark_curve::{StarkCurveKeyPairImpl, StarkCurveSignerImpl};
use snforge_std::signature::KeyPair;

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