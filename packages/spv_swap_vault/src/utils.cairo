use core::integer::{u512_safe_div_rem_by_u256};
use core::num::traits::WideMul;

#[generate_trait]
pub impl U32ArrayToU256Parser of U32ArrayToU256ParserTrait {
    //Parse u256 from a a fixed-length u32 array (an output of the sha256 hash function)
    fn to_u256(self: [u32; 8]) -> u256 {
        let span = self.span();

        let high: felt252 = (*span[0]).into() * 0x1000000000000000000000000
            + (*span[1]).into() * 0x10000000000000000
            + (*span[2]).into() * 0x100000000
            + (*span[3]).into();

            let low: felt252 = (*span[4]).into() * 0x1000000000000000000000000
            + (*span[5]).into() * 0x10000000000000000
            + (*span[6]).into() * 0x100000000
            + (*span[7]).into();

        u256 {
            low: low.try_into().unwrap(),
            high: high.try_into().unwrap()
        }
    }
}

pub fn fee_amount(amount: u256, fee: u16) -> u256 {
    let (quotient, _) = u512_safe_div_rem_by_u256(amount.wide_mul(fee.into()), 65535);
    //Note that this is a safe cast, since we are passing u16 value to the multiplication & dividing by 2^16 - 1,
    // such that the resulting value will always be at most 2^256 - 1
    quotient.try_into().unwrap()
}
