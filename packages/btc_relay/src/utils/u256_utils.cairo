#[generate_trait]
pub impl U32LEArrayToU256Parser of U32LEArrayToU256ParserTrait {
    //Parse u256 from a a fixed-length u32 array (an output of the sha256 hash function), with LE encoding
    fn from_le_to_u256(self: [u32; 8]) -> u256 {
        let span = self.span();

        let a0 = *span[0];
        let a1 = *span[1];
        let a2 = *span[2];
        let a3 = *span[3];
        let a4 = *span[4];
        let a5 = *span[5];
        let a6 = *span[6];
        let a7 = *span[7];

        let low: felt252 = (a0 / 0x1000000).into() +
            ((a0 / 0x100) & 0xFF00).into() +
            (a0 & 0xFF00).into() * 0x100 +
            (a0 & 0xFF).into() * 0x1000000 +

            (a1 & 0xFF000000).into() * 0x100 +
            (a1 & 0xFF0000).into() * 0x1000000 +
            (a1 & 0xFF00).into() * 0x10000000000 +
            (a1 & 0xFF).into() * 0x100000000000000 +
            
            (a2 & 0xFF000000).into() * 0x10000000000 +
            (a2 & 0xFF0000).into() * 0x100000000000000 +
            (a2 & 0xFF00).into() * 0x1000000000000000000 +
            (a2 & 0xFF).into() * 0x10000000000000000000000 +
            
            (a3 & 0xFF000000).into() * 0x1000000000000000000 +
            (a3 & 0xFF0000).into() * 0x10000000000000000000000 +
            (a3 & 0xFF00).into() * 0x100000000000000000000000000 +
            (a3 & 0xFF).into() * 0x1000000000000000000000000000000;

        let high: felt252 = (a4 / 0x1000000).into() +
            ((a4 / 0x100) & 0xFF00).into() +
            (a4 & 0xFF00).into() * 0x100 +
            (a4 & 0xFF).into() * 0x1000000 +

            (a5 & 0xFF000000).into() * 0x100 +
            (a5 & 0xFF0000).into() * 0x1000000 +
            (a5 & 0xFF00).into() * 0x10000000000 +
            (a5 & 0xFF).into() * 0x100000000000000 +
            
            (a6 & 0xFF000000).into() * 0x10000000000 +
            (a6 & 0xFF0000).into() * 0x100000000000000 +
            (a6 & 0xFF00).into() * 0x1000000000000000000 +
            (a6 & 0xFF).into() * 0x10000000000000000000000 +
            
            (a7 & 0xFF000000).into() * 0x1000000000000000000 +
            (a7 & 0xFF0000).into() * 0x10000000000000000000000 +
            (a7 & 0xFF00).into() * 0x100000000000000000000000000 +
            (a7 & 0xFF).into() * 0x1000000000000000000000000000000;

        u256 {
            low: low.try_into().unwrap(),
            high: high.try_into().unwrap()
        }
    }
}
