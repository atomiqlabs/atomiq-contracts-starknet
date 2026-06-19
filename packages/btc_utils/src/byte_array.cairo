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

        let mut serialized_byte_array = array![0x2, 0x90239d8b630591030c86e7ab106a4dc4b4e3d18a36a031e26bbc8ecbe6e685, 0x023d315a6b0067287cc438bdf3f5fea790292a2dc7b5475d59f56d137a8ac0, 0xf83da1a8f744cd5abff9be14fb61c137673073, 0x13].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(56), 0x6df5);
        assert_eq!(buffer.read_u32_le(21), 0x6be231a0);
        assert_eq!(buffer.read_u64_le(0), 0x39105638b9d2390);
        assert_eq!(buffer.read_u256(5), 0x0591030c86e7ab106a4dc4b4e3d18a36a031e26bbc8ecbe6e685023d315a6b00);
        assert_eq!(buffer.read_bytes31(28), 0xe6e685023d315a6b0067287cc438bdf3f5fea790292a2dc7b5475d59f56d13);
        assert_eq!(buffer.read_felt252(16), 0x4e3d18a36a0306c6bbc8ecbe6e685023d315a6b0067287cc438bdf3f5fea77a);
        assert_eq!(buffer.read_partial_felt252(72, 1), 0xbe);
        assert_eq!(buffer.read_partial_felt252(39, 2), 0x7cc4);
        assert_eq!(buffer.read_partial_felt252(9, 3), 0x86e7ab);
        assert_eq!(buffer.read_partial_felt252(15, 4), 0xc4b4e3d1);
        assert_eq!(buffer.read_partial_felt252(16, 5), 0xb4e3d18a36);
        assert_eq!(buffer.read_partial_felt252(51, 6), 0xc7b5475d59f5);
        assert_eq!(buffer.read_partial_felt252(59, 7), 0x7a8ac0f83da1a8);
        assert_eq!(buffer.read_partial_felt252(66, 8), 0xf744cd5abff9be14);
        assert_eq!(buffer.read_partial_felt252(2, 9), 0x9d8b630591030c86e7);
        assert_eq!(buffer.read_partial_felt252(13, 10), 0x6a4dc4b4e3d18a36a031);
        assert_eq!(buffer.read_partial_felt252(23, 11), 0xe26bbc8ecbe6e685023d31);
        assert_eq!(buffer.read_partial_felt252(30, 12), 0x85023d315a6b0067287cc438);
        assert_eq!(buffer.read_partial_felt252(37, 13), 0x67287cc438bdf3f5fea790292a);
        assert_eq!(buffer.read_partial_felt252(45, 14), 0xfea790292a2dc7b5475d59f56d13);
        assert_eq!(buffer.read_partial_felt252(29, 15), 0xe685023d315a6b0067287cc438bdf3);
        assert_eq!(buffer.read_partial_felt252(20, 16), 0x36a031e26bbc8ecbe6e685023d315a6b);
        assert_eq!(buffer.read_partial_felt252(49, 17), 0x2a2dc7b5475d59f56d137a8ac0f83da1a8);
        assert_eq!(buffer.read_partial_felt252(58, 18), 0x137a8ac0f83da1a8f744cd5abff9be14fb61);
        assert_eq!(buffer.read_partial_felt252(2, 19), 0x9d8b630591030c86e7ab106a4dc4b4e3d18a36);
        assert_eq!(buffer.read_partial_felt252(56, 20), 0xf56d137a8ac0f83da1a8f744cd5abff9be14fb61);
        assert_eq!(buffer.read_partial_felt252(41, 21), 0x38bdf3f5fea790292a2dc7b5475d59f56d137a8ac0);
        assert_eq!(buffer.read_partial_felt252(15, 22), 0xc4b4e3d18a36a031e26bbc8ecbe6e685023d315a6b00);
        assert_eq!(buffer.read_partial_felt252(6, 23), 0x91030c86e7ab106a4dc4b4e3d18a36a031e26bbc8ecbe6);
        assert_eq!(buffer.read_partial_felt252(46, 24), 0xa790292a2dc7b5475d59f56d137a8ac0f83da1a8f744cd5a);
        assert_eq!(buffer.read_partial_felt252(24, 25), 0x6bbc8ecbe6e685023d315a6b0067287cc438bdf3f5fea79029);
        assert_eq!(buffer.read_partial_felt252(47, 26), 0x90292a2dc7b5475d59f56d137a8ac0f83da1a8f744cd5abff9be);
        assert_eq!(buffer.read_partial_felt252(16, 27), 0xb4e3d18a36a031e26bbc8ecbe6e685023d315a6b0067287cc438bd);
        assert_eq!(buffer.read_partial_felt252(7, 28), 0x30c86e7ab106a4dc4b4e3d18a36a031e26bbc8ecbe6e685023d315a);
        assert_eq!(buffer.read_partial_felt252(35, 29), 0x6b0067287cc438bdf3f5fea790292a2dc7b5475d59f56d137a8ac0f83d);
        assert_eq!(buffer.read_partial_felt252(28, 30), 0xe6e685023d315a6b0067287cc438bdf3f5fea790292a2dc7b5475d59f56d);
        assert_eq!(buffer.read_partial_felt252(39, 31), 0x7cc438bdf3f5fea790292a2dc7b5475d59f56d137a8ac0f83da1a8f744cd5a);
        assert_eq!(buffer.read_partial_felt252(42, 32), 0x5f3f5fea79027a32dc7b5475d59f56d137a8ac0f83da1a8f744cd5abff9bdfd);
        assert_eq!(buffer.hash_sha256(), [0xf18a184a, 0x3502d4a0, 0x4b79dee7, 0x3bc88088, 0xa039ee13, 0x41f25121, 0xb233e4d3, 0x1fff37eb]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x7b403d51, 0xa9c1cbfa, 0x832a33e9, 0xbbfa5db5, 0x1b510b5c, 0x63a4fcf8, 0xb7c617c6, 0xf260c47]);
        assert_eq!(buffer.hash_poseidon_range(54, 73), 0x7b61f410ea95ed74f1982d61f1f4995022165fffc8ddb74ac569bb2909a1858);
        assert_eq!(buffer.hash_poseidon_range(61, 61), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(buffer.hash_poseidon_range(70, 79), 0x3ef0995919264cd22b6bd6b5b77595cb5943c8dc2c5cb97888e79b159a89a32);
        assert_eq!(buffer.hash_poseidon_range(46, 80), 0x19b9351dbc9b183bd985866968ac4861d53d71e8d949975b7282060f8164ba6);
        assert_eq!(buffer.hash_poseidon_range(51, 71), 0x67a6bf4799a7f4c50e069a8cd08926955249d18b8223c8fa08f5a55804f86f2);

        let mut serialized_byte_array = array![0x2, 0xab0b061732f63ab2eeb6bee9239ea45002e1751a2ae29b7fdf3019fac96198, 0x6f2dec8b70a669053c2537689c48259db1d9b0551562b0c038296b46a51dbb, 0x0bf7286f58f97cafb7c5ee632e371b9ed71f731e92cf, 0x16].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(38), 0x3c05);
        assert_eq!(buffer.read_u32_le(76), 0x1fd79e1b);
        assert_eq!(buffer.read_u64_le(11), 0x75e10250a49e23e9);
        assert_eq!(buffer.read_u256(45), 0x259db1d9b0551562b0c038296b46a51dbb0bf7286f58f97cafb7c5ee632e371b);
        assert_eq!(buffer.read_bytes31(8), 0xeeb6bee9239ea45002e1751a2ae29b7fdf3019fac961986f2dec8b70a66905);
        assert_eq!(buffer.read_felt252(11), 0x1239ea45002df881a2ae29b7fdf3019fac961986f2dec8b70a669053c25374b);
        assert_eq!(buffer.read_partial_felt252(36, 1), 0xa6);
        assert_eq!(buffer.read_partial_felt252(55, 2), 0x3829);
        assert_eq!(buffer.read_partial_felt252(68, 3), 0x7cafb7);
        assert_eq!(buffer.read_partial_felt252(50, 4), 0x551562b0);
        assert_eq!(buffer.read_partial_felt252(41, 5), 0x37689c4825);
        assert_eq!(buffer.read_partial_felt252(66, 6), 0x58f97cafb7c5);
        assert_eq!(buffer.read_partial_felt252(55, 7), 0x38296b46a51dbb);
        assert_eq!(buffer.read_partial_felt252(5, 8), 0xf63ab2eeb6bee923);
        assert_eq!(buffer.read_partial_felt252(51, 9), 0x1562b0c038296b46a5);
        assert_eq!(buffer.read_partial_felt252(38, 10), 0x53c2537689c48259db1);
        assert_eq!(buffer.read_partial_felt252(4, 11), 0x32f63ab2eeb6bee9239ea4);
        assert_eq!(buffer.read_partial_felt252(19, 12), 0x1a2ae29b7fdf3019fac96198);
        assert_eq!(buffer.read_partial_felt252(19, 13), 0x1a2ae29b7fdf3019fac961986f);
        assert_eq!(buffer.read_partial_felt252(31, 14), 0x6f2dec8b70a669053c2537689c48);
        assert_eq!(buffer.read_partial_felt252(58, 15), 0x46a51dbb0bf7286f58f97cafb7c5ee);
        assert_eq!(buffer.read_partial_felt252(7, 16), 0xb2eeb6bee9239ea45002e1751a2ae29b);
        assert_eq!(buffer.read_partial_felt252(3, 17), 0x1732f63ab2eeb6bee9239ea45002e1751a);
        assert_eq!(buffer.read_partial_felt252(50, 18), 0x551562b0c038296b46a51dbb0bf7286f58f9);
        assert_eq!(buffer.read_partial_felt252(28, 19), 0xc961986f2dec8b70a669053c2537689c48259d);
        assert_eq!(buffer.read_partial_felt252(20, 20), 0x2ae29b7fdf3019fac961986f2dec8b70a669053c);
        assert_eq!(buffer.read_partial_felt252(2, 21), 0x61732f63ab2eeb6bee9239ea45002e1751a2ae29b);
        assert_eq!(buffer.read_partial_felt252(32, 22), 0x2dec8b70a669053c2537689c48259db1d9b0551562b0);
        assert_eq!(buffer.read_partial_felt252(11, 23), 0xe9239ea45002e1751a2ae29b7fdf3019fac961986f2dec);
        assert_eq!(buffer.read_partial_felt252(21, 24), 0xe29b7fdf3019fac961986f2dec8b70a669053c2537689c48);
        assert_eq!(buffer.read_partial_felt252(20, 25), 0x2ae29b7fdf3019fac961986f2dec8b70a669053c2537689c48);
        assert_eq!(buffer.read_partial_felt252(3, 26), 0x1732f63ab2eeb6bee9239ea45002e1751a2ae29b7fdf3019fac9);
        assert_eq!(buffer.read_partial_felt252(27, 27), 0xfac961986f2dec8b70a669053c2537689c48259db1d9b0551562b0);
        assert_eq!(buffer.read_partial_felt252(8, 28), 0xeeb6bee9239ea45002e1751a2ae29b7fdf3019fac961986f2dec8b70);
        assert_eq!(buffer.read_partial_felt252(22, 29), 0x9b7fdf3019fac961986f2dec8b70a669053c2537689c48259db1d9b055);
        assert_eq!(buffer.read_partial_felt252(22, 30), 0x9b7fdf3019fac961986f2dec8b70a669053c2537689c48259db1d9b05515);
        assert_eq!(buffer.read_partial_felt252(3, 31), 0x1732f63ab2eeb6bee9239ea45002e1751a2ae29b7fdf3019fac961986f2dec);
        assert_eq!(buffer.read_partial_felt252(15, 32), 0x2e1751a2ae1f17fdf3019fac961986f2dec8b70a669053c2537689c482593);
        assert_eq!(buffer.hash_sha256(), [0xcd10c0ba, 0x37494086, 0x576e97dc, 0xd84173bb, 0xd1d976ba, 0x1a3b1cc2, 0x86f9773b, 0xf979caaf]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x3328b318, 0x1a5959a2, 0xb166c715, 0x6baa3cc, 0xc8b0ee1a, 0xb03f6ab8, 0x5f82f807, 0xe92d47a]);
        assert_eq!(buffer.hash_poseidon_range(58, 83), 0x6e9ce1136d9954a83a54fa803cea469075d416fcd14bd4c75ae9a566e7ba83f);
        assert_eq!(buffer.hash_poseidon_range(34, 54), 0x347e863fb4d955f4bb3623c92c3f719b20bf1da70f41c01a05a6dcda644f0c2);
        assert_eq!(buffer.hash_poseidon_range(54, 80), 0x71200a2e2f5fe042e3fa27f20bc33f72020c7f49943f5c94e0d7987ccc13b27);
        assert_eq!(buffer.hash_poseidon_range(52, 80), 0x3e61aa8cbc9b96c5c3ea473588acd4360b6c39e721eb19aa9e087b82659ab04);
        assert_eq!(buffer.hash_poseidon_range(82, 83), 0x7bc2504f7851185d36143396d0f8330a7f79ac615f445a5365b0bc5f932fc68);

        let mut serialized_byte_array = array![0x0, 0xc61c5cb79c, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(1), 0x5c1c);
        assert_eq!(buffer.read_u32_le(0), 0xb75c1cc6);
        assert_eq!(buffer.read_partial_felt252(0, 1), 0xc6);
        assert_eq!(buffer.read_partial_felt252(2, 2), 0x5cb7);
        assert_eq!(buffer.read_partial_felt252(0, 3), 0xc61c5c);
        assert_eq!(buffer.read_partial_felt252(0, 4), 0xc61c5cb7);
        assert_eq!(buffer.read_partial_felt252(0, 5), 0xc61c5cb79c);
        assert_eq!(buffer.hash_sha256(), [0xdeb71a0d, 0x1e0e9c81, 0x958c1705, 0x3c0a1e57, 0xfbe9af6f, 0x399daca8, 0x9fd7849d, 0x2d5a564e]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x9b9244b0, 0x56d57705, 0x5d172ab9, 0x2b982491, 0x5f70ff6d, 0x4d04b4f6, 0x825b1bd3, 0xc3ab0bb0]);
        assert_eq!(buffer.hash_poseidon_range(2, 2), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(buffer.hash_poseidon_range(4, 4), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(buffer.hash_poseidon_range(4, 4), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(buffer.hash_poseidon_range(2, 4), 0xdf32b4199024331806740fcd41f364b6d89a9c782e46c898622d65fd1d85a9);
        assert_eq!(buffer.hash_poseidon_range(2, 4), 0xdf32b4199024331806740fcd41f364b6d89a9c782e46c898622d65fd1d85a9);

        let mut serialized_byte_array = array![0x1, 0xddf9790b8c3eeed56a5740c3ba840044f9e160ca63630deceeac9929fb6dd8, 0xb04773499fb6960f09363cb03733, 0xe].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(38), 0x90f);
        assert_eq!(buffer.read_u32_le(23), 0x99aceeec);
        assert_eq!(buffer.read_u64_le(22), 0x6dfb2999aceeec0d);
        assert_eq!(buffer.read_u256(4), 0x8c3eeed56a5740c3ba840044f9e160ca63630deceeac9929fb6dd8b04773499f);
        assert_eq!(buffer.read_bytes31(13), 0x840044f9e160ca63630deceeac9929fb6dd8b04773499fb6960f09363cb037);
        assert_eq!(buffer.read_felt252(5), 0x6eed56a5740c343840044f9e160ca63630deceeac9929fb6dd8b04773499faf);
        assert_eq!(buffer.read_partial_felt252(36, 1), 0xb6);
        assert_eq!(buffer.read_partial_felt252(42, 2), 0xb037);
        assert_eq!(buffer.read_partial_felt252(26, 3), 0x9929fb);
        assert_eq!(buffer.read_partial_felt252(10, 4), 0x40c3ba84);
        assert_eq!(buffer.read_partial_felt252(10, 5), 0x40c3ba8400);
        assert_eq!(buffer.read_partial_felt252(16, 6), 0xf9e160ca6363);
        assert_eq!(buffer.read_partial_felt252(6, 7), 0xeed56a5740c3ba);
        assert_eq!(buffer.read_partial_felt252(12, 8), 0xba840044f9e160ca);
        assert_eq!(buffer.read_partial_felt252(18, 9), 0x60ca63630deceeac99);
        assert_eq!(buffer.read_partial_felt252(9, 10), 0x5740c3ba840044f9e160);
        assert_eq!(buffer.read_partial_felt252(23, 11), 0xeceeac9929fb6dd8b04773);
        assert_eq!(buffer.read_partial_felt252(31, 12), 0xb04773499fb6960f09363cb0);
        assert_eq!(buffer.read_partial_felt252(2, 13), 0x790b8c3eeed56a5740c3ba8400);
        assert_eq!(buffer.read_partial_felt252(29, 14), 0x6dd8b04773499fb6960f09363cb0);
        assert_eq!(buffer.read_partial_felt252(24, 15), 0xeeac9929fb6dd8b04773499fb6960f);
        assert_eq!(buffer.read_partial_felt252(27, 16), 0x29fb6dd8b04773499fb6960f09363cb0);
        assert_eq!(buffer.read_partial_felt252(13, 17), 0x840044f9e160ca63630deceeac9929fb6d);
        assert_eq!(buffer.read_partial_felt252(7, 18), 0xd56a5740c3ba840044f9e160ca63630decee);
        assert_eq!(buffer.read_partial_felt252(16, 19), 0xf9e160ca63630deceeac9929fb6dd8b0477349);
        assert_eq!(buffer.read_partial_felt252(14, 20), 0x44f9e160ca63630deceeac9929fb6dd8b04773);
        assert_eq!(buffer.read_partial_felt252(17, 21), 0xe160ca63630deceeac9929fb6dd8b04773499fb696);
        assert_eq!(buffer.read_partial_felt252(4, 22), 0x8c3eeed56a5740c3ba840044f9e160ca63630deceeac);
        assert_eq!(buffer.read_partial_felt252(17, 23), 0xe160ca63630deceeac9929fb6dd8b04773499fb6960f09);
        assert_eq!(buffer.read_partial_felt252(20, 24), 0x63630deceeac9929fb6dd8b04773499fb6960f09363cb037);
        assert_eq!(buffer.read_partial_felt252(11, 25), 0xc3ba840044f9e160ca63630deceeac9929fb6dd8b04773499f);
        assert_eq!(buffer.read_partial_felt252(5, 26), 0x3eeed56a5740c3ba840044f9e160ca63630deceeac9929fb6dd8);
        assert_eq!(buffer.read_partial_felt252(13, 27), 0x840044f9e160ca63630deceeac9929fb6dd8b04773499fb6960f09);
        assert_eq!(buffer.read_partial_felt252(2, 28), 0x790b8c3eeed56a5740c3ba840044f9e160ca63630deceeac9929fb6d);
        assert_eq!(buffer.read_partial_felt252(15, 29), 0x44f9e160ca63630deceeac9929fb6dd8b04773499fb6960f09363cb037);
        assert_eq!(buffer.read_partial_felt252(11, 30), 0xc3ba840044f9e160ca63630deceeac9929fb6dd8b04773499fb6960f0936);
        assert_eq!(buffer.read_partial_felt252(10, 31), 0x40c3ba840044f9e160ca63630deceeac9929fb6dd8b04773499fb6960f0936);
        assert_eq!(buffer.read_partial_felt252(2, 32), 0x10b8c3eeed5695840c3ba840044f9e160ca63630deceeac9929fb6dd8b04764);
        assert_eq!(buffer.hash_sha256(), [0xcd597307, 0xf2867d84, 0xb4d69848, 0x5a75230f, 0x366e9bf3, 0x554c0d7e, 0x14a43f68, 0xf6a0dc4e]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x400df732, 0xab3d5815, 0x33d6af5d, 0xc076cd53, 0x4ca38341, 0xf898a0fd, 0x22af863, 0x7edc73c3]);
        assert_eq!(buffer.hash_poseidon_range(43, 44), 0x83fccb86d32d4ffa0a8b729db8d136c2822a09cb2ccda6e69b510ef88c36a6);
        assert_eq!(buffer.hash_poseidon_range(0, 38), 0x5e75cc9e55ec5f1890d1c8120d20dffa072c7bb02234f20bc0cf3a2143a4d11);
        assert_eq!(buffer.hash_poseidon_range(27, 29), 0x4a7c9ce9e390c583559ecf4f0bc58abede0022ac8d04c74321341a98ddbcb37);
        assert_eq!(buffer.hash_poseidon_range(1, 7), 0x11b8535ec502e1c07d4e6e5be4886b75e17f4a9929926e9ddff23017109a687);
        assert_eq!(buffer.hash_poseidon_range(5, 34), 0x451ee9e4eee24ac90870ec9bc144fb16f2d03da74c6819a3982b152955f93a7);

        let mut serialized_byte_array = array![0x2, 0xf1d49aa2d964f1b2c3146190ecb35cac8167f381023405e97d6152a808dcea, 0x3526b044964660626ce4fac5abe027c5868d9548d80e551de3ce82b78410c1, 0xa816ca684dbd6c, 0x7].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(11), 0xec90);
        assert_eq!(buffer.read_u32_le(10), 0xb3ec9061);
        assert_eq!(buffer.read_u64_le(22), 0xdc08a852617de905);
        assert_eq!(buffer.read_u256(27), 0xa808dcea3526b044964660626ce4fac5abe027c5868d9548d80e551de3ce82b7);
        assert_eq!(buffer.read_bytes31(30), 0xea3526b044964660626ce4fac5abe027c5868d9548d80e551de3ce82b78410);
        assert_eq!(buffer.read_felt252(15), 0x48167f3810232a0e97d6152a808dcea3526b044964660626ce4fac5abe027b0);
        assert_eq!(buffer.read_partial_felt252(63, 1), 0x16);
        assert_eq!(buffer.read_partial_felt252(10, 2), 0x6190);
        assert_eq!(buffer.read_partial_felt252(30, 3), 0xea3526);
        assert_eq!(buffer.read_partial_felt252(41, 4), 0xfac5abe0);
        assert_eq!(buffer.read_partial_felt252(34, 5), 0x4496466062);
        assert_eq!(buffer.read_partial_felt252(34, 6), 0x44964660626c);
        assert_eq!(buffer.read_partial_felt252(46, 7), 0xc5868d9548d80e);
        assert_eq!(buffer.read_partial_felt252(45, 8), 0x27c5868d9548d80e);
        assert_eq!(buffer.read_partial_felt252(45, 9), 0x27c5868d9548d80e55);
        assert_eq!(buffer.read_partial_felt252(55, 10), 0xe3ce82b78410c1a816ca);
        assert_eq!(buffer.read_partial_felt252(34, 11), 0x44964660626ce4fac5abe0);
        assert_eq!(buffer.read_partial_felt252(41, 12), 0xfac5abe027c5868d9548d80e);
        assert_eq!(buffer.read_partial_felt252(44, 13), 0xe027c5868d9548d80e551de3ce);
        assert_eq!(buffer.read_partial_felt252(21, 14), 0x3405e97d6152a808dcea3526b044);
        assert_eq!(buffer.read_partial_felt252(7, 15), 0xb2c3146190ecb35cac8167f3810234);
        assert_eq!(buffer.read_partial_felt252(7, 16), 0xb2c3146190ecb35cac8167f381023405);
        assert_eq!(buffer.read_partial_felt252(51, 17), 0xd80e551de3ce82b78410c1a816ca684dbd);
        assert_eq!(buffer.read_partial_felt252(37, 18), 0x60626ce4fac5abe027c5868d9548d80e551d);
        assert_eq!(buffer.read_partial_felt252(49, 19), 0x9548d80e551de3ce82b78410c1a816ca684dbd);
        assert_eq!(buffer.read_partial_felt252(1, 20), 0xd49aa2d964f1b2c3146190ecb35cac8167f38102);
        assert_eq!(buffer.read_partial_felt252(42, 21), 0xc5abe027c5868d9548d80e551de3ce82b78410c1a8);
        assert_eq!(buffer.read_partial_felt252(7, 22), 0xb2c3146190ecb35cac8167f381023405e97d6152a808);
        assert_eq!(buffer.read_partial_felt252(13, 23), 0xb35cac8167f381023405e97d6152a808dcea3526b04496);
        assert_eq!(buffer.read_partial_felt252(11, 24), 0x90ecb35cac8167f381023405e97d6152a808dcea3526b044);
        assert_eq!(buffer.read_partial_felt252(42, 25), 0xc5abe027c5868d9548d80e551de3ce82b78410c1a816ca684d);
        assert_eq!(buffer.read_partial_felt252(16, 26), 0x8167f381023405e97d6152a808dcea3526b044964660626ce4fa);
        assert_eq!(buffer.read_partial_felt252(39, 27), 0x6ce4fac5abe027c5868d9548d80e551de3ce82b78410c1a816ca68);
        assert_eq!(buffer.read_partial_felt252(30, 28), 0xea3526b044964660626ce4fac5abe027c5868d9548d80e551de3ce82);
        assert_eq!(buffer.read_partial_felt252(27, 29), 0xa808dcea3526b044964660626ce4fac5abe027c5868d9548d80e551de3);
        assert_eq!(buffer.read_partial_felt252(17, 30), 0x67f381023405e97d6152a808dcea3526b044964660626ce4fac5abe027c5);
        assert_eq!(buffer.read_partial_felt252(2, 31), 0x9aa2d964f1b2c3146190ecb35cac8167f381023405e97d6152a808dcea3526);
        assert_eq!(buffer.read_partial_felt252(29, 32), 0x4ea3526b044947b60626ce4fac5abe027c5868d9548d80e551de3ce82b783f5);
        assert_eq!(buffer.hash_sha256(), [0x45061f15, 0x8d6a6b77, 0xcf33fa79, 0xe0363153, 0xaf688c46, 0xd8c73c7d, 0xf154269, 0x93a3eebc]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x12c0a174, 0xc5a034d2, 0x91707449, 0xadf25281, 0x5a2cc424, 0x61ded351, 0xb582b8e, 0xc1625616]);
        assert_eq!(buffer.hash_poseidon_range(17, 42), 0x36de72ce76a99d0e4a2265fe43737490de9c8be6abda6169ff63abb9be4d020);
        assert_eq!(buffer.hash_poseidon_range(35, 41), 0x2b9d3ad052695b0a36b86f1f756faa906a8ab7ee72a82eb78be696026d7aff3);
        assert_eq!(buffer.hash_poseidon_range(58, 66), 0x3f2cfee6856a7abe0596664032a67785ff63d36e85b829939a2e2244d307ba4);
        assert_eq!(buffer.hash_poseidon_range(18, 63), 0xea7ba91a033f7717348254fc516712ac01b18c5af6796337fa4525a3924e2f);
        assert_eq!(buffer.hash_poseidon_range(27, 66), 0x70601eff17199c9dc22785b270c358fc0682fffd7fd994368a825fa90552fad);

        let mut serialized_byte_array = array![0x2, 0x9799ee64d7f86614599863f1d1ec065a32869576a6b0d36d93cfa53fed578c, 0xd1f23e65f8e7377147bb0e4e7824b5b260f90b0b53dc70fbdee0f7a252b2a6, 0x40d13ba46bfb47b01af8, 0xa].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(15), 0x325a);
        assert_eq!(buffer.read_u32_le(1), 0xd764ee99);
        assert_eq!(buffer.read_u64_le(7), 0x6ecd1f163985914);
        assert_eq!(buffer.read_u256(5), 0xf86614599863f1d1ec065a32869576a6b0d36d93cfa53fed578cd1f23e65f8e7);
        assert_eq!(buffer.read_bytes31(21), 0xb0d36d93cfa53fed578cd1f23e65f8e7377147bb0e4e7824b5b260f90b0b53);
        assert_eq!(buffer.read_felt252(16), 0x2869576a6b0d30793cfa53fed578cd1f23e65f8e7377147bb0e4e7824b5b25a);
        assert_eq!(buffer.read_partial_felt252(36, 1), 0xe7);
        assert_eq!(buffer.read_partial_felt252(50, 2), 0xb53);
        assert_eq!(buffer.read_partial_felt252(32, 3), 0xf23e65);
        assert_eq!(buffer.read_partial_felt252(3, 4), 0x64d7f866);
        assert_eq!(buffer.read_partial_felt252(29, 5), 0x578cd1f23e);
        assert_eq!(buffer.read_partial_felt252(61, 6), 0xa640d13ba46b);
        assert_eq!(buffer.read_partial_felt252(14, 7), 0x65a32869576a6);
        assert_eq!(buffer.read_partial_felt252(12, 8), 0xd1ec065a32869576);
        assert_eq!(buffer.read_partial_felt252(12, 9), 0xd1ec065a32869576a6);
        assert_eq!(buffer.read_partial_felt252(26, 10), 0xa53fed578cd1f23e65f8);
        assert_eq!(buffer.read_partial_felt252(21, 11), 0xb0d36d93cfa53fed578cd1);
        assert_eq!(buffer.read_partial_felt252(44, 12), 0x24b5b260f90b0b53dc70fbde);
        assert_eq!(buffer.read_partial_felt252(50, 13), 0xb53dc70fbdee0f7a252b2a640);
        assert_eq!(buffer.read_partial_felt252(47, 14), 0x60f90b0b53dc70fbdee0f7a252b2);
        assert_eq!(buffer.read_partial_felt252(4, 15), 0xd7f86614599863f1d1ec065a328695);
        assert_eq!(buffer.read_partial_felt252(16, 16), 0x32869576a6b0d36d93cfa53fed578cd1);
        assert_eq!(buffer.read_partial_felt252(34, 17), 0x65f8e7377147bb0e4e7824b5b260f90b0b);
        assert_eq!(buffer.read_partial_felt252(42, 18), 0x4e7824b5b260f90b0b53dc70fbdee0f7a252);
        assert_eq!(buffer.read_partial_felt252(48, 19), 0xf90b0b53dc70fbdee0f7a252b2a640d13ba46b);
        assert_eq!(buffer.read_partial_felt252(20, 20), 0xa6b0d36d93cfa53fed578cd1f23e65f8e7377147);
        assert_eq!(buffer.read_partial_felt252(5, 21), 0xf86614599863f1d1ec065a32869576a6b0d36d93cf);
        assert_eq!(buffer.read_partial_felt252(22, 22), 0xd36d93cfa53fed578cd1f23e65f8e7377147bb0e4e78);
        assert_eq!(buffer.read_partial_felt252(6, 23), 0x6614599863f1d1ec065a32869576a6b0d36d93cfa53fed);
        assert_eq!(buffer.read_partial_felt252(13, 24), 0xec065a32869576a6b0d36d93cfa53fed578cd1f23e65f8e7);
        assert_eq!(buffer.read_partial_felt252(1, 25), 0x99ee64d7f86614599863f1d1ec065a32869576a6b0d36d93cf);
        assert_eq!(buffer.read_partial_felt252(40, 26), 0xbb0e4e7824b5b260f90b0b53dc70fbdee0f7a252b2a640d13ba4);
        assert_eq!(buffer.read_partial_felt252(6, 27), 0x6614599863f1d1ec065a32869576a6b0d36d93cfa53fed578cd1f2);
        assert_eq!(buffer.read_partial_felt252(42, 28), 0x4e7824b5b260f90b0b53dc70fbdee0f7a252b2a640d13ba46bfb47b0);
        assert_eq!(buffer.read_partial_felt252(1, 29), 0x99ee64d7f86614599863f1d1ec065a32869576a6b0d36d93cfa53fed57);
        assert_eq!(buffer.read_partial_felt252(3, 30), 0x64d7f86614599863f1d1ec065a32869576a6b0d36d93cfa53fed578cd1f2);
        assert_eq!(buffer.read_partial_felt252(40, 31), 0xbb0e4e7824b5b260f90b0b53dc70fbdee0f7a252b2a640d13ba46bfb47b01a);
        assert_eq!(buffer.read_partial_felt252(32, 32), 0x23e65f8e7376f49bb0e4e7824b5b260f90b0b53dc70fbdee0f7a252b2a640b3);
        assert_eq!(buffer.hash_sha256(), [0x5040cc71, 0x97a1f9bc, 0x4d175efa, 0xbfd4ba8e, 0xe8999d4e, 0x5ad93c1d, 0x18081f8f, 0x4544ec02]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x9e76cd5b, 0x37a06bbf, 0xf63dbf9f, 0x43ebb560, 0xe5e1811b, 0x487460aa, 0x255617e1, 0x589da221]);
        assert_eq!(buffer.hash_poseidon_range(18, 36), 0x7800a4fe4830a4a74811a008a1b4766deb40072d08f1b988d2233d36d94227b);
        assert_eq!(buffer.hash_poseidon_range(50, 66), 0x2bd5d5745e069dceb62bee440c3badf897fa67041d9d91761e14a67c23ddc5b);
        assert_eq!(buffer.hash_poseidon_range(0, 40), 0x1b1ab2ad44041997dafd91fcb1afc8503864d758b725580a345d5608f3fd83e);
        assert_eq!(buffer.hash_poseidon_range(59, 61), 0x495325266feec97b91af1d066515f1e00023e4879dd03c9a2d36be2fd680185);
        assert_eq!(buffer.hash_poseidon_range(50, 51), 0x3e89a0e415c274c3afdfb531abeb1da734b4ed89aee261a2b1fe59778a98b57);

        let mut serialized_byte_array = array![0x3, 0x9f7d174a37ad5976059fc93514f47d6215c26b8eeaca4c3569a97aac047b9a, 0x7a7c2bf0005b02f3dbc06210851617e97c45a1cdfb05a4251cdf6ac389189e, 0x3e39ad1944ba439f823f6f8571e8abcb71e1a2ae56dddcbdbf37295906a489, 0xb7fb0012b0d3, 0x6].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(52), 0xa405);
        assert_eq!(buffer.read_u32_le(41), 0x16851062);
        assert_eq!(buffer.read_u64_le(26), 0x2b7c7a9a7b04ac7a);
        assert_eq!(buffer.read_u256(20), 0xeaca4c3569a97aac047b9a7a7c2bf0005b02f3dbc06210851617e97c45a1cdfb);
        assert_eq!(buffer.read_bytes31(9), 0x9fc93514f47d6215c26b8eeaca4c3569a97aac047b9a7a7c2bf0005b02f3db);
        assert_eq!(buffer.read_felt252(42), 0x851617e97c457fcdfb05a4251cdf6ac389189e3e39ad1944ba439f823f6f83);
        assert_eq!(buffer.read_partial_felt252(30, 1), 0x9a);
        assert_eq!(buffer.read_partial_felt252(86, 2), 0xbf37);
        assert_eq!(buffer.read_partial_felt252(49, 3), 0xa1cdfb);
        assert_eq!(buffer.read_partial_felt252(66, 4), 0x44ba439f);
        assert_eq!(buffer.read_partial_felt252(86, 5), 0xbf37295906);
        assert_eq!(buffer.read_partial_felt252(12, 6), 0x14f47d6215c2);
        assert_eq!(buffer.read_partial_felt252(66, 7), 0x44ba439f823f6f);
        assert_eq!(buffer.read_partial_felt252(37, 8), 0x2f3dbc062108516);
        assert_eq!(buffer.read_partial_felt252(9, 9), 0x9fc93514f47d6215c2);
        assert_eq!(buffer.read_partial_felt252(25, 10), 0xa97aac047b9a7a7c2bf0);
        assert_eq!(buffer.read_partial_felt252(44, 11), 0x1617e97c45a1cdfb05a425);
        assert_eq!(buffer.read_partial_felt252(82, 12), 0x56dddcbdbf37295906a489b7);
        assert_eq!(buffer.read_partial_felt252(42, 13), 0x10851617e97c45a1cdfb05a425);
        assert_eq!(buffer.read_partial_felt252(7, 14), 0x76059fc93514f47d6215c26b8eea);
        assert_eq!(buffer.read_partial_felt252(59, 15), 0x89189e3e39ad1944ba439f823f6f85);
        assert_eq!(buffer.read_partial_felt252(24, 16), 0x69a97aac047b9a7a7c2bf0005b02f3db);
        assert_eq!(buffer.read_partial_felt252(57, 17), 0x6ac389189e3e39ad1944ba439f823f6f85);
        assert_eq!(buffer.read_partial_felt252(73, 18), 0x8571e8abcb71e1a2ae56dddcbdbf37295906);
        assert_eq!(buffer.read_partial_felt252(49, 19), 0xa1cdfb05a4251cdf6ac389189e3e39ad1944ba);
        assert_eq!(buffer.read_partial_felt252(25, 20), 0xa97aac047b9a7a7c2bf0005b02f3dbc062108516);
        assert_eq!(buffer.read_partial_felt252(50, 21), 0xcdfb05a4251cdf6ac389189e3e39ad1944ba439f82);
        assert_eq!(buffer.read_partial_felt252(37, 22), 0x2f3dbc06210851617e97c45a1cdfb05a4251cdf6ac3);
        assert_eq!(buffer.read_partial_felt252(27, 23), 0xac047b9a7a7c2bf0005b02f3dbc06210851617e97c45a1);
        assert_eq!(buffer.read_partial_felt252(26, 24), 0x7aac047b9a7a7c2bf0005b02f3dbc06210851617e97c45a1);
        assert_eq!(buffer.read_partial_felt252(38, 25), 0xf3dbc06210851617e97c45a1cdfb05a4251cdf6ac389189e3e);
        assert_eq!(buffer.read_partial_felt252(56, 26), 0xdf6ac389189e3e39ad1944ba439f823f6f8571e8abcb71e1a2ae);
        assert_eq!(buffer.read_partial_felt252(52, 27), 0x5a4251cdf6ac389189e3e39ad1944ba439f823f6f8571e8abcb71);
        assert_eq!(buffer.read_partial_felt252(29, 28), 0x7b9a7a7c2bf0005b02f3dbc06210851617e97c45a1cdfb05a4251cdf);
        assert_eq!(buffer.read_partial_felt252(66, 29), 0x44ba439f823f6f8571e8abcb71e1a2ae56dddcbdbf37295906a489b7fb);
        assert_eq!(buffer.read_partial_felt252(66, 30), 0x44ba439f823f6f8571e8abcb71e1a2ae56dddcbdbf37295906a489b7fb00);
        assert_eq!(buffer.read_partial_felt252(18, 31), 0x6b8eeaca4c3569a97aac047b9a7a7c2bf0005b02f3dbc06210851617e97c45);
        assert_eq!(buffer.read_partial_felt252(48, 32), 0x5a1cdfb05a42494df6ac389189e3e39ad1944ba439f823f6f8571e8abcb71d9);
        assert_eq!(buffer.hash_sha256(), [0xfd54fda0, 0x9ccc2d37, 0xef83a4d8, 0xc16b57bf, 0xb1a1b790, 0x545ebb71, 0xea199f49, 0xeef7e17b]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x9ace9900, 0xcac95df7, 0x1eb1bf9e, 0x60691b02, 0xcac27e29, 0xd984ae9f, 0x512cca2b, 0xf8c8421]);
        assert_eq!(buffer.hash_poseidon_range(89, 90), 0x661886120bab150fb19a50b36591b2566cb73a3ad4f39d4493b7d71bd8abbce);
        assert_eq!(buffer.hash_poseidon_range(34, 95), 0x3b51c6b231005ca55029c7f85ba3c8b7990439416b8de107ba095e9b15345eb);
        assert_eq!(buffer.hash_poseidon_range(42, 98), 0x54a61dfc1f7a621e944919a63de9cb980c42f6b2e8a14bfcfd0199d2fa833f1);
        assert_eq!(buffer.hash_poseidon_range(52, 74), 0x6d40f691c63345dfda269da25d4cb155b7d1b50dd01a0afc9c3d68cdef92bf8);
        assert_eq!(buffer.hash_poseidon_range(32, 63), 0x34b9b6d8002d58c8d8e9de61c19750c1b47944e451e0c729893355f02a048c0);

        let mut serialized_byte_array = array![0x3, 0xa6c4649106100b57d649f67bd92b32cbe756f67ef935e81b7920e4d4c4c3e2, 0x4b42240c187e6c4b0029cc297022f2b35e94251d0f0e8f8e8b7d2ede9f1348, 0x527b4814d7030c3f9950ed4b6bc5ebe8e98bff90fe3a3184bfc6964b47fbdb, 0x5e9a55b7439eb6e726bffde5c0b788cee64d, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(42), 0x7029);
        assert_eq!(buffer.read_u32_le(12), 0xcb322bd9);
        assert_eq!(buffer.read_u64_le(23), 0xe2c3c4d4e420791b);
        assert_eq!(buffer.read_u256(9), 0x49f67bd92b32cbe756f67ef935e81b7920e4d4c4c3e24b42240c187e6c4b0029);
        assert_eq!(buffer.read_bytes31(59), 0x9f1348527b4814d7030c3f9950ed4b6bc5ebe8e98bff90fe3a3184bfc6964b);
        assert_eq!(buffer.read_felt252(2), 0x49106100b57d57df67bd92b32cbe756f67ef935e81b7920e4d4c4c3e24b4218);
        assert_eq!(buffer.read_partial_felt252(2, 1), 0x64);
        assert_eq!(buffer.read_partial_felt252(66, 2), 0xd703);
        assert_eq!(buffer.read_partial_felt252(91, 3), 0xfbdb5e);
        assert_eq!(buffer.read_partial_felt252(86, 4), 0xbfc6964b);
        assert_eq!(buffer.read_partial_felt252(32, 5), 0x42240c187e);
        assert_eq!(buffer.read_partial_felt252(70, 6), 0x9950ed4b6bc5);
        assert_eq!(buffer.read_partial_felt252(15, 7), 0xcbe756f67ef935);
        assert_eq!(buffer.read_partial_felt252(55, 8), 0x8b7d2ede9f134852);
        assert_eq!(buffer.read_partial_felt252(64, 9), 0x4814d7030c3f9950ed);
        assert_eq!(buffer.read_partial_felt252(44, 10), 0x22f2b35e94251d0f0e8f);
        assert_eq!(buffer.read_partial_felt252(88, 11), 0x964b47fbdb5e9a55b7439e);
        assert_eq!(buffer.read_partial_felt252(3, 12), 0x9106100b57d649f67bd92b32);
        assert_eq!(buffer.read_partial_felt252(36, 13), 0x7e6c4b0029cc297022f2b35e94);
        assert_eq!(buffer.read_partial_felt252(24, 14), 0x7920e4d4c4c3e24b42240c187e6c);
        assert_eq!(buffer.read_partial_felt252(10, 15), 0xf67bd92b32cbe756f67ef935e81b79);
        assert_eq!(buffer.read_partial_felt252(60, 16), 0x1348527b4814d7030c3f9950ed4b6bc5);
        assert_eq!(buffer.read_partial_felt252(25, 17), 0x20e4d4c4c3e24b42240c187e6c4b0029cc);
        assert_eq!(buffer.read_partial_felt252(4, 18), 0x6100b57d649f67bd92b32cbe756f67ef935);
        assert_eq!(buffer.read_partial_felt252(82, 19), 0xfe3a3184bfc6964b47fbdb5e9a55b7439eb6e7);
        assert_eq!(buffer.read_partial_felt252(78, 20), 0xe98bff90fe3a3184bfc6964b47fbdb5e9a55b743);
        assert_eq!(buffer.read_partial_felt252(88, 21), 0x964b47fbdb5e9a55b7439eb6e726bffde5c0b788ce);
        assert_eq!(buffer.read_partial_felt252(41, 22), 0xcc297022f2b35e94251d0f0e8f8e8b7d2ede9f134852);
        assert_eq!(buffer.read_partial_felt252(19, 23), 0x7ef935e81b7920e4d4c4c3e24b42240c187e6c4b0029cc);
        assert_eq!(buffer.read_partial_felt252(63, 24), 0x7b4814d7030c3f9950ed4b6bc5ebe8e98bff90fe3a3184bf);
        assert_eq!(buffer.read_partial_felt252(59, 25), 0x9f1348527b4814d7030c3f9950ed4b6bc5ebe8e98bff90fe3a);
        assert_eq!(buffer.read_partial_felt252(52, 26), 0xe8f8e8b7d2ede9f1348527b4814d7030c3f9950ed4b6bc5ebe8);
        assert_eq!(buffer.read_partial_felt252(31, 27), 0x4b42240c187e6c4b0029cc297022f2b35e94251d0f0e8f8e8b7d2e);
        assert_eq!(buffer.read_partial_felt252(82, 28), 0xfe3a3184bfc6964b47fbdb5e9a55b7439eb6e726bffde5c0b788cee6);
        assert_eq!(buffer.read_partial_felt252(47, 29), 0x5e94251d0f0e8f8e8b7d2ede9f1348527b4814d7030c3f9950ed4b6bc5);
        assert_eq!(buffer.read_partial_felt252(72, 30), 0xed4b6bc5ebe8e98bff90fe3a3184bfc6964b47fbdb5e9a55b7439eb6e726);
        assert_eq!(buffer.read_partial_felt252(50, 31), 0x1d0f0e8f8e8b7d2ede9f1348527b4814d7030c3f9950ed4b6bc5ebe8e98bff);
        assert_eq!(buffer.read_partial_felt252(44, 32), 0x2f2b35e94251ccb0e8f8e8b7d2ede9f1348527b4814d7030c3f9950ed4b6bc1);
        assert_eq!(buffer.hash_sha256(), [0x74ebca90, 0x5717c18b, 0xe7d32e6f, 0x75e7d3ab, 0xa0d3e637, 0x62c18366, 0xa74e76d8, 0xbd2528a2]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x4b741931, 0x586aa788, 0x6c5b4762, 0xfc9fbe9c, 0x16e20759, 0x3f4a8268, 0xc4e44ea4, 0xb3176077]);
        assert_eq!(buffer.hash_poseidon_range(10, 33), 0x2a8889fa5578e5375618fff7da160b7ab766f3c5fba7a1f18401dc5b1c9088d);
        assert_eq!(buffer.hash_poseidon_range(33, 109), 0xc633a4670c5e9c39ee1bcaea798950988db5741d3e34448e7541cda8b55ea1);
        assert_eq!(buffer.hash_poseidon_range(70, 110), 0x4d0bb08a7a8b1d22a70a16647eb5317b99e05b9d64a63b418a4c52214de2a97);
        assert_eq!(buffer.hash_poseidon_range(107, 108), 0x55b35ae26ccc5a56e415a9c2c5187d0597f0997474075d01f93bd16c83e7b28);
        assert_eq!(buffer.hash_poseidon_range(28, 76), 0x3a2e3e74b4e6b496dbab651c251ec2a2ef29d300768d973fa5013b88097032b);

        let mut serialized_byte_array = array![0x3, 0x61d4b7372e6dd2c57cdc9377a168f461f0253b229cca408d4eb0129ea6f9eb, 0x343404d848c1c6018e7b2b53178c0cca4194efea712c629e0522520d3fd44e, 0xc446e5bb8c1b00eabce27d90712c86996610f4321cfa2bf8cdeaa3c1678bef, 0xee9ce400c9abbb60a5, 0x9].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(56), 0x5222);
        assert_eq!(buffer.read_u32_le(12), 0x61f468a1);
        assert_eq!(buffer.read_u64_le(9), 0xf061f468a17793dc);
        assert_eq!(buffer.read_u256(46), 0xca4194efea712c629e0522520d3fd44ec446e5bb8c1b00eabce27d90712c8699);
        assert_eq!(buffer.read_bytes31(34), 0xd848c1c6018e7b2b53178c0cca4194efea712c629e0522520d3fd44ec446e5);
        assert_eq!(buffer.read_felt252(7), 0x57cdc9377a1675c61f0253b229cca408d4eb0129ea6f9eb343404d848c1c5e9);
        assert_eq!(buffer.read_partial_felt252(88, 1), 0xa3);
        assert_eq!(buffer.read_partial_felt252(57, 2), 0x520d);
        assert_eq!(buffer.read_partial_felt252(2, 3), 0xb7372e);
        assert_eq!(buffer.read_partial_felt252(70, 4), 0xbce27d90);
        assert_eq!(buffer.read_partial_felt252(91, 5), 0x8befee9ce4);
        assert_eq!(buffer.read_partial_felt252(48, 6), 0x94efea712c62);
        assert_eq!(buffer.read_partial_felt252(61, 7), 0x4ec446e5bb8c1b);
        assert_eq!(buffer.read_partial_felt252(40, 8), 0x7b2b53178c0cca41);
        assert_eq!(buffer.read_partial_felt252(53, 9), 0x629e0522520d3fd44e);
        assert_eq!(buffer.read_partial_felt252(3, 10), 0x372e6dd2c57cdc9377a1);
        assert_eq!(buffer.read_partial_felt252(57, 11), 0x520d3fd44ec446e5bb8c1b);
        assert_eq!(buffer.read_partial_felt252(45, 12), 0xcca4194efea712c629e0522);
        assert_eq!(buffer.read_partial_felt252(76, 13), 0x86996610f4321cfa2bf8cdeaa3);
        assert_eq!(buffer.read_partial_felt252(71, 14), 0xe27d90712c86996610f4321cfa2b);
        assert_eq!(buffer.read_partial_felt252(85, 15), 0xf8cdeaa3c1678befee9ce400c9abbb);
        assert_eq!(buffer.read_partial_felt252(48, 16), 0x94efea712c629e0522520d3fd44ec446);
        assert_eq!(buffer.read_partial_felt252(46, 17), 0xca4194efea712c629e0522520d3fd44ec4);
        assert_eq!(buffer.read_partial_felt252(79, 18), 0x10f4321cfa2bf8cdeaa3c1678befee9ce400);
        assert_eq!(buffer.read_partial_felt252(37, 19), 0xc6018e7b2b53178c0cca4194efea712c629e05);
        assert_eq!(buffer.read_partial_felt252(22, 20), 0x408d4eb0129ea6f9eb343404d848c1c6018e7b2b);
        assert_eq!(buffer.read_partial_felt252(64, 21), 0xe5bb8c1b00eabce27d90712c86996610f4321cfa2b);
        assert_eq!(buffer.read_partial_felt252(30, 22), 0xeb343404d848c1c6018e7b2b53178c0cca4194efea71);
        assert_eq!(buffer.read_partial_felt252(25, 23), 0xb0129ea6f9eb343404d848c1c6018e7b2b53178c0cca41);
        assert_eq!(buffer.read_partial_felt252(44, 24), 0x8c0cca4194efea712c629e0522520d3fd44ec446e5bb8c1b);
        assert_eq!(buffer.read_partial_felt252(30, 25), 0xeb343404d848c1c6018e7b2b53178c0cca4194efea712c629e);
        assert_eq!(buffer.read_partial_felt252(31, 26), 0x343404d848c1c6018e7b2b53178c0cca4194efea712c629e0522);
        assert_eq!(buffer.read_partial_felt252(5, 27), 0x6dd2c57cdc9377a168f461f0253b229cca408d4eb0129ea6f9eb34);
        assert_eq!(buffer.read_partial_felt252(0, 28), 0x61d4b7372e6dd2c57cdc9377a168f461f0253b229cca408d4eb0129e);
        assert_eq!(buffer.read_partial_felt252(25, 29), 0xb0129ea6f9eb343404d848c1c6018e7b2b53178c0cca4194efea712c62);
        assert_eq!(buffer.read_partial_felt252(9, 30), 0xdc9377a168f461f0253b229cca408d4eb0129ea6f9eb343404d848c1c601);
        assert_eq!(buffer.read_partial_felt252(59, 31), 0x3fd44ec446e5bb8c1b00eabce27d90712c86996610f4321cfa2bf8cdeaa3c1);
        assert_eq!(buffer.read_partial_felt252(45, 32), 0x4ca4194efea711b629e0522520d3fd44ec446e5bb8c1b00eabce27d90712c85);
        assert_eq!(buffer.hash_sha256(), [0x52aad9d2, 0xbe2ad340, 0x21d3347c, 0x3430c4e5, 0x501ab66f, 0x535f79a1, 0x74dbcc10, 0xb43a8a06]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xc391addd, 0x24d41e19, 0x1ce74dba, 0x43ef58fd, 0x11c6ce39, 0x9297f4ea, 0x105a31cc, 0x276b8223]);
        assert_eq!(buffer.hash_poseidon_range(8, 56), 0x803dcd5a60cb8523fad6cbd52413acb48e4a7f885915276fd2b7f0a38891c5);
        assert_eq!(buffer.hash_poseidon_range(71, 91), 0x7a16487b62f28fe34a01e920bd47d4fbe119b5926e0ce06224ec54e66db57d4);
        assert_eq!(buffer.hash_poseidon_range(101, 101), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(buffer.hash_poseidon_range(59, 71), 0x72b32d51372700b88fc414645cf58cf31fceabfa335d455b48fd06dc270861);
        assert_eq!(buffer.hash_poseidon_range(78, 100), 0x520537fe601b5ba0f33ee18e4a560dd3c9124dd3ff85ec978017d0493f6b1ce);

        let mut serialized_byte_array = array![0x2, 0xd0e74d9c7b85ddeb1e02cdb2cca7773970abb8bb318fcff3f5f78d8bc5c87a, 0xc163f25c1261df70b14d48879b0ad788d645c2610955f2650293284c4868f4, 0x534513411e197843b93f751ae97d0b3e87c6406a50, 0x15].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(39), 0x4db1);
        assert_eq!(buffer.read_u32_le(23), 0x8df7f5f3);
        assert_eq!(buffer.read_u64_le(71), 0x873e0b7de91a753f);
        assert_eq!(buffer.read_u256(14), 0x773970abb8bb318fcff3f5f78d8bc5c87ac163f25c1261df70b14d48879b0ad7);
        assert_eq!(buffer.read_bytes31(9), 0x02cdb2cca7773970abb8bb318fcff3f5f78d8bc5c87ac163f25c1261df70b1);
        assert_eq!(buffer.read_felt252(20), 0x18fcff3f5f78d25c5c87ac163f25c1261df70b14d48879b0ad788d645c26103);
        assert_eq!(buffer.read_partial_felt252(51, 1), 0x9);
        assert_eq!(buffer.read_partial_felt252(54, 2), 0x6502);
        assert_eq!(buffer.read_partial_felt252(53, 3), 0xf26502);
        assert_eq!(buffer.read_partial_felt252(24, 4), 0xf5f78d8b);
        assert_eq!(buffer.read_partial_felt252(23, 5), 0xf3f5f78d8b);
        assert_eq!(buffer.read_partial_felt252(15, 6), 0x3970abb8bb31);
        assert_eq!(buffer.read_partial_felt252(56, 7), 0x93284c4868f453);
        assert_eq!(buffer.read_partial_felt252(28, 8), 0xc5c87ac163f25c12);
        assert_eq!(buffer.read_partial_felt252(24, 9), 0xf5f78d8bc5c87ac163);
        assert_eq!(buffer.read_partial_felt252(45, 10), 0xd788d645c2610955f265);
        assert_eq!(buffer.read_partial_felt252(45, 11), 0xd788d645c2610955f26502);
        assert_eq!(buffer.read_partial_felt252(4, 12), 0x7b85ddeb1e02cdb2cca77739);
        assert_eq!(buffer.read_partial_felt252(14, 13), 0x773970abb8bb318fcff3f5f78d);
        assert_eq!(buffer.read_partial_felt252(8, 14), 0x1e02cdb2cca7773970abb8bb318f);
        assert_eq!(buffer.read_partial_felt252(55, 15), 0x293284c4868f4534513411e197843);
        assert_eq!(buffer.read_partial_felt252(64, 16), 0x13411e197843b93f751ae97d0b3e87c6);
        assert_eq!(buffer.read_partial_felt252(58, 17), 0x4c4868f4534513411e197843b93f751ae9);
        assert_eq!(buffer.read_partial_felt252(12, 18), 0xcca7773970abb8bb318fcff3f5f78d8bc5c8);
        assert_eq!(buffer.read_partial_felt252(40, 19), 0x4d48879b0ad788d645c2610955f2650293284c);
        assert_eq!(buffer.read_partial_felt252(38, 20), 0x70b14d48879b0ad788d645c2610955f265029328);
        assert_eq!(buffer.read_partial_felt252(30, 21), 0x7ac163f25c1261df70b14d48879b0ad788d645c261);
        assert_eq!(buffer.read_partial_felt252(48, 22), 0x45c2610955f2650293284c4868f4534513411e197843);
        assert_eq!(buffer.read_partial_felt252(19, 23), 0xbb318fcff3f5f78d8bc5c87ac163f25c1261df70b14d48);
        assert_eq!(buffer.read_partial_felt252(18, 24), 0xb8bb318fcff3f5f78d8bc5c87ac163f25c1261df70b14d48);
        assert_eq!(buffer.read_partial_felt252(40, 25), 0x4d48879b0ad788d645c2610955f2650293284c4868f4534513);
        assert_eq!(buffer.read_partial_felt252(37, 26), 0xdf70b14d48879b0ad788d645c2610955f2650293284c4868f453);
        assert_eq!(buffer.read_partial_felt252(15, 27), 0x3970abb8bb318fcff3f5f78d8bc5c87ac163f25c1261df70b14d48);
        assert_eq!(buffer.read_partial_felt252(7, 28), 0xeb1e02cdb2cca7773970abb8bb318fcff3f5f78d8bc5c87ac163f25c);
        assert_eq!(buffer.read_partial_felt252(34, 29), 0x5c1261df70b14d48879b0ad788d645c2610955f2650293284c4868f453);
        assert_eq!(buffer.read_partial_felt252(25, 30), 0xf78d8bc5c87ac163f25c1261df70b14d48879b0ad788d645c2610955f265);
        assert_eq!(buffer.read_partial_felt252(27, 31), 0x8bc5c87ac163f25c1261df70b14d48879b0ad788d645c2610955f265029328);
        assert_eq!(buffer.read_partial_felt252(49, 32), 0x2610955f26500fb284c4868f4534513411e197843b93f751ae97d0b3e87c628);
        assert_eq!(buffer.hash_sha256(), [0x49b46f76, 0x4b5cceb6, 0x1954f93b, 0x19682f01, 0x60954a7f, 0xa56b11cf, 0x824cc7e8, 0x40ee471e]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x59245637, 0xf46956c6, 0xad1e6e58, 0xa40c2b13, 0xa684960d, 0x89fc877c, 0xfcaf4b5a, 0x22acaa18]);
        assert_eq!(buffer.hash_poseidon_range(18, 75), 0x20de2ce3546221669ed0e4b9bf2dfe2c68152de1cc616aadcad03819d76fd66);
        assert_eq!(buffer.hash_poseidon_range(38, 56), 0x7bd6f91555b2d7e7901b78e4ba6e23396ee937cd1d28b3738d98514bd8c36cb);
        assert_eq!(buffer.hash_poseidon_range(13, 40), 0x5c72375c40ef1a7763d32a42256ded0462bdd379be0c8e0d037f1a06bcc0b44);
        assert_eq!(buffer.hash_poseidon_range(36, 58), 0x5a9433db88b1c5fecff1eb844398f6065cdadad123f7a78c942ed7415142659);
        assert_eq!(buffer.hash_poseidon_range(45, 49), 0x13762c3a49fea1e669eb489ee094a1dad6b05be3f89cb94fe8c1170c002096a);


        // Random access test cases testing random reads

        let mut serialized_byte_array = array![0x2, 0xe9c28342352d18a1875b96c0a3d90447d0851ab32e2cb048f9a6c8ce6e1ba0, 0x4789e867dc45f1cba3f4d669c6052901305699c1e6ebb2bd9c049811b9fa93, 0x008ec53b5e, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(24, 25), 0xf9a6c8ce6e1ba04789e867dc45f1cba3f4d669c60529013056);
        assert_eq!(buffer.read_u64_le(18), 0xa6f948b02c2eb31a);
        assert_eq!(buffer.read_partial_felt252(30, 21), 0xa04789e867dc45f1cba3f4d669c6052901305699c1);
        assert_eq!(buffer.read_u64_le(1), 0x87a1182d354283c2);
        assert_eq!(buffer.read_partial_felt252(46, 16), 0x1305699c1e6ebb2bd9c049811b9fa93);
        assert_eq!(buffer.read_partial_felt252(42, 19), 0x69c6052901305699c1e6ebb2bd9c049811b9fa);
        assert_eq!(buffer.read_u64_le(16), 0x48b02c2eb31a85d0);
        assert_eq!(buffer.read_partial_felt252(28, 10), 0x6e1ba04789e867dc45f1);
        assert_eq!(buffer.read_partial_felt252(42, 11), 0x69c6052901305699c1e6eb);
        assert_eq!(buffer.read_partial_felt252(8, 29), 0x875b96c0a3d90447d0851ab32e2cb048f9a6c8ce6e1ba04789e867dc45);

        let mut serialized_byte_array = array![0x3, 0x0456e56ac08eda45811c8b0fe20f8352c59d9c36f0b53c687216c3ee96462b, 0x74c437dcc830109591e2ddff1d8378b3f9f4000601cac009ae213025d8e70e, 0xe2b311cc90a6cd51cbe8fc6525564caff5dc9aba31b8f1769c38a57f7274fe, 0x44f5cf6a652305e4b906cb5469a72164aac10d424947374b512c539e2c781a, 0x1f].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(110, 3), 0xc10d42);
        assert_eq!(buffer.read_u16_le(27), 0x96ee);
        assert_eq!(buffer.read_u64_le(95), 0x6b9e40523656acf);
        assert_eq!(buffer.read_partial_felt252(98, 20), 0x2305e4b906cb5469a72164aac10d424947374b51);
        assert_eq!(buffer.hash_poseidon_range(81, 115), 0x5bcbcdfbc648fe3f8fc4f1795a0e9c30f8cbb6bb57107634dfd361af05649b6);
        assert_eq!(buffer.read_partial_felt252(46, 30), 0xb3f9f4000601cac009ae213025d8e70ee2b311cc90a6cd51cbe8fc652556);
        assert_eq!(buffer.read_partial_felt252(21, 16), 0xb53c687216c3ee96462b74c437dcc830);
        assert_eq!(buffer.read_partial_felt252(46, 20), 0xb3f9f4000601cac009ae213025d8e70ee2b311cc);
        assert_eq!(buffer.read_partial_felt252(91, 27), 0x74fe44f5cf6a652305e4b906cb5469a72164aac10d424947374b51);
        assert_eq!(buffer.read_partial_felt252(31, 28), 0x74c437dcc830109591e2ddff1d8378b3f9f4000601cac009ae213025);

        let mut serialized_byte_array = array![0x3, 0xcf2143982648cded784b3a9891860497cfe5a0f7df7727b2a7069cff3e8c92, 0x085acc4dc0469303fcf4884fdb752c901f433dd5f9bcccb08666c8701442f3, 0xd92b46eafc5667b54a7d0ee7d89e364feb31f9bd7ee4504895492b5d1c9579, 0xa4905978e493b5c93621d42d8b47cbf71caf, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u256(30), 0x92085acc4dc0469303fcf4884fdb752c901f433dd5f9bcccb08666c8701442f3);
        assert_eq!(buffer.read_partial_felt252(71, 21), 0x7d0ee7d89e364feb31f9bd7ee4504895492b5d1c95);
        assert_eq!(buffer.read_partial_felt252(19, 21), 0xf7df7727b2a7069cff3e8c92085acc4dc0469303fc);
        assert_eq!(buffer.read_partial_felt252(1, 12), 0x2143982648cded784b3a9891);
        assert_eq!(buffer.read_partial_felt252(54, 30), 0xb08666c8701442f3d92b46eafc5667b54a7d0ee7d89e364feb31f9bd7ee4);
        assert_eq!(buffer.read_partial_felt252(39, 15), 0xfcf4884fdb752c901f433dd5f9bccc);
        assert_eq!(buffer.read_partial_felt252(38, 24), 0x3fcf4884fdb752c901f433dd5f9bcccb08666c8701442f3);
        assert_eq!(buffer.read_partial_felt252(47, 3), 0x1f433d);
        assert_eq!(buffer.read_partial_felt252(15, 14), 0x97cfe5a0f7df7727b2a7069cff3e);
        assert_eq!(buffer.read_partial_felt252(20, 8), 0xdf7727b2a7069cff);

        let mut serialized_byte_array = array![0x1, 0x9fee9ae5b61596c7034edf8da6eb804505c34863ea8de095faedb75378c9a6, 0x56f79f53b1866b8a3098cb276015a72f26d69cc5861994a4c6, 0x19].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(41, 13), 0xcb276015a72f26d69cc5861994);
        assert_eq!(buffer.read_partial_felt252(1, 3), 0xee9ae5);
        assert_eq!(buffer.read_bytes31(19), 0x63ea8de095faedb75378c9a656f79f53b1866b8a3098cb276015a72f26d69c);
        assert_eq!(buffer.read_partial_felt252(43, 9), 0x6015a72f26d69cc586);
        assert_eq!(buffer.read_u256(15), 0x4505c34863ea8de095faedb75378c9a656f79f53b1866b8a3098cb276015a72f);
        assert_eq!(buffer.read_u64_le(20), 0x53b7edfa95e08dea);
        assert_eq!(buffer.read_partial_felt252(11, 23), 0x8da6eb804505c34863ea8de095faedb75378c9a656f79f);
        assert_eq!(buffer.read_partial_felt252(17, 29), 0xc34863ea8de095faedb75378c9a656f79f53b1866b8a3098cb276015a7);
        assert_eq!(buffer.read_partial_felt252(17, 31), 0xc34863ea8de095faedb75378c9a656f79f53b1866b8a3098cb276015a72f26);
        assert_eq!(buffer.read_partial_felt252(39, 15), 0x3098cb276015a72f26d69cc5861994);

        let mut serialized_byte_array = array![0x1, 0xe2385e4b836f409502f6fe43f0db7654b1cc7bd0bb53db1e0ade9840a63160, 0x2e6faf878b, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(9, 22), 0xf6fe43f0db7654b1cc7bd0bb53db1e0ade9840a63160);
        assert_eq!(buffer.read_partial_felt252(8, 8), 0x2f6fe43f0db7654);
        assert_eq!(buffer.read_partial_felt252(0, 31), 0xe2385e4b836f409502f6fe43f0db7654b1cc7bd0bb53db1e0ade9840a63160);
        assert_eq!(buffer.read_partial_felt252(0, 28), 0xe2385e4b836f409502f6fe43f0db7654b1cc7bd0bb53db1e0ade9840);
        assert_eq!(buffer.read_partial_felt252(8, 23), 0x2f6fe43f0db7654b1cc7bd0bb53db1e0ade9840a63160);
        assert_eq!(buffer.read_partial_felt252(0, 24), 0xe2385e4b836f409502f6fe43f0db7654b1cc7bd0bb53db1e);
        assert_eq!(buffer.read_partial_felt252(6, 17), 0x409502f6fe43f0db7654b1cc7bd0bb53db);
        assert_eq!(buffer.read_partial_felt252(14, 6), 0x7654b1cc7bd0);
        assert_eq!(buffer.read_partial_felt252(4, 23), 0x836f409502f6fe43f0db7654b1cc7bd0bb53db1e0ade98);
        assert_eq!(buffer.read_u256(2), 0x5e4b836f409502f6fe43f0db7654b1cc7bd0bb53db1e0ade9840a631602e6faf);

        let mut serialized_byte_array = array![0x3, 0xff2498683d4e703a7b7215bb2e5a2f3b0f0152e689a02a7a826f606cfde90f, 0x8e5110bdcf10cfd569b729d7b68ac0a0a6c3f116bf03fc0eddae0cde38209d, 0x52140fb867ed88912e19c1c572be498912d2ea41f91840aad613c37a8298ad, 0x17afbeb026f076ba, 0x8].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(76, 21), 0x498912d2ea41f91840aad613c37a8298ad17afbeb0);
        assert_eq!(buffer.read_partial_felt252(16, 11), 0xf0152e689a02a7a826f60);
        assert_eq!(buffer.read_partial_felt252(30, 29), 0xf8e5110bdcf10cfd569b729d7b68ac0a0a6c3f116bf03fc0eddae0cde);
        assert_eq!(buffer.read_partial_felt252(57, 5), 0xcde38209d);
        assert_eq!(buffer.read_partial_felt252(44, 21), 0x8ac0a0a6c3f116bf03fc0eddae0cde38209d52140f);
        assert_eq!(buffer.read_partial_felt252(67, 15), 0xed88912e19c1c572be498912d2ea41);
        assert_eq!(buffer.read_partial_felt252(39, 24), 0x69b729d7b68ac0a0a6c3f116bf03fc0eddae0cde38209d52);
        assert_eq!(buffer.read_partial_felt252(34, 20), 0xbdcf10cfd569b729d7b68ac0a0a6c3f116bf03fc);
        assert_eq!(buffer.read_partial_felt252(57, 8), 0xcde38209d52140f);
        assert_eq!(buffer.read_partial_felt252(30, 1), 0xf);

        let mut serialized_byte_array = array![0x0, 0x5326e373b771f6167b318e88, 0xc].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u32_le(5), 0x7b16f671);
        assert_eq!(buffer.read_partial_felt252(0, 12), 0x5326e373b771f6167b318e88);
        assert_eq!(buffer.read_partial_felt252(0, 11), 0x5326e373b771f6167b318e);

        let mut serialized_byte_array = array![0x3, 0x0a34194bc0de6f804f7d450edda55c7fd23c92c4ec8630f02868a1e69132e9, 0x3d970ffb6a213ad2909cee6fdffded5f4df191d5e83ddfe3b096b8498ce577, 0x0896f1011f9ca99b62722988d112b122c1db6667f6daa42a755ac10875d2d8, 0x22, 0x1].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(4, 14), 0xc0de6f804f7d450edda55c7fd23c);
        assert_eq!(buffer.read_partial_felt252(17, 9), 0x3c92c4ec8630f02868);
        assert_eq!(buffer.read_felt252(17), 0x492c4ec8630efb168a1e69132e93d970ffb6a213ad2909cee6fdffded5f4dea);
        assert_eq!(buffer.read_partial_felt252(40, 22), 0x9cee6fdffded5f4df191d5e83ddfe3b096b8498ce577);
        assert_eq!(buffer.read_partial_felt252(39, 6), 0x909cee6fdffd);
        assert_eq!(buffer.read_partial_felt252(83, 2), 0xdaa4);
        assert_eq!(buffer.hash_poseidon_range(35, 87), 0x3362ebc61d7bb7d8a13d5cd3ee7d2859d6df27ea8fda500ed2aaa312cd64dca);
        assert_eq!(buffer.read_partial_felt252(26, 14), 0xa1e69132e93d970ffb6a213ad290);
        assert_eq!(buffer.read_partial_felt252(39, 30), 0x909cee6fdffded5f4df191d5e83ddfe3b096b8498ce5770896f1011f9ca9);
        assert_eq!(buffer.read_partial_felt252(56, 27), 0x96b8498ce5770896f1011f9ca99b62722988d112b122c1db6667f6);

        let mut serialized_byte_array = array![0x0, 0xef64675d, 0x4].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(0, 3), 0xef6467);
        assert_eq!(buffer.hash_poseidon_range(1, 3), 0x190da4970e4c85c882f44358ed8479853ad6ffb161a9d19efac464737c1c8e5);

        let mut serialized_byte_array = array![0x1, 0xdcaef252dc79f362875d0def09d22c270be93e6be0f079ae34b785a21fb396, 0x4fc8a0b9c8a684b4b0c2436bee157b60382716748e42ab37ca0dd050719c, 0x1e].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(48, 12), 0x2716748e42ab37ca0dd05071);
        assert_eq!(buffer.read_partial_felt252(6, 9), 0xf362875d0def09d22c);
        assert_eq!(buffer.read_partial_felt252(29, 17), 0xb3964fc8a0b9c8a684b4b0c2436bee157b);
        assert_eq!(buffer.read_partial_felt252(21, 25), 0xf079ae34b785a21fb3964fc8a0b9c8a684b4b0c2436bee157b);
        assert_eq!(buffer.read_partial_felt252(3, 21), 0x52dc79f362875d0def09d22c270be93e6be0f079ae);
        assert_eq!(buffer.read_partial_felt252(17, 4), 0xe93e6be0);
        assert_eq!(buffer.read_u16_le(52), 0xab42);
        assert_eq!(buffer.read_partial_felt252(2, 5), 0xf252dc79f3);
        assert_eq!(buffer.read_partial_felt252(17, 3), 0xe93e6b);
        assert_eq!(buffer.read_partial_felt252(36, 21), 0xa684b4b0c2436bee157b60382716748e42ab37ca0d);
    }
    
    // Random access out of bounds reads

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u16_le() {
        let mut serialized_byte_array = array![0x0, 0xf364fa2ed6e10d03cee012e570c424cb8753a19e, 0x14].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u16_le(20);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u32_le() {
        let mut serialized_byte_array = array![0x0, 0x9753924bfe4e856cdf15133e77c8, 0xe].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u32_le(12);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u64_le() {
        let mut serialized_byte_array = array![0x0, 0x95f8ae8ad85ec36a311f0e7a432e00f42430480444f5eb0d, 0x18].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u64_le(22);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u256() {
        let mut serialized_byte_array = array![0x1, 0x0f11955497e293aec55d08e81e4b9e7091620ccca507a6665a8bf4826a4b8a, 0xedb956b9cbeacf53620fc2272eb931ff848efcf9fefb, 0x16].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u256(47);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_bytes31() {
        let mut serialized_byte_array = array![0x1, 0x4f41de3a93e80d7399ab5fce674a89f3d72c05a2f66ee966509e0f270037f6, 0xc919879811e3, 0x6].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_bytes31(34);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252() {
        let mut serialized_byte_array = array![0x1, 0x1c06167e74a6a3ddb26a582b4af3b5e21cf18333b03877d60c6a67ed661c3e, 0x3e9a67a525b87272228f279558af4f7d80ba37d90f93da16adc61a7707ac7b, 0x1f].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_felt252(39);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_1b() {
        let mut serialized_byte_array = array![0x0, 0xd626a767251ada587b63e18e, 0xc].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(12, 1);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_2b() {
        let mut serialized_byte_array = array![0x0, 0x44a06c05106bec3408bd5d51e584afa415ff77670c738be899f8, 0x1a].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(26, 2);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_3b() {
        let mut serialized_byte_array = array![0x0, 0xb8afb0a561, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(4, 3);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_4b() {
        let mut serialized_byte_array = array![0x0, 0x4ef44a2b9536139539c5ed9f6a7bf664a02c4afd473ab8782f988e1606, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(28, 4);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_5b() {
        let mut serialized_byte_array = array![0x0, 0x70367345bd4b6b2f244ee2, 0xb].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(7, 5);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_6b() {
        let mut serialized_byte_array = array![0x0, 0xa8971891ea74c4, 0x7].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(5, 6);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_7b() {
        let mut serialized_byte_array = array![0x0, 0x85aa0aca7e91a4992e6a15173e59d1874351a7b801db9226, 0x18].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(23, 7);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_8b() {
        let mut serialized_byte_array = array![0x1, 0x47336a50a95c0c94b2aa3e54482c7b6954300ca4a2bd465c1acb2b16a3b4b3, 0x5d7016da09, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(32, 8);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_9b() {
        let mut serialized_byte_array = array![0x1, 0x84b9c21714b22062e2d906f49645e6f44f034b44c6b08f679a635020967e6d, 0xab957f, 0x3].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(29, 9);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_10b() {
        let mut serialized_byte_array = array![0x0, 0xaf2f744d28748adf2e9452055141477d1b0d63c862596d50fb56a59703, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(23, 10);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_11b() {
        let mut serialized_byte_array = array![0x0, 0x2304a9cfdbb98fef07f5, 0xa].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(5, 11);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_12b() {
        let mut serialized_byte_array = array![0x0, 0xe57d8ebb0ca31439eae422fe, 0xc].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(8, 12);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_13b() {
        let mut serialized_byte_array = array![0x1, 0x684704736657a9d32c01195d35b9292ab68527ca42be5897a64a795bc399ed, 0xa5a73f3c4140b4cc36452b66, 0xc].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(38, 13);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_14b() {
        let mut serialized_byte_array = array![0x0, 0xe19a28b6e197a25490e8b87ae36d689bc0129446, 0x14].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(12, 14);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_15b() {
        let mut serialized_byte_array = array![0x1, 0x2cf5b3d47c82f3f445e4395ff9ce6482ee29b5a072416b58617b473b7c8511, 0xe32202e9df, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(32, 15);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_16b() {
        let mut serialized_byte_array = array![0x1, 0x4aa1776b4853b54bf563f436aec797a7d0d9cc0cbd8a0a5e0e6efc2d03ba7d, 0x7dc0baedc2bf53e63f, 0x9].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(37, 16);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_17b() {
        let mut serialized_byte_array = array![0x0, 0xfabebe40d54c30329bbacc1ea35888333edd3ab6d4e0f7dac5d28a, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(15, 17);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_18b() {
        let mut serialized_byte_array = array![0x0, 0xd3ebd88cf77410a217537f666f508bec36c36e873dc0513f9b3333cb, 0x1c].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(23, 18);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_19b() {
        let mut serialized_byte_array = array![0x1, 0xed66a584ab83411d0e813b6c9a0515e4f83c101d5ee846dfe35cbd1fa50574, 0xdd06d85ad10a759638c2ffe15068, 0xe].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(42, 19);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_20b() {
        let mut serialized_byte_array = array![0x1, 0x1614ba1ea43e23c7e50b2acc58f3cb52b2f1cdd6eca252c62127ed3eaaf0f1, 0xaf5368c11a8a8dab382140529488e2772a06c7, 0x13].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(48, 20);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_21b() {
        let mut serialized_byte_array = array![0x0, 0x9536230a47d4d8d639e2c850a0faff370e82bcc815fc1877319992563248, 0x1e].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(10, 21);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_22b() {
        let mut serialized_byte_array = array![0x0, 0x5d859408d59c8973c3d59f16871330a2c29d554d37a7de9c8294d611c963, 0x1e].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(10, 22);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_23b() {
        let mut serialized_byte_array = array![0x1, 0xe5edfa65a18cf3583e4b0aeaef8c8affaaf10c7e21166f6bbafed1a8130ef3, 0xaabecaa7757201fced42, 0xa].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(26, 23);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_24b() {
        let mut serialized_byte_array = array![0x0, 0xbb8625234af506f9d8276d33787178be30f4a64641d963e48e3b91114647b7, 0x1f].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(25, 24);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_25b() {
        let mut serialized_byte_array = array![0x0, 0xa22b088b08a510ff047b80d49de16b72923fe4bde86aa005, 0x18].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(13, 25);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_26b() {
        let mut serialized_byte_array = array![0x1, 0x92c17ac3f9e794f28bd3fac6cb2aa757f44bd3f474ac5b46f10f8064f35098, 0x18e880bf2268088c74d1dbca, 0xc].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(24, 26);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_27b() {
        let mut serialized_byte_array = array![0x1, 0xcd4428512273c5db6a0198a047a1573c0981f46e85a0b955d5eb3211cf436d, 0x1de6f91183e651fa07a43700bf50d0dde6, 0x11].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(33, 27);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_28b() {
        let mut serialized_byte_array = array![0x0, 0x98d073b50c2d5cd0edd962b513a0686d95e39bf357112fc885ef18, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(1, 28);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_29b() {
        let mut serialized_byte_array = array![0x0, 0xf6bb9894d92f3e8ed7d56fc107c3b732493503a09b6dafca8479ed45aca0, 0x1e].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(12, 29);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_30b() {
        let mut serialized_byte_array = array![0x1, 0xd8181f03b7f85793c5b1090d59ca912e397bab1c0339c4cdd1d9c662251e24, 0xb660ce81cc5bffa86ff6f6f4710fe41ec3e9a366a78da25079fa360139, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(34, 30);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_31b() {
        let mut serialized_byte_array = array![0x1, 0x4be3994ee087a7d517b0c116f8eaad9ed07e814360c536f378bac01383778f, 0x240e0104c5ab2126c313d33e8dae2388260c, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(38, 31);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_32b() {
        let mut serialized_byte_array = array![0x1, 0xce1f6399b6e81b45a7cfdcf3b2cc09edc61ae66b0bb9d268d9bd7e80a73492, 0xd55002e3f1dcd611e15442da, 0xc].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(34, 32);
    }

}
