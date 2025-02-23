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
        31 => 0x100000000000000000000000000000000000000000000000000000000000000,
        _ => panic(array!['n_bytes too large']),
    }
}

#[generate_trait]
pub impl ByteArrayReader of ByteArrayReaderTrait {

    fn read_u16_le(self: @ByteArray, index: usize) -> u16 {
        let result: felt252 = self.at(index+1).expect('Array index out of bounds').into() * 0x100
            + self.at(index+0).expect('Array index out of bounds').into();
        result.try_into().unwrap()
    }

    fn read_u32_le(self: @ByteArray, index: usize) -> u32 {
        let result: felt252 = self.at(index+3).expect('Array index out of bounds').into() * 0x1000000
            + self.at(index+2).expect('Array index out of bounds').into() * 0x10000
            + self.at(index+1).expect('Array index out of bounds').into() * 0x100
            + self.at(index+0).expect('Array index out of bounds').into();
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

    fn read_u256(self: @ByteArray, index: usize) -> u256 {
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

    fn read_bytes31(self: @ByteArray, index: usize) -> felt252 {
        let result: felt252 = self.at(index).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000000000000000000000000000000000
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

    //Reads {size} bytes starting at {index} as felt252
    //NOTE: Not guaranteed to not overflow
    fn read_partial_felt252(self: @ByteArray, index: usize, size: usize) -> felt252 {
        let mut result: felt252 = 0;
        for i in 0..size {
            result += self.at(index+i).expect('Array index out of bounds').into() * one_shift_left_bytes_felt252(size-i-1);
        };
        result
    }

    //Returns sha256 hash of the data
    fn hash_sha256(self: @ByteArray) -> [u32; 8] {
        compute_sha256_byte_array(self)
    }

    //Returns double sha256 hash of the data
    fn hash_dbl_sha256(self: @ByteArray) -> [u32; 8] {
        let result = compute_sha256_byte_array(self).span();
        compute_sha256_u32_array(array![
            *result[0], *result[1], *result[2], *result[3], *result[4], *result[5], *result[6], *result[7]
        ], 0, 0)
    }

    //Hash the range starting at {start_index} (inclusive) and ending with {end_index} (not inclusive)
    // by reading the 31 byte segments, representing them as felt252 and then incrementally hashing them
    fn hash_poseidon_range(self: @ByteArray, start_index: usize, end_index: usize) -> felt252 {
        let mut hasher = PoseidonTrait::new();
        let mut index = start_index;
        while index < end_index {
            let remaining = end_index - index;
            let hash_value: felt252 = if remaining < 31 {
                self.read_partial_felt252(index, remaining)
            } else {
                self.read_bytes31(index)
            };
            hasher = hasher.update(hash_value);
            index += 31;
        };
        hasher.finalize()
    }
    
}


//All tests generated by scripts/tests_unit/byte_array.js
#[cfg(test)]
mod tests {
    use super::*;

    //Tests on random data, using all the available functions
    #[test]
    fn test_random() {
        // Random test cases testing all the functionality
        
        let mut serialized_byte_array = array![0x3, 0x98ce100d1e1887911c872de4ffa1da6d5253cc9c5b712a4a11f30cf08c810f, 0x9e699fe0e68b48dd02dd773658cb407294c1a43b88b8e0b9a3a41a7a57cf8d, 0x96b436214da70e727d7051d85328591c0bc5bb9d5444aad4b7b6d19af409f4, 0xb86cfa33970b805301529f3ffae85c1325dfef2d266ed73d27, 0x19].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(32), 0x9f69);
        assert_eq!(buffer.read_u32_le(48), 0x883ba4c1);
        assert_eq!(buffer.read_u64_le(48), 0xa3b9e0b8883ba4c1);
        assert_eq!(buffer.read_u256(74), 0x5328591c0bc5bb9d5444aad4b7b6d19af409f4b86cfa33970b805301529f3ffa);
        assert_eq!(buffer.read_bytes31(77), 0x1c0bc5bb9d5444aad4b7b6d19af409f4b86cfa33970b805301529f3ffae85c);
        assert_eq!(buffer.read_partial_felt252(11, 1), 0xe4);
        assert_eq!(buffer.read_partial_felt252(42, 2), 0x3658);
        assert_eq!(buffer.read_partial_felt252(103, 3), 0x9f3ffa);
        assert_eq!(buffer.read_partial_felt252(113, 4), 0x266ed73d);
        assert_eq!(buffer.read_partial_felt252(48, 5), 0xc1a43b88b8);
        assert_eq!(buffer.read_partial_felt252(49, 6), 0xa43b88b8e0b9);
        assert_eq!(buffer.read_partial_felt252(93, 7), 0xb86cfa33970b80);
        assert_eq!(buffer.read_partial_felt252(108, 8), 0x1325dfef2d266ed7);
        assert_eq!(buffer.read_partial_felt252(56, 9), 0xa41a7a57cf8d96b436);
        assert_eq!(buffer.read_partial_felt252(47, 10), 0x94c1a43b88b8e0b9a3a4);
        assert_eq!(buffer.read_partial_felt252(96, 11), 0x33970b805301529f3ffae8);
        assert_eq!(buffer.read_partial_felt252(39, 12), 0x2dd773658cb407294c1a43b);
        assert_eq!(buffer.read_partial_felt252(18, 13), 0xcc9c5b712a4a11f30cf08c810f);
        assert_eq!(buffer.read_partial_felt252(3, 14), 0xd1e1887911c872de4ffa1da6d52);
        assert_eq!(buffer.read_partial_felt252(39, 15), 0x2dd773658cb407294c1a43b88b8e0);
        assert_eq!(buffer.read_partial_felt252(12, 16), 0xffa1da6d5253cc9c5b712a4a11f30cf0);
        assert_eq!(buffer.read_partial_felt252(63, 17), 0xb436214da70e727d7051d85328591c0bc5);
        assert_eq!(buffer.read_partial_felt252(52, 18), 0xb8e0b9a3a41a7a57cf8d96b436214da70e72);
        assert_eq!(buffer.read_partial_felt252(6, 19), 0x87911c872de4ffa1da6d5253cc9c5b712a4a11);
        assert_eq!(buffer.read_partial_felt252(44, 20), 0xcb407294c1a43b88b8e0b9a3a41a7a57cf8d96b4);
        assert_eq!(buffer.read_partial_felt252(26, 21), 0xcf08c810f9e699fe0e68b48dd02dd773658cb4072);
        assert_eq!(buffer.read_partial_felt252(92, 22), 0xf4b86cfa33970b805301529f3ffae85c1325dfef2d26);
        assert_eq!(buffer.read_partial_felt252(83, 23), 0x44aad4b7b6d19af409f4b86cfa33970b805301529f3ffa);
        assert_eq!(buffer.read_partial_felt252(54, 24), 0xb9a3a41a7a57cf8d96b436214da70e727d7051d85328591c);
        assert_eq!(buffer.read_partial_felt252(7, 25), 0x911c872de4ffa1da6d5253cc9c5b712a4a11f30cf08c810f9e);
        assert_eq!(buffer.read_partial_felt252(90, 26), 0xf409f4b86cfa33970b805301529f3ffae85c1325dfef2d266ed7);
        assert_eq!(buffer.read_partial_felt252(80, 27), 0xbb9d5444aad4b7b6d19af409f4b86cfa33970b805301529f3ffae8);
        assert_eq!(buffer.read_partial_felt252(34, 28), 0xe0e68b48dd02dd773658cb407294c1a43b88b8e0b9a3a41a7a57cf8d);
        assert_eq!(buffer.read_partial_felt252(85, 29), 0xd4b7b6d19af409f4b86cfa33970b805301529f3ffae85c1325dfef2d26);
        assert_eq!(buffer.read_partial_felt252(79, 30), 0xc5bb9d5444aad4b7b6d19af409f4b86cfa33970b805301529f3ffae85c13);
        assert_eq!(buffer.read_partial_felt252(0, 31), 0x98ce100d1e1887911c872de4ffa1da6d5253cc9c5b712a4a11f30cf08c810f);
        assert_eq!(buffer.read_partial_felt252(1, 32), 0x6100d1e18878f73872de4ffa1da6d5253cc9c5b712a4a11f30cf08c810f9e50);
        assert_eq!(buffer.hash_sha256(), [0x46374f5b, 0x51503f2d, 0xf515264a, 0x283a82b6, 0x4c36426a, 0x7118c8c2, 0x6b9de73c, 0x7870611a]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x7d325b99, 0xb418c2ce, 0xa9e027e1, 0x53a49182, 0xb7afa09e, 0x3242b7ac, 0xbef5bfcd, 0x34ca9448]);
        assert_eq!(buffer.hash_poseidon_range(91, 102), 0x3905a14ddd0895bb8f9799930d12a0ff6d8a8bde8b2ffe0da7a68524bdced59);
        assert_eq!(buffer.hash_poseidon_range(11, 40), 0x15fc6ff0f194ddbcae84f73a0b7b88aaa06bfb61ab14eb95cbf9da414466813);
        assert_eq!(buffer.hash_poseidon_range(64, 109), 0x7cca6d958c142decca95f090ad3836c49e3bef872c11adbed8fcb2fe80cee1b);
        assert_eq!(buffer.hash_poseidon_range(50, 86), 0x7f24ff5f71ef27a324a76e2623da427a75f1076470e1534dabb4d55cc16f071);
        assert_eq!(buffer.hash_poseidon_range(74, 116), 0x32bd5a5d1d27c6bef280ad40832bd03afc777a6cca5d0d157114d8affdde184);

        let mut serialized_byte_array = array![0x3, 0x627e9d6627c5871076dce1b1ddf78e126a5e1ddb78bd5c7be2c9ca255de15c, 0xdb8ecbf68bbee21f4e61ca915c2f9a01ef6f59f1f56d87840e27de4e088c1a, 0xbd82e3e24b5a7b27dca8195b4e28b88761dcc5e595230407e605189a27e2af, 0x137fbc36cd75f50a4851e3dfcc83ee03ba15a39f9a64, 0x16].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(92), 0x13af);
        assert_eq!(buffer.read_u32_le(74), 0x87b8284e);
        assert_eq!(buffer.read_u64_le(9), 0x6a128ef7ddb1e1dc);
        assert_eq!(buffer.read_u256(65), 0xe24b5a7b27dca8195b4e28b88761dcc5e595230407e605189a27e2af137fbc36);
        assert_eq!(buffer.read_bytes31(81), 0xe595230407e605189a27e2af137fbc36cd75f50a4851e3dfcc83ee03ba15a3);
        assert_eq!(buffer.read_partial_felt252(107, 1), 0xee);
        assert_eq!(buffer.read_partial_felt252(4, 2), 0x27c5);
        assert_eq!(buffer.read_partial_felt252(5, 3), 0xc58710);
        assert_eq!(buffer.read_partial_felt252(57, 4), 0xde4e088c);
        assert_eq!(buffer.read_partial_felt252(90, 5), 0x27e2af137f);
        assert_eq!(buffer.read_partial_felt252(37, 6), 0xe21f4e61ca91);
        assert_eq!(buffer.read_partial_felt252(103, 7), 0xe3dfcc83ee03ba);
        assert_eq!(buffer.read_partial_felt252(39, 8), 0x4e61ca915c2f9a01);
        assert_eq!(buffer.read_partial_felt252(104, 9), 0xdfcc83ee03ba15a39f);
        assert_eq!(buffer.read_partial_felt252(81, 10), 0xe595230407e605189a27);
        assert_eq!(buffer.read_partial_felt252(78, 11), 0x61dcc5e595230407e60518);
        assert_eq!(buffer.read_partial_felt252(99, 12), 0xf50a4851e3dfcc83ee03ba15);
        assert_eq!(buffer.read_partial_felt252(15, 13), 0x126a5e1ddb78bd5c7be2c9ca25);
        assert_eq!(buffer.read_partial_felt252(20, 14), 0x78bd5c7be2c9ca255de15cdb8ecb);
        assert_eq!(buffer.read_partial_felt252(55, 15), 0xe27de4e088c1abd82e3e24b5a7b27);
        assert_eq!(buffer.read_partial_felt252(20, 16), 0x78bd5c7be2c9ca255de15cdb8ecbf68b);
        assert_eq!(buffer.read_partial_felt252(30, 17), 0x5cdb8ecbf68bbee21f4e61ca915c2f9a01);
        assert_eq!(buffer.read_partial_felt252(95, 18), 0xbc36cd75f50a4851e3dfcc83ee03ba15a39f);
        assert_eq!(buffer.read_partial_felt252(54, 19), 0x840e27de4e088c1abd82e3e24b5a7b27dca819);
        assert_eq!(buffer.read_partial_felt252(78, 20), 0x61dcc5e595230407e605189a27e2af137fbc36cd);
        assert_eq!(buffer.read_partial_felt252(30, 21), 0x5cdb8ecbf68bbee21f4e61ca915c2f9a01ef6f59f1);
        assert_eq!(buffer.read_partial_felt252(57, 22), 0xde4e088c1abd82e3e24b5a7b27dca8195b4e28b88761);
        assert_eq!(buffer.read_partial_felt252(87, 23), 0x5189a27e2af137fbc36cd75f50a4851e3dfcc83ee03ba);
        assert_eq!(buffer.read_partial_felt252(56, 24), 0x27de4e088c1abd82e3e24b5a7b27dca8195b4e28b88761dc);
        assert_eq!(buffer.read_partial_felt252(63, 25), 0x82e3e24b5a7b27dca8195b4e28b88761dcc5e595230407e605);
        assert_eq!(buffer.read_partial_felt252(75, 26), 0x28b88761dcc5e595230407e605189a27e2af137fbc36cd75f50a);
        assert_eq!(buffer.read_partial_felt252(29, 27), 0xe15cdb8ecbf68bbee21f4e61ca915c2f9a01ef6f59f1f56d87840e);
        assert_eq!(buffer.read_partial_felt252(6, 28), 0x871076dce1b1ddf78e126a5e1ddb78bd5c7be2c9ca255de15cdb8ecb);
        assert_eq!(buffer.read_partial_felt252(11, 29), 0xb1ddf78e126a5e1ddb78bd5c7be2c9ca255de15cdb8ecbf68bbee21f4e);
        assert_eq!(buffer.read_partial_felt252(11, 30), 0xb1ddf78e126a5e1ddb78bd5c7be2c9ca255de15cdb8ecbf68bbee21f4e61);
        assert_eq!(buffer.read_partial_felt252(58, 31), 0x4e088c1abd82e3e24b5a7b27dca8195b4e28b88761dcc5e595230407e60518);
        assert_eq!(buffer.read_partial_felt252(64, 32), 0x3e24b5a7b27dacc195b4e28b88761dcc5e595230407e605189a27e2af137fa0);
        assert_eq!(buffer.hash_sha256(), [0x35528019, 0xaa23033f, 0x14adce72, 0x55f1feb1, 0x4e15088a, 0xf1a48ef5, 0x84ff3486, 0xff7a28c0]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xe88c23d4, 0x26c37cb2, 0x742b8668, 0x84b2fc9c, 0x2426c78f, 0x37e1442b, 0x6a75d9a7, 0xa4f0196d]);
        assert_eq!(buffer.hash_poseidon_range(76, 106), 0x3b36a81b274e5c19389bf46d811865cadce03f6033f5d2a566945584ca25808);
        assert_eq!(buffer.hash_poseidon_range(55, 68), 0x2b637a4a14164c972dc1ca7461e6ae3a4880b49a8cf9f7481a133361445522e);
        assert_eq!(buffer.hash_poseidon_range(10, 18), 0x4b8b781babca457f5aabcf5110eae3c7963d7a6fd4bc68f785820935a2bf03);
        assert_eq!(buffer.hash_poseidon_range(90, 103), 0x2498fe6e293555100a1762f86573356f7c7a2571dbb543ac2dd4a61662ed5ac);
        assert_eq!(buffer.hash_poseidon_range(65, 99), 0x1c5c6e802f006a99072c109e01084884ce6a0f4ec313f8562a4570286c2441b);

