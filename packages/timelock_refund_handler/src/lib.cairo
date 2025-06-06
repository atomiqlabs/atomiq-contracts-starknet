//Refund handler for timestamp based timelocks
//Claim data: C = u64 expiry timestamp encoded as felt252
//Witness: W = empty
#[starknet::contract]
mod TimelockRefundHandler {
    use common::handlers::refund::IRefundHandler;
    use core::starknet::get_block_timestamp;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl TimelockRefundHandlerImpl of IRefundHandler<ContractState> {
        fn refund(self: @ContractState, refund_data: felt252, witness: Array<felt252>) -> Span<felt252> {
            assert(witness.len()==0, 'timestamp_lock: witness len!=0');
            let timeout: u64 = refund_data.try_into().expect('timestamp_lock: u64 parse');
            assert(get_block_timestamp() > timeout, 'timestamp_lock: Not expired');
            [refund_data].span()
        }
    }
}
