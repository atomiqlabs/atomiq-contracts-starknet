use core::hash::{HashStateExTrait, HashStateTrait};
use core::poseidon::{PoseidonTrait};
use crate::structs::blockheader::{BlockHeader, BlockHeaderSha256HashTrait};
use crate::utils::nbits::nBitsConvertorTrait;
use crate::utils::endianness::ReverseEndiannessTrait;
use crate::difficulty;
use crate::constants;
use crate::utils::u256_utils::U32LEArrayToU256ParserTrait;

//Representing the blockchain state at a specific blockheight,
// the hash of this acts as a commitment that is saved in the main_chain map
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
    //Returns the poseidon hash of the struct, to be used as a commitment and saved to the main_chain storage map
    fn get_hash(self: StoredBlockHeader) -> felt252 {
        PoseidonTrait::new().update_with(self).finalize()
    }

    //Returns the poseidon hash of block_hash, it is computed on the [u32; 8] representation!
    fn get_block_hash_poseidon(self: StoredBlockHeader) -> felt252 {
        PoseidonTrait::new().update_with(self.block_hash).finalize()
    }
}

#[generate_trait]
pub impl StoredBlockHeaderUpdate of StoredBlockHeaderUpdateTrait {
    //Update the chain state with a new blockheader
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
            ).to_nbits(); //Comment this line for testnet deployment
            assert(block_header.nbits == computed_nbits, 'update_chain: new nbits'); //Comment this line for testnet deployment
            //Even though timestamp of the last block in epoch is used to re-target PoW difficulty, the first
            // block in a new epoch is used as last_diff_adjustment, the time it takes to mine the first block
            // in every epoch is therefore not taken into consideration when retargetting PoW - one of many
            // bitcoin's quirks
            self.last_diff_adjustment = curr_block_timestamp;
        } else {
            //nbits must be same as last block
            assert(block_header.nbits == self.blockheader.nbits, 'update_chain: nbits'); //Comment this line for testnet deployment
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
            count += 1;
        };
        assert(count > 5, 'update_chain: timestamp median');

        //Verify timestamp is no more than MAX_FUTURE_BLOCKTIME in the future
        assert(curr_block_timestamp < starknet_timestamp + constants::MAX_FUTURE_BLOCKTIME, 'update_chain: timestamp future');

        //Update state
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

        self.chain_work += difficulty::get_chainwork(target);
    }
}
