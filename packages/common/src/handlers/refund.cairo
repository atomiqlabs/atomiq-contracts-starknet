//Interface for checking refundability of the escrow (i.e. if the offerer is able to refund the funds from the escrow back to himself)
#[starknet::interface]
pub trait IRefundHandler<TState> {
    fn refund(self: @TState, refund_data: felt252, witness: Array<felt252>) -> Span<felt252>;
}
