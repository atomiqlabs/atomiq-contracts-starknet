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
        
        let mut serialized_byte_array = array![0x2, 0x8769ff29caebfb93e67bac986150feadd2226dbc2654f64582a7273b4de4d8, 0x2c37e7e6d3772fe5f8d862533553b0d8feb8c8ed8552b5f9c0abfab8e2dad3, 0xb1f0a3bc135df2, 0x7].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(48), 0xc8b8);
        assert_eq!(buffer.read_u32_le(48), 0x85edc8b8);
        assert_eq!(buffer.read_u64_le(23), 0xd8e44d3b27a78245);
        assert_eq!(buffer.read_u256(35), 0xd3772fe5f8d862533553b0d8feb8c8ed8552b5f9c0abfab8e2dad3b1f0a3bc13);
        assert_eq!(buffer.read_felt252(14), 0xfeadd2226dbc2654f64582a7273b4de4d82c37e7e6d3772fe5f8d862533553);
        assert_eq!(buffer.read_partial_felt252(50, 1), 0xed);
        assert_eq!(buffer.read_partial_felt252(60, 2), 0xdad3);
        assert_eq!(buffer.read_partial_felt252(8, 3), 0xe67bac);
        assert_eq!(buffer.read_partial_felt252(2, 4), 0xff29caeb);
        assert_eq!(buffer.read_partial_felt252(49, 5), 0xc8ed8552b5);
        assert_eq!(buffer.read_partial_felt252(11, 6), 0x986150feadd2);
        assert_eq!(buffer.read_partial_felt252(16, 7), 0xd2226dbc2654f6);
        assert_eq!(buffer.read_partial_felt252(41, 8), 0x62533553b0d8feb8);
        assert_eq!(buffer.read_partial_felt252(20, 9), 0x2654f64582a7273b4d);
        assert_eq!(buffer.read_partial_felt252(9, 10), 0x7bac986150feadd2226d);
        assert_eq!(buffer.read_partial_felt252(29, 11), 0xe4d82c37e7e6d3772fe5f8);
        assert_eq!(buffer.read_partial_felt252(24, 12), 0x82a7273b4de4d82c37e7e6d3);
        assert_eq!(buffer.read_partial_felt252(24, 13), 0x82a7273b4de4d82c37e7e6d377);
        assert_eq!(buffer.read_partial_felt252(32, 14), 0x37e7e6d3772fe5f8d862533553b0);
        assert_eq!(buffer.read_partial_felt252(51, 15), 0x8552b5f9c0abfab8e2dad3b1f0a3bc);
        assert_eq!(buffer.read_partial_felt252(12, 16), 0x6150feadd2226dbc2654f64582a7273b);
        assert_eq!(buffer.read_partial_felt252(46, 17), 0xd8feb8c8ed8552b5f9c0abfab8e2dad3b1);
        assert_eq!(buffer.read_partial_felt252(7, 18), 0x93e67bac986150feadd2226dbc2654f64582);
        assert_eq!(buffer.read_partial_felt252(36, 19), 0x772fe5f8d862533553b0d8feb8c8ed8552b5f9);
        assert_eq!(buffer.read_partial_felt252(0, 20), 0x8769ff29caebfb93e67bac986150feadd2226dbc);
        assert_eq!(buffer.read_partial_felt252(11, 21), 0x986150feadd2226dbc2654f64582a7273b4de4d82c);
        assert_eq!(buffer.read_partial_felt252(25, 22), 0xa7273b4de4d82c37e7e6d3772fe5f8d862533553b0d8);
        assert_eq!(buffer.read_partial_felt252(22, 23), 0xf64582a7273b4de4d82c37e7e6d3772fe5f8d862533553);
        assert_eq!(buffer.read_partial_felt252(24, 24), 0x82a7273b4de4d82c37e7e6d3772fe5f8d862533553b0d8fe);
        assert_eq!(buffer.read_partial_felt252(14, 25), 0xfeadd2226dbc2654f64582a7273b4de4d82c37e7e6d3772fe5);
        assert_eq!(buffer.read_partial_felt252(11, 26), 0x986150feadd2226dbc2654f64582a7273b4de4d82c37e7e6d377);
        assert_eq!(buffer.read_partial_felt252(21, 27), 0x54f64582a7273b4de4d82c37e7e6d3772fe5f8d862533553b0d8fe);
        assert_eq!(buffer.read_partial_felt252(19, 28), 0xbc2654f64582a7273b4de4d82c37e7e6d3772fe5f8d862533553b0d8);
        assert_eq!(buffer.read_partial_felt252(25, 29), 0xa7273b4de4d82c37e7e6d3772fe5f8d862533553b0d8feb8c8ed8552b5);
        assert_eq!(buffer.read_partial_felt252(11, 30), 0x986150feadd2226dbc2654f64582a7273b4de4d82c37e7e6d3772fe5f8d8);
        assert_eq!(buffer.read_partial_felt252(26, 31), 0x273b4de4d82c37e7e6d3772fe5f8d862533553b0d8feb8c8ed8552b5f9c0ab);
        assert_eq!(buffer.hash_sha256(), [0x2a1d7b77, 0xc1ce64ef, 0xb61197f1, 0x00a489ae, 0x5a21cceb, 0xb8044a53, 0x5bb4da31, 0xd816d2e4]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x34a9920e, 0x12cfc94a, 0x62b3f8d0, 0xc910def4, 0x8aeb9c01, 0xe9872805, 0x73ec36ca, 0x96c0ef74]);
        assert_eq!(buffer.hash_poseidon_range(51, 62), 0x4af4ab6630cacb52d35633f36093f7164d11808f75dbf12ada0295a82d8c613);
        assert_eq!(buffer.hash_poseidon_range(1, 35), 0x648699498e92b801ac8bb0d2ae41b935833687c5c96b89e79a21691ffe1a5f5);
        assert_eq!(buffer.hash_poseidon_range(33, 47), 0xaecc639d851ff1179a16689aea5af729e3288f9439f40475a38c2a2d49921a);
        assert_eq!(buffer.hash_poseidon_range(41, 43), 0x2aaf78104aa2e85bbf11d52ac4998052fdf256cf3040f7bec94cd232a9fb664);
        assert_eq!(buffer.hash_poseidon_range(56, 57), 0x178d1eb87b955ac6799b1c79eb90f793a8634228fb3b0f969609c48d6c3087d);

        let mut serialized_byte_array = array![0x4, 0x07c40015e94f8d58625f1cef4c376726dfcfe2cb53ff72cf286a426996b595, 0x98a1f79900677dbbc4542b073965803ff689bfdde85f3d71bbab765488ccce, 0x32a329c97331f707b95fba1727d16a449106919e4e4ce16a724bf8a239f834, 0x21cb0d341fdabe4d1e08c0f0c9639c084ce6c064e63f2b3325665889ef588b, 0x18837b417b, 0x5].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(114), 0x2b3f);
        assert_eq!(buffer.read_u32_le(6), 0x5f62588d);
        assert_eq!(buffer.read_u64_le(64), 0x5fb907f73173c929);
        assert_eq!(buffer.read_u256(69), 0x07b95fba1727d16a449106919e4e4ce16a724bf8a239f83421cb0d341fdabe4d);
        assert_eq!(buffer.read_felt252(9), 0x5f1cef4c376726dfcfe2cb53ff72cf286a426996b59598a1f79900677dbbc4);
        assert_eq!(buffer.read_partial_felt252(3, 1), 0x15);
        assert_eq!(buffer.read_partial_felt252(55, 2), 0xbbab);
        assert_eq!(buffer.read_partial_felt252(21, 3), 0xff72cf);
        assert_eq!(buffer.read_partial_felt252(120, 4), 0x89ef588b);
        assert_eq!(buffer.read_partial_felt252(32, 5), 0xa1f7990067);
        assert_eq!(buffer.read_partial_felt252(29, 6), 0xb59598a1f799);
        assert_eq!(buffer.read_partial_felt252(38, 7), 0xbbc4542b073965);
        assert_eq!(buffer.read_partial_felt252(28, 8), 0x96b59598a1f79900);
        assert_eq!(buffer.read_partial_felt252(49, 9), 0xbfdde85f3d71bbab76);
        assert_eq!(buffer.read_partial_felt252(82, 10), 0x4e4ce16a724bf8a239f8);
        assert_eq!(buffer.read_partial_felt252(56, 11), 0xab765488ccce32a329c973);
        assert_eq!(buffer.read_partial_felt252(9, 12), 0x5f1cef4c376726dfcfe2cb53);
        assert_eq!(buffer.read_partial_felt252(29, 13), 0xb59598a1f79900677dbbc4542b);
        assert_eq!(buffer.read_partial_felt252(21, 14), 0xff72cf286a426996b59598a1f799);
        assert_eq!(buffer.read_partial_felt252(66, 15), 0x7331f707b95fba1727d16a44910691);
        assert_eq!(buffer.read_partial_felt252(81, 16), 0x9e4e4ce16a724bf8a239f83421cb0d34);
        assert_eq!(buffer.read_partial_felt252(70, 17), 0xb95fba1727d16a449106919e4e4ce16a72);
        assert_eq!(buffer.read_partial_felt252(72, 18), 0xba1727d16a449106919e4e4ce16a724bf8a2);
        assert_eq!(buffer.read_partial_felt252(75, 19), 0xd16a449106919e4e4ce16a724bf8a239f83421);
        assert_eq!(buffer.read_partial_felt252(12, 20), 0x4c376726dfcfe2cb53ff72cf286a426996b59598);
        assert_eq!(buffer.read_partial_felt252(99, 21), 0xbe4d1e08c0f0c9639c084ce6c064e63f2b33256658);
        assert_eq!(buffer.read_partial_felt252(53, 22), 0x3d71bbab765488ccce32a329c97331f707b95fba1727);
        assert_eq!(buffer.read_partial_felt252(49, 23), 0xbfdde85f3d71bbab765488ccce32a329c97331f707b95f);
        assert_eq!(buffer.read_partial_felt252(88, 24), 0xf8a239f83421cb0d341fdabe4d1e08c0f0c9639c084ce6c0);
        assert_eq!(buffer.read_partial_felt252(17, 25), 0xcfe2cb53ff72cf286a426996b59598a1f79900677dbbc4542b);
        assert_eq!(buffer.read_partial_felt252(64, 26), 0x29c97331f707b95fba1727d16a449106919e4e4ce16a724bf8a2);
        assert_eq!(buffer.read_partial_felt252(9, 27), 0x5f1cef4c376726dfcfe2cb53ff72cf286a426996b59598a1f79900);
        assert_eq!(buffer.read_partial_felt252(57, 28), 0x765488ccce32a329c97331f707b95fba1727d16a449106919e4e4ce1);
        assert_eq!(buffer.read_partial_felt252(59, 29), 0x88ccce32a329c97331f707b95fba1727d16a449106919e4e4ce16a724b);
        assert_eq!(buffer.read_partial_felt252(3, 30), 0x15e94f8d58625f1cef4c376726dfcfe2cb53ff72cf286a426996b59598a1);
        assert_eq!(buffer.read_partial_felt252(87, 31), 0x4bf8a239f83421cb0d341fdabe4d1e08c0f0c9639c084ce6c064e63f2b3325);
        assert_eq!(buffer.hash_sha256(), [0x2d444dfb, 0x8cc6762b, 0x0b50f1e5, 0xd9b950d5, 0xe28d9066, 0x9669a1ee, 0xd95d3239, 0x9beb02bd]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x376c3c1a, 0x611812db, 0x3252f3b0, 0xcaffd049, 0x84647236, 0x2aebee77, 0x4f95a6f9, 0xd302068d]);
        assert_eq!(buffer.hash_poseidon_range(28, 61), 0x7d5facc26dd83c68b69e1e33a8a4edfa4183de3feb42dc5c3e66613f0ed1c3e);
        assert_eq!(buffer.hash_poseidon_range(16, 43), 0x369cbfbf085f01c46057edb549f1fa0d8a967a07061a7a2ca8c36e97cf5da77);
        assert_eq!(buffer.hash_poseidon_range(28, 87), 0x793fe3d90242440274fc4d44c0a3a4edecfc909c3fc39ae810cea71c4e083bb);
        assert_eq!(buffer.hash_poseidon_range(85, 115), 0xbcd30d48d6fac38fec01c65c65a472ad251a1de842a047dce16f7cdcda714c);
        assert_eq!(buffer.hash_poseidon_range(104, 127), 0x53e23afd25cff2245af5989a9b824d5f6dc9b0f3a5b4a2df4e31b3cef403291);

        let mut serialized_byte_array = array![0x3, 0x6f0b5ac8c69c691daca8f785ededcd50cd4af80cd37925c7d000bfcc3ae82a, 0xe4fe06538c3a38a28fff48460bbe51d23bc96146ff0552b5898f05ad950391, 0x39bd28ddc5a5b40c281c323adfa1046e02f1dee6294507d4c7183b257602b3, 0xe1a3b298b193612f8cef4821, 0xc].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(49), 0x4661);
        assert_eq!(buffer.read_u32_le(74), 0x6e04a1df);
        assert_eq!(buffer.read_u64_le(47), 0xb55205ff4661c93b);
        assert_eq!(buffer.read_u256(45), 0x51d23bc96146ff0552b5898f05ad95039139bd28ddc5a5b40c281c323adfa104);
        assert_eq!(buffer.read_felt252(1), 0x0b5ac8c69c691daca8f785ededcd50cd4af80cd37925c7d000bfcc3ae82ae4);
        assert_eq!(buffer.read_partial_felt252(77, 1), 0x6e);
        assert_eq!(buffer.read_partial_felt252(87, 2), 0x183b);
        assert_eq!(buffer.read_partial_felt252(69, 3), 0x0c281c);
        assert_eq!(buffer.read_partial_felt252(15, 4), 0x50cd4af8);
        assert_eq!(buffer.read_partial_felt252(42, 5), 0x460bbe51d2);
        assert_eq!(buffer.read_partial_felt252(6, 6), 0x691daca8f785);
        assert_eq!(buffer.read_partial_felt252(89, 7), 0x257602b3e1a3b2);
        assert_eq!(buffer.read_partial_felt252(14, 8), 0xcd50cd4af80cd379);
        assert_eq!(buffer.read_partial_felt252(48, 9), 0xc96146ff0552b5898f);
        assert_eq!(buffer.read_partial_felt252(42, 10), 0x460bbe51d23bc96146ff);
        assert_eq!(buffer.read_partial_felt252(14, 11), 0xcd50cd4af80cd37925c7d0);
        assert_eq!(buffer.read_partial_felt252(46, 12), 0xd23bc96146ff0552b5898f05);
        assert_eq!(buffer.read_partial_felt252(12, 13), 0xededcd50cd4af80cd37925c7d0);
        assert_eq!(buffer.read_partial_felt252(85, 14), 0xd4c7183b257602b3e1a3b298b193);
        assert_eq!(buffer.read_partial_felt252(1, 15), 0x0b5ac8c69c691daca8f785ededcd50);
        assert_eq!(buffer.read_partial_felt252(4, 16), 0xc69c691daca8f785ededcd50cd4af80c);
        assert_eq!(buffer.read_partial_felt252(25, 17), 0x00bfcc3ae82ae4fe06538c3a38a28fff48);
        assert_eq!(buffer.read_partial_felt252(23, 18), 0xc7d000bfcc3ae82ae4fe06538c3a38a28fff);
        assert_eq!(buffer.read_partial_felt252(12, 19), 0xededcd50cd4af80cd37925c7d000bfcc3ae82a);
        assert_eq!(buffer.read_partial_felt252(33, 20), 0x06538c3a38a28fff48460bbe51d23bc96146ff05);
        assert_eq!(buffer.read_partial_felt252(10, 21), 0xf785ededcd50cd4af80cd37925c7d000bfcc3ae82a);
        assert_eq!(buffer.read_partial_felt252(58, 22), 0xad95039139bd28ddc5a5b40c281c323adfa1046e02f1);
        assert_eq!(buffer.read_partial_felt252(46, 23), 0xd23bc96146ff0552b5898f05ad95039139bd28ddc5a5b4);
        assert_eq!(buffer.read_partial_felt252(35, 24), 0x8c3a38a28fff48460bbe51d23bc96146ff0552b5898f05ad);
        assert_eq!(buffer.read_partial_felt252(21, 25), 0x7925c7d000bfcc3ae82ae4fe06538c3a38a28fff48460bbe51);
        assert_eq!(buffer.read_partial_felt252(33, 26), 0x06538c3a38a28fff48460bbe51d23bc96146ff0552b5898f05ad);
        assert_eq!(buffer.read_partial_felt252(37, 27), 0x38a28fff48460bbe51d23bc96146ff0552b5898f05ad95039139bd);
        assert_eq!(buffer.read_partial_felt252(12, 28), 0xededcd50cd4af80cd37925c7d000bfcc3ae82ae4fe06538c3a38a28f);
        assert_eq!(buffer.read_partial_felt252(1, 29), 0x0b5ac8c69c691daca8f785ededcd50cd4af80cd37925c7d000bfcc3ae8);
        assert_eq!(buffer.read_partial_felt252(13, 30), 0xedcd50cd4af80cd37925c7d000bfcc3ae82ae4fe06538c3a38a28fff4846);
        assert_eq!(buffer.read_partial_felt252(66, 31), 0xc5a5b40c281c323adfa1046e02f1dee6294507d4c7183b257602b3e1a3b298);
        assert_eq!(buffer.hash_sha256(), [0xca9eff19, 0xafc32cbc, 0x57892687, 0xd82fb677, 0xa880bde7, 0xc72b8bf5, 0x32033868, 0x0b79a00b]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xe94d5cad, 0x3d56ab70, 0xf1b86705, 0x250f3791, 0xc0584acb, 0x31cd316b, 0x39e41e7d, 0x992d1707]);
        assert_eq!(buffer.hash_poseidon_range(2, 16), 0x61f2128e52b74f88c9619a4e4c1f3eac3b241be9095a7bc8c1eaa93e6f417b3);
        assert_eq!(buffer.hash_poseidon_range(21, 42), 0x3db114fabd26c2dfbf3a74d9714a00265e39a9eace8d4fb8d6718f914102e4);
        assert_eq!(buffer.hash_poseidon_range(47, 55), 0x1aec4291d4bde4229729e87c1d05cc9838dbdaac5ec93a6200aa11dcf3103a4);
        assert_eq!(buffer.hash_poseidon_range(50, 53), 0x35ed1ff746ef6699e16c9951a2f5c4e22ad2be43636fc57fb2a81ce9e9c0ffa);
        assert_eq!(buffer.hash_poseidon_range(10, 10), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);

        let mut serialized_byte_array = array![0x3, 0x17f31f53e4a7cd5003957f9785cfa62bcda6f0e430044766a6b618ed8d7506, 0xd493cd00c3045c3498b7093b8771645dc1accc636636f94753e2e492c62896, 0x5763e4c03b361d93b37aea1b5c01ed0e7f7d7e6ed155b8c5ed0bad70a54788, 0x8b6da7c562c410c5d49ad58a41, 0xd].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(11), 0x8597);
        assert_eq!(buffer.read_u32_le(15), 0xf0a6cd2b);
        assert_eq!(buffer.read_u64_le(31), 0x345c04c300cd93d4);
        assert_eq!(buffer.read_u256(30), 0x06d493cd00c3045c3498b7093b8771645dc1accc636636f94753e2e492c62896);
        assert_eq!(buffer.read_felt252(16), 0xcda6f0e430044766a6b618ed8d7506d493cd00c3045c3498b7093b8771645d);
        assert_eq!(buffer.read_partial_felt252(101, 1), 0xd4);
        assert_eq!(buffer.read_partial_felt252(47, 2), 0xc1ac);
        assert_eq!(buffer.read_partial_felt252(86, 3), 0xed0bad);
        assert_eq!(buffer.read_partial_felt252(94, 4), 0x6da7c562);
        assert_eq!(buffer.read_partial_felt252(64, 5), 0xe4c03b361d);
        assert_eq!(buffer.read_partial_felt252(45, 6), 0x645dc1accc63);
        assert_eq!(buffer.read_partial_felt252(79, 7), 0x7d7e6ed155b8c5);
        assert_eq!(buffer.read_partial_felt252(17, 8), 0xa6f0e430044766a6);
        assert_eq!(buffer.read_partial_felt252(19, 9), 0xe430044766a6b618ed);
        assert_eq!(buffer.read_partial_felt252(81, 10), 0x6ed155b8c5ed0bad70a5);
        assert_eq!(buffer.read_partial_felt252(28, 11), 0x8d7506d493cd00c3045c34);
        assert_eq!(buffer.read_partial_felt252(13, 12), 0xcfa62bcda6f0e430044766a6);
        assert_eq!(buffer.read_partial_felt252(66, 13), 0x3b361d93b37aea1b5c01ed0e7f);
        assert_eq!(buffer.read_partial_felt252(56, 14), 0xe2e492c628965763e4c03b361d93);
        assert_eq!(buffer.read_partial_felt252(6, 15), 0xcd5003957f9785cfa62bcda6f0e430);
        assert_eq!(buffer.read_partial_felt252(37, 16), 0x5c3498b7093b8771645dc1accc636636);
        assert_eq!(buffer.read_partial_felt252(74, 17), 0x5c01ed0e7f7d7e6ed155b8c5ed0bad70a5);
        assert_eq!(buffer.read_partial_felt252(20, 18), 0x30044766a6b618ed8d7506d493cd00c3045c);
        assert_eq!(buffer.read_partial_felt252(29, 19), 0x7506d493cd00c3045c3498b7093b8771645dc1);
        assert_eq!(buffer.read_partial_felt252(6, 20), 0xcd5003957f9785cfa62bcda6f0e430044766a6b6);
        assert_eq!(buffer.read_partial_felt252(62, 21), 0x5763e4c03b361d93b37aea1b5c01ed0e7f7d7e6ed1);
        assert_eq!(buffer.read_partial_felt252(67, 22), 0x361d93b37aea1b5c01ed0e7f7d7e6ed155b8c5ed0bad);
        assert_eq!(buffer.read_partial_felt252(40, 23), 0xb7093b8771645dc1accc636636f94753e2e492c6289657);
        assert_eq!(buffer.read_partial_felt252(25, 24), 0xb618ed8d7506d493cd00c3045c3498b7093b8771645dc1ac);
        assert_eq!(buffer.read_partial_felt252(5, 25), 0xa7cd5003957f9785cfa62bcda6f0e430044766a6b618ed8d75);
        assert_eq!(buffer.read_partial_felt252(8, 26), 0x03957f9785cfa62bcda6f0e430044766a6b618ed8d7506d493cd);
        assert_eq!(buffer.read_partial_felt252(67, 27), 0x361d93b37aea1b5c01ed0e7f7d7e6ed155b8c5ed0bad70a547888b);
        assert_eq!(buffer.read_partial_felt252(68, 28), 0x1d93b37aea1b5c01ed0e7f7d7e6ed155b8c5ed0bad70a547888b6da7);
        assert_eq!(buffer.read_partial_felt252(27, 29), 0xed8d7506d493cd00c3045c3498b7093b8771645dc1accc636636f94753);
        assert_eq!(buffer.read_partial_felt252(9, 30), 0x957f9785cfa62bcda6f0e430044766a6b618ed8d7506d493cd00c3045c34);
        assert_eq!(buffer.read_partial_felt252(62, 31), 0x5763e4c03b361d93b37aea1b5c01ed0e7f7d7e6ed155b8c5ed0bad70a54788);
        assert_eq!(buffer.hash_sha256(), [0x046a5eef, 0x5568f9c9, 0xf828718a, 0xff380727, 0x46aff130, 0xa186097e, 0x4556d4f9, 0xee0f7d60]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x80d2e907, 0xf0d4f710, 0x70266692, 0xf949fdb8, 0xaef9c2de, 0xfdb522ad, 0x5af11bf6, 0x98531229]);
        assert_eq!(buffer.hash_poseidon_range(92, 94), 0x6deada3299827be74120bd03a621629f629db4d3a2c85939631c6bc5ac6c7f8);
        assert_eq!(buffer.hash_poseidon_range(60, 71), 0x126f533fc8bbaca0614331be7a2a6870ab218f5f09f61275fc90c4251abd6d9);
        assert_eq!(buffer.hash_poseidon_range(79, 83), 0x732c830387f7bb3cad805c101666bebaf70493c4226fff559276dec93841b3d);
        assert_eq!(buffer.hash_poseidon_range(81, 86), 0x7234064a8cf2b2c11c03a9e145c5adc6188d5e904d65221c95c81534287507a);
        assert_eq!(buffer.hash_poseidon_range(75, 100), 0x703de0b93ab9beef15529a020eb53f56d9de57e45d639e6e191e952d319c0f1);

        let mut serialized_byte_array = array![0x3, 0x77de6d0038f85c69e839f58420660f1f4a625e00117d59644b428324793196, 0x53713c96c6d67c1f24981563a1b7b50eb005560b265f4c7059ea62dd11c16f, 0x51938fb66d21f0898f7eb4ec26a37fbd96ac59d83e52b680c23018a644e605, 0xed254f5e3f1ae542dc5bff6ff1750e40d7d6, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(91), 0x5e6);
        assert_eq!(buffer.read_u32_le(8), 0x84f539e8);
        assert_eq!(buffer.read_u64_le(68), 0xa326ecb47e8f89f0);
        assert_eq!(buffer.read_u256(69), 0x898f7eb4ec26a37fbd96ac59d83e52b680c23018a644e605ed254f5e3f1ae542);
        assert_eq!(buffer.read_felt252(0), 0x77de6d0038f85c69e839f58420660f1f4a625e00117d59644b428324793196);
        assert_eq!(buffer.read_partial_felt252(98, 1), 0x1a);
        assert_eq!(buffer.read_partial_felt252(49, 2), 0x560b);
        assert_eq!(buffer.read_partial_felt252(83, 3), 0x52b680);
        assert_eq!(buffer.read_partial_felt252(45, 4), 0xb50eb005);
        assert_eq!(buffer.read_partial_felt252(4, 5), 0x38f85c69e8);
        assert_eq!(buffer.read_partial_felt252(43, 6), 0xa1b7b50eb005);
        assert_eq!(buffer.read_partial_felt252(78, 7), 0x96ac59d83e52b6);
        assert_eq!(buffer.read_partial_felt252(94, 8), 0x254f5e3f1ae542dc);
        assert_eq!(buffer.read_partial_felt252(67, 9), 0x21f0898f7eb4ec26a3);
        assert_eq!(buffer.read_partial_felt252(44, 10), 0xb7b50eb005560b265f4c);
        assert_eq!(buffer.read_partial_felt252(9, 11), 0x39f58420660f1f4a625e00);
        assert_eq!(buffer.read_partial_felt252(24, 12), 0x4b42832479319653713c96c6);
        assert_eq!(buffer.read_partial_felt252(67, 13), 0x21f0898f7eb4ec26a37fbd96ac);
        assert_eq!(buffer.read_partial_felt252(45, 14), 0xb50eb005560b265f4c7059ea62dd);
        assert_eq!(buffer.read_partial_felt252(79, 15), 0xac59d83e52b680c23018a644e605ed);
        assert_eq!(buffer.read_partial_felt252(48, 16), 0x05560b265f4c7059ea62dd11c16f5193);
        assert_eq!(buffer.read_partial_felt252(92, 17), 0x05ed254f5e3f1ae542dc5bff6ff1750e40);
        assert_eq!(buffer.read_partial_felt252(66, 18), 0x6d21f0898f7eb4ec26a37fbd96ac59d83e52);
        assert_eq!(buffer.read_partial_felt252(29, 19), 0x319653713c96c6d67c1f24981563a1b7b50eb0);
        assert_eq!(buffer.read_partial_felt252(50, 20), 0x0b265f4c7059ea62dd11c16f51938fb66d21f089);
        assert_eq!(buffer.read_partial_felt252(15, 21), 0x1f4a625e00117d59644b42832479319653713c96c6);
        assert_eq!(buffer.read_partial_felt252(11, 22), 0x8420660f1f4a625e00117d59644b4283247931965371);
        assert_eq!(buffer.read_partial_felt252(43, 23), 0xa1b7b50eb005560b265f4c7059ea62dd11c16f51938fb6);
        assert_eq!(buffer.read_partial_felt252(18, 24), 0x5e00117d59644b42832479319653713c96c6d67c1f249815);
        assert_eq!(buffer.read_partial_felt252(55, 25), 0x59ea62dd11c16f51938fb66d21f0898f7eb4ec26a37fbd96ac);
        assert_eq!(buffer.read_partial_felt252(81, 26), 0xd83e52b680c23018a644e605ed254f5e3f1ae542dc5bff6ff175);
        assert_eq!(buffer.read_partial_felt252(16, 27), 0x4a625e00117d59644b42832479319653713c96c6d67c1f24981563);
        assert_eq!(buffer.read_partial_felt252(63, 28), 0x938fb66d21f0898f7eb4ec26a37fbd96ac59d83e52b680c23018a644);
        assert_eq!(buffer.read_partial_felt252(48, 29), 0x05560b265f4c7059ea62dd11c16f51938fb66d21f0898f7eb4ec26a37f);
        assert_eq!(buffer.read_partial_felt252(36, 30), 0xd67c1f24981563a1b7b50eb005560b265f4c7059ea62dd11c16f51938fb6);
        assert_eq!(buffer.read_partial_felt252(41, 31), 0x1563a1b7b50eb005560b265f4c7059ea62dd11c16f51938fb66d21f0898f7e);
        assert_eq!(buffer.hash_sha256(), [0x12ab3d6a, 0x21a5233b, 0x18ea0b3b, 0x33926aa0, 0x782d1d2c, 0xe8e43279, 0xdf6c1b3c, 0x74588a39]);
        assert_eq!(buffer.hash_dbl_sha256(), [0xbceaf867, 0xfc054aa3, 0x444e90ed, 0x160409c4, 0x22787068, 0xe724b269, 0x095826c1, 0x7f48bbb4]);
        assert_eq!(buffer.hash_poseidon_range(95, 103), 0x50dc865582003385e3f15ce196c6081cb74f0d95ea97c7625d9b01041b1ac5b);
        assert_eq!(buffer.hash_poseidon_range(76, 94), 0x69f45be47adab7d522671b0510cf9322121a2dccfdf609c70658a188e5bec4);
        assert_eq!(buffer.hash_poseidon_range(89, 96), 0x5532b5eb7cfeca2964e10d8b2848f31a94515bff809b9d1f4ef470ebf3470b2);
        assert_eq!(buffer.hash_poseidon_range(15, 25), 0x31f00124ab347af5f049a262f0f33104223ca2e7092e382178e05ecdfa67edc);
        assert_eq!(buffer.hash_poseidon_range(85, 107), 0x39c29e6bf931f3afe992ebacde13f61522204ee0105359eb89916533253f066);

        let mut serialized_byte_array = array![0x0, 0xf709aca1d9bf8a331a320217f59f87cc9725430b51bc19cc95666b, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(13), 0x879f);
        assert_eq!(buffer.read_u32_le(5), 0x1a338abf);
        assert_eq!(buffer.read_u64_le(7), 0x879ff51702321a33);
        assert_eq!(buffer.read_partial_felt252(4, 1), 0xd9);
        assert_eq!(buffer.read_partial_felt252(6, 2), 0x8a33);
        assert_eq!(buffer.read_partial_felt252(20, 3), 0x51bc19);
        assert_eq!(buffer.read_partial_felt252(17, 4), 0x25430b51);
        assert_eq!(buffer.read_partial_felt252(5, 5), 0xbf8a331a32);
        assert_eq!(buffer.read_partial_felt252(14, 6), 0x87cc9725430b);
        assert_eq!(buffer.read_partial_felt252(6, 7), 0x8a331a320217f5);
        assert_eq!(buffer.read_partial_felt252(17, 8), 0x25430b51bc19cc95);
        assert_eq!(buffer.read_partial_felt252(12, 9), 0xf59f87cc9725430b51);
        assert_eq!(buffer.read_partial_felt252(11, 10), 0x17f59f87cc9725430b51);
        assert_eq!(buffer.read_partial_felt252(12, 11), 0xf59f87cc9725430b51bc19);
        assert_eq!(buffer.read_partial_felt252(1, 12), 0x09aca1d9bf8a331a320217f5);
        assert_eq!(buffer.read_partial_felt252(2, 13), 0xaca1d9bf8a331a320217f59f87);
        assert_eq!(buffer.read_partial_felt252(8, 14), 0x1a320217f59f87cc9725430b51bc);
        assert_eq!(buffer.read_partial_felt252(11, 15), 0x17f59f87cc9725430b51bc19cc9566);
        assert_eq!(buffer.read_partial_felt252(3, 16), 0xa1d9bf8a331a320217f59f87cc972543);
        assert_eq!(buffer.read_partial_felt252(9, 17), 0x320217f59f87cc9725430b51bc19cc9566);
        assert_eq!(buffer.read_partial_felt252(1, 18), 0x09aca1d9bf8a331a320217f59f87cc972543);
        assert_eq!(buffer.read_partial_felt252(1, 19), 0x09aca1d9bf8a331a320217f59f87cc9725430b);
        assert_eq!(buffer.read_partial_felt252(0, 20), 0xf709aca1d9bf8a331a320217f59f87cc9725430b);
        assert_eq!(buffer.read_partial_felt252(1, 21), 0x09aca1d9bf8a331a320217f59f87cc9725430b51bc);
        assert_eq!(buffer.read_partial_felt252(0, 22), 0xf709aca1d9bf8a331a320217f59f87cc9725430b51bc);
        assert_eq!(buffer.read_partial_felt252(0, 23), 0xf709aca1d9bf8a331a320217f59f87cc9725430b51bc19);
        assert_eq!(buffer.read_partial_felt252(2, 24), 0xaca1d9bf8a331a320217f59f87cc9725430b51bc19cc9566);
        assert_eq!(buffer.read_partial_felt252(0, 25), 0xf709aca1d9bf8a331a320217f59f87cc9725430b51bc19cc95);
        assert_eq!(buffer.read_partial_felt252(0, 26), 0xf709aca1d9bf8a331a320217f59f87cc9725430b51bc19cc9566);
        assert_eq!(buffer.read_partial_felt252(0, 27), 0xf709aca1d9bf8a331a320217f59f87cc9725430b51bc19cc95666b);
        assert_eq!(buffer.hash_sha256(), [0xd1b0bc2e, 0xf990bfaa, 0x6f5b5173, 0xa6794b13, 0xe4d3dd8c, 0x6e374f0f, 0xfdb8f6a5, 0x1dc345cd]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x0aa9b8b4, 0xb7b49c4e, 0x3d1f57d0, 0xdba674a0, 0x66ddf078, 0x3f4912a4, 0x6ad278b6, 0xe0fa3973]);
        assert_eq!(buffer.hash_poseidon_range(5, 10), 0xd327df036d568137b3e98cbdeb01de3ef37902882b019c5c2358e194a91807);
        assert_eq!(buffer.hash_poseidon_range(20, 24), 0x42a1ff14c3b578d331fbd6e6e585d6d0984e42bf80eecbeb473409e41691cd8);
        assert_eq!(buffer.hash_poseidon_range(7, 9), 0x3d3221b6e38b26a29d0827c9b088b6619d882baad7f44d0e350725662ff277a);
        assert_eq!(buffer.hash_poseidon_range(20, 23), 0x1850872ce67c99414186bc2db2f167de0230b8bd48010679da72434b577562a);
        assert_eq!(buffer.hash_poseidon_range(21, 24), 0xc6b28b23cdb5e26f5b85be23dcf85c64cbf2b701e3811810166092254c3214);

        let mut serialized_byte_array = array![0x3, 0x4b2beeb640883a2ab9a3d786f6966c714ac6bdc3f5ec33183293af8c551ec6, 0x2c19f3c0501f1a7aacc9c2c489c43c03eebfe676cba1b65a28b7d3ab19d066, 0x7164f3ef73bf5f35b14e9901cbd4ebd862580a02e36d0721aa295d0ca72ccc, 0x8298aa4fbe08bde54c7953e919a53e7236d562b670fc53a87c, 0x19].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(48), 0xe6bf);
        assert_eq!(buffer.read_u32_le(10), 0x96f686d7);
        assert_eq!(buffer.read_u64_le(66), 0x1994eb1355fbf73);
        assert_eq!(buffer.read_u256(63), 0x64f3ef73bf5f35b14e9901cbd4ebd862580a02e36d0721aa295d0ca72ccc8298);
        assert_eq!(buffer.read_felt252(15), 0x714ac6bdc3f5ec33183293af8c551ec62c19f3c0501f1a7aacc9c2c489c43c);
        assert_eq!(buffer.read_partial_felt252(22, 1), 0x33);
        assert_eq!(buffer.read_partial_felt252(112, 2), 0xb670);
        assert_eq!(buffer.read_partial_felt252(48, 3), 0xbfe676);
        assert_eq!(buffer.read_partial_felt252(98, 4), 0x08bde54c);
        assert_eq!(buffer.read_partial_felt252(103, 5), 0x53e919a53e);
        assert_eq!(buffer.read_partial_felt252(7, 6), 0x2ab9a3d786f6);
        assert_eq!(buffer.read_partial_felt252(65, 7), 0xef73bf5f35b14e);
        assert_eq!(buffer.read_partial_felt252(8, 8), 0xb9a3d786f6966c71);
        assert_eq!(buffer.read_partial_felt252(57, 9), 0xd3ab19d0667164f3ef);
        assert_eq!(buffer.read_partial_felt252(57, 10), 0xd3ab19d0667164f3ef73);
        assert_eq!(buffer.read_partial_felt252(83, 11), 0x6d0721aa295d0ca72ccc82);
        assert_eq!(buffer.read_partial_felt252(68, 12), 0x5f35b14e9901cbd4ebd86258);
        assert_eq!(buffer.read_partial_felt252(26, 13), 0xaf8c551ec62c19f3c0501f1a7a);
        assert_eq!(buffer.read_partial_felt252(16, 14), 0x4ac6bdc3f5ec33183293af8c551e);
        assert_eq!(buffer.read_partial_felt252(63, 15), 0x64f3ef73bf5f35b14e9901cbd4ebd8);
        assert_eq!(buffer.read_partial_felt252(83, 16), 0x6d0721aa295d0ca72ccc8298aa4fbe08);
        assert_eq!(buffer.read_partial_felt252(79, 17), 0x580a02e36d0721aa295d0ca72ccc8298aa);
        assert_eq!(buffer.read_partial_felt252(96, 18), 0x4fbe08bde54c7953e919a53e7236d562b670);
        assert_eq!(buffer.read_partial_felt252(23, 19), 0x183293af8c551ec62c19f3c0501f1a7aacc9c2);
        assert_eq!(buffer.read_partial_felt252(90, 20), 0xa72ccc8298aa4fbe08bde54c7953e919a53e7236);
        assert_eq!(buffer.read_partial_felt252(28, 21), 0x551ec62c19f3c0501f1a7aacc9c2c489c43c03eebf);
        assert_eq!(buffer.read_partial_felt252(59, 22), 0x19d0667164f3ef73bf5f35b14e9901cbd4ebd862580a);
        assert_eq!(buffer.read_partial_felt252(64, 23), 0xf3ef73bf5f35b14e9901cbd4ebd862580a02e36d0721aa);
        assert_eq!(buffer.read_partial_felt252(69, 24), 0x35b14e9901cbd4ebd862580a02e36d0721aa295d0ca72ccc);
        assert_eq!(buffer.read_partial_felt252(31, 25), 0x2c19f3c0501f1a7aacc9c2c489c43c03eebfe676cba1b65a28);
        assert_eq!(buffer.read_partial_felt252(61, 26), 0x667164f3ef73bf5f35b14e9901cbd4ebd862580a02e36d0721aa);
        assert_eq!(buffer.read_partial_felt252(56, 27), 0xb7d3ab19d0667164f3ef73bf5f35b14e9901cbd4ebd862580a02e3);
        assert_eq!(buffer.read_partial_felt252(66, 28), 0x73bf5f35b14e9901cbd4ebd862580a02e36d0721aa295d0ca72ccc82);
        assert_eq!(buffer.read_partial_felt252(79, 29), 0x580a02e36d0721aa295d0ca72ccc8298aa4fbe08bde54c7953e919a53e);
        assert_eq!(buffer.read_partial_felt252(84, 30), 0x0721aa295d0ca72ccc8298aa4fbe08bde54c7953e919a53e7236d562b670);
        assert_eq!(buffer.read_partial_felt252(50, 31), 0x76cba1b65a28b7d3ab19d0667164f3ef73bf5f35b14e9901cbd4ebd862580a);
        assert_eq!(buffer.hash_sha256(), [0x30a558af, 0x79972304, 0x34210ea3, 0x6b784725, 0x2b91420b, 0xe631805c, 0xc7793b74, 0x2992d189]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x7abe9c4f, 0x6bed1e1b, 0x39a98870, 0x7fad1e28, 0xfa1fe12a, 0xf1cb79df, 0x12ad6bf6, 0x4608321f]);
        assert_eq!(buffer.hash_poseidon_range(73, 95), 0x78ee2693964b26637e95c77027e58acba458f586cbdfbd5e3f368a81695bcb1);
        assert_eq!(buffer.hash_poseidon_range(95, 109), 0x492e6dd58c7eecc556b3232c849a7466d7806ca5265c1bcb018c20443974ec4);
        assert_eq!(buffer.hash_poseidon_range(67, 84), 0x2117dd29eb2ffd25557fa8a6dfa122b8748c432f330031442c3c85b3045441c);
        assert_eq!(buffer.hash_poseidon_range(72, 89), 0x5a4862d7644fff27ed81d06a72f0a0809b3813b20c56716f16ad3ed59bdbb42);
        assert_eq!(buffer.hash_poseidon_range(6, 115), 0x3371549fb00a94349ab3f4874d0d9a6a2e4b63732c58a7c1adf8f51a825523a);

        let mut serialized_byte_array = array![0x2, 0xa7c6ac05072cba343cab305ee7bceb57ccb8485807787deb6269a23f6b6048, 0xfedd31427e6fa2b141db7692f29434a27a884e368d3194d863ddf28defadf5, 0x3937d4, 0x3].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(15), 0xcc57);
        assert_eq!(buffer.read_u32_le(55), 0x8df2dd63);
        assert_eq!(buffer.read_u64_le(24), 0xfe48606b3fa26962);
        assert_eq!(buffer.read_u256(21), 0x787deb6269a23f6b6048fedd31427e6fa2b141db7692f29434a27a884e368d31);
        assert_eq!(buffer.read_felt252(18), 0x485807787deb6269a23f6b6048fedd31427e6fa2b141db7692f29434a27a88);
        assert_eq!(buffer.read_partial_felt252(32, 1), 0xdd);
        assert_eq!(buffer.read_partial_felt252(17, 2), 0xb848);
        assert_eq!(buffer.read_partial_felt252(45, 3), 0x34a27a);
        assert_eq!(buffer.read_partial_felt252(57, 4), 0xf28defad);
        assert_eq!(buffer.read_partial_felt252(54, 5), 0xd863ddf28d);
        assert_eq!(buffer.read_partial_felt252(36, 6), 0x6fa2b141db76);
        assert_eq!(buffer.read_partial_felt252(45, 7), 0x34a27a884e368d);
        assert_eq!(buffer.read_partial_felt252(44, 8), 0x9434a27a884e368d);
        assert_eq!(buffer.read_partial_felt252(36, 9), 0x6fa2b141db7692f294);
        assert_eq!(buffer.read_partial_felt252(28, 10), 0x6b6048fedd31427e6fa2);
        assert_eq!(buffer.read_partial_felt252(10, 11), 0x305ee7bceb57ccb8485807);
        assert_eq!(buffer.read_partial_felt252(47, 12), 0x7a884e368d3194d863ddf28d);
        assert_eq!(buffer.read_partial_felt252(6, 13), 0xba343cab305ee7bceb57ccb848);
        assert_eq!(buffer.read_partial_felt252(13, 14), 0xbceb57ccb8485807787deb6269a2);
        assert_eq!(buffer.read_partial_felt252(10, 15), 0x305ee7bceb57ccb8485807787deb62);
        assert_eq!(buffer.read_partial_felt252(26, 16), 0xa23f6b6048fedd31427e6fa2b141db76);
        assert_eq!(buffer.read_partial_felt252(46, 17), 0xa27a884e368d3194d863ddf28defadf539);
        assert_eq!(buffer.read_partial_felt252(16, 18), 0xccb8485807787deb6269a23f6b6048fedd31);
        assert_eq!(buffer.read_partial_felt252(9, 19), 0xab305ee7bceb57ccb8485807787deb6269a23f);
        assert_eq!(buffer.read_partial_felt252(0, 20), 0xa7c6ac05072cba343cab305ee7bceb57ccb84858);
        assert_eq!(buffer.read_partial_felt252(12, 21), 0xe7bceb57ccb8485807787deb6269a23f6b6048fedd);
        assert_eq!(buffer.read_partial_felt252(11, 22), 0x5ee7bceb57ccb8485807787deb6269a23f6b6048fedd);
        assert_eq!(buffer.read_partial_felt252(16, 23), 0xccb8485807787deb6269a23f6b6048fedd31427e6fa2b1);
        assert_eq!(buffer.read_partial_felt252(38, 24), 0xb141db7692f29434a27a884e368d3194d863ddf28defadf5);
        assert_eq!(buffer.read_partial_felt252(10, 25), 0x305ee7bceb57ccb8485807787deb6269a23f6b6048fedd3142);
        assert_eq!(buffer.read_partial_felt252(5, 26), 0x2cba343cab305ee7bceb57ccb8485807787deb6269a23f6b6048);
        assert_eq!(buffer.read_partial_felt252(19, 27), 0x5807787deb6269a23f6b6048fedd31427e6fa2b141db7692f29434);
        assert_eq!(buffer.read_partial_felt252(23, 28), 0xeb6269a23f6b6048fedd31427e6fa2b141db7692f29434a27a884e36);
        assert_eq!(buffer.read_partial_felt252(31, 29), 0xfedd31427e6fa2b141db7692f29434a27a884e368d3194d863ddf28def);
        assert_eq!(buffer.read_partial_felt252(7, 30), 0x343cab305ee7bceb57ccb8485807787deb6269a23f6b6048fedd31427e6f);
        assert_eq!(buffer.read_partial_felt252(16, 31), 0xccb8485807787deb6269a23f6b6048fedd31427e6fa2b141db7692f29434a2);
        assert_eq!(buffer.hash_sha256(), [0x074573f7, 0xfbefe4c2, 0x690fab5d, 0x44dc00d0, 0x065c62ae, 0x383e7679, 0x359375e4, 0xefe23bfc]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x0b42a497, 0x38456eda, 0xbe583070, 0x79c01ebd, 0xacaa88a9, 0x2b1ffcb8, 0x003594be, 0xe154fdda]);
        assert_eq!(buffer.hash_poseidon_range(50, 63), 0x5e8e92820f887da2d35ea83375bf3cc6b6eafaa35ad8652c183f1be81d18294);
        assert_eq!(buffer.hash_poseidon_range(31, 49), 0x654202c888e61ab95fdeeccbfb3f6144baea06d56f663f34bf111c043b80bc0);
        assert_eq!(buffer.hash_poseidon_range(13, 62), 0xb7bd74a3bb795edfd0509e35636c97d2d7184f15e433073686bb6a8a7ab44d);
        assert_eq!(buffer.hash_poseidon_range(25, 40), 0x1cc72db74330f41ed80745665178caeb5c36cacc0550e76c637f5b59d8459f5);
        assert_eq!(buffer.hash_poseidon_range(6, 57), 0x6e9b1ec2c35506f9891952caff2d9675657feba8bf719a26519d15c00c7bba5);

        let mut serialized_byte_array = array![0x1, 0x0093a7cac721c3b95d52a1ae5e31306986d589e763be70cc4e058e894ac9cd, 0x78834b9de3eb4ac8, 0x8].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(36), 0x4aeb);
        assert_eq!(buffer.read_u32_le(7), 0xa1525db9);
        assert_eq!(buffer.read_u64_le(7), 0x30315eaea1525db9);
        assert_eq!(buffer.read_u256(5), 0x21c3b95d52a1ae5e31306986d589e763be70cc4e058e894ac9cd78834b9de3eb);
        assert_eq!(buffer.read_felt252(5), 0x21c3b95d52a1ae5e31306986d589e763be70cc4e058e894ac9cd78834b9de3);
        assert_eq!(buffer.read_partial_felt252(37, 1), 0x4a);
        assert_eq!(buffer.read_partial_felt252(34, 2), 0x9de3);
        assert_eq!(buffer.read_partial_felt252(28, 3), 0x4ac9cd);
        assert_eq!(buffer.read_partial_felt252(20, 4), 0x63be70cc);
        assert_eq!(buffer.read_partial_felt252(9, 5), 0x52a1ae5e31);
        assert_eq!(buffer.read_partial_felt252(30, 6), 0xcd78834b9de3);
        assert_eq!(buffer.read_partial_felt252(4, 7), 0xc721c3b95d52a1);
        assert_eq!(buffer.read_partial_felt252(7, 8), 0xb95d52a1ae5e3130);
        assert_eq!(buffer.read_partial_felt252(29, 9), 0xc9cd78834b9de3eb4a);
        assert_eq!(buffer.read_partial_felt252(8, 10), 0x5d52a1ae5e31306986d5);
        assert_eq!(buffer.read_partial_felt252(13, 11), 0x31306986d589e763be70cc);
        assert_eq!(buffer.read_partial_felt252(4, 12), 0xc721c3b95d52a1ae5e313069);
        assert_eq!(buffer.read_partial_felt252(17, 13), 0xd589e763be70cc4e058e894ac9);
        assert_eq!(buffer.read_partial_felt252(20, 14), 0x63be70cc4e058e894ac9cd78834b);
        assert_eq!(buffer.read_partial_felt252(2, 15), 0xa7cac721c3b95d52a1ae5e31306986);
        assert_eq!(buffer.read_partial_felt252(10, 16), 0xa1ae5e31306986d589e763be70cc4e05);
        assert_eq!(buffer.read_partial_felt252(1, 17), 0x93a7cac721c3b95d52a1ae5e31306986d5);
        assert_eq!(buffer.read_partial_felt252(13, 18), 0x31306986d589e763be70cc4e058e894ac9cd);
        assert_eq!(buffer.read_partial_felt252(8, 19), 0x5d52a1ae5e31306986d589e763be70cc4e058e);
        assert_eq!(buffer.read_partial_felt252(14, 20), 0x306986d589e763be70cc4e058e894ac9cd78834b);
        assert_eq!(buffer.read_partial_felt252(12, 21), 0x5e31306986d589e763be70cc4e058e894ac9cd7883);
        assert_eq!(buffer.read_partial_felt252(4, 22), 0xc721c3b95d52a1ae5e31306986d589e763be70cc4e05);
        assert_eq!(buffer.read_partial_felt252(1, 23), 0x93a7cac721c3b95d52a1ae5e31306986d589e763be70cc);
        assert_eq!(buffer.read_partial_felt252(3, 24), 0xcac721c3b95d52a1ae5e31306986d589e763be70cc4e058e);
        assert_eq!(buffer.read_partial_felt252(5, 25), 0x21c3b95d52a1ae5e31306986d589e763be70cc4e058e894ac9);
        assert_eq!(buffer.read_partial_felt252(12, 26), 0x5e31306986d589e763be70cc4e058e894ac9cd78834b9de3eb4a);
        assert_eq!(buffer.read_partial_felt252(5, 27), 0x21c3b95d52a1ae5e31306986d589e763be70cc4e058e894ac9cd78);
        assert_eq!(buffer.read_partial_felt252(2, 28), 0xa7cac721c3b95d52a1ae5e31306986d589e763be70cc4e058e894ac9);
        assert_eq!(buffer.read_partial_felt252(9, 29), 0x52a1ae5e31306986d589e763be70cc4e058e894ac9cd78834b9de3eb4a);
        assert_eq!(buffer.read_partial_felt252(1, 30), 0x93a7cac721c3b95d52a1ae5e31306986d589e763be70cc4e058e894ac9cd);
        assert_eq!(buffer.read_partial_felt252(0, 31), 0x0093a7cac721c3b95d52a1ae5e31306986d589e763be70cc4e058e894ac9cd);
        assert_eq!(buffer.hash_sha256(), [0xc923e725, 0xabdb28c4, 0x677dd92d, 0xb93d106a, 0x2b023138, 0x19e945c3, 0x27130124, 0x40f72c98]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x7c0d0b05, 0x7924fae4, 0xbfffc885, 0x2d0d05a5, 0x455abd0f, 0x3e1cd90d, 0x1f442f78, 0x7ec5a428]);
        assert_eq!(buffer.hash_poseidon_range(13, 19), 0x689157e13448cf9f3b4c2384f06e5b5cc34cf60bba351c4036f63550f77848b);
        assert_eq!(buffer.hash_poseidon_range(16, 19), 0x7ee47c6c65381cdd5d856bea6399b2bfc8da0fe672ea03d6506745ed468af49);
        assert_eq!(buffer.hash_poseidon_range(2, 4), 0x5dad806af26597d6cabca9382453e5605a9efe91f11c326e7b420f95e9b0a94);
        assert_eq!(buffer.hash_poseidon_range(24, 32), 0x458b8f6af01719b58fa05a53f4ed8c316d19cdb9734001f6c307d82897d55f4);
        assert_eq!(buffer.hash_poseidon_range(36, 37), 0x2be14807da643c2c8ac5fe7cd455b10f2bd221671c1d03eae5bf33bbbf726f4);

        let mut serialized_byte_array = array![0x3, 0x6937b3c25baef4df208e9aca9c1f2f2ad74a281f23669d3282e9b9a3fd8718, 0x94f53e39adf22e65662b163346d5907e7275db359074eb2e553b1ac39bfa42, 0xebf05ce5a3f8b745d03e4ffa280f8f02c8d4cdd8246057f92aa9b910d30ca8, 0xa955c85d7952e98d048bf3e8cb, 0xd].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u16_le(36), 0x2ef2);
        assert_eq!(buffer.read_u32_le(29), 0xf5941887);
        assert_eq!(buffer.read_u64_le(39), 0x7e90d54633162b66);
        assert_eq!(buffer.read_u256(35), 0xadf22e65662b163346d5907e7275db359074eb2e553b1ac39bfa42ebf05ce5a3);
        assert_eq!(buffer.read_felt252(68), 0xb745d03e4ffa280f8f02c8d4cdd8246057f92aa9b910d30ca8a955c85d7952);
        assert_eq!(buffer.read_partial_felt252(75, 1), 0x0f);
        assert_eq!(buffer.read_partial_felt252(9, 2), 0x8e9a);
        assert_eq!(buffer.read_partial_felt252(0, 3), 0x6937b3);
        assert_eq!(buffer.read_partial_felt252(58, 4), 0xc39bfa42);
        assert_eq!(buffer.read_partial_felt252(55, 5), 0x553b1ac39b);
        assert_eq!(buffer.read_partial_felt252(58, 6), 0xc39bfa42ebf0);
        assert_eq!(buffer.read_partial_felt252(62, 7), 0xebf05ce5a3f8b7);
        assert_eq!(buffer.read_partial_felt252(12, 8), 0x9c1f2f2ad74a281f);
        assert_eq!(buffer.read_partial_felt252(69, 9), 0x45d03e4ffa280f8f02);
        assert_eq!(buffer.read_partial_felt252(68, 10), 0xb745d03e4ffa280f8f02);
        assert_eq!(buffer.read_partial_felt252(5, 11), 0xaef4df208e9aca9c1f2f2a);
        assert_eq!(buffer.read_partial_felt252(33, 12), 0x3e39adf22e65662b163346d5);
        assert_eq!(buffer.read_partial_felt252(42, 13), 0x3346d5907e7275db359074eb2e);
        assert_eq!(buffer.read_partial_felt252(87, 14), 0xa9b910d30ca8a955c85d7952e98d);
        assert_eq!(buffer.read_partial_felt252(23, 15), 0x3282e9b9a3fd871894f53e39adf22e);
        assert_eq!(buffer.read_partial_felt252(0, 16), 0x6937b3c25baef4df208e9aca9c1f2f2a);
        assert_eq!(buffer.read_partial_felt252(68, 17), 0xb745d03e4ffa280f8f02c8d4cdd8246057);
        assert_eq!(buffer.read_partial_felt252(61, 18), 0x42ebf05ce5a3f8b745d03e4ffa280f8f02c8);
        assert_eq!(buffer.read_partial_felt252(30, 19), 0x1894f53e39adf22e65662b163346d5907e7275);
        assert_eq!(buffer.read_partial_felt252(6, 20), 0xf4df208e9aca9c1f2f2ad74a281f23669d3282e9);
        assert_eq!(buffer.read_partial_felt252(7, 21), 0xdf208e9aca9c1f2f2ad74a281f23669d3282e9b9a3);
        assert_eq!(buffer.read_partial_felt252(79, 22), 0xd4cdd8246057f92aa9b910d30ca8a955c85d7952e98d);
        assert_eq!(buffer.read_partial_felt252(73, 23), 0xfa280f8f02c8d4cdd8246057f92aa9b910d30ca8a955c8);
        assert_eq!(buffer.read_partial_felt252(36, 24), 0xf22e65662b163346d5907e7275db359074eb2e553b1ac39b);
        assert_eq!(buffer.read_partial_felt252(67, 25), 0xf8b745d03e4ffa280f8f02c8d4cdd8246057f92aa9b910d30c);
        assert_eq!(buffer.read_partial_felt252(24, 26), 0x82e9b9a3fd871894f53e39adf22e65662b163346d5907e7275db);
        assert_eq!(buffer.read_partial_felt252(42, 27), 0x3346d5907e7275db359074eb2e553b1ac39bfa42ebf05ce5a3f8b7);
        assert_eq!(buffer.read_partial_felt252(50, 28), 0x359074eb2e553b1ac39bfa42ebf05ce5a3f8b745d03e4ffa280f8f02);
        assert_eq!(buffer.read_partial_felt252(54, 29), 0x2e553b1ac39bfa42ebf05ce5a3f8b745d03e4ffa280f8f02c8d4cdd824);
        assert_eq!(buffer.read_partial_felt252(23, 30), 0x3282e9b9a3fd871894f53e39adf22e65662b163346d5907e7275db359074);
        assert_eq!(buffer.read_partial_felt252(3, 31), 0xc25baef4df208e9aca9c1f2f2ad74a281f23669d3282e9b9a3fd871894f53e);
        assert_eq!(buffer.hash_sha256(), [0xacf192d0, 0x3e9b8457, 0x4503b92d, 0x03901ecc, 0x980f1c90, 0x34d0948d, 0x5aca0981, 0x5c59dcd3]);
        assert_eq!(buffer.hash_dbl_sha256(), [0x81dbd7c0, 0x556da504, 0x6795b431, 0x0cac5013, 0x2b147d62, 0xd81f62c1, 0xc42cb54a, 0x5cb0f62f]);
        assert_eq!(buffer.hash_poseidon_range(57, 104), 0x9be9a3b6abc25d68f9fab961512c251b45d6e696dda6a4270c479a64ddfdd3);
        assert_eq!(buffer.hash_poseidon_range(1, 10), 0x6f616da066f4ecf1488753361226b7cf2408659043b167906f03c3425e3bea2);
        assert_eq!(buffer.hash_poseidon_range(34, 57), 0x8be29677ed9c0a5c58b50aa62ffee2be03808ecdb14415d9106d02fa7b873f);
        assert_eq!(buffer.hash_poseidon_range(65, 72), 0x20c18972ee99894a6c72b45f2784b676fc28491d2e033374ff0268bfabefcd5);
        assert_eq!(buffer.hash_poseidon_range(15, 57), 0x996f1c3ce18e5a7ee131ed47bc571193374cb52c8d9c9834a2ba183d721bca);
    }

    #[test]
    fn test_random_access() {
        // Random access test cases testing random reads

        let mut serialized_byte_array = array![0x1, 0xbd04e4648d87d6ad7b09b877938816538e7268186a7bd274200d8a80c5b9fb, 0x00e45a7ba500dd51666bb553d641a1326bb72087b12d4bd2be4c4a982d, 0x1d].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u256(19), 0x186a7bd274200d8a80c5b9fb00e45a7ba500dd51666bb553d641a1326bb72087);
        assert_eq!(buffer.read_partial_felt252(5, 1), 0x87);
        assert_eq!(buffer.read_partial_felt252(14, 21), 0x16538e7268186a7bd274200d8a80c5b9fb00e45a7b);
        assert_eq!(buffer.read_partial_felt252(1, 31), 0x04e4648d87d6ad7b09b877938816538e7268186a7bd274200d8a80c5b9fb00);
        assert_eq!(buffer.read_partial_felt252(17, 30), 0x7268186a7bd274200d8a80c5b9fb00e45a7ba500dd51666bb553d641a132);
        assert_eq!(buffer.read_partial_felt252(17, 11), 0x7268186a7bd274200d8a80);
        assert_eq!(buffer.read_partial_felt252(6, 18), 0xd6ad7b09b877938816538e7268186a7bd274);
        assert_eq!(buffer.read_partial_felt252(32, 19), 0xe45a7ba500dd51666bb553d641a1326bb72087);
        assert_eq!(buffer.read_partial_felt252(31, 27), 0x00e45a7ba500dd51666bb553d641a1326bb72087b12d4bd2be4c4a);
        assert_eq!(buffer.read_u256(15), 0x538e7268186a7bd274200d8a80c5b9fb00e45a7ba500dd51666bb553d641a132);

        let mut serialized_byte_array = array![0x0, 0xd1b1001230813fb0066bf76db2f4ea1e87af5a6116dd08, 0x17].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(9, 13), 0x6bf76db2f4ea1e87af5a6116dd);
        assert_eq!(buffer.read_u16_le(19), 0x1661);
        assert_eq!(buffer.read_partial_felt252(9, 7), 0x6bf76db2f4ea1e);
        assert_eq!(buffer.read_u64_le(10), 0xaf871eeaf4b26df7);
        assert_eq!(buffer.hash_poseidon_range(11, 19), 0x73807d5d52e3fd6bcd2dfa4e244fc4cc70a77cdc877586d47861f91b3d3cb68);
        assert_eq!(buffer.read_partial_felt252(3, 15), 0x1230813fb0066bf76db2f4ea1e87af);
        assert_eq!(buffer.read_partial_felt252(0, 23), 0xd1b1001230813fb0066bf76db2f4ea1e87af5a6116dd08);

        let mut serialized_byte_array = array![0x1, 0x49162ffb62a133bd13b6a9bd53901fcb23dbcfb69273c982c44209a0b6ced3, 0xbdf595a69a0ba4a4613c97fa84e3c03ae6da34, 0x13].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(13, 21), 0x901fcb23dbcfb69273c982c44209a0b6ced3bdf595);
        assert_eq!(buffer.read_partial_felt252(26, 6), 0x09a0b6ced3bd);
        assert_eq!(buffer.read_partial_felt252(21, 26), 0x73c982c44209a0b6ced3bdf595a69a0ba4a4613c97fa84e3c03a);
        assert_eq!(buffer.read_partial_felt252(9, 30), 0xb6a9bd53901fcb23dbcfb69273c982c44209a0b6ced3bdf595a69a0ba4a4);
        assert_eq!(buffer.read_partial_felt252(25, 2), 0x4209);
        assert_eq!(buffer.read_partial_felt252(5, 5), 0xa133bd13b6);
        assert_eq!(buffer.read_u32_le(33), 0xb9aa695);
        assert_eq!(buffer.read_partial_felt252(21, 24), 0x73c982c44209a0b6ced3bdf595a69a0ba4a4613c97fa84e3);
        assert_eq!(buffer.read_partial_felt252(35, 4), 0x9a0ba4a4);
        assert_eq!(buffer.read_partial_felt252(6, 12), 0x33bd13b6a9bd53901fcb23db);

        let mut serialized_byte_array = array![0x3, 0xbc7e9bd88e534b37e5599e97a988aed1a9fa9faa3a8dabdfdc0252f0062317, 0xc16735ba0e9542610778dd3b4b159a1345dcc55c300e0ab099e27072ac0bcc, 0x25b9373ec15dc036bb8d0929935ce9b93bb391573e8307dc540b1be6216a08, 0xfb7e0e5a8d4a0286efde9ce30715e2, 0xf].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(87, 14), 0x0b1be6216a08fb7e0e5a8d4a0286);
        assert_eq!(buffer.hash_poseidon_range(19, 25), 0x6c60ed5f0323f53725c99a46ac8285e85c0b2fcaaf537ed52f61db37813a635);
        assert_eq!(buffer.read_partial_felt252(94, 9), 0x7e0e5a8d4a0286efde);
        assert_eq!(buffer.read_partial_felt252(66, 30), 0xc15dc036bb8d0929935ce9b93bb391573e8307dc540b1be6216a08fb7e0e);
        assert_eq!(buffer.read_partial_felt252(78, 20), 0x3bb391573e8307dc540b1be6216a08fb7e0e5a8d);
        assert_eq!(buffer.hash_poseidon_range(26, 105), 0x6abda6047130b3b18f2e5382ce74d219356d2d6f0310741781a014c4fcc138e);
        assert_eq!(buffer.read_partial_felt252(14, 31), 0xaed1a9fa9faa3a8dabdfdc0252f0062317c16735ba0e9542610778dd3b4b15);
        assert_eq!(buffer.read_partial_felt252(14, 29), 0xaed1a9fa9faa3a8dabdfdc0252f0062317c16735ba0e9542610778dd3b);
        assert_eq!(buffer.read_u16_le(54), 0x99b0);
        assert_eq!(buffer.read_u64_le(82), 0xe61b0b54dc07833e);

        let mut serialized_byte_array = array![0x2, 0x80047049e8775f8e570dd44924f9c71c731036329dc90b8abfcaba4b31939e, 0x8c2e10bb9f1eed2f7d80d0672e374fa0d450b0d1c28138066431d6fc3566d7, 0x9da0edee39253a0bf705618fd7573025a151, 0x12].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_u64_le(3), 0xd40d578e5f77e849);
        assert_eq!(buffer.read_u32_le(39), 0x67d0807d);
        assert_eq!(buffer.read_partial_felt252(26, 23), 0xba4b31939e8c2e10bb9f1eed2f7d80d0672e374fa0d450);
        assert_eq!(buffer.read_partial_felt252(63, 8), 0xa0edee39253a0bf7);
        assert_eq!(buffer.read_u256(32), 0x2e10bb9f1eed2f7d80d0672e374fa0d450b0d1c28138066431d6fc3566d79da0);
        assert_eq!(buffer.read_partial_felt252(52, 8), 0x8138066431d6fc35);
        assert_eq!(buffer.read_partial_felt252(39, 29), 0x7d80d0672e374fa0d450b0d1c28138066431d6fc3566d79da0edee3925);
        assert_eq!(buffer.read_partial_felt252(41, 24), 0xd0672e374fa0d450b0d1c28138066431d6fc3566d79da0ed);
        assert_eq!(buffer.read_partial_felt252(7, 27), 0x8e570dd44924f9c71c731036329dc90b8abfcaba4b31939e8c2e10);
        assert_eq!(buffer.read_partial_felt252(61, 9), 0xd79da0edee39253a0b);

        let mut serialized_byte_array = array![0x0, 0x2d5dd5628af54487bb4ff03880, 0xd].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(2, 9), 0xd5628af54487bb4ff0);
        assert_eq!(buffer.read_partial_felt252(0, 13), 0x2d5dd5628af54487bb4ff03880);
        assert_eq!(buffer.hash_poseidon_range(10, 12), 0x5a73c14395767e370be4becc4c8f9b98e9b259d0c987f79b618504bacb5ae2c);
        assert_eq!(buffer.read_partial_felt252(1, 10), 0x5dd5628af54487bb4ff0);

        let mut serialized_byte_array = array![0x2, 0x67c7f6e29dcfea8b9ea3843e25ca6ee1f8563c6be1141d079ab1cedc5ae9f3, 0xaf04bdf7a4ce435662569c9ef628d7de0b12a93b2ee54ee6529285373225eb, 0x6a08ac7cb9de633c8e, 0x9].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(39, 18), 0x62569c9ef628d7de0b12a93b2ee54ee65292);
        assert_eq!(buffer.read_partial_felt252(6, 17), 0xea8b9ea3843e25ca6ee1f8563c6be1141d);
        assert_eq!(buffer.read_partial_felt252(18, 12), 0x3c6be1141d079ab1cedc5ae9);
        assert_eq!(buffer.read_partial_felt252(18, 26), 0x3c6be1141d079ab1cedc5ae9f3af04bdf7a4ce435662569c9ef6);
        assert_eq!(buffer.read_partial_felt252(40, 17), 0x569c9ef628d7de0b12a93b2ee54ee65292);
        assert_eq!(buffer.read_u64_le(62), 0x3c63deb97cac086a);
        assert_eq!(buffer.read_partial_felt252(55, 12), 0x529285373225eb6a08ac7cb9);
        assert_eq!(buffer.read_partial_felt252(44, 18), 0x28d7de0b12a93b2ee54ee6529285373225eb);
        assert_eq!(buffer.read_partial_felt252(3, 13), 0xe29dcfea8b9ea3843e25ca6ee1);
        assert_eq!(buffer.read_partial_felt252(36, 18), 0xce435662569c9ef628d7de0b12a93b2ee54e);

        let mut serialized_byte_array = array![0x2, 0x4abd5cf5b7b581e48aebc3f588e41e118de4d0a81d62eb81df8cd78f2f6339, 0xbd4d530ed2f93c59585fe0c32b3f802f84d0e4c46a977954c5314a519d05e7, 0xdde2994a22508929be14fb2e2babafe035e9616ad58f91bfac, 0x19].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(50, 26), 0xc46a977954c5314a519d05e7dde2994a22508929be14fb2e2bab);
        assert_eq!(buffer.read_partial_felt252(31, 31), 0xbd4d530ed2f93c59585fe0c32b3f802f84d0e4c46a977954c5314a519d05e7);
        assert_eq!(buffer.read_partial_felt252(5, 13), 0xb581e48aebc3f588e41e118de4);
        assert_eq!(buffer.read_partial_felt252(33, 2), 0x530e);
        assert_eq!(buffer.read_partial_felt252(3, 24), 0xf5b7b581e48aebc3f588e41e118de4d0a81d62eb81df8cd7);
        assert_eq!(buffer.read_partial_felt252(0, 8), 0x4abd5cf5b7b581e4);
        assert_eq!(buffer.read_partial_felt252(38, 3), 0x59585f);
        assert_eq!(buffer.read_partial_felt252(59, 14), 0x9d05e7dde2994a22508929be14fb);
        assert_eq!(buffer.read_partial_felt252(0, 6), 0x4abd5cf5b7b5);
        assert_eq!(buffer.read_partial_felt252(7, 30), 0xe48aebc3f588e41e118de4d0a81d62eb81df8cd78f2f6339bd4d530ed2f9);

        let mut serialized_byte_array = array![0x2, 0x7658e87f59ea854b37d5b3221c700a1e4f2a1bbcc5c3beccf6f276cb538ee7, 0xd34e212c152ae3bc618ec956f4fc5e328e4f82ff04742a0bba7f980b28de42, 0xdae7123891690fdef108aec94641e013, 0x10].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(22, 6), 0xbeccf6f276cb);
        assert_eq!(buffer.read_partial_felt252(49, 15), 0x82ff04742a0bba7f980b28de42dae7);
        assert_eq!(buffer.read_partial_felt252(62, 12), 0xdae7123891690fdef108aec9);
        assert_eq!(buffer.read_u16_le(57), 0xb98);
        assert_eq!(buffer.read_partial_felt252(4, 17), 0x59ea854b37d5b3221c700a1e4f2a1bbcc5);
        assert_eq!(buffer.read_partial_felt252(41, 7), 0xc956f4fc5e328e);
        assert_eq!(buffer.read_partial_felt252(3, 23), 0x7f59ea854b37d5b3221c700a1e4f2a1bbcc5c3beccf6f2);
        assert_eq!(buffer.read_partial_felt252(7, 29), 0x4b37d5b3221c700a1e4f2a1bbcc5c3beccf6f276cb538ee7d34e212c15);
        assert_eq!(buffer.read_felt252(36), 0x2ae3bc618ec956f4fc5e328e4f82ff04742a0bba7f980b28de42dae7123891);
        assert_eq!(buffer.read_partial_felt252(28, 14), 0x538ee7d34e212c152ae3bc618ec9);

        let mut serialized_byte_array = array![0x0, 0xe133, 0x2].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        assert_eq!(buffer.read_partial_felt252(0, 2), 0xe133);
    }

    // Random access out of bounds reads

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u16_le() {
        let mut serialized_byte_array = array![0x0, 0x6e1c3e34ea05188a10b0137ed6efaea1761cbaea4195080a, 0x18].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u16_le(24);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u32_le() {
        let mut serialized_byte_array = array![0x0, 0x7eca89be9cf7ad27bed36b0ca77182cf8188c2909f2e5ebc88da1196, 0x1c].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u32_le(25);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u64_le() {
        let mut serialized_byte_array = array![0x0, 0x1469765fbcbca37ae3f408b1b3141e35d7455910770dc0, 0x17].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u64_le(21);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_u256() {
        let mut serialized_byte_array = array![0x1, 0xfca96e07afceb8b467dbdd0994320cb4b2586a71d1bcb18c405eaa12c0085f, 0x618ffd1e7a2fe540ea338f48efdad49e, 0x10].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_u256(26);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252() {
        let mut serialized_byte_array = array![0x1, 0xc9f5fc7d100c36959928c06a3e84e17fe916957867fd4a2f35eade45ebd14a, 0xa3d1200aa5bdbbd4, 0x8].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_felt252(18);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_1b() {
        let mut serialized_byte_array = array![0x0, 0x36c66e34d9c63903e72d6646, 0xc].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(12, 1);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_2b() {
        let mut serialized_byte_array = array![0x0, 0x4aabda10c51e28a65226cec9b898778002c5bf3f9a7cb2bfb43bc8, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(26, 2);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_3b() {
        let mut serialized_byte_array = array![0x0, 0x069ed9591e89b1c9b407f2b24785de130814d0, 0x13].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(18, 3);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_4b() {
        let mut serialized_byte_array = array![0x0, 0x9e2321024ef8113e22724982e42e4564086ad5d7cff7, 0x16].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(21, 4);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_5b() {
        let mut serialized_byte_array = array![0x1, 0x632f5f6b800345393b4de363518889dee4176570232b6b27b914e10ecd16a4, 0x92a05f, 0x3].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(32, 5);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_6b() {
        let mut serialized_byte_array = array![0x0, 0xe60010099403abf3d43989d15482da45a7118d66a72e6f91e1, 0x19].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(22, 6);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_7b() {
        let mut serialized_byte_array = array![0x0, 0x7cd49992266ac222ecc38c048e4a7917aad27e, 0x13].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(19, 7);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_8b() {
        let mut serialized_byte_array = array![0x0, 0x356e652f5d7c1f50e9807f46cc, 0xd].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(11, 8);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_9b() {
        let mut serialized_byte_array = array![0x0, 0x9ed035cc2d69e011755ea29d707575f7ed8539, 0x13].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(13, 9);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_10b() {
        let mut serialized_byte_array = array![0x0, 0x9c7a672156e5986e6e96e1, 0xb].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(10, 10);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_11b() {
        let mut serialized_byte_array = array![0x0, 0x15779033db9fef5f324736e1670d68eb56cba5aa2e19, 0x16].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(17, 11);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_12b() {
        let mut serialized_byte_array = array![0x0, 0x07152f5c0fa193e90797cf064bc1, 0xe].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(13, 12);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_13b() {
        let mut serialized_byte_array = array![0x0, 0xd197173571271c49db0dc55686d2c005cd24ec098b3153f83f, 0x19].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(15, 13);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_14b() {
        let mut serialized_byte_array = array![0x0, 0x33d33bc1c4a90ac393d70b235d1c308c1d6eb10a7dee1c9167c76648, 0x1c].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(17, 14);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_15b() {
        let mut serialized_byte_array = array![0x1, 0x9a42b0d58ccfdc8a75b7c6487d27405bcc08bcfaac7c16adb8627ae65aad29, 0x9831, 0x2].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(21, 15);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_16b() {
        let mut serialized_byte_array = array![0x0, 0xd9144a47457ee7878c297e0c179323ef94, 0x11].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(8, 16);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_17b() {
        let mut serialized_byte_array = array![0x1, 0x2bd61b4455773d016e52c8cc59cfcedd057a9a92a321d4c87284e644c5e3dd, 0x620f, 0x2].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(27, 17);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_18b() {
        let mut serialized_byte_array = array![0x0, 0xa1f45cb0ce23faa13fcedef2d2c11e2927, 0x11].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(3, 18);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_19b() {
        let mut serialized_byte_array = array![0x1, 0x3e1935663f9cf8c83d0c2fb123b7123c5b05e36640c573222c856906ef50b4, 0x040e2233c06a61f325634e21, 0xc].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(40, 19);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_20b() {
        let mut serialized_byte_array = array![0x0, 0x1e56882c8528e750b9c1db43d48827549353d0159b2ac23cec54491c954e91, 0x1f].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(15, 20);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_21b() {
        let mut serialized_byte_array = array![0x1, 0xf9af5970cc26a8a9f97ac7600d607a06155f633ab50f802c3ba1c1dc591b21, 0xec01a748, 0x4].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(35, 21);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_22b() {
        let mut serialized_byte_array = array![0x0, 0x7b70d1dfd2bf5761ea7636bf0e45c1c32d58f0c4095ccb67462021, 0x1b].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(18, 22);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_23b() {
        let mut serialized_byte_array = array![0x1, 0x4d7d2afb757a388b22da79d9defc27466bba7c8b287802a531f56b56666765, 0xb31eca8b1a0cb74a, 0x8].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(19, 23);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_24b() {
        let mut serialized_byte_array = array![0x0, 0xbc3f652c7f5db73bf83550fed4c2bc82cef5f306e4d9ba98, 0x18].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(6, 24);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_25b() {
        let mut serialized_byte_array = array![0x1, 0x9b913142932f3af96e89be1407855ffce6b4c3f1f69fc38af295340932f40c, 0x2b04b8bedf738f8f35, 0x9].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(16, 25);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_26b() {
        let mut serialized_byte_array = array![0x1, 0x7934e8425178e43af609f6423b589ab096f7750a998ddf21b029ec2c6824cd, 0x66c544b0127b331351cd9277, 0xc].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(43, 26);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_27b() {
        let mut serialized_byte_array = array![0x1, 0xd099f6acda70246aabd88721df4eb9b4f01abc1c2b951d49c705359e3902fe, 0x1466, 0x2].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(16, 27);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_28b() {
        let mut serialized_byte_array = array![0x1, 0xfbd7a99a271b259914c8fe1cd187001b79e14fe29bb4281b87077fbe341852, 0x2ae38abd1be32729a298, 0xa].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(20, 28);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_29b() {
        let mut serialized_byte_array = array![0x0, 0x21ad6d6bfc796af8406d90f35c935da795ca7e45f2ae33dfca769eb4fd4b, 0x1e].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(22, 29);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_30b() {
        let mut serialized_byte_array = array![0x1, 0x825b26d5ad216f79206d6d9db83c857cb21218ef54e227049bb61442c3bbc0, 0xff13ce066de2edc1b193d834a4e549d7c2bd5a6c1f81f2, 0x17].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(37, 30);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_felt252_31b() {
        let mut serialized_byte_array = array![0x1, 0xf3963515b57e755f0c7d466effc175ca8507524135a0fc8c3c4d10225a3f1d, 0x8cac7e6776d0b53646e9e10a8931ad5c90d799ab9ac9ce, 0x17].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.read_partial_felt252(47, 31);
    }

    #[test]
    #[should_panic(expected: 'Array index out of bounds')]
    fn test_invalid_hash_poseidon_range() {
        let mut serialized_byte_array = array![0x1, 0x96ed2f773fffc8cec364a8027cc3b535035e40b1c8bc0b1f811a4d35a93e46, 0xf1f4b6ef, 0x4].span();
        let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        buffer.hash_poseidon_range(15, 49);
    }

}