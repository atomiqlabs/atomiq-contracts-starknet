
#[starknet::contract]
mod MockClaimHandler {
    use common::handlers::claim::IClaimHandler;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl MockClaimHandlerImpl of IClaimHandler<ContractState> {
        fn claim(self: @ContractState, claim_data: felt252, witness: Array<felt252>) -> Span<felt252> {
            assert(witness.len()!=0, 'mock_claim: witness len==0');
            witness.span()
        }
    }
}
