
#[starknet::contract]
mod HashlockClaimHandler {
    use common::handlers::claim::IClaimHandler;
    use core::sha256::compute_sha256_byte_array;
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::poseidon::PoseidonTrait;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl HashlockClaimHandlerImpl of IClaimHandler<ContractState> {
        fn claim(self: @ContractState, claim_data: felt252, witness: Array<felt252>) -> Span<felt252> {
            let mut witness_span = witness.span();
            let witness_byte_array = Serde::<ByteArray>::deserialize(ref witness_span).expect('hashlock: Deserialize witness');

            assert(witness.len() == 32, 'hashlock: Invalid witness len');
            let result = compute_sha256_byte_array(@witness_byte_array);
            assert(claim_data == PoseidonTrait::new().update_with(result).finalize(), 'hashlock: Invalid witness');
            witness.span()
        }
    }
}
