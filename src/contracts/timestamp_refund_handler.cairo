
#[starknet::contract]
mod TimestampRefundHandler {
    use crate::handlers::refund::IRefundHandler;
    use core::starknet::get_block_timestamp;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl TimestampRefundHandlerImpl of IRefundHandler<ContractState> {
        fn refund(self: @ContractState, refund_data: felt252, witness: ByteArray) -> ByteArray {
            let timeout: u64 = refund_data.try_into().unwrap();
            assert(get_block_timestamp() > timeout, 'timestamp_lock: Not expired');
            ""
        }
    }
}
