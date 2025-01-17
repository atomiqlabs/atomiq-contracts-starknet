use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

pub const TIMESTAMP: u64 = 1700000000;

const BLOCKHEADER_0: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000],
    merkle_root: [0xb44390c5, 0xf49433ca, 0x2c5ae30e, 0xb3ad9c6e, 0x545e2c3e, 0x24aeb082, 0xff649e77, 0x4c386cec],
    reversed_timestamp: 0x002f6859,
    nbits: 0xffff001f,
    nonce: 0x00007bfd
};
const BLOCKHEADER_1: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6a161738, 0x4efba0a8, 0xb278d3cd, 0x015e2c6f, 0xa38073c1, 0x8bf6da1b, 0x2a977886, 0x151e0000],
    merkle_root: [0x86894e56, 0x2bc1f68d, 0xa16b23c9, 0x678ec4e4, 0x78b979a5, 0x399788c7, 0xec8995fe, 0x2c22267c],
    reversed_timestamp: 0x58316859,
    nbits: 0xffff001f,
    nonce: 0x0000002d
};

pub const BLOCKHEADERS: [BlockHeader; 1] = [
    BLOCKHEADER_1,
];

pub const STORED_BLOCKHEADERS: [StoredBlockHeader; 2] = [
    StoredBlockHeader {
        blockheader: BLOCKHEADER_0,
        block_hash: [0x6a161738, 0x4efba0a8, 0xb278d3cd, 0x015e2c6f, 0xa38073c1, 0x8bf6da1b, 0x2a977886, 0x151e0000],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000010001,
        block_height: 0,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1,
        block_hash: [0x34380e15, 0x975784db, 0xa945821e, 0xa17108c1, 0x77149c75, 0xe540e0c0, 0xff7461d2, 0xe8301900],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000020002,
        block_height: 1,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000]
    },
];
