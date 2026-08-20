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
    
    fn read_felt252(self: @ByteArray, index: usize) -> felt252 {
        let result: felt252 = self.at(index).expect('Array index out of bounds').into() * 0x100000000000000000000000000000000000000000000000000000000000000
            + self.at(index+1).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000000000000000000000000000000000
            + self.at(index+2).expect('Array index out of bounds').into() * 0x10000000000000000000000000000000000000000000000000000000000
            + self.at(index+3).expect('Array index out of bounds').into() * 0x100000000000000000000000000000000000000000000000000000000
            + self.at(index+4).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000000000000000000000000000
            + self.at(index+5).expect('Array index out of bounds').into() * 0x10000000000000000000000000000000000000000000000000000
            + self.at(index+6).expect('Array index out of bounds').into() * 0x100000000000000000000000000000000000000000000000000
            + self.at(index+7).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000000000000000000000
            + self.at(index+8).expect('Array index out of bounds').into() * 0x10000000000000000000000000000000000000000000000
            + self.at(index+9).expect('Array index out of bounds').into() * 0x100000000000000000000000000000000000000000000
            + self.at(index+10).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000000000000000
            + self.at(index+11).expect('Array index out of bounds').into() * 0x10000000000000000000000000000000000000000
            + self.at(index+12).expect('Array index out of bounds').into() * 0x100000000000000000000000000000000000000
            + self.at(index+13).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000000000
            + self.at(index+14).expect('Array index out of bounds').into() * 0x10000000000000000000000000000000000
            + self.at(index+15).expect('Array index out of bounds').into() * 0x100000000000000000000000000000000
            + self.at(index+16).expect('Array index out of bounds').into() * 0x1000000000000000000000000000000
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
        let mut hasher = PoseidonTrait::new().update((end_index - start_index).into());
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

    #[test]
    fn test_poseidon_range_hash_includes_length() {
        let script_hash: felt252 = 0x14aabbccddeeff00112233445566778899aabbccdd;

        // 00 14 <20-byte-hash>
        let mut serialized_p2wpkh = array![0x0, script_hash, 22].span();
        let p2wpkh = Serde::<ByteArray>::deserialize(ref serialized_p2wpkh).unwrap();

        // 00 00 14 <20-byte-hash>
        let mut serialized_prefixed_p2wpkh = array![0x0, script_hash, 23].span();
        let prefixed_p2wpkh = Serde::<ByteArray>::deserialize(ref serialized_prefixed_p2wpkh).unwrap();

        assert(
            p2wpkh.hash_poseidon_range(0, p2wpkh.len())
                != prefixed_p2wpkh.hash_poseidon_range(0, prefixed_p2wpkh.len()),
            'ambigous range hash',
        );
    }

    //Tests on random data, using all the available functions
    #[test]
    fn test_random() {
        // Random test cases testing all the functionality

        let mut serialized_byte_array = array![0x3, 0xf70c6e43aa9ef2fb78eb07668e1f6fc378423ff0faa7b3a24e514490ce21fe, 0x3976e8c67c2931ace5a6844c54a8bb85cf1954c15aac0c90c49d06f10b705c, 0x2963337539902daddcbadec150f4560059a8f1d92ccc0aed2a02f302e3dd7c, 0xe861fd11d483d909bc9a, 0xa].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(90), 0xdde3);
        assert_eq!(buffer.read_u32_le(75), 0x590056f4);
        assert_eq!(buffer.read_u64_le(69), 0x56f450c1debadcad);
        assert_eq!(buffer.read_u256(16), 0x78423ff0faa7b3a24e514490ce21fe3976e8c67c2931ace5a6844c54a8bb85cf);
        assert_eq!(buffer.read_bytes31(10), 0x07668e1f6fc378423ff0faa7b3a24e514490ce21fe3976e8c67c2931ace5a6);
        assert_eq!(buffer.read_felt252(23), 0x24e514490ce20aa3976e8c67c2931ace5a6844c54a8bb85cf1954c15aac0c7c);
        assert_eq!(buffer.read_partial_felt252(86, 1), 0x2a);
        assert_eq!(buffer.read_partial_felt252(71, 2), 0xbade);
        assert_eq!(buffer.read_partial_felt252(47, 3), 0xcf1954);
        assert_eq!(buffer.read_partial_felt252(74, 4), 0x50f45600);
        assert_eq!(buffer.read_partial_felt252(31, 5), 0x3976e8c67c);
        assert_eq!(buffer.read_partial_felt252(61, 6), 0x5c2963337539);
        assert_eq!(buffer.read_partial_felt252(36, 7), 0x2931ace5a6844c);
        assert_eq!(buffer.read_partial_felt252(27, 8), 0x90ce21fe3976e8c6);
        assert_eq!(buffer.read_partial_felt252(36, 9), 0x2931ace5a6844c54a8);
        assert_eq!(buffer.read_partial_felt252(39, 10), 0xe5a6844c54a8bb85cf19);
        assert_eq!(buffer.read_partial_felt252(26, 11), 0x4490ce21fe3976e8c67c29);
        assert_eq!(buffer.read_partial_felt252(17, 12), 0x423ff0faa7b3a24e514490ce);
        assert_eq!(buffer.read_partial_felt252(40, 13), 0xa6844c54a8bb85cf1954c15aac);
        assert_eq!(buffer.read_partial_felt252(18, 14), 0x3ff0faa7b3a24e514490ce21fe39);
        assert_eq!(buffer.read_partial_felt252(43, 15), 0x54a8bb85cf1954c15aac0c90c49d06);
        assert_eq!(buffer.read_partial_felt252(26, 16), 0x4490ce21fe3976e8c67c2931ace5a684);
        assert_eq!(buffer.read_partial_felt252(38, 17), 0xace5a6844c54a8bb85cf1954c15aac0c90);
        assert_eq!(buffer.read_partial_felt252(75, 18), 0xf4560059a8f1d92ccc0aed2a02f302e3dd7c);
        assert_eq!(buffer.read_partial_felt252(48, 19), 0x1954c15aac0c90c49d06f10b705c2963337539);
        assert_eq!(buffer.read_partial_felt252(45, 20), 0xbb85cf1954c15aac0c90c49d06f10b705c296333);
        assert_eq!(buffer.read_partial_felt252(36, 21), 0x2931ace5a6844c54a8bb85cf1954c15aac0c90c49d);
        assert_eq!(buffer.read_partial_felt252(61, 22), 0x5c2963337539902daddcbadec150f4560059a8f1d92c);
        assert_eq!(buffer.read_partial_felt252(72, 23), 0xdec150f4560059a8f1d92ccc0aed2a02f302e3dd7ce861);
        assert_eq!(buffer.read_partial_felt252(21, 24), 0xa7b3a24e514490ce21fe3976e8c67c2931ace5a6844c54a8);
        assert_eq!(buffer.read_partial_felt252(37, 25), 0x31ace5a6844c54a8bb85cf1954c15aac0c90c49d06f10b705c);
        assert_eq!(buffer.read_partial_felt252(21, 26), 0xa7b3a24e514490ce21fe3976e8c67c2931ace5a6844c54a8bb85);
        assert_eq!(buffer.read_partial_felt252(55, 27), 0xc49d06f10b705c2963337539902daddcbadec150f4560059a8f1d9);
        assert_eq!(buffer.read_partial_felt252(14, 28), 0x6fc378423ff0faa7b3a24e514490ce21fe3976e8c67c2931ace5a684);
        assert_eq!(buffer.read_partial_felt252(33, 29), 0xe8c67c2931ace5a6844c54a8bb85cf1954c15aac0c90c49d06f10b705c);
        assert_eq!(buffer.read_partial_felt252(36, 30), 0x2931ace5a6844c54a8bb85cf1954c15aac0c90c49d06f10b705c29633375);
        assert_eq!(buffer.read_partial_felt252(52, 31), 0xac0c90c49d06f10b705c2963337539902daddcbadec150f4560059a8f1d92c);
        assert_eq!(buffer.read_partial_felt252(8, 32), 0xeb07668e1f6ec478423ff0faa7b3a24e514490ce21fe3976e8c67c2931acd6);
        assert_eq!(buffer.hash_sha256(), [0x6f9dd863, 0xe70ce644, 0xf3c4aa1e, 0xf3f90567, 0x547ec1b9, 0x972b5e3d, 0xcdef3976, 0x9319102d]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x365b5f1c, 0x5fca64fd, 0xdeaffec4, 0x37a40389, 0xb191f580, 0x9bc824df, 0x368fc536, 0x7ce44d2f]);
        assert_eq!(buffer.hash_poseidon_range(102, 102), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(buffer.hash_poseidon_range(88, 99), 0x6f37bb6833875e0fbb66344b2748e0f6d8c582e8b6080f2e6dd4cdf3bd44f82);
        assert_eq!(buffer.hash_poseidon_range(22, 47), 0x62fcadd11ab3d3464f3dc47f4d595e5197cb7ac48ac4a3e42f3188347f1e3af);
        assert_eq!(buffer.hash_poseidon_range(86, 97), 0x46c29c067230cc4662357608a567f06a82afba19fd961e0b117433d08f22e41);
        assert_eq!(buffer.hash_poseidon_range(62, 73), 0x5a5be8749a946c25596af0a5ec68be6c47095a9f9f731f89f8995587da209cf);

        let mut serialized_byte_array = array![0x0, 0x63cc6e19549a103955b46998e6f9ab000a351a3806e4f76f61, 0x19].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(15), 0xa00);
        assert_eq!(buffer.read_u32_le(9), 0xe69869b4);
        assert_eq!(buffer.read_u64_le(9), 0xa00abf9e69869b4);
        assert_eq!(buffer.read_partial_felt252(16, 1), 0xa);
        assert_eq!(buffer.read_partial_felt252(15, 2), 0xa);
        assert_eq!(buffer.read_partial_felt252(12, 3), 0xe6f9ab);
        assert_eq!(buffer.read_partial_felt252(12, 4), 0xe6f9ab00);
        assert_eq!(buffer.read_partial_felt252(9, 5), 0xb46998e6f9);
        assert_eq!(buffer.read_partial_felt252(14, 6), 0xab000a351a38);
        assert_eq!(buffer.read_partial_felt252(10, 7), 0x6998e6f9ab000a);
        assert_eq!(buffer.read_partial_felt252(3, 8), 0x19549a103955b469);
        assert_eq!(buffer.read_partial_felt252(6, 9), 0x103955b46998e6f9ab);
        assert_eq!(buffer.read_partial_felt252(11, 10), 0x98e6f9ab000a351a3806);
        assert_eq!(buffer.read_partial_felt252(1, 11), 0xcc6e19549a103955b46998);
        assert_eq!(buffer.read_partial_felt252(10, 12), 0x6998e6f9ab000a351a3806e4);
        assert_eq!(buffer.read_partial_felt252(7, 13), 0x3955b46998e6f9ab000a351a38);
        assert_eq!(buffer.read_partial_felt252(5, 14), 0x9a103955b46998e6f9ab000a351a);
        assert_eq!(buffer.read_partial_felt252(4, 15), 0x549a103955b46998e6f9ab000a351a);
        assert_eq!(buffer.read_partial_felt252(6, 16), 0x103955b46998e6f9ab000a351a3806e4);
        assert_eq!(buffer.read_partial_felt252(4, 17), 0x549a103955b46998e6f9ab000a351a3806);
        assert_eq!(buffer.read_partial_felt252(3, 18), 0x19549a103955b46998e6f9ab000a351a3806);
        assert_eq!(buffer.read_partial_felt252(4, 19), 0x549a103955b46998e6f9ab000a351a3806e4f7);
        assert_eq!(buffer.read_partial_felt252(1, 20), 0xcc6e19549a103955b46998e6f9ab000a351a3806);
        assert_eq!(buffer.read_partial_felt252(2, 21), 0x6e19549a103955b46998e6f9ab000a351a3806e4f7);
        assert_eq!(buffer.read_partial_felt252(1, 22), 0xcc6e19549a103955b46998e6f9ab000a351a3806e4f7);
        assert_eq!(buffer.read_partial_felt252(1, 23), 0xcc6e19549a103955b46998e6f9ab000a351a3806e4f76f);
        assert_eq!(buffer.read_partial_felt252(0, 24), 0x63cc6e19549a103955b46998e6f9ab000a351a3806e4f76f);
        assert_eq!(buffer.read_partial_felt252(0, 25), 0x63cc6e19549a103955b46998e6f9ab000a351a3806e4f76f61);
        assert_eq!(buffer.hash_sha256(), [0x6e716f9a, 0x752bdc8f, 0xe88784b1, 0xbc753662, 0xd5bb3c8e, 0x6be8355f, 0x978ddc08, 0xb2b0bb35]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xa25e94c7, 0xac45f4ea, 0x631ca791, 0x119d13b3, 0x7518210f, 0x675c856d, 0x233a8ec3, 0x71ffcb99]);
        assert_eq!(buffer.hash_poseidon_range(4, 6), 0x3d94e765dc57c3e1037907a974180a0969a0d3b9c65eeb9d5bb605ca034cf34);
        assert_eq!(buffer.hash_poseidon_range(13, 13), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(buffer.hash_poseidon_range(12, 13), 0x70f042691000e245a57458870e5c1505b1325a0dfba9d293dd5b1a4dd743eb1);
        assert_eq!(buffer.hash_poseidon_range(10, 23), 0x667a0cc839e4d684b0cce6418602805ec1c3532c9415f370987750c1fc81bb4);
        assert_eq!(buffer.hash_poseidon_range(12, 23), 0x6f2b42b016015ba49bfd2538c8b4145d5258511e1d616d5f80aacb510ba1c75);

        let mut serialized_byte_array = array![0x2, 0xc1104a68efcd2827c7cb5aab75fd962cbca2ad98bbb6c1144fc8fc16f8e79b, 0x62970c8025b379e8ee824bf59a8880ae778aa2e16db45224a4110777fb3f38, 0x34cd891e84ac, 0x6].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(2), 0x684a);
        assert_eq!(buffer.read_u32_le(29), 0x97629be7);
        assert_eq!(buffer.read_u64_le(55), 0x34383ffb770711a4);
        assert_eq!(buffer.read_u256(28), 0xf8e79b62970c8025b379e8ee824bf59a8880ae778aa2e16db45224a4110777fb);
        assert_eq!(buffer.read_bytes31(26), 0xfc16f8e79b62970c8025b379e8ee824bf59a8880ae778aa2e16db45224a411);
        assert_eq!(buffer.read_felt252(30), 0x362970c8025b236e8ee824bf59a8880ae778aa2e16db45224a4110777fb3f25);
        assert_eq!(buffer.read_partial_felt252(25, 1), 0xc8);
        assert_eq!(buffer.read_partial_felt252(19, 2), 0x98bb);
        assert_eq!(buffer.read_partial_felt252(0, 3), 0xc1104a);
        assert_eq!(buffer.read_partial_felt252(42, 4), 0xf59a8880);
        assert_eq!(buffer.read_partial_felt252(52, 5), 0xb45224a411);
        assert_eq!(buffer.read_partial_felt252(31, 6), 0x62970c8025b3);
        assert_eq!(buffer.read_partial_felt252(49, 7), 0xa2e16db45224a4);
        assert_eq!(buffer.read_partial_felt252(8, 8), 0xc7cb5aab75fd962c);
        assert_eq!(buffer.read_partial_felt252(6, 9), 0x2827c7cb5aab75fd96);
        assert_eq!(buffer.read_partial_felt252(42, 10), 0xf59a8880ae778aa2e16d);
        assert_eq!(buffer.read_partial_felt252(7, 11), 0x27c7cb5aab75fd962cbca2);
        assert_eq!(buffer.read_partial_felt252(53, 12), 0x5224a4110777fb3f3834cd89);
        assert_eq!(buffer.read_partial_felt252(42, 13), 0xf59a8880ae778aa2e16db45224);
        assert_eq!(buffer.read_partial_felt252(40, 14), 0x824bf59a8880ae778aa2e16db452);
        assert_eq!(buffer.read_partial_felt252(26, 15), 0xfc16f8e79b62970c8025b379e8ee82);
        assert_eq!(buffer.read_partial_felt252(30, 16), 0x9b62970c8025b379e8ee824bf59a8880);
        assert_eq!(buffer.read_partial_felt252(25, 17), 0xc8fc16f8e79b62970c8025b379e8ee824b);
        assert_eq!(buffer.read_partial_felt252(29, 18), 0xe79b62970c8025b379e8ee824bf59a8880ae);
        assert_eq!(buffer.read_partial_felt252(6, 19), 0x2827c7cb5aab75fd962cbca2ad98bbb6c1144f);
        assert_eq!(buffer.read_partial_felt252(40, 20), 0x824bf59a8880ae778aa2e16db45224a4110777fb);
        assert_eq!(buffer.read_partial_felt252(4, 21), 0xefcd2827c7cb5aab75fd962cbca2ad98bbb6c1144f);
        assert_eq!(buffer.read_partial_felt252(14, 22), 0x962cbca2ad98bbb6c1144fc8fc16f8e79b62970c8025);
        assert_eq!(buffer.read_partial_felt252(42, 23), 0xf59a8880ae778aa2e16db45224a4110777fb3f3834cd89);
        assert_eq!(buffer.read_partial_felt252(39, 24), 0xee824bf59a8880ae778aa2e16db45224a4110777fb3f3834);
        assert_eq!(buffer.read_partial_felt252(38, 25), 0xe8ee824bf59a8880ae778aa2e16db45224a4110777fb3f3834);
        assert_eq!(buffer.read_partial_felt252(2, 26), 0x4a68efcd2827c7cb5aab75fd962cbca2ad98bbb6c1144fc8fc16);
        assert_eq!(buffer.read_partial_felt252(26, 27), 0xfc16f8e79b62970c8025b379e8ee824bf59a8880ae778aa2e16db4);
        assert_eq!(buffer.read_partial_felt252(20, 28), 0xbbb6c1144fc8fc16f8e79b62970c8025b379e8ee824bf59a8880ae77);
        assert_eq!(buffer.read_partial_felt252(15, 29), 0x2cbca2ad98bbb6c1144fc8fc16f8e79b62970c8025b379e8ee824bf59a);
        assert_eq!(buffer.read_partial_felt252(33, 30), 0xc8025b379e8ee824bf59a8880ae778aa2e16db45224a4110777fb3f3834);
        assert_eq!(buffer.read_partial_felt252(3, 31), 0x68efcd2827c7cb5aab75fd962cbca2ad98bbb6c1144fc8fc16f8e79b62970c);
        assert_eq!(buffer.read_partial_felt252(2, 32), 0x268efcd2827c7325aab75fd962cbca2ad98bbb6c1144fc8fc16f8e79b629703);
        assert_eq!(buffer.hash_sha256(), [0x7270f50a, 0x4f4700f8, 0x300d5571, 0xa95c9156, 0x44950a16, 0x9cb426ca, 0x2c74789b, 0x6bc85db4]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x4acbf262, 0xe48f1ca3, 0x1b868ad4, 0xac05ef21, 0x3918828c, 0x36592ed1, 0x336fb84d, 0x16f9439b]);
        assert_eq!(buffer.hash_poseidon_range(35, 35), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(buffer.hash_poseidon_range(6, 43), 0x777bb6756ebdb4da771b6c2a43daef602f4a6884ad92ab87fa1d87afaa53920);
        assert_eq!(buffer.hash_poseidon_range(23, 34), 0x5566942e484674ab75338854735a7d761575df99cf5edf7fa449de29455d113);
        assert_eq!(buffer.hash_poseidon_range(13, 36), 0x335be972c3206ac4e96a1c405ee38e12368f5a485735cf37e6e89b549fa91c5);
        assert_eq!(buffer.hash_poseidon_range(38, 44), 0x294c7f867d4ae998cb82516cc46aec1e8a7131447752499dc21360b70df6a55);

        let mut serialized_byte_array = array![0x1, 0xbb0f4cab360162d20c9e80c5a1d8f106c6bb5c9e85a20445de3ec3c6895e14, 0x2f0d2e8d1be78810c2ad6e4ed0ef42, 0xf].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(35), 0xe71b);
        assert_eq!(buffer.read_u32_le(27), 0x145e89c6);
        assert_eq!(buffer.read_u64_le(20), 0xc6c33ede4504a285);
        assert_eq!(buffer.read_u256(2), 0x4cab360162d20c9e80c5a1d8f106c6bb5c9e85a20445de3ec3c6895e142f0d2e);
        assert_eq!(buffer.read_bytes31(12), 0xa1d8f106c6bb5c9e85a20445de3ec3c6895e142f0d2e8d1be78810c2ad6e4e);
        assert_eq!(buffer.read_felt252(11), 0x5a1d8f106c6b9c49e85a20445de3ec3c6895e142f0d2e8d1be78810c2ad6e36);
        assert_eq!(buffer.read_partial_felt252(38, 1), 0x10);
        assert_eq!(buffer.read_partial_felt252(21, 2), 0xa204);
        assert_eq!(buffer.read_partial_felt252(7, 3), 0xd20c9e);
        assert_eq!(buffer.read_partial_felt252(7, 4), 0xd20c9e80);
        assert_eq!(buffer.read_partial_felt252(29, 5), 0x5e142f0d2e);
        assert_eq!(buffer.read_partial_felt252(16, 6), 0xc6bb5c9e85a2);
        assert_eq!(buffer.read_partial_felt252(8, 7), 0xc9e80c5a1d8f1);
        assert_eq!(buffer.read_partial_felt252(27, 8), 0xc6895e142f0d2e8d);
        assert_eq!(buffer.read_partial_felt252(31, 9), 0x2f0d2e8d1be78810c2);
        assert_eq!(buffer.read_partial_felt252(20, 10), 0x85a20445de3ec3c6895e);
        assert_eq!(buffer.read_partial_felt252(13, 11), 0xd8f106c6bb5c9e85a20445);
        assert_eq!(buffer.read_partial_felt252(17, 12), 0xbb5c9e85a20445de3ec3c689);
        assert_eq!(buffer.read_partial_felt252(9, 13), 0x9e80c5a1d8f106c6bb5c9e85a2);
        assert_eq!(buffer.read_partial_felt252(12, 14), 0xa1d8f106c6bb5c9e85a20445de3e);
        assert_eq!(buffer.read_partial_felt252(3, 15), 0xab360162d20c9e80c5a1d8f106c6bb);
        assert_eq!(buffer.read_partial_felt252(26, 16), 0xc3c6895e142f0d2e8d1be78810c2ad6e);
        assert_eq!(buffer.read_partial_felt252(14, 17), 0xf106c6bb5c9e85a20445de3ec3c6895e14);
        assert_eq!(buffer.read_partial_felt252(24, 18), 0xde3ec3c6895e142f0d2e8d1be78810c2ad6e);
        assert_eq!(buffer.read_partial_felt252(7, 19), 0xd20c9e80c5a1d8f106c6bb5c9e85a20445de3e);
        assert_eq!(buffer.read_partial_felt252(21, 20), 0xa20445de3ec3c6895e142f0d2e8d1be78810c2ad);
        assert_eq!(buffer.read_partial_felt252(22, 21), 0x445de3ec3c6895e142f0d2e8d1be78810c2ad6e4e);
        assert_eq!(buffer.read_partial_felt252(4, 22), 0x360162d20c9e80c5a1d8f106c6bb5c9e85a20445de3e);
        assert_eq!(buffer.read_partial_felt252(2, 23), 0x4cab360162d20c9e80c5a1d8f106c6bb5c9e85a20445de);
        assert_eq!(buffer.read_partial_felt252(8, 24), 0xc9e80c5a1d8f106c6bb5c9e85a20445de3ec3c6895e142f);
        assert_eq!(buffer.read_partial_felt252(16, 25), 0xc6bb5c9e85a20445de3ec3c6895e142f0d2e8d1be78810c2ad);
        assert_eq!(buffer.read_partial_felt252(12, 26), 0xa1d8f106c6bb5c9e85a20445de3ec3c6895e142f0d2e8d1be788);
        assert_eq!(buffer.read_partial_felt252(2, 27), 0x4cab360162d20c9e80c5a1d8f106c6bb5c9e85a20445de3ec3c689);
        assert_eq!(buffer.read_partial_felt252(3, 28), 0xab360162d20c9e80c5a1d8f106c6bb5c9e85a20445de3ec3c6895e14);
        assert_eq!(buffer.read_partial_felt252(0, 29), 0xbb0f4cab360162d20c9e80c5a1d8f106c6bb5c9e85a20445de3ec3c689);
        assert_eq!(buffer.read_partial_felt252(4, 30), 0x360162d20c9e80c5a1d8f106c6bb5c9e85a20445de3ec3c6895e142f0d2e);
        assert_eq!(buffer.read_partial_felt252(8, 31), 0xc9e80c5a1d8f106c6bb5c9e85a20445de3ec3c6895e142f0d2e8d1be78810);
        assert_eq!(buffer.read_partial_felt252(2, 32), 0x4ab360162d20c0580c5a1d8f106c6bb5c9e85a20445de3ec3c6895e142f0d25);
        assert_eq!(buffer.hash_sha256(), [0xe67d4e28, 0x9f55d0d5, 0x10cd64a6, 0xf5ca022e, 0xaa7bb978, 0x13201906, 0xd16dc3f, 0x8ffdf787]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x98c243a3, 0xb0f16e78, 0xd6ead23d, 0x32998295, 0xc19c297d, 0xca42db16, 0x762045d4, 0x6fd24c49]);
        assert_eq!(buffer.hash_poseidon_range(44, 45), 0x32eb1ffee130ebdf618e7a53d99813f61346d94ae33e6d0fe0335efbea7db3f);
        assert_eq!(buffer.hash_poseidon_range(0, 9), 0x57c41faf68a87a2dc66cdd785269176708182f4d5a7e760240f736bc28658f1);
        assert_eq!(buffer.hash_poseidon_range(4, 20), 0x5647fa991df1f1e033bb2e004ca89dc9a8fe8cf715cd0dd536f3c58ad7df6d);
        assert_eq!(buffer.hash_poseidon_range(38, 38), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(buffer.hash_poseidon_range(45, 45), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);

        let mut serialized_byte_array = array![0x3, 0x14491a0058cd739966cc2d1cc2739d6d29d19acccefd145edda72536059c28, 0xfd6c3fb472096f2e82b778f70d384e7d534aa2da9e21c1b4a4b53d4678afb1, 0xdd9366ed3eb1096ae6ec25df33621a7ac59893659d5773e440cf45f3098d8e, 0x6338cebf7d4fa7e846b99961ca512e90ecc408, 0x13].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(50), 0x9eda);
        assert_eq!(buffer.read_u32_le(58), 0xb1af7846);
        assert_eq!(buffer.read_u64_le(1), 0x669973cd58001a49);
        assert_eq!(buffer.read_u256(51), 0x9e21c1b4a4b53d4678afb1dd9366ed3eb1096ae6ec25df33621a7ac59893659d);
        assert_eq!(buffer.read_bytes31(33), 0x3fb472096f2e82b778f70d384e7d534aa2da9e21c1b4a4b53d4678afb1dd93);
        assert_eq!(buffer.read_felt252(18), 0x2cccefd145edc642536059c28fd6c3fb472096f2e82b778f70d384e7d534a8f);
        assert_eq!(buffer.read_partial_felt252(43, 1), 0xd);
        assert_eq!(buffer.read_partial_felt252(67, 2), 0xb109);
        assert_eq!(buffer.read_partial_felt252(74, 3), 0x33621a);
        assert_eq!(buffer.read_partial_felt252(39, 4), 0x82b778f7);
        assert_eq!(buffer.read_partial_felt252(8, 5), 0x66cc2d1cc2);
        assert_eq!(buffer.read_partial_felt252(102, 6), 0xb99961ca512e);
        assert_eq!(buffer.read_partial_felt252(48, 7), 0x4aa2da9e21c1b4);
        assert_eq!(buffer.read_partial_felt252(50, 8), 0xda9e21c1b4a4b53d);
        assert_eq!(buffer.read_partial_felt252(55, 9), 0xa4b53d4678afb1dd93);
        assert_eq!(buffer.read_partial_felt252(14, 10), 0x9d6d29d19acccefd145e);
        assert_eq!(buffer.read_partial_felt252(45, 11), 0x4e7d534aa2da9e21c1b4a4);
        assert_eq!(buffer.read_partial_felt252(86, 12), 0x40cf45f3098d8e6338cebf7d);
        assert_eq!(buffer.read_partial_felt252(60, 13), 0xafb1dd9366ed3eb1096ae6ec25);
        assert_eq!(buffer.read_partial_felt252(8, 14), 0x66cc2d1cc2739d6d29d19acccefd);
        assert_eq!(buffer.read_partial_felt252(86, 15), 0x40cf45f3098d8e6338cebf7d4fa7e8);
        assert_eq!(buffer.read_partial_felt252(62, 16), 0xdd9366ed3eb1096ae6ec25df33621a7a);
        assert_eq!(buffer.read_partial_felt252(90, 17), 0x98d8e6338cebf7d4fa7e846b99961ca51);
        assert_eq!(buffer.read_partial_felt252(0, 18), 0x14491a0058cd739966cc2d1cc2739d6d29d1);
        assert_eq!(buffer.read_partial_felt252(52, 19), 0x21c1b4a4b53d4678afb1dd9366ed3eb1096ae6);
        assert_eq!(buffer.read_partial_felt252(9, 20), 0xcc2d1cc2739d6d29d19acccefd145edda7253605);
        assert_eq!(buffer.read_partial_felt252(87, 21), 0xcf45f3098d8e6338cebf7d4fa7e846b99961ca512e);
        assert_eq!(buffer.read_partial_felt252(36, 22), 0x96f2e82b778f70d384e7d534aa2da9e21c1b4a4b53d);
        assert_eq!(buffer.read_partial_felt252(58, 23), 0x4678afb1dd9366ed3eb1096ae6ec25df33621a7ac59893);
        assert_eq!(buffer.read_partial_felt252(77, 24), 0x7ac59893659d5773e440cf45f3098d8e6338cebf7d4fa7e8);
        assert_eq!(buffer.read_partial_felt252(49, 25), 0xa2da9e21c1b4a4b53d4678afb1dd9366ed3eb1096ae6ec25df);
        assert_eq!(buffer.read_partial_felt252(4, 26), 0x58cd739966cc2d1cc2739d6d29d19acccefd145edda72536059c);
        assert_eq!(buffer.read_partial_felt252(80, 27), 0x93659d5773e440cf45f3098d8e6338cebf7d4fa7e846b99961ca51);
        assert_eq!(buffer.read_partial_felt252(0, 28), 0x14491a0058cd739966cc2d1cc2739d6d29d19acccefd145edda72536);
        assert_eq!(buffer.read_partial_felt252(13, 29), 0x739d6d29d19acccefd145edda72536059c28fd6c3fb472096f2e82b778);
        assert_eq!(buffer.read_partial_felt252(80, 30), 0x93659d5773e440cf45f3098d8e6338cebf7d4fa7e846b99961ca512e90ec);
        assert_eq!(buffer.read_partial_felt252(10, 31), 0x2d1cc2739d6d29d19acccefd145edda72536059c28fd6c3fb472096f2e82b7);
        assert_eq!(buffer.read_partial_felt252(70, 32), 0x6ec25df3362189ec59893659d5773e440cf45f3098d8e6338cebf7d4fa7e82a);
        assert_eq!(buffer.hash_sha256(), [0xe86b4d42, 0x35c00838, 0xb607d1e5, 0x78f00f67, 0xec0cef1e, 0x4c29bfee, 0x64eb3638, 0xf98d3595]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xd6b87d92, 0x247e3c54, 0x13e0b982, 0xeef22540, 0x82a7957e, 0x4326b8e3, 0x588b1a9f, 0x7f68317d]);
        assert_eq!(buffer.hash_poseidon_range(97, 111), 0x68cd2f380ee8163e4ed1a35e51d980a3ef189830909336f973c4047b69cb7b3);
        assert_eq!(buffer.hash_poseidon_range(110, 111), 0x753b730455eea53319bac1cd713fdd2c2a7b88d6670b5da7b349788eb7839cf);
        assert_eq!(buffer.hash_poseidon_range(74, 100), 0x614f36d409ef8190645e54871b15820edc1497a26deab3667c986a0d1ac4b92);
        assert_eq!(buffer.hash_poseidon_range(34, 78), 0x5cd5fc637fa28919b7189f674972ea793ddf4c30a26065ce4ceab3505fbeb0);
        assert_eq!(buffer.hash_poseidon_range(31, 61), 0x3cdd6b71a63ae51e0cff48a12e567d924ddef1890ba960a71e7cc2a0aa830f1);

        let mut serialized_byte_array = array![0x2, 0x653007d471b5146b2669f54ab334099cc8e16f3f52e4f2ce22bed764a1bed7, 0xb1ac9475aa3bfb3a2ed08cf9f16c990985784dbd4b61bbb3d575032f755e20, 0xb7, 0x1].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(52), 0xbb61);
        assert_eq!(buffer.read_u32_le(53), 0x75d5b3bb);
        assert_eq!(buffer.read_u64_le(21), 0xa164d7be22cef2e4);
        assert_eq!(buffer.read_u256(19), 0x3f52e4f2ce22bed764a1bed7b1ac9475aa3bfb3a2ed08cf9f16c990985784dbd);
        assert_eq!(buffer.read_bytes31(1), 0x3007d471b5146b2669f54ab334099cc8e16f3f52e4f2ce22bed764a1bed7b1);
        assert_eq!(buffer.read_felt252(7), 0x32669f54ab3332c9cc8e16f3f52e4f2ce22bed764a1bed7b1ac9475aa3bfb2d);
        assert_eq!(buffer.read_partial_felt252(42, 1), 0xf9);
        assert_eq!(buffer.read_partial_felt252(4, 2), 0x71b5);
        assert_eq!(buffer.read_partial_felt252(16, 3), 0xc8e16f);
        assert_eq!(buffer.read_partial_felt252(19, 4), 0x3f52e4f2);
        assert_eq!(buffer.read_partial_felt252(3, 5), 0xd471b5146b);
        assert_eq!(buffer.read_partial_felt252(12, 6), 0xb334099cc8e1);
        assert_eq!(buffer.read_partial_felt252(3, 7), 0xd471b5146b2669);
        assert_eq!(buffer.read_partial_felt252(30, 8), 0xd7b1ac9475aa3bfb);
        assert_eq!(buffer.read_partial_felt252(17, 9), 0xe16f3f52e4f2ce22be);
        assert_eq!(buffer.read_partial_felt252(10, 10), 0xf54ab334099cc8e16f3f);
        assert_eq!(buffer.read_partial_felt252(46, 11), 0x985784dbd4b61bbb3d575);
        assert_eq!(buffer.read_partial_felt252(5, 12), 0xb5146b2669f54ab334099cc8);
        assert_eq!(buffer.read_partial_felt252(33, 13), 0x9475aa3bfb3a2ed08cf9f16c99);
        assert_eq!(buffer.read_partial_felt252(48, 14), 0x784dbd4b61bbb3d575032f755e20);
        assert_eq!(buffer.read_partial_felt252(19, 15), 0x3f52e4f2ce22bed764a1bed7b1ac94);
        assert_eq!(buffer.read_partial_felt252(20, 16), 0x52e4f2ce22bed764a1bed7b1ac9475aa);
        assert_eq!(buffer.read_partial_felt252(17, 17), 0xe16f3f52e4f2ce22bed764a1bed7b1ac94);
        assert_eq!(buffer.read_partial_felt252(5, 18), 0xb5146b2669f54ab334099cc8e16f3f52e4f2);
        assert_eq!(buffer.read_partial_felt252(28, 19), 0xa1bed7b1ac9475aa3bfb3a2ed08cf9f16c9909);
        assert_eq!(buffer.read_partial_felt252(4, 20), 0x71b5146b2669f54ab334099cc8e16f3f52e4f2ce);
        assert_eq!(buffer.read_partial_felt252(6, 21), 0x146b2669f54ab334099cc8e16f3f52e4f2ce22bed7);
        assert_eq!(buffer.read_partial_felt252(30, 22), 0xd7b1ac9475aa3bfb3a2ed08cf9f16c990985784dbd4b);
        assert_eq!(buffer.read_partial_felt252(23, 23), 0xce22bed764a1bed7b1ac9475aa3bfb3a2ed08cf9f16c99);
        assert_eq!(buffer.read_partial_felt252(10, 24), 0xf54ab334099cc8e16f3f52e4f2ce22bed764a1bed7b1ac94);
        assert_eq!(buffer.read_partial_felt252(10, 25), 0xf54ab334099cc8e16f3f52e4f2ce22bed764a1bed7b1ac9475);
        assert_eq!(buffer.read_partial_felt252(34, 26), 0x75aa3bfb3a2ed08cf9f16c990985784dbd4b61bbb3d575032f75);
        assert_eq!(buffer.read_partial_felt252(3, 27), 0xd471b5146b2669f54ab334099cc8e16f3f52e4f2ce22bed764a1be);
        assert_eq!(buffer.read_partial_felt252(9, 28), 0x69f54ab334099cc8e16f3f52e4f2ce22bed764a1bed7b1ac9475aa3b);
        assert_eq!(buffer.read_partial_felt252(4, 29), 0x71b5146b2669f54ab334099cc8e16f3f52e4f2ce22bed764a1bed7b1ac);
        assert_eq!(buffer.read_partial_felt252(2, 30), 0x7d471b5146b2669f54ab334099cc8e16f3f52e4f2ce22bed764a1bed7b1);
        assert_eq!(buffer.read_partial_felt252(2, 31), 0x7d471b5146b2669f54ab334099cc8e16f3f52e4f2ce22bed764a1bed7b1ac);
        assert_eq!(buffer.read_partial_felt252(0, 32), 0x53007d471b5139f2669f54ab334099cc8e16f3f52e4f2ce22bed764a1bed7a5);
        assert_eq!(buffer.hash_sha256(), [0x2af46a47, 0x140621f8, 0x10bb6e2a, 0x79a52a77, 0x6e0dddd0, 0xc4fff20, 0x865e3d5e, 0x93023dfa]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x9313adb4, 0xa192a1bc, 0x2def5aaf, 0x5b28d632, 0x307293a6, 0xb45736ee, 0xe05d6d8, 0xe7899f75]);
        assert_eq!(buffer.hash_poseidon_range(34, 53), 0x2e0aea6e34b93dfa537994ae132356722b4524aabac79a47a8fe23715b57bf5);
        assert_eq!(buffer.hash_poseidon_range(32, 61), 0x5c74be2115e85b39244c4939f4751698c719734bd272f6b68155f6d80648099);
        assert_eq!(buffer.hash_poseidon_range(41, 42), 0x4555631ccba4b6688859fe1e0558621485c9ed700fb9f2ef127f68d9eb27e52);
        assert_eq!(buffer.hash_poseidon_range(55, 60), 0x71a57bb31455829e13842c876c7399f741daa1af30cfa760ddd046ff0f858);
        assert_eq!(buffer.hash_poseidon_range(0, 37), 0x26a21d0649a1210ab6271d62b2d202cfc446ceef457bc38a1b29c746e5035eb);

        let mut serialized_byte_array = array![0x2, 0xbae1510af3348e6ba824f76a2ec53b58cb42091685c409cb59e2ea32320cb5, 0x7aad475724b723d94da24fec6635c6e253da5fa108b50617f98eda24140767, 0x1cd23309ff66dac8c1ae344eabcd6624714b, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(74), 0xcdab);
        assert_eq!(buffer.read_u32_le(10), 0xc52e6af7);
        assert_eq!(buffer.read_u64_le(33), 0xa24dd923b7245747);
        assert_eq!(buffer.read_u256(28), 0x320cb57aad475724b723d94da24fec6635c6e253da5fa108b50617f98eda2414);
        assert_eq!(buffer.read_bytes31(5), 0x348e6ba824f76a2ec53b58cb42091685c409cb59e2ea32320cb57aad475724);
        assert_eq!(buffer.read_felt252(41), 0x7ec6635c6e253415fa108b50617f98eda241407671cd23309ff66dac8c1ae2b);
        assert_eq!(buffer.read_partial_felt252(70, 1), 0xc1);
        assert_eq!(buffer.read_partial_felt252(43, 2), 0x6635);
        assert_eq!(buffer.read_partial_felt252(66, 3), 0xff66da);
        assert_eq!(buffer.read_partial_felt252(2, 4), 0x510af334);
        assert_eq!(buffer.read_partial_felt252(5, 5), 0x348e6ba824);
        assert_eq!(buffer.read_partial_felt252(51, 6), 0x8b50617f98e);
        assert_eq!(buffer.read_partial_felt252(34, 7), 0x5724b723d94da2);
        assert_eq!(buffer.read_partial_felt252(29, 8), 0xcb57aad475724b7);
        assert_eq!(buffer.read_partial_felt252(8, 9), 0xa824f76a2ec53b58cb);
        assert_eq!(buffer.read_partial_felt252(60, 10), 0x7671cd23309ff66dac8);
        assert_eq!(buffer.read_partial_felt252(21, 11), 0xc409cb59e2ea32320cb57a);
        assert_eq!(buffer.read_partial_felt252(6, 12), 0x8e6ba824f76a2ec53b58cb42);
        assert_eq!(buffer.read_partial_felt252(28, 13), 0x320cb57aad475724b723d94da2);
        assert_eq!(buffer.read_partial_felt252(38, 14), 0xd94da24fec6635c6e253da5fa108);
        assert_eq!(buffer.read_partial_felt252(60, 15), 0x7671cd23309ff66dac8c1ae344eab);
        assert_eq!(buffer.read_partial_felt252(61, 16), 0x671cd23309ff66dac8c1ae344eabcd66);
        assert_eq!(buffer.read_partial_felt252(8, 17), 0xa824f76a2ec53b58cb42091685c409cb59);
        assert_eq!(buffer.read_partial_felt252(21, 18), 0xc409cb59e2ea32320cb57aad475724b723d9);
        assert_eq!(buffer.read_partial_felt252(16, 19), 0xcb42091685c409cb59e2ea32320cb57aad4757);
        assert_eq!(buffer.read_partial_felt252(18, 20), 0x91685c409cb59e2ea32320cb57aad475724b723);
        assert_eq!(buffer.read_partial_felt252(15, 21), 0x58cb42091685c409cb59e2ea32320cb57aad475724);
        assert_eq!(buffer.read_partial_felt252(42, 22), 0xec6635c6e253da5fa108b50617f98eda241407671cd2);
        assert_eq!(buffer.read_partial_felt252(49, 23), 0x5fa108b50617f98eda241407671cd23309ff66dac8c1ae);
        assert_eq!(buffer.read_partial_felt252(6, 24), 0x8e6ba824f76a2ec53b58cb42091685c409cb59e2ea32320c);
        assert_eq!(buffer.read_partial_felt252(0, 25), 0xbae1510af3348e6ba824f76a2ec53b58cb42091685c409cb59);
        assert_eq!(buffer.read_partial_felt252(8, 26), 0xa824f76a2ec53b58cb42091685c409cb59e2ea32320cb57aad47);
        assert_eq!(buffer.read_partial_felt252(6, 27), 0x8e6ba824f76a2ec53b58cb42091685c409cb59e2ea32320cb57aad);
        assert_eq!(buffer.read_partial_felt252(44, 28), 0x35c6e253da5fa108b50617f98eda241407671cd23309ff66dac8c1ae);
        assert_eq!(buffer.read_partial_felt252(24, 29), 0x59e2ea32320cb57aad475724b723d94da24fec6635c6e253da5fa108b5);
        assert_eq!(buffer.read_partial_felt252(0, 30), 0xbae1510af3348e6ba824f76a2ec53b58cb42091685c409cb59e2ea32320c);
        assert_eq!(buffer.read_partial_felt252(38, 31), 0xd94da24fec6635c6e253da5fa108b50617f98eda241407671cd23309ff66da);
        assert_eq!(buffer.read_partial_felt252(32, 32), 0x5475724b723d7e8a24fec6635c6e253da5fa108b50617f98eda241407671cbd);
        assert_eq!(buffer.hash_sha256(), [0xf7eb92ac, 0x52e527c5, 0x5910c081, 0x18357f89, 0x75bdd538, 0xbe9d2102, 0xe56a64e, 0xea03a793]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x122f43fd, 0x2808e439, 0xb5f0e862, 0xb820700d, 0xdcb20bdb, 0xb430466d, 0x3fa253f2, 0x33f4d862]);
        assert_eq!(buffer.hash_poseidon_range(3, 31), 0x4bc5f0b2d0cfae8e894c9dcb512b3da4dc6fd942f2eb93ba8c10fe86892b2d7);
        assert_eq!(buffer.hash_poseidon_range(74, 76), 0x128af579527bd346f3388e210627b02e169ba2910fd7a232cd3d35ee48eb953);
        assert_eq!(buffer.hash_poseidon_range(52, 57), 0x64723dbd57be944cf8ce94d94c99b8d4c7051398327e1fdc60c648e2a94405c);
        assert_eq!(buffer.hash_poseidon_range(25, 58), 0x2e03b6ceae0d7f70723749a8a28f0bd1935286136eba2a91740a6e9ddfc8444);
        assert_eq!(buffer.hash_poseidon_range(47, 53), 0x414ffdc83fcfbded79614dec729ae79fbaed3dc550cff9370ea2dfe8089ef92);

        let mut serialized_byte_array = array![0x2, 0x0b6be3742e68b05b0a011f5ff041b9f3b43504b4dccf86ebf269bbf86404da, 0xce7bc101b04ff2726391764258c2a778559d72faba391d0daace3345aa6c92, 0x1b, 0x1].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(46), 0x5578);
        assert_eq!(buffer.read_u32_le(25), 0x64f8bb69);
        assert_eq!(buffer.read_u64_le(48), 0xaa0d1d39bafa729d);
        assert_eq!(buffer.read_u256(18), 0x04b4dccf86ebf269bbf86404dace7bc101b04ff2726391764258c2a778559d72);
        assert_eq!(buffer.read_bytes31(24), 0xf269bbf86404dace7bc101b04ff2726391764258c2a778559d72faba391d0d);
        assert_eq!(buffer.read_felt252(20), 0x4cf86ebf269ba2d6404dace7bc101b04ff2726391764258c2a778559d72fa9f);
        assert_eq!(buffer.read_partial_felt252(22, 1), 0x86);
        assert_eq!(buffer.read_partial_felt252(28, 2), 0x6404);
        assert_eq!(buffer.read_partial_felt252(17, 3), 0x3504b4);
        assert_eq!(buffer.read_partial_felt252(25, 4), 0x69bbf864);
        assert_eq!(buffer.read_partial_felt252(28, 5), 0x6404dace7b);
        assert_eq!(buffer.read_partial_felt252(35, 6), 0xb04ff2726391);
        assert_eq!(buffer.read_partial_felt252(51, 7), 0xba391d0daace33);
        assert_eq!(buffer.read_partial_felt252(32, 8), 0x7bc101b04ff27263);
        assert_eq!(buffer.read_partial_felt252(23, 9), 0xebf269bbf86404dace);
        assert_eq!(buffer.read_partial_felt252(33, 10), 0xc101b04ff27263917642);
        assert_eq!(buffer.read_partial_felt252(24, 11), 0xf269bbf86404dace7bc101);
        assert_eq!(buffer.read_partial_felt252(41, 12), 0x764258c2a778559d72faba39);
        assert_eq!(buffer.read_partial_felt252(37, 13), 0xf2726391764258c2a778559d72);
        assert_eq!(buffer.read_partial_felt252(12, 14), 0xf041b9f3b43504b4dccf86ebf269);
        assert_eq!(buffer.read_partial_felt252(44, 15), 0xc2a778559d72faba391d0daace3345);
        assert_eq!(buffer.read_partial_felt252(27, 16), 0xf86404dace7bc101b04ff27263917642);
        assert_eq!(buffer.read_partial_felt252(31, 17), 0xce7bc101b04ff2726391764258c2a77855);
        assert_eq!(buffer.read_partial_felt252(33, 18), 0xc101b04ff2726391764258c2a778559d72fa);
        assert_eq!(buffer.read_partial_felt252(10, 19), 0x1f5ff041b9f3b43504b4dccf86ebf269bbf864);
        assert_eq!(buffer.read_partial_felt252(34, 20), 0x1b04ff2726391764258c2a778559d72faba391d);
        assert_eq!(buffer.read_partial_felt252(30, 21), 0xdace7bc101b04ff2726391764258c2a778559d72fa);
        assert_eq!(buffer.read_partial_felt252(29, 22), 0x4dace7bc101b04ff2726391764258c2a778559d72fa);
        assert_eq!(buffer.read_partial_felt252(9, 23), 0x11f5ff041b9f3b43504b4dccf86ebf269bbf86404dace);
        assert_eq!(buffer.read_partial_felt252(33, 24), 0xc101b04ff2726391764258c2a778559d72faba391d0daace);
        assert_eq!(buffer.read_partial_felt252(3, 25), 0x742e68b05b0a011f5ff041b9f3b43504b4dccf86ebf269bbf8);
        assert_eq!(buffer.read_partial_felt252(18, 26), 0x4b4dccf86ebf269bbf86404dace7bc101b04ff2726391764258);
        assert_eq!(buffer.read_partial_felt252(19, 27), 0xb4dccf86ebf269bbf86404dace7bc101b04ff2726391764258c2a7);
        assert_eq!(buffer.read_partial_felt252(18, 28), 0x4b4dccf86ebf269bbf86404dace7bc101b04ff2726391764258c2a7);
        assert_eq!(buffer.read_partial_felt252(11, 29), 0x5ff041b9f3b43504b4dccf86ebf269bbf86404dace7bc101b04ff27263);
        assert_eq!(buffer.read_partial_felt252(12, 30), 0xf041b9f3b43504b4dccf86ebf269bbf86404dace7bc101b04ff272639176);
        assert_eq!(buffer.read_partial_felt252(9, 31), 0x11f5ff041b9f3b43504b4dccf86ebf269bbf86404dace7bc101b04ff27263);
        assert_eq!(buffer.read_partial_felt252(23, 32), 0x3f269bbf86402edce7bc101b04ff2726391764258c2a778559d72faba391cf0);
        assert_eq!(buffer.hash_sha256(), [0x403d7c22, 0x59644db, 0xcd2a67b9, 0xed29ef1d, 0x73580be6, 0x76616441, 0x7c2dcb3e, 0x110acb24]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x96315a93, 0xb6f02ca8, 0x1ebe78df, 0x3a8f747a, 0xd9f26842, 0x7d51fb2d, 0xad177ac8, 0xcf5f62f5]);
        assert_eq!(buffer.hash_poseidon_range(39, 39), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(buffer.hash_poseidon_range(24, 62), 0xf0ab26472a21ab9ab57635aa6b3bdf85b45defb27638aae76ac852543fee40);
        assert_eq!(buffer.hash_poseidon_range(26, 31), 0x2c01aad5500c3f6b2e5e7132144663f218e1a587793252e89e8446745eb3ec6);
        assert_eq!(buffer.hash_poseidon_range(51, 62), 0x3d431069dc539cc9cfe0d9472d8a547bd2ac042115906040e24c0b6005a976e);
        assert_eq!(buffer.hash_poseidon_range(20, 60), 0xa22d9f6fd74878252194308ba42b69d25d574e7eeff11d64ebefab08ba301a);

        let mut serialized_byte_array = array![0x2, 0xcd1bcbae01b77aa47a1f93f0faa427761738622ed756b9d6bfecd6a8febb41, 0x9b1c2588a05ecb09ae0dbb0dad81b354ed6e454fbdc2ff75628f38d761bb62, 0x4e84f71bd602591f7f4e820afc8f74b025cb590bd68e65d181804f71e179, 0x1e].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(14), 0x7627);
        assert_eq!(buffer.read_u32_le(50), 0xffc2bd4f);
        assert_eq!(buffer.read_u64_le(29), 0x5ea088251c9b41bb);
        assert_eq!(buffer.read_u256(11), 0xf0faa427761738622ed756b9d6bfecd6a8febb419b1c2588a05ecb09ae0dbb0d);
        assert_eq!(buffer.read_bytes31(17), 0x38622ed756b9d6bfecd6a8febb419b1c2588a05ecb09ae0dbb0dad81b354ed);
        assert_eq!(buffer.read_felt252(45), 0x354ed6e454fbc4cff75628f38d761bb624e84f71bd602591f7f4e820afc8f5e);
        assert_eq!(buffer.read_partial_felt252(84, 1), 0x65);
        assert_eq!(buffer.read_partial_felt252(81, 2), 0xbd6);
        assert_eq!(buffer.read_partial_felt252(35, 3), 0xa05ecb);
        assert_eq!(buffer.read_partial_felt252(2, 4), 0xcbae01b7);
        assert_eq!(buffer.read_partial_felt252(81, 5), 0xbd68e65d1);
        assert_eq!(buffer.read_partial_felt252(75, 6), 0x8f74b025cb59);
        assert_eq!(buffer.read_partial_felt252(61, 7), 0x624e84f71bd602);
        assert_eq!(buffer.read_partial_felt252(34, 8), 0x88a05ecb09ae0dbb);
        assert_eq!(buffer.read_partial_felt252(72, 9), 0x820afc8f74b025cb59);
        assert_eq!(buffer.read_partial_felt252(50, 10), 0x4fbdc2ff75628f38d761);
        assert_eq!(buffer.read_partial_felt252(68, 11), 0x591f7f4e820afc8f74b025);
        assert_eq!(buffer.read_partial_felt252(42, 12), 0xdad81b354ed6e454fbdc2ff);
        assert_eq!(buffer.read_partial_felt252(27, 13), 0xa8febb419b1c2588a05ecb09ae);
        assert_eq!(buffer.read_partial_felt252(44, 14), 0x81b354ed6e454fbdc2ff75628f38);
        assert_eq!(buffer.read_partial_felt252(39, 15), 0xae0dbb0dad81b354ed6e454fbdc2ff);
        assert_eq!(buffer.read_partial_felt252(22, 16), 0xb9d6bfecd6a8febb419b1c2588a05ecb);
        assert_eq!(buffer.read_partial_felt252(0, 17), 0xcd1bcbae01b77aa47a1f93f0faa4277617);
        assert_eq!(buffer.read_partial_felt252(46, 18), 0x54ed6e454fbdc2ff75628f38d761bb624e84);
        assert_eq!(buffer.read_partial_felt252(49, 19), 0x454fbdc2ff75628f38d761bb624e84f71bd602);
        assert_eq!(buffer.read_partial_felt252(5, 20), 0xb77aa47a1f93f0faa427761738622ed756b9d6bf);
        assert_eq!(buffer.read_partial_felt252(66, 21), 0xd602591f7f4e820afc8f74b025cb590bd68e65d181);
        assert_eq!(buffer.read_partial_felt252(48, 22), 0x6e454fbdc2ff75628f38d761bb624e84f71bd602591f);
        assert_eq!(buffer.read_partial_felt252(53, 23), 0xff75628f38d761bb624e84f71bd602591f7f4e820afc8f);
        assert_eq!(buffer.read_partial_felt252(29, 24), 0xbb419b1c2588a05ecb09ae0dbb0dad81b354ed6e454fbdc2);
        assert_eq!(buffer.read_partial_felt252(38, 25), 0x9ae0dbb0dad81b354ed6e454fbdc2ff75628f38d761bb624e);
        assert_eq!(buffer.read_partial_felt252(42, 26), 0xdad81b354ed6e454fbdc2ff75628f38d761bb624e84f71bd602);
        assert_eq!(buffer.read_partial_felt252(20, 27), 0xd756b9d6bfecd6a8febb419b1c2588a05ecb09ae0dbb0dad81b354);
        assert_eq!(buffer.read_partial_felt252(31, 28), 0x9b1c2588a05ecb09ae0dbb0dad81b354ed6e454fbdc2ff75628f38d7);
        assert_eq!(buffer.read_partial_felt252(4, 29), 0x1b77aa47a1f93f0faa427761738622ed756b9d6bfecd6a8febb419b1c);
        assert_eq!(buffer.read_partial_felt252(25, 30), 0xecd6a8febb419b1c2588a05ecb09ae0dbb0dad81b354ed6e454fbdc2ff75);
        assert_eq!(buffer.read_partial_felt252(44, 31), 0x81b354ed6e454fbdc2ff75628f38d761bb624e84f71bd602591f7f4e820afc);
        assert_eq!(buffer.read_partial_felt252(10, 32), 0x3f0faa427761606622ed756b9d6bfecd6a8febb419b1c2588a05ecb09ae0da9);
        assert_eq!(buffer.hash_sha256(), [0x4d9c3a70, 0x9ec7e883, 0x448a188a, 0xf6d6a7cc, 0x828f377a, 0x956bd926, 0x81d038dd, 0xe5bf71e3]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xfa0a71c7, 0x641c0cad, 0xa68577bf, 0xb1b5ffb5, 0x9bc14bcf, 0x4e3608fe, 0xa377cb94, 0x3da58c04]);
        assert_eq!(buffer.hash_poseidon_range(9, 17), 0x73bfacf5b42345a5818545085424791601e22bc59575656e5af4fd9a780909f);
        assert_eq!(buffer.hash_poseidon_range(85, 86), 0x6d110c10299262e80a97be439bd4cc5a92626b0aa45bed80dd514c215d7026a);
        assert_eq!(buffer.hash_poseidon_range(59, 71), 0x1c972f2a720eb20b5d45ddbb2b277e01b5572b4c546c8e36ec0b7bde949171a);
        assert_eq!(buffer.hash_poseidon_range(17, 58), 0x6164f27b5ee8c9a40908cb716edd7ccd2b660d71b1c13c08d512b13df91c0ab);
        assert_eq!(buffer.hash_poseidon_range(33, 36), 0x706238fd4c85b785775dd2909078b0e73f0d178d86eca26c2be9ba66e5907a2);

        let mut serialized_byte_array = array![0x0, 0x8a1b82d81c871b9a823f72dffa4a6127f02d91d2471371506bda2d56fe8c, 0x1e].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(19), 0x47d2);
        assert_eq!(buffer.read_u32_le(0), 0xd8821b8a);
        assert_eq!(buffer.read_u64_le(10), 0x2df027614afadf72);
        assert_eq!(buffer.read_partial_felt252(7, 1), 0x9a);
        assert_eq!(buffer.read_partial_felt252(1, 2), 0x1b82);
        assert_eq!(buffer.read_partial_felt252(6, 3), 0x1b9a82);
        assert_eq!(buffer.read_partial_felt252(13, 4), 0x4a6127f0);
        assert_eq!(buffer.read_partial_felt252(23, 5), 0x506bda2d56);
        assert_eq!(buffer.read_partial_felt252(14, 6), 0x6127f02d91d2);
        assert_eq!(buffer.read_partial_felt252(16, 7), 0xf02d91d2471371);
        assert_eq!(buffer.read_partial_felt252(12, 8), 0xfa4a6127f02d91d2);
        assert_eq!(buffer.read_partial_felt252(6, 9), 0x1b9a823f72dffa4a61);
        assert_eq!(buffer.read_partial_felt252(4, 10), 0x1c871b9a823f72dffa4a);
        assert_eq!(buffer.read_partial_felt252(14, 11), 0x6127f02d91d2471371506b);
        assert_eq!(buffer.read_partial_felt252(13, 12), 0x4a6127f02d91d2471371506b);
        assert_eq!(buffer.read_partial_felt252(0, 13), 0x8a1b82d81c871b9a823f72dffa);
        assert_eq!(buffer.read_partial_felt252(1, 14), 0x1b82d81c871b9a823f72dffa4a61);
        assert_eq!(buffer.read_partial_felt252(4, 15), 0x1c871b9a823f72dffa4a6127f02d91);
        assert_eq!(buffer.read_partial_felt252(8, 16), 0x823f72dffa4a6127f02d91d247137150);
        assert_eq!(buffer.read_partial_felt252(1, 17), 0x1b82d81c871b9a823f72dffa4a6127f02d);
        assert_eq!(buffer.read_partial_felt252(3, 18), 0xd81c871b9a823f72dffa4a6127f02d91d247);
        assert_eq!(buffer.read_partial_felt252(8, 19), 0x823f72dffa4a6127f02d91d2471371506bda2d);
        assert_eq!(buffer.read_partial_felt252(6, 20), 0x1b9a823f72dffa4a6127f02d91d2471371506bda);
        assert_eq!(buffer.read_partial_felt252(3, 21), 0xd81c871b9a823f72dffa4a6127f02d91d247137150);
        assert_eq!(buffer.read_partial_felt252(1, 22), 0x1b82d81c871b9a823f72dffa4a6127f02d91d2471371);
        assert_eq!(buffer.read_partial_felt252(1, 23), 0x1b82d81c871b9a823f72dffa4a6127f02d91d247137150);
        assert_eq!(buffer.read_partial_felt252(0, 24), 0x8a1b82d81c871b9a823f72dffa4a6127f02d91d247137150);
        assert_eq!(buffer.read_partial_felt252(1, 25), 0x1b82d81c871b9a823f72dffa4a6127f02d91d2471371506bda);
        assert_eq!(buffer.read_partial_felt252(1, 26), 0x1b82d81c871b9a823f72dffa4a6127f02d91d2471371506bda2d);
        assert_eq!(buffer.read_partial_felt252(0, 27), 0x8a1b82d81c871b9a823f72dffa4a6127f02d91d2471371506bda2d);
        assert_eq!(buffer.read_partial_felt252(0, 28), 0x8a1b82d81c871b9a823f72dffa4a6127f02d91d2471371506bda2d56);
        assert_eq!(buffer.read_partial_felt252(0, 29), 0x8a1b82d81c871b9a823f72dffa4a6127f02d91d2471371506bda2d56fe);
        assert_eq!(buffer.read_partial_felt252(0, 30), 0x8a1b82d81c871b9a823f72dffa4a6127f02d91d2471371506bda2d56fe8c);
        assert_eq!(buffer.hash_sha256(), [0xac75f1ae, 0x6da8e1e6, 0x8ee90f71, 0x75e92ba9, 0x3321ffc3, 0xe790acd6, 0x706bd829, 0x45c3ead5]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x40c340d5, 0x4d2eef3, 0x8acdb17e, 0x72c48e30, 0x4f12a70d, 0x1f0e28e8, 0x22f002ce, 0x4c27c722]);
        assert_eq!(buffer.hash_poseidon_range(20, 20), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(buffer.hash_poseidon_range(0, 19), 0x4f9e0b8f678ba4ea50019282b422adb2b2e1102663a69e08a1fc11a8162386);
        assert_eq!(buffer.hash_poseidon_range(17, 27), 0x5b459b6ab4695b890cafcd344352f1f7ff13adae80f7076c9708f69acb108cb);
        assert_eq!(buffer.hash_poseidon_range(21, 21), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(buffer.hash_poseidon_range(18, 28), 0x2bb3ced5a0fc7f39ab61e46d59a7c0db2b7cc38bd6ebeabbe07976586669b40);


        // Random access test cases testing random reads

        let mut serialized_byte_array = array![0x3, 0x5b87d895f62bc686ddcf4fab41df196ad98a5abc83db78026fa83c377676d2, 0xee148374f13ac79d32d1a77698dec9cdad3b74e0b57592b6f61cb516765314, 0x87abab734a174ab18b1c6bf3aedf63fc6c3f931e6454541c182587e44f8af0, 0x1d442eebbc7bc355b5aaa7765c67b5e1e60acdc434c26b65df5e, 0x1a].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u32_le(93), 0xeb2e441d);
        assert_eq!(buffer.read_partial_felt252(10, 16), 0x4fab41df196ad98a5abc83db78026fa8);
        assert_eq!(buffer.read_partial_felt252(15, 6), 0x6ad98a5abc83);
        assert_eq!(buffer.read_partial_felt252(66, 16), 0x4a174ab18b1c6bf3aedf63fc6c3f931e);
        assert_eq!(buffer.hash_poseidon_range(12, 118), 0x3127e39c24ba8442852c45e302bafb81b63a3e1e35b2413848ee2dc9004a03d);
        assert_eq!(buffer.read_u256(52), 0x7592b6f61cb51676531487abab734a174ab18b1c6bf3aedf63fc6c3f931e6454);
        assert_eq!(buffer.read_partial_felt252(42, 4), 0x7698dec9);
        assert_eq!(buffer.read_partial_felt252(41, 4), 0xa77698de);
        assert_eq!(buffer.read_partial_felt252(76, 17), 0x63fc6c3f931e6454541c182587e44f8af0);
        assert_eq!(buffer.read_partial_felt252(70, 12), 0x8b1c6bf3aedf63fc6c3f931e);

        let mut serialized_byte_array = array![0x3, 0x493c3961ab2b2669861b4ce4b3937a25d466bac13fe7a44b5857cb0ce2c126, 0xd8c1d93c0174bdd283140017be738464797131a310ce65e6f2347c7bc88743, 0x712be4d093cbf3324e0dc91d568deb0ff76f6da62b1e116278171d6bf756d7, 0x4f, 0x1].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(78, 14), 0xf76f6da62b1e116278171d6bf756);
        assert_eq!(buffer.read_partial_felt252(58, 31), 0x7bc88743712be4d093cbf3324e0dc91d568deb0ff76f6da62b1e116278171d);
        assert_eq!(buffer.read_partial_felt252(57, 32), 0x47bc88743712ae5d093cbf3324e0dc91d568deb0ff76f6da62b1e116278170e);
        assert_eq!(buffer.read_partial_felt252(35, 18), 0x174bdd283140017be738464797131a310ce);
        assert_eq!(buffer.read_partial_felt252(71, 3), 0xdc91d);
        assert_eq!(buffer.read_partial_felt252(39, 30), 0x83140017be738464797131a310ce65e6f2347c7bc88743712be4d093cbf3);
        assert_eq!(buffer.read_partial_felt252(11, 17), 0xe4b3937a25d466bac13fe7a44b5857cb0c);
        assert_eq!(buffer.read_partial_felt252(61, 22), 0x43712be4d093cbf3324e0dc91d568deb0ff76f6da62b);
        assert_eq!(buffer.read_partial_felt252(56, 12), 0x347c7bc88743712be4d093cb);
        assert_eq!(buffer.read_partial_felt252(32, 29), 0xc1d93c0174bdd283140017be738464797131a310ce65e6f2347c7bc887);

        let mut serialized_byte_array = array![0x0, 0xfe81849be83b5376, 0x8].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(0, 6), 0xfe81849be83b);
        assert_eq!(buffer.read_partial_felt252(1, 6), 0x81849be83b53);
        assert_eq!(buffer.read_partial_felt252(3, 2), 0x9be8);

        let mut serialized_byte_array = array![0x1, 0xebb5fd319521ec2b01edb575c870295f585892f5406e3abc165eab834b9043, 0xd7d611c0e65d351505, 0x9].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(4, 31), 0x9521ec2b01edb575c870295f585892f5406e3abc165eab834b9043d7d611c0);
        assert_eq!(buffer.read_u16_le(3), 0x9531);
        assert_eq!(buffer.read_partial_felt252(17, 2), 0x5892);
        assert_eq!(buffer.read_partial_felt252(7, 2), 0x2b01);
        assert_eq!(buffer.read_partial_felt252(10, 14), 0xb575c870295f585892f5406e3abc);
        assert_eq!(buffer.read_partial_felt252(5, 30), 0x21ec2b01edb575c870295f585892f5406e3abc165eab834b9043d7d611c0);
        assert_eq!(buffer.read_partial_felt252(13, 17), 0x70295f585892f5406e3abc165eab834b90);
        assert_eq!(buffer.read_u64_le(15), 0x3a6e40f59258585f);
        assert_eq!(buffer.read_bytes31(2), 0xfd319521ec2b01edb575c870295f585892f5406e3abc165eab834b9043d7d6);
        assert_eq!(buffer.read_u16_le(35), 0x5de6);

        let mut serialized_byte_array = array![0x3, 0x97018e01a968c06e09e81ce53289379b57450f7e4d36dcee88cafa30886731, 0x018f7f8aa445d4c602f08a7e857d36efb1c88ad39f336d1a6ab80f360e6b48, 0xd83481b97f0fb03a5e0c4f0902245dd8bc97abee2d714b2865f4c02a43b1d6, 0xe6b4f1b42f2c9931c7d565b01f0fe74796dbc7f56b0d43, 0x17].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(69, 24), 0x3a5e0c4f0902245dd8bc97abee2d714b2865f4c02a43b1d6);
        assert_eq!(buffer.read_partial_felt252(67, 24), 0xfb03a5e0c4f0902245dd8bc97abee2d714b2865f4c02a43);
        assert_eq!(buffer.read_partial_felt252(52, 2), 0x336d);
        assert_eq!(buffer.read_partial_felt252(28, 23), 0x886731018f7f8aa445d4c602f08a7e857d36efb1c88ad3);
        assert_eq!(buffer.read_partial_felt252(38, 27), 0xc602f08a7e857d36efb1c88ad39f336d1a6ab80f360e6b48d83481);
        assert_eq!(buffer.read_partial_felt252(37, 29), 0xd4c602f08a7e857d36efb1c88ad39f336d1a6ab80f360e6b48d83481b9);
        assert_eq!(buffer.read_partial_felt252(23, 29), 0xee88cafa30886731018f7f8aa445d4c602f08a7e857d36efb1c88ad39f);
        assert_eq!(buffer.read_partial_felt252(78, 21), 0xbc97abee2d714b2865f4c02a43b1d6e6b4f1b42f2c);
        assert_eq!(buffer.read_partial_felt252(94, 14), 0xb4f1b42f2c9931c7d565b01f0fe7);
        assert_eq!(buffer.read_partial_felt252(85, 16), 0x2865f4c02a43b1d6e6b4f1b42f2c9931);

        let mut serialized_byte_array = array![0x2, 0x0100b298eccabded5f70e1c3eac0bf81d48e664ca87e9099a2f1e1b9e307c6, 0x8ee358bbfbf11da53f1db95af60c84a0f3187eb61080ffc0c81905e5844dae, 0x3754f72b363b0b78e75e, 0xa].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(13, 30), 0xc0bf81d48e664ca87e9099a2f1e1b9e307c68ee358bbfbf11da53f1db95a);
        assert_eq!(buffer.read_partial_felt252(14, 27), 0xbf81d48e664ca87e9099a2f1e1b9e307c68ee358bbfbf11da53f1d);
        assert_eq!(buffer.read_partial_felt252(41, 18), 0xb95af60c84a0f3187eb61080ffc0c81905e5);
        assert_eq!(buffer.read_partial_felt252(54, 16), 0xc0c81905e5844dae3754f72b363b0b78);
        assert_eq!(buffer.read_partial_felt252(35, 29), 0xfbf11da53f1db95af60c84a0f3187eb61080ffc0c81905e5844dae3754);
        assert_eq!(buffer.read_partial_felt252(39, 23), 0x3f1db95af60c84a0f3187eb61080ffc0c81905e5844dae);
        assert_eq!(buffer.read_partial_felt252(0, 4), 0x100b298);
        assert_eq!(buffer.read_partial_felt252(7, 21), 0xed5f70e1c3eac0bf81d48e664ca87e9099a2f1e1b9);
        assert_eq!(buffer.read_bytes31(2), 0xb298eccabded5f70e1c3eac0bf81d48e664ca87e9099a2f1e1b9e307c68ee3);
        assert_eq!(buffer.read_partial_felt252(23, 15), 0x99a2f1e1b9e307c68ee358bbfbf11d);

        let mut serialized_byte_array = array![0x4, 0x067c4ee1f0caf9c45719f5c894dd82e9658db3a4e40bdaa2daf878f605fabb, 0xa1331df10774f2789e52d760ad28199c1bc17701399f655d97c1e06f4a1f39, 0x3609e6ac04d9ed8f3c9038174c597e8667be65c36583a34f1d3e35920a4f30, 0x96494cc4a0c6e5c9b3d0362010174906866275d22c5df30d391e5ce152e776, 0x053b58, 0x3].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(63, 17), 0x9e6ac04d9ed8f3c9038174c597e8667be);
        assert_eq!(buffer.read_partial_felt252(85, 4), 0x4f1d3e35);
        assert_eq!(buffer.read_partial_felt252(74, 12), 0x4c597e8667be65c36583a34f);
        assert_eq!(buffer.read_partial_felt252(11, 14), 0xc894dd82e9658db3a4e40bdaa2da);
        assert_eq!(buffer.read_partial_felt252(71, 3), 0x903817);
        assert_eq!(buffer.read_partial_felt252(35, 28), 0x774f2789e52d760ad28199c1bc17701399f655d97c1e06f4a1f3936);
        assert_eq!(buffer.hash_poseidon_range(18, 116), 0x24d0b16af1704c8db26f57d5d309439972fcc29c174d5a1733885932d9b7d6);
        assert_eq!(buffer.read_partial_felt252(108, 7), 0x6866275d22c5d);
        assert_eq!(buffer.read_partial_felt252(55, 2), 0x97c1);
        assert_eq!(buffer.read_partial_felt252(3, 18), 0xe1f0caf9c45719f5c894dd82e9658db3a4e4);

        let mut serialized_byte_array = array![0x1, 0x516f570bd4b1dcc57ca1406a9b7545cd2d6afb787449005b024c7ae90270be, 0x8c184ed7d6731cf0b1da81fc6f7884f4a2dfeb27aba757, 0x17].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(16, 31), 0x2d6afb787449005b024c7ae90270be8c184ed7d6731cf0b1da81fc6f7884f4);
        assert_eq!(buffer.read_partial_felt252(49, 2), 0xeb27);
        assert_eq!(buffer.read_partial_felt252(24, 8), 0x24c7ae90270be8c);
        assert_eq!(buffer.read_partial_felt252(24, 16), 0x24c7ae90270be8c184ed7d6731cf0b1);
        assert_eq!(buffer.read_partial_felt252(18, 22), 0xfb787449005b024c7ae90270be8c184ed7d6731cf0b1);
        assert_eq!(buffer.read_partial_felt252(34, 8), 0xd7d6731cf0b1da81);
        assert_eq!(buffer.read_partial_felt252(4, 27), 0xd4b1dcc57ca1406a9b7545cd2d6afb787449005b024c7ae90270be);
        assert_eq!(buffer.read_partial_felt252(0, 25), 0x516f570bd4b1dcc57ca1406a9b7545cd2d6afb787449005b02);
        assert_eq!(buffer.read_partial_felt252(18, 32), 0x3787449005b003d7ae90270be8c184ed7d6731cf0b1da81fc6f7884f4a2dfcc);
        assert_eq!(buffer.read_partial_felt252(5, 1), 0xb1);

        let mut serialized_byte_array = array![0x0, 0x6001c947f5a085461295922bc4ffd829a6c6ea3e6fd7257333, 0x19].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(5, 17), 0xa085461295922bc4ffd829a6c6ea3e6fd7);
        assert_eq!(buffer.read_u32_le(8), 0x2b929512);
        assert_eq!(buffer.read_u64_le(0), 0x4685a0f547c90160);
        assert_eq!(buffer.read_partial_felt252(2, 22), 0xc947f5a085461295922bc4ffd829a6c6ea3e6fd72573);
        assert_eq!(buffer.read_partial_felt252(0, 24), 0x6001c947f5a085461295922bc4ffd829a6c6ea3e6fd72573);
        assert_eq!(buffer.read_partial_felt252(1, 19), 0x1c947f5a085461295922bc4ffd829a6c6ea3e);
        assert_eq!(buffer.read_partial_felt252(14, 1), 0xd8);
        assert_eq!(buffer.read_partial_felt252(1, 6), 0x1c947f5a085);
        assert_eq!(buffer.read_partial_felt252(5, 7), 0xa085461295922b);

        let mut serialized_byte_array = array![0x3, 0x65e1be12287e05685c6eeda74ddc47e17678989b5cd4f752b6d1200ed2a226, 0x1d7b6f18d99ee79ee3d2bf28858e8bdf6c6b32423c803b5ea54fddfc5a2712, 0x990f2076a41199027e50229c658e9fd8243eb8641b062951b917a73c4ad5d1, 0xd8, 0x1].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_bytes31(6), 0x05685c6eeda74ddc47e17678989b5cd4f752b6d1200ed2a2261d7b6f18d99e);
        assert_eq!(buffer.read_felt252(19), 0x35cd4f752b6cfdd0ed2a2261d7b6f18d99ee79ee3d2bf28858e8bdf6c6b322f);
        assert_eq!(buffer.read_partial_felt252(60, 32), 0x712990f2076a3cd99027e50229c658e9fd8243eb8641b062951b917a73c4ad1);
        assert_eq!(buffer.read_partial_felt252(39, 22), 0xe3d2bf28858e8bdf6c6b32423c803b5ea54fddfc5a27);
        assert_eq!(buffer.read_partial_felt252(79, 10), 0x3eb8641b062951b917a7);
        assert_eq!(buffer.read_partial_felt252(53, 3), 0x3b5ea5);
        assert_eq!(buffer.read_partial_felt252(73, 14), 0x9c658e9fd8243eb8641b062951b9);
        assert_eq!(buffer.read_partial_felt252(19, 17), 0x9b5cd4f752b6d1200ed2a2261d7b6f18d9);
        assert_eq!(buffer.read_partial_felt252(26, 14), 0x200ed2a2261d7b6f18d99ee79ee3);
        assert_eq!(buffer.read_partial_felt252(30, 21), 0x261d7b6f18d99ee79ee3d2bf28858e8bdf6c6b3242);
    }
    
    // Random access out of bounds reads

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u16_le() {
        let mut serialized_byte_array = array![0x0, 0x33f4ef37a29b81344226, 0xa].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u16_le(9);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u32_le() {
        let mut serialized_byte_array = array![0x0, 0x5bb2cac083, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u32_le(5);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u64_le() {
        let mut serialized_byte_array = array![0x0, 0x20075b5c4550642ce3386e5bcb786a528b85d0, 0x13].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u64_le(12);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u256() {
        let mut serialized_byte_array = array![0x1, 0xe18ea402f7aa50305c68d440d88021ad216c6dfdfaab1b9b92381802396da3, 0x92, 0x1].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u256(18);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_bytes31() {
        let mut serialized_byte_array = array![0x1, 0xb2a7c6ef45bfde3f3caf560d2351f2e7892f23b54313fc640358e0bf9199cd, 0xd04df8e8c73ec7fa90923d6a88f2371d984c3910ccdf72168683447e, 0x1c].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_bytes31(32);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252() {
        let mut serialized_byte_array = array![0x1, 0xb29faeb097cde2c6e76c67d748ab52574ee2707e858daf6f574f43be462538, 0x16e7e87f314077b093f2ef, 0xb].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_felt252(42);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_1b() {
        let mut serialized_byte_array = array![0x0, 0x3220fb1beb35d244473c9f7b54c94d, 0xf].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(15, 1);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_2b() {
        let mut serialized_byte_array = array![0x0, 0x7d479f6df6259c58b58428a610a3, 0xe].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(14, 2);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_3b() {
        let mut serialized_byte_array = array![0x0, 0x793af4144cf205fa6b8b1cb839b60df228, 0x11].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(15, 3);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_4b() {
        let mut serialized_byte_array = array![0x1, 0xdf8d39e83d89cef378df1551c5ec7d89d1c22e25bf1c62e76edab856dab30d, 0x13, 0x1].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(29, 4);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_5b() {
        let mut serialized_byte_array = array![0x0, 0xc8f7f0000ce9a2ec52e222400e6c9262697a18086c5402daa89272, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(24, 5);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_6b() {
        let mut serialized_byte_array = array![0x0, 0xc17f27bcf75515, 0x7].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(3, 6);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_7b() {
        let mut serialized_byte_array = array![0x0, 0x69df53c59eed540cac6215a6ca, 0xd].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(7, 7);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_8b() {
        let mut serialized_byte_array = array![0x1, 0x248f08f845c245f6366987830d949f2d5f93741c30a87fcbfbb2148e5a2626, 0x59be10, 0x3].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(28, 8);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_9b() {
        let mut serialized_byte_array = array![0x1, 0x59b84d924bd0342b38a3a97570da45dcbffc0f3876559b926cca3df77d5fa8, 0xdde8c7ce8ff5, 0x6].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(30, 9);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_10b() {
        let mut serialized_byte_array = array![0x1, 0x6d95e59c737a86026b2970bebdfdc7ba6e58fa1f6b356d01f3844b31095fc3, 0x3ecef8c37164f94a25, 0x9].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(38, 10);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_11b() {
        let mut serialized_byte_array = array![0x0, 0x27a6c1ca8aba6a45fa62b4862be082e27c26, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(8, 11);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_12b() {
        let mut serialized_byte_array = array![0x0, 0x5753f6ec8df677a44a0395044f, 0xd].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(12, 12);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_13b() {
        let mut serialized_byte_array = array![0x0, 0x00a20c1d1d0b657281b786223705aec2637549ca87, 0x15].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(12, 13);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_14b() {
        let mut serialized_byte_array = array![0x0, 0x07636c036697ab037b50393f94efbf54ca9d4b8811bd9e, 0x17].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(22, 14);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_15b() {
        let mut serialized_byte_array = array![0x0, 0x869a56cca854f8a7a609f41a7dbfdd2d62, 0x11].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(5, 15);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_16b() {
        let mut serialized_byte_array = array![0x1, 0x94572b7108c13178435ff9e6bcc4f7da26172b51fc9c01d2f0aad827145198, 0x188e03064b, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(28, 16);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_17b() {
        let mut serialized_byte_array = array![0x1, 0x43d3d62cf4a79d79cf5e49e46f14d7f8c3ed0f34dc1b0b1a9e0caee3fc1358, 0xd96d, 0x2].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(21, 17);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_18b() {
        let mut serialized_byte_array = array![0x0, 0x9bc4fa33e5069f6fc727a9733b4d355eccec9ca52ab1ccc448677d5fba6a, 0x1e].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(17, 18);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_19b() {
        let mut serialized_byte_array = array![0x1, 0x7bb62fa16bf3129b0be5d52b058c0a781911a5bb12a83a08a107498b289e3b, 0xb0, 0x1].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(25, 19);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_20b() {
        let mut serialized_byte_array = array![0x0, 0x71a758f00789b81f833c1ad04e4b2a028ae794ef, 0x14].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(6, 20);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_21b() {
        let mut serialized_byte_array = array![0x1, 0xdb5bb035874d89568c32e02151f2210056bf6dcae21e2d5918cfeaf070bdf9, 0x89e12ec6482034a0d91378, 0xb].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(27, 21);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_22b() {
        let mut serialized_byte_array = array![0x0, 0xe83bc576bda0669aa195ec1eae4b8509138b845cfaaab1283b4cd8, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(15, 22);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_23b() {
        let mut serialized_byte_array = array![0x1, 0x626db5558dbd2723a92f23c70718b7c9aeb6c0a839a94c1a384111edbc922a, 0x1a776ee437cb0df2145098f9919e65765acd1a03ff7e, 0x16].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(40, 23);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_24b() {
        let mut serialized_byte_array = array![0x0, 0x9f5faef48a53fa015f4ae0c59f5a0bbec5f80b30ffe0a28f, 0x18].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(10, 24);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_25b() {
        let mut serialized_byte_array = array![0x1, 0x01eb3b2085d06f787855699ff10390be5dafec0d834ef15e8d45b2e7d8b26a, 0x7a18b3697ee14450519465a9e1fcf64070b421, 0x13].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(38, 25);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_26b() {
        let mut serialized_byte_array = array![0x0, 0x199e570f4a0a6721243d490b1c92efd5f3dcadb700f9ee94d14b48c2f2, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(12, 26);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_27b() {
        let mut serialized_byte_array = array![0x1, 0xa1d2e411f4ff37febe51adb026b54013febd7126975df2da632f212584265b, 0xdd0b7c23f53c20cdd13168adc42efe38955349f4cb, 0x15].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(39, 27);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_28b() {
        let mut serialized_byte_array = array![0x1, 0x2c320205d46c222cfd466a9fd70c6e58bca720750acc13d71addb701efd14b, 0xb115df811a9d31a109f81eebb1b04e86967f, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(27, 28);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_29b() {
        let mut serialized_byte_array = array![0x1, 0x9de1e5ce96d5f5f0523a38e15fda48992f7846c2a8995e036b5464b70ac5df, 0x180bb547, 0x4].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(24, 29);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_30b() {
        let mut serialized_byte_array = array![0x1, 0x56823143ae3bc833b24b7526406bd96d3da10f7260486dca47c2deef3d9398, 0xb3b486c5d9338ef6161ce3a4a663ba, 0xf].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(32, 30);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_31b() {
        let mut serialized_byte_array = array![0x1, 0x025bef3cd5f8d2a4373d673d0278c8de4c032eb93ca6874f89d6a51ad4694d, 0xe92b7c54c0a9be, 0x7].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(32, 31);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_32b() {
        let mut serialized_byte_array = array![0x1, 0x622467b9b4128b63491235b0c6aa054a7a3c1647ff9df4d3731213cc9c4313, 0xcdc575f8d2664c3f0f750e8d3fe91389a7b97ac4e655ace570f165, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(47, 32);
    }

}
