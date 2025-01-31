use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait
};
use starknet::contract_address::{ContractAddress};

use common::handlers::claim::{
    IClaimHandlerDispatcher, IClaimHandlerDispatcherTrait,
    IClaimHandlerSafeDispatcher, IClaimHandlerSafeDispatcherTrait
};

use btc_relay::structs::stored_blockheader::{StoredBlockHeader};
use btc_txid_claim_handler::{Commitment, Witness};

use core::hash::{HashStateTrait, HashStateExTrait};
use core::poseidon::PoseidonTrait;

pub fn deploy(header: StoredBlockHeader, relay_height: u32) -> (ContractAddress, IClaimHandlerDispatcher) {
    // Deploy BTC relay contract
    let mut serialized_data = array![];
    header.serialize(ref serialized_data);
    relay_height.serialize(ref serialized_data);
    let contract = declare("MockBtcRelay").unwrap().contract_class();
    let (btc_relay_contract_address, _) = contract.deploy(@serialized_data).unwrap();

    // First declare and deploy a contract
    let contract = declare("BitcoinTxIdClaimHandler").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();

    // Create a Dispatcher object that will allow interacting with the deployed contract
    let dispatcher = IClaimHandlerDispatcher { contract_address };

    (btc_relay_contract_address, dispatcher)
}

pub fn execute(dispatcher: IClaimHandlerDispatcher, commitment: Commitment, witness: Witness) {
    let mut witness_arr = array![];
    witness.serialize(ref witness_arr);
    
    let mut witness_result = array![];
    commitment.reversed_tx_id.serialize(ref witness_result);

    let result = dispatcher.claim(PoseidonTrait::new().update_with(commitment).finalize(), witness_arr);

    assert!(result==witness_result.span());
}

pub fn execute_should_fail(dispatcher: IClaimHandlerDispatcher, commitment: Commitment, witness: Witness, panic_reason: felt252) {
    let safe_dispatcher = IClaimHandlerSafeDispatcher { contract_address: dispatcher.contract_address };
    let mut witness_arr = array![];
    witness.serialize(ref witness_arr);
    let result = safe_dispatcher.claim(PoseidonTrait::new().update_with(commitment).finalize(), witness_arr);
    let error = result.unwrap_err();
    if panic_reason != 0 {
        assert!(error==array![panic_reason]);
    };
}

pub fn deploy_and_execute(header: StoredBlockHeader, relay_height: u32, commitment: Commitment, witness: Witness) {
    let (btc_relay_contract_address, dispatcher) = deploy(header, relay_height);
    let mut _commitment = commitment;
    let mut _witness = witness;
    _commitment.btc_relay_contract = btc_relay_contract_address;
    _witness.commitment.btc_relay_contract = btc_relay_contract_address;
    execute(dispatcher, _commitment, _witness);
}

//Valid randomly generated transactions and blockheaders
#[test]
fn test_valid_random() {
    for element in crate::data::valid_random::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (reversed_tx_id, confirmations, proof_blockheader, _merkle_proof, _merkle_length, position) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);

        let commitment = Commitment {
            reversed_tx_id,
            btc_relay_contract: 0.try_into().unwrap(),
            confirmations
        };

        deploy_and_execute(stored_header, relay_height, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            merkle_proof,
            position
        });
    }
}

//Valid real on-chain transactions and blockheaders
#[test]
fn test_valid_real() {
    for element in crate::data::valid_real::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (reversed_tx_id, confirmations, proof_blockheader, _merkle_proof, _merkle_length, position) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);

        let commitment = Commitment {
            reversed_tx_id,
            btc_relay_contract: 0.try_into().unwrap(),
            confirmations
        };

        deploy_and_execute(stored_header, relay_height, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            merkle_proof,
            position
        });
    }
}

//Invalid call due to empty witness array
#[test]
fn test_invalid_empty_witness() {
    for element in crate::data::valid_random::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (reversed_tx_id, confirmations, _, _merkle_proof, _merkle_length, _) = data;
        // let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        let commitment = Commitment {
            reversed_tx_id,
            btc_relay_contract,
            confirmations
        };

        let safe_dispatcher = IClaimHandlerSafeDispatcher { contract_address: dispatcher.contract_address };
        let mut witness_arr = array![];
        let result = safe_dispatcher.claim(PoseidonTrait::new().update_with(commitment).finalize(), witness_arr);
        let error = result.unwrap_err();
        assert!(error==array!['txidlock: Deserialize witness']);
    }
}

//Invalid call due to incorrect commitment, claim_data hash doesn't match commitment in witness
#[test]
fn test_invalid_commitment() {
    for element in crate::data::valid_random::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (reversed_tx_id, confirmations, proof_blockheader, _merkle_proof, _merkle_length, position) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        //Malleate commitment in claim_data
        let commitment = Commitment {
            reversed_tx_id,
            btc_relay_contract,
            confirmations: confirmations + 10
        };

        execute_should_fail(dispatcher, commitment, Witness {
            //Correct commitment in witness
            commitment: Commitment {
                reversed_tx_id,
                btc_relay_contract,
                confirmations
            },
            blockheader: proof_blockheader,
            merkle_proof,
            position
        }, 'txidlock: Invalid commitment');
    }
}

//Invalid due to block containing the transaciton not having enough confirmations
#[test]
fn test_invalid_confirmations() {
    for element in crate::data::valid_random::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (reversed_tx_id, _, proof_blockheader, _merkle_proof, _merkle_length, position) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        let commitment = Commitment {
            reversed_tx_id,
            btc_relay_contract,
            confirmations: relay_height - stored_header.block_height + 2
        };

        execute_should_fail(dispatcher, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            merkle_proof,
            position
        }, 'txidlock: Confirmations');
    }
}

//Invalid due to incorrect merkle proof - root doesn't match
#[test]
fn test_invalid_merkle() {
    for element in crate::data::invalid_random_merkle::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (reversed_tx_id, confirmations, proof_blockheader, _merkle_proof, _merkle_length, position) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        let commitment = Commitment {
            reversed_tx_id,
            btc_relay_contract,
            confirmations
        };

        execute_should_fail(dispatcher, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            merkle_proof,
            position
        }, 'merkle_tree: verify failed');
    }
}

//Invalid due to invalid blockheader, blockheader stored in light client != witness blockheader
#[test]
fn test_invalid_blockheader() {
    for element in crate::data::invalid_random_blockheader::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (reversed_tx_id, confirmations, proof_blockheader, _merkle_proof, _merkle_length, position) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        let commitment = Commitment {
            reversed_tx_id,
            btc_relay_contract,
            confirmations
        };

        execute_should_fail(dispatcher, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            merkle_proof,
            position
        }, 'verify: block commitment');
    }
}
