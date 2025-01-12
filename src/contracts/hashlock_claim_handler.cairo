
#[starknet::contract]
mod HashlockClaimHandler {
    use crate::handlers::claim::IClaimHandler;
    use crate::utils::byte_array::{ByteArrayIntegerReader};
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::poseidon::PoseidonTrait;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl HashlockClaimHandlerImpl of IClaimHandler<ContractState> {
        fn claim(self: @ContractState, claim_data: felt252, witness: ByteArray) -> ByteArray {
            assert(witness.len() == 32, 'hashlock: Invalid witness len');
            let result = witness.hash_sha256();
            assert(claim_data == PoseidonTrait::new().update_with(result).finalize(), 'hashlock: Invalid witness');
            witness
        }
    }
}
