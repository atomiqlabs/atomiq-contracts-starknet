fn one_shift_left_bytes_u256(n_bytes: usize) -> u256 {
    match n_bytes {
        0 => 0x1,
        1 => 0x100,
        2 => 0x10000,
        3 => 0x1000000,
        4 => 0x100000000,
        5 => 0x10000000000,
        6 => 0x1000000000000,
        7 => 0x100000000000000,
        8 => 0x10000000000000000,
        9 => 0x1000000000000000000,
        10 => 0x100000000000000000000,
        11 => 0x10000000000000000000000,
        12 => 0x1000000000000000000000000,
        13 => 0x100000000000000000000000000,
        14 => 0x10000000000000000000000000000,
        15 => 0x1000000000000000000000000000000,
        16 => 0x100000000000000000000000000000000,
        17 => 0x10000000000000000000000000000000000,
        18 => 0x1000000000000000000000000000000000000,
        19 => 0x100000000000000000000000000000000000000,
        20 => 0x10000000000000000000000000000000000000000,
        21 => 0x1000000000000000000000000000000000000000000,
        22 => 0x100000000000000000000000000000000000000000000,
        23 => 0x10000000000000000000000000000000000000000000000,
        24 => 0x1000000000000000000000000000000000000000000000000,
        25 => 0x100000000000000000000000000000000000000000000000000,
        26 => 0x10000000000000000000000000000000000000000000000000000,
        27 => 0x1000000000000000000000000000000000000000000000000000000,
        28 => 0x100000000000000000000000000000000000000000000000000000000,
        29 => 0x10000000000000000000000000000000000000000000000000000000000,
        30 => 0x1000000000000000000000000000000000000000000000000000000000000,
        31 => 0x100000000000000000000000000000000000000000000000000000000000000,
        _ => panic(array!['n_bytes too large']),
    }
}

fn get_leading_zeroes_u128(num: u128) -> u32 {
    if num & 0xFF000000000000000000000000000000 != 0 {
        0
    } else if num & 0xFF0000000000000000000000000000 != 0 {
        1
    } else if num & 0xFF00000000000000000000000000 != 0 {
        2
    } else if num & 0xFF000000000000000000000000 != 0 {
        3
    } else if num & 0xFF0000000000000000000000 != 0 {
        4
    } else if num & 0xFF00000000000000000000 != 0 {
        5
    } else if num & 0xFF000000000000000000 != 0 {
        6
    } else if num & 0xFF0000000000000000 != 0 {
        7
    } else if num & 0xFF00000000000000 != 0 {
        8
    } else if num & 0xFF000000000000 != 0 {
        9
    } else if num & 0xFF0000000000 != 0 {
        10
    } else if num & 0xFF00000000 != 0 {
        11
    } else if num & 0xFF000000 != 0 {   
        12
    } else if num & 0xFF0000 != 0 {
        13
    } else if num & 0xFF00 != 0 {
        14
    } else if num & 0xFF != 0 {
        15
    } else {
        16
    }
}

pub type nbits = u32;

#[generate_trait]
pub impl nBitsConvertor of nBitsConvertorTrait {
    //Calculates difficulty target from nBits
    //Description: https://btcinformation.org/en/developer-reference#target-nbits
    //This implementation panics on negative and overflown targets
    fn to_target(self: nbits) -> u256 {
        let n_size = self & 0xFF;

        // let n_word: u32 = ((nbits / 0x100) & 0xFF) * 0x10000 +
        //     ((nbits / 0x10000) & 0xFF) * 0x100 +
        //     ((nbits / 0x1000000) & 0x7F);
        // Simplifies to:
        let n_word: u32 = (self & 0x7F00) * 0x100 +
            ((self / 0x100) & 0xFF00) +
            ((self / 0x1000000) & 0xFF);
    
        let result = if n_size < 3 {
            n_word.into() / one_shift_left_bytes_u256(3 - n_size)
        } else {
            n_word.into() * one_shift_left_bytes_u256(n_size - 3)
        };

        if result!=0 {
            assert(self & 0x8000 == 0, 'nbits: negative');
        }

        result
    }

