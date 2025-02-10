use starknet::contract_address::ContractAddress;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

//Claim handler for bitcoin chain, requiring a pre-specified output script with a pre-specified amount
// as one of the outputs of the transaction.

#[derive(Copy, Drop, Hash, Serde)]
pub struct Commitment {
    pub txo_hash: felt252, //Hash of poseidon([output_amount, poseidon(to_bytes31_array(output_script))])
    pub confirmations: u32,
    pub btc_relay_contract: ContractAddress
}

#[derive(Drop, Serde)]
pub struct Witness {
    pub commitment: Commitment,
    pub blockheader: StoredBlockHeader,
    pub merkle_proof: Span<[u32; 8]>,
    pub position: u32,
    pub transaction: ByteArray,
    pub vout: u32
}

#[starknet::contract]
mod BitcoinOutputClaimHandler {
    use super::*;
    use common::handlers::claim::IClaimHandler;
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::poseidon::PoseidonTrait;
    use btc_utils::bitcoin_merkle_tree;
    use btc_relay::{IBtcRelayReadOnlyDispatcher, IBtcRelayReadOnlyDispatcherTrait};
    use btc_utils::bitcoin_tx::{BitcoinTransactionImpl, BitcoinTransactionTrait, BitcoinTxOutputTrait};

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl BitcoinOutputClaimHandlerImpl of IClaimHandler<ContractState> {
        fn claim(self: @ContractState, claim_data: felt252, witness: Array<felt252>) -> Span<felt252> {
            let mut witness_span = witness.span();
            let witness_struct = Serde::<Witness>::deserialize(ref witness_span).expect('btcoutlock: Deserialize witness');
            
            let expected_txo_hash = witness_struct.commitment.txo_hash;
            let confirmations = witness_struct.commitment.confirmations;
            let btc_relay_contract = witness_struct.commitment.btc_relay_contract;

            //Verify claim data commitment
            assert(PoseidonTrait::new().update_with(witness_struct.commitment).finalize() == claim_data, 'btcoutlock: Invalid commitment');

            //Parse transaction
            let transaction = BitcoinTransactionImpl::from_byte_array(@witness_struct.transaction);
            //Check output is valid
            let txo = transaction.get_out(witness_struct.vout).expect('btcoutlock: Invalid vout').unbox();
            let txo_hash = PoseidonTrait::new().update(txo.get_value().into()).update(txo.get_script_hash()).finalize();
            assert(txo_hash == expected_txo_hash, 'btcoutlock: Invalid output');

            //Verify blockheader against the light client
            let block_confirmations = IBtcRelayReadOnlyDispatcher{contract_address: btc_relay_contract}.verify_blockheader(witness_struct.blockheader);
            assert(block_confirmations>=confirmations, 'btcoutlock: Confirmations');

            let transaction_hash = transaction.get_hash();

            //Verify merkle proof
            bitcoin_merkle_tree::verify(
                witness_struct.blockheader.blockheader.merkle_root,
                transaction_hash,
                witness_struct.merkle_proof,
                witness_struct.position
            );

            let mut witness_result = array![];
            transaction_hash.serialize(ref witness_result);
            witness_result.span()
        }
    }
}
