use starknet::contract_address::ContractAddress;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

//Claim handler for bitcoin chain, requiring a pre-specified output script with a pre-specified amount
// as one of the outputs of the transaction. The transaction also needs to be marked with a specific nonce
// a nonce in this context is derived from the the transaction's timelock & input nSequences.
//Nonce n is computed as n = ((locktime - 500,000,000) << 24) | (nSequence & 0x00FFFFFF)
//The last 3 bytes of the nSequence need to be the same for every input
//First 4 bits of the nSequence need to be set for every input (ensuring nSequence has no consensus meaning)

#[derive(Drop, Hash, Serde)]
struct Commitment {
    txo_hash: felt252, //Hash of poseidon([nonce, output_amount, poseidon(to_bytes31_array(output_script))])
    confirmations: u32,
    btc_relay_contract: ContractAddress
}

#[derive(Drop, Serde)]
struct Witness {
    commitment: Commitment,
    blockheader: StoredBlockHeader,
    transaction: ByteArray,
    vout: u32,
    merkle_proof: Span<[u32; 8]>,
    position: u32
}

#[starknet::contract]
mod BitcoinNoncedOutputClaimHandler {
    use super::*;
    use common::handlers::claim::IClaimHandler;
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::poseidon::PoseidonTrait;
    use btc_utils::bitcoin_merkle_tree;
    use btc_relay::{IBtcRelayReadOnlyDispatcher, IBtcRelayReadOnlyDispatcherTrait};
    use btc_utils::bitcoin_tx::{BitcoinTransactionImpl, BitcoinTransactionTrait, BitcoinTxOutputTrait, BitcoinTxInputTrait};

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl BitcoinNoncedOutputClaimHandlerImpl of IClaimHandler<ContractState> {
        fn claim(self: @ContractState, claim_data: felt252, witness: Array<felt252>) -> Span<felt252> {
            let mut witness_span = witness.span();
            let witness_struct = Serde::<Witness>::deserialize(ref witness_span).expect('btcoutlock: Deserialize witness');
            
            let expected_txo_hash = witness_struct.commitment.txo_hash;
            let confirmations = witness_struct.commitment.confirmations;
            let btc_relay_contract = witness_struct.commitment.btc_relay_contract;

            //Verify claim data commitment
            assert(PoseidonTrait::new().update_with(witness_struct.commitment).finalize() == claim_data, 'btcnoutlock: Invalid commitment');

            //Parse transaction
            let transaction = BitcoinTransactionImpl::from_byte_array(@witness_struct.transaction);

            //Check the nonce is correct
            //First input
            let first_n_sequence = transaction.get_in(0).expect('btcnoutlock: Empty ins').unbox().get_n_sequence();
            assert(first_n_sequence & 0xF0000000 == 0xF0000000, 'btcnoutlock: nSequence bits'); //Ensure first 4 bits are set, such that the nSequence has no consensus meaning
            let n_sequence: u32 = first_n_sequence & 0x00FFFFFF; //Isolate 3 least significant bytes of the nSequence
            //Other inputs
            let mut index = 1;
            while index != transaction.count_ins() {
                let input_n_sequence = transaction.get_in(index).unwrap().unbox().get_n_sequence();
                assert(input_n_sequence & 0xF0000000 == 0xF0000000, 'btcnoutlock: nSequence bits'); //Ensure first 4 bits are set, such that the nSequence has no consensus meaning
                assert(input_n_sequence & 0x00FFFFFF == n_sequence, 'btcnoutlock: nSequence match'); //Ensure all nSequences match in the 3 least significant bytes
                index += 1;
            };

            //Check output is valid
            let txo = transaction.get_out(witness_struct.vout).expect('btcnoutlock: Invalid vout').unbox();

            let txo_hash = PoseidonTrait::new().update(n_sequence.into()).update(txo.get_value().into()).update(txo.get_script_hash()).finalize();
            assert(txo_hash == expected_txo_hash, 'btcnoutlock: Invalid output');

            let transaction_hash = transaction.get_hash();

            //Verify merkle proof
            bitcoin_merkle_tree::verify(
                witness_struct.blockheader.blockheader.merkle_root,
                transaction_hash,
                witness_struct.merkle_proof,
                witness_struct.position
            );

            //Verify blockheader against the light client
            let block_confirmations = IBtcRelayReadOnlyDispatcher{contract_address: btc_relay_contract}.verify_blockheader(witness_struct.blockheader);
            assert(block_confirmations>=confirmations, 'txidlock: Confirmations');

            let mut witness_result = array![];
            transaction_hash.serialize(ref witness_result);
            witness_result.span()
        }
    }
}
