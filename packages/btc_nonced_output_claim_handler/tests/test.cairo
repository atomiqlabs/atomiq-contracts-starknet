use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait
};
use starknet::contract_address::{ContractAddress};

use common::handlers::claim::{
    IClaimHandlerDispatcher, IClaimHandlerDispatcherTrait,
    IClaimHandlerSafeDispatcher, IClaimHandlerSafeDispatcherTrait
};

use btc_relay::structs::stored_blockheader::{StoredBlockHeader};
use btc_nonced_output_claim_handler::{Commitment, Witness};

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
    let contract = declare("BitcoinNoncedOutputClaimHandler").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();

    // Create a Dispatcher object that will allow interacting with the deployed contract
    let dispatcher = IClaimHandlerDispatcher { contract_address };

    (btc_relay_contract_address, dispatcher)
}

pub fn execute(dispatcher: IClaimHandlerDispatcher, commitment: Commitment, witness: Witness, reversed_tx_id: [u32; 8]) {
    let mut witness_arr = array![];
    witness.serialize(ref witness_arr);
    
    let mut witness_result = array![];
    reversed_tx_id.serialize(ref witness_result);

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
        assert(*error[0]==panic_reason, *error[0]);
    };
}

pub fn deploy_and_execute(header: StoredBlockHeader, relay_height: u32, commitment: Commitment, witness: Witness, reversed_tx_id: [u32; 8]) {
    let (btc_relay_contract_address, dispatcher) = deploy(header, relay_height);
    let mut _commitment = commitment;
    let mut _witness = witness;
    _commitment.btc_relay_contract = btc_relay_contract_address;
    _witness.commitment.btc_relay_contract = btc_relay_contract_address;
    execute(dispatcher, _commitment, _witness, reversed_tx_id);
}

//Valid randomly generated transactions and blockheaders
#[test]
fn test_valid_random() {
    for element in crate::data::valid_random::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (txo_hash, confirmations, proof_blockheader, _transaction, _transaction_length, vout, _merkle_proof, _merkle_length, position, reversed_tx_id) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);
        let mut transaction_serialized = _transaction.span().slice(0, _transaction_length);
        let transaction = Serde::<ByteArray>::deserialize(ref transaction_serialized).unwrap();

        let commitment = Commitment {
            txo_hash,
            btc_relay_contract: 0.try_into().unwrap(),
            confirmations
        };

        deploy_and_execute(stored_header, relay_height, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            transaction,
            vout,
            merkle_proof,
            position
        }, reversed_tx_id);
    }
}

//Invalid call due to empty witness array
#[test]
fn test_invalid_empty_witness() {
    for element in crate::data::valid_random::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (txo_hash, confirmations, _, _transaction, _transaction_length, _, _merkle_proof, _merkle_length, _, _) = data;

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        let commitment = Commitment {
            txo_hash,
            btc_relay_contract,
            confirmations
        };

        let safe_dispatcher = IClaimHandlerSafeDispatcher { contract_address: dispatcher.contract_address };
        let mut witness_arr = array![];
        let result = safe_dispatcher.claim(PoseidonTrait::new().update_with(commitment).finalize(), witness_arr);
        let error = result.unwrap_err();
        assert!(error==array!['btcnoutlock: Deserialize witnes']);
    }
}

//Invalid call due to incorrect commitment, claim_data hash doesn't match commitment in witness
#[test]
fn test_invalid_commitment() {
    for element in crate::data::valid_random::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (txo_hash, confirmations, proof_blockheader, _transaction, _transaction_length, vout, _merkle_proof, _merkle_length, position, _) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);
        let mut transaction_serialized = _transaction.span().slice(0, _transaction_length);
        let transaction = Serde::<ByteArray>::deserialize(ref transaction_serialized).unwrap();

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        //Malleate commitment in claim_data
        let commitment = Commitment {
            txo_hash,
            btc_relay_contract,
            confirmations: confirmations + 10
        };

        execute_should_fail(dispatcher, commitment, Witness {
            //Correct commitment in witness
            commitment: Commitment {
                txo_hash,
                btc_relay_contract,
                confirmations
            },
            blockheader: proof_blockheader,
            transaction,
            vout,
            merkle_proof,
            position
        }, 'btcnoutlock: Invalid commitment');
    }
}

//Invalid due to block containing the transaciton not having enough confirmations
#[test]
fn test_invalid_confirmations() {
    for element in crate::data::valid_random::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (txo_hash, _, proof_blockheader, _transaction, _transaction_length, vout, _merkle_proof, _merkle_length, position, _) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);
        let mut transaction_serialized = _transaction.span().slice(0, _transaction_length);
        let transaction = Serde::<ByteArray>::deserialize(ref transaction_serialized).unwrap();

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        let commitment = Commitment {
            txo_hash,
            btc_relay_contract,
            confirmations: relay_height - stored_header.block_height + 2
        };

        execute_should_fail(dispatcher, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            transaction,
            vout,
            merkle_proof,
            position
        }, 'btcnoutlock: Confirmations');
    }
}

//Invalid due to vout index being out of bounds for a specific transaction
#[test]
fn test_invalid_vout_out_of_bounds() {
    for element in crate::data::invalid_random_vout_out_of_bounds::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (txo_hash, confirmations, proof_blockheader, _transaction, _transaction_length, vout, _merkle_proof, _merkle_length, position, _) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);
        let mut transaction_serialized = _transaction.span().slice(0, _transaction_length);
        let transaction = Serde::<ByteArray>::deserialize(ref transaction_serialized).unwrap();

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        let commitment = Commitment {
            txo_hash,
            btc_relay_contract,
            confirmations
        };

        execute_should_fail(dispatcher, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            transaction,
            vout,
            merkle_proof,
            position
        }, 'btcnoutlock: Invalid vout');
    }
}

