#[starknet::interface]
pub trait IRefundHandler<TState> {
    fn refund(self: @TState, refund_data: felt252, witness: Array<felt252>) -> Span<felt252>;
}
