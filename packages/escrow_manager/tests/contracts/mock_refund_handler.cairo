
#[starknet::contract]
mod MockRefundHandler {
    use common::handlers::refund::IRefundHandler;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl MockRefundHandlerImpl of IRefundHandler<ContractState> {
        fn refund(self: @ContractState, refund_data: felt252, witness: Array<felt252>) -> Span<felt252> {
            assert(witness.len()!=0, 'mock_refund: witness len==0');
            witness.span()
        }
    }
}
