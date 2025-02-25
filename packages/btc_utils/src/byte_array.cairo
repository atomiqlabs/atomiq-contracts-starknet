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


    fn read_u56_le(self: @ByteArray, index: usize) -> u64 {
        let result: felt252 = self.at(index+6).expect('Array index out of bounds').into() * 0x1000000000000
            + self.at(index+5).expect('Array index out of bounds').into() * 0x10000000000
            + self.at(index+4).expect('Array index out of bounds').into() * 0x100000000
            + self.at(index+3).expect('Array index out of bounds').into() * 0x1000000
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
