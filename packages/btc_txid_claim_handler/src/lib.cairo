use starknet::contract_address::ContractAddress;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

//Claim handler for bitcoin chain txId locks based on light client verification

#[derive(Copy, Drop, Hash, Serde)]
pub struct Commitment {
    pub reversed_tx_id: [u32; 8],
    pub confirmations: u32,
    pub btc_relay_contract: ContractAddress
}

#[derive(Copy, Drop, Serde)]
pub struct Witness {
    pub commitment: Commitment,
    pub blockheader: StoredBlockHeader,
    pub merkle_proof: Span<[u32; 8]>,
    pub position: u32
}

#[starknet::contract]
mod BitcoinTxIdClaimHandler {
    use super::*;
    use common::handlers::claim::IClaimHandler;
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::poseidon::PoseidonTrait;
    use btc_utils::bitcoin_merkle_tree;
    use btc_relay::{IBtcRelayReadOnlyDispatcher, IBtcRelayReadOnlyDispatcherTrait};

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl TxIdClaimHandlerImpl of IClaimHandler<ContractState> {
        fn claim(self: @ContractState, claim_data: felt252, witness: Array<felt252>) -> Span<felt252> {
            let mut witness_span = witness.span();
            let witness_struct = Serde::<Witness>::deserialize(ref witness_span).expect('txidlock: Deserialize witness');
            
            let reversed_tx_id = witness_struct.commitment.reversed_tx_id;
            let confirmations = witness_struct.commitment.confirmations;
            let btc_relay_contract = witness_struct.commitment.btc_relay_contract;

            //Verify claim data commitment
            assert(PoseidonTrait::new().update_with(witness_struct.commitment).finalize() == claim_data, 'txidlock: Invalid commitment');

            //Verify blockheader against the light client
            let block_confirmations = IBtcRelayReadOnlyDispatcher{contract_address: btc_relay_contract}.verify_blockheader(witness_struct.blockheader);
            assert(block_confirmations>=confirmations, 'txidlock: Confirmations');

            //Verify merkle proof
            bitcoin_merkle_tree::verify(
                witness_struct.blockheader.blockheader.merkle_root,
                reversed_tx_id,
                witness_struct.merkle_proof,
                witness_struct.position
            );

            let mut witness_result = array![];
            reversed_tx_id.serialize(ref witness_result);
            witness_result.span()
        }
    }
}
