
#[starknet::contract]
mod HashlockClaimHandler {
    use common::handlers::claim::IClaimHandler;
    use core::sha256::compute_sha256_u32_array;
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::poseidon::PoseidonTrait;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl HashlockClaimHandlerImpl of IClaimHandler<ContractState> {
        fn claim(self: @ContractState, claim_data: felt252, witness: Array<felt252>) -> Span<felt252> {
            let mut witness_span = witness.span();
            let witness_byte_array = Serde::<[u32; 8]>::deserialize(ref witness_span).expect('hashlock: Deserialize witness').span();
            assert(witness_span.len()==0, 'hashlock: Large witness');

            let result = compute_sha256_u32_array(array![
                *witness_byte_array[0], *witness_byte_array[1], *witness_byte_array[2], *witness_byte_array[3],
                *witness_byte_array[4], *witness_byte_array[5], *witness_byte_array[6], *witness_byte_array[7]
            ], 0, 0);
            assert(claim_data == PoseidonTrait::new().update_with(result).finalize(), 'hashlock: Invalid witness');
            witness.span()
        }
    }
}
