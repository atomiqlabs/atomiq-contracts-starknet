use core::sha256::compute_sha256_u32_array;
use crate::utils::nbits::nbits;

//Bitcoin blockheader data structure
#[derive(Hash, Drop, Copy, Serde)]
pub struct BlockHeader {
    pub reversed_version: u32,
    pub previous_blockhash: [u32; 8],
    pub merkle_root: [u32; 8],
    pub reversed_timestamp: u32,
    pub nbits: nbits,
    pub nonce: u32
}

//Double sha256 hash of the block
#[generate_trait]
pub impl BlockHeaderSha256Hash of BlockHeaderSha256HashTrait {
    fn dbl_sha256_hash(self: @BlockHeader) -> [u32; 8] {
        let prev_blockhash = self.previous_blockhash.span();
        let merkle_root = self.merkle_root.span();
        let result = compute_sha256_u32_array(array![
            *self.reversed_version,
            *prev_blockhash[0], *prev_blockhash[1], *prev_blockhash[2], *prev_blockhash[3], *prev_blockhash[4], *prev_blockhash[5], *prev_blockhash[6], *prev_blockhash[7],
            *merkle_root[0], *merkle_root[1], *merkle_root[2], *merkle_root[3], *merkle_root[4], *merkle_root[5], *merkle_root[6], *merkle_root[7],
            *self.reversed_timestamp,
            *self.nbits,
            *self.nonce
        ], 0, 0).span();
        compute_sha256_u32_array(array![
            *result[0], *result[1], *result[2], *result[3], *result[4], *result[5], *result[6], *result[7]
        ], 0, 0)
    }
}
