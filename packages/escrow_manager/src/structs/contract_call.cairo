use starknet::ContractAddress;
use core::hash::{HashStateTrait, HashStateExTrait, Hash};

pub impl Felt252SpanHashImpl<HashState, +HashStateTrait<HashState>, +Drop<HashState>> of Hash<Span<felt252>, HashState> {
    fn update_state(state: HashState, value: Span<felt252>) -> HashState {
        let mut result = state;
        for element in value {
            result = result.update(*element);
        };
        result
    }
}

pub impl ContractCallSpanHashImpl<HashState, +HashStateTrait<HashState>, +Drop<HashState>> of Hash<Span<ContractCall>, HashState> {
    fn update_state(state: HashState, value: Span<ContractCall>) -> HashState {
        let mut result = state;
        for element in value {
            result = result.update_with(*element);
        };
        result
    }
}

#[derive(Drop, Hash, Copy, Serde, Debug)]
pub struct ContractCall {
    pub address: ContractAddress,
    pub entrypoint: felt252,
    pub calldata: Span<felt252>
}
