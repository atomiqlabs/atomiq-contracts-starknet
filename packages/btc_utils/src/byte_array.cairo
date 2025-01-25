use core::sha256::{compute_sha256_byte_array, compute_sha256_u32_array};
use core::hash::{HashStateTrait};
use core::poseidon::PoseidonTrait;

fn one_shift_left_bytes_felt252(n_bytes: usize) -> felt252 {
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
        _ => panic(array!['n_bytes too large']),
    }
}

#[generate_trait]
pub impl ByteArrayReader of ByteArrayReaderTrait {

    fn read_u16_be(self: @ByteArray, index: usize) -> u16 {
        let result: felt252 = self.at(index+0).expect('Array index out of bounds').into() * 0x100
            + self.at(index+1).expect('Array index out of bounds').into();
        result.try_into().unwrap()
    }

    fn read_u16_le(self: @ByteArray, index: usize) -> u16 {
        let result: felt252 = self.at(index+1).expect('Array index out of bounds').into() * 0x100
            + self.at(index+0).expect('Array index out of bounds').into();
        result.try_into().unwrap()
    }

    fn read_u32_be(self: @ByteArray, index: usize) -> u32 {
        let result: felt252 = self.at(index+0).expect('Array index out of bounds').into() * 0x1000000
            + self.at(index+1).expect('Array index out of bounds').into() * 0x10000
            + self.at(index+2).expect('Array index out of bounds').into() * 0x100
            + self.at(index+3).expect('Array index out of bounds').into();
        result.try_into().unwrap()
    }

    fn read_u32_le(self: @ByteArray, index: usize) -> u32 {
        let result: felt252 = self.at(index+3).expect('Array index out of bounds').into() * 0x1000000
            + self.at(index+2).expect('Array index out of bounds').into() * 0x10000
            + self.at(index+1).expect('Array index out of bounds').into() * 0x100
            + self.at(index+0).expect('Array index out of bounds').into();
        result.try_into().unwrap()
    }

    fn read_u64_be(self: @ByteArray, index: usize) -> u64 {
        let result: felt252 = self.at(index+0).expect('Array index out of bounds').into() * 0x100000000000000
            + self.at(index+1).expect('Array index out of bounds').into() * 0x1000000000000
            + self.at(index+2).expect('Array index out of bounds').into() * 0x10000000000
            + self.at(index+3).expect('Array index out of bounds').into() * 0x100000000
            + self.at(index+4).expect('Array index out of bounds').into() * 0x1000000
            + self.at(index+5).expect('Array index out of bounds').into() * 0x10000
            + self.at(index+6).expect('Array index out of bounds').into() * 0x100
            + self.at(index+7).expect('Array index out of bounds').into();
        result.try_into().unwrap()
    }

    fn read_u64_le(self: @ByteArray, index: usize) -> u64 {
        let result: felt252 = self.at(index+7).expect('Array index out of bounds').into() * 0x100000000000000
            + self.at(index+6).expect('Array index out of bounds').into() * 0x1000000000000
            + self.at(index+5).expect('Array index out of bounds').into() * 0x10000000000
            + self.at(index+4).expect('Array index out of bounds').into() * 0x100000000
            + self.at(index+3).expect('Array index out of bounds').into() * 0x1000000
            + self.at(index+2).expect('Array index out of bounds').into() * 0x10000
            + self.at(index+1).expect('Array index out of bounds').into() * 0x100
            + self.at(index+0).expect('Array index out of bounds').into();
        result.try_into().unwrap()
    }

    fn read_u128_be(self: @ByteArray, index: usize) -> u128 {
        let result: felt252 = self.at(index+0).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000
            + self.at(index+1).expect('Array index out of bounds').into() * 0x10000000000000000000000000000
            + self.at(index+2).expect('Array index out of bounds').into() * 0x100000000000000000000000000
            + self.at(index+3).expect('Array index out of bounds').into() * 0x1000000000000000000000000
            + self.at(index+4).expect('Array index out of bounds').into() * 0x10000000000000000000000
            + self.at(index+5).expect('Array index out of bounds').into() * 0x100000000000000000000
            + self.at(index+6).expect('Array index out of bounds').into() * 0x1000000000000000000
            + self.at(index+7).expect('Array index out of bounds').into() * 0x10000000000000000
            + self.at(index+8).expect('Array index out of bounds').into() * 0x100000000000000
            + self.at(index+9).expect('Array index out of bounds').into() * 0x1000000000000
            + self.at(index+10).expect('Array index out of bounds').into() * 0x10000000000
            + self.at(index+11).expect('Array index out of bounds').into() * 0x100000000
            + self.at(index+12).expect('Array index out of bounds').into() * 0x1000000
            + self.at(index+13).expect('Array index out of bounds').into() * 0x10000
            + self.at(index+14).expect('Array index out of bounds').into() * 0x100
            + self.at(index+15).expect('Array index out of bounds').into();
        result.try_into().unwrap()
    }

    fn read_u128_le(self: @ByteArray, index: usize) -> u128 {
        let result: felt252 = self.at(index+15).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000
            + self.at(index+14).expect('Array index out of bounds').into() * 0x10000000000000000000000000000
            + self.at(index+13).expect('Array index out of bounds').into() * 0x100000000000000000000000000
            + self.at(index+12).expect('Array index out of bounds').into() * 0x1000000000000000000000000
            + self.at(index+11).expect('Array index out of bounds').into() * 0x10000000000000000000000
            + self.at(index+10).expect('Array index out of bounds').into() * 0x100000000000000000000
            + self.at(index+9).expect('Array index out of bounds').into() * 0x1000000000000000000
            + self.at(index+8).expect('Array index out of bounds').into() * 0x10000000000000000
            + self.at(index+7).expect('Array index out of bounds').into() * 0x100000000000000
            + self.at(index+6).expect('Array index out of bounds').into() * 0x1000000000000
            + self.at(index+5).expect('Array index out of bounds').into() * 0x10000000000
            + self.at(index+4).expect('Array index out of bounds').into() * 0x100000000
            + self.at(index+3).expect('Array index out of bounds').into() * 0x1000000
            + self.at(index+2).expect('Array index out of bounds').into() * 0x10000
            + self.at(index+1).expect('Array index out of bounds').into() * 0x100
            + self.at(index+0).expect('Array index out of bounds').into();
        result.try_into().unwrap()
    }

    fn read_u256_be(self: @ByteArray, index: usize) -> u256 {
        let high: felt252 = self.at(index+0).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000
            + self.at(index+1).expect('Array index out of bounds').into() * 0x10000000000000000000000000000
            + self.at(index+2).expect('Array index out of bounds').into() * 0x100000000000000000000000000
            + self.at(index+3).expect('Array index out of bounds').into() * 0x1000000000000000000000000
            + self.at(index+4).expect('Array index out of bounds').into() * 0x10000000000000000000000
            + self.at(index+5).expect('Array index out of bounds').into() * 0x100000000000000000000
            + self.at(index+6).expect('Array index out of bounds').into() * 0x1000000000000000000
            + self.at(index+7).expect('Array index out of bounds').into() * 0x10000000000000000
            + self.at(index+8).expect('Array index out of bounds').into() * 0x100000000000000
            + self.at(index+9).expect('Array index out of bounds').into() * 0x1000000000000
            + self.at(index+10).expect('Array index out of bounds').into() * 0x10000000000
            + self.at(index+11).expect('Array index out of bounds').into() * 0x100000000
            + self.at(index+12).expect('Array index out of bounds').into() * 0x1000000
            + self.at(index+13).expect('Array index out of bounds').into() * 0x10000
            + self.at(index+14).expect('Array index out of bounds').into() * 0x100
            + self.at(index+15).expect('Array index out of bounds').into();

        let low: felt252 = self.at(index+16).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000
            + self.at(index+17).expect('Array index out of bounds').into() * 0x10000000000000000000000000000
            + self.at(index+18).expect('Array index out of bounds').into() * 0x100000000000000000000000000
            + self.at(index+19).expect('Array index out of bounds').into() * 0x1000000000000000000000000
            + self.at(index+20).expect('Array index out of bounds').into() * 0x10000000000000000000000
            + self.at(index+21).expect('Array index out of bounds').into() * 0x100000000000000000000
            + self.at(index+22).expect('Array index out of bounds').into() * 0x1000000000000000000
            + self.at(index+23).expect('Array index out of bounds').into() * 0x10000000000000000
            + self.at(index+24).expect('Array index out of bounds').into() * 0x100000000000000
            + self.at(index+25).expect('Array index out of bounds').into() * 0x1000000000000
            + self.at(index+26).expect('Array index out of bounds').into() * 0x10000000000
            + self.at(index+27).expect('Array index out of bounds').into() * 0x100000000
            + self.at(index+28).expect('Array index out of bounds').into() * 0x1000000
            + self.at(index+29).expect('Array index out of bounds').into() * 0x10000
            + self.at(index+30).expect('Array index out of bounds').into() * 0x100
            + self.at(index+31).expect('Array index out of bounds').into();

        return u256 {
            low: low.try_into().unwrap(),
            high: high.try_into().unwrap()
        };
    }

    fn read_u256_le(self: @ByteArray, index: usize) -> u256 {
        let high: felt252 = self.at(index+31).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000
            + self.at(index+30).expect('Array index out of bounds').into() * 0x10000000000000000000000000000
            + self.at(index+29).expect('Array index out of bounds').into() * 0x100000000000000000000000000
            + self.at(index+28).expect('Array index out of bounds').into() * 0x1000000000000000000000000
            + self.at(index+27).expect('Array index out of bounds').into() * 0x10000000000000000000000
            + self.at(index+26).expect('Array index out of bounds').into() * 0x100000000000000000000
            + self.at(index+25).expect('Array index out of bounds').into() * 0x1000000000000000000
            + self.at(index+24).expect('Array index out of bounds').into() * 0x10000000000000000
            + self.at(index+23).expect('Array index out of bounds').into() * 0x100000000000000
            + self.at(index+22).expect('Array index out of bounds').into() * 0x1000000000000
            + self.at(index+21).expect('Array index out of bounds').into() * 0x10000000000
            + self.at(index+20).expect('Array index out of bounds').into() * 0x100000000
            + self.at(index+19).expect('Array index out of bounds').into() * 0x1000000
            + self.at(index+18).expect('Array index out of bounds').into() * 0x10000
            + self.at(index+17).expect('Array index out of bounds').into() * 0x100
            + self.at(index+16).expect('Array index out of bounds').into();

        let low: felt252 = self.at(index+15).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000
            + self.at(index+14).expect('Array index out of bounds').into() * 0x10000000000000000000000000000
            + self.at(index+13).expect('Array index out of bounds').into() * 0x100000000000000000000000000
            + self.at(index+12).expect('Array index out of bounds').into() * 0x1000000000000000000000000
            + self.at(index+11).expect('Array index out of bounds').into() * 0x10000000000000000000000
            + self.at(index+10).expect('Array index out of bounds').into() * 0x100000000000000000000
            + self.at(index+9).expect('Array index out of bounds').into() * 0x1000000000000000000
            + self.at(index+8).expect('Array index out of bounds').into() * 0x10000000000000000
            + self.at(index+7).expect('Array index out of bounds').into() * 0x100000000000000
            + self.at(index+6).expect('Array index out of bounds').into() * 0x1000000000000
            + self.at(index+5).expect('Array index out of bounds').into() * 0x10000000000
            + self.at(index+4).expect('Array index out of bounds').into() * 0x100000000
            + self.at(index+3).expect('Array index out of bounds').into() * 0x1000000
            + self.at(index+2).expect('Array index out of bounds').into() * 0x10000
            + self.at(index+1).expect('Array index out of bounds').into() * 0x100
            + self.at(index+0).expect('Array index out of bounds').into();

        return u256 {
            low: low.try_into().unwrap(),
            high: high.try_into().unwrap()
        };
    }

