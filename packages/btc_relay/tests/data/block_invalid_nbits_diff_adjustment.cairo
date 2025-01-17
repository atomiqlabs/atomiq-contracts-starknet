use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

pub const TIMESTAMP: u64 = 1700000000;

const BLOCKHEADER_2015: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8fc05422, 0xa76a73e3, 0xfb9ce131, 0x59568d2d, 0x3203bf11, 0xb3f404fe, 0xa0aac84b, 0xf5db2300],
    merkle_root: [0x99f615a3, 0xa037df70, 0x9867487f, 0xfebbdf8f, 0x3c78bbc8, 0x69ad56b3, 0x1e838e51, 0x90ea4555],
    reversed_timestamp: 0xa8a17a59,
    nbits: 0xffff6f1f,
    nonce: 0x000000c0
};
const BLOCKHEADER_2016: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x051355cf, 0x23efb8f6, 0x67a697e3, 0x809ccd12, 0x81179444, 0x865c384d, 0x4549b9d6, 0x1e5e1b00],
    merkle_root: [0x611e395c, 0x93ac3b45, 0xf03257e9, 0xf1a0f073, 0x77eaa70b, 0x92a8175a, 0xff378aaf, 0x3910ba89],
    reversed_timestamp: 0x00a47a59,
    nbits: 0xffff7f1f,
    nonce: 0x000006fb
};

pub const BLOCKHEADERS: [BlockHeader; 1] = [
    BLOCKHEADER_2016,
];

pub const STORED_BLOCKHEADERS: [StoredBlockHeader; 2] = [
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2015,
        block_hash: [0x051355cf, 0x23efb8f6, 0x67a697e3, 0x809ccd12, 0x81179444, 0x865c384d, 0x4549b9d6, 0x1e5e1b00],
        chain_work: 0x000000000000000000000000000000000000000000000000000000000011fee0,
        block_height: 2015,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2016,
        block_hash: [0xab306b0b, 0x1a152ff1, 0xaa18fafe, 0x56b16395, 0x9b07ecff, 0xbb4cdf2e, 0x08cbc355, 0x43eb4e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000001200e0,
        block_height: 2016,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000]
    },
];
