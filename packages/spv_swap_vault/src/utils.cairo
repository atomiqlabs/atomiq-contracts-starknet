use core::traits::Add;

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

pub impl U64TupleAdd of Add::<(u64, u64)> {

    fn add(lhs: (u64, u64), rhs: (u64, u64)) -> (u64, u64) {
        let (val00, val01) = lhs;
        let (val10, val11) = rhs;
        (val00 + val10, val01 + val11)
    }

}

pub fn fee_amount(amount: u64, fee_u20: u32) -> Option<u64> {
    let result: u128 = amount.into() * fee_u20.into() / 100000;
    result.try_into()
}