    fn read_felt252(self: @ByteArray, index: usize) -> felt252 {
        let result: felt252 = self.at(index+0).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000000000000000000000000000000000
            + self.at(index+1).expect('Array index out of bounds').into() * 0x10000000000000000000000000000000000000000000000000000000000
            + self.at(index+2).expect('Array index out of bounds').into() * 0x100000000000000000000000000000000000000000000000000000000
            + self.at(index+3).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000000000000000000000000000
            + self.at(index+4).expect('Array index out of bounds').into() * 0x10000000000000000000000000000000000000000000000000000
            + self.at(index+5).expect('Array index out of bounds').into() * 0x100000000000000000000000000000000000000000000000000
            + self.at(index+6).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000000000000000000000
            + self.at(index+7).expect('Array index out of bounds').into() * 0x10000000000000000000000000000000000000000000000
            + self.at(index+8).expect('Array index out of bounds').into() * 0x100000000000000000000000000000000000000000000
            + self.at(index+9).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000000000000000
            + self.at(index+10).expect('Array index out of bounds').into() * 0x10000000000000000000000000000000000000000
            + self.at(index+11).expect('Array index out of bounds').into() * 0x100000000000000000000000000000000000000
            + self.at(index+12).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000000000
            + self.at(index+13).expect('Array index out of bounds').into() * 0x10000000000000000000000000000000000
            + self.at(index+14).expect('Array index out of bounds').into() * 0x100000000000000000000000000000000
            + self.at(index+15).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000
            + self.at(index+16).expect('Array index out of bounds').into() * 0x10000000000000000000000000000
            + self.at(index+17).expect('Array index out of bounds').into() * 0x100000000000000000000000000
            + self.at(index+18).expect('Array index out of bounds').into() * 0x1000000000000000000000000
            + self.at(index+19).expect('Array index out of bounds').into() * 0x10000000000000000000000
            + self.at(index+20).expect('Array index out of bounds').into() * 0x100000000000000000000
            + self.at(index+21).expect('Array index out of bounds').into() * 0x1000000000000000000
            + self.at(index+22).expect('Array index out of bounds').into() * 0x10000000000000000
            + self.at(index+23).expect('Array index out of bounds').into() * 0x100000000000000
            + self.at(index+24).expect('Array index out of bounds').into() * 0x1000000000000
            + self.at(index+25).expect('Array index out of bounds').into() * 0x10000000000
            + self.at(index+26).expect('Array index out of bounds').into() * 0x100000000
            + self.at(index+27).expect('Array index out of bounds').into() * 0x1000000
            + self.at(index+28).expect('Array index out of bounds').into() * 0x10000
            + self.at(index+29).expect('Array index out of bounds').into() * 0x100
            + self.at(index+30).expect('Array index out of bounds').into();
        result
    }

    fn read_partial_felt252(self: @ByteArray, index: usize, size: usize) -> felt252 {
        let mut result: felt252 = 0;
        for i in 0..size {
            result += self.at(index+i).expect('Array index out of bounds').into() * one_shift_left_bytes_felt252(size-i-1);
        };
        result
    }

    fn hash_sha256(self: @ByteArray) -> [u32; 8] {
        compute_sha256_byte_array(self)
    }

    fn hash_dbl_sha256(self: @ByteArray) -> [u32; 8] {
        let result = compute_sha256_byte_array(self).span();
        compute_sha256_u32_array(array![
            *result[0], *result[1], *result[2], *result[3], *result[4], *result[5], *result[6], *result[7]
        ], 0, 0)
    }

    fn hash_poseidon_range(self: @ByteArray, start_index: usize, end_index: usize) -> felt252 {
        let mut hasher = PoseidonTrait::new();
        let mut index = start_index;
        while index < end_index {
            let remaining = end_index - index;
            let hash_value: felt252 = if remaining < 31 {
                self.read_partial_felt252(index, remaining)
            } else {
                self.read_felt252(index)
            };
            hasher = hasher.update(hash_value);
            index += 31;
        };
        hasher.finalize()
    }
    
}


#[cfg(test)]
mod tests {
    use super::*;

    //Tests generated by scripts/tests_unit/byte_array.js

    #[test]
    fn test_random() {
        // Random test cases testing all the functionality

        let mut serialized_byte_array = array![0x2, 0x0680f0f7cd9409d11fbb446897668402a063dba41d241c486cdf3daefda89d, 0x2e3b8a0c28323898967a1afcfe09af39036a4c7a656bfd043141c44a361df2, 0xf8f16fa9eb, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(21), 0x1c24);
        assert_eq!(buffer.read_u16_be(64), 0x6fa9);
        assert_eq!(buffer.read_u32_le(62), 0xa96ff1f8);
        assert_eq!(buffer.read_u32_be(52), 0x6bfd0431);
        assert_eq!(buffer.read_u64_le(9), 0xa0028466976844bb);
        assert_eq!(buffer.read_u64_be(13), 0x668402a063dba41d);
        assert_eq!(buffer.read_u128_le(38), 0xfd6b657a4c6a0339af09fefc1a7a9698);
        assert_eq!(buffer.read_u128_be(38), 0x98967a1afcfe09af39036a4c7a656bfd);
        assert_eq!(buffer.read_u256_le(24), 0x3104fd6b657a4c6a0339af09fefc1a7a96983832280c8a3b2e9da8fdae3ddf6c);
        assert_eq!(buffer.read_u256_be(2), 0xf0f7cd9409d11fbb446897668402a063dba41d241c486cdf3daefda89d2e3b8a);
        assert_eq!(buffer.read_felt252(33), 0x8a0c28323898967a1afcfe09af39036a4c7a656bfd043141c44a361df2f8f1);
        assert_eq!(buffer.read_partial_felt252(52, 1), 0x6b);
        assert_eq!(buffer.read_partial_felt252(56, 2), 0x41c4);
        assert_eq!(buffer.read_partial_felt252(2, 3), 0xf0f7cd);
        assert_eq!(buffer.read_partial_felt252(40, 4), 0x7a1afcfe);
        assert_eq!(buffer.read_partial_felt252(58, 5), 0x4a361df2f8);
        assert_eq!(buffer.read_partial_felt252(29, 6), 0xa89d2e3b8a0c);
        assert_eq!(buffer.read_partial_felt252(55, 7), 0x3141c44a361df2);
        assert_eq!(buffer.read_partial_felt252(33, 8), 0x8a0c28323898967a);
        assert_eq!(buffer.read_partial_felt252(21, 9), 0x241c486cdf3daefda8);
        assert_eq!(buffer.read_partial_felt252(11, 10), 0x6897668402a063dba41d);
        assert_eq!(buffer.read_partial_felt252(26, 11), 0x3daefda89d2e3b8a0c2832);
        assert_eq!(buffer.read_partial_felt252(21, 12), 0x241c486cdf3daefda89d2e3b);
        assert_eq!(buffer.read_partial_felt252(49, 13), 0x4c7a656bfd043141c44a361df2);
        assert_eq!(buffer.read_partial_felt252(29, 14), 0xa89d2e3b8a0c28323898967a1afc);
        assert_eq!(buffer.read_partial_felt252(24, 15), 0x6cdf3daefda89d2e3b8a0c28323898);
        assert_eq!(buffer.read_partial_felt252(1, 16), 0x80f0f7cd9409d11fbb446897668402a0);
        assert_eq!(buffer.read_partial_felt252(6, 17), 0x09d11fbb446897668402a063dba41d241c);
        assert_eq!(buffer.read_partial_felt252(22, 18), 0x1c486cdf3daefda89d2e3b8a0c2832389896);
        assert_eq!(buffer.read_partial_felt252(47, 19), 0x036a4c7a656bfd043141c44a361df2f8f16fa9);
        assert_eq!(buffer.read_partial_felt252(6, 20), 0x09d11fbb446897668402a063dba41d241c486cdf);
        assert_eq!(buffer.read_partial_felt252(40, 21), 0x7a1afcfe09af39036a4c7a656bfd043141c44a361d);
        assert_eq!(buffer.read_partial_felt252(26, 22), 0x3daefda89d2e3b8a0c28323898967a1afcfe09af3903);
        assert_eq!(buffer.read_partial_felt252(21, 23), 0x241c486cdf3daefda89d2e3b8a0c28323898967a1afcfe);
        assert_eq!(buffer.read_partial_felt252(15, 24), 0x02a063dba41d241c486cdf3daefda89d2e3b8a0c28323898);
        assert_eq!(buffer.read_partial_felt252(1, 25), 0x80f0f7cd9409d11fbb446897668402a063dba41d241c486cdf);
        assert_eq!(buffer.read_partial_felt252(6, 26), 0x09d11fbb446897668402a063dba41d241c486cdf3daefda89d2e);
        assert_eq!(buffer.read_partial_felt252(22, 27), 0x1c486cdf3daefda89d2e3b8a0c28323898967a1afcfe09af39036a);
        assert_eq!(buffer.read_partial_felt252(31, 28), 0x2e3b8a0c28323898967a1afcfe09af39036a4c7a656bfd043141c44a);
        assert_eq!(buffer.read_partial_felt252(9, 29), 0xbb446897668402a063dba41d241c486cdf3daefda89d2e3b8a0c283238);
        assert_eq!(buffer.read_partial_felt252(28, 30), 0xfda89d2e3b8a0c28323898967a1afcfe09af39036a4c7a656bfd043141c4);
        assert_eq!(buffer.read_partial_felt252(2, 31), 0xf0f7cd9409d11fbb446897668402a063dba41d241c486cdf3daefda89d2e3b);
        assert_eq!(buffer.hash_sha256(), [0x6eb3292f, 0x91800fa1, 0x72b3d7b6, 0x7ed55a54, 0x5aacfffd, 0xd4094452, 0xe7aaac00, 0x6b986ddf]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xb5dec003, 0x7a1c0ca2, 0x63200e11, 0xf7d53a3e, 0x0ee368be, 0xa96e65aa, 0x142e4856, 0x824e9654]);
        assert_eq!(buffer.hash_poseidon_range(35, 62), 0x778b6ae29cfa0e3b6020feca1182e5b845538160caac989e906527e7cfaeb2e);
        assert_eq!(buffer.hash_poseidon_range(35, 47), 0x5ba73c1c6d41d989d824f92021deeb9f498d10c13a929cbf7fa3eb3ecde7b0a);
        assert_eq!(buffer.hash_poseidon_range(58, 66), 0x5e3858ca34b6924e66979c9fb0ca23c54990dfb28cd93263dd96ff3c167d12a);
        assert_eq!(buffer.hash_poseidon_range(0, 16), 0x3225b0ba591057f0202c4ace9efd57555d00420703d3e4d966643fe64eada60);
        assert_eq!(buffer.hash_poseidon_range(18, 66), 0x13bf6985bd5d6959fc8504a75f75f12659af4eb6299adf010cf50ceccbbad3e);

