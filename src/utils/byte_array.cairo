use core::sha256::{compute_sha256_byte_array, compute_sha256_u32_array};

pub trait IntegerReader {
    fn read_u16_be(self: @ByteArray, index: usize) -> u16;
    fn read_u16_le(self: @ByteArray, index: usize) -> u16;
    fn read_u32_be(self: @ByteArray, index: usize) -> u32;
    fn read_u32_le(self: @ByteArray, index: usize) -> u32;
    fn read_u64_be(self: @ByteArray, index: usize) -> u64;
    fn read_u64_le(self: @ByteArray, index: usize) -> u64;
    fn hash_sha256(self: @ByteArray) -> [u32; 8];
    fn hash_dbl_sha256(self: @ByteArray) -> [u32; 8];
}

pub impl ByteArrayIntegerReader of IntegerReader {

    fn read_u16_be(self: @ByteArray, index: usize) -> u16 {
        let result: felt252 = self.at(0).unwrap().into() * 0x100
            + self.at(1).unwrap().into();
        result.try_into().unwrap()
    }

    fn read_u16_le(self: @ByteArray, index: usize) -> u16 {
        let result: felt252 = self.at(1).unwrap().into() * 0x100
            + self.at(0).unwrap().into();
        result.try_into().unwrap()
    }

    fn read_u32_be(self: @ByteArray, index: usize) -> u32 {
        let result: felt252 = self.at(0).unwrap().into() * 0x1000000
            + self.at(1).unwrap().into() * 0x10000
            + self.at(2).unwrap().into() * 0x100
            + self.at(3).unwrap().into();
        result.try_into().unwrap()
    }

    fn read_u32_le(self: @ByteArray, index: usize) -> u32 {
        let result: felt252 = self.at(3).unwrap().into() * 0x1000000
            + self.at(2).unwrap().into() * 0x10000
            + self.at(1).unwrap().into() * 0x100
            + self.at(0).unwrap().into();
        result.try_into().unwrap()
    }

    fn read_u64_be(self: @ByteArray, index: usize) -> u64 {
        let result: felt252 = self.at(0).unwrap().into() * 0x100000000000000
            + self.at(1).unwrap().into() * 0x1000000000000
            + self.at(2).unwrap().into() * 0x10000000000
            + self.at(3).unwrap().into() * 0x100000000
            + self.at(4).unwrap().into() * 0x1000000
            + self.at(5).unwrap().into() * 0x10000
            + self.at(6).unwrap().into() * 0x100
            + self.at(7).unwrap().into();
        result.try_into().unwrap()
    }

    fn read_u64_le(self: @ByteArray, index: usize) -> u64 {
        let result: felt252 = self.at(7).unwrap().into() * 0x100000000000000
            + self.at(6).unwrap().into() * 0x1000000000000
            + self.at(5).unwrap().into() * 0x10000000000
            + self.at(4).unwrap().into() * 0x100000000
            + self.at(3).unwrap().into() * 0x1000000
            + self.at(2).unwrap().into() * 0x10000
            + self.at(1).unwrap().into() * 0x100
            + self.at(0).unwrap().into();
        result.try_into().unwrap()
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
    
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_integers() {
        let byte_array: ByteArray = "asdlakdadasdasjdajfjajsd ias0d s9ad asd 9asd9 a90ads 0as80d 8u";

        let short = byte_array.read_u16_be(0);
        assert!(short == 0x6173);
        let integer = byte_array.read_u32_be(2);
        assert!(integer == 0x646C616B);
        let long = byte_array.read_u64_be(6);
        assert!(long == 0x6461646173646173);
    }

    #[test]
    fn hash() {
        let byte_array: ByteArray = "asdlakdadasdasjdajfjajsd ias0d s9ad asd 9asd9 a90ads 0as80d 8u";

        let hash = byte_array.hash_sha256();
        assert!(hash == [0x640f8218, 0x827ff6b1, 0xed8912e2, 0x3c514f17, 0x31da486b, 0x42495e94, 0xa861c475, 0x83fad28e]);
    }


    #[test]
    fn dbl_hash() {
        let byte_array: ByteArray = "asdlakdadasdasjdajfjajsd ias0d s9ad asd 9asd9 a90ads 0as80d 8u";

        let hash = byte_array.hash_dbl_sha256();
        assert!(hash == [0x4c88581d, 0x5894e032, 0xbb2a7b53, 0x0932c019, 0x520a51c1, 0xf8fbe18c, 0x0ee3d028, 0xcf35b02a]);
    }

}