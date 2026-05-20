pub trait ReverseEndiannessTrait<T> {
    fn rev_endianness(self: T) -> T;
}

pub impl u32ReverseEndianness of ReverseEndiannessTrait<u32> {
    //Reverses endianness of the u32
    fn rev_endianness(self: u32) -> u32 {
        (self / 0x1000000) +
        ((self / 0x100) & 0xFF00) +
        (self & 0xFF00) * 0x100 +
        (self & 0xFF) * 0x1000000
    }
}