    //Compresses difficulty target to nBits
    //Description: https://btcinformation.org/en/developer-reference#target-nbits
    fn to_nbits(self: u256) -> nbits {
        let mut n_size: u32 = if self.high == 0 {
            //Only low
            16 - get_leading_zeroes_u128(self.low)
        } else {
            //Only high
            32 - get_leading_zeroes_u128(self.high)
        };
    
        let mut result: u32 = if n_size < 3 {
            (self * one_shift_left_bytes_u256(3 - n_size)).low.try_into().unwrap()
        } else {
            (self / one_shift_left_bytes_u256(n_size - 3)).low.try_into().unwrap()
        };
    
        if (result & 0x00800000) == 0x00800000 {
            result /= 0x100;
            n_size += 1;
        }
        
        // (result & 0xFF) * 0x1000000 + ((result / 0x100) & 0xFF) * 0x10000 + ((result / 0x10000) & 0xFF) * 0x100 + n_size
        // Simplifies to:
        (result & 0xFF) * 0x1000000 + (result & 0xFF00) * 0x100 + ((result / 0x100) & 0xFF00) + n_size
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::utils::endianness::ReverseEndiannessTrait;

    #[test]
    fn test_nbits_to_target() {
        assert!(0x618c0217.to_target() == 0x028c610000000000000000000000000000000000000000);
    }

    #[test]
    fn test_target_to_nbits() {
        assert!(0x028c610000000000000000000000000000000000000000.to_nbits() == 0x618c0217);
    }

    //Test vectors from https://github.com/bitcoin/bitcoin/blob/master/src/test/arith_uint256_tests.cpp#L409
    #[test]
    fn bitcoin_core_test_vectors() {
        let target = 0_u32.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000000000000);
        assert!(target.to_nbits().rev_endianness() == 0);
        
        let target = 0x00123456_u32.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000000000000);
        assert!(target.to_nbits().rev_endianness() == 0);
        
        let target = 0x01003456_u32.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000000000000);
        assert!(target.to_nbits().rev_endianness() == 0);
        
        let target = 0x02000056_u32.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000000000000);
        assert!(target.to_nbits().rev_endianness() == 0);
        
        let target = 0x03000000_u32.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000000000000);
        assert!(target.to_nbits().rev_endianness() == 0);
        
        let target = 0x04000000_u32.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000000000000);
        assert!(target.to_nbits().rev_endianness() == 0);
        
        let target = 0x00923456_u32.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000000000000);
        assert!(target.to_nbits().rev_endianness() == 0);
        
        let target = 0x01803456_u32.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000000000000);
        assert!(target.to_nbits().rev_endianness() == 0);
        
        let target = 0x02800056_u32.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000000000000);
        assert!(target.to_nbits().rev_endianness() == 0);
        
        let target = 0x03800000_u32.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000000000000);
        assert!(target.to_nbits().rev_endianness() == 0);
        
        let target = 0x04800000_u32.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000000000000);
        assert!(target.to_nbits().rev_endianness() == 0);
    
        let target = 0x01123456_u32.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000000000012);
        assert!(target.to_nbits().rev_endianness() == 0x01120000);

        // Make sure that we don't generate compacts with the 0x00800000 bit set
        assert!(0x80_u256.to_nbits().rev_endianness() == 0x02008000);

        let target = 0x02123456.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000000001234);
        assert!(target.to_nbits().rev_endianness() == 0x02123400);

        let target = 0x03123456.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000000123456);
        assert!(target.to_nbits().rev_endianness() == 0x03123456);

        let target = 0x04123456.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000012345600);
        assert!(target.to_nbits().rev_endianness() == 0x04123456);

        let target = 0x05009234.rev_endianness().to_target();
        assert!(target == 0x0000000000000000000000000000000000000000000000000000000092340000);
        assert!(target.to_nbits().rev_endianness() == 0x05009234);

        let target = 0x20123456.rev_endianness().to_target();
        assert!(target == 0x1234560000000000000000000000000000000000000000000000000000000000);
        assert!(target.to_nbits().rev_endianness() == 0x20123456);
    }

    //invalid vectors from https://github.com/bitcoin/bitcoin/blob/master/src/test/arith_uint256_tests.cpp#L409
    #[test]
    #[should_panic(expected: 'nbits: negative')]
    fn bitcoin_core_negative_nbits_test_vector_1() {
        0x01fedcba.rev_endianness().to_target();
    }

    #[test]
    #[should_panic(expected: 'nbits: negative')]
    fn bitcoin_core_negative_nbits_test_vector_2() {
        0x04923456.rev_endianness().to_target();
    }

    #[test]
    #[should_panic(expected: 'n_bytes too large')]
    fn bitcoin_core_overflow_nbits_test_vector() {
        0xff123456.rev_endianness().to_target();
    }

}