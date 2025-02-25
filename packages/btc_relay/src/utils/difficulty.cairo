use crate::constants;

#[cfg(target: 'test')]
use core::integer::{u512_safe_div_rem_by_u256};
#[cfg(target: 'test')]
use core::num::traits::WideMul;

//Pre-calculated multiples for target timespan
pub const TARGET_TIMESPAN_DIV_4: u32 = constants::TARGET_TIMESPAN_u32 / 4;
pub const TARGET_TIMESPAN_MUL_4: u32 = constants::TARGET_TIMESPAN_u32 * 4;

//////////////////////////////
// ENABLED FOR TESTING ONLY //
//////////////////////////////
//Difficulty retargetting algorithm
//https://minerdaily.com/2021/how-are-bitcoins-difficulty-and-hash-rate-calculated/#Difficulty_Adjustments
// new_difficulty_target = prev_difficulty_target * (timespan / target_timespan)
//This is adjusted to skip verification of the MAX_TARGET, to allow for testing with higher target (lower difficulties)
//Also u512 multiplication is implemented, because the u256 multiplication overflows on high targets
#[cfg(target: 'test')]
#[inline(always)]
pub fn compute_new_target_test(prev_time: u32, start_time: u32, prev_target: u256) -> u256 {
    let mut time_span = prev_time - start_time;

    //Difficulty increase/decrease multiples are clamped between 0.25 (-75%) and 4 (+300%)
    if time_span < TARGET_TIMESPAN_DIV_4 {
        time_span = TARGET_TIMESPAN_DIV_4;
    }
    if time_span > TARGET_TIMESPAN_MUL_4 {
        time_span = TARGET_TIMESPAN_MUL_4;
    }

    let (quotient, _) = u512_safe_div_rem_by_u256(prev_target.wide_mul(time_span.into()), constants::TARGET_TIMESPAN.try_into().unwrap());
    let new_target: u256 = quotient.try_into().unwrap();
    return new_target;
}

//Difficulty retargetting algorithm
//https://minerdaily.com/2021/how-are-bitcoins-difficulty-and-hash-rate-calculated/#Difficulty_Adjustments
// new_difficulty_target = prev_difficulty_target * (timespan / target_timespan)
#[inline(always)]
pub fn compute_new_target_release(prev_time: u32, start_time: u32, prev_target: u256) -> u256 {
    let mut time_span = prev_time - start_time;

    //Difficulty increase/decrease multiples are clamped between 0.25 (-75%) and 4 (+300%)
    if time_span < TARGET_TIMESPAN_DIV_4 {
        time_span = TARGET_TIMESPAN_DIV_4;
    }
    if time_span > TARGET_TIMESPAN_MUL_4 {
        time_span = TARGET_TIMESPAN_MUL_4;
    }

    let new_target = prev_target * time_span.into() / constants::TARGET_TIMESPAN;

    //Check if the target isn't past maximum allowed target (lowest possible mining difficulty)
    //https://en.bitcoin.it/wiki/Target#What_is_the_maximum_target.3F
    if new_target > constants::UNROUNDED_MAX_TARGET {
        return constants::UNROUNDED_MAX_TARGET;
    }

    new_target
}

//We use different implementation for this function for testing purposes, to allow
// us to use higher PoW targets and generate test blockheaders with lower difficulty
#[cfg(target: 'test')]
pub fn compute_new_target(prev_time: u32, start_time: u32, prev_target: u256) -> u256 {
    compute_new_target_test(prev_time, start_time, prev_target)
}
#[cfg(target: 'lib')]
pub fn compute_new_target(prev_time: u32, start_time: u32, prev_target: u256) -> u256 {
    compute_new_target_release(prev_time, start_time, prev_target)
}
#[cfg(target: 'starknet-contract')]
pub fn compute_new_target(prev_time: u32, start_time: u32, prev_target: u256) -> u256 {
    compute_new_target_release(prev_time, start_time, prev_target)
}

//Compute chainwork according to bitcoin core implementation
// https://github.com/bitcoin/bitcoin/blob/master/src/chain.cpp#L131
pub fn get_chainwork(target: u256) -> u256 {
    (~target / (target + 1)) + 1
}
