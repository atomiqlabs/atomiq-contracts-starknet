use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

pub const TIMESTAMP: u64 = 1700000000;

const BLOCKHEADER_9: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa65702c7, 0x0a242b04, 0x20a3d8c5, 0xb078736e, 0xbe9339ff, 0x2db15bcc, 0x379fc765, 0xbb8c4d00],
    merkle_root: [0x9d9343f0, 0x2ac3faec, 0xcb389755, 0x84979251, 0x50cc13a2, 0x041b394e, 0x6bcf8b75, 0x537a118f],
    reversed_timestamp: 0x18446859,
    nbits: 0xffff7f1f,
    nonce: 0x000001af
};
const BLOCKHEADER_10: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x732bc950, 0x3a029d34, 0xab789550, 0xd9edfe57, 0x4650baad, 0xb4874b28, 0xe83f1c01, 0xc4ae0000],
    merkle_root: [0x958520fc, 0x0bc425f5, 0xe5fbef15, 0xef3b1473, 0x23d8d1f8, 0x63221c3a, 0x644c8e5f, 0x17ad6707],
    reversed_timestamp: 0x70466859,
    nbits: 0xffff7f1f,
    nonce: 0x000005a9
};
const BLOCKHEADER_11: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7407a4e9, 0x7375666e, 0x37e5c575, 0x19d8dfd9, 0x95bfcdc0, 0x647a1ba6, 0xbce420da, 0xd3ab5600],
    merkle_root: [0xa5183951, 0x6ee9c9ff, 0x34fcc457, 0x2625fa30, 0x834821a0, 0x06789310, 0xe107a09d, 0x46c7c15a],
    reversed_timestamp: 0xc8486859,
    nbits: 0xffff7f1f,
    nonce: 0x000002e7
};
const BLOCKHEADER_12: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x92e1b39e, 0x5ca26cee, 0xaf7bdbe4, 0x0e853e96, 0xf763ae14, 0x43d130da, 0x58bbe424, 0xe1602400],
    merkle_root: [0x4b0d46b3, 0x9807995c, 0x4a7cc433, 0x17ee9939, 0x236e8aa7, 0x91f3e08d, 0x675d9338, 0xd9e8e855],
    reversed_timestamp: 0x204b6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000148
};
const BLOCKHEADER_13: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xef23f501, 0xa1a9bb21, 0x481edfdc, 0xf5a0e641, 0x083a6334, 0xcc58c3e2, 0xf79ca118, 0x33304b00],
    merkle_root: [0x42423bc3, 0x919398b4, 0xfa28954e, 0x1cb0af5b, 0xc8ad888d, 0xe5e500b1, 0xafe2af15, 0xe9f2b977],
    reversed_timestamp: 0x784d6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000250
};
const BLOCKHEADER_14: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6add5061, 0x6d889ee6, 0x376c4a83, 0x32318789, 0x5e0b5aa3, 0xdfd46072, 0xb756de41, 0x45db3800],
    merkle_root: [0xe0468794, 0xb1ed17cd, 0xdbc8daad, 0xd010cb4c, 0x42168951, 0x20eb9ccf, 0x6c424ae8, 0xc2e2d700],
    reversed_timestamp: 0xd04f6859,
    nbits: 0xffff7f1f,
    nonce: 0x000000a9
};

pub const BLOCKHEADERS: [BlockHeader; 5] = [
    BLOCKHEADER_10,
    BLOCKHEADER_11,
    BLOCKHEADER_12,
    BLOCKHEADER_13,
    BLOCKHEADER_14,
];

pub const STORED_BLOCKHEADERS: [StoredBlockHeader; 6] = [
    StoredBlockHeader {
        blockheader: BLOCKHEADER_9,
        block_hash: [0x732bc950, 0x3a029d34, 0xab789550, 0xd9edfe57, 0x4650baad, 0xb4874b28, 0xe83f1c01, 0xc4ae0000],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001400,
        block_height: 9,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_10,
        block_hash: [0x7407a4e9, 0x7375666e, 0x37e5c575, 0x19d8dfd9, 0x95bfcdc0, 0x647a1ba6, 0xbce420da, 0xd3ab5600],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001600,
        block_height: 10,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_11,
        block_hash: [0x92e1b39e, 0x5ca26cee, 0xaf7bdbe4, 0x0e853e96, 0xf763ae14, 0x43d130da, 0x58bbe424, 0xe1602400],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001800,
        block_height: 11,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_12,
        block_hash: [0xef23f501, 0xa1a9bb21, 0x481edfdc, 0xf5a0e641, 0x083a6334, 0xcc58c3e2, 0xf79ca118, 0x33304b00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001a00,
        block_height: 12,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_13,
        block_hash: [0x6add5061, 0x6d889ee6, 0x376c4a83, 0x32318789, 0x5e0b5aa3, 0xdfd46072, 0xb756de41, 0x45db3800],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001c00,
        block_height: 13,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_14,
        block_hash: [0xd98d72cd, 0x83bc9729, 0x9fe6710e, 0x0bda94c0, 0x88f6e6a7, 0xc67626c2, 0xfac3571a, 0x20593d00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001e00,
        block_height: 14,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800]
    },
];
