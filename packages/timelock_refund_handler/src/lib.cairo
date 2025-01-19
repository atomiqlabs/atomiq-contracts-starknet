
#[starknet::contract]
mod TimelockRefundHandler {
    use common::handlers::refund::IRefundHandler;
    use core::starknet::get_block_timestamp;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl TimelockRefundHandlerImpl of IRefundHandler<ContractState> {
        fn refund(self: @ContractState, refund_data: felt252, witness: Array<felt252>) -> Span<felt252> {
            let timeout: u64 = refund_data.try_into().unwrap();
            assert(get_block_timestamp() > timeout, 'timestamp_lock: Not expired');
            [refund_data].span()
        }
    }
}
