use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

pub const TIMESTAMP: u64 = 1500000000;

const BLOCKHEADER_0: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000],
    merkle_root: [0x444ef92a, 0xe1dca0ea, 0x06550a25, 0x5f26c371, 0x42a40412, 0xa6dc3c00, 0x99104f13, 0xb00e7911],
    reversed_timestamp: 0x002f6859,
    nbits: 0xffff7f1f,
    nonce: 0x0000011a
};
const BLOCKHEADER_1: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6035cfe5, 0x31b91cdb, 0x8d87340e, 0x9b10150f, 0x58e4178d, 0x43e8c733, 0xcd9fbc83, 0xf56a4f00],
    merkle_root: [0x633b610c, 0xb4cba983, 0xc47fd24f, 0x174a5617, 0xdec4bed1, 0x8d1fe29b, 0x7d28733e, 0x6587a296],
    reversed_timestamp: 0x98696859,
    nbits: 0xffff7f1f,
    nonce: 0x00000072
};

pub const BLOCKHEADERS: [BlockHeader; 1] = [
    BLOCKHEADER_1,
];

pub const STORED_BLOCKHEADERS: [StoredBlockHeader; 2] = [
    StoredBlockHeader {
        blockheader: BLOCKHEADER_0,
        block_hash: [0x6035cfe5, 0x31b91cdb, 0x8d87340e, 0x9b10150f, 0x58e4178d, 0x43e8c733, 0xcd9fbc83, 0xf56a4f00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000200,
        block_height: 0,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1,
        block_hash: [0xf986dab8, 0x58191818, 0x2b8181f0, 0xa6c68034, 0x1bbfeaeb, 0xf641e442, 0xb84728fd, 0xef402500],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000400,
        block_height: 1,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000]
    },
];
