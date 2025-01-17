use core::hash::{HashStateExTrait, HashStateTrait};
use core::poseidon::{PoseidonTrait};
use crate::structs::blockheader::{BlockHeader, BlockHeaderSha256HashTrait};
use crate::utils::nbits::nBitsConvertorTrait;
use crate::utils::u256_utils::U32LEArrayToU256ParserTrait;
use crate::utils::endianness::ReverseEndiannessTrait;
use crate::difficulty;
use crate::constants;


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

    fn get_block_hash_poseidon(self: StoredBlockHeader) -> felt252 {
        PoseidonTrait::new().update_with(self.block_hash).finalize()
    }
}

#[generate_trait]
pub impl StoredBlockHeaderUpdate of StoredBlockHeaderUpdateTrait {
    fn update_chain(ref self: StoredBlockHeader, block_header: BlockHeader, starknet_timestamp: u32) {
        //Previous blockhash matches
        assert(self.block_hash == block_header.previous_blockhash, 'update_chain: prev blockhash');

        let prev_block_timestamp = self.blockheader.reversed_timestamp.rev_endianness();
        let curr_block_timestamp = block_header.reversed_timestamp.rev_endianness();

        //Check correct nbits
        self.block_height += 1;
        if self.block_height % constants::DIFF_ADJUSTMENT_INTERVAL == 0 {
            //Compute new nbits, bitcoin uses the timestamp of the last block in the epoch to re-target PoW difficulty
            // https://github.com/bitcoin/bitcoin/blob/78dae8caccd82cfbfd76557f1fb7d7557c7b5edb/src/pow.cpp#L49
            let computed_nbits = difficulty::compute_new_target(
                prev_block_timestamp, 
                self.last_diff_adjustment,
                self.blockheader.nbits.to_target()
            ).to_nbits();
            assert(block_header.nbits == computed_nbits, 'update_chain: new nbits');
            //Even though timestamp of the last block in epoch is used to re-target PoW difficulty, the first
            // block in a new epoch is used as last_diff_adjustment, the time it takes to mine the first block
            // in every epoch is therefore not taken into consideration when retargetting PoW - one of many
            // bitcoin's quirks
            self.last_diff_adjustment = curr_block_timestamp;
        } else {
            //nbits must be same as last block
            assert(block_header.nbits == self.blockheader.nbits, 'update_chain: nbits');
        }

        //Check PoW
        let target: u256 = block_header.nbits.to_target();
        let block_hash: [u32; 8] = block_header.dbl_sha256_hash();
        assert(block_hash.from_le_to_u256() < target, 'update_chain: invalid PoW');

        //Verify timestamp is larger than median of last 11 block timestamps
        let mut count: u8 = 0;
        for timestamp in self.prev_block_timestamps.span() {
            if curr_block_timestamp > *timestamp {
                count += 1;
            };
        };
        if curr_block_timestamp > prev_block_timestamp {
            count += 1
        };
        assert(count > 5, 'update_chain: timestamp median');

        //Verify timestamp is no more than MAX_FUTURE_BLOCKTIME in the future
        assert(curr_block_timestamp < starknet_timestamp + constants::MAX_FUTURE_BLOCKTIME, 'update_chain: timestamp future');

        //Set self variables
        self.block_hash = block_hash;
        self.blockheader = block_header;
        let prev_block_timestamps = self.prev_block_timestamps.span();
        self.prev_block_timestamps = [
            *prev_block_timestamps[1],
            *prev_block_timestamps[2],
            *prev_block_timestamps[3],
            *prev_block_timestamps[4],
            *prev_block_timestamps[5],
            *prev_block_timestamps[6],
            *prev_block_timestamps[7],
            *prev_block_timestamps[8],
            *prev_block_timestamps[9],
            prev_block_timestamp
        ];

        self.chain_work += difficulty::get_difficulty(target);
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

    #[test]
    fn single_block_update() {
        let mut stored_blockheader = StoredBlockHeader {
            blockheader: BlockHeader {
                reversed_version: 0x00e00020,
                previous_blockhash: [0x005ad1e5, 0x2105871c, 0x3307f84d, 0x0ec1bbd6, 0xdaf1f165, 0x95730100, 0x00000000, 0x00000000],
                merkle_root: [0x2f7cf817, 0x45228b2b, 0x0c5e0191, 0x418757cb, 0xd85355bc, 0xd0d56f4f, 0x597e9531, 0xc55ffe94],
                reversed_timestamp: 0x2f148567,
                nbits: 0x618c0217,
                nonce: 0xf1d0c106
            },
            block_hash: [0x750d80cd, 0xb13dacc2, 0x88e25f1e, 0x460b9540, 0x1a3f50dc, 0x2ed10100, 0x00000000, 0x00000000],
            chain_work: 0x0000000000000000000000000000000000000000a70ff8c166c99c6b6cd42d58,
            block_height: 879079,
            last_diff_adjustment: 1736712111,
            prev_block_timestamps: [
                1736767006,
                1736767744,
                1736767878,
                1736769034,
                1736769616,
                1736770294,
                1736770311,
                1736771611,
                1736773502,
                1736774360
            ]
        };

        let next_block_header = BlockHeader {
            reversed_version: 0x00e09c2f,
            previous_blockhash: [0x750d80cd, 0xb13dacc2, 0x88e25f1e, 0x460b9540, 0x1a3f50dc, 0x2ed10100, 0x00000000, 0x00000000],
            merkle_root: [0xb59cce24, 0xcc632429, 0x6883cef5, 0x7ed40ef8, 0x622daf7e, 0xce8337b0, 0xa1f91324, 0xaa6fb741],
            reversed_timestamp: 0xb0158567,
            nbits: 0x618c0217,
            nonce: 0xa614233d
        };

        stored_blockheader.update_chain(next_block_header, 1736777120);
    }
}