        let mut serialized_byte_array = array![0x0, 0x76d3613933c8de6b430bdb092470b0ce6c6cdb7c99, 0x15].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(5), 0xdec8);
        assert_eq!(buffer.read_u16_be(0), 0x76d3);
        assert_eq!(buffer.read_u32_le(7), 0xdb0b436b);
        assert_eq!(buffer.read_u32_be(4), 0x33c8de6b);
        assert_eq!(buffer.read_u64_le(0), 0x6bdec8333961d376);
        assert_eq!(buffer.read_u64_be(10), 0xdb092470b0ce6c6c);
        assert_eq!(buffer.read_u128_le(0), 0xceb0702409db0b436bdec8333961d376);
        assert_eq!(buffer.read_u128_be(3), 0x3933c8de6b430bdb092470b0ce6c6cdb);
        assert_eq!(buffer.read_partial_felt252(16, 1), 0x6c);
        assert_eq!(buffer.read_partial_felt252(5, 2), 0xc8de);
        assert_eq!(buffer.read_partial_felt252(10, 3), 0xdb0924);
        assert_eq!(buffer.read_partial_felt252(4, 4), 0x33c8de6b);
        assert_eq!(buffer.read_partial_felt252(10, 5), 0xdb092470b0);
        assert_eq!(buffer.read_partial_felt252(1, 6), 0xd3613933c8de);
        assert_eq!(buffer.read_partial_felt252(6, 7), 0xde6b430bdb0924);
        assert_eq!(buffer.read_partial_felt252(4, 8), 0x33c8de6b430bdb09);
        assert_eq!(buffer.read_partial_felt252(1, 9), 0xd3613933c8de6b430b);
        assert_eq!(buffer.read_partial_felt252(1, 10), 0xd3613933c8de6b430bdb);
        assert_eq!(buffer.read_partial_felt252(3, 11), 0x3933c8de6b430bdb092470);
        assert_eq!(buffer.read_partial_felt252(7, 12), 0x6b430bdb092470b0ce6c6cdb);
        assert_eq!(buffer.read_partial_felt252(4, 13), 0x33c8de6b430bdb092470b0ce6c);
        assert_eq!(buffer.read_partial_felt252(6, 14), 0xde6b430bdb092470b0ce6c6cdb7c);
        assert_eq!(buffer.read_partial_felt252(0, 15), 0x76d3613933c8de6b430bdb092470b0);
        assert_eq!(buffer.read_partial_felt252(1, 16), 0xd3613933c8de6b430bdb092470b0ce6c);
        assert_eq!(buffer.read_partial_felt252(3, 17), 0x3933c8de6b430bdb092470b0ce6c6cdb7c);
        assert_eq!(buffer.read_partial_felt252(1, 18), 0xd3613933c8de6b430bdb092470b0ce6c6cdb);
        assert_eq!(buffer.read_partial_felt252(0, 19), 0x76d3613933c8de6b430bdb092470b0ce6c6cdb);
        assert_eq!(buffer.read_partial_felt252(0, 20), 0x76d3613933c8de6b430bdb092470b0ce6c6cdb7c);
        assert_eq!(buffer.read_partial_felt252(0, 21), 0x76d3613933c8de6b430bdb092470b0ce6c6cdb7c99);
        assert_eq!(buffer.hash_sha256(), [0x4ab07d11, 0x3641e78b, 0xd4e2dd6a, 0x38f8a4e1, 0x733ffffa, 0xd93b7f4d, 0x1ef1cbf7, 0x16295812]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xcd24ffb4, 0xeac86973, 0x6a8f6c2f, 0x41ad9a4e, 0xf9ba273b, 0xc84b2604, 0x62f2d5c8, 0x5ccafb23]);
        assert_eq!(buffer.hash_poseidon_range(14, 16), 0x3c71e398b1c821a3f99cc29727ebdec561ab1eb0677063587ffc5af6cb1f97);
        assert_eq!(buffer.hash_poseidon_range(16, 17), 0x1ed72b7ff48c6898a1a9b1ac87d189df2346736ee4c07c15901c0ef0c775e4b);
        assert_eq!(buffer.hash_poseidon_range(5, 6), 0x3ce0652164efa47a5fdd35e0431ab5cc315e66891fb452a637604579aaef3e9);
        assert_eq!(buffer.hash_poseidon_range(7, 11), 0x1342ae178bb9f50e139abe7cd521d483e4f5f3bff5b85b8a60c8244628d34d3);
        assert_eq!(buffer.hash_poseidon_range(3, 19), 0x4bb0bdd267c7e7bda99ac802cae8f67c72c6000bf8e0aa4618f452c8656b0f1);

        let mut serialized_byte_array = array![0x3, 0x913a7ad0a3de964578d7878270a4874bdb3b65dbe782940f16c897fb8a734e, 0xf6632d23a4ba88ec7e60fd32acceb049535be6788c3c4a817a0ef66a47455e, 0xa53b82c2b2c2b62539810c2a35fe4d686148f9c796fcdd49643eed7ffdd719, 0x58b84eaad1ce0cd4203cd0eb5f5b238bf02905ed, 0x14].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(55), 0xe7a);
        assert_eq!(buffer.read_u16_be(93), 0x58b8);
        assert_eq!(buffer.read_u32_le(38), 0xfd607eec);
        assert_eq!(buffer.read_u32_be(80), 0xf9c796fc);
        assert_eq!(buffer.read_u64_le(45), 0x3c8c78e65b5349b0);
        assert_eq!(buffer.read_u64_be(49), 0xe6788c3c4a817a0e);
        assert_eq!(buffer.read_u128_le(22), 0x88baa4232d63f64e738afb97c8160f94);
        assert_eq!(buffer.read_u128_be(31), 0xf6632d23a4ba88ec7e60fd32acceb049);
        assert_eq!(buffer.read_u256_le(48), 0x4861684dfe352a0c813925b6c2b2c2823ba55e45476af60e7a814a3c8c78e65b);
        assert_eq!(buffer.read_u256_be(68), 0xb62539810c2a35fe4d686148f9c796fcdd49643eed7ffdd71958b84eaad1ce0c);
        assert_eq!(buffer.read_felt252(56), 0x0ef66a47455ea53b82c2b2c2b62539810c2a35fe4d686148f9c796fcdd4964);
        assert_eq!(buffer.read_partial_felt252(97, 1), 0xd1);
        assert_eq!(buffer.read_partial_felt252(53, 2), 0x4a81);
        assert_eq!(buffer.read_partial_felt252(96, 3), 0xaad1ce);
        assert_eq!(buffer.read_partial_felt252(93, 4), 0x58b84eaa);
        assert_eq!(buffer.read_partial_felt252(84, 5), 0xdd49643eed);
        assert_eq!(buffer.read_partial_felt252(30, 6), 0x4ef6632d23a4);
        assert_eq!(buffer.read_partial_felt252(80, 7), 0xf9c796fcdd4964);
        assert_eq!(buffer.read_partial_felt252(12, 8), 0x70a4874bdb3b65db);
        assert_eq!(buffer.read_partial_felt252(70, 9), 0x39810c2a35fe4d6861);
        assert_eq!(buffer.read_partial_felt252(68, 10), 0xb62539810c2a35fe4d68);
        assert_eq!(buffer.read_partial_felt252(4, 11), 0xa3de964578d7878270a487);
        assert_eq!(buffer.read_partial_felt252(35, 12), 0xa4ba88ec7e60fd32acceb049);
        assert_eq!(buffer.read_partial_felt252(41, 13), 0xfd32acceb049535be6788c3c4a);
        assert_eq!(buffer.read_partial_felt252(71, 14), 0x810c2a35fe4d686148f9c796fcdd);
        assert_eq!(buffer.read_partial_felt252(14, 15), 0x874bdb3b65dbe782940f16c897fb8a);
        assert_eq!(buffer.read_partial_felt252(18, 16), 0x65dbe782940f16c897fb8a734ef6632d);
        assert_eq!(buffer.read_partial_felt252(35, 17), 0xa4ba88ec7e60fd32acceb049535be6788c);
        assert_eq!(buffer.read_partial_felt252(41, 18), 0xfd32acceb049535be6788c3c4a817a0ef66a);
        assert_eq!(buffer.read_partial_felt252(3, 19), 0xd0a3de964578d7878270a4874bdb3b65dbe782);
        assert_eq!(buffer.read_partial_felt252(77, 20), 0x686148f9c796fcdd49643eed7ffdd71958b84eaa);
        assert_eq!(buffer.read_partial_felt252(9, 21), 0xd7878270a4874bdb3b65dbe782940f16c897fb8a73);
        assert_eq!(buffer.read_partial_felt252(56, 22), 0x0ef66a47455ea53b82c2b2c2b62539810c2a35fe4d68);
        assert_eq!(buffer.read_partial_felt252(30, 23), 0x4ef6632d23a4ba88ec7e60fd32acceb049535be6788c3c);
        assert_eq!(buffer.read_partial_felt252(51, 24), 0x8c3c4a817a0ef66a47455ea53b82c2b2c2b62539810c2a35);
        assert_eq!(buffer.read_partial_felt252(44, 25), 0xceb049535be6788c3c4a817a0ef66a47455ea53b82c2b2c2b6);
        assert_eq!(buffer.read_partial_felt252(73, 26), 0x2a35fe4d686148f9c796fcdd49643eed7ffdd71958b84eaad1ce);
        assert_eq!(buffer.read_partial_felt252(37, 27), 0x88ec7e60fd32acceb049535be6788c3c4a817a0ef66a47455ea53b);
        assert_eq!(buffer.read_partial_felt252(53, 28), 0x4a817a0ef66a47455ea53b82c2b2c2b62539810c2a35fe4d686148f9);
        assert_eq!(buffer.read_partial_felt252(14, 29), 0x874bdb3b65dbe782940f16c897fb8a734ef6632d23a4ba88ec7e60fd32);
        assert_eq!(buffer.read_partial_felt252(81, 30), 0xc796fcdd49643eed7ffdd71958b84eaad1ce0cd4203cd0eb5f5b238bf029);
        assert_eq!(buffer.read_partial_felt252(48, 31), 0x5be6788c3c4a817a0ef66a47455ea53b82c2b2c2b62539810c2a35fe4d6861);
        assert_eq!(buffer.hash_sha256(), [0x3dc04ffa, 0xe2b84d86, 0xb708317c, 0x5887f122, 0xf50e5cec, 0xb39fa8c4, 0x4ac1b172, 0x46d1dc5f]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xc7cd1fd6, 0x81a6c56b, 0xa4697089, 0x10961a4c, 0xcb7ddbb1, 0x8163f3a7, 0xc65bf44f, 0x0cf37e4a]);
        assert_eq!(buffer.hash_poseidon_range(44, 105), 0x7a71e1c20555762a1f456295cbaf4a84a0cc9d0074b519f7e95d4a2a18b8a5b);
        assert_eq!(buffer.hash_poseidon_range(109, 112), 0x429137998840853f2868fca5bcc5574cc15ad8da11428aadce594ead0be49fb);
        assert_eq!(buffer.hash_poseidon_range(28, 38), 0x4cd8d88ed604858a92ef6eab2f2cdf1b08dc3be0d910a9607a3593079c1ab13);
        assert_eq!(buffer.hash_poseidon_range(58, 110), 0x6e68fb2a6998d29598be20d502c82fb51c16df6d1d996385f70b2d976ab859d);
        assert_eq!(buffer.hash_poseidon_range(105, 105), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);

        let mut serialized_byte_array = array![0x2, 0xe39e10aec2931c468b8bf1d09e5116b97c5d70f15b981a1a28b4490168c520, 0x05161c39ecb9cfd7d39aa97a25d2537d5ae0d0d2da1a80475d4ab245fb2523, 0x016bc643b5, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(15), 0x7cb9);
        assert_eq!(buffer.read_u16_be(3), 0xaec2);
        assert_eq!(buffer.read_u32_le(9), 0x9ed0f18b);
        assert_eq!(buffer.read_u32_be(34), 0x39ecb9cf);
        assert_eq!(buffer.read_u64_le(39), 0x7d53d2257aa99ad3);
        assert_eq!(buffer.read_u64_be(42), 0x7a25d2537d5ae0d0);
        assert_eq!(buffer.read_u128_le(42), 0xb24a5d47801adad2d0e05a7d53d2257a);
        assert_eq!(buffer.read_u128_be(35), 0xecb9cfd7d39aa97a25d2537d5ae0d0d2);
        assert_eq!(buffer.read_u256_le(15), 0x7d53d2257aa99ad3d7cfb9ec391c160520c5680149b4281a1a985bf1705d7cb9);
        assert_eq!(buffer.read_u256_be(2), 0x10aec2931c468b8bf1d09e5116b97c5d70f15b981a1a28b4490168c52005161c);
        assert_eq!(buffer.read_felt252(29), 0xc52005161c39ecb9cfd7d39aa97a25d2537d5ae0d0d2da1a80475d4ab245fb);
        assert_eq!(buffer.read_partial_felt252(3, 1), 0xae);
        assert_eq!(buffer.read_partial_felt252(0, 2), 0xe39e);
        assert_eq!(buffer.read_partial_felt252(37, 3), 0xcfd7d3);
        assert_eq!(buffer.read_partial_felt252(60, 4), 0x2523016b);
        assert_eq!(buffer.read_partial_felt252(42, 5), 0x7a25d2537d);
        assert_eq!(buffer.read_partial_felt252(4, 6), 0xc2931c468b8b);
        assert_eq!(buffer.read_partial_felt252(10, 7), 0xf1d09e5116b97c);
        assert_eq!(buffer.read_partial_felt252(17, 8), 0x5d70f15b981a1a28);
        assert_eq!(buffer.read_partial_felt252(10, 9), 0xf1d09e5116b97c5d70);
        assert_eq!(buffer.read_partial_felt252(42, 10), 0x7a25d2537d5ae0d0d2da);
        assert_eq!(buffer.read_partial_felt252(16, 11), 0x7c5d70f15b981a1a28b449);
        assert_eq!(buffer.read_partial_felt252(32, 12), 0x161c39ecb9cfd7d39aa97a25);
        assert_eq!(buffer.read_partial_felt252(40, 13), 0x9aa97a25d2537d5ae0d0d2da1a);
        assert_eq!(buffer.read_partial_felt252(17, 14), 0x5d70f15b981a1a28b4490168c520);
        assert_eq!(buffer.read_partial_felt252(9, 15), 0x8bf1d09e5116b97c5d70f15b981a1a);
        assert_eq!(buffer.read_partial_felt252(9, 16), 0x8bf1d09e5116b97c5d70f15b981a1a28);
        assert_eq!(buffer.read_partial_felt252(22, 17), 0x1a1a28b4490168c52005161c39ecb9cfd7);
        assert_eq!(buffer.read_partial_felt252(42, 18), 0x7a25d2537d5ae0d0d2da1a80475d4ab245fb);
        assert_eq!(buffer.read_partial_felt252(22, 19), 0x1a1a28b4490168c52005161c39ecb9cfd7d39a);
        assert_eq!(buffer.read_partial_felt252(1, 20), 0x9e10aec2931c468b8bf1d09e5116b97c5d70f15b);
        assert_eq!(buffer.read_partial_felt252(1, 21), 0x9e10aec2931c468b8bf1d09e5116b97c5d70f15b98);
        assert_eq!(buffer.read_partial_felt252(12, 22), 0x9e5116b97c5d70f15b981a1a28b4490168c52005161c);
        assert_eq!(buffer.read_partial_felt252(34, 23), 0x39ecb9cfd7d39aa97a25d2537d5ae0d0d2da1a80475d4a);
        assert_eq!(buffer.read_partial_felt252(4, 24), 0xc2931c468b8bf1d09e5116b97c5d70f15b981a1a28b44901);
        assert_eq!(buffer.read_partial_felt252(16, 25), 0x7c5d70f15b981a1a28b4490168c52005161c39ecb9cfd7d39a);
        assert_eq!(buffer.read_partial_felt252(30, 26), 0x2005161c39ecb9cfd7d39aa97a25d2537d5ae0d0d2da1a80475d);
        assert_eq!(buffer.read_partial_felt252(37, 27), 0xcfd7d39aa97a25d2537d5ae0d0d2da1a80475d4ab245fb2523016b);
        assert_eq!(buffer.read_partial_felt252(23, 28), 0x1a28b4490168c52005161c39ecb9cfd7d39aa97a25d2537d5ae0d0d2);
        assert_eq!(buffer.read_partial_felt252(15, 29), 0xb97c5d70f15b981a1a28b4490168c52005161c39ecb9cfd7d39aa97a25);
        assert_eq!(buffer.read_partial_felt252(11, 30), 0xd09e5116b97c5d70f15b981a1a28b4490168c52005161c39ecb9cfd7d39a);
        assert_eq!(buffer.read_partial_felt252(21, 31), 0x981a1a28b4490168c52005161c39ecb9cfd7d39aa97a25d2537d5ae0d0d2da);
        assert_eq!(buffer.hash_sha256(), [0x8b3d18b7, 0x6b1bd95f, 0xb0c2561f, 0xa89e8497, 0x46e54b7d, 0xc3835956, 0xff69c4a1, 0xa87dbf30]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x6e5205ab, 0x3724f501, 0x5d40de08, 0x1b2f9e05, 0xa13ce51d, 0xb5c44edc, 0x50b0f7dd, 0x204c4277]);
        assert_eq!(buffer.hash_poseidon_range(28, 35), 0x56f41ced22ddc793125cad2d476266a34dfc13e0a1dc6d382b810a0b20eefe4);
        assert_eq!(buffer.hash_poseidon_range(32, 32), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);
        assert_eq!(buffer.hash_poseidon_range(16, 40), 0x6d852051516db32817dfa56e4f575b6403fb0b77ab2a1e5a3f81f3a3cece0f9);
        assert_eq!(buffer.hash_poseidon_range(48, 48), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);
        assert_eq!(buffer.hash_poseidon_range(34, 62), 0x233df2f8f142dc76204bc3b4aaeb1fa09897867b90e47f278135959786cf1ba);

        let mut serialized_byte_array = array![0x2, 0x97f567f92a5a08a5164b2be52c803d074953c911cd1472f2b7c97e75d34f03, 0x4cbdc2c1cb8f4fa388a4bc94896993b29f2066019e07adc8e72d5ec9e6814f, 0xa726, 0x2].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(33), 0xc1c2);
        assert_eq!(buffer.read_u16_be(34), 0xc1cb);
        assert_eq!(buffer.read_u32_le(7), 0x2b4b16a5);
        assert_eq!(buffer.read_u32_be(56), 0x2d5ec9e6);
        assert_eq!(buffer.read_u64_le(19), 0x7ec9b7f27214cd11);
        assert_eq!(buffer.read_u64_be(53), 0xadc8e72d5ec9e681);
        assert_eq!(buffer.read_u128_le(16), 0x4c034fd3757ec9b7f27214cd11c95349);
        assert_eq!(buffer.read_u128_be(5), 0x5a08a5164b2be52c803d074953c911cd);
        assert_eq!(buffer.read_u256_le(25), 0x2de7c8ad079e0166209fb293698994bca488a34f8fcbc1c2bd4c034fd3757ec9);
        assert_eq!(buffer.read_u256_be(4), 0x2a5a08a5164b2be52c803d074953c911cd1472f2b7c97e75d34f034cbdc2c1cb);
        assert_eq!(buffer.read_felt252(30), 0x034cbdc2c1cb8f4fa388a4bc94896993b29f2066019e07adc8e72d5ec9e681);
        assert_eq!(buffer.read_partial_felt252(0, 1), 0x97);
        assert_eq!(buffer.read_partial_felt252(8, 2), 0x164b);
        assert_eq!(buffer.read_partial_felt252(59, 3), 0xe6814f);
        assert_eq!(buffer.read_partial_felt252(10, 4), 0x2be52c80);
        assert_eq!(buffer.read_partial_felt252(33, 5), 0xc2c1cb8f4f);
        assert_eq!(buffer.read_partial_felt252(22, 6), 0x72f2b7c97e75);
        assert_eq!(buffer.read_partial_felt252(3, 7), 0xf92a5a08a5164b);
        assert_eq!(buffer.read_partial_felt252(27, 8), 0x75d34f034cbdc2c1);
        assert_eq!(buffer.read_partial_felt252(40, 9), 0xa4bc94896993b29f20);
        assert_eq!(buffer.read_partial_felt252(50, 10), 0x019e07adc8e72d5ec9e6);
        assert_eq!(buffer.read_partial_felt252(14, 11), 0x3d074953c911cd1472f2b7);
        assert_eq!(buffer.read_partial_felt252(51, 12), 0x9e07adc8e72d5ec9e6814fa7);
        assert_eq!(buffer.read_partial_felt252(10, 13), 0x2be52c803d074953c911cd1472);
        assert_eq!(buffer.read_partial_felt252(6, 14), 0x08a5164b2be52c803d074953c911);
        assert_eq!(buffer.read_partial_felt252(18, 15), 0xc911cd1472f2b7c97e75d34f034cbd);
        assert_eq!(buffer.read_partial_felt252(46, 16), 0xb29f2066019e07adc8e72d5ec9e6814f);
        assert_eq!(buffer.read_partial_felt252(8, 17), 0x164b2be52c803d074953c911cd1472f2b7);
        assert_eq!(buffer.read_partial_felt252(11, 18), 0xe52c803d074953c911cd1472f2b7c97e75d3);
        assert_eq!(buffer.read_partial_felt252(39, 19), 0x88a4bc94896993b29f2066019e07adc8e72d5e);
        assert_eq!(buffer.read_partial_felt252(33, 20), 0xc2c1cb8f4fa388a4bc94896993b29f2066019e07);
        assert_eq!(buffer.read_partial_felt252(35, 21), 0xcb8f4fa388a4bc94896993b29f2066019e07adc8e7);
        assert_eq!(buffer.read_partial_felt252(38, 22), 0xa388a4bc94896993b29f2066019e07adc8e72d5ec9e6);
        assert_eq!(buffer.read_partial_felt252(21, 23), 0x1472f2b7c97e75d34f034cbdc2c1cb8f4fa388a4bc9489);
        assert_eq!(buffer.read_partial_felt252(26, 24), 0x7e75d34f034cbdc2c1cb8f4fa388a4bc94896993b29f2066);
        assert_eq!(buffer.read_partial_felt252(24, 25), 0xb7c97e75d34f034cbdc2c1cb8f4fa388a4bc94896993b29f20);
        assert_eq!(buffer.read_partial_felt252(28, 26), 0xd34f034cbdc2c1cb8f4fa388a4bc94896993b29f2066019e07ad);
        assert_eq!(buffer.read_partial_felt252(36, 27), 0x8f4fa388a4bc94896993b29f2066019e07adc8e72d5ec9e6814fa7);
        assert_eq!(buffer.read_partial_felt252(13, 28), 0x803d074953c911cd1472f2b7c97e75d34f034cbdc2c1cb8f4fa388a4);
        assert_eq!(buffer.read_partial_felt252(10, 29), 0x2be52c803d074953c911cd1472f2b7c97e75d34f034cbdc2c1cb8f4fa3);
        assert_eq!(buffer.read_partial_felt252(16, 30), 0x4953c911cd1472f2b7c97e75d34f034cbdc2c1cb8f4fa388a4bc94896993);
        assert_eq!(buffer.read_partial_felt252(31, 31), 0x4cbdc2c1cb8f4fa388a4bc94896993b29f2066019e07adc8e72d5ec9e6814f);
        assert_eq!(buffer.hash_sha256(), [0x09f5ba7d, 0x8d1209fd, 0xc6f09660, 0xd806123e, 0xe0fb360b, 0x00495549, 0xffeb241b, 0x7dad6fce]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xd0af01ed, 0x40c02c9d, 0xb164519d, 0x7a0d0539, 0x4c6df747, 0x8015d6a7, 0xd09454d4, 0x290d05df]);
        assert_eq!(buffer.hash_poseidon_range(1, 53), 0x67f61b69089f42c297841657119f632ad68faab39d9f33705e5414f03789ea8);
        assert_eq!(buffer.hash_poseidon_range(14, 42), 0x1960421128608d5495a5c3e702b5a441a56e3f0cf5505982fd8454805957320);
        assert_eq!(buffer.hash_poseidon_range(15, 54), 0x313fcc94605c6adb6c662b1cb178d1b7439da1f6911a8fedb8d5e4de52500d2);
        assert_eq!(buffer.hash_poseidon_range(62, 63), 0x4b7afc72edaf8049eb62bd218b5b70d8332b9d1be0bf9920a4b92b42ebe13b8);
        assert_eq!(buffer.hash_poseidon_range(50, 54), 0x63200ba3ff4231ca5b60c6898e2652e2ab7d174a7261f09e49a1564a743c552);

        let mut serialized_byte_array = array![0x2, 0x8737b27db3efe37fa01fa65cd32da3e721b74628d91ca0794720404af203ba, 0x9f44840a95eeb26c258a6a9f71b4d8e98ca83dece2a760b87ce74a18a3e97d, 0x325d806cd6, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(58), 0xa318);
        assert_eq!(buffer.read_u16_be(51), 0xe2a7);
        assert_eq!(buffer.read_u32_le(30), 0x84449fba);
        assert_eq!(buffer.read_u32_be(36), 0xeeb26c25);
        assert_eq!(buffer.read_u64_le(35), 0x9f6a8a256cb2ee95);
        assert_eq!(buffer.read_u64_be(36), 0xeeb26c258a6a9f71);
        assert_eq!(buffer.read_u128_le(21), 0xee950a84449fba03f24a40204779a01c);
        assert_eq!(buffer.read_u128_be(45), 0xd8e98ca83dece2a760b87ce74a18a3e9);
        assert_eq!(buffer.read_u256_le(4), 0x950a84449fba03f24a40204779a01cd92846b721e7a32dd35ca61fa07fe3efb3);
        assert_eq!(buffer.read_u256_be(20), 0xd91ca0794720404af203ba9f44840a95eeb26c258a6a9f71b4d8e98ca83dece2);
        assert_eq!(buffer.read_felt252(7), 0x7fa01fa65cd32da3e721b74628d91ca0794720404af203ba9f44840a95eeb2);
        assert_eq!(buffer.read_partial_felt252(24, 1), 0x47);
        assert_eq!(buffer.read_partial_felt252(43, 2), 0x71b4);
        assert_eq!(buffer.read_partial_felt252(5, 3), 0xefe37f);
        assert_eq!(buffer.read_partial_felt252(45, 4), 0xd8e98ca8);
        assert_eq!(buffer.read_partial_felt252(24, 5), 0x4720404af2);
        assert_eq!(buffer.read_partial_felt252(14, 6), 0xa3e721b74628);
        assert_eq!(buffer.read_partial_felt252(4, 7), 0xb3efe37fa01fa6);
        assert_eq!(buffer.read_partial_felt252(4, 8), 0xb3efe37fa01fa65c);
        assert_eq!(buffer.read_partial_felt252(6, 9), 0xe37fa01fa65cd32da3);
        assert_eq!(buffer.read_partial_felt252(19, 10), 0x28d91ca0794720404af2);
        assert_eq!(buffer.read_partial_felt252(26, 11), 0x404af203ba9f44840a95ee);
        assert_eq!(buffer.read_partial_felt252(46, 12), 0xe98ca83dece2a760b87ce74a);
        assert_eq!(buffer.read_partial_felt252(24, 13), 0x4720404af203ba9f44840a95ee);
        assert_eq!(buffer.read_partial_felt252(39, 14), 0x258a6a9f71b4d8e98ca83dece2a7);
        assert_eq!(buffer.read_partial_felt252(26, 15), 0x404af203ba9f44840a95eeb26c258a);
        assert_eq!(buffer.read_partial_felt252(32, 16), 0x44840a95eeb26c258a6a9f71b4d8e98c);
        assert_eq!(buffer.read_partial_felt252(8, 17), 0xa01fa65cd32da3e721b74628d91ca07947);
        assert_eq!(buffer.read_partial_felt252(26, 18), 0x404af203ba9f44840a95eeb26c258a6a9f71);
        assert_eq!(buffer.read_partial_felt252(41, 19), 0x6a9f71b4d8e98ca83dece2a760b87ce74a18a3);
        assert_eq!(buffer.read_partial_felt252(34, 20), 0x0a95eeb26c258a6a9f71b4d8e98ca83dece2a760);
        assert_eq!(buffer.read_partial_felt252(22, 21), 0xa0794720404af203ba9f44840a95eeb26c258a6a9f);
        assert_eq!(buffer.read_partial_felt252(15, 22), 0xe721b74628d91ca0794720404af203ba9f44840a95ee);
        assert_eq!(buffer.read_partial_felt252(18, 23), 0x4628d91ca0794720404af203ba9f44840a95eeb26c258a);
        assert_eq!(buffer.read_partial_felt252(33, 24), 0x840a95eeb26c258a6a9f71b4d8e98ca83dece2a760b87ce7);
        assert_eq!(buffer.read_partial_felt252(25, 25), 0x20404af203ba9f44840a95eeb26c258a6a9f71b4d8e98ca83d);
        assert_eq!(buffer.read_partial_felt252(6, 26), 0xe37fa01fa65cd32da3e721b74628d91ca0794720404af203ba9f);
        assert_eq!(buffer.read_partial_felt252(30, 27), 0xba9f44840a95eeb26c258a6a9f71b4d8e98ca83dece2a760b87ce7);
        assert_eq!(buffer.read_partial_felt252(2, 28), 0xb27db3efe37fa01fa65cd32da3e721b74628d91ca0794720404af203);
        assert_eq!(buffer.read_partial_felt252(29, 29), 0x03ba9f44840a95eeb26c258a6a9f71b4d8e98ca83dece2a760b87ce74a);
        assert_eq!(buffer.read_partial_felt252(6, 30), 0xe37fa01fa65cd32da3e721b74628d91ca0794720404af203ba9f44840a95);
        assert_eq!(buffer.read_partial_felt252(20, 31), 0xd91ca0794720404af203ba9f44840a95eeb26c258a6a9f71b4d8e98ca83dec);
        assert_eq!(buffer.hash_sha256(), [0x67b50957, 0x9d19051f, 0x610d0af6, 0xd2b2b485, 0xd906f02d, 0xf1bc1b1a, 0xe8a9f463, 0xca854044]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xfaf7e814, 0xdc376908, 0x71cf34ee, 0x9dc08cc0, 0x77d2aaad, 0xddfb1fdc, 0xd2721cb0, 0xc6591d92]);
        assert_eq!(buffer.hash_poseidon_range(60, 65), 0x2394d275f6309612f6c85b9c7b6b4eea4aa01586c7b9d0f6f6b594e5a41bc6b);
        assert_eq!(buffer.hash_poseidon_range(66, 66), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);
        assert_eq!(buffer.hash_poseidon_range(53, 57), 0x228d42a05d36bb195824cec1660187fd17fee2f2417ab132e24042cafb32d54);
        assert_eq!(buffer.hash_poseidon_range(63, 66), 0x1517a94f3d38104ad3ddb2892594a9d21f15682da498f2d960638d4cff2e23);
        assert_eq!(buffer.hash_poseidon_range(2, 14), 0x2585d0dcb48b9cf92dcbc94280e981eb1353dfc88c4ae9adec64ad5e0b48482);

        let mut serialized_byte_array = array![0x1, 0xdc1b9dee753f9317b834eb472f8890632032192a7c109598f91494639ac86c, 0x03e1c992ab0f9a7716a57ea04065438d48464f958e815c36a0a7630eb9, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(3), 0x75ee);
        assert_eq!(buffer.read_u16_be(11), 0x472f);
        assert_eq!(buffer.read_u32_le(26), 0xc89a6394);
        assert_eq!(buffer.read_u32_be(42), 0xa0406543);
        assert_eq!(buffer.read_u64_le(33), 0xa516779a0fab92c9);
        assert_eq!(buffer.read_u64_be(6), 0x9317b834eb472f88);
        assert_eq!(buffer.read_u128_le(38), 0x5c818e954f46488d436540a07ea51677);
        assert_eq!(buffer.read_u128_be(39), 0x16a57ea04065438d48464f958e815c36);
        assert_eq!(buffer.read_u256_le(1), 0xe1036cc89a639414f99895107c2a1932206390882f47eb34b817933f75ee9d1b);
        assert_eq!(buffer.read_u256_be(6), 0x9317b834eb472f8890632032192a7c109598f91494639ac86c03e1c992ab0f9a);
        assert_eq!(buffer.read_felt252(14), 0x90632032192a7c109598f91494639ac86c03e1c992ab0f9a7716a57ea04065);
        assert_eq!(buffer.read_partial_felt252(17, 1), 0x32);
        assert_eq!(buffer.read_partial_felt252(41, 2), 0x7ea0);
        assert_eq!(buffer.read_partial_felt252(23, 3), 0x98f914);
        assert_eq!(buffer.read_partial_felt252(53, 4), 0x5c36a0a7);
        assert_eq!(buffer.read_partial_felt252(28, 5), 0x9ac86c03e1);
        assert_eq!(buffer.read_partial_felt252(47, 6), 0x48464f958e81);
        assert_eq!(buffer.read_partial_felt252(7, 7), 0x17b834eb472f88);
        assert_eq!(buffer.read_partial_felt252(42, 8), 0xa04065438d48464f);
        assert_eq!(buffer.read_partial_felt252(15, 9), 0x632032192a7c109598);
        assert_eq!(buffer.read_partial_felt252(46, 10), 0x8d48464f958e815c36a0);
        assert_eq!(buffer.read_partial_felt252(13, 11), 0x8890632032192a7c109598);
        assert_eq!(buffer.read_partial_felt252(25, 12), 0x1494639ac86c03e1c992ab0f);
        assert_eq!(buffer.read_partial_felt252(10, 13), 0xeb472f8890632032192a7c1095);
        assert_eq!(buffer.read_partial_felt252(43, 14), 0x4065438d48464f958e815c36a0a7);
        assert_eq!(buffer.read_partial_felt252(40, 15), 0xa57ea04065438d48464f958e815c36);
        assert_eq!(buffer.read_partial_felt252(15, 16), 0x632032192a7c109598f91494639ac86c);
        assert_eq!(buffer.read_partial_felt252(3, 17), 0xee753f9317b834eb472f8890632032192a);
        assert_eq!(buffer.read_partial_felt252(21, 18), 0x109598f91494639ac86c03e1c992ab0f9a77);
        assert_eq!(buffer.read_partial_felt252(18, 19), 0x192a7c109598f91494639ac86c03e1c992ab0f);
        assert_eq!(buffer.read_partial_felt252(38, 20), 0x7716a57ea04065438d48464f958e815c36a0a763);
        assert_eq!(buffer.read_partial_felt252(27, 21), 0x639ac86c03e1c992ab0f9a7716a57ea04065438d48);
        assert_eq!(buffer.read_partial_felt252(31, 22), 0x03e1c992ab0f9a7716a57ea04065438d48464f958e81);
        assert_eq!(buffer.read_partial_felt252(21, 23), 0x109598f91494639ac86c03e1c992ab0f9a7716a57ea040);
        assert_eq!(buffer.read_partial_felt252(14, 24), 0x90632032192a7c109598f91494639ac86c03e1c992ab0f9a);
        assert_eq!(buffer.read_partial_felt252(20, 25), 0x7c109598f91494639ac86c03e1c992ab0f9a7716a57ea04065);
        assert_eq!(buffer.read_partial_felt252(14, 26), 0x90632032192a7c109598f91494639ac86c03e1c992ab0f9a7716);
        assert_eq!(buffer.read_partial_felt252(32, 27), 0xe1c992ab0f9a7716a57ea04065438d48464f958e815c36a0a7630e);
        assert_eq!(buffer.read_partial_felt252(7, 28), 0x17b834eb472f8890632032192a7c109598f91494639ac86c03e1c992);
        assert_eq!(buffer.read_partial_felt252(23, 29), 0x98f91494639ac86c03e1c992ab0f9a7716a57ea04065438d48464f958e);
        assert_eq!(buffer.read_partial_felt252(20, 30), 0x7c109598f91494639ac86c03e1c992ab0f9a7716a57ea04065438d48464f);
        assert_eq!(buffer.read_partial_felt252(12, 31), 0x2f8890632032192a7c109598f91494639ac86c03e1c992ab0f9a7716a57ea0);
        assert_eq!(buffer.hash_sha256(), [0x0d9d43bd, 0x8776b7ab, 0xc31d68c2, 0x254b11e6, 0xbe99562e, 0x3a06b86e, 0xb4d0f4b1, 0x6afd944b]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x155ee54a, 0x0790636f, 0x8572d713, 0xd31c1b5c, 0xfac1ab03, 0x61ae6467, 0x3944bb7f, 0x20c558c0]);
        assert_eq!(buffer.hash_poseidon_range(6, 40), 0x342da7ceb71bcf4ad1083b26af3a408385d96b881fb47ee37a7209114e2bd5);
        assert_eq!(buffer.hash_poseidon_range(27, 42), 0x7626dcf59630beaa41880b8888d89ed9410e9c0fca6319e2793a64e9fd94b69);
        assert_eq!(buffer.hash_poseidon_range(0, 58), 0x1e7b82ea14977e4d4d77d8208d6acea3ede15c506140679a7675bc5b3d37f60);
        assert_eq!(buffer.hash_poseidon_range(39, 52), 0x459085563cc433c4e11d3c13eb793f9f73c4b5bad58a63338fcf1fe8be5a150);
        assert_eq!(buffer.hash_poseidon_range(23, 28), 0x7277627e815c2d5c23ca0d40bb75d95289946c52249fa668008c14988f71077);

        let mut serialized_byte_array = array![0x3, 0x5c5188b5aa0e2e62dcd0422e24639a49246cbd31a879e8322c3d2e08bca652, 0xd86e7971ac9bdbc0d0dbcbd922d8f896fa49a555610c76a9994503ef45ec80, 0x686401cab13362ea9a5db82bf0bcd77d947a89e72a91de96725ac4e1775133, 0x68cec9546a, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(69), 0x9aea);
        assert_eq!(buffer.read_u16_be(66), 0xb133);
        assert_eq!(buffer.read_u32_le(11), 0x9a63242e);
        assert_eq!(buffer.read_u32_be(70), 0x9a5db82b);
        assert_eq!(buffer.read_u64_le(20), 0x82e3d2c32e879a8);
        assert_eq!(buffer.read_u64_be(13), 0x639a49246cbd31a8);
        assert_eq!(buffer.read_u128_le(64), 0x7a947dd7bcf02bb85d9aea6233b1ca01);
        assert_eq!(buffer.read_u128_be(69), 0xea9a5db82bf0bcd77d947a89e72a91de);
        assert_eq!(buffer.read_u256_le(48), 0x7a947dd7bcf02bb85d9aea6233b1ca01646880ec45ef034599a9760c6155a549);
        assert_eq!(buffer.read_u256_be(42), 0xd922d8f896fa49a555610c76a9994503ef45ec80686401cab13362ea9a5db82b);
        assert_eq!(buffer.read_felt252(61), 0x80686401cab13362ea9a5db82bf0bcd77d947a89e72a91de96725ac4e17751);
        assert_eq!(buffer.read_partial_felt252(20, 1), 0xa8);
        assert_eq!(buffer.read_partial_felt252(65, 2), 0xcab1);
        assert_eq!(buffer.read_partial_felt252(12, 3), 0x24639a);
        assert_eq!(buffer.read_partial_felt252(80, 4), 0x89e72a91);
        assert_eq!(buffer.read_partial_felt252(17, 5), 0x6cbd31a879);
        assert_eq!(buffer.read_partial_felt252(4, 6), 0xaa0e2e62dcd0);
        assert_eq!(buffer.read_partial_felt252(61, 7), 0x80686401cab133);
        assert_eq!(buffer.read_partial_felt252(39, 8), 0xd0dbcbd922d8f896);
        assert_eq!(buffer.read_partial_felt252(84, 9), 0xde96725ac4e1775133);
        assert_eq!(buffer.read_partial_felt252(35, 10), 0xac9bdbc0d0dbcbd922d8);
        assert_eq!(buffer.read_partial_felt252(65, 11), 0xcab13362ea9a5db82bf0bc);
        assert_eq!(buffer.read_partial_felt252(57, 12), 0x03ef45ec80686401cab13362);
        assert_eq!(buffer.read_partial_felt252(35, 13), 0xac9bdbc0d0dbcbd922d8f896fa);
        assert_eq!(buffer.read_partial_felt252(82, 14), 0x2a91de96725ac4e177513368cec9);
        assert_eq!(buffer.read_partial_felt252(47, 15), 0xfa49a555610c76a9994503ef45ec80);
        assert_eq!(buffer.read_partial_felt252(3, 16), 0xb5aa0e2e62dcd0422e24639a49246cbd);
        assert_eq!(buffer.read_partial_felt252(9, 17), 0xd0422e24639a49246cbd31a879e8322c3d);
        assert_eq!(buffer.read_partial_felt252(31, 18), 0xd86e7971ac9bdbc0d0dbcbd922d8f896fa49);
        assert_eq!(buffer.read_partial_felt252(48, 19), 0x49a555610c76a9994503ef45ec80686401cab1);
        assert_eq!(buffer.read_partial_felt252(45, 20), 0xf896fa49a555610c76a9994503ef45ec80686401);
        assert_eq!(buffer.read_partial_felt252(72, 21), 0xb82bf0bcd77d947a89e72a91de96725ac4e1775133);
        assert_eq!(buffer.read_partial_felt252(9, 22), 0xd0422e24639a49246cbd31a879e8322c3d2e08bca652);
        assert_eq!(buffer.read_partial_felt252(37, 23), 0xdbc0d0dbcbd922d8f896fa49a555610c76a9994503ef45);
        assert_eq!(buffer.read_partial_felt252(67, 24), 0x3362ea9a5db82bf0bcd77d947a89e72a91de96725ac4e177);
        assert_eq!(buffer.read_partial_felt252(3, 25), 0xb5aa0e2e62dcd0422e24639a49246cbd31a879e8322c3d2e08);
        assert_eq!(buffer.read_partial_felt252(66, 26), 0xb13362ea9a5db82bf0bcd77d947a89e72a91de96725ac4e17751);
        assert_eq!(buffer.read_partial_felt252(2, 27), 0x88b5aa0e2e62dcd0422e24639a49246cbd31a879e8322c3d2e08bc);
        assert_eq!(buffer.read_partial_felt252(44, 28), 0xd8f896fa49a555610c76a9994503ef45ec80686401cab13362ea9a5d);
        assert_eq!(buffer.read_partial_felt252(11, 29), 0x2e24639a49246cbd31a879e8322c3d2e08bca652d86e7971ac9bdbc0d0);
        assert_eq!(buffer.read_partial_felt252(12, 30), 0x24639a49246cbd31a879e8322c3d2e08bca652d86e7971ac9bdbc0d0dbcb);
        assert_eq!(buffer.read_partial_felt252(23, 31), 0x322c3d2e08bca652d86e7971ac9bdbc0d0dbcbd922d8f896fa49a555610c76);
        assert_eq!(buffer.hash_sha256(), [0x58eab234, 0x54cfa905, 0xe0a85dca, 0xc5698401, 0x8d8d59ed, 0x1acd7e76, 0xeebff728, 0x104e9807]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x66dfdddb, 0x09a4f6ee, 0xc3ec9471, 0xca6f03df, 0x3a938428, 0xdfb2849d, 0xca9ecfc8, 0xd04374cf]);
        assert_eq!(buffer.hash_poseidon_range(60, 88), 0x3c8c048fad4cceacd9f2730a4f4628e85216269ee222a4e32e4f0b9d27f6302);
        assert_eq!(buffer.hash_poseidon_range(62, 96), 0x498de89b26aacc0170530c0c347b60cd7fb8f92e4b84c94c5a4c2018bcfaadf);
        assert_eq!(buffer.hash_poseidon_range(36, 71), 0x69be9f409bb5513790b6ef9f705d27be8d79658fd32ce14f9870d9454006523);
        assert_eq!(buffer.hash_poseidon_range(1, 66), 0x1db51bc187ab4cca770b35879e185fcfcdf670f619c89c10d367bafc787d15d);
        assert_eq!(buffer.hash_poseidon_range(59, 68), 0x39d12b28af2f3b856782850c7a27ad3295a3b9d31ee895e537b374e4512862e);

        let mut serialized_byte_array = array![0x2, 0xd1cbb570aba92005719157a3279e71e25fa37a4f2e6b1049aa15a97ca890b2, 0xd9df501082013e1ba328559a10b8762a1ed2351e9c5e457d49f3c3ed0466f1, 0x172ad0bd49f92dbed8f5569333f04862, 0x10].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(34), 0x8210);
        assert_eq!(buffer.read_u16_be(0), 0xd1cb);
        assert_eq!(buffer.read_u32_le(69), 0x56f5d8be);
        assert_eq!(buffer.read_u32_be(53), 0x457d49f3);
        assert_eq!(buffer.read_u64_le(29), 0x1821050dfd9b290);
        assert_eq!(buffer.read_u64_be(19), 0x4f2e6b1049aa15a9);
        assert_eq!(buffer.read_u128_le(16), 0xd9b290a87ca915aa49106b2e4f7aa35f);
        assert_eq!(buffer.read_u128_be(17), 0xa37a4f2e6b1049aa15a97ca890b2d9df);
        assert_eq!(buffer.read_u256_le(6), 0x3e01821050dfd9b290a87ca915aa49106b2e4f7aa35fe2719e27a35791710520);
        assert_eq!(buffer.read_u256_be(23), 0x49aa15a97ca890b2d9df501082013e1ba328559a10b8762a1ed2351e9c5e457d);
        assert_eq!(buffer.read_felt252(23), 0x49aa15a97ca890b2d9df501082013e1ba328559a10b8762a1ed2351e9c5e45);
        assert_eq!(buffer.read_partial_felt252(27, 1), 0x7c);
        assert_eq!(buffer.read_partial_felt252(58, 2), 0xed04);
        assert_eq!(buffer.read_partial_felt252(67, 3), 0xf92dbe);
        assert_eq!(buffer.read_partial_felt252(2, 4), 0xb570aba9);
        assert_eq!(buffer.read_partial_felt252(28, 5), 0xa890b2d9df);
        assert_eq!(buffer.read_partial_felt252(58, 6), 0xed0466f1172a);
        assert_eq!(buffer.read_partial_felt252(57, 7), 0xc3ed0466f1172a);
        assert_eq!(buffer.read_partial_felt252(66, 8), 0x49f92dbed8f55693);
        assert_eq!(buffer.read_partial_felt252(44, 9), 0xb8762a1ed2351e9c5e);
        assert_eq!(buffer.read_partial_felt252(46, 10), 0x2a1ed2351e9c5e457d49);
        assert_eq!(buffer.read_partial_felt252(65, 11), 0xbd49f92dbed8f5569333f0);
        assert_eq!(buffer.read_partial_felt252(10, 12), 0x57a3279e71e25fa37a4f2e6b);
        assert_eq!(buffer.read_partial_felt252(34, 13), 0x1082013e1ba328559a10b8762a);
        assert_eq!(buffer.read_partial_felt252(61, 14), 0xf1172ad0bd49f92dbed8f5569333);
        assert_eq!(buffer.read_partial_felt252(23, 15), 0x49aa15a97ca890b2d9df501082013e);
        assert_eq!(buffer.read_partial_felt252(46, 16), 0x2a1ed2351e9c5e457d49f3c3ed0466f1);
        assert_eq!(buffer.read_partial_felt252(1, 17), 0xcbb570aba92005719157a3279e71e25fa3);
        assert_eq!(buffer.read_partial_felt252(9, 18), 0x9157a3279e71e25fa37a4f2e6b1049aa15a9);
        assert_eq!(buffer.read_partial_felt252(26, 19), 0xa97ca890b2d9df501082013e1ba328559a10b8);
        assert_eq!(buffer.read_partial_felt252(7, 20), 0x05719157a3279e71e25fa37a4f2e6b1049aa15a9);
        assert_eq!(buffer.read_partial_felt252(18, 21), 0x7a4f2e6b1049aa15a97ca890b2d9df501082013e1b);
        assert_eq!(buffer.read_partial_felt252(21, 22), 0x6b1049aa15a97ca890b2d9df501082013e1ba328559a);
        assert_eq!(buffer.read_partial_felt252(47, 23), 0x1ed2351e9c5e457d49f3c3ed0466f1172ad0bd49f92dbe);
        assert_eq!(buffer.read_partial_felt252(53, 24), 0x457d49f3c3ed0466f1172ad0bd49f92dbed8f5569333f048);
        assert_eq!(buffer.read_partial_felt252(2, 25), 0xb570aba92005719157a3279e71e25fa37a4f2e6b1049aa15a9);
        assert_eq!(buffer.read_partial_felt252(50, 26), 0x1e9c5e457d49f3c3ed0466f1172ad0bd49f92dbed8f5569333f0);
        assert_eq!(buffer.read_partial_felt252(25, 27), 0x15a97ca890b2d9df501082013e1ba328559a10b8762a1ed2351e9c);
        assert_eq!(buffer.read_partial_felt252(12, 28), 0x279e71e25fa37a4f2e6b1049aa15a97ca890b2d9df501082013e1ba3);
        assert_eq!(buffer.read_partial_felt252(30, 29), 0xb2d9df501082013e1ba328559a10b8762a1ed2351e9c5e457d49f3c3ed);
        assert_eq!(buffer.read_partial_felt252(3, 30), 0x70aba92005719157a3279e71e25fa37a4f2e6b1049aa15a97ca890b2d9df);
        assert_eq!(buffer.read_partial_felt252(38, 31), 0x1ba328559a10b8762a1ed2351e9c5e457d49f3c3ed0466f1172ad0bd49f92d);
        assert_eq!(buffer.hash_sha256(), [0xbf44ec0f, 0x1ada99c7, 0x365a982c, 0xbb7f9b14, 0xaeda5a02, 0xcbf697b1, 0x56ed97a3, 0x320ebe8a]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xfd597811, 0x0c123b71, 0x1804c521, 0xcbbb3008, 0xa258cfe9, 0xabb8988d, 0x8fead8e0, 0x69bc0bc9]);
        assert_eq!(buffer.hash_poseidon_range(12, 64), 0x65dcee7525671481217c7271f3d9cf6abe945973afdf1c9a31162788bd85ba4);
        assert_eq!(buffer.hash_poseidon_range(41, 56), 0x571e6edadf859ad2b930957b5e9fc7d10a2cb9440f44d29d05f2de5769b2afc);
        assert_eq!(buffer.hash_poseidon_range(54, 75), 0x611dbbb7120794ea81f71691c9e768180b7fb03622b3c2a1b86b1942e7e574d);
        assert_eq!(buffer.hash_poseidon_range(0, 18), 0x69687d956a94f2e4f6c82a199cdb3c42724f246873a8c35d6b8676af242e094);
        assert_eq!(buffer.hash_poseidon_range(39, 48), 0x71784c91c9510052cc3c72aa522e89bbc913808a9587edb5adcf5daca14072b);

        let mut serialized_byte_array = array![0x4, 0x317eaaf1887f150119df66062abf22e015e829f3b6eb412fe73faa49d35bcf, 0x671edfeb5b75e0f21eef583dbfc6788edb93b4b240ff31b0725ba71db07938, 0x27f3165d67f66e763aac6f5739becc802496c0b35307fc6e83d2bd5b16a0db, 0xb51337b2952a4d838e0cdc506ec15844501a72f70642a3ce156a057434d5ce, 0xef, 0x1].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(29), 0xcf5b);
        assert_eq!(buffer.read_u16_be(118), 0x6a05);
        assert_eq!(buffer.read_u32_le(76), 0x962480cc);
        assert_eq!(buffer.read_u32_be(33), 0xdfeb5b75);
        assert_eq!(buffer.read_u64_le(41), 0x93db8e78c6bf3d58);
        assert_eq!(buffer.read_u64_be(116), 0xce156a057434d5ce);
        assert_eq!(buffer.read_u128_le(19), 0xebdf1e67cf5bd349aa3fe72f41ebb6f3);
        assert_eq!(buffer.read_u128_be(78), 0x2496c0b35307fc6e83d2bd5b16a0dbb5);
        assert_eq!(buffer.read_u256_le(77), 0x4458c16e50dc0c8e834d2a95b23713b5dba0165bbdd2836efc0753b3c0962480);
        assert_eq!(buffer.read_u256_be(15), 0xe015e829f3b6eb412fe73faa49d35bcf671edfeb5b75e0f21eef583dbfc6788e);
        assert_eq!(buffer.read_felt252(50), 0xb240ff31b0725ba71db0793827f3165d67f66e763aac6f5739becc802496c0);
        assert_eq!(buffer.read_partial_felt252(11, 1), 0x06);
        assert_eq!(buffer.read_partial_felt252(25, 2), 0x3faa);
        assert_eq!(buffer.read_partial_felt252(61, 3), 0x3827f3);
        assert_eq!(buffer.read_partial_felt252(19, 4), 0xf3b6eb41);
        assert_eq!(buffer.read_partial_felt252(50, 5), 0xb240ff31b0);
        assert_eq!(buffer.read_partial_felt252(76, 6), 0xcc802496c0b3);
        assert_eq!(buffer.read_partial_felt252(111, 7), 0x72f70642a3ce15);
        assert_eq!(buffer.read_partial_felt252(11, 8), 0x062abf22e015e829);
        assert_eq!(buffer.read_partial_felt252(11, 9), 0x062abf22e015e829f3);
        assert_eq!(buffer.read_partial_felt252(1, 10), 0x7eaaf1887f150119df66);
        assert_eq!(buffer.read_partial_felt252(16, 11), 0x15e829f3b6eb412fe73faa);
        assert_eq!(buffer.read_partial_felt252(21, 12), 0xeb412fe73faa49d35bcf671e);
        assert_eq!(buffer.read_partial_felt252(48, 13), 0x93b4b240ff31b0725ba71db079);
        assert_eq!(buffer.read_partial_felt252(45, 14), 0x788edb93b4b240ff31b0725ba71d);
        assert_eq!(buffer.read_partial_felt252(64, 15), 0x165d67f66e763aac6f5739becc8024);
        assert_eq!(buffer.read_partial_felt252(107, 16), 0x5844501a72f70642a3ce156a057434d5);
        assert_eq!(buffer.read_partial_felt252(6, 17), 0x150119df66062abf22e015e829f3b6eb41);
        assert_eq!(buffer.read_partial_felt252(90, 18), 0x16a0dbb51337b2952a4d838e0cdc506ec158);
        assert_eq!(buffer.read_partial_felt252(99, 19), 0x4d838e0cdc506ec15844501a72f70642a3ce15);
        assert_eq!(buffer.read_partial_felt252(2, 20), 0xaaf1887f150119df66062abf22e015e829f3b6eb);
        assert_eq!(buffer.read_partial_felt252(101, 21), 0x8e0cdc506ec15844501a72f70642a3ce156a057434);
        assert_eq!(buffer.read_partial_felt252(42, 22), 0x3dbfc6788edb93b4b240ff31b0725ba71db0793827f3);
        assert_eq!(buffer.read_partial_felt252(60, 23), 0x793827f3165d67f66e763aac6f5739becc802496c0b353);
        assert_eq!(buffer.read_partial_felt252(51, 24), 0x40ff31b0725ba71db0793827f3165d67f66e763aac6f5739);
        assert_eq!(buffer.read_partial_felt252(74, 25), 0x39becc802496c0b35307fc6e83d2bd5b16a0dbb51337b2952a);
        assert_eq!(buffer.read_partial_felt252(63, 26), 0xf3165d67f66e763aac6f5739becc802496c0b35307fc6e83d2bd);
        assert_eq!(buffer.read_partial_felt252(50, 27), 0xb240ff31b0725ba71db0793827f3165d67f66e763aac6f5739becc);
        assert_eq!(buffer.read_partial_felt252(19, 28), 0xf3b6eb412fe73faa49d35bcf671edfeb5b75e0f21eef583dbfc6788e);
        assert_eq!(buffer.read_partial_felt252(58, 29), 0x1db0793827f3165d67f66e763aac6f5739becc802496c0b35307fc6e83);
        assert_eq!(buffer.read_partial_felt252(66, 30), 0x67f66e763aac6f5739becc802496c0b35307fc6e83d2bd5b16a0dbb51337);
        assert_eq!(buffer.read_partial_felt252(65, 31), 0x5d67f66e763aac6f5739becc802496c0b35307fc6e83d2bd5b16a0dbb51337);
        assert_eq!(buffer.hash_sha256(), [0x87b7ab0d, 0xeb3eeecf, 0x830b9024, 0x5077e09e, 0x094dadd1, 0x80fa8025, 0x49cfb6ac, 0xbdfbfc9f]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x574f59b4, 0x134b06fa, 0x0ff88bf1, 0xae79b49f, 0xb58346b9, 0xba8be6e7, 0x954f99f5, 0x6bafc1a3]);
        assert_eq!(buffer.hash_poseidon_range(107, 109), 0x56a7508555b1852c8838df9a7c62aa44cba955231a3ef42358bd9b6bca3ce0c);
        assert_eq!(buffer.hash_poseidon_range(32, 98), 0xf27036c1d0280163c53112bea41b48dfdb09e67111bdf84ba18df644844ad);
        assert_eq!(buffer.hash_poseidon_range(80, 103), 0x580b061d7eaa4d262112ff92083b8ee520766fa6b192b567c882b3538808372);
        assert_eq!(buffer.hash_poseidon_range(93, 93), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);
        assert_eq!(buffer.hash_poseidon_range(63, 76), 0xf8452de3fc377d6b5884a2633cb648b05e4908c8b320a2e4ca50471928bac5);
    }

    #[test]
    fn test_random_access() {
        // Random access test cases testing random reads

        let mut serialized_byte_array = array![0x2, 0x9856680360679b20ae729ab2665f4dac4fbdba798aa399472fd546c109dc00, 0x4e1c805a5c98431a4a06cacbc462da35c51eeb5352b3f5449f08e8695d754b, 0xae412730c3c61b5fba7ba09cd6e8d3c2a96f7f, 0x13].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(10, 11), 0x9ab2665f4dac4fbdba798a);
        assert_eq!(buffer.read_partial_felt252(43, 25), 0xc462da35c51eeb5352b3f5449f08e8695d754bae412730c3c6);
        assert_eq!(buffer.read_u64_be(71), 0x7ba09cd6e8d3c2a9);
        assert_eq!(buffer.read_partial_felt252(42, 8), 0xcbc462da35c51eeb);
        assert_eq!(buffer.read_partial_felt252(45, 20), 0xda35c51eeb5352b3f5449f08e8695d754bae4127);
        assert_eq!(buffer.read_partial_felt252(36, 4), 0x98431a4a);
        assert_eq!(buffer.read_partial_felt252(25, 30), 0xd546c109dc004e1c805a5c98431a4a06cacbc462da35c51eeb5352b3f544);
        assert_eq!(buffer.read_partial_felt252(60, 12), 0x754bae412730c3c61b5fba7b);
        assert_eq!(buffer.read_partial_felt252(45, 12), 0xda35c51eeb5352b3f5449f08);
        assert_eq!(buffer.read_partial_felt252(60, 13), 0x754bae412730c3c61b5fba7ba0);

        let mut serialized_byte_array = array![0x2, 0x343e76ffe841990c1a3038b14aefe1919da8354b446c749e9716bd07b473f7, 0x91648282a6674d6d050b8cb0defc966ef639c0e15179a46a53b5b5300d3ac4, 0xcae0b9c0caa178bbe4ee26c28de9d2204d173a7f4e01f0baa8c56dcb2e2d, 0x1e].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u128_be(33), 0x8282a6674d6d050b8cb0defc966ef639);
        assert_eq!(buffer.read_partial_felt252(19, 18), 0x4b446c749e9716bd07b473f791648282a667);
        assert_eq!(buffer.read_partial_felt252(12, 8), 0x4aefe1919da8354b);
        assert_eq!(buffer.read_u128_le(70), 0xbaf0014e7f3a174d20d2e98dc226eee4);
        assert_eq!(buffer.read_felt252(56), 0xb5b5300d3ac4cae0b9c0caa178bbe4ee26c28de9d2204d173a7f4e01f0baa8);
        assert_eq!(buffer.read_partial_felt252(57, 14), 0xb5300d3ac4cae0b9c0caa178bbe4);
        assert_eq!(buffer.read_partial_felt252(66, 9), 0xcaa178bbe4ee26c28d);
        assert_eq!(buffer.read_partial_felt252(29, 7), 0x73f791648282a6);
        assert_eq!(buffer.read_partial_felt252(59, 29), 0x0d3ac4cae0b9c0caa178bbe4ee26c28de9d2204d173a7f4e01f0baa8c5);
        assert_eq!(buffer.read_partial_felt252(70, 4), 0xe4ee26c2);

        let mut serialized_byte_array = array![0x2, 0x1fb0518bcc98bd0ab351cd2482e688f681b40069e4cf77d9e331f8f76818c3, 0xce4b211ecd5477cfb5667ba5e256a1410e76a088556d95a47f44ab8a7be3e2, 0xd76f123352aeab12227f26de6e37c3e1734a5834e646f46ce46377c9aabdc8, 0x1f].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(18, 29), 0x0069e4cf77d9e331f8f76818c3ce4b211ecd5477cfb5667ba5e256a141);
        assert_eq!(buffer.read_partial_felt252(1, 23), 0xb0518bcc98bd0ab351cd2482e688f681b40069e4cf77d9);
        assert_eq!(buffer.read_u128_le(61), 0xc3376ede267f2212abae5233126fd7e2);
        assert_eq!(buffer.read_partial_felt252(65, 23), 0x3352aeab12227f26de6e37c3e1734a5834e646f46ce463);
        assert_eq!(buffer.read_partial_felt252(41, 8), 0x7ba5e256a1410e76);
        assert_eq!(buffer.read_u32_le(79), 0xe634584a);
        assert_eq!(buffer.read_u256_be(57), 0xab8a7be3e2d76f123352aeab12227f26de6e37c3e1734a5834e646f46ce46377);
        assert_eq!(buffer.read_u128_be(64), 0x123352aeab12227f26de6e37c3e1734a);
        assert_eq!(buffer.read_partial_felt252(19, 12), 0x69e4cf77d9e331f8f76818c3);
        assert_eq!(buffer.read_partial_felt252(62, 8), 0xd76f123352aeab12);

        let mut serialized_byte_array = array![0x2, 0x423a7895600542e27e64016c9ea19161c04b9e8497060be675cea4a139d928, 0xd17cd5645b85efc70690a99748e2f8ff631436c91490558a808d09223a4525, 0x9080009ce34eec, 0x7].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(41, 11), 0xa99748e2f8ff631436c914);
        assert_eq!(buffer.read_u64_le(36), 0x4897a99006c7ef85);
        assert_eq!(buffer.read_partial_felt252(35, 1), 0x5b);
        assert_eq!(buffer.read_u32_be(20), 0x97060be6);
        assert_eq!(buffer.read_partial_felt252(33, 30), 0xd5645b85efc70690a99748e2f8ff631436c91490558a808d09223a452590);
        assert_eq!(buffer.read_partial_felt252(25, 29), 0xcea4a139d928d17cd5645b85efc70690a99748e2f8ff631436c9149055);
        assert_eq!(buffer.read_u32_le(0), 0x95783a42);
        assert_eq!(buffer.read_partial_felt252(3, 29), 0x95600542e27e64016c9ea19161c04b9e8497060be675cea4a139d928d1);
        assert_eq!(buffer.read_u128_be(9), 0x64016c9ea19161c04b9e8497060be675);
        assert_eq!(buffer.read_partial_felt252(4, 4), 0x600542e2);

        let mut serialized_byte_array = array![0x2, 0x330376299058f39a5a8013d601980fd3286679c6c7698136f4befc83439434, 0x46ffa680d41e0584adb4f408dfce1f07c9dde106bdb5ae270f2826aec9d5ba, 0xd1d28d304a9b0daa6ab6deebdd385ae3f10a7d68, 0x14].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(2, 22), 0x76299058f39a5a8013d601980fd3286679c6c7698136);
        assert_eq!(buffer.read_partial_felt252(42, 16), 0x08dfce1f07c9dde106bdb5ae270f2826);
        assert_eq!(buffer.read_partial_felt252(8, 16), 0x5a8013d601980fd3286679c6c7698136);
        assert_eq!(buffer.read_u64_le(39), 0x71fcedf08f4b4ad);
        assert_eq!(buffer.read_partial_felt252(2, 7), 0x76299058f39a5a);
        assert_eq!(buffer.read_partial_felt252(44, 13), 0xce1f07c9dde106bdb5ae270f28);
        assert_eq!(buffer.read_partial_felt252(38, 16), 0x84adb4f408dfce1f07c9dde106bdb5ae);
        assert_eq!(buffer.read_partial_felt252(20, 27), 0xc7698136f4befc8343943446ffa680d41e0584adb4f408dfce1f07);
        assert_eq!(buffer.read_partial_felt252(11, 9), 0xd601980fd3286679c6);
        assert_eq!(buffer.read_partial_felt252(44, 25), 0xce1f07c9dde106bdb5ae270f2826aec9d5bad1d28d304a9b0d);

        let mut serialized_byte_array = array![0x1, 0x98b4923a14f22b904c35e34b31bac53c861149571f60b6a4378bdde2fc5e09, 0xf0e8a78a9395f1e313041dfc2ad1e2ddfc3f16f7, 0x14].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(27, 18), 0xe2fc5e09f0e8a78a9395f1e313041dfc2ad1);
        assert_eq!(buffer.read_partial_felt252(43, 5), 0x2ad1e2ddfc);
        assert_eq!(buffer.read_partial_felt252(46, 1), 0xdd);
        assert_eq!(buffer.read_felt252(7), 0x904c35e34b31bac53c861149571f60b6a4378bdde2fc5e09f0e8a78a9395f1);
        assert_eq!(buffer.read_partial_felt252(11, 21), 0x4b31bac53c861149571f60b6a4378bdde2fc5e09f0);
        assert_eq!(buffer.read_partial_felt252(25, 25), 0x8bdde2fc5e09f0e8a78a9395f1e313041dfc2ad1e2ddfc3f16);
        assert_eq!(buffer.read_partial_felt252(30, 1), 0x09);
        assert_eq!(buffer.read_partial_felt252(13, 25), 0xbac53c861149571f60b6a4378bdde2fc5e09f0e8a78a9395f1);
        assert_eq!(buffer.read_partial_felt252(25, 12), 0x8bdde2fc5e09f0e8a78a9395);
        assert_eq!(buffer.read_partial_felt252(12, 4), 0x31bac53c);

        let mut serialized_byte_array = array![0x0, 0x8a90f53e3c254ce32160daa1030b3c6a8fd5623d6631d6ef14b858d170, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u128_be(2), 0xf53e3c254ce32160daa1030b3c6a8fd5);
        assert_eq!(buffer.read_partial_felt252(0, 21), 0x8a90f53e3c254ce32160daa1030b3c6a8fd5623d66);
        assert_eq!(buffer.read_partial_felt252(17, 4), 0xd5623d66);
        assert_eq!(buffer.read_partial_felt252(8, 19), 0x2160daa1030b3c6a8fd5623d6631d6ef14b858);
        assert_eq!(buffer.read_partial_felt252(11, 10), 0xa1030b3c6a8fd5623d66);
        assert_eq!(buffer.read_partial_felt252(0, 5), 0x8a90f53e3c);
        assert_eq!(buffer.read_partial_felt252(1, 22), 0x90f53e3c254ce32160daa1030b3c6a8fd5623d6631d6);
        assert_eq!(buffer.read_partial_felt252(1, 17), 0x90f53e3c254ce32160daa1030b3c6a8fd5);

        let mut serialized_byte_array = array![0x0, 0xe52eff64021879570b6bb3b103009d5ba5d658b635, 0x15].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(0, 20), 0xe52eff64021879570b6bb3b103009d5ba5d658b6);
        assert_eq!(buffer.read_u32_le(3), 0x79180264);
        assert_eq!(buffer.read_u32_le(10), 0x3b1b3);
        assert_eq!(buffer.read_partial_felt252(2, 7), 0xff64021879570b);
        assert_eq!(buffer.read_partial_felt252(2, 14), 0xff64021879570b6bb3b103009d5b);
        assert_eq!(buffer.read_partial_felt252(0, 20), 0xe52eff64021879570b6bb3b103009d5ba5d658b6);
        assert_eq!(buffer.read_u32_be(6), 0x79570b6b);
        assert_eq!(buffer.read_partial_felt252(11, 6), 0xb103009d5ba5);

        let mut serialized_byte_array = array![0x0, 0x79a13285f6facde83202a684b48cad78d30836dd10df2d09fdfc98, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_be(6), 0xcde8);
        assert_eq!(buffer.read_partial_felt252(0, 13), 0x79a13285f6facde83202a684b4);
        assert_eq!(buffer.read_partial_felt252(0, 15), 0x79a13285f6facde83202a684b48cad);
        assert_eq!(buffer.read_partial_felt252(5, 15), 0xfacde83202a684b48cad78d30836dd);
        assert_eq!(buffer.read_partial_felt252(10, 14), 0xa684b48cad78d30836dd10df2d09);
        assert_eq!(buffer.read_partial_felt252(3, 12), 0x85f6facde83202a684b48cad);
        assert_eq!(buffer.read_partial_felt252(12, 11), 0xb48cad78d30836dd10df2d);
        assert_eq!(buffer.read_partial_felt252(13, 4), 0x8cad78d3);

        let mut serialized_byte_array = array![0x1, 0xc1fecfc1b0204d74bea4025b7e3e05e25819103ac6e5ac598b209b3075b5be, 0xf3927c4e2a311fe430565e7bf5fb7b19aa, 0x11].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(12, 2), 0x7e3e);
        assert_eq!(buffer.read_partial_felt252(27, 19), 0x3075b5bef3927c4e2a311fe430565e7bf5fb7b);
        assert_eq!(buffer.hash_poseidon_range(28, 31), 0x1168b769b167a9c810e5f472a3dbc79b9aee9807caa33fb441a3b68b94a2961);
        assert_eq!(buffer.read_partial_felt252(35, 8), 0x2a311fe430565e7b);
        assert_eq!(buffer.read_u256_le(3), 0x4e7c92f3beb575309b208b59ace5c63a101958e2053e7e5b02a4be744d20b0c1);
        assert_eq!(buffer.read_partial_felt252(33, 11), 0x7c4e2a311fe430565e7bf5);
        assert_eq!(buffer.read_partial_felt252(44, 2), 0xfb7b);
        assert_eq!(buffer.read_partial_felt252(15, 14), 0xe25819103ac6e5ac598b209b3075);
        assert_eq!(buffer.read_partial_felt252(3, 22), 0xc1b0204d74bea4025b7e3e05e25819103ac6e5ac598b);
        assert_eq!(buffer.read_partial_felt252(32, 7), 0x927c4e2a311fe4);
    }

    // Random access out of bounds reads

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u16_le() {
        let mut serialized_byte_array = array![0x0, 0x213e43488253df8424f86c9635c11cda53b77af6bc68ce4d, 0x18].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u16_le(23);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u16_be() {
        let mut serialized_byte_array = array![0x0, 0x548dc163355b6a, 0x7].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u16_be(7);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u32_le() {
        let mut serialized_byte_array = array![0x0, 0x01c7d43b8aa003f6cbfe363ad43bb27c79567a41ab6dad88e6cee441, 0x1c].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u32_le(28);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u32_be() {
        let mut serialized_byte_array = array![0x0, 0xd29558830431dd6b69cb21655bf2594dbad6f1d11115017e, 0x18].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u32_be(21);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u64_le() {
        let mut serialized_byte_array = array![0x0, 0x477e7d47109ebc01c1, 0x9].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u64_le(7);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u64_be() {
        let mut serialized_byte_array = array![0x0, 0x0228db6933859ee20baf866645b35a1cff405aab5462fa5cbb7418, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u64_be(25);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u128_le() {
        let mut serialized_byte_array = array![0x1, 0x9b5b7bda9056a84898d5c03dcd9f9c4d83d11ff90ed412948d65266ce2d373, 0xdf7084, 0x3].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u128_le(28);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u128_be() {
        let mut serialized_byte_array = array![0x0, 0x7bb8b2bb4b55f0a5dbe85e17367515b28ae5221873e1, 0x16].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u128_be(15);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u256_le() {
        let mut serialized_byte_array = array![0x0, 0xf80d34a377b092811309aeec9a07bb6a4617c8ba82f3832675d70b12a86299, 0x1f].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u256_le(0);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u256_be() {
        let mut serialized_byte_array = array![0x1, 0x2b443f6b32184e8c7321ac4d7fee12722cc8c4696ea7e641efd165bb5b493e, 0x0ee0c6260d6c2601c9ffd3, 0xb].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u256_be(21);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252() {
        let mut serialized_byte_array = array![0x1, 0xcd64fb9fa212510baa45db6db3693fbc4053a99654f417659d6ae7f5c90aa9, 0x583062ffce0f29, 0x7].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_felt252(33);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_1b() {
        let mut serialized_byte_array = array![0x0, 0x5c7d67adc5c7b456b8f424b452a3be2225c6aeb36230f318, 0x18].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(24, 1);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_2b() {
        let mut serialized_byte_array = array![0x0, 0x9a7efffd27602a84236116a0833c41b607908e99, 0x14].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(20, 2);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_3b() {
        let mut serialized_byte_array = array![0x0, 0xa45bb404879ca2242bd51ca795e56cf0e219e787d106cac53fbb, 0x1a].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(25, 3);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_4b() {
        let mut serialized_byte_array = array![0x0, 0x1fde212f41cb9bdc1b32539c52938a69, 0x10].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(16, 4);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_5b() {
        let mut serialized_byte_array = array![0x0, 0xc46b92c1599926f489228ea8e99b7299add1, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(14, 5);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_6b() {
        let mut serialized_byte_array = array![0x0, 0x485ee3173f1b816b453ee198f5, 0xd].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(13, 6);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_7b() {
        let mut serialized_byte_array = array![0x0, 0x143d9fc4421fb081a42ded1080ec9215215207de057180c686444d1ff1dc, 0x1e].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(29, 7);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_8b() {
        let mut serialized_byte_array = array![0x0, 0xf9e915fe8b7fb6146321ba1eecaaeac1b54a009d064e, 0x16].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(20, 8);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_9b() {
        let mut serialized_byte_array = array![0x0, 0x6a0232cd8061120dd643b634cfa2842ea09c9e3baf29293b9ec44fb90847fa, 0x1f].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(28, 9);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_10b() {
        let mut serialized_byte_array = array![0x1, 0x5518535865b1b2ffaca8ee0b2f080cfdb44d02aee93d6048fa6dfcb00faf2f, 0xbf68160b88ca, 0x6].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(36, 10);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_11b() {
        let mut serialized_byte_array = array![0x0, 0x4150f9331a00a50c557be936bd8b8738891e77a0a7, 0x15].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(11, 11);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_12b() {
        let mut serialized_byte_array = array![0x0, 0x3ab43019c76da49254d38167fd3e8e7aacccba4effdae585414dd986f7, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(25, 12);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_13b() {
        let mut serialized_byte_array = array![0x1, 0x5203bf01e6bb27265f5fa45a4b4a4213f7a840f2b8410c8a3f751c375a30a7, 0xcb25, 0x2].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(32, 13);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_14b() {
        let mut serialized_byte_array = array![0x0, 0x06480e177537a883f393e87ae4fe8e, 0xf].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(5, 14);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_15b() {
        let mut serialized_byte_array = array![0x0, 0xa5750f7291189fd6095d316b1a1545d22cc1df71a1b4086f1f0471, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(27, 15);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_16b() {
        let mut serialized_byte_array = array![0x1, 0x7b0a38af624c0fc98315c1986ffd8e56c8e18faddf6d370fa7a500830a005c, 0x4957e46edb452d, 0x7].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(37, 16);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_17b() {
        let mut serialized_byte_array = array![0x1, 0x1bfcbe505cd12ba33598d5a16c52ae6d8178c78511bf0fb1b843d3ce6bda8b, 0x899f60abdad9f88472e2d9, 0xb].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(38, 17);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_18b() {
        let mut serialized_byte_array = array![0x0, 0xfccba296525f22d43da586e0c745669fce2383c3ef66cfd4d9a754, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(21, 18);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_19b() {
        let mut serialized_byte_array = array![0x1, 0xe08635cf87dcd9146e9d68b7922e457ceaedbd952250a66d1f028fd83cf4bb, 0x460ce559fc09d12af254d982e2, 0xd].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(36, 19);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_20b() {
        let mut serialized_byte_array = array![0x0, 0x8c731a1cf58d001259c66ed9b186b7fff07e7c94e65b174e10c5314c, 0x1c].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(22, 20);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_21b() {
        let mut serialized_byte_array = array![0x0, 0xda4f24d57f7fcc9366cdca0bbb5ec0c99d560c05b3f8bb6f70ca11, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(8, 21);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_22b() {
        let mut serialized_byte_array = array![0x1, 0x3f7668716988ca750e6cd1aa6070a474ca18ebe299c73b3f9d8fd5c849c534, 0xbeafc76bdb7034e22d935483aa81, 0xe].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(34, 22);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_23b() {
        let mut serialized_byte_array = array![0x1, 0x3d43cf59a530b3cffeb354d4d8637c4dcaa792834f4adddb9389c01cbcbdb5, 0xc3294d26e1328e5d7b, 0x9].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(27, 23);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_24b() {
        let mut serialized_byte_array = array![0x0, 0x153071a48f5859b4666df2d88be783c33f1dabfdaafcc2, 0x17].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(19, 24);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_25b() {
        let mut serialized_byte_array = array![0x0, 0xa0c95fec6b532d20129f6b530ba1b3abeae9c1dcb0ebdfa1220d91ba, 0x1c].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(25, 25);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_26b() {
        let mut serialized_byte_array = array![0x1, 0xc45a4eacb05cd216f1da701eac5ec834c2634e2f90876234f0b39a7b31a8ab, 0x6aa971aa087028271b82ea09110b4df764f5ad5905, 0x15].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(43, 26);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_27b() {
        let mut serialized_byte_array = array![0x1, 0x5085d4e9d5d80c16dfad2a8bf02dc6c49f36114ece5745352569cd289e0a2e, 0x65ef551e, 0x4].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(9, 27);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_28b() {
        let mut serialized_byte_array = array![0x1, 0x596d2a70e52150d1936b168c1b6f6cbacd615ab73c5e4517c177d8d4de38d4, 0x8629395b4de5c93ad737705ef459e080, 0x10].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(39, 28);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_29b() {
        let mut serialized_byte_array = array![0x1, 0x43d0e5633d481ed657d5786c3f3dd6fdb1b6d66fad5dbf43036452c4af5a04, 0x6c52535765af00f9aaf25fb179601af9, 0x10].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(27, 29);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_30b() {
        let mut serialized_byte_array = array![0x1, 0xba9cdaa39356331b4b128b5e0594684f2cb8fe9fd8b86a72f3e5ff11c09bb9, 0xac30fe8112afedc6c05ed387fba31d, 0xf].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(33, 30);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_31b() {
        let mut serialized_byte_array = array![0x1, 0x96ed2f773fffc8cec364a8027cc3b535035e40b1c8bc0b1f811a4d35a93e46, 0xf1f4b6ef, 0x4].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(31, 31);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_hash_poseidon_range() {
        let mut serialized_byte_array = array![0x1, 0x96ed2f773fffc8cec364a8027cc3b535035e40b1c8bc0b1f811a4d35a93e46, 0xf1f4b6ef, 0x4].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.hash_poseidon_range(15, 49);
    }

}