use core::integer::{u512_safe_div_rem_by_u256};
use core::num::traits::WideMul;

use core::hash::{HashStateTrait, HashStateExTrait, Hash};

pub impl SpanHashImpl<HashState, +HashStateTrait<HashState>, +Drop<HashState>, T, +Hash<T, HashState>, +Copy<T>> of Hash<Span<T>, HashState> {
    fn update_state(state: HashState, value: Span<T>) -> HashState {
        let mut result = state;
        for element in value {
            result = result.update_with(*element);
        };
        result
    }
}

pub fn fee_amount(amount: u256, fee: u16) -> u256 {
    let (quotient, _) = u512_safe_div_rem_by_u256(amount.wide_mul(fee.into()), 65535);
    //Note that this is a safe cast, since we are passing u16 value to the multiplication & dividing by 2^16 - 1,
    // such that the resulting value will always be at most 2^256 - 1
    quotient.try_into().unwrap()
}
