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


//All tests generated by scripts/tests_unit/byte_array.js
#[cfg(test)]
mod tests {
    use super::*;

    //Tests on random data, using all the available functions
    #[test]
    fn test_random() {
        // Random test cases testing all the functionality
        
        let mut serialized_byte_array = array![0x0, 0xcd89bb464e3c6db5295002ec28fba04e25461f5250ce08a76af4d3, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(5), 0x6d3c);
        assert_eq!(buffer.read_u32_le(8), 0xec025029);
        assert_eq!(buffer.read_u56_le(4), 0x025029b56d3c4e);
        assert_eq!(buffer.read_u64_le(5), 0x28ec025029b56d3c);
        assert_eq!(buffer.read_partial_felt252(25, 1), 0xf4);
        assert_eq!(buffer.read_partial_felt252(4, 2), 0x4e3c);
        assert_eq!(buffer.read_partial_felt252(11, 3), 0xec28fb);
        assert_eq!(buffer.read_partial_felt252(10, 4), 0x2ec28fb);
        assert_eq!(buffer.read_partial_felt252(15, 5), 0x4e25461f52);
        assert_eq!(buffer.read_partial_felt252(9, 6), 0x5002ec28fba0);
        assert_eq!(buffer.read_partial_felt252(19, 7), 0x5250ce08a76af4);
        assert_eq!(buffer.read_partial_felt252(13, 8), 0xfba04e25461f5250);
        assert_eq!(buffer.read_partial_felt252(3, 9), 0x464e3c6db5295002ec);
        assert_eq!(buffer.read_partial_felt252(4, 10), 0x4e3c6db5295002ec28fb);
        assert_eq!(buffer.read_partial_felt252(8, 11), 0x295002ec28fba04e25461f);
        assert_eq!(buffer.read_partial_felt252(2, 12), 0xbb464e3c6db5295002ec28fb);
        assert_eq!(buffer.read_partial_felt252(12, 13), 0x28fba04e25461f5250ce08a76a);
        assert_eq!(buffer.read_partial_felt252(12, 14), 0x28fba04e25461f5250ce08a76af4);
        assert_eq!(buffer.read_partial_felt252(4, 15), 0x4e3c6db5295002ec28fba04e25461f);
        assert_eq!(buffer.read_partial_felt252(5, 16), 0x3c6db5295002ec28fba04e25461f5250);
        assert_eq!(buffer.read_partial_felt252(8, 17), 0x295002ec28fba04e25461f5250ce08a76a);
        assert_eq!(buffer.read_partial_felt252(6, 18), 0x6db5295002ec28fba04e25461f5250ce08a7);
        assert_eq!(buffer.read_partial_felt252(1, 19), 0x89bb464e3c6db5295002ec28fba04e25461f52);
        assert_eq!(buffer.read_partial_felt252(2, 20), 0xbb464e3c6db5295002ec28fba04e25461f5250ce);
        assert_eq!(buffer.read_partial_felt252(3, 21), 0x464e3c6db5295002ec28fba04e25461f5250ce08a7);
        assert_eq!(buffer.read_partial_felt252(3, 22), 0x464e3c6db5295002ec28fba04e25461f5250ce08a76a);
        assert_eq!(buffer.read_partial_felt252(2, 23), 0xbb464e3c6db5295002ec28fba04e25461f5250ce08a76a);
        assert_eq!(buffer.read_partial_felt252(0, 24), 0xcd89bb464e3c6db5295002ec28fba04e25461f5250ce08a7);
        assert_eq!(buffer.read_partial_felt252(0, 25), 0xcd89bb464e3c6db5295002ec28fba04e25461f5250ce08a76a);
        assert_eq!(buffer.read_partial_felt252(0, 26), 0xcd89bb464e3c6db5295002ec28fba04e25461f5250ce08a76af4);
        assert_eq!(buffer.read_partial_felt252(0, 27), 0xcd89bb464e3c6db5295002ec28fba04e25461f5250ce08a76af4d3);
        assert_eq!(buffer.hash_sha256(), [0x32be7124, 0x715bfbd0, 0x14a10cf9, 0xebe8132a, 0x85069cae, 0x7eff3b71, 0x6739fee, 0x55c8c70e]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xd15b8cd5, 0xe800bd06, 0x9df866c2, 0x4e77d629, 0x249a6f5a, 0x96ed102c, 0x4a905dd, 0xd9b780bd]);
        assert_eq!(buffer.hash_poseidon_range(20, 21), 0x3436373bba770aa98e10c9dbca3de647cb41c6cf22f8a4f2dbe0296ebc4431d);
        assert_eq!(buffer.hash_poseidon_range(9, 24), 0x4172011b686cb0ae490b5a8c223b083c1111c616b14dfa9db4d41f860922d90);
        assert_eq!(buffer.hash_poseidon_range(10, 11), 0x20185e0ab367a55b068e0f8b7abda935f15b418737e7b67d84aaee133ec2572);
        assert_eq!(buffer.hash_poseidon_range(1, 4), 0xd28c8c477ae8a8996cc8b24ca25999bc0a9302a1664a9e2b546333cbfee145);
        assert_eq!(buffer.hash_poseidon_range(10, 19), 0x545fefaf29b18ca419adff8cefeb1ec9cd70b6e5a64d1dc9606215002550741);

