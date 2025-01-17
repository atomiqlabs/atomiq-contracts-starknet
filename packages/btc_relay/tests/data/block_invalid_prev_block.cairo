use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

pub const TIMESTAMP: u64 = 1700000000;

const BLOCKHEADER_0: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000],
    merkle_root: [0x7028fd71, 0x1bdee598, 0xc9f7b5f5, 0x699f6d29, 0x7bfb8ee7, 0x9fdf241d, 0x0b6bcf42, 0x06a4a2c7],
    reversed_timestamp: 0x002f6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000135
};
const BLOCKHEADER_1: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe06c516d, 0x30040312, 0x57594ec2, 0xee2ab51f, 0x90d10cd9, 0x5bcdc852, 0x3edc8e64, 0xcf65e618],
    merkle_root: [0xddf6886c, 0x13e049ca, 0x5b1f88e8, 0xb0911178, 0x3da23876, 0x8d9df40e, 0x05663597, 0xb5977635],
    reversed_timestamp: 0x58316859,
    nbits: 0xffff7f1f,
    nonce: 0x00000286
};

pub const BLOCKHEADERS: [BlockHeader; 1] = [
    BLOCKHEADER_1,
];

pub const STORED_BLOCKHEADERS: [StoredBlockHeader; 2] = [
    StoredBlockHeader {
        blockheader: BLOCKHEADER_0,
        block_hash: [0x643b1c98, 0xac335fc7, 0x0ad5f776, 0x9b9304a9, 0x61eb8e75, 0x5510d115, 0xfe8858b3, 0x9f967600],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000200,
        block_height: 0,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1,
        block_hash: [0xdbe08d4e, 0x90469219, 0xf00d2c0c, 0x959764c7, 0x97b454f4, 0xd8734ad3, 0xeeddef63, 0x023f4800],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000400,
        block_height: 1,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000]
    },
];
