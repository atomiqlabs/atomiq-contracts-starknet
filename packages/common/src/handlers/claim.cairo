//Interface for checking claimability of the escrow (i.e. if the claimer is able to claim the funds from the escrow)
#[starknet::interface]
pub trait IClaimHandler<TState> {
    fn claim(self: @TState, claim_data: felt252, witness: Array<felt252>) -> Span<felt252>;
}
