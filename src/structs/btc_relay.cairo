use core::sha256::compute_sha256_u32_array;
use core::hash::{HashStateExTrait, HashStateTrait};
use core::poseidon::{PoseidonTrait};

#[derive(Hash, Drop, Copy, Serde)]
pub struct BlockHeader {
    pub reversed_version: u32,
    pub previous_blockhash: [u32; 8],
    pub merkle_root: [u32; 8],
    pub reversed_timestamp: u32,
    pub nbits: u32,
    pub nonce: u32
}

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

#[derive(Hash, Drop, Copy, Serde)]
pub struct StoredBlockHeader {
    pub blockheader: BlockHeader,
    pub block_hash: [u32; 8],
    pub chain_work: u256,
    pub block_height: u32,
    pub last_diff_adjustment: u32,
    pub prev_block_timestamps: [u32; 10]
}

#[generate_trait]
pub impl StoredBlockHeaderPoseidonHash of StoredBlockHeaderPoseidonHashTrait {
    fn get_hash(self: StoredBlockHeader) -> felt252 {
        PoseidonTrait::new().update_with(self).finalize()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const blockheader: BlockHeader = BlockHeader {
        reversed_version: 0x00a09d30,
        previous_blockhash: [0xd9b4483b, 0xfeea114d, 0x28cac19f, 0xff38342c, 0x46f806c2, 0xe56c0200, 0x00000000, 0x00000000],
        merkle_root: [0x96358d74, 0x49b41091, 0x5558c859, 0x135e1b1b, 0xcce967c1, 0x40eb5f07, 0x922a6c74, 0x3fe80855],
        reversed_timestamp: 0xefcf8367,
        nbits: 0x5c900217,
        nonce: 0xb6b877b1
    };
    const block_hash: [u32; 8] = [0xad0d7f7c, 0x596123cd, 0xda3901a7, 0xad2a234b, 0xb6d49674, 0xdff30100, 0x00000000, 0x00000000];

    #[test]
    fn hash_blockheader() {
        let hash = blockheader.dbl_sha256_hash();
        assert!(hash == block_hash);
    }

    #[test]
    fn hash_stored_blockheader() {
        let stored_blockheader = StoredBlockHeader {
            blockheader: blockheader,
            block_hash: block_hash,
            chain_work: 0x01,
            last_diff_adjustment: 23123,
            block_height: 878939,
            prev_block_timestamps: [1, 2, 3, 4, 6, 7, 8, 9, 10, 11]
        };
        let result = PoseidonTrait::new().update_with(stored_blockheader).finalize();
        assert!(result == 586737086952035464897353876617034348300086891384582126864613676405656723293);
    }

}