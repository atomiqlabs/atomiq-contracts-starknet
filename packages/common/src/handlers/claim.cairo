#[starknet::interface]
pub trait IClaimHandler<TState> {
    fn claim(self: @TState, claim_data: felt252, witness: Array<felt252>) -> Span<felt252>;
}
