use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

pub const TIMESTAMP: u64 = 1700000000;

const BLOCKHEADER_10: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x522a5af5, 0xd909dca9, 0xc348163d, 0x7f3f00b3, 0xaff3b955, 0xc1fadb99, 0x9da7ed1f, 0x629b3000],
    merkle_root: [0xd8321f8d, 0x452abbc3, 0x4002470a, 0x39aacc44, 0x9b68c18e, 0xbdd213b3, 0x8a5b7f86, 0xbe01ad8a],
    reversed_timestamp: 0x70466859,
    nbits: 0xffff7f1f,
    nonce: 0x000001d1
};
const BLOCKHEADER_11: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd7e9034e, 0x25b2caa6, 0x2933d438, 0xd15b93f7, 0xee2405bf, 0xed41a248, 0xd900571c, 0xd93e5900],
    merkle_root: [0x4997000d, 0x325baaea, 0x43e9a377, 0x8a30f070, 0xd56457f3, 0x4748b491, 0x472c2d6a, 0x8feed636],
    reversed_timestamp: 0xb83a6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000034
};

pub const BLOCKHEADERS: [BlockHeader; 1] = [
    BLOCKHEADER_11,
];

pub const STORED_BLOCKHEADERS: [StoredBlockHeader; 2] = [
    StoredBlockHeader {
        blockheader: BLOCKHEADER_10,
        block_hash: [0xd7e9034e, 0x25b2caa6, 0x2933d438, 0xd15b93f7, 0xee2405bf, 0xed41a248, 0xd900571c, 0xd93e5900],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001600,
        block_height: 10,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_11,
        block_hash: [0xc334414a, 0xf8f39c72, 0xef8afa92, 0x03d75de9, 0x1d63c2f5, 0x7528fa49, 0xce81c9e1, 0x08a86f00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001800,
        block_height: 11,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000]
    },
];