        let mut serialized_byte_array = array![0x3, 0x036806f0a63cc20789a74608e6757c8d98924dc73ddc2d0757f0f2686fa046, 0x266c9aa22f6826888a005acd5eb6f2acb223b7810cbc6ec2f58858205f1732, 0xbe0fcec2e8d08aa79b6260c46469613b9f93fead93f4018f21394a0d18ccfc, 0x5d526b9500c9c44ccfb8ac, 0xb].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(36), 0x2668);
        assert_eq!(buffer.read_u32_le(86), 0xd4a3921);
        assert_eq!(buffer.read_u56_le(64), 0x9ba78ad0e8c2ce);
        assert_eq!(buffer.read_u64_le(17), 0x57072ddc3dc74d92);
        assert_eq!(buffer.read_u256(27), 0x686fa046266c9aa22f6826888a005acd5eb6f2acb223b7810cbc6ec2f5885820);
        assert_eq!(buffer.read_bytes31(41), 0x5acd5eb6f2acb223b7810cbc6ec2f58858205f1732be0fcec2e8d08aa79b62);
        assert_eq!(buffer.read_felt252(6), 0x20789a74608e4dd7c8d98924dc73ddc2d0757f0f2686fa046266c9aa22f680e);
        assert_eq!(buffer.read_partial_felt252(49, 1), 0xb7);
        assert_eq!(buffer.read_partial_felt252(74, 2), 0x6469);
        assert_eq!(buffer.read_partial_felt252(27, 3), 0x686fa0);
        assert_eq!(buffer.read_partial_felt252(72, 4), 0x60c46469);
        assert_eq!(buffer.read_partial_felt252(32, 5), 0x6c9aa22f68);
        assert_eq!(buffer.read_partial_felt252(20, 6), 0x3ddc2d0757f0);
        assert_eq!(buffer.read_partial_felt252(73, 7), 0xc46469613b9f93);
        assert_eq!(buffer.read_partial_felt252(47, 8), 0xb223b7810cbc6ec2);
        assert_eq!(buffer.read_partial_felt252(79, 9), 0x93fead93f4018f2139);
        assert_eq!(buffer.read_partial_felt252(33, 10), 0x9aa22f6826888a005acd);
        assert_eq!(buffer.read_partial_felt252(5, 11), 0x3cc20789a74608e6757c8d);
        assert_eq!(buffer.read_partial_felt252(26, 12), 0xf2686fa046266c9aa22f6826);
        assert_eq!(buffer.read_partial_felt252(25, 13), 0xf0f2686fa046266c9aa22f6826);
        assert_eq!(buffer.read_partial_felt252(83, 14), 0xf4018f21394a0d18ccfc5d526b95);
        assert_eq!(buffer.read_partial_felt252(15, 15), 0x8d98924dc73ddc2d0757f0f2686fa0);
        assert_eq!(buffer.read_partial_felt252(46, 16), 0xacb223b7810cbc6ec2f58858205f1732);
        assert_eq!(buffer.read_partial_felt252(58, 17), 0x205f1732be0fcec2e8d08aa79b6260c464);
        assert_eq!(buffer.read_partial_felt252(41, 18), 0x5acd5eb6f2acb223b7810cbc6ec2f5885820);
        assert_eq!(buffer.read_partial_felt252(34, 19), 0xa22f6826888a005acd5eb6f2acb223b7810cbc);
        assert_eq!(buffer.read_partial_felt252(76, 20), 0x613b9f93fead93f4018f21394a0d18ccfc5d526b);
        assert_eq!(buffer.read_partial_felt252(66, 21), 0xe8d08aa79b6260c46469613b9f93fead93f4018f21);
        assert_eq!(buffer.read_partial_felt252(8, 22), 0x89a74608e6757c8d98924dc73ddc2d0757f0f2686fa0);
        assert_eq!(buffer.read_partial_felt252(59, 23), 0x5f1732be0fcec2e8d08aa79b6260c46469613b9f93fead);
        assert_eq!(buffer.read_partial_felt252(0, 24), 0x36806f0a63cc20789a74608e6757c8d98924dc73ddc2d07);
        assert_eq!(buffer.read_partial_felt252(50, 25), 0x810cbc6ec2f58858205f1732be0fcec2e8d08aa79b6260c464);
        assert_eq!(buffer.read_partial_felt252(48, 26), 0x23b7810cbc6ec2f58858205f1732be0fcec2e8d08aa79b6260c4);
        assert_eq!(buffer.read_partial_felt252(34, 27), 0xa22f6826888a005acd5eb6f2acb223b7810cbc6ec2f58858205f17);
        assert_eq!(buffer.read_partial_felt252(46, 28), 0xacb223b7810cbc6ec2f58858205f1732be0fcec2e8d08aa79b6260c4);
        assert_eq!(buffer.read_partial_felt252(52, 29), 0xbc6ec2f58858205f1732be0fcec2e8d08aa79b6260c46469613b9f93fe);
        assert_eq!(buffer.read_partial_felt252(57, 30), 0x58205f1732be0fcec2e8d08aa79b6260c46469613b9f93fead93f4018f21);
        assert_eq!(buffer.read_partial_felt252(52, 31), 0xbc6ec2f58858205f1732be0fcec2e8d08aa79b6260c46469613b9f93fead93);
        assert_eq!(buffer.read_partial_felt252(58, 32), 0x5f1732be0fce7ee8d08aa79b6260c46469613b9f93fead93f4018f21394a09);
        assert_eq!(buffer.hash_sha256(), [0xaa8749b6, 0x8da92934, 0xfd417c2c, 0xc9cf146a, 0x6519a0e1, 0x768c263a, 0x5a635a9d, 0x3c97e077]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x84f01c5a, 0x8b716490, 0xf8b0ccb9, 0xa4561a18, 0xf26e0ab1, 0xf64c913e, 0x2af636ba, 0xf76e9298]);
        assert_eq!(buffer.hash_poseidon_range(38, 94), 0x73395a950cf988c6747e1717aa87e58169e1e6bee7ef46c440e5a3aabc34c9b);
        assert_eq!(buffer.hash_poseidon_range(3, 14), 0x4aa62e16bec5691ab9edf899767b0f021c3b9fc89ad6d41d9c6a964cecfee18);
        assert_eq!(buffer.hash_poseidon_range(16, 50), 0x55020a39034f2164922f8d65e70b26ac4471a29e0692afe926d549a9b1f1ae9);
        assert_eq!(buffer.hash_poseidon_range(58, 99), 0x3aea00cb62e0a741df5854d439bf049137cc5b21ada37f49f84a8148ad70dd7);
        assert_eq!(buffer.hash_poseidon_range(78, 99), 0x65550748fcd6e4ad9388695b2d4cc68d24091b550751f15d186e2fd3f741a29);

        let mut serialized_byte_array = array![0x3, 0x7f7c44030eee3d2d3ee60cfc9d8dbb61cda257eacb408aff395eb3d37f7fb7, 0x707580eba38772c5d756c9788accc82cb48ca26f989138a4044f241f8eafec, 0x8d3b7fc4299d784c94579f8bd3fabe218010c01176d5094b7458810ca98252, 0x5871, 0x2].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(80), 0x11c0);
        assert_eq!(buffer.read_u32_le(6), 0xe63e2d3d);
        assert_eq!(buffer.read_u56_le(84), 0xa90c8158744b09);
        assert_eq!(buffer.read_u64_le(85), 0x5282a90c8158744b);
        assert_eq!(buffer.read_u256(47), 0xb48ca26f989138a4044f241f8eafec8d3b7fc4299d784c94579f8bd3fabe2180);
        assert_eq!(buffer.read_bytes31(11), 0xfc9d8dbb61cda257eacb408aff395eb3d37f7fb7707580eba38772c5d756c9);
        assert_eq!(buffer.read_felt252(4), 0x6ee3d2d3ee60ceb9d8dbb61cda257eacb408aff395eb3d37f7fb7707580eba2);
        assert_eq!(buffer.read_partial_felt252(84, 1), 0x9);
        assert_eq!(buffer.read_partial_felt252(92, 2), 0x5258);
        assert_eq!(buffer.read_partial_felt252(65, 3), 0xc4299d);
        assert_eq!(buffer.read_partial_felt252(36, 4), 0x8772c5d7);
        assert_eq!(buffer.read_partial_felt252(68, 5), 0x784c94579f);
        assert_eq!(buffer.read_partial_felt252(48, 6), 0x8ca26f989138);
        assert_eq!(buffer.read_partial_felt252(53, 7), 0x38a4044f241f8e);
        assert_eq!(buffer.read_partial_felt252(85, 8), 0x4b7458810ca98252);
        assert_eq!(buffer.read_partial_felt252(68, 9), 0x784c94579f8bd3fabe);
        assert_eq!(buffer.read_partial_felt252(78, 10), 0x8010c01176d5094b7458);
        assert_eq!(buffer.read_partial_felt252(31, 11), 0x707580eba38772c5d756c9);
        assert_eq!(buffer.read_partial_felt252(78, 12), 0x8010c01176d5094b7458810c);
        assert_eq!(buffer.read_partial_felt252(1, 13), 0x7c44030eee3d2d3ee60cfc9d8d);
        assert_eq!(buffer.read_partial_felt252(8, 14), 0x3ee60cfc9d8dbb61cda257eacb40);
        assert_eq!(buffer.read_partial_felt252(64, 15), 0x7fc4299d784c94579f8bd3fabe2180);
        assert_eq!(buffer.read_partial_felt252(44, 16), 0xccc82cb48ca26f989138a4044f241f8e);
        assert_eq!(buffer.read_partial_felt252(8, 17), 0x3ee60cfc9d8dbb61cda257eacb408aff39);
        assert_eq!(buffer.read_partial_felt252(16, 18), 0xcda257eacb408aff395eb3d37f7fb7707580);
        assert_eq!(buffer.read_partial_felt252(1, 19), 0x7c44030eee3d2d3ee60cfc9d8dbb61cda257ea);
        assert_eq!(buffer.read_partial_felt252(4, 20), 0xeee3d2d3ee60cfc9d8dbb61cda257eacb408aff);
        assert_eq!(buffer.read_partial_felt252(5, 21), 0xee3d2d3ee60cfc9d8dbb61cda257eacb408aff395e);
        assert_eq!(buffer.read_partial_felt252(12, 22), 0x9d8dbb61cda257eacb408aff395eb3d37f7fb7707580);
        assert_eq!(buffer.read_partial_felt252(60, 23), 0xafec8d3b7fc4299d784c94579f8bd3fabe218010c01176);
        assert_eq!(buffer.read_partial_felt252(26, 24), 0xb3d37f7fb7707580eba38772c5d756c9788accc82cb48ca2);
        assert_eq!(buffer.read_partial_felt252(14, 25), 0xbb61cda257eacb408aff395eb3d37f7fb7707580eba38772c5);
        assert_eq!(buffer.read_partial_felt252(49, 26), 0xa26f989138a4044f241f8eafec8d3b7fc4299d784c94579f8bd3);
        assert_eq!(buffer.read_partial_felt252(54, 27), 0xa4044f241f8eafec8d3b7fc4299d784c94579f8bd3fabe218010c0);
        assert_eq!(buffer.read_partial_felt252(15, 28), 0x61cda257eacb408aff395eb3d37f7fb7707580eba38772c5d756c978);
        assert_eq!(buffer.read_partial_felt252(24, 29), 0x395eb3d37f7fb7707580eba38772c5d756c9788accc82cb48ca26f9891);
        assert_eq!(buffer.read_partial_felt252(34, 30), 0xeba38772c5d756c9788accc82cb48ca26f989138a4044f241f8eafec8d3b);
        assert_eq!(buffer.read_partial_felt252(1, 31), 0x7c44030eee3d2d3ee60cfc9d8dbb61cda257eacb408aff395eb3d37f7fb770);
        assert_eq!(buffer.read_partial_felt252(10, 32), 0x4fc9d8dbb61cd9157eacb408aff395eb3d37f7fb7707580eba38772c5d756c8);
        assert_eq!(buffer.hash_sha256(), [0x7a7c83bf, 0x2bfcf15, 0x612ac29d, 0x111b4f69, 0x15fce7e0, 0x34d90140, 0x9de314, 0xadaeeb4b]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xe292d8b1, 0xee3677, 0x612dc26b, 0xe3343e06, 0xe52a03b5, 0x33d18536, 0xd0b62ae0, 0x8577b31d]);
        assert_eq!(buffer.hash_poseidon_range(25, 82), 0x29f2622c14b862793f17e7889d2b46ca50694ad9c9416213dc38f95102bf96b);
        assert_eq!(buffer.hash_poseidon_range(7, 75), 0x2b5d6f98cc78691181ed752a96f032a04ecf71c1a07b73420b44836a4462fc8);
        assert_eq!(buffer.hash_poseidon_range(76, 85), 0x6403e3042072b802b4faf906d11968e1a9feaabd4b4d6ca7cfe11ccebb3bf83);
        assert_eq!(buffer.hash_poseidon_range(0, 71), 0x41ade0896fa241c9e4b2274a4b0c7006321fff21e0cdf92fc2910c0f6bdd061);
        assert_eq!(buffer.hash_poseidon_range(61, 82), 0x62f75b93921337333f088e0b84ef7ad30cb823dec9cc2851597432b5d250a60);

        let mut serialized_byte_array = array![0x3, 0x8f5c33601784aa63c1f91896e2ccdf2ae4612d77d3dc5425f5ea7de9deff08, 0x782c1d4bb1ed9e32e51952639470a308855b063d1d46a6db7b7c25e8c76f51, 0x2c253fef3b9566b954fe57dc585f89b6c5c648044625f233651aa46a6a18de, 0x882130683947ec1fef757fb3307c9d782f7271f91f9cdc64389c1d85ac, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(45), 0x8a3);
        assert_eq!(buffer.read_u32_le(13), 0xe42adfcc);
        assert_eq!(buffer.read_u56_le(15), 0xdcd3772d61e42a);
        assert_eq!(buffer.read_u64_le(33), 0x19e5329eedb14b1d);
        assert_eq!(buffer.read_u256(47), 0x855b063d1d46a6db7b7c25e8c76f512c253fef3b9566b954fe57dc585f89b6c5);
        assert_eq!(buffer.read_bytes31(22), 0x5425f5ea7de9deff08782c1d4bb1ed9e32e51952639470a308855b063d1d46);
        assert_eq!(buffer.read_felt252(70), 0x4fe57dc585f890cc5c648044625f233651aa46a6a18de882130683947ec1fe5);
        assert_eq!(buffer.read_partial_felt252(10, 1), 0x18);
        assert_eq!(buffer.read_partial_felt252(34, 2), 0x4bb1);
        assert_eq!(buffer.read_partial_felt252(51, 3), 0x1d46a6);
        assert_eq!(buffer.read_partial_felt252(104, 4), 0xb3307c9d);
        assert_eq!(buffer.read_partial_felt252(60, 5), 0x6f512c253f);
        assert_eq!(buffer.read_partial_felt252(79, 6), 0xc648044625f2);
        assert_eq!(buffer.read_partial_felt252(114, 7), 0x9cdc64389c1d85);
        assert_eq!(buffer.read_partial_felt252(82, 8), 0x4625f233651aa46a);
        assert_eq!(buffer.read_partial_felt252(23, 9), 0x25f5ea7de9deff0878);
        assert_eq!(buffer.read_partial_felt252(106, 10), 0x7c9d782f7271f91f9cdc);
        assert_eq!(buffer.read_partial_felt252(93, 11), 0x882130683947ec1fef757f);
        assert_eq!(buffer.read_partial_felt252(41, 12), 0x52639470a308855b063d1d46);
        assert_eq!(buffer.read_partial_felt252(20, 13), 0xd3dc5425f5ea7de9deff08782c);
        assert_eq!(buffer.read_partial_felt252(92, 14), 0xde882130683947ec1fef757fb330);
        assert_eq!(buffer.read_partial_felt252(7, 15), 0x63c1f91896e2ccdf2ae4612d77d3dc);
        assert_eq!(buffer.read_partial_felt252(94, 16), 0x2130683947ec1fef757fb3307c9d782f);
        assert_eq!(buffer.read_partial_felt252(65, 17), 0xef3b9566b954fe57dc585f89b6c5c64804);
        assert_eq!(buffer.read_partial_felt252(63, 18), 0x253fef3b9566b954fe57dc585f89b6c5c648);
        assert_eq!(buffer.read_partial_felt252(7, 19), 0x63c1f91896e2ccdf2ae4612d77d3dc5425f5ea);
        assert_eq!(buffer.read_partial_felt252(1, 20), 0x5c33601784aa63c1f91896e2ccdf2ae4612d77d3);
        assert_eq!(buffer.read_partial_felt252(91, 21), 0x18de882130683947ec1fef757fb3307c9d782f7271);
        assert_eq!(buffer.read_partial_felt252(86, 22), 0x651aa46a6a18de882130683947ec1fef757fb3307c9d);
        assert_eq!(buffer.read_partial_felt252(59, 23), 0xc76f512c253fef3b9566b954fe57dc585f89b6c5c64804);
        assert_eq!(buffer.read_partial_felt252(70, 24), 0x54fe57dc585f89b6c5c648044625f233651aa46a6a18de88);
        assert_eq!(buffer.read_partial_felt252(87, 25), 0x1aa46a6a18de882130683947ec1fef757fb3307c9d782f7271);
        assert_eq!(buffer.read_partial_felt252(40, 26), 0x1952639470a308855b063d1d46a6db7b7c25e8c76f512c253fef);
        assert_eq!(buffer.read_partial_felt252(52, 27), 0x46a6db7b7c25e8c76f512c253fef3b9566b954fe57dc585f89b6c5);
        assert_eq!(buffer.read_partial_felt252(51, 28), 0x1d46a6db7b7c25e8c76f512c253fef3b9566b954fe57dc585f89b6c5);
        assert_eq!(buffer.read_partial_felt252(84, 29), 0xf233651aa46a6a18de882130683947ec1fef757fb3307c9d782f7271f9);
        assert_eq!(buffer.read_partial_felt252(76, 30), 0x89b6c5c648044625f233651aa46a6a18de882130683947ec1fef757fb330);
        assert_eq!(buffer.read_partial_felt252(13, 31), 0xccdf2ae4612d77d3dc5425f5ea7de9deff08782c1d4bb1ed9e32e519526394);
        assert_eq!(buffer.read_partial_felt252(28, 32), 0x6ff08782c1d49e6ed9e32e51952639470a308855b063d1d46a6db7b7c25e8ac);
        assert_eq!(buffer.hash_sha256(), [0x7e19b9c8, 0x667a368b, 0x5f01a7cd, 0xd668a148, 0x2c5287c8, 0x21ac822b, 0x654c4885, 0x9bc501e3]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xc2e93972, 0xf56a8a6, 0xfdf97877, 0x815b2005, 0xe7c2a01f, 0xc95e6a6a, 0x6a77bdb5, 0xfd1e7d99]);
        assert_eq!(buffer.hash_poseidon_range(77, 87), 0x7271e9f7e237c11752dcf5f4cf563b12c12feedfed89ac8f3329e9ef00f7468);
        assert_eq!(buffer.hash_poseidon_range(62, 76), 0x25c341fefe64ea85a04f432afd8747276decd24256174c86214e0b15fb6d790);
        assert_eq!(buffer.hash_poseidon_range(52, 107), 0x6b7bb1de32c9f93eff6723f473c2a40b8e05fc472a0ef5bae0cb68a6bb26487);
        assert_eq!(buffer.hash_poseidon_range(51, 112), 0x3994a721142e6fd47861cc327136a552a9b4b30bf9d36ad4b21ed9aeec07c8b);
        assert_eq!(buffer.hash_poseidon_range(119, 119), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);

        let mut serialized_byte_array = array![0x2, 0xe28da79b61870c536efbe558282e7b6f1a507dd53c8f620d43e1cc43bb25fd, 0xc81f189ea487b70d0d6fa0ec4a5bd367797042145afc8feb05f922a246904e, 0x1f4d58fda0, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(40), 0xa06f);
        assert_eq!(buffer.read_u32_le(13), 0x1a6f7b2e);
        assert_eq!(buffer.read_u56_le(18), 0x430d628f3cd57d);
        assert_eq!(buffer.read_u64_le(11), 0x7d501a6f7b2e2858);
        assert_eq!(buffer.read_u256(14), 0x7b6f1a507dd53c8f620d43e1cc43bb25fdc81f189ea487b70d0d6fa0ec4a5bd3);
        assert_eq!(buffer.read_bytes31(34), 0x9ea487b70d0d6fa0ec4a5bd367797042145afc8feb05f922a246904e1f4d58);
        assert_eq!(buffer.read_felt252(23), 0x543e1cc43bb25ecc81f189ea487b70d0d6fa0ec4a5bd367797042145afc8fea);
        assert_eq!(buffer.read_partial_felt252(31, 1), 0xc8);
        assert_eq!(buffer.read_partial_felt252(1, 2), 0x8da7);
        assert_eq!(buffer.read_partial_felt252(18, 3), 0x7dd53c);
        assert_eq!(buffer.read_partial_felt252(36, 4), 0x87b70d0d);
        assert_eq!(buffer.read_partial_felt252(30, 5), 0xfdc81f189e);
        assert_eq!(buffer.read_partial_felt252(18, 6), 0x7dd53c8f620d);
        assert_eq!(buffer.read_partial_felt252(52, 7), 0xfc8feb05f922a2);
        assert_eq!(buffer.read_partial_felt252(20, 8), 0x3c8f620d43e1cc43);
        assert_eq!(buffer.read_partial_felt252(35, 9), 0xa487b70d0d6fa0ec4a);
        assert_eq!(buffer.read_partial_felt252(52, 10), 0xfc8feb05f922a246904e);
        assert_eq!(buffer.read_partial_felt252(6, 11), 0xc536efbe558282e7b6f1a);
        assert_eq!(buffer.read_partial_felt252(41, 12), 0xa0ec4a5bd367797042145afc);
        assert_eq!(buffer.read_partial_felt252(6, 13), 0xc536efbe558282e7b6f1a507d);
        assert_eq!(buffer.read_partial_felt252(49, 14), 0x42145afc8feb05f922a246904e1f);
        assert_eq!(buffer.read_partial_felt252(35, 15), 0xa487b70d0d6fa0ec4a5bd367797042);
        assert_eq!(buffer.read_partial_felt252(42, 16), 0xec4a5bd367797042145afc8feb05f922);
        assert_eq!(buffer.read_partial_felt252(18, 17), 0x7dd53c8f620d43e1cc43bb25fdc81f189e);
        assert_eq!(buffer.read_partial_felt252(14, 18), 0x7b6f1a507dd53c8f620d43e1cc43bb25fdc8);
        assert_eq!(buffer.read_partial_felt252(47, 19), 0x797042145afc8feb05f922a246904e1f4d58fd);
        assert_eq!(buffer.read_partial_felt252(4, 20), 0x61870c536efbe558282e7b6f1a507dd53c8f620d);
        assert_eq!(buffer.read_partial_felt252(36, 21), 0x87b70d0d6fa0ec4a5bd367797042145afc8feb05f9);
        assert_eq!(buffer.read_partial_felt252(20, 22), 0x3c8f620d43e1cc43bb25fdc81f189ea487b70d0d6fa0);
        assert_eq!(buffer.read_partial_felt252(20, 23), 0x3c8f620d43e1cc43bb25fdc81f189ea487b70d0d6fa0ec);
        assert_eq!(buffer.read_partial_felt252(41, 24), 0xa0ec4a5bd367797042145afc8feb05f922a246904e1f4d58);
        assert_eq!(buffer.read_partial_felt252(1, 25), 0x8da79b61870c536efbe558282e7b6f1a507dd53c8f620d43e1);
        assert_eq!(buffer.read_partial_felt252(29, 26), 0x25fdc81f189ea487b70d0d6fa0ec4a5bd367797042145afc8feb);
        assert_eq!(buffer.read_partial_felt252(37, 27), 0xb70d0d6fa0ec4a5bd367797042145afc8feb05f922a246904e1f4d);
        assert_eq!(buffer.read_partial_felt252(2, 28), 0xa79b61870c536efbe558282e7b6f1a507dd53c8f620d43e1cc43bb25);
        assert_eq!(buffer.read_partial_felt252(30, 29), 0xfdc81f189ea487b70d0d6fa0ec4a5bd367797042145afc8feb05f922a2);
        assert_eq!(buffer.read_partial_felt252(33, 30), 0x189ea487b70d0d6fa0ec4a5bd367797042145afc8feb05f922a246904e1f);
        assert_eq!(buffer.read_partial_felt252(12, 31), 0x282e7b6f1a507dd53c8f620d43e1cc43bb25fdc81f189ea487b70d0d6fa0ec);
        assert_eq!(buffer.read_partial_felt252(17, 32), 0x7dd53c8f620c99e1cc43bb25fdc81f189ea487b70d0d6fa0ec4a5bd3677966);
        assert_eq!(buffer.hash_sha256(), [0x7696070f, 0xfbfd5a8, 0x939177ba, 0x2ea48258, 0xfcf73504, 0xaec3038b, 0x5402e762, 0xc2cbfbb9]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xf904e0e, 0x17595583, 0x17a101e1, 0x966a63f0, 0x2e4b0ff8, 0x999a082a, 0xd36f2b68, 0x799f16db]);
        assert_eq!(buffer.hash_poseidon_range(11, 54), 0x1a1f19ef9db4022e8c05d270b1ea2853f6e2b6a4d071a2ded470fd7a00cb4d4);
        assert_eq!(buffer.hash_poseidon_range(32, 62), 0x29f17031623a95980c760fc6303c41847eb56e2515afd027fe5b8206815d84d);
        assert_eq!(buffer.hash_poseidon_range(36, 42), 0x2c8bcd0a7ac486c85cb6b47e0ff84933fac151ef82a0082bc0c9095aa9fc23b);
        assert_eq!(buffer.hash_poseidon_range(48, 64), 0x3ea79969bd9abbd166d32e7300b38857817ead43f87705678e3e92833203ddb);
        assert_eq!(buffer.hash_poseidon_range(19, 44), 0x1f83c98e824c18bbf7665ca334bd5ca03399c3d8ddf87dd37e7e35baefe600d);

        let mut serialized_byte_array = array![0x0, 0xd8fcfd58f6dbdb1649dba3b63baa1c4e24691b1c4e200c1f5c82f57e6063, 0x1e].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(11), 0x3bb6);
        assert_eq!(buffer.read_u32_le(4), 0x16dbdbf6);
        assert_eq!(buffer.read_u56_le(13), 0x1c1b69244e1caa);
        assert_eq!(buffer.read_u64_le(7), 0x1caa3bb6a3db4916);
        assert_eq!(buffer.read_partial_felt252(9, 1), 0xdb);
        assert_eq!(buffer.read_partial_felt252(10, 2), 0xa3b6);
        assert_eq!(buffer.read_partial_felt252(16, 3), 0x24691b);
        assert_eq!(buffer.read_partial_felt252(21, 4), 0x200c1f5c);
        assert_eq!(buffer.read_partial_felt252(24, 5), 0x5c82f57e60);
        assert_eq!(buffer.read_partial_felt252(9, 6), 0xdba3b63baa1c);
        assert_eq!(buffer.read_partial_felt252(13, 7), 0xaa1c4e24691b1c);
        assert_eq!(buffer.read_partial_felt252(0, 8), 0xd8fcfd58f6dbdb16);
        assert_eq!(buffer.read_partial_felt252(1, 9), 0xfcfd58f6dbdb1649db);
        assert_eq!(buffer.read_partial_felt252(17, 10), 0x691b1c4e200c1f5c82f5);
        assert_eq!(buffer.read_partial_felt252(0, 11), 0xd8fcfd58f6dbdb1649dba3);
        assert_eq!(buffer.read_partial_felt252(5, 12), 0xdbdb1649dba3b63baa1c4e24);
        assert_eq!(buffer.read_partial_felt252(2, 13), 0xfd58f6dbdb1649dba3b63baa1c);
        assert_eq!(buffer.read_partial_felt252(12, 14), 0x3baa1c4e24691b1c4e200c1f5c82);
        assert_eq!(buffer.read_partial_felt252(8, 15), 0x49dba3b63baa1c4e24691b1c4e200c);
        assert_eq!(buffer.read_partial_felt252(12, 16), 0x3baa1c4e24691b1c4e200c1f5c82f57e);
        assert_eq!(buffer.read_partial_felt252(4, 17), 0xf6dbdb1649dba3b63baa1c4e24691b1c4e);
        assert_eq!(buffer.read_partial_felt252(1, 18), 0xfcfd58f6dbdb1649dba3b63baa1c4e24691b);
        assert_eq!(buffer.read_partial_felt252(7, 19), 0x1649dba3b63baa1c4e24691b1c4e200c1f5c82);
        assert_eq!(buffer.read_partial_felt252(0, 20), 0xd8fcfd58f6dbdb1649dba3b63baa1c4e24691b1c);
        assert_eq!(buffer.read_partial_felt252(3, 21), 0x58f6dbdb1649dba3b63baa1c4e24691b1c4e200c1f);
        assert_eq!(buffer.read_partial_felt252(7, 22), 0x1649dba3b63baa1c4e24691b1c4e200c1f5c82f57e60);
        assert_eq!(buffer.read_partial_felt252(6, 23), 0xdb1649dba3b63baa1c4e24691b1c4e200c1f5c82f57e60);
        assert_eq!(buffer.read_partial_felt252(4, 24), 0xf6dbdb1649dba3b63baa1c4e24691b1c4e200c1f5c82f57e);
        assert_eq!(buffer.read_partial_felt252(2, 25), 0xfd58f6dbdb1649dba3b63baa1c4e24691b1c4e200c1f5c82f5);
        assert_eq!(buffer.read_partial_felt252(0, 26), 0xd8fcfd58f6dbdb1649dba3b63baa1c4e24691b1c4e200c1f5c82);
        assert_eq!(buffer.read_partial_felt252(2, 27), 0xfd58f6dbdb1649dba3b63baa1c4e24691b1c4e200c1f5c82f57e60);
        assert_eq!(buffer.read_partial_felt252(0, 28), 0xd8fcfd58f6dbdb1649dba3b63baa1c4e24691b1c4e200c1f5c82f57e);
        assert_eq!(buffer.read_partial_felt252(0, 29), 0xd8fcfd58f6dbdb1649dba3b63baa1c4e24691b1c4e200c1f5c82f57e60);
        assert_eq!(buffer.read_partial_felt252(0, 30), 0xd8fcfd58f6dbdb1649dba3b63baa1c4e24691b1c4e200c1f5c82f57e6063);
        assert_eq!(buffer.hash_sha256(), [0x2a59a258, 0xfc7ebe26, 0xe9ff426f, 0x6fb47ad9, 0x566e0fbb, 0x723fb1fa, 0xf806e2b, 0x3d80aed0]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x9d2b70b4, 0x7c8a25a5, 0x74f65bb0, 0x1582bdfd, 0x6402e758, 0xd00218f7, 0x280aab83, 0x56c8450d]);
        assert_eq!(buffer.hash_poseidon_range(14, 16), 0x28279976c4045749f33ca44a9c4b7b621812e9fda86dae176ebc9a4659fb1cb);
        assert_eq!(buffer.hash_poseidon_range(23, 25), 0x3b3f7402890bab684dda7ff6730781dd4f984b93a9b4545844260cc7a98e6a3);
        assert_eq!(buffer.hash_poseidon_range(11, 14), 0x61934e2f77af089c91313bf63e0f71b37fda0724bb4a2386ae3c651a40fb5a6);
        assert_eq!(buffer.hash_poseidon_range(0, 1), 0x143fbf5c63db2892fc3408878fe42fafead6b76393b4b725a2981695735eb23);
        assert_eq!(buffer.hash_poseidon_range(13, 27), 0x141d43b81bc0d806c816f89ca3d87a6ac24a698ee914b76b50f0800a695588d);

        let mut serialized_byte_array = array![0x2, 0x53f2ea9fc4e045acb46000fe30bc0fe80bd83fc949b6c8f6af94237080cc0e, 0xfaa417f88ee9c3f4f3c4b6f3ab693af3ccc42b24ce0b618702ecfc15dd47b7, 0x39156bb6fd9b01789ed132604f37, 0xe].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(6), 0xac45);
        assert_eq!(buffer.read_u32_le(4), 0xac45e0c4);
        assert_eq!(buffer.read_u56_le(7), 0xbc30fe0060b4ac);
        assert_eq!(buffer.read_u64_le(11), 0x3fd80be80fbc30fe);
        assert_eq!(buffer.read_u256(29), 0xcc0efaa417f88ee9c3f4f3c4b6f3ab693af3ccc42b24ce0b618702ecfc15dd47);
        assert_eq!(buffer.read_bytes31(5), 0xe045acb46000fe30bc0fe80bd83fc949b6c8f6af94237080cc0efaa417f88e);
        assert_eq!(buffer.read_felt252(28), 0xcc0efaa417f77ee9c3f4f3c4b6f3ab693af3ccc42b24ce0b618702ecfc15cd);
        assert_eq!(buffer.read_partial_felt252(48, 1), 0xc4);
        assert_eq!(buffer.read_partial_felt252(38, 2), 0xf4f3);
        assert_eq!(buffer.read_partial_felt252(50, 3), 0x24ce0b);
        assert_eq!(buffer.read_partial_felt252(48, 4), 0xc42b24ce);
        assert_eq!(buffer.read_partial_felt252(33, 5), 0x17f88ee9c3);
        assert_eq!(buffer.read_partial_felt252(29, 6), 0xcc0efaa417f8);
        assert_eq!(buffer.read_partial_felt252(61, 7), 0xb739156bb6fd9b);
        assert_eq!(buffer.read_partial_felt252(34, 8), 0xf88ee9c3f4f3c4b6);
        assert_eq!(buffer.read_partial_felt252(9, 9), 0x6000fe30bc0fe80bd8);
        assert_eq!(buffer.read_partial_felt252(64, 10), 0x6bb6fd9b01789ed13260);
        assert_eq!(buffer.read_partial_felt252(42, 11), 0xf3ab693af3ccc42b24ce0b);
        assert_eq!(buffer.read_partial_felt252(9, 12), 0x6000fe30bc0fe80bd83fc949);
        assert_eq!(buffer.read_partial_felt252(58, 13), 0x15dd47b739156bb6fd9b01789e);
        assert_eq!(buffer.read_partial_felt252(47, 14), 0xccc42b24ce0b618702ecfc15dd47);
        assert_eq!(buffer.read_partial_felt252(7, 15), 0xacb46000fe30bc0fe80bd83fc949b6);
        assert_eq!(buffer.read_partial_felt252(17, 16), 0xd83fc949b6c8f6af94237080cc0efaa4);
        assert_eq!(buffer.read_partial_felt252(2, 17), 0xea9fc4e045acb46000fe30bc0fe80bd83f);
        assert_eq!(buffer.read_partial_felt252(21, 18), 0xb6c8f6af94237080cc0efaa417f88ee9c3f4);
        assert_eq!(buffer.read_partial_felt252(35, 19), 0x8ee9c3f4f3c4b6f3ab693af3ccc42b24ce0b61);
        assert_eq!(buffer.read_partial_felt252(1, 20), 0xf2ea9fc4e045acb46000fe30bc0fe80bd83fc949);
        assert_eq!(buffer.read_partial_felt252(5, 21), 0xe045acb46000fe30bc0fe80bd83fc949b6c8f6af94);
        assert_eq!(buffer.read_partial_felt252(48, 22), 0xc42b24ce0b618702ecfc15dd47b739156bb6fd9b0178);
        assert_eq!(buffer.read_partial_felt252(22, 23), 0xc8f6af94237080cc0efaa417f88ee9c3f4f3c4b6f3ab69);
        assert_eq!(buffer.read_partial_felt252(29, 24), 0xcc0efaa417f88ee9c3f4f3c4b6f3ab693af3ccc42b24ce0b);
        assert_eq!(buffer.read_partial_felt252(43, 25), 0xab693af3ccc42b24ce0b618702ecfc15dd47b739156bb6fd9b);
        assert_eq!(buffer.read_partial_felt252(32, 26), 0xa417f88ee9c3f4f3c4b6f3ab693af3ccc42b24ce0b618702ecfc);
        assert_eq!(buffer.read_partial_felt252(0, 27), 0x53f2ea9fc4e045acb46000fe30bc0fe80bd83fc949b6c8f6af9423);
        assert_eq!(buffer.read_partial_felt252(9, 28), 0x6000fe30bc0fe80bd83fc949b6c8f6af94237080cc0efaa417f88ee9);
        assert_eq!(buffer.read_partial_felt252(8, 29), 0xb46000fe30bc0fe80bd83fc949b6c8f6af94237080cc0efaa417f88ee9);
        assert_eq!(buffer.read_partial_felt252(26, 30), 0x237080cc0efaa417f88ee9c3f4f3c4b6f3ab693af3ccc42b24ce0b618702);
        assert_eq!(buffer.read_partial_felt252(36, 31), 0xe9c3f4f3c4b6f3ab693af3ccc42b24ce0b618702ecfc15dd47b739156bb6fd);
        assert_eq!(buffer.read_partial_felt252(14, 32), 0x7e80bd83fc949a5c8f6af94237080cc0efaa417f88ee9c3f4f3c4b6f3ab6939);
        assert_eq!(buffer.hash_sha256(), [0xf5f068f6, 0x787432d3, 0xeacb5bd3, 0x21c3b91b, 0x58487f2b, 0xf40671c3, 0xc6d169b1, 0x92160643]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xf97857c2, 0xde902a58, 0xe4095936, 0xe2e8a886, 0xb070fe61, 0x88f9e3d3, 0xbe76b8f9, 0xc57415a6]);
        assert_eq!(buffer.hash_poseidon_range(36, 59), 0x5c346dcd7f27c8a6aff74e5519a876f56f6622a33f657e95b08a59bf0d14bc1);
        assert_eq!(buffer.hash_poseidon_range(25, 30), 0x232523c99b8808f0a5179f73556d965e145f82ca52420b4f25e7c9406e2715c);
        assert_eq!(buffer.hash_poseidon_range(7, 73), 0x2e0a449e8ffc4352d27b3561e628b7cfc33b285fee8e12e1cf1da4299bfe992);
        assert_eq!(buffer.hash_poseidon_range(56, 60), 0x28c4a735a0b9fbdb0869387e86104c35d9bcc73aeb155472d6caa63beb857ee);
        assert_eq!(buffer.hash_poseidon_range(25, 71), 0x5e4899696ee05e32706780eeffa4cf003d77a9f50a3011134e9376d852d3a4c);

        let mut serialized_byte_array = array![0x3, 0x209b4fd6d2f910fb9ec35cdc79919971cea845f8515ee146bb3a5b33bbace0, 0xf5b128a5516ea4de2d235b7f43f895c729fb06663b00419b6b69ae114c1f6f, 0x83ddd24888586ea85cdd9b150ac4223f6c07049e25e5afa1b89dbff3b15323, 0xfe5323b241e492d51847814a0b651750206e5c39, 0x14].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(44), 0x95f8);
        assert_eq!(buffer.read_u32_le(54), 0xae696b9b);
        assert_eq!(buffer.read_u56_le(10), 0xce71999179dc5c);
        assert_eq!(buffer.read_u64_le(17), 0xbb46e15e51f845a8);
        assert_eq!(buffer.read_u256(41), 0x5b7f43f895c729fb06663b00419b6b69ae114c1f6f83ddd24888586ea85cdd9b);
        assert_eq!(buffer.read_bytes31(22), 0xe146bb3a5b33bbace0f5b128a5516ea4de2d235b7f43f895c729fb06663b00);
        assert_eq!(buffer.read_felt252(49), 0x6663b00419b6b69ae114c1f6f83ddd24888586ea85cdd9b150ac4223f6c0704);
        assert_eq!(buffer.read_partial_felt252(73, 1), 0x15);
        assert_eq!(buffer.read_partial_felt252(104, 2), 0x4a0b);
        assert_eq!(buffer.read_partial_felt252(48, 3), 0xfb0666);
        assert_eq!(buffer.read_partial_felt252(20, 4), 0x515ee146);
        assert_eq!(buffer.read_partial_felt252(53, 5), 0x419b6b69ae);
        assert_eq!(buffer.read_partial_felt252(98, 6), 0xe492d5184781);
        assert_eq!(buffer.read_partial_felt252(38, 7), 0xde2d235b7f43f8);
        assert_eq!(buffer.read_partial_felt252(104, 8), 0x4a0b651750206e5c);
        assert_eq!(buffer.read_partial_felt252(72, 9), 0x9b150ac4223f6c0704);
        assert_eq!(buffer.read_partial_felt252(72, 10), 0x9b150ac4223f6c07049e);
        assert_eq!(buffer.read_partial_felt252(100, 11), 0xd51847814a0b651750206e);
        assert_eq!(buffer.read_partial_felt252(55, 12), 0x6b69ae114c1f6f83ddd24888);
        assert_eq!(buffer.read_partial_felt252(36, 13), 0x6ea4de2d235b7f43f895c729fb);
        assert_eq!(buffer.read_partial_felt252(50, 14), 0x663b00419b6b69ae114c1f6f83dd);
        assert_eq!(buffer.read_partial_felt252(7, 15), 0xfb9ec35cdc79919971cea845f8515e);
        assert_eq!(buffer.read_partial_felt252(45, 16), 0x95c729fb06663b00419b6b69ae114c1f);
        assert_eq!(buffer.read_partial_felt252(33, 17), 0x28a5516ea4de2d235b7f43f895c729fb06);
        assert_eq!(buffer.read_partial_felt252(30, 18), 0xe0f5b128a5516ea4de2d235b7f43f895c729);
        assert_eq!(buffer.read_partial_felt252(65, 19), 0x4888586ea85cdd9b150ac4223f6c07049e25e5);
        assert_eq!(buffer.read_partial_felt252(1, 20), 0x9b4fd6d2f910fb9ec35cdc79919971cea845f851);
        assert_eq!(buffer.read_partial_felt252(45, 21), 0x95c729fb06663b00419b6b69ae114c1f6f83ddd248);
        assert_eq!(buffer.read_partial_felt252(64, 22), 0xd24888586ea85cdd9b150ac4223f6c07049e25e5afa1);
        assert_eq!(buffer.read_partial_felt252(84, 23), 0xafa1b89dbff3b15323fe5323b241e492d51847814a0b65);
        assert_eq!(buffer.read_partial_felt252(29, 24), 0xace0f5b128a5516ea4de2d235b7f43f895c729fb06663b00);
        assert_eq!(buffer.read_partial_felt252(86, 25), 0xb89dbff3b15323fe5323b241e492d51847814a0b651750206e);
        assert_eq!(buffer.read_partial_felt252(7, 26), 0xfb9ec35cdc79919971cea845f8515ee146bb3a5b33bbace0f5b1);
        assert_eq!(buffer.read_partial_felt252(0, 27), 0x209b4fd6d2f910fb9ec35cdc79919971cea845f8515ee146bb3a5b);
        assert_eq!(buffer.read_partial_felt252(54, 28), 0x9b6b69ae114c1f6f83ddd24888586ea85cdd9b150ac4223f6c07049e);
        assert_eq!(buffer.read_partial_felt252(37, 29), 0xa4de2d235b7f43f895c729fb06663b00419b6b69ae114c1f6f83ddd248);
        assert_eq!(buffer.read_partial_felt252(13, 30), 0x919971cea845f8515ee146bb3a5b33bbace0f5b128a5516ea4de2d235b7f);
        assert_eq!(buffer.read_partial_felt252(52, 31), 0x419b6b69ae114c1f6f83ddd24888586ea85cdd9b150ac4223f6c07049e25);
        assert_eq!(buffer.read_partial_felt252(9, 32), 0x35cdc7991997036a845f8515ee146bb3a5b33bbace0f5b128a5516ea4de2d0b);
        assert_eq!(buffer.hash_sha256(), [0x2b45ba18, 0xac5c7929, 0x6fd724d0, 0x8552b9b5, 0x3453cb96, 0x12a9b5da, 0x490b07a6, 0x3551476d]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x774a1214, 0xb1a9e0e, 0x997a21c7, 0xa61cffcb, 0x88a98082, 0x1ce791d1, 0xf5eec960, 0x3a6088f0]);
        assert_eq!(buffer.hash_poseidon_range(76, 102), 0x1da5afbdd3c964205f6181ef40511336c0c906aa589c2c46c9f2ed79405b040);
        assert_eq!(buffer.hash_poseidon_range(54, 102), 0x490481c8137dd6b9e75b9397f36a0d3aefbb35c0003042574782f3df42ad003);
        assert_eq!(buffer.hash_poseidon_range(86, 101), 0xcae688c4d756a3db8d324cd80dd77988d4a7cdaef2bd8e3a35ce51fff42220);
        assert_eq!(buffer.hash_poseidon_range(10, 50), 0x4ae0007aa496f4efe11e49e2fe44591571c26f53694febc13f5dc9c70ba0db9);
        assert_eq!(buffer.hash_poseidon_range(12, 92), 0x7b544f5257ffa99a51c55adff64dc2da86ffbe83f4509f4bf0080fca70836df);

        let mut serialized_byte_array = array![0x4, 0x7225c9e76c97a3d83e2a5260c75345115c82af1ccbb2f56912bdc01c0632f2, 0x38bb36e954c076df530153871807414fa51aec60b5fc91a7fb33e9a3b4f4f6, 0xc52eb3c1859781e72d2b722d7e00bf0ca9d15f1371ae636baffb6eca5d6986, 0x446e8bf23f93df43b655d26e89d297df29d107595b8efe830c5224edfe6f0f, 0xceec7c, 0x3].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(16), 0x825c);
        assert_eq!(buffer.read_u32_le(120), 0xf6ffeed);
        assert_eq!(buffer.read_u56_le(44), 0x60ec1aa54f4107);
        assert_eq!(buffer.read_u64_le(82), 0xca6efbaf6b63ae71);
        assert_eq!(buffer.read_u256(80), 0x5f1371ae636baffb6eca5d6986446e8bf23f93df43b655d26e89d297df29d107);
        assert_eq!(buffer.read_bytes31(63), 0x2eb3c1859781e72d2b722d7e00bf0ca9d15f1371ae636baffb6eca5d698644);
        assert_eq!(buffer.read_felt252(36), 0x76df530153858007414fa51aec60b5fc91a7fb33e9a3b4f4f6c52eb3c1857f);
        assert_eq!(buffer.read_partial_felt252(113, 1), 0x5b);
        assert_eq!(buffer.read_partial_felt252(124, 2), 0xceec);
        assert_eq!(buffer.read_partial_felt252(26, 3), 0xc01c06);
        assert_eq!(buffer.read_partial_felt252(22, 4), 0xf56912bd);
        assert_eq!(buffer.read_partial_felt252(120, 5), 0xedfe6f0fce);
        assert_eq!(buffer.read_partial_felt252(35, 6), 0x54c076df5301);
        assert_eq!(buffer.read_partial_felt252(104, 7), 0x6e89d297df29d1);
        assert_eq!(buffer.read_partial_felt252(82, 8), 0x71ae636baffb6eca);
        assert_eq!(buffer.read_partial_felt252(63, 9), 0x2eb3c1859781e72d2b);
        assert_eq!(buffer.read_partial_felt252(86, 10), 0xaffb6eca5d6986446e8b);
        assert_eq!(buffer.read_partial_felt252(102, 11), 0x55d26e89d297df29d10759);
        assert_eq!(buffer.read_partial_felt252(106, 12), 0xd297df29d107595b8efe830c);
        assert_eq!(buffer.read_partial_felt252(40, 13), 0x153871807414fa51aec60b5fc);
        assert_eq!(buffer.read_partial_felt252(22, 14), 0xf56912bdc01c0632f238bb36e954);
        assert_eq!(buffer.read_partial_felt252(14, 15), 0x45115c82af1ccbb2f56912bdc01c06);
        assert_eq!(buffer.read_partial_felt252(22, 16), 0xf56912bdc01c0632f238bb36e954c076);
        assert_eq!(buffer.read_partial_felt252(15, 17), 0x115c82af1ccbb2f56912bdc01c0632f238);
        assert_eq!(buffer.read_partial_felt252(48, 18), 0x1aec60b5fc91a7fb33e9a3b4f4f6c52eb3c1);
        assert_eq!(buffer.read_partial_felt252(8, 19), 0x3e2a5260c75345115c82af1ccbb2f56912bdc0);
        assert_eq!(buffer.read_partial_felt252(63, 20), 0x2eb3c1859781e72d2b722d7e00bf0ca9d15f1371);
        assert_eq!(buffer.read_partial_felt252(62, 21), 0xc52eb3c1859781e72d2b722d7e00bf0ca9d15f1371);
        assert_eq!(buffer.read_partial_felt252(86, 22), 0xaffb6eca5d6986446e8bf23f93df43b655d26e89d297);
        assert_eq!(buffer.read_partial_felt252(81, 23), 0x1371ae636baffb6eca5d6986446e8bf23f93df43b655d2);
        assert_eq!(buffer.read_partial_felt252(39, 24), 0x530153871807414fa51aec60b5fc91a7fb33e9a3b4f4f6c5);
        assert_eq!(buffer.read_partial_felt252(82, 25), 0x71ae636baffb6eca5d6986446e8bf23f93df43b655d26e89d2);
        assert_eq!(buffer.read_partial_felt252(10, 26), 0x5260c75345115c82af1ccbb2f56912bdc01c0632f238bb36e954);
        assert_eq!(buffer.read_partial_felt252(88, 27), 0x6eca5d6986446e8bf23f93df43b655d26e89d297df29d107595b8e);
        assert_eq!(buffer.read_partial_felt252(27, 28), 0x1c0632f238bb36e954c076df530153871807414fa51aec60b5fc91a7);
        assert_eq!(buffer.read_partial_felt252(79, 29), 0xd15f1371ae636baffb6eca5d6986446e8bf23f93df43b655d26e89d297);
        assert_eq!(buffer.read_partial_felt252(77, 30), 0xca9d15f1371ae636baffb6eca5d6986446e8bf23f93df43b655d26e89d2);
        assert_eq!(buffer.read_partial_felt252(89, 31), 0xca5d6986446e8bf23f93df43b655d26e89d297df29d107595b8efe830c5224);
        assert_eq!(buffer.read_partial_felt252(10, 32), 0x260c75345115bd8af1ccbb2f56912bdc01c0632f238bb36e954c076df530149);
        assert_eq!(buffer.hash_sha256(), [0xe6aa44cf, 0x61349a53, 0x9007a034, 0xb8357bf8, 0xa1cb3cac, 0x527c7dc3, 0xaeca15bc, 0x683f93f9]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x88454a09, 0x54929df9, 0x2491c357, 0xd6b01020, 0xa3e9dd30, 0x8ce481fb, 0x8797c4d1, 0x55e68261]);
        assert_eq!(buffer.hash_poseidon_range(19, 99), 0x32c1410a4f3b4040d511c4f43f09b2ba7dfbc05b7efe2ea40f196a8a24a7fbf);
        assert_eq!(buffer.hash_poseidon_range(76, 115), 0x7a71415d448a7ee8b821ed79a68cb46526e2cde95b63e20691b3d0d33bdc2f6);
        assert_eq!(buffer.hash_poseidon_range(85, 98), 0x6b6d539f7a0ea7f9e3ea012ec35076436b6483c6840dab937277f0f06a2fd02);
        assert_eq!(buffer.hash_poseidon_range(117, 118), 0x404c388d9776724afeef4bb5c077785b76574a92fc2de51cf9bcb88e7ba758b);
        assert_eq!(buffer.hash_poseidon_range(57, 117), 0x96c36a4268ddff44b6fd17b200fc3ea123799183b2b5beccca95725a75d1fa);

        let mut serialized_byte_array = array![0x3, 0x0fea4394d394829c3441fb81b4f4b0f45b1518724666e487eff03d7da924c7, 0xdf6b19b68eafea3ea2163cc07cdcba375eb0e6b007034dc2ff566c1a816922, 0x13edb00b612a333171e08220833786e96aca942dd44344b8b57b468c6391b3, 0xb2ce481c38bf5a353e4d9dea, 0xc].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(14), 0xf4b0);
        assert_eq!(buffer.read_u32_le(68), 0xe0713133);
        assert_eq!(buffer.read_u56_le(96), 0x4d3e355abf381c);
        assert_eq!(buffer.read_u64_le(58), 0xbb0ed132269811a);
        assert_eq!(buffer.read_u256(61), 0x2213edb00b612a333171e08220833786e96aca942dd44344b8b57b468c6391b3);
        assert_eq!(buffer.read_bytes31(67), 0x2a333171e08220833786e96aca942dd44344b8b57b468c6391b3b2ce481c38);
        assert_eq!(buffer.read_felt252(50), 0x7034dc2ff54f61a81692213edb00b612a333171e08220833786e96aca9417);
        assert_eq!(buffer.read_partial_felt252(26, 1), 0x3d);
        assert_eq!(buffer.read_partial_felt252(28, 2), 0xa924);
        assert_eq!(buffer.read_partial_felt252(28, 3), 0xa924c7);
        assert_eq!(buffer.read_partial_felt252(66, 4), 0x612a3331);
        assert_eq!(buffer.read_partial_felt252(17, 5), 0x1518724666);
        assert_eq!(buffer.read_partial_felt252(76, 6), 0x86e96aca942d);
        assert_eq!(buffer.read_partial_felt252(12, 7), 0xb4f4b0f45b1518);
        assert_eq!(buffer.read_partial_felt252(55, 8), 0xff566c1a81692213);
        assert_eq!(buffer.read_partial_felt252(8, 9), 0x3441fb81b4f4b0f45b);
        assert_eq!(buffer.read_partial_felt252(48, 10), 0xb0e6b007034dc2ff566c);
        assert_eq!(buffer.read_partial_felt252(81, 11), 0x2dd44344b8b57b468c6391);
        assert_eq!(buffer.read_partial_felt252(54, 12), 0xc2ff566c1a81692213edb00b);
        assert_eq!(buffer.read_partial_felt252(36, 13), 0xafea3ea2163cc07cdcba375eb0);
        assert_eq!(buffer.read_partial_felt252(89, 14), 0x8c6391b3b2ce481c38bf5a353e4d);
        assert_eq!(buffer.read_partial_felt252(83, 15), 0x4344b8b57b468c6391b3b2ce481c38);
        assert_eq!(buffer.read_partial_felt252(77, 16), 0xe96aca942dd44344b8b57b468c6391b3);
        assert_eq!(buffer.read_partial_felt252(56, 17), 0x566c1a81692213edb00b612a333171e082);
        assert_eq!(buffer.read_partial_felt252(2, 18), 0x4394d394829c3441fb81b4f4b0f45b151872);
        assert_eq!(buffer.read_partial_felt252(13, 19), 0xf4b0f45b1518724666e487eff03d7da924c7df);
        assert_eq!(buffer.read_partial_felt252(59, 20), 0x81692213edb00b612a333171e08220833786e96a);
        assert_eq!(buffer.read_partial_felt252(22, 21), 0xe487eff03d7da924c7df6b19b68eafea3ea2163cc0);
        assert_eq!(buffer.read_partial_felt252(15, 22), 0xf45b1518724666e487eff03d7da924c7df6b19b68eaf);
        assert_eq!(buffer.read_partial_felt252(7, 23), 0x9c3441fb81b4f4b0f45b1518724666e487eff03d7da924);
        assert_eq!(buffer.read_partial_felt252(43, 24), 0x7cdcba375eb0e6b007034dc2ff566c1a81692213edb00b61);
        assert_eq!(buffer.read_partial_felt252(3, 25), 0x94d394829c3441fb81b4f4b0f45b1518724666e487eff03d7d);
        assert_eq!(buffer.read_partial_felt252(56, 26), 0x566c1a81692213edb00b612a333171e08220833786e96aca942d);
        assert_eq!(buffer.read_partial_felt252(0, 27), 0xfea4394d394829c3441fb81b4f4b0f45b1518724666e487eff03d);
        assert_eq!(buffer.read_partial_felt252(58, 28), 0x1a81692213edb00b612a333171e08220833786e96aca942dd44344b8);
        assert_eq!(buffer.read_partial_felt252(3, 29), 0x94d394829c3441fb81b4f4b0f45b1518724666e487eff03d7da924c7df);
        assert_eq!(buffer.read_partial_felt252(51, 30), 0x7034dc2ff566c1a81692213edb00b612a333171e08220833786e96aca94);
        assert_eq!(buffer.read_partial_felt252(27, 31), 0x7da924c7df6b19b68eafea3ea2163cc07cdcba375eb0e6b007034dc2ff566c);
        assert_eq!(buffer.read_partial_felt252(4, 32), 0x394829c3441f9c7b4f4b0f45b1518724666e487eff03d7da924c7df6b19b674);
        assert_eq!(buffer.hash_sha256(), [0x619db234, 0x4d8e02d6, 0xad2d7e20, 0x48e071f6, 0xcbc568f2, 0x68506929, 0xbc9df14, 0x3db7c816]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x9d3640a4, 0x70934629, 0x86bcf6e8, 0x3734afa2, 0x23bfb1, 0x4dc91005, 0xa1cbb161, 0x7f935766]);
        assert_eq!(buffer.hash_poseidon_range(55, 95), 0x6e400ea2a6530edceb80e8f41fbe7451e2bb84b323bb0a9c6f6f2ad8e508b92);
        assert_eq!(buffer.hash_poseidon_range(103, 104), 0x6258817788aa4fbabbe984ea98d304e77bb14ac644b97fb20d25a66c568bc61);
        assert_eq!(buffer.hash_poseidon_range(23, 95), 0x5eb1ae5aebd9588c357bc48fe2e8fd8c4c477649707f14a296c666c8b22353b);
        assert_eq!(buffer.hash_poseidon_range(4, 100), 0x3e6ed7c1954cf44479cb61eee8c22b12976c24ec0e83aec8b81669b4c735ab3);
        assert_eq!(buffer.hash_poseidon_range(56, 85), 0xf0fc7b3f89d4b00179bb955bebf09630b60674e15631978d2e805555cb49f0);
    }

    //Tests on random data, using randomly choosen functions
    #[test]
    fn test_random_access() {
        // Random access test cases testing random reads
        let mut serialized_byte_array = array![0x2, 0x8272b16b6b5351c2d6b03c08925aa11003ea870e31fc25a2708b0f4c07d818, 0x9eddaf69605e58e753a1c629e5f43e970fccbbf5af5e227583c76a39f608b4, 0x037018, 0x3].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u32_le(27), 0x18d8074c);
        assert_eq!(buffer.read_bytes31(5), 0x5351c2d6b03c08925aa11003ea870e31fc25a2708b0f4c07d8189eddaf6960);
        assert_eq!(buffer.hash_poseidon_range(34, 46), 0x17c77c118a9a19803019ad8cf9319d855aac638589913a0792dee2039f7456c);
        assert_eq!(buffer.read_partial_felt252(23, 6), 0xa2708b0f4c07);
        assert_eq!(buffer.read_u16_le(37), 0xe758);
        assert_eq!(buffer.read_partial_felt252(11, 19), 0x8925aa11003ea870e31fc25a2708b0f4c07d8);
        assert_eq!(buffer.read_partial_felt252(51, 7), 0xaf5e227583c76a);
        assert_eq!(buffer.read_u64_le(31), 0xe7585e6069afdd9e);
        assert_eq!(buffer.read_partial_felt252(8, 24), 0xd6b03c08925aa11003ea870e31fc25a2708b0f4c07d8189e);
        assert_eq!(buffer.read_partial_felt252(21, 29), 0xfc25a2708b0f4c07d8189eddaf69605e58e753a1c629e5f43e970fccbb);

        let mut serialized_byte_array = array![0x3, 0xe8dff8a85e98174442d0df931e996369295eb440645941f922238b25db6203, 0x6a16c928e6fbf92c9c434b99cde756a0bfc3a1da9d263a85dd5e75ffeb468c, 0x709432e5b25aaa8c44d32cc9656114a300b2d3452f399d3cd7e7f4d37234f0, 0x74b71bf06224a36c77d6a5926604, 0xe].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(32, 16), 0x16c928e6fbf92c9c434b99cde756a0bf);
        assert_eq!(buffer.read_partial_felt252(3, 15), 0xa85e98174442d0df931e996369295e);
        assert_eq!(buffer.read_partial_felt252(95, 9), 0x1bf06224a36c77d6a5);
        assert_eq!(buffer.read_partial_felt252(94, 3), 0xb71bf0);
        assert_eq!(buffer.read_partial_felt252(57, 30), 0x75ffeb468c709432e5b25aaa8c44d32cc9656114a300b2d3452f399d3cd7);
        assert_eq!(buffer.read_partial_felt252(76, 5), 0x14a300b2d3);
        assert_eq!(buffer.read_u64_le(86), 0x74f03472d3f4e7d7);
        assert_eq!(buffer.read_partial_felt252(77, 6), 0xa300b2d3452f);
        assert_eq!(buffer.read_partial_felt252(81, 13), 0x452f399d3cd7e7f4d37234f074);
        assert_eq!(buffer.read_partial_felt252(36, 23), 0xfbf92c9c434b99cde756a0bfc3a1da9d263a85dd5e75ff);

        let mut serialized_byte_array = array![0x1, 0x703c3f5b4d74ccc410626b63b9aeae210e05b2a6611d10f598d07a1ab8e881, 0xbf1859cb4c47f21af88c6a053bfa0d8a7ef003865174397168de58d2258fd3, 0x1f].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(25, 12), 0xd07a1ab8e881bf1859cb4c47);
        assert_eq!(buffer.read_partial_felt252(34, 5), 0xcb4c47f21a);
        assert_eq!(buffer.read_partial_felt252(24, 31), 0x98d07a1ab8e881bf1859cb4c47f21af88c6a053bfa0d8a7ef0038651743971);
        assert_eq!(buffer.read_partial_felt252(49, 6), 0x38651743971);
        assert_eq!(buffer.read_bytes31(14), 0xae210e05b2a6611d10f598d07a1ab8e881bf1859cb4c47f21af88c6a053bfa);
        assert_eq!(buffer.read_partial_felt252(42, 19), 0x53bfa0d8a7ef003865174397168de58d2258f);
        assert_eq!(buffer.read_partial_felt252(5, 28), 0x74ccc410626b63b9aeae210e05b2a6611d10f598d07a1ab8e881bf18);
        assert_eq!(buffer.read_partial_felt252(35, 16), 0x4c47f21af88c6a053bfa0d8a7ef00386);
        assert_eq!(buffer.read_partial_felt252(25, 31), 0xd07a1ab8e881bf1859cb4c47f21af88c6a053bfa0d8a7ef003865174397168);
        assert_eq!(buffer.read_partial_felt252(15, 7), 0x210e05b2a6611d);

        let mut serialized_byte_array = array![0x2, 0x17a80f2408afcc5a5d34143e870c106deb6227e11531b60c92f584407b4644, 0x22f2236764e51ad0dba8bf6e5be6938abbfa43e42ab34f921135f77ba16064, 0xd5, 0x1].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(14, 22), 0x106deb6227e11531b60c92f584407b464422f2236764);
        assert_eq!(buffer.read_u56_le(8), 0x100c873e14345d);
        assert_eq!(buffer.read_partial_felt252(1, 24), 0xa80f2408afcc5a5d34143e870c106deb6227e11531b60c92);
        assert_eq!(buffer.read_partial_felt252(0, 30), 0x17a80f2408afcc5a5d34143e870c106deb6227e11531b60c92f584407b46);
        assert_eq!(buffer.read_partial_felt252(12, 27), 0x870c106deb6227e11531b60c92f584407b464422f2236764e51ad0);
        assert_eq!(buffer.read_partial_felt252(50, 3), 0xe42ab3);
        assert_eq!(buffer.read_partial_felt252(13, 32), 0x4106deb6227e10431b60c92f584407b464422f2236764e51ad0dba8bf6e5be5);
        assert_eq!(buffer.read_partial_felt252(0, 14), 0x17a80f2408afcc5a5d34143e870c);
        assert_eq!(buffer.read_partial_felt252(45, 12), 0x938abbfa43e42ab34f921135);
        assert_eq!(buffer.read_partial_felt252(12, 4), 0x870c106d);

        let mut serialized_byte_array = array![0x1, 0x506d9845b00f0655f99297218c8937c50df55935fbd0dc5f0b299d209d9903, 0x152db40faf6d678765a86ed881e1040df45c03d7, 0x14].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(13, 2), 0x8937);
        assert_eq!(buffer.read_u64_le(2), 0x92f955060fb04598);
        assert_eq!(buffer.read_felt252(6), 0x655f99297218c8937c50df55935fbd0dc5f0b299d209d9903152db40faf6d67);
        assert_eq!(buffer.read_partial_felt252(12, 23), 0x8c8937c50df55935fbd0dc5f0b299d209d9903152db40f);
        assert_eq!(buffer.read_u56_le(40), 0x0d04e181d86ea8);
        assert_eq!(buffer.read_u64_le(2), 0x92f955060fb04598);
        assert_eq!(buffer.read_partial_felt252(22, 13), 0xdc5f0b299d209d9903152db40f);
        assert_eq!(buffer.read_u64_le(24), 0x1503999d209d290b);
        assert_eq!(buffer.read_partial_felt252(9, 30), 0x9297218c8937c50df55935fbd0dc5f0b299d209d9903152db40faf6d6787);
        assert_eq!(buffer.read_partial_felt252(10, 28), 0x97218c8937c50df55935fbd0dc5f0b299d209d9903152db40faf6d67);

        let mut serialized_byte_array = array![0x3, 0x597f9002e081a4c564357ab339aae2c3d03d7c7c22ff1f0be2987bbcdaa0cb, 0x1d6ff97921344b9096549ddc5cdf7753be0df0822ed02ead5a883d0dae7885, 0x8fb0c79e6b6c0b7afaf622604ceec4748f413202a008b8f1dd0f3bfbb0a5b6, 0xb8d894662225c994d2871c8ff0, 0xd].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(45, 19), 0x7753be0df0822ed02ead5a883d0dae78858fb0);
        assert_eq!(buffer.read_partial_felt252(20, 28), 0x22ff1f0be2987bbcdaa0cb1d6ff97921344b9096549ddc5cdf7753be);
        assert_eq!(buffer.read_partial_felt252(23, 12), 0xbe2987bbcdaa0cb1d6ff979);
        assert_eq!(buffer.read_partial_felt252(43, 7), 0x5cdf7753be0df0);
        assert_eq!(buffer.read_bytes31(24), 0xe2987bbcdaa0cb1d6ff97921344b9096549ddc5cdf7753be0df0822ed02ead);
        assert_eq!(buffer.read_partial_felt252(74, 23), 0x4ceec4748f413202a008b8f1dd0f3bfbb0a5b6b8d89466);
        assert_eq!(buffer.read_u64_le(69), 0xc4ee4c6022f6fa7a);
        assert_eq!(buffer.read_partial_felt252(80, 7), 0x3202a008b8f1dd);
        assert_eq!(buffer.read_partial_felt252(61, 27), 0x858fb0c79e6b6c0b7afaf622604ceec4748f413202a008b8f1dd0f);
        assert_eq!(buffer.read_partial_felt252(69, 27), 0x7afaf622604ceec4748f413202a008b8f1dd0f3bfbb0a5b6b8d894);

        let mut serialized_byte_array = array![0x3, 0x81be16177223fb85370c3d32b186e16cb2f512b0857319820d3870767f803b, 0x1e4c95ffaa6791d57cc64ef8eb9afe76bd1ccff76658a9f29abfe758548092, 0x1375df19e7267f52516ef2bc09a9ff836f87e6c5175fede3c8bd587c26c197, 0x274984f5b574ad37f44c2e8a5f3f553759f98a8ce8c2, 0x16].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(28, 15), 0x7f803b1e4c95ffaa6791d57cc64ef8);
        assert_eq!(buffer.read_partial_felt252(30, 25), 0x3b1e4c95ffaa6791d57cc64ef8eb9afe76bd1ccff76658a9f2);
        assert_eq!(buffer.read_partial_felt252(80, 32), 0x6c5175fede3c6e1587c26c197274984f5b574ad37f44c2e8a5f3f553759f96e);
        assert_eq!(buffer.read_partial_felt252(86, 18), 0xc8bd587c26c197274984f5b574ad37f44c2e);
        assert_eq!(buffer.read_partial_felt252(62, 4), 0x1375df19);
        assert_eq!(buffer.hash_poseidon_range(74, 102), 0x47cfe8fa7fd7ef4841b22ad70f33e3e8b5db5c29735acde43311bd81cf7504f);
        assert_eq!(buffer.read_partial_felt252(10, 9), 0x3d32b186e16cb2f512);
        assert_eq!(buffer.read_partial_felt252(92, 12), 0x97274984f5b574ad37f44c2e);
        assert_eq!(buffer.read_partial_felt252(97, 16), 0xb574ad37f44c2e8a5f3f553759f98a8c);
        assert_eq!(buffer.read_bytes31(20), 0x857319820d3870767f803b1e4c95ffaa6791d57cc64ef8eb9afe76bd1ccff7);

        let mut serialized_byte_array = array![0x3, 0xa41090407973b98c00a5819fbef026178b1103db588ecfb23d98d27177a8e2, 0x52e118ad1b9a7d143afb2035c7ee9258ef680222a00f2a3ee26975125470f1, 0x161eff8a27728b5629c6f60888879f6b0f4db3ffc076083089abdc0d4dffc0, 0xf0bd06e7507a42b3, 0x8].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(49, 16), 0x222a00f2a3ee26975125470f1161eff);
        assert_eq!(buffer.read_partial_felt252(53, 9), 0x2a3ee26975125470f1);
        assert_eq!(buffer.read_partial_felt252(56, 29), 0x6975125470f1161eff8a27728b5629c6f60888879f6b0f4db3ffc07608);
        assert_eq!(buffer.read_partial_felt252(54, 6), 0x3ee269751254);
        assert_eq!(buffer.read_partial_felt252(30, 27), 0xe252e118ad1b9a7d143afb2035c7ee9258ef680222a00f2a3ee269);
        assert_eq!(buffer.read_partial_felt252(21, 26), 0x8ecfb23d98d27177a8e252e118ad1b9a7d143afb2035c7ee9258);
        assert_eq!(buffer.read_partial_felt252(33, 29), 0x18ad1b9a7d143afb2035c7ee9258ef680222a00f2a3ee26975125470f1);
        assert_eq!(buffer.read_partial_felt252(67, 22), 0x728b5629c6f60888879f6b0f4db3ffc076083089abdc);
        assert_eq!(buffer.read_bytes31(33), 0x18ad1b9a7d143afb2035c7ee9258ef680222a00f2a3ee26975125470f1161e);
        assert_eq!(buffer.read_partial_felt252(58, 32), 0x25470f1161eff6827728b5629c6f60888879f6b0f4db3ffc076083089abdc0b);

        let mut serialized_byte_array = array![0x0, 0xc3bfd711ae8fb8bbe871a5ce2e7ea789877ec95cb42d07423b6d81f5, 0x1c].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(16, 8), 0x877ec95cb42d0742);
        assert_eq!(buffer.read_partial_felt252(0, 24), 0xc3bfd711ae8fb8bbe871a5ce2e7ea789877ec95cb42d0742);
        assert_eq!(buffer.read_partial_felt252(0, 27), 0xc3bfd711ae8fb8bbe871a5ce2e7ea789877ec95cb42d07423b6d81);
        assert_eq!(buffer.read_u16_le(1), 0xd7bf);
        assert_eq!(buffer.read_partial_felt252(13, 9), 0x7ea789877ec95cb42d);
        assert_eq!(buffer.read_u64_le(12), 0x5cc97e8789a77e2e);
        assert_eq!(buffer.read_partial_felt252(1, 25), 0xbfd711ae8fb8bbe871a5ce2e7ea789877ec95cb42d07423b6d);
        assert_eq!(buffer.read_partial_felt252(6, 16), 0xb8bbe871a5ce2e7ea789877ec95cb42d);
        assert_eq!(buffer.read_partial_felt252(2, 24), 0xd711ae8fb8bbe871a5ce2e7ea789877ec95cb42d07423b6d);

        let mut serialized_byte_array = array![0x2, 0x37566afb428623b6ba6ea98dc59743cb7587bf318e87fb05fb2927b847d7fb, 0x83d158aa275db9a261d0fa5186b143be5ff35f1cca53ca41d2b0f190ab049b, 0xdc3f810b277db9aca6e2f8c46bb86e3e7b, 0x11].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.hash_poseidon_range(63, 69), 0x572e87d8ad00315b52495f85c90bf0a0a7c9bcdbc7b9e87e808b90b5687e75e);
        assert_eq!(buffer.read_partial_felt252(9, 18), 0x6ea98dc59743cb7587bf318e87fb05fb2927);
        assert_eq!(buffer.read_partial_felt252(69, 3), 0xaca6e2);
        assert_eq!(buffer.read_partial_felt252(21, 20), 0x87fb05fb2927b847d7fb83d158aa275db9a261d0);
        assert_eq!(buffer.read_partial_felt252(37, 8), 0xb9a261d0fa5186b1);
        assert_eq!(buffer.read_partial_felt252(30, 12), 0xfb83d158aa275db9a261d0fa);
        assert_eq!(buffer.read_partial_felt252(22, 1), 0xfb);
        assert_eq!(buffer.read_bytes31(40), 0xd0fa5186b143be5ff35f1cca53ca41d2b0f190ab049bdc3f810b277db9aca6);
        assert_eq!(buffer.read_u56_le(15), 0x878e31bf8775cb);
        assert_eq!(buffer.read_partial_felt252(42, 31), 0x5186b143be5ff35f1cca53ca41d2b0f190ab049bdc3f810b277db9aca6e2f8);
    }
    
    // Random access out of bounds reads

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u16_le() {
        let mut serialized_byte_array = array![0x0, 0xe32927d0, 0x4].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u16_le(4);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u32_le() {
        let mut serialized_byte_array = array![0x0, 0x4a641e6a02719182d5198d1b476d8ba364bb, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u32_le(15);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u56_le() {
        let mut serialized_byte_array = array![0x0, 0x9b3d9f0062b8eeccfc92b767c3e81b8a0bac6bbdb860, 0x16].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u56_le(16);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u64_le() {
        let mut serialized_byte_array = array![0x0, 0x143ea2247d84abbc11f0c80191fd, 0xe].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u64_le(11);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u256() {
        let mut serialized_byte_array = array![0x1, 0x327a0ad0966615e0c2e0e5f8e53c1d03d5476fbb50ff67fb0e98cbebfca2b6, 0x945350866f6c00a92c0bff6209c080081fe543055a66a318, 0x18].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u256(44);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_bytes31() {
        let mut serialized_byte_array = array![0x1, 0x47bae1958baaadcaeab95e94932ab338cbad838fb52c62092252c750403615, 0x5b64abff397cc7c5bcc126d94ca8f74628fd9576e75abcf5aa8cfbe6fd, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_bytes31(55);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252() {
        let mut serialized_byte_array = array![0x1, 0x7e6bdb1a2b819bcf6aeaa0452271845de29ac80267e236fef2315f16f25daf, 0x08650f2a105fc0fbac30be0d7bfe489c5c1bf16565feeb126456cffb6773, 0x1e].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_felt252(42);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_1b() {
        let mut serialized_byte_array = array![0x0, 0xf37d0fe6d09c2a7b5ee9a2f0462b5b18df46db, 0x13].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(19, 1);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_2b() {
        let mut serialized_byte_array = array![0x0, 0x31a37e3a52, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(4, 2);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_3b() {
        let mut serialized_byte_array = array![0x0, 0x5d440f693126, 0x6].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(4, 3);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_4b() {
        let mut serialized_byte_array = array![0x0, 0x360e87b9dd31dc4d846b155961c8150d02ff, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(17, 4);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_5b() {
        let mut serialized_byte_array = array![0x0, 0xdcab06cd164268fec4cda8842627a7622cf21e58e48b299f49ec45b591, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(28, 5);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_6b() {
        let mut serialized_byte_array = array![0x0, 0x14905af8c13fb3f6dd941d2170639b26701f44500492d6a8c931b2b0a4, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(27, 6);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_7b() {
        let mut serialized_byte_array = array![0x0, 0x4514f9a9b2f5bccf28245be1b12f01d1f8, 0x11].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(14, 7);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_8b() {
        let mut serialized_byte_array = array![0x0, 0xad8765f1e9c6765f0589a4d712e7a499f1, 0x11].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(16, 8);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_9b() {
        let mut serialized_byte_array = array![0x0, 0x834eb0fa98002b2f3ddaff0e929320889fde, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(15, 9);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_10b() {
        let mut serialized_byte_array = array![0x0, 0xca5031b4d8a200f169e199, 0xb].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(6, 10);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_11b() {
        let mut serialized_byte_array = array![0x1, 0x6b9f38c08ad9865b8da1058519c710e01af77a48ce60a995a286c7ea3830b3, 0x3e020d062ae9a4, 0x7].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(37, 11);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_12b() {
        let mut serialized_byte_array = array![0x1, 0xbaa6e1daec1cfcee890fdb45dcb934671d78c5a7ef4fc59de4ae1e9c3a83b8, 0xa8f199af, 0x4].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(30, 12);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_13b() {
        let mut serialized_byte_array = array![0x0, 0x7de23930ff5232a7ff33516d0c0eee4af44bc1bb5114f497b6eac736d0, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(22, 13);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_14b() {
        let mut serialized_byte_array = array![0x1, 0x4de8755a50c5194d266c97f41f5e59ab5498389358c0777dc2d0a8da2c318d, 0xcdb4dd419277e0bde1dcce, 0xb].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(39, 14);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_15b() {
        let mut serialized_byte_array = array![0x1, 0x7df0d00ce7350019ff7bf46798b50bcd62e0f20f75042d137a13a0f7783cae, 0xc46e3ac0cd39dd, 0x7].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(33, 15);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_16b() {
        let mut serialized_byte_array = array![0x0, 0x04eafbfd9b2978f48fe8048927700fe6dbcfc11297bf5df5fe7ed9, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(20, 16);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_17b() {
        let mut serialized_byte_array = array![0x1, 0x85736bfae46b5df954476c207e0cb64b578c084f10f3db3948beb8b98715ba, 0x61258d896769, 0x6].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(36, 17);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_18b() {
        let mut serialized_byte_array = array![0x1, 0x0583c31d8df72a591f1927cad5744f7ce932b50bd7692e9fe4f46fca0d10a0, 0x31, 0x1].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(31, 18);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_19b() {
        let mut serialized_byte_array = array![0x1, 0xbd2940cea98ee3090c76b4805944ee4ecaa806e63a3a14298c4d29b98ee6ea, 0x9fe883edb51cb3cd3dd02cc8516941, 0xf].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(29, 19);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_20b() {
        let mut serialized_byte_array = array![0x1, 0x5f7e5b5c01d11dac6608424378142845c0f73c3e59b54f6a45524f8f990c24, 0x3baa200fdbbc40062ad8a0a9865767b830, 0x11].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(47, 20);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_21b() {
        let mut serialized_byte_array = array![0x0, 0x4c0760693c8f15470b948f5bd24e99535ee2425db6eb87, 0x17].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(5, 21);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_22b() {
        let mut serialized_byte_array = array![0x0, 0xdfbcfc8fe7e0b3ec7a9cb2055a0bea63bc16676ecb5c, 0x16].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(4, 22);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_23b() {
        let mut serialized_byte_array = array![0x1, 0x80008852b82b79ea0067690c69151e69eda7a212377d64097855d3669578c1, 0x02beaf61ee, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(20, 23);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_24b() {
        let mut serialized_byte_array = array![0x1, 0x639fb67a5620efebf8417b10538e08e285d49e90d446d5e68c1698adb7ddbd, 0x3a01be9ad5cb1745f1b21b5c682f74b4c2403748ff, 0x15].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(48, 24);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_25b() {
        let mut serialized_byte_array = array![0x0, 0x496894b4922d72dfd22feecb179df9f4a818d3cff9f6d0d2780a58e7e5, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(15, 25);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_26b() {
        let mut serialized_byte_array = array![0x0, 0xcb0fc1b641586b3c00bea215e07b34bb65670bf37bf36f7635743cde73e0, 0x1e].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(21, 26);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_27b() {
        let mut serialized_byte_array = array![0x1, 0x33946aa1d6d99aa2a37ebbb7b6fddc15b0fa0c0270d0693977f82dab8b1963, 0x557c565992b360def39f, 0xa].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(16, 27);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_28b() {
        let mut serialized_byte_array = array![0x1, 0x2483887d750a37ea0fd1d8c87cd30d4ceb1bdc331f886307b631f315752af8, 0x32e747305a4d78bde69ea79a32af9974891fe13975417e80693a, 0x1a].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(52, 28);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_29b() {
        let mut serialized_byte_array = array![0x1, 0x7a17caa25cbb76e46c248f35e56f01ce40eb97cfb7e864463098fb4b7ab44a, 0xaf633275e82cfa159511d2e3d6c79e12d69ed630e1f9, 0x16].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(46, 29);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_30b() {
        let mut serialized_byte_array = array![0x1, 0x576c5eef2428d727a8f6cb526f7b9a2cb0f0541ff60a391d5586bf43ff9045, 0xc1b52203377eebe85690bdf0a6ad0c718ed67ddb0ad0912241, 0x19].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(54, 30);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_31b() {
        let mut serialized_byte_array = array![0x1, 0xcee88da346c7079eef206901edcecb7c91f7ac8c525910be97db6cf6813684, 0x30eda2c6, 0x4].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(18, 31);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_32b() {
        let mut serialized_byte_array = array![0x1, 0x2b0985f9f6ac500d60798adfa8b4d2c1769df72307a565bcda1f7055c14525, 0x06ce5915, 0x4].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(25, 32);
    }

}