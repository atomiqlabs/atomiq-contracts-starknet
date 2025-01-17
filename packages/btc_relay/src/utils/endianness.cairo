pub trait ReverseEndiannessTrait<T> {
    fn rev_endianness(self: T) -> T;
}

pub impl u32ReverseEndianness of ReverseEndiannessTrait<u32> {
    fn rev_endianness(self: u32) -> u32 {
        (self / 0x1000000) +
        ((self / 0x100) & 0xFF00) +
        (self & 0xFF00) * 0x100 +
        (self & 0xFF) * 0x1000000
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_reverse_endianness_u32() {
        let val: u32 = 0x10323201;
        assert!(val.rev_endianness() == 0x01323210);
        let val: u32 = 0xc8b367ca;
        assert!(val.rev_endianness() == 0xca67b3c8);
    }

}