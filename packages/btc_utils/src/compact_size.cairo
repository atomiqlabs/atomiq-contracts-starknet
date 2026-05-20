use crate::byte_array::{ByteArrayReader, ByteArrayReaderTrait};

//Implements Compact Size reader as per bitcoin's https://learnmeabitcoin.com/technical/general/compact-size/
#[generate_trait]
pub impl ByteArrayCompactSizeReader of ByteArrayCompactSizeReaderTrait {
    //Reads compact size integer from the byte array
    fn read_compact(self: @ByteArray, position: usize) -> (u64, usize) {
        let first = self.at(position).expect('Array index out of bounds');
        if first==0xFD {
            return (self.read_u16_le(position+1).into(), 3);
        }
        if first==0xFE {
            return (self.read_u32_le(position+1).into(), 5);
        }
        if first==0xFF {
            return (self.read_u64_le(position+1).into(), 9);
        }
        (first.into(), 1)
    }
}
