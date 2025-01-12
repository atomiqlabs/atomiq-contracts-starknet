#[starknet::interface]
pub trait IClaimHandler<TState> {
    fn claim(self: @TState, claim_data: felt252, witness: ByteArray) -> ByteArray;
}