        let mut serialized_byte_array = array![0x0, 0x56e68ef0602cbb97d7dff23425eb519738dd, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(2), 0xf08e);
        assert_eq!(buffer.read_u32_le(5), 0xd797bb2c);
        assert_eq!(buffer.read_u64_le(9), 0x389751eb2534f2df);
        assert_eq!(buffer.read_partial_felt252(13, 1), 0xeb);
        assert_eq!(buffer.read_partial_felt252(2, 2), 0x8ef0);
        assert_eq!(buffer.read_partial_felt252(11, 3), 0x3425eb);
        assert_eq!(buffer.read_partial_felt252(1, 4), 0xe68ef060);
        assert_eq!(buffer.read_partial_felt252(0, 5), 0x56e68ef060);
        assert_eq!(buffer.read_partial_felt252(5, 6), 0x2cbb97d7dff2);
        assert_eq!(buffer.read_partial_felt252(10, 7), 0xf23425eb519738);
        assert_eq!(buffer.read_partial_felt252(2, 8), 0x8ef0602cbb97d7df);
        assert_eq!(buffer.read_partial_felt252(4, 9), 0x602cbb97d7dff23425);
        assert_eq!(buffer.read_partial_felt252(2, 10), 0x8ef0602cbb97d7dff234);
        assert_eq!(buffer.read_partial_felt252(4, 11), 0x602cbb97d7dff23425eb51);
        assert_eq!(buffer.read_partial_felt252(3, 12), 0xf0602cbb97d7dff23425eb51);
        assert_eq!(buffer.read_partial_felt252(1, 13), 0xe68ef0602cbb97d7dff23425eb);
        assert_eq!(buffer.read_partial_felt252(3, 14), 0xf0602cbb97d7dff23425eb519738);
        assert_eq!(buffer.read_partial_felt252(0, 15), 0x56e68ef0602cbb97d7dff23425eb51);
        assert_eq!(buffer.read_partial_felt252(0, 16), 0x56e68ef0602cbb97d7dff23425eb5197);
        assert_eq!(buffer.read_partial_felt252(0, 17), 0x56e68ef0602cbb97d7dff23425eb519738);
        assert_eq!(buffer.read_partial_felt252(0, 18), 0x56e68ef0602cbb97d7dff23425eb519738dd);
        assert_eq!(buffer.hash_sha256(), [0x3296d8ca, 0xc3f09c3d, 0x1f750c7, 0x5e4576e0, 0x5bfcf5c3, 0x23c3d1ec, 0x67cafefa, 0x8f850611]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x40ef9be9, 0x44d0315f, 0x836769c8, 0x3834081e, 0x105d4a8d, 0x172163b8, 0xfcf14bb5, 0xb9020828]);
        assert_eq!(buffer.hash_poseidon_range(10, 15), 0x79552c47f4b242c1f25a73150d90ab8a2493b6406818c2fbc5347dc3d316d12);
        assert_eq!(buffer.hash_poseidon_range(11, 17), 0x5ac5ec469f964255bd49d9e3ea57b0018750f3a39f390f54769dc56aad36ec8);
        assert_eq!(buffer.hash_poseidon_range(13, 17), 0x484cf40b0fc8aae58db858af42c3b5e1ada7cf9de15e3794801df9eca64c0a5);
        assert_eq!(buffer.hash_poseidon_range(1, 11), 0x161180852e396d1968cf9a67d43d2797de4cec2607cd24347a38945e04ac6a);
        assert_eq!(buffer.hash_poseidon_range(15, 16), 0x73b9a08bd2ab79762b114ae0812aea0678283af0674beee715599fb08cfedaa);

        let mut serialized_byte_array = array![0x0, 0x054ce8a18528bb12a4eef42baa0ca1, 0xf].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(1), 0xe84c);
        assert_eq!(buffer.read_u32_le(4), 0x12bb2885);
        assert_eq!(buffer.read_u64_le(3), 0xf4eea412bb2885a1);
        assert_eq!(buffer.read_partial_felt252(4, 1), 0x85);
        assert_eq!(buffer.read_partial_felt252(6, 2), 0xbb12);
        assert_eq!(buffer.read_partial_felt252(8, 3), 0xa4eef4);
        assert_eq!(buffer.read_partial_felt252(7, 4), 0x12a4eef4);
        assert_eq!(buffer.read_partial_felt252(5, 5), 0x28bb12a4ee);
        assert_eq!(buffer.read_partial_felt252(5, 6), 0x28bb12a4eef4);
        assert_eq!(buffer.read_partial_felt252(4, 7), 0x8528bb12a4eef4);
        assert_eq!(buffer.read_partial_felt252(0, 8), 0x54ce8a18528bb12);
        assert_eq!(buffer.read_partial_felt252(5, 9), 0x28bb12a4eef42baa0c);
        assert_eq!(buffer.read_partial_felt252(1, 10), 0x4ce8a18528bb12a4eef4);
        assert_eq!(buffer.read_partial_felt252(0, 11), 0x54ce8a18528bb12a4eef4);
        assert_eq!(buffer.read_partial_felt252(2, 12), 0xe8a18528bb12a4eef42baa0c);
        assert_eq!(buffer.read_partial_felt252(0, 13), 0x54ce8a18528bb12a4eef42baa);
        assert_eq!(buffer.read_partial_felt252(0, 14), 0x54ce8a18528bb12a4eef42baa0c);
        assert_eq!(buffer.read_partial_felt252(0, 15), 0x54ce8a18528bb12a4eef42baa0ca1);
        assert_eq!(buffer.hash_sha256(), [0x7ac8d84a, 0x72a18725, 0xd1b2c455, 0x8dbb1bf8, 0xd17976ad, 0xeb97367e, 0x82cd6662, 0xfd8b9230]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x419bf84b, 0x437f13cd, 0x399cc9eb, 0x399ec29b, 0x51b3c6ad, 0xfdd09b41, 0x7d50ba9, 0x477390dc]);
        assert_eq!(buffer.hash_poseidon_range(13, 14), 0x404c388d9776724afeef4bb5c077785b76574a92fc2de51cf9bcb88e7ba758b);
        assert_eq!(buffer.hash_poseidon_range(1, 10), 0x50a283ee4faff269c37f2e69731160ddf6e01f0e10aa899c464199e6dd2fe53);
        assert_eq!(buffer.hash_poseidon_range(7, 8), 0x49acadadb7400d25e79f2bd0d56fe1dd07ee91d4d66baa49b6f7db54503c247);
        assert_eq!(buffer.hash_poseidon_range(7, 7), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);
        assert_eq!(buffer.hash_poseidon_range(0, 1), 0x16d7415cf2ba56fb52c10fed4cf73a3ac3d6c9cd2321248881b644e89f7c8e5);

        let mut serialized_byte_array = array![0x3, 0xefe933468286bfd592f81e53f9b0522ad34a09388be90bf737e157242913e8, 0x50910fff8008ad3b8f4eb61a40d21da8304338a3c87fb54b9aadb28b0e6c4a, 0x0c3afca7563a9230b82fe72067dbde4299efeba9c39dac14afa7c41184e902, 0x0d0635, 0x3].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(60), 0x4a6c);
        assert_eq!(buffer.read_u32_le(5), 0x92d5bf86);
        assert_eq!(buffer.read_u64_le(12), 0x38094ad32a52b0f9);
        assert_eq!(buffer.read_u256(10), 0x1e53f9b0522ad34a09388be90bf737e157242913e850910fff8008ad3b8f4eb6);
        assert_eq!(buffer.read_bytes31(20), 0x8be90bf737e157242913e850910fff8008ad3b8f4eb61a40d21da8304338a3);
        assert_eq!(buffer.read_partial_felt252(41, 1), 0xb6);
        assert_eq!(buffer.read_partial_felt252(47, 2), 0x3043);
        assert_eq!(buffer.read_partial_felt252(41, 3), 0xb61a40);
        assert_eq!(buffer.read_partial_felt252(34, 4), 0xff8008ad);
        assert_eq!(buffer.read_partial_felt252(88, 5), 0xc41184e902);
        assert_eq!(buffer.read_partial_felt252(30, 6), 0xe850910fff80);
        assert_eq!(buffer.read_partial_felt252(76, 7), 0xde4299efeba9c3);
        assert_eq!(buffer.read_partial_felt252(7, 8), 0xd592f81e53f9b052);
        assert_eq!(buffer.read_partial_felt252(20, 9), 0x8be90bf737e1572429);
        assert_eq!(buffer.read_partial_felt252(80, 10), 0xeba9c39dac14afa7c411);
        assert_eq!(buffer.read_partial_felt252(52, 11), 0x7fb54b9aadb28b0e6c4a0c);
        assert_eq!(buffer.read_partial_felt252(60, 12), 0x6c4a0c3afca7563a9230b82f);
        assert_eq!(buffer.read_partial_felt252(33, 13), 0xfff8008ad3b8f4eb61a40d21d);
        assert_eq!(buffer.read_partial_felt252(39, 14), 0x8f4eb61a40d21da8304338a3c87f);
        assert_eq!(buffer.read_partial_felt252(69, 15), 0x30b82fe72067dbde4299efeba9c39d);
        assert_eq!(buffer.read_partial_felt252(10, 16), 0x1e53f9b0522ad34a09388be90bf737e1);
        assert_eq!(buffer.read_partial_felt252(23, 17), 0xf737e157242913e850910fff8008ad3b8f);
        assert_eq!(buffer.read_partial_felt252(59, 18), 0xe6c4a0c3afca7563a9230b82fe72067dbde);
        assert_eq!(buffer.read_partial_felt252(43, 19), 0x40d21da8304338a3c87fb54b9aadb28b0e6c4a);
        assert_eq!(buffer.read_partial_felt252(38, 20), 0x3b8f4eb61a40d21da8304338a3c87fb54b9aadb2);
        assert_eq!(buffer.read_partial_felt252(7, 21), 0xd592f81e53f9b0522ad34a09388be90bf737e15724);
        assert_eq!(buffer.read_partial_felt252(26, 22), 0x57242913e850910fff8008ad3b8f4eb61a40d21da830);
        assert_eq!(buffer.read_partial_felt252(53, 23), 0xb54b9aadb28b0e6c4a0c3afca7563a9230b82fe72067db);
        assert_eq!(buffer.read_partial_felt252(63, 24), 0x3afca7563a9230b82fe72067dbde4299efeba9c39dac14af);
        assert_eq!(buffer.read_partial_felt252(24, 25), 0x37e157242913e850910fff8008ad3b8f4eb61a40d21da83043);
        assert_eq!(buffer.read_partial_felt252(47, 26), 0x304338a3c87fb54b9aadb28b0e6c4a0c3afca7563a9230b82fe7);
        assert_eq!(buffer.read_partial_felt252(11, 27), 0x53f9b0522ad34a09388be90bf737e157242913e850910fff8008ad);
        assert_eq!(buffer.read_partial_felt252(54, 28), 0x4b9aadb28b0e6c4a0c3afca7563a9230b82fe72067dbde4299efeba9);
        assert_eq!(buffer.read_partial_felt252(30, 29), 0xe850910fff8008ad3b8f4eb61a40d21da8304338a3c87fb54b9aadb28b);
        assert_eq!(buffer.read_partial_felt252(50, 30), 0xa3c87fb54b9aadb28b0e6c4a0c3afca7563a9230b82fe72067dbde4299ef);
        assert_eq!(buffer.read_partial_felt252(7, 31), 0xd592f81e53f9b0522ad34a09388be90bf737e157242913e850910fff8008ad);
        assert_eq!(buffer.read_partial_felt252(33, 32), 0x7ff8008ad3b8f3db61a40d21da8304338a3c87fb54b9aadb28b0e6c4a0c3afb);
        assert_eq!(buffer.hash_sha256(), [0xe0bd6972, 0xe1523414, 0xe008f66, 0xc98ffaed, 0x8be0d3b8, 0x7be26e06, 0x47e54053, 0x76d7c439]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x6ffc0c4e, 0x8a8f2509, 0x66fb6b1a, 0x3325cb0b, 0x91efac0d, 0xe470ea45, 0x4327575f, 0xaa46192]);
        assert_eq!(buffer.hash_poseidon_range(51, 64), 0x22fe250dcd39ce359ec7e4a8282f3b0c962b5e649abea3af31108073ca8609d);
        assert_eq!(buffer.hash_poseidon_range(33, 68), 0xe3b53c80afa2016af0b11d54c9dee394b0eb05bb436dcef630b0d6c7e62191);
        assert_eq!(buffer.hash_poseidon_range(36, 57), 0x4c387199e1383b20c0b1d3d48012f6da6a20afb5d18d2b172f1c76b662cbdeb);
        assert_eq!(buffer.hash_poseidon_range(26, 27), 0x2e33e8d6d3bbba25be72ad640700917de3de0c1ffa87b3a9da6ce7f489d3778);
        assert_eq!(buffer.hash_poseidon_range(17, 57), 0x6960f1555d3624086aa6a9b3d8bc6f4bad005160659705fc39027269061aec6);

        let mut serialized_byte_array = array![0x0, 0x449873e30deae23537f2, 0xa].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(0), 0x9844);
        assert_eq!(buffer.read_u32_le(2), 0xea0de373);
        assert_eq!(buffer.read_u64_le(1), 0x3735e2ea0de37398);
        assert_eq!(buffer.read_partial_felt252(1, 1), 0x98);
        assert_eq!(buffer.read_partial_felt252(1, 2), 0x9873);
        assert_eq!(buffer.read_partial_felt252(1, 3), 0x9873e3);
        assert_eq!(buffer.read_partial_felt252(2, 4), 0x73e30dea);
        assert_eq!(buffer.read_partial_felt252(2, 5), 0x73e30deae2);
        assert_eq!(buffer.read_partial_felt252(1, 6), 0x9873e30deae2);
        assert_eq!(buffer.read_partial_felt252(1, 7), 0x9873e30deae235);
        assert_eq!(buffer.read_partial_felt252(1, 8), 0x9873e30deae23537);
        assert_eq!(buffer.read_partial_felt252(0, 9), 0x449873e30deae23537);
        assert_eq!(buffer.read_partial_felt252(0, 10), 0x449873e30deae23537f2);
        assert_eq!(buffer.hash_sha256(), [0x904ba80c, 0xa81db6d2, 0x58a9a7d3, 0x2396134c, 0x3d222b8a, 0xd9ae187, 0xca703251, 0x62291210]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x97ff79e0, 0xe46277d2, 0x3327603, 0x885b393e, 0x47f6d4b0, 0x348d725e, 0x9492e11, 0x8841d6a6]);
        assert_eq!(buffer.hash_poseidon_range(5, 6), 0x2f8fa09b4535e3d820048a6460de373b7f3fab90be24dc31d3d2828a887624f);
        assert_eq!(buffer.hash_poseidon_range(9, 9), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);
        assert_eq!(buffer.hash_poseidon_range(5, 7), 0x641ea9cddfe053755eb50fa7d6fb3179f79f0b42ecc94bbf4c303e4d2e1d1ee);
        assert_eq!(buffer.hash_poseidon_range(7, 8), 0x7b2e5a227e9ebde33bd096d7dcdbe0dee5d8faf24020db08d24688d28a27790);
        assert_eq!(buffer.hash_poseidon_range(9, 9), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);

        let mut serialized_byte_array = array![0x0, 0xc778ab, 0x3].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(0), 0x78c7);
        assert_eq!(buffer.read_partial_felt252(0, 1), 0xc7);
        assert_eq!(buffer.read_partial_felt252(0, 2), 0xc778);
        assert_eq!(buffer.read_partial_felt252(0, 3), 0xc778ab);
        assert_eq!(buffer.hash_sha256(), [0x55ad21ef, 0x29004b0c, 0xfbb89142, 0x286c8b41, 0xe0420fe, 0x5c1fe8ee, 0x5e2dc14, 0x82862433]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xff208d0a, 0x64329bb8, 0xfbce6689, 0xe22a8cc8, 0xea0a1d22, 0xb36e06d5, 0xf0c7c6a2, 0x1bc02ddf]);
        assert_eq!(buffer.hash_poseidon_range(1, 1), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);
        assert_eq!(buffer.hash_poseidon_range(0, 2), 0x44cbdcd348bbe06ed21be55259f66183ee048ed583efa17ce7b46462392daef);
        assert_eq!(buffer.hash_poseidon_range(0, 1), 0x6fe87aaa18d68a62f60b80d4d402eb3fbbb8114e75c81e4cc42e9b2dd0a416f);
        assert_eq!(buffer.hash_poseidon_range(0, 1), 0x6fe87aaa18d68a62f60b80d4d402eb3fbbb8114e75c81e4cc42e9b2dd0a416f);
        assert_eq!(buffer.hash_poseidon_range(0, 0), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);

        let mut serialized_byte_array = array![0x3, 0x22dfd54f380d6be34e3f9b73c52c07efbf4b555035fb28d4248056a6c64806, 0x5700b987b19ca14e76c92ea2c784d12481d02dcb268392a64d30643cb61cf2, 0xba54eef4f7e28a3961ee7d8a18dd6e35a20fa6e36752ec6ccd3c7d7acd8af2, 0x578186ee8b2b02, 0x7].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(0), 0xdf22);
        assert_eq!(buffer.read_u32_le(7), 0x9b3f4ee3);
        assert_eq!(buffer.read_u64_le(32), 0x764ea19cb187b900);
        assert_eq!(buffer.read_u256(25), 0x8056a6c648065700b987b19ca14e76c92ea2c784d12481d02dcb268392a64d30);
        assert_eq!(buffer.read_bytes31(46), 0x2481d02dcb268392a64d30643cb61cf2ba54eef4f7e28a3961ee7d8a18dd6e);
        assert_eq!(buffer.read_partial_felt252(98, 1), 0x2b);
        assert_eq!(buffer.read_partial_felt252(54, 2), 0xa64d);
        assert_eq!(buffer.read_partial_felt252(33, 3), 0xb987b1);
        assert_eq!(buffer.read_partial_felt252(88, 4), 0x7d7acd8a);
        assert_eq!(buffer.read_partial_felt252(16, 5), 0xbf4b555035);
        assert_eq!(buffer.read_partial_felt252(34, 6), 0x87b19ca14e76);
        assert_eq!(buffer.read_partial_felt252(12, 7), 0xc52c07efbf4b55);
        assert_eq!(buffer.read_partial_felt252(85, 8), 0x6ccd3c7d7acd8af2);
        assert_eq!(buffer.read_partial_felt252(69, 9), 0x3961ee7d8a18dd6e35);
        assert_eq!(buffer.read_partial_felt252(44, 10), 0x84d12481d02dcb268392);
        assert_eq!(buffer.read_partial_felt252(1, 11), 0xdfd54f380d6be34e3f9b73);
        assert_eq!(buffer.read_partial_felt252(67, 12), 0xe28a3961ee7d8a18dd6e35a2);
        assert_eq!(buffer.read_partial_felt252(50, 13), 0xcb268392a64d30643cb61cf2ba);
        assert_eq!(buffer.read_partial_felt252(71, 14), 0xee7d8a18dd6e35a20fa6e36752ec);
        assert_eq!(buffer.read_partial_felt252(63, 15), 0x54eef4f7e28a3961ee7d8a18dd6e35);
        assert_eq!(buffer.read_partial_felt252(57, 16), 0x643cb61cf2ba54eef4f7e28a3961ee7d);
        assert_eq!(buffer.read_partial_felt252(68, 17), 0x8a3961ee7d8a18dd6e35a20fa6e36752ec);
        assert_eq!(buffer.read_partial_felt252(75, 18), 0xdd6e35a20fa6e36752ec6ccd3c7d7acd8af2);
        assert_eq!(buffer.read_partial_felt252(51, 19), 0x268392a64d30643cb61cf2ba54eef4f7e28a39);
        assert_eq!(buffer.read_partial_felt252(76, 20), 0x6e35a20fa6e36752ec6ccd3c7d7acd8af2578186);
        assert_eq!(buffer.read_partial_felt252(58, 21), 0x3cb61cf2ba54eef4f7e28a3961ee7d8a18dd6e35a2);
        assert_eq!(buffer.read_partial_felt252(20, 22), 0x35fb28d4248056a6c648065700b987b19ca14e76c92e);
        assert_eq!(buffer.read_partial_felt252(36, 23), 0x9ca14e76c92ea2c784d12481d02dcb268392a64d30643c);
        assert_eq!(buffer.read_partial_felt252(36, 24), 0x9ca14e76c92ea2c784d12481d02dcb268392a64d30643cb6);
        assert_eq!(buffer.read_partial_felt252(28, 25), 0xc648065700b987b19ca14e76c92ea2c784d12481d02dcb2683);
        assert_eq!(buffer.read_partial_felt252(55, 26), 0x4d30643cb61cf2ba54eef4f7e28a3961ee7d8a18dd6e35a20fa6);
        assert_eq!(buffer.read_partial_felt252(64, 27), 0xeef4f7e28a3961ee7d8a18dd6e35a20fa6e36752ec6ccd3c7d7acd);
        assert_eq!(buffer.read_partial_felt252(27, 28), 0xa6c648065700b987b19ca14e76c92ea2c784d12481d02dcb268392a6);
        assert_eq!(buffer.read_partial_felt252(50, 29), 0xcb268392a64d30643cb61cf2ba54eef4f7e28a3961ee7d8a18dd6e35a2);
        assert_eq!(buffer.read_partial_felt252(51, 30), 0x268392a64d30643cb61cf2ba54eef4f7e28a3961ee7d8a18dd6e35a20fa6);
        assert_eq!(buffer.read_partial_felt252(14, 31), 0x7efbf4b555035fb28d4248056a6c648065700b987b19ca14e76c92ea2c784);
        assert_eq!(buffer.read_partial_felt252(55, 32), 0x530643cb61cf22154eef4f7e28a3961ee7d8a18dd6e35a20fa6e36752ec6cc4);
        assert_eq!(buffer.hash_sha256(), [0x332fce6b, 0x902af645, 0xa08a2533, 0xe46fcc9c, 0xae45fc35, 0xc99ca81f, 0xa916c71a, 0x23812bd1]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xd55b1d3f, 0xf4b496e3, 0xba310da, 0xeea6bbaf, 0x6d89e8a3, 0x9e4cf234, 0x7676ef19, 0x28b272ce]);
        assert_eq!(buffer.hash_poseidon_range(15, 74), 0x35a54de6627a58a1a36f522205d7ba75e516c71746b7a442c9fdeca1563327e);
        assert_eq!(buffer.hash_poseidon_range(65, 65), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);
        assert_eq!(buffer.hash_poseidon_range(39, 94), 0x1b22e04b4c9d1aa6afb6226dfd32ec3a95918674fca85ae67cbbb520eb0225a);
        assert_eq!(buffer.hash_poseidon_range(32, 60), 0x15e635ea66e21407129c5b80baf9227e168db4d9de993942b719ca546dd82c7);
        assert_eq!(buffer.hash_poseidon_range(25, 58), 0x25d5e48a8f807fa43875bb487e9dce31e3146001cb63f0e98d97fd214e29fd8);

        let mut serialized_byte_array = array![0x1, 0xc48df25fdb9f83666f2b18271bf6878267d5a1c9e2c31506219db6926c5a6d, 0x1a68a379c32faa2ea7142bd5, 0xc].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(12), 0xf61b);
        assert_eq!(buffer.read_u32_le(6), 0x2b6f6683);
        assert_eq!(buffer.read_u64_le(6), 0xf61b27182b6f6683);
        assert_eq!(buffer.read_u256(1), 0x8df25fdb9f83666f2b18271bf6878267d5a1c9e2c31506219db6926c5a6d1a68);
        assert_eq!(buffer.read_bytes31(2), 0xf25fdb9f83666f2b18271bf6878267d5a1c9e2c31506219db6926c5a6d1a68);
        assert_eq!(buffer.read_partial_felt252(28, 1), 0x6c);
        assert_eq!(buffer.read_partial_felt252(18, 2), 0xa1c9);
        assert_eq!(buffer.read_partial_felt252(8, 3), 0x6f2b18);
        assert_eq!(buffer.read_partial_felt252(18, 4), 0xa1c9e2c3);
        assert_eq!(buffer.read_partial_felt252(27, 5), 0x926c5a6d1a);
        assert_eq!(buffer.read_partial_felt252(13, 6), 0xf6878267d5a1);
        assert_eq!(buffer.read_partial_felt252(25, 7), 0x9db6926c5a6d1a);
        assert_eq!(buffer.read_partial_felt252(31, 8), 0x1a68a379c32faa2e);
        assert_eq!(buffer.read_partial_felt252(4, 9), 0xdb9f83666f2b18271b);
        assert_eq!(buffer.read_partial_felt252(19, 10), 0xc9e2c31506219db6926c);
        assert_eq!(buffer.read_partial_felt252(23, 11), 0x6219db6926c5a6d1a68a3);
        assert_eq!(buffer.read_partial_felt252(2, 12), 0xf25fdb9f83666f2b18271bf6);
        assert_eq!(buffer.read_partial_felt252(11, 13), 0x271bf6878267d5a1c9e2c31506);
        assert_eq!(buffer.read_partial_felt252(18, 14), 0xa1c9e2c31506219db6926c5a6d1a);
        assert_eq!(buffer.read_partial_felt252(26, 15), 0xb6926c5a6d1a68a379c32faa2ea714);
        assert_eq!(buffer.read_partial_felt252(9, 16), 0x2b18271bf6878267d5a1c9e2c3150621);
        assert_eq!(buffer.read_partial_felt252(11, 17), 0x271bf6878267d5a1c9e2c31506219db692);
        assert_eq!(buffer.read_partial_felt252(12, 18), 0x1bf6878267d5a1c9e2c31506219db6926c5a);
        assert_eq!(buffer.read_partial_felt252(6, 19), 0x83666f2b18271bf6878267d5a1c9e2c3150621);
        assert_eq!(buffer.read_partial_felt252(8, 20), 0x6f2b18271bf6878267d5a1c9e2c31506219db692);
        assert_eq!(buffer.read_partial_felt252(1, 21), 0x8df25fdb9f83666f2b18271bf6878267d5a1c9e2c3);
        assert_eq!(buffer.read_partial_felt252(3, 22), 0x5fdb9f83666f2b18271bf6878267d5a1c9e2c3150621);
        assert_eq!(buffer.read_partial_felt252(6, 23), 0x83666f2b18271bf6878267d5a1c9e2c31506219db6926c);
        assert_eq!(buffer.read_partial_felt252(17, 24), 0xd5a1c9e2c31506219db6926c5a6d1a68a379c32faa2ea714);
        assert_eq!(buffer.read_partial_felt252(16, 25), 0x67d5a1c9e2c31506219db6926c5a6d1a68a379c32faa2ea714);
        assert_eq!(buffer.read_partial_felt252(0, 26), 0xc48df25fdb9f83666f2b18271bf6878267d5a1c9e2c31506219d);
        assert_eq!(buffer.read_partial_felt252(11, 27), 0x271bf6878267d5a1c9e2c31506219db6926c5a6d1a68a379c32faa);
        assert_eq!(buffer.read_partial_felt252(4, 28), 0xdb9f83666f2b18271bf6878267d5a1c9e2c31506219db6926c5a6d1a);
        assert_eq!(buffer.read_partial_felt252(11, 29), 0x271bf6878267d5a1c9e2c31506219db6926c5a6d1a68a379c32faa2ea7);
        assert_eq!(buffer.read_partial_felt252(12, 30), 0x1bf6878267d5a1c9e2c31506219db6926c5a6d1a68a379c32faa2ea7142b);
        assert_eq!(buffer.read_partial_felt252(6, 31), 0x83666f2b18271bf6878267d5a1c9e2c31506219db6926c5a6d1a68a379c32f);
        assert_eq!(buffer.read_partial_felt252(5, 32), 0x783666f2b1825d8f6878267d5a1c9e2c31506219db6926c5a6d1a68a379c31c);
        assert_eq!(buffer.hash_sha256(), [0x371974a7, 0x7270a65, 0xa01cd354, 0xddc67dc8, 0xe6736135, 0x1d706532, 0x78352cd, 0x126bdcf1]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x7253c89f, 0xcb6b0333, 0xedbc482a, 0x8be64636, 0x281a4a0, 0xa6ae644a, 0xbb29b41b, 0xdd767b67]);
        assert_eq!(buffer.hash_poseidon_range(0, 17), 0x5bf8ef5230f9ef72f365ffe60b392e20d0fe78e1a62ebb18bb0996baf2c9f4d);
        assert_eq!(buffer.hash_poseidon_range(23, 24), 0x2d3a12d984d95f8cf584cd788ff7ef098a9a8c2d6eb9d5d9a89ef4d6df3d7f8);
        assert_eq!(buffer.hash_poseidon_range(31, 32), 0x41d47948669c27ccfe998951bc8b6b2a2d291be4c16c41e5ac0741d0931e41);
        assert_eq!(buffer.hash_poseidon_range(36, 41), 0xf132f2a95447eeeaacc7e4bbf2269d0078bb6b7f33775658687c9a6fa194);
        assert_eq!(buffer.hash_poseidon_range(18, 37), 0x175b910870fed1faf0987178cd58e0eb3f1b8e847a9d39f9c8d25f0aa09a43a);

        let mut serialized_byte_array = array![0x0, 0x8eae1243a36e00a61526a2828a471bec7c, 0x11].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(13), 0x1b47);
        assert_eq!(buffer.read_u32_le(0), 0x4312ae8e);
        assert_eq!(buffer.read_u64_le(2), 0x2615a6006ea34312);
        assert_eq!(buffer.read_partial_felt252(6, 1), 0x0);
        assert_eq!(buffer.read_partial_felt252(1, 2), 0xae12);
        assert_eq!(buffer.read_partial_felt252(0, 3), 0x8eae12);
        assert_eq!(buffer.read_partial_felt252(9, 4), 0x26a2828a);
        assert_eq!(buffer.read_partial_felt252(1, 5), 0xae1243a36e);
        assert_eq!(buffer.read_partial_felt252(3, 6), 0x43a36e00a615);
        assert_eq!(buffer.read_partial_felt252(5, 7), 0x6e00a61526a282);
        assert_eq!(buffer.read_partial_felt252(2, 8), 0x1243a36e00a61526);
        assert_eq!(buffer.read_partial_felt252(1, 9), 0xae1243a36e00a61526);
        assert_eq!(buffer.read_partial_felt252(0, 10), 0x8eae1243a36e00a61526);
        assert_eq!(buffer.read_partial_felt252(1, 11), 0xae1243a36e00a61526a282);
        assert_eq!(buffer.read_partial_felt252(0, 12), 0x8eae1243a36e00a61526a282);
        assert_eq!(buffer.read_partial_felt252(2, 13), 0x1243a36e00a61526a2828a471b);
        assert_eq!(buffer.read_partial_felt252(1, 14), 0xae1243a36e00a61526a2828a471b);
        assert_eq!(buffer.read_partial_felt252(1, 15), 0xae1243a36e00a61526a2828a471bec);
        assert_eq!(buffer.read_partial_felt252(0, 16), 0x8eae1243a36e00a61526a2828a471bec);
        assert_eq!(buffer.read_partial_felt252(0, 17), 0x8eae1243a36e00a61526a2828a471bec7c);
        assert_eq!(buffer.hash_sha256(), [0xc41409d, 0xdd2a4bcf, 0x3c87a5b9, 0x2c8eea2a, 0x46617538, 0x719901, 0xb0a3191e, 0x7401e92a]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xdac63d5b, 0xdebfa7a, 0x99c0db2, 0xf02baf8d, 0xcc7591ff, 0xf5566b3d, 0x70245f2, 0xf2214c9a]);
        assert_eq!(buffer.hash_poseidon_range(11, 13), 0x4df167d114160600ae2061d3a0beb7dc767d762c38269b5cdaf58e49f9f496f);
        assert_eq!(buffer.hash_poseidon_range(8, 9), 0x3bd95cdf1d905df43c147a436603d33e147756f6667717c8d131be8db3c5cbc);
        assert_eq!(buffer.hash_poseidon_range(8, 11), 0x62df0a862021e3668f63c2258c3fa8b0fd710cbb470ea1f83c0073d9f202640);
        assert_eq!(buffer.hash_poseidon_range(16, 16), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);
        assert_eq!(buffer.hash_poseidon_range(14, 16), 0x213bd025b321448947f96709e59c962f39c8621fddb8a187a02dd33bb990);
    }

    //Tests on random data, using randomly choosen functions
    #[test]
    fn test_random_access() {
        // Random access test cases testing random reads

        let mut serialized_byte_array = array![0x3, 0x68b39f55765efbb8acc370b867cbbd6bd43c949bca2cde525d5a31a795cd85, 0x064bba9b7db2f31acc7fa9c1c8dcde91030bb4596ccd60dbe0c981b9aa631d, 0x5c66eb25d084cf5d4d2e1a90057a603a5007fd888344aefc9b3d656b8a47db, 0xdd00498201faf84bc537c6, 0xb].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u64_le(87), 0xdddb478a6b653d);
        assert_eq!(buffer.read_partial_felt252(46, 12), 0x91030bb4596ccd60dbe0c981);
        assert_eq!(buffer.read_partial_felt252(47, 31), 0x30bb4596ccd60dbe0c981b9aa631d5c66eb25d084cf5d4d2e1a90057a603a);
        assert_eq!(buffer.read_partial_felt252(72, 22), 0x1a90057a603a5007fd888344aefc9b3d656b8a47dbdd);
        assert_eq!(buffer.read_partial_felt252(89, 11), 0x6b8a47dbdd00498201faf8);
        assert_eq!(buffer.read_partial_felt252(75, 3), 0x7a603a);
        assert_eq!(buffer.read_partial_felt252(72, 9), 0x1a90057a603a5007fd);
        assert_eq!(buffer.hash_poseidon_range(25, 30), 0x58dd4307a5a15a3b65bbf939bf847d98fd3d356fd58625441a909fea3d008f0);
        assert_eq!(buffer.read_partial_felt252(9, 10), 0xc370b867cbbd6bd43c94);
        assert_eq!(buffer.read_partial_felt252(0, 22), 0x68b39f55765efbb8acc370b867cbbd6bd43c949bca2c);

        let mut serialized_byte_array = array![0x1, 0x3d350c37f17394f0e0b589b92852f715d14ed84787d662401ef65c35e90f23, 0x492dd7b3ebe1b041ce27a3afd2507833f7ace3e381174c447c, 0x19].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(39, 3), 0xce27a3);
        assert_eq!(buffer.read_partial_felt252(28, 5), 0xe90f23492d);
        assert_eq!(buffer.read_partial_felt252(16, 22), 0xd14ed84787d662401ef65c35e90f23492dd7b3ebe1b0);
        assert_eq!(buffer.read_partial_felt252(14, 27), 0xf715d14ed84787d662401ef65c35e90f23492dd7b3ebe1b041ce27);
        assert_eq!(buffer.read_partial_felt252(44, 4), 0x507833f7);
        assert_eq!(buffer.read_partial_felt252(31, 9), 0x492dd7b3ebe1b041ce);
        assert_eq!(buffer.read_partial_felt252(5, 25), 0x7394f0e0b589b92852f715d14ed84787d662401ef65c35e90f);
        assert_eq!(buffer.read_partial_felt252(23, 5), 0x401ef65c35);
        assert_eq!(buffer.read_partial_felt252(22, 4), 0x62401ef6);
        assert_eq!(buffer.read_partial_felt252(22, 21), 0x62401ef65c35e90f23492dd7b3ebe1b041ce27a3af);

        let mut serialized_byte_array = array![0x0, 0xa599c9fcd962401f3fc848f4de11ee98f59925253c227608, 0x18].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(14, 3), 0xee98f5);
        assert_eq!(buffer.read_partial_felt252(0, 14), 0xa599c9fcd962401f3fc848f4de11);
        assert_eq!(buffer.read_partial_felt252(1, 11), 0x99c9fcd962401f3fc848f4);
        assert_eq!(buffer.read_partial_felt252(7, 16), 0x1f3fc848f4de11ee98f59925253c2276);
        assert_eq!(buffer.read_partial_felt252(2, 2), 0xc9fc);
        assert_eq!(buffer.read_partial_felt252(3, 14), 0xfcd962401f3fc848f4de11ee98f5);

        let mut serialized_byte_array = array![0x3, 0x6e926ff99637af8f8e5bf86db4e799551753983b65adb168276d9125ab9054, 0x6d219ac7c2b5605c17cdc40efbbc4dc68f0ed52c96bf5480e82db203a5c425, 0xc8148c80a13882cc111e24bbc417c238d999118666c345c1f30fb8d909dd37, 0xff45176c02c251ae8ff73c93d67d08de99a1a3182f81c029daa03ca02a, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(29, 31), 0x90546d219ac7c2b5605c17cdc40efbbc4dc68f0ed52c96bf5480e82db203a5);
        assert_eq!(buffer.read_u64_le(29), 0xb5c2c79a216d5490);
        assert_eq!(buffer.read_partial_felt252(60, 15), 0xc425c8148c80a13882cc111e24bbc4);
        assert_eq!(buffer.read_partial_felt252(52, 25), 0xbf5480e82db203a5c425c8148c80a13882cc111e24bbc417c2);
        assert_eq!(buffer.read_partial_felt252(86, 13), 0xf30fb8d909dd37ff45176c02c2);
        assert_eq!(buffer.read_partial_felt252(78, 17), 0xd999118666c345c1f30fb8d909dd37ff45);
        assert_eq!(buffer.read_bytes31(71), 0x1e24bbc417c238d999118666c345c1f30fb8d909dd37ff45176c02c251ae8f);
        assert_eq!(buffer.read_partial_felt252(23, 23), 0x68276d9125ab90546d219ac7c2b5605c17cdc40efbbc4d);
        assert_eq!(buffer.read_partial_felt252(96, 25), 0x6c02c251ae8ff73c93d67d08de99a1a3182f81c029daa03ca0);
        assert_eq!(buffer.read_partial_felt252(95, 25), 0x176c02c251ae8ff73c93d67d08de99a1a3182f81c029daa03c);

        let mut serialized_byte_array = array![0x0, 0xc35d10543ade07a3c2e2d5959c41e74ba046546ae9556f308b8742d4d290, 0x1e].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(1, 11), 0x5d10543ade07a3c2e2d595);
        assert_eq!(buffer.read_partial_felt252(4, 24), 0x3ade07a3c2e2d5959c41e74ba046546ae9556f308b8742d4);
        assert_eq!(buffer.read_partial_felt252(8, 4), 0xc2e2d595);
        assert_eq!(buffer.read_partial_felt252(9, 16), 0xe2d5959c41e74ba046546ae9556f308b);
        assert_eq!(buffer.read_partial_felt252(10, 11), 0xd5959c41e74ba046546ae9);
        assert_eq!(buffer.read_partial_felt252(3, 26), 0x543ade07a3c2e2d5959c41e74ba046546ae9556f308b8742d4d2);
        assert_eq!(buffer.read_partial_felt252(5, 23), 0xde07a3c2e2d5959c41e74ba046546ae9556f308b8742d4);
        assert_eq!(buffer.read_partial_felt252(0, 29), 0xc35d10543ade07a3c2e2d5959c41e74ba046546ae9556f308b8742d4d2);
        assert_eq!(buffer.read_partial_felt252(6, 10), 0x7a3c2e2d5959c41e74b);
        assert_eq!(buffer.hash_poseidon_range(23, 26), 0x3eab081ee8bbc6893405ac22921036b32be02ee984242c1a31e9749b4a330cf);

        let mut serialized_byte_array = array![0x2, 0xcf299d7a473b77c32cf79aa7b44bbfc6a41e4d54713b0ee59886188cd7b12f, 0xbb08c33d7c6952c7e88f999e46024c9bc4e3fa85abe9ac134b88b38ec65e9d, 0xc11ca61f02f938ce7fa8ef3ba48780656ce51ae2b5cabc28e1f85ba254, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(67, 11), 0xf938ce7fa8ef3ba4878065);
        assert_eq!(buffer.read_partial_felt252(4, 3), 0x473b77);
        assert_eq!(buffer.read_u64_le(15), 0xe3b71544d1ea4c6);
        assert_eq!(buffer.read_partial_felt252(21, 32), 0x30ee59886188c60b12fbb08c33d7c6952c7e88f999e46024c9bc4e3fa85abe2);
        assert_eq!(buffer.read_partial_felt252(32, 12), 0x8c33d7c6952c7e88f999e46);
        assert_eq!(buffer.read_partial_felt252(10, 9), 0x9aa7b44bbfc6a41e4d);
        assert_eq!(buffer.read_partial_felt252(77, 6), 0x656ce51ae2b5);
        assert_eq!(buffer.read_partial_felt252(65, 3), 0x1f02f9);
        assert_eq!(buffer.read_u16_le(59), 0x5ec6);
        assert_eq!(buffer.read_u32_le(13), 0xa4c6bf4b);

        let mut serialized_byte_array = array![0x3, 0xb624967049fb83d2583c030c85a2c56da36a50da84c14e93f740bc8868033f, 0x92ac4f960771e82da102e42e4b7c4e7dc45ea1e52a68235e1a2d75ca9ac2c2, 0x4cf7ebe0817017cd7abf4b3e2a6670ff0261cc32822a860df4d929793ced96, 0x1258b6b2191787346099a2ee7de6a96375deba615b12d085727335, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(10, 23), 0x30c85a2c56da36a50da84c14e93f740bc8868033f92ac);
        assert_eq!(buffer.read_partial_felt252(11, 32), 0x485a2c56da36a3fda84c14e93f740bc8868033f92ac4f960771e82da102e42d);
        assert_eq!(buffer.read_partial_felt252(34, 21), 0x960771e82da102e42e4b7c4e7dc45ea1e52a68235e);
        assert_eq!(buffer.read_partial_felt252(68, 25), 0x17cd7abf4b3e2a6670ff0261cc32822a860df4d929793ced96);
        assert_eq!(buffer.read_partial_felt252(23, 19), 0x93f740bc8868033f92ac4f960771e82da102e4);
        assert_eq!(buffer.read_partial_felt252(15, 10), 0x6da36a50da84c14e93f7);
        assert_eq!(buffer.read_partial_felt252(99, 13), 0x87346099a2ee7de6a96375deba);
        assert_eq!(buffer.read_partial_felt252(111, 3), 0xba615b);
        assert_eq!(buffer.read_partial_felt252(22, 8), 0x4e93f740bc886803);
        assert_eq!(buffer.read_partial_felt252(7, 21), 0xd2583c030c85a2c56da36a50da84c14e93f740bc88);

        let mut serialized_byte_array = array![0x1, 0xb0d02443f95b87abe12d51820f576a59111e9c5c4e3a5b974e173e5453b1f5, 0x6c378d4039e4, 0x6].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(8, 20), 0xe12d51820f576a59111e9c5c4e3a5b974e173e54);
        assert_eq!(buffer.read_partial_felt252(24, 2), 0x4e17);
        assert_eq!(buffer.read_partial_felt252(16, 18), 0x111e9c5c4e3a5b974e173e5453b1f56c378d);
        assert_eq!(buffer.read_u64_le(24), 0x6cf5b153543e174e);
        assert_eq!(buffer.read_partial_felt252(0, 28), 0xb0d02443f95b87abe12d51820f576a59111e9c5c4e3a5b974e173e54);
        assert_eq!(buffer.read_partial_felt252(1, 22), 0xd02443f95b87abe12d51820f576a59111e9c5c4e3a5b);
        assert_eq!(buffer.read_partial_felt252(27, 7), 0x5453b1f56c378d);
        assert_eq!(buffer.read_partial_felt252(3, 2), 0x43f9);
        assert_eq!(buffer.read_partial_felt252(15, 13), 0x59111e9c5c4e3a5b974e173e54);
        assert_eq!(buffer.read_partial_felt252(30, 5), 0xf56c378d40);

        let mut serialized_byte_array = array![0x3, 0xfde7bcabc509157ea3bb4e468f6751db8c75977398794cfa3541342ec6773b, 0x4f3cb0ff058427366c192185a8032dba29f329fa0c0aed8c5b2d3460d42c69, 0x534bf768e5d4ec59dc6b3061be222dea7eb558fb385213ea03c6323033bf56, 0x58e633ff55ad992151fa6cfad9e76c, 0xf].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(73, 21), 0x61be222dea7eb558fb385213ea03c6323033bf5658);
        assert_eq!(buffer.read_partial_felt252(30, 27), 0x3b4f3cb0ff058427366c192185a8032dba29f329fa0c0aed8c5b2d);
        assert_eq!(buffer.read_partial_felt252(70, 9), 0xdc6b3061be222dea7e);
        assert_eq!(buffer.read_partial_felt252(64, 14), 0xf768e5d4ec59dc6b3061be222dea);
        assert_eq!(buffer.read_partial_felt252(67, 22), 0xd4ec59dc6b3061be222dea7eb558fb385213ea03c632);
        assert_eq!(buffer.read_partial_felt252(44, 11), 0x32dba29f329fa0c0aed8c);
        assert_eq!(buffer.read_u16_le(38), 0x6c36);
        assert_eq!(buffer.read_partial_felt252(64, 32), 0x768e5d4ec59da6d3061be222dea7eb558fb385213ea03c6323033bf5658e615);
        assert_eq!(buffer.read_u256(20), 0x98794cfa3541342ec6773b4f3cb0ff058427366c192185a8032dba29f329fa0c);
        assert_eq!(buffer.read_partial_felt252(47, 18), 0x29f329fa0c0aed8c5b2d3460d42c69534bf7);

        let mut serialized_byte_array = array![0x3, 0x7b302d412fbb4a924648a29360c743caaef36ef2f2359506c4d9a8673fb5f3, 0x2342e6dec797f0e0d2f7cb62c023924fbbe4fe7d610c2e096503e58d7acdd4, 0xedd33535e598de72b3d269fb72800b6e1d007d0f0076917f8c953abfbe8062, 0x2d7e7cdac9aa109d5d3588648e445c50c0c300d33b, 0x15].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(28, 27), 0x3fb5f32342e6dec797f0e0d2f7cb62c023924fbbe4fe7d610c2e09);
        assert_eq!(buffer.read_partial_felt252(74, 16), 0x72800b6e1d007d0f0076917f8c953abf);
        assert_eq!(buffer.read_partial_felt252(28, 21), 0x3fb5f32342e6dec797f0e0d2f7cb62c023924fbbe4);
        assert_eq!(buffer.read_partial_felt252(61, 17), 0xd4edd33535e598de72b3d269fb72800b6e);
        assert_eq!(buffer.read_partial_felt252(101, 3), 0x5d3588);
        assert_eq!(buffer.read_partial_felt252(92, 8), 0x622d7e7cdac9aa10);
        assert_eq!(buffer.read_partial_felt252(32, 24), 0x42e6dec797f0e0d2f7cb62c023924fbbe4fe7d610c2e0965);
        assert_eq!(buffer.read_partial_felt252(61, 31), 0xd4edd33535e598de72b3d269fb72800b6e1d007d0f0076917f8c953abfbe80);
        assert_eq!(buffer.read_u16_le(98), 0x10aa);
        assert_eq!(buffer.read_partial_felt252(46, 32), 0x7bbe4fe7d610b95096503e58d7acdd4edd33535e598de72b3d269fb72800b65);
    }

    // Random access out of bounds reads
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u16_le() {
        let mut serialized_byte_array = array![0x0, 0xed5f1bf87d7b60d6ae3cdeda1c1ba3fad9e53b, 0x13].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u16_le(19);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u32_le() {
        let mut serialized_byte_array = array![0x0, 0xecca2ece3511263ced7f, 0xa].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u32_le(8);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u64_le() {
        let mut serialized_byte_array = array![0x0, 0x157d0c099a9196babc064c0dee048200ddeb6625c3c70c9045649166, 0x1c].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u64_le(23);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u256() {
        let mut serialized_byte_array = array![0x1, 0xd9974d7b32d81e5d7f448b26075f7b3449deefd884691e8a91c28648e8bdd3, 0x274bd46ff062ef6347af96937a7cb2863a345a7493, 0x15].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u256(47);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252() {
        let mut serialized_byte_array = array![0x1, 0xd6277756e8fec0245561fc440b53612d869a52567c2780261e3e542fc9bd0b, 0x46b79f8d4b7b74d54f966fb8bee893d0eb8dc67c, 0x14].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_bytes31(51);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_1b() {
        let mut serialized_byte_array = array![0x0, 0x828685bcc598f657aebf2430ad009c56d437815263f0, 0x16].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(22, 1);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_2b() {
        let mut serialized_byte_array = array![0x0, 0x37e9ce8d9a520cf5f315fe55769a7b0c7445, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(17, 2);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_3b() {
        let mut serialized_byte_array = array![0x0, 0x219909ae0f85ab1a7315f42ad93388aa813d4212ae40f238, 0x18].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(22, 3);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_4b() {
        let mut serialized_byte_array = array![0x0, 0x68bfc93b6efa191bc930f28ef212f53ce0f54c655a20dc7901249365, 0x1c].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(25, 4);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_5b() {
        let mut serialized_byte_array = array![0x0, 0x3bd235736f9a57af51, 0x9].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(6, 5);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_6b() {
        let mut serialized_byte_array = array![0x0, 0x34371a16858409b2e4b6956de95e0be823e76dd8d6f442a723eced90, 0x1c].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(26, 6);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_7b() {
        let mut serialized_byte_array = array![0x0, 0x3757029daa5407c9fc9d768509f83a73, 0x10].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(15, 7);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_8b() {
        let mut serialized_byte_array = array![0x0, 0x7bf6554dd8c5108084f56232cef8, 0xe].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(11, 8);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_9b() {
        let mut serialized_byte_array = array![0x0, 0xdc0af723cabfc2ca44efe08deef0006cab86e8ca30da9abd, 0x18].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(23, 9);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_10b() {
        let mut serialized_byte_array = array![0x0, 0xce789d89356244409baba3, 0xb].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(6, 10);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_11b() {
        let mut serialized_byte_array = array![0x0, 0xe9bcf7bfce8a05a738d52da90a7c86a6e2e4b0, 0x13].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(13, 11);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_12b() {
        let mut serialized_byte_array = array![0x0, 0x0900e4f1d5571bad24711749ba13c2e16e5dacadf332007181d8, 0x1a].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(22, 12);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_13b() {
        let mut serialized_byte_array = array![0x0, 0xe4d8b262ead03480e4a3688da999c2, 0xf].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(11, 13);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_14b() {
        let mut serialized_byte_array = array![0x0, 0x4f7f1b43182220b65be202ac9e4a150038569e69ccc186cc, 0x18].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(19, 14);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_15b() {
        let mut serialized_byte_array = array![0x0, 0x78420afcaadad22879296b1df8416b3373dc77c5f300dde26694b196, 0x1c].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(25, 15);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_16b() {
        let mut serialized_byte_array = array![0x1, 0xe6a8c7b87fd70c931b2e914307944e6cab24abbba02e70640d352d5a26bd0f, 0xd7f465844f1c86773d78d4b0681a, 0xe].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(42, 16);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_17b() {
        let mut serialized_byte_array = array![0x0, 0x81fa1e5c4b7a76ed53524db795d27b0e823d7d46398ca0db61477eed, 0x1c].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(15, 17);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_18b() {
        let mut serialized_byte_array = array![0x0, 0x1b12326f13c0c0aab75e00191a37771676ce2f, 0x13].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(19, 18);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_19b() {
        let mut serialized_byte_array = array![0x0, 0xa10e1e5f869555b3c7153c8d7a048e39de37, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(12, 19);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_20b() {
        let mut serialized_byte_array = array![0x1, 0xf2a32d3f9ca368d7781ac16e43b53ba7d4a337ffa8b55dd07a4e6a263087cd, 0x2d5be0cceb7d7a1b293952e330dd, 0xe].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(45, 20);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_21b() {
        let mut serialized_byte_array = array![0x1, 0x2e1a8d5081b4d7afdb858ebad1cef1f82da0fc3766173544dc3569510f38af, 0x23, 0x1].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(26, 21);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_22b() {
        let mut serialized_byte_array = array![0x1, 0x612a7f877c10b2bdb3e80a31c0286adcb118a771e1fcf7b72e8a4eb2daa538, 0xfec92627db, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(33, 22);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_23b() {
        let mut serialized_byte_array = array![0x1, 0x7bc7d5f500420a8c8b0e1d91a8fdb5e4047960c60bb564eb0b34191d96a841, 0xcd831dce1185aa62, 0x8].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(21, 23);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_24b() {
        let mut serialized_byte_array = array![0x0, 0xdef0db57d6970a69d5ce60da78beb6d356f053f197da81, 0x17].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(22, 24);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_25b() {
        let mut serialized_byte_array = array![0x1, 0x6fe01201cce53fc3d2b3ae2b7141fe720e72d0d5e45ace21fc001bcf46f0e6, 0x6fec70028c9a, 0x6].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(23, 25);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_26b() {
        let mut serialized_byte_array = array![0x1, 0x6ae1144d9a4c7bb482f528d2f19977b2d7549a36cae3342ca80488cd7c9aab, 0xe3ad0096d1e8e702aa5735385ea31971880252ab1fb8a8, 0x17].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(49, 26);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_27b() {
        let mut serialized_byte_array = array![0x1, 0x7ce2f2e86f6b5a227b7b356a76e29f905606d6a61177b26b9fc9eba2da458b, 0x0748303a7973d7e371aa6adbb971e7e08e37393d659178c16f, 0x19].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(46, 27);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_28b() {
        let mut serialized_byte_array = array![0x1, 0xa1299ff90b273239d215f00c668914dd69e9cd45764d6d35602f4e86735af9, 0xd32e982da0219458328c88457f38, 0xe].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(43, 28);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_29b() {
        let mut serialized_byte_array = array![0x1, 0x330b7e7d08c02163eb086fcf24015c3cbba4ad272f566411cf0ddadbc95425, 0xdce59ca1308dcf, 0x7].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(27, 29);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_30b() {
        let mut serialized_byte_array = array![0x1, 0xb3bd8fa441d5ba7a5510ec00dac8803160b49944fbb24e33c5a6bdfb469522, 0x096a10c9576b4c58da1913ad540e5550ce59804ad68127, 0x17].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(41, 30);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_31b() {
        let mut serialized_byte_array = array![0x1, 0x56bc0d9cf0b9fd62dce55f7938a61df5c4e00ba32d7078ff188e571702111c, 0x85ef098945, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(20, 31);
    }
    
    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_32b() {
        let mut serialized_byte_array = array![0x1, 0x0b8a27ab99e88332d9bdc1b59a953fb264709158c8fdd2bea93cb2c5de3feb, 0x15bddd2842d244d380db, 0xa].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(11, 32);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_hash_poseidon_range() {
        let mut serialized_byte_array = array![0x1, 0x96ed2f773fffc8cec364a8027cc3b535035e40b1c8bc0b1f811a4d35a93e46, 0xf1f4b6ef, 0x4].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.hash_poseidon_range(15, 49);
    }

}