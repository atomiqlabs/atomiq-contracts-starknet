use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

pub const TIMESTAMP: u64 = 1700000000;

const BLOCKHEADER_0: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000],
    merkle_root: [0x9044f21d, 0xdbf585da, 0x244a855a, 0x8ff47663, 0xc6964833, 0xe9adf8f7, 0x23c0f10f, 0x837781de],
    reversed_timestamp: 0x002f6859,
    nbits: 0xffff001f,
    nonce: 0x00001db3
};
const BLOCKHEADER_1: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xacc2f5d5, 0x6d91ae30, 0x51afdfea, 0x44672280, 0x38c9b70b, 0xe3eca55f, 0xa1d9ff0e, 0x0ca20000],
    merkle_root: [0xd999c9ef, 0xf0351e12, 0x225b3720, 0x4a0277c7, 0x48b615b8, 0xa396af02, 0x29a7b12e, 0x06714a8f],
    reversed_timestamp: 0x58316859,
    nbits: 0xffff7f1f,
    nonce: 0x00000035
};

pub const BLOCKHEADERS: [BlockHeader; 1] = [
    BLOCKHEADER_1,
];

pub const STORED_BLOCKHEADERS: [StoredBlockHeader; 2] = [
    StoredBlockHeader {
        blockheader: BLOCKHEADER_0,
        block_hash: [0xacc2f5d5, 0x6d91ae30, 0x51afdfea, 0x44672280, 0x38c9b70b, 0xe3eca55f, 0xa1d9ff0e, 0x0ca20000],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000010001,
        block_height: 0,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1,
        block_hash: [0x058f8a74, 0x41b41fd2, 0x9204927d, 0x523a1993, 0x476b29b1, 0x5f5defc8, 0x48da14f2, 0x6ece1e00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000010201,
        block_height: 1,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000]
    },
];
