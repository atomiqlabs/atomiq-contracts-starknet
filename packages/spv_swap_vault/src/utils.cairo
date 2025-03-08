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


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn to_u256() {
        let input: [u32; 8] = [0x00010203, 0x04050607, 0x08090a0b, 0x0c0d0e0f, 0x10111213, 0x14151617, 0x18191a1b, 0x1c1d1e1f];
        assert_eq!(input.to_u256(), 0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f);
        
        let input: [u32; 8] = [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000001];
        assert_eq!(input.to_u256(), 0x0000000000000000000000000000000000000000000000000000000000000001);
        
        let input: [u32; 8] = [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff];
        assert_eq!(input.to_u256(), 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff);
        
        let input: [u32; 8] = [0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0x00000000, 0x00000000, 0x00000000, 0x00000000];
        assert_eq!(input.to_u256(), 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000);
        
        let input: [u32; 8] = [0xff00ff00, 0xff00ff00, 0xff00ff00, 0xff00ff00, 0x00ff00ff, 0x00ff00ff, 0x00ff00ff, 0x00ff00ff];
        assert_eq!(input.to_u256(), 0xff00ff00ff00ff00ff00ff00ff00ff0000ff00ff00ff00ff00ff00ff00ff00ff);
        
        let input: [u32; 8] = [0x01000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000];
        assert_eq!(input.to_u256(), 0x0100000000000000000000000000000000000000000000000000000000000000);
        
        let input: [u32; 8] = [0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff];
        assert_eq!(input.to_u256(), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        
        let input: [u32; 8] = [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000];
        assert_eq!(input.to_u256(), 0x0000000000000000000000000000000000000000000000000000000000000000);
    }

    #[test]
    fn tuple_add_u64() {
        assert_eq!((3123, 6543) + (842, 421), (3123 + 842, 6543 + 421));
        assert_eq!((0, 0) + (0, 0), (0, 0));
        assert_eq!((12312, 0) + (0, 0), (12312, 0));
        assert_eq!((0, 634) + (0, 0), (0, 634));
        assert_eq!((0, 0) + (25214, 0), (25214, 0));
        assert_eq!((0, 0) + (0, 124235324), (0, 124235324));
    }

    #[test]
    fn test_fee_amount() {
        assert_eq!(fee_amount(112312, 10000).unwrap(), 11231);
        assert_eq!(fee_amount(4865356465, 1000).unwrap(), 48653564);
        assert_eq!(fee_amount(446846514, 48854).unwrap(), 218302395);
        assert_eq!(fee_amount(84884684684486, 0).unwrap(), 0);
        assert_eq!(fee_amount(0xFFFFFFFFFFFFFFFF, 100000).unwrap(), 0xFFFFFFFFFFFFFFFF);
    }

    #[test]
    fn test_fee_amount_overflow() {
        assert_eq!(fee_amount(0xFFFFFFFFFFFFFFFF, 110000).is_none(), true);
        assert_eq!(fee_amount(0xEFFFFFFFFFFFFFFF, 1000000).is_none(), true);
    }

}
