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
            count += 1;
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

        self.chain_work += difficulty::get_chainwork(target);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn real_success_block_update() {
        // Valid real block update
        let BLOCKHEADER_463131: BlockHeader = BlockHeader {
            reversed_version: 0x00000020,
            previous_blockhash: [0xa5376a85, 0xea4e0b98, 0x2e5305d0, 0xfb17b573, 0x07d7b4e2, 0x03980000, 0x00000000, 0x00000000],
            merkle_root: [0x1d564961, 0x5cffcd11, 0x0ad492ae, 0x83c54034, 0xf12d41f4, 0x4dd69094, 0xc875b750, 0x539e1031],
            reversed_timestamp: 0xf65afc58,
            nbits: 0x731c0218,
            nonce: 0x7a15fac4
        };
        let BLOCKHEADER_463132: BlockHeader = BlockHeader {
            reversed_version: 0x00000020,
            previous_blockhash: [0x6c9a2e74, 0x00553bb3, 0x268205eb, 0x0c1f3449, 0xb6bbdd8b, 0xb8d89d00, 0x00000000, 0x00000000],
            merkle_root: [0xda44094f, 0xbe83dd0c, 0x7567d2de, 0xde1cd632, 0xa844eecd, 0xc80469b2, 0xd38173a3, 0x8adb6d37],
            reversed_timestamp: 0xfc5bfc58,
            nbits: 0x731c0218,
            nonce: 0x05c5ce0a
        };
        let mut stored_blockheader_0: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_463131,
            block_hash: [0x6c9a2e74, 0x00553bb3, 0x268205eb, 0x0c1f3449, 0xb6bbdd8b, 0xb8d89d00, 0x00000000, 0x00000000],
            chain_work: 0x000000000000000000000000000000000000000000501ba97ac01f852a253710,
            block_height: 463131,
            last_diff_adjustment: 1492052390,
            prev_block_timestamps: [1492927366, 1492927966, 1492928566, 1492929166, 1492929766, 1492930366, 1492930966, 1492931566, 1492932166, 1492932766]
        };
        let stored_blockheader_1: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_463132,
            block_hash: [0x3f775fdd, 0x939699a1, 0x80ce2604, 0x54227f66, 0x3dfa9652, 0x79531100, 0x00000000, 0x00000000],
            chain_work: 0x000000000000000000000000000000000000000000501c22bdd83c0b6a792cc4,
            block_height: 463132,
            last_diff_adjustment: 1492052390,
            prev_block_timestamps: [1492927966, 1492928566, 1492929166, 1492929766, 1492930366, 1492930966, 1492931566, 1492932166, 1492932766, 1492933366]
        };
        stored_blockheader_0.update_chain(BLOCKHEADER_463132, 1492933628);
        let mut serialized_0: Array<felt252> = array![];
        stored_blockheader_0.serialize(ref serialized_0);
        let mut serialized_1: Array<felt252> = array![];
        stored_blockheader_1.serialize(ref serialized_1);
        assert_eq!(serialized_0, serialized_1);
    }

    #[test]
    fn real_success_block_pow_retarget() {
        // Valid real block update on PoW readjustment
        let BLOCKHEADER_131039: BlockHeader = BlockHeader {
            reversed_version: 0x01000000,
            previous_blockhash: [0xeedff963, 0xdd256b57, 0x46806b52, 0x865a6c95, 0x57f16f1f, 0x8151b090, 0x8a0b0000, 0x00000000],
            merkle_root: [0x61c9639f, 0x5beee712, 0x2f9ed3dc, 0x17589723, 0xfcb43317, 0x8d1e97f7, 0xe3a79448, 0xacde985c],
            reversed_timestamp: 0x8fb7f84d,
            nbits: 0x2f931d1a,
            nonce: 0x6db9b3b9
        };
        let BLOCKHEADER_131040: BlockHeader = BlockHeader {
            reversed_version: 0x01000000,
            previous_blockhash: [0x2362ea4c, 0x7e402943, 0xe17b5aec, 0x2b1eaa3a, 0xd6aa4782, 0xcb4c6998, 0x6e0e0000, 0x00000000],
            merkle_root: [0x98d8d6ab, 0x69367e74, 0xe83c4739, 0xf28edb2b, 0xf7299435, 0xe29323bf, 0x635e56f6, 0x17b127bd],
            reversed_timestamp: 0x6eb8f84d,
            nbits: 0x8521131a,
            nonce: 0x0bca388b
        };
        let mut stored_blockheader_0: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_131039,
            block_hash: [0x2362ea4c, 0x7e402943, 0xe17b5aec, 0x2b1eaa3a, 0xd6aa4782, 0xcb4c6998, 0x6e0e0000, 0x00000000],
            chain_work: 0x000000000000000000000000000000000000000000000000f84049eaa2bdc920,
            block_height: 131039,
            last_diff_adjustment: 1307363105,
            prev_block_timestamps: [1308139551, 1308140151, 1308140751, 1308141351, 1308141951, 1308142551, 1308143151, 1308143751, 1308144351, 1308144951]
        };
        let stored_blockheader_1: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_131040,
            block_hash: [0x8759422d, 0x27a082a2, 0x7e8e1c72, 0x10806a58, 0x2489449c, 0xe1b851a6, 0x7a090000, 0x00000000],
            chain_work: 0x000000000000000000000000000000000000000000000000f84dab9282bc9055,
            block_height: 131040,
            last_diff_adjustment: 1308145774,
            prev_block_timestamps: [1308140151, 1308140751, 1308141351, 1308141951, 1308142551, 1308143151, 1308143751, 1308144351, 1308144951, 1308145551]
        };
        stored_blockheader_0.update_chain(BLOCKHEADER_131040, 1308145774);
        let mut serialized_0: Array<felt252> = array![];
        stored_blockheader_0.serialize(ref serialized_0);
        let mut serialized_1: Array<felt252> = array![];
        stored_blockheader_1.serialize(ref serialized_1);
        assert_eq!(serialized_0, serialized_1);
    }

    #[test]
    fn real_success_block_pow_retarget_fast_limit() {
        // Valid real block update on PoW readjustment, too fast
        let BLOCKHEADER_68543: BlockHeader = BlockHeader {
            reversed_version: 0x01000000,
            previous_blockhash: [0x0cfc9e4c, 0x2703d2da, 0x0276db10, 0xd809fbad, 0x119f4a7a, 0x015b83ff, 0xbdac0903, 0x00000000],
            merkle_root: [0xc5907cdb, 0x4d947c8b, 0x73204658, 0xe6a6faae, 0x0307527b, 0xc4f6f5fd, 0xcf5e96d6, 0x3b549d91],
            reversed_timestamp: 0x8788404c,
            nbits: 0xf4a3051c,
            nonce: 0x193bdd00
        };
        let BLOCKHEADER_68544: BlockHeader = BlockHeader {
            reversed_version: 0x01000000,
            previous_blockhash: [0xfb57c71c, 0xcd211b3d, 0xe4ccc2e2, 0x3b50a7cd, 0xb72aab91, 0xe60737b3, 0xa2bfdf03, 0x00000000],
            merkle_root: [0x88a88ad9, 0xdf68925e, 0x880e5d52, 0xb7e50cef, 0x225871c6, 0x8b40a2cd, 0x0bca1084, 0xcd436037],
            reversed_timestamp: 0xf388404c,
            nbits: 0xfd68011c,
            nonce: 0xaeb1f801
        };
        let mut stored_blockheader_0: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_68543,
            block_hash: [0xfb57c71c, 0xcd211b3d, 0xe4ccc2e2, 0x3b50a7cd, 0xb72aab91, 0xe60737b3, 0xa2bfdf03, 0x00000000],
            chain_work: 0x00000000000000000000000000000000000000000000000000067127f0749ce0,
            block_height: 68543,
            last_diff_adjustment: 1279008237,
            prev_block_timestamps: [1279291671, 1279292271, 1279292871, 1279293471, 1279294071, 1279294671, 1279295271, 1279295871, 1279296471, 1279297071]
        };
        let stored_blockheader_1: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_68544,
            block_hash: [0x5c8e9b29, 0x76db7b28, 0x083ebc1f, 0x4eff0e6a, 0x17bccd43, 0x593c5feb, 0x51905100, 0x00000000],
            chain_work: 0x000000000000000000000000000000000000000000000000000671dd7c3f2bad,
            block_height: 68544,
            last_diff_adjustment: 1279297779,
            prev_block_timestamps: [1279292271, 1279292871, 1279293471, 1279294071, 1279294671, 1279295271, 1279295871, 1279296471, 1279297071, 1279297671]
        };
        stored_blockheader_0.update_chain(BLOCKHEADER_68544, 1279297779);
        let mut serialized_0: Array<felt252> = array![];
        stored_blockheader_0.serialize(ref serialized_0);
        let mut serialized_1: Array<felt252> = array![];
        stored_blockheader_1.serialize(ref serialized_1);
        assert_eq!(serialized_0, serialized_1);
    }

    #[test]
    fn random_success_block_updates() {
        let BLOCKHEADER_523097: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0x770c166f, 0xaaf203fb, 0x0e5b0f09, 0x3e5a79fc, 0xb413bc81, 0xaec90a7b, 0xa5a2bc2b, 0xdf382cd5],
            merkle_root: [0x3b08b658, 0xbb81594e, 0x66d0f5d5, 0x4de4993f, 0xcd1a15c4, 0xb2ffe36b, 0x60fa59da, 0xd33567e5],
            reversed_timestamp: 0x2ddbd225,
            nbits: 0xdd39461f,
            nonce: 0x00000241
        };
        let BLOCKHEADER_523098: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0x1c4799bd, 0xda6ffe69, 0x4297df69, 0x230514bf, 0x91d8e8af, 0xe00102f3, 0x8e068ef1, 0x92852000],
            merkle_root: [0x32560362, 0x4d808917, 0x0f715958, 0x65b14e79, 0x54b5c134, 0xc1565157, 0x84465ee9, 0x5252bed3],
            reversed_timestamp: 0xbcded225,
            nbits: 0xdd39461f,
            nonce: 0x000002ac
        };
        let mut stored_blockheader_0: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_523097,
            block_hash: [0x1c4799bd, 0xda6ffe69, 0x4297df69, 0x230514bf, 0x91d8e8af, 0xe00102f3, 0x8e068ef1, 0x92852000],
            chain_work: 0x00000000000000000000000000000000000000000000000a9abf31b72c00c6b5,
            block_height: 523097,
            last_diff_adjustment: 634003861,
            prev_block_timestamps: [634569661, 634570261, 634570861, 634571461, 634572061, 634572661, 634573261, 634573861, 634574461, 634575061]
        };
        let stored_blockheader_1: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_523098,
            block_hash: [0xb49cf3d6, 0xa355d8dd, 0x98daed85, 0x0b5be166, 0x56471ffb, 0x2b7cf14e, 0x6f6d40e1, 0x8bb82400],
            chain_work: 0x00000000000000000000000000000000000000000000000a9abf31b72c00ca5a,
            block_height: 523098,
            last_diff_adjustment: 634003861,
            prev_block_timestamps: [634570261, 634570861, 634571461, 634572061, 634572661, 634573261, 634573861, 634574461, 634575061, 634575661]
        };
        stored_blockheader_0.update_chain(BLOCKHEADER_523098, 634576572);
        let mut serialized_0: Array<felt252> = array![];
        stored_blockheader_0.serialize(ref serialized_0);
        let mut serialized_1: Array<felt252> = array![];
        stored_blockheader_1.serialize(ref serialized_1);
        assert_eq!(serialized_0, serialized_1);
    }

    #[test]
    fn random_success_block_pow_retarget() {
        let BLOCKHEADER_114911: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0x2f70ef91, 0x8782622c, 0xd4c1316a, 0x2d18247a, 0x1853467b, 0x2de0dc43, 0x9a27f391, 0xcb46d2b0],
            merkle_root: [0x091df449, 0xc2c4b8d4, 0xcd04df73, 0x2a71c1e0, 0x112d0542, 0xed21568b, 0xa93c9848, 0xa32a454d],
            reversed_timestamp: 0xdc492b61,
            nbits: 0xa12b101f,
            nonce: 0x00001ca3
        };
        let BLOCKHEADER_114912: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0x388e4516, 0xac9b2af5, 0x84c03038, 0xcedb3ab0, 0xc82846c6, 0x4f675f0c, 0x8c268b7a, 0xeaaf0000],
            merkle_root: [0xd33c7753, 0x725fe478, 0x03b25762, 0xffaa3edb, 0x3b3963ec, 0xee5d8b07, 0xc99276f6, 0xfb582390],
            reversed_timestamp: 0x934c2b61,
            nbits: 0xc7d00e1f,
            nonce: 0x00001157
        };
        let mut stored_blockheader_0: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_114911,
            block_hash: [0x388e4516, 0xac9b2af5, 0x84c03038, 0xcedb3ab0, 0xc82846c6, 0x4f675f0c, 0x8c268b7a, 0xeaaf0000],
            chain_work: 0x00000000000000000000000000000000013074ce0c2c590823f5be867308bcce,
            block_height: 114911,
            last_diff_adjustment: 1629118658,
            prev_block_timestamps: [1630220908, 1630221508, 1630222108, 1630222708, 1630223308, 1630223908, 1630224508, 1630225108, 1630225708, 1630226308]
        };
        let stored_blockheader_1: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_114912,
            block_hash: [0x6ff2dfd3, 0x6bad752b, 0x65bbc17f, 0x7f3755d9, 0x4ea0523c, 0xeeff54c1, 0x46861035, 0xcc280800],
            chain_work: 0x00000000000000000000000000000000013074ce0c2c590823f5be867308ce15,
            block_height: 114912,
            last_diff_adjustment: 1630227603,
            prev_block_timestamps: [1630221508, 1630222108, 1630222708, 1630223308, 1630223908, 1630224508, 1630225108, 1630225708, 1630226308, 1630226908]
        };
        stored_blockheader_0.update_chain(BLOCKHEADER_114912, 1630227603);
        let mut serialized_0: Array<felt252> = array![];
        stored_blockheader_0.serialize(ref serialized_0);
        let mut serialized_1: Array<felt252> = array![];
        stored_blockheader_1.serialize(ref serialized_1);
        assert_eq!(serialized_0, serialized_1);
    }

    #[test]
    fn random_success_block_pow_retarget_fast_limit() {
        // Valid random block update on PoW readjustment, too fast
        let BLOCKHEADER_558431: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0xa2c22329, 0x279d04e4, 0x4d552fc1, 0x89e9b8a8, 0xe1fbfbf2, 0x26c965f7, 0x42f6082c, 0xf95330b2],
            merkle_root: [0x57b9747c, 0x6b28db01, 0xde56dc8c, 0x3057035a, 0xb057fd57, 0xc9fb96bc, 0xd9335a63, 0x8f100beb],
            reversed_timestamp: 0x5f1c3543,
            nbits: 0x4510101f,
            nonce: 0x000009ba
        };
        let BLOCKHEADER_558432: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0x09bf5675, 0x459f6d23, 0xa0876b9f, 0xb9539690, 0xbe87c0de, 0xf1f35a19, 0x8dfe9641, 0x6aea0000],
            merkle_root: [0x8adde81e, 0x3e2e6a4c, 0x512f9a85, 0x9378c96c, 0x6b7f43c5, 0xa6545e83, 0xa7fd4220, 0x2588a03a],
            reversed_timestamp: 0xf81d3543,
            nbits: 0x1104041f,
            nonce: 0x00001283
        };
        let mut stored_blockheader_0: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_558431,
            block_hash: [0x09bf5675, 0x459f6d23, 0xa0876b9f, 0xb9539690, 0xbe87c0de, 0xf1f35a19, 0x8dfe9641, 0x6aea0000],
            chain_work: 0x000000000000000000000000000000000000000000000003a809dc4b54c63201,
            block_height: 558431,
            last_diff_adjustment: 1127352643,
            prev_block_timestamps: [1127548143, 1127548743, 1127549343, 1127549943, 1127550543, 1127551143, 1127551743, 1127552343, 1127552943, 1127553543]
        };
        let stored_blockheader_1: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_558432,
            block_hash: [0x8b9e728d, 0xc6ddb98f, 0x3a627b13, 0xf96aac0a, 0x4b491092, 0x6b640687, 0x48ff8ca1, 0x4e330100],
            chain_work: 0x000000000000000000000000000000000000000000000003a809dc4b54c671c0,
            block_height: 558432,
            last_diff_adjustment: 1127554552,
            prev_block_timestamps: [1127548743, 1127549343, 1127549943, 1127550543, 1127551143, 1127551743, 1127552343, 1127552943, 1127553543, 1127554143]
        };
        stored_blockheader_0.update_chain(BLOCKHEADER_558432, 1127554552);
        let mut serialized_0: Array<felt252> = array![];
        stored_blockheader_0.serialize(ref serialized_0);
        let mut serialized_1: Array<felt252> = array![];
        stored_blockheader_1.serialize(ref serialized_1);
        assert_eq!(serialized_0, serialized_1);
    }

    #[test]
    fn random_success_block_pow_retarget_slow_limit() {
        // Valid random block update on PoW readjustment, too slow
        let BLOCKHEADER_810431: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0x3169a712, 0x6c02d049, 0xcbabb6a8, 0x426d6707, 0xa9ab70af, 0xebd2bbea, 0xa1ee88a8, 0x2a58acd0],
            merkle_root: [0x0385c1aa, 0xbfc62503, 0xb1c17625, 0x078b090b, 0xd00eab63, 0x750c53f9, 0x95322fd7, 0xb32c7f0c],
            reversed_timestamp: 0x2bad0445,
            nbits: 0xdb70101f,
            nonce: 0x00000894
        };
        let BLOCKHEADER_810432: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0x008de892, 0xfc40c6f1, 0xbf2eae26, 0x664dd2cf, 0xd5f93898, 0x2cac536d, 0x51727036, 0xcaa40f00],
            merkle_root: [0x8a80f412, 0x47c1ced3, 0x3447365e, 0x885627ea, 0x61e92ccb, 0x7de51749, 0x9aeda7a9, 0xb76df102],
            reversed_timestamp: 0xb3b00445,
            nbits: 0x6cc3411f,
            nonce: 0x000000d8
        };
        let mut stored_blockheader_0: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_810431,
            block_hash: [0x008de892, 0xfc40c6f1, 0xbf2eae26, 0x664dd2cf, 0xd5f93898, 0x2cac536d, 0x51727036, 0xcaa40f00],
            chain_work: 0x0000000000000000000000000000000000000000000000000000000079ea0cfb,
            block_height: 810431,
            last_diff_adjustment: 1151889379,
            prev_block_timestamps: [1157928379, 1157928979, 1157929579, 1157930179, 1157930779, 1157931379, 1157931979, 1157932579, 1157933179, 1157933779]
        };
        let stored_blockheader_1: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_810432,
            block_hash: [0xb2dcf817, 0x1dd69c86, 0xd0271623, 0xbc66329a, 0xf912a798, 0x199679d2, 0xe82c9759, 0x5d5f0900],
            chain_work: 0x0000000000000000000000000000000000000000000000000000000079ea10df,
            block_height: 810432,
            last_diff_adjustment: 1157935283,
            prev_block_timestamps: [1157928979, 1157929579, 1157930179, 1157930779, 1157931379, 1157931979, 1157932579, 1157933179, 1157933779, 1157934379]
        };
        stored_blockheader_0.update_chain(BLOCKHEADER_810432, 1157935283);
        let mut serialized_0: Array<felt252> = array![];
        stored_blockheader_0.serialize(ref serialized_0);
        let mut serialized_1: Array<felt252> = array![];
        stored_blockheader_1.serialize(ref serialized_1);
        assert_eq!(serialized_0, serialized_1);
    }

    #[test]
    fn random_success_block_timestamp_median() {
        // Valid random block update, with timestamp larger than median of last 11 blocks
        
        let BLOCKHEADER_226657: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0xd2fbaf33, 0x0b3214e4, 0x716d0f0e, 0x53dbd16e, 0x6680faf0, 0xa19b8948, 0x69d83534, 0xeec564ba],
            merkle_root: [0x4528adc0, 0x2e0cbff4, 0xf67ae1d5, 0x722a20b3, 0x2c9d2cc5, 0xe5f74507, 0x8eab05b5, 0xc751ce2f],
            reversed_timestamp: 0xd24a0135,
            nbits: 0xe521101f,
            nonce: 0x00000664
        };
        let BLOCKHEADER_226658: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0xc8e89fb5, 0x789ebfc5, 0x80f07190, 0xfcd47391, 0xc82f8f25, 0x58374b61, 0xdae5434b, 0xf2610900],
            merkle_root: [0x287e23c0, 0xb0608ad0, 0x798be3ed, 0x22102888, 0x4e8778e5, 0x05982e2e, 0xc5cff0e0, 0x890128f9],
            reversed_timestamp: 0x253d0135,
            nbits: 0xe521101f,
            nonce: 0x0000062d
        };
        let mut stored_blockheader_0: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_226657,
            block_hash: [0xc8e89fb5, 0x789ebfc5, 0x80f07190, 0xfcd47391, 0xc82f8f25, 0x58374b61, 0xdae5434b, 0xf2610900],
            chain_work: 0x00000000000000000000000000000000003209703edfb65e03e40645278ab071,
            block_height: 226657,
            last_diff_adjustment: 888758138,
            prev_block_timestamps: [889270875, 889270032, 889273490, 889272717, 889273977, 889275413, 889271752, 889270482, 889275038, 889276081]
        };
        stored_blockheader_0.update_chain(BLOCKHEADER_226658, 889273637);
    }

    #[test]
    #[should_panic(expected: 'update_chain: invalid PoW')]
    fn random_fail_block_invalid_pow() {
        // Invalid random block update, due to low PoW

        let BLOCKHEADER_903724: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0xa7569f44, 0x9cc08b4c, 0x3973e4aa, 0x41d7a055, 0x8c885288, 0xd2f7003e, 0x5eb66e0b, 0x8464e95c],
            merkle_root: [0x6fb932f7, 0x5e4932f0, 0x0a7f7eb6, 0x07b04e62, 0x64406dd0, 0x10841bea, 0x2c5dd225, 0x1c52db74],
            reversed_timestamp: 0x66721217,
            nbits: 0xffff191f,
            nonce: 0x0000014b
        };
        let BLOCKHEADER_903725: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0x316e208c, 0xc5c5ca3d, 0x4af785b9, 0x2b57cd0d, 0x9b95b0d0, 0x32f54c7b, 0x7e97238c, 0x1db80100],
            merkle_root: [0x963a8eed, 0x56d9ade4, 0xca8c6580, 0x7845aa74, 0x2e080d51, 0x80d031e9, 0x1ebd78c0, 0x878edc65],
            reversed_timestamp: 0x16741217,
            nbits: 0xffff191f,
            nonce: 0x00000230
        };
        let mut stored_blockheader_0: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_903724,
            block_hash: [0x316e208c, 0xc5c5ca3d, 0x4af785b9, 0x2b57cd0d, 0x9b95b0d0, 0x32f54c7b, 0x7e97238c, 0x1db80100],
            chain_work: 0x00000000000000000000000000000000000000000000000000005d1a4110e46d,
            block_height: 903724,
            last_diff_adjustment: 386751302,
            prev_block_timestamps: [387078902, 387079502, 387080102, 387080702, 387081302, 387081902, 387082502, 387083102, 387083702, 387084302]
        };
        stored_blockheader_0.update_chain(BLOCKHEADER_903725, 387085334);
    }

    #[test]
    #[should_panic(expected: 'update_chain: nbits')]
    fn random_fail_block_wrong_nbits() {
        // Invalid random block update, due to wrong nBits

        let BLOCKHEADER_909205: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0x62c1cfe9, 0x0a4e3208, 0x48d56715, 0x87644208, 0x4ae973a2, 0xfed5c061, 0x16884e90, 0x57e77f53],
            merkle_root: [0xd2ae25eb, 0xc86663e0, 0x517fed19, 0x27b602b2, 0xee3f368c, 0xec454e46, 0xfc23182e, 0x4caa1d99],
            reversed_timestamp: 0x120ef650,
            nbits: 0xffff191f,
            nonce: 0x000005e6
        };
        let BLOCKHEADER_909206: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0xa3cbd223, 0x5caba996, 0x50782f05, 0x42a5be56, 0xf3a1b79b, 0x16e6a703, 0xaabeb25a, 0x7e240200],
            merkle_root: [0xbb94de29, 0x6d755c68, 0xd97da2f0, 0xf88a0f0c, 0x830f7dd1, 0xa8b1be5a, 0x7ca88a0f, 0x23b10a0c],
            reversed_timestamp: 0xa711f650,
            nbits: 0xffff4f1f,
            nonce: 0x000005b2
        };
        let mut stored_blockheader_0: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_909205,
            block_hash: [0xa3cbd223, 0x5caba996, 0x50782f05, 0x42a5be56, 0xf3a1b79b, 0x16e6a703, 0xaabeb25a, 0x7e240200],
            chain_work: 0x000000000000000000000004869efd136d6f829ad233728bf4f9a16fd082e10e,
            block_height: 909205,
            last_diff_adjustment: 1357099738,
            prev_block_timestamps: [1358296738, 1358297338, 1358297938, 1358298538, 1358299138, 1358299738, 1358300338, 1358300938, 1358301538, 1358302138]
        };
        stored_blockheader_0.update_chain(BLOCKHEADER_909206, 1358303655);
    }
    
    #[test]
    #[should_panic(expected: 'update_chain: new nbits')]
    fn random_fail_block_wrong_nbits_diff_adjustment() {
        // Invalid random block update, due to wrong nBits during difficulty retarget

        let BLOCKHEADER_249983: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0x029e7790, 0xa57c2169, 0x4cb97f60, 0x090957aa, 0x07e44131, 0x013cda1c, 0x0eeb40de, 0xe229bfe1],
            merkle_root: [0x1f3b2f4a, 0x0dc38185, 0x3cf19585, 0xce6bfd4c, 0x9477c45a, 0xedc9b958, 0x8c2e5090, 0xfccc0cf1],
            reversed_timestamp: 0x88d13e20,
            nbits: 0xffff191f,
            nonce: 0x00000f54
        };
        let BLOCKHEADER_249984: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0x872af29c, 0xadaab3c5, 0xcd8c5f20, 0x73ebae13, 0x75c1277e, 0x987cef2b, 0xdeff73a1, 0xe3900100],
            merkle_root: [0xf8bbc549, 0xdd60e721, 0x7aaa0865, 0xbfad0d16, 0x451e6777, 0xe997e796, 0xa5061ed5, 0xea70071c],
            reversed_timestamp: 0xccd33e20,
            nbits: 0xffff4f1f,
            nonce: 0x000000b8
        };
        let mut stored_blockheader_0: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_249983,
            block_hash: [0x872af29c, 0xadaab3c5, 0xcd8c5f20, 0x73ebae13, 0x75c1277e, 0x987cef2b, 0xdeff73a1, 0xe3900100],
            chain_work: 0x00000000000000001459185fa3c6f8ed197c6e64dc1a37ced57eb9b9b661ad13,
            block_height: 249983,
            last_diff_adjustment: 539778784,
            prev_block_timestamps: [540981784, 540982384, 540982984, 540983584, 540984184, 540984784, 540985384, 540985984, 540986584, 540987184]
        };
        stored_blockheader_0.update_chain(BLOCKHEADER_249984, 540988364);
    }

    #[test]
    #[should_panic(expected: 'update_chain: prev blockhash')]
    fn random_fail_block_invalid_prev_blockhash() {
        // Invalid random block update, due to wrong previous blockhash

        let BLOCKHEADER_883430: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0x33f2ba16, 0x65fc7a01, 0x1a1fc707, 0x2196552b, 0xcf6026cf, 0xe87b7ac9, 0xeb4a8608, 0x60160249],
            merkle_root: [0x3236d5c3, 0x69403955, 0x1c6dd6ba, 0xbb9f1e7a, 0xa358493e, 0x35d297db, 0x9b2a2448, 0x2cedb1e6],
            reversed_timestamp: 0x5b559155,
            nbits: 0x02f8101f,
            nonce: 0x00001aea
        };
        let BLOCKHEADER_883431: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0x6ab2c299, 0x91a94404, 0x78cb16cb, 0x80f7f48e, 0xa8f98f6e, 0xf1582202, 0x0ddc8b8b, 0xb3a2c0ef],
            merkle_root: [0xee228bc5, 0x260d4d36, 0xa316bff2, 0x83c1a348, 0xb590ea5b, 0x43ad0b96, 0xa5c4fdc6, 0x0db153dc],
            reversed_timestamp: 0x7e599155,
            nbits: 0x02f8101f,
            nonce: 0x000008c9
        };
        let mut stored_blockheader_0: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_883430,
            block_hash: [0xd98deb3c, 0xd3ec19f4, 0xdc055b1e, 0x50ec9f37, 0xc00a2666, 0x4dd9149c, 0x3459b492, 0x442e0100],
            chain_work: 0x0000000000000000000000000000000000000000000000000000000000000f17,
            block_height: 883430,
            last_diff_adjustment: 1435334731,
            prev_block_timestamps: [1435581931, 1435582531, 1435583131, 1435583731, 1435584331, 1435584931, 1435585531, 1435586131, 1435586731, 1435587331]
        };
        stored_blockheader_0.update_chain(BLOCKHEADER_883431, 1435588990);
    }

    #[test]
    #[should_panic(expected: 'update_chain: timestamp median')]
    fn random_fail_block_timestamp_median() {
        // Invalid random block update, due to timestamp not being larger than median of last 11 blocks

        let BLOCKHEADER_808574: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0x14fec78b, 0xb3457b89, 0x5d788ca0, 0x2191dc2d, 0xce548a79, 0xfaa862ab, 0x4a510629, 0xb8484ab1],
            merkle_root: [0x8c1d4619, 0xafc28f84, 0x9144b6b8, 0x2e000f11, 0xc0eb3f24, 0xaa8ed452, 0x94bd7f44, 0x9de2c000],
            reversed_timestamp: 0x76801b0f,
            nbits: 0x2bb4101f,
            nonce: 0x0000026f
        };
        let BLOCKHEADER_808575: BlockHeader = BlockHeader {
            reversed_version: 0x00000000,
            previous_blockhash: [0xf0250791, 0x52884de7, 0xb0a0a62f, 0xce06aef2, 0xb75e9a02, 0xa65b64ec, 0x84f6e8bf, 0x40960000],
            merkle_root: [0xf50b5ae2, 0xd4c76250, 0x4a91706d, 0x99d3c746, 0xd88bbef9, 0x5a9de137, 0x711af2ae, 0x6ceb5123],
            reversed_timestamp: 0x64711b0f,
            nbits: 0x2bb4101f,
            nonce: 0x00000f9e
        };
        let mut stored_blockheader_0: StoredBlockHeader = StoredBlockHeader {
            blockheader: BLOCKHEADER_808574,
            block_hash: [0xf0250791, 0x52884de7, 0xb0a0a62f, 0xce06aef2, 0xb75e9a02, 0xa65b64ec, 0x84f6e8bf, 0x40960000],
            chain_work: 0x000000000000000000000000000000055618b01a346810c5a5e24744f1552751,
            block_height: 808574,
            last_diff_adjustment: 253365798,
            prev_block_timestamps: [253456862, 253453965, 253454855, 253457327, 253453385, 253459970, 253455833, 253459296, 253454481, 253458523]
        };
        stored_blockheader_0.update_chain(BLOCKHEADER_808575, 253456740);
    }

}