//Invalid due to output txoHash not matching
#[test]
fn test_invalid_output() {
    for element in crate::data::invalid_random_output::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (txo_hash, confirmations, proof_blockheader, _transaction, _transaction_length, vout, _merkle_proof, _merkle_length, position, _) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);
        let mut transaction_serialized = _transaction.span().slice(0, _transaction_length);
        let transaction = Serde::<ByteArray>::deserialize(ref transaction_serialized).unwrap();

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        let commitment = Commitment {
            txo_hash,
            btc_relay_contract,
            confirmations
        };

        execute_should_fail(dispatcher, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            transaction,
            vout,
            merkle_proof,
            position
        }, 'btcnoutlock: Invalid output');
    }
}

//Invalid due to incorrect merkle proof - root doesn't match
#[test]
fn test_invalid_merkle() {
    for element in crate::data::invalid_random_merkle::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (txo_hash, confirmations, proof_blockheader, _transaction, _transaction_length, vout, _merkle_proof, _merkle_length, position, _) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);
        let mut transaction_serialized = _transaction.span().slice(0, _transaction_length);
        let transaction = Serde::<ByteArray>::deserialize(ref transaction_serialized).unwrap();

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        let commitment = Commitment {
            txo_hash,
            btc_relay_contract,
            confirmations
        };

        execute_should_fail(dispatcher, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            transaction,
            vout,
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
        let (txo_hash, confirmations, proof_blockheader, _transaction, _transaction_length, vout, _merkle_proof, _merkle_length, position, _) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);
        let mut transaction_serialized = _transaction.span().slice(0, _transaction_length);
        let transaction = Serde::<ByteArray>::deserialize(ref transaction_serialized).unwrap();

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        let commitment = Commitment {
            txo_hash,
            btc_relay_contract,
            confirmations
        };

        execute_should_fail(dispatcher, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            transaction,
            vout,
            merkle_proof,
            position
        }, 'verify: block commitment');
    }
}

//Invalid due to tx inputs being empty, therefore nonce cannot be extracted
#[test]
fn test_invalid_empty_ins() {
    for element in crate::data::invalid_random_empty_ins::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (txo_hash, confirmations, proof_blockheader, _transaction, _transaction_length, vout, _merkle_proof, _merkle_length, position, _) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);
        let mut transaction_serialized = _transaction.span().slice(0, _transaction_length);
        let transaction = Serde::<ByteArray>::deserialize(ref transaction_serialized).unwrap();

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        let commitment = Commitment {
            txo_hash,
            btc_relay_contract,
            confirmations
        };

        execute_should_fail(dispatcher, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            transaction,
            vout,
            merkle_proof,
            position
        }, 'btcnoutlock: Empty ins');
    }
}

//Invalid due to nSequence 4 high bits being unset
#[test]
fn test_invalid_nsequence_bits() {
    for element in crate::data::invalid_random_sequence_bits::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (txo_hash, confirmations, proof_blockheader, _transaction, _transaction_length, vout, _merkle_proof, _merkle_length, position, _) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);
        let mut transaction_serialized = _transaction.span().slice(0, _transaction_length);
        let transaction = Serde::<ByteArray>::deserialize(ref transaction_serialized).unwrap();

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        let commitment = Commitment {
            txo_hash,
            btc_relay_contract,
            confirmations
        };

        execute_should_fail(dispatcher, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            transaction,
            vout,
            merkle_proof,
            position
        }, 'btcnoutlock: nSequence bits');
    }
}

//Invalid due to nSequence's 3 least signficant bytes not matching between multiple inputs
#[test]
fn test_invalid_nsequence_match() {
    for element in crate::data::invalid_random_sequence_match::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (txo_hash, confirmations, proof_blockheader, _transaction, _transaction_length, vout, _merkle_proof, _merkle_length, position, _) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);
        let mut transaction_serialized = _transaction.span().slice(0, _transaction_length);
        let transaction = Serde::<ByteArray>::deserialize(ref transaction_serialized).unwrap();

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        let commitment = Commitment {
            txo_hash,
            btc_relay_contract,
            confirmations
        };

        execute_should_fail(dispatcher, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            transaction,
            vout,
            merkle_proof,
            position
        }, 'btcnoutlock: nSequence match');
    }
}


//Invalid due to locktime < 500,000,000, so locktime - 500,000,000 cannot be computed
#[test]
fn test_invalid_locktime_too_low() {
    for element in crate::data::invalid_random_timelock_too_low::TEST_DATA.span() {
        let (btc_relay_data, data) = *element;
        let (stored_header, relay_height) = btc_relay_data;
        let (txo_hash, confirmations, proof_blockheader, _transaction, _transaction_length, vout, _merkle_proof, _merkle_length, position, _) = data;
        let merkle_proof = _merkle_proof.span().slice(0, _merkle_length);
        let mut transaction_serialized = _transaction.span().slice(0, _transaction_length);
        let transaction = Serde::<ByteArray>::deserialize(ref transaction_serialized).unwrap();

        let (btc_relay_contract, dispatcher) = deploy(stored_header, relay_height);

        let commitment = Commitment {
            txo_hash,
            btc_relay_contract,
            confirmations
        };

        execute_should_fail(dispatcher, commitment, Witness {
            commitment,
            blockheader: proof_blockheader,
            transaction,
            vout,
            merkle_proof,
            position
        }, 'btcnoutlock: Locktime too low');
    }
}
