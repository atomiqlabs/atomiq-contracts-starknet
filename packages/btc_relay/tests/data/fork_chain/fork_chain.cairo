use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

pub const TIMESTAMP: u64 = 1700000000;

const BLOCKHEADER_4: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe227d753, 0x9d6b363f, 0x4b5ca68c, 0xa67c1c34, 0xfc9750bb, 0x542a52dc, 0xdfbba94f, 0x7b8e7c00],
    merkle_root: [0x5fa68c0e, 0xd977e5e4, 0x32a9e043, 0x41ddce9f, 0xe86e7837, 0xe7c0821f, 0x70cfc1c5, 0x2beec7bc],
    reversed_timestamp: 0x60386859,
    nbits: 0xffff7f1f,
    nonce: 0x00000132
};
const BLOCKHEADER_5: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x86583419, 0x25603e86, 0x65fbcd01, 0x6ce658d1, 0x9bdc0e2e, 0x7df03462, 0xaeebebe1, 0xa9d90700],
    merkle_root: [0x4e0630f7, 0xbe7044cc, 0xf3fec7e4, 0x1de5ebff, 0x9af71a7e, 0xc2ebe29c, 0xd2caf3af, 0x48c18a65],
    reversed_timestamp: 0xb83a6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000234
};
const BLOCKHEADER_6: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x04fc1335, 0x32f282c6, 0xf9872660, 0x776c24f4, 0x86897c32, 0x0947bd2c, 0xe5680419, 0x0f9b0c00],
    merkle_root: [0xcc51ab26, 0x9390ad09, 0xf89e1275, 0xf2e38141, 0x64b63a4a, 0xccd59a89, 0x694da39d, 0xa33fd504],
    reversed_timestamp: 0x103d6859,
    nbits: 0xffff7f1f,
    nonce: 0x000002b9
};
const BLOCKHEADER_7: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1a2ff260, 0xe90cd48b, 0xe0bb2f74, 0x1d5786ab, 0xa4b9d243, 0x87f1903d, 0xc3497db4, 0xd5ec3f00],
    merkle_root: [0x92ed9219, 0x8fea0c1e, 0x70e3353e, 0x193ae692, 0xc9249521, 0x9a112bb4, 0xd06eb0c4, 0x0d48e283],
    reversed_timestamp: 0x683f6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000001
};
const BLOCKHEADER_8: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb7b4675e, 0x157fbc73, 0xbd115bc0, 0x6b6f9919, 0x9c0ae2a0, 0x44873c8a, 0xfdcf9bd5, 0x990d6500],
    merkle_root: [0x1cf16b61, 0x175c2a46, 0xb13f4731, 0xef5db4d6, 0x7ba40224, 0xcb931937, 0x170ddfcb, 0xd81e3460],
    reversed_timestamp: 0xc0416859,
    nbits: 0xffff7f1f,
    nonce: 0x00000079
};
const BLOCKHEADER_9: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x0b0ea516, 0x30a7f7f4, 0x991c3c22, 0xaca6cbc9, 0xf62a51e1, 0x9330a60f, 0xd49fca2f, 0xef0b1700],
    merkle_root: [0x381f53ec, 0xf9497ea5, 0xed15607b, 0xf95ef849, 0xc27b9ada, 0xb13ed66a, 0x2971362a, 0xa5b173c5],
    reversed_timestamp: 0x18446859,
    nbits: 0xffff7f1f,
    nonce: 0x00000017
};
const BLOCKHEADER_10: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2ee6421d, 0x01accac2, 0xcb580878, 0xa3521af1, 0xfdcc8186, 0x9e89471d, 0x26495125, 0x1f845f00],
    merkle_root: [0x3f534919, 0x96dd351e, 0x1b4ca677, 0xfbb3a082, 0xf8517c72, 0x924de164, 0xdd3dc82f, 0xcaa9f5bf],
    reversed_timestamp: 0x70466859,
    nbits: 0xffff7f1f,
    nonce: 0x00000388
};
const BLOCKHEADER_11: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1d66a3fe, 0x397715a0, 0xda21926a, 0x668694bf, 0xf68f9365, 0xb80614b8, 0x38d5c6bd, 0xfa224200],
    merkle_root: [0x5fd4a4fa, 0xf220d06d, 0xd912f7fc, 0x39ed69d7, 0x9264a917, 0xb37733cf, 0x9359b0ae, 0x10ef0ef9],
    reversed_timestamp: 0xc8486859,
    nbits: 0xffff7f1f,
    nonce: 0x0000021f
};
const BLOCKHEADER_12: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb62a2a06, 0xb80ea998, 0x85930612, 0x55914e32, 0x3dad1507, 0x28e0d95a, 0x02024860, 0x89197d00],
    merkle_root: [0x3959b253, 0x59bc149c, 0xa102a644, 0x6ed2ec6c, 0x53ef5166, 0xbc5865b4, 0x098a6639, 0xcacbdd7a],
    reversed_timestamp: 0x204b6859,
    nbits: 0xffff7f1f,
    nonce: 0x000002df
};
const BLOCKHEADER_13: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xfb599897, 0x2a7db542, 0xf8fac3af, 0x587ad7e6, 0xc3b79716, 0x50580e6f, 0xe5fada63, 0x1de13f00],
    merkle_root: [0x2fd6ee2b, 0xdb8d4eed, 0xa8b38fbd, 0x5fc4080a, 0x5885da32, 0xbf382412, 0x403e6869, 0x09784ec2],
    reversed_timestamp: 0x784d6859,
    nbits: 0xffff7f1f,
    nonce: 0x000003ce
};
const BLOCKHEADER_14: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9ea819c2, 0xd1f1bee8, 0x4c12688c, 0x3e485a96, 0x85579598, 0xca4238f8, 0x1ea46cd8, 0x6e085d00],
    merkle_root: [0xaacf8628, 0x3b764aa0, 0x72891479, 0xb1d3c776, 0xc01dedea, 0xcb753352, 0x66287a7b, 0x9c78592a],
    reversed_timestamp: 0xd04f6859,
    nbits: 0xffff7f1f,
    nonce: 0x0000002d
};
const BLOCKHEADER_15: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8773609f, 0x9d3d8245, 0xc84d4453, 0x9ec49d6b, 0x192fdf36, 0x032396fb, 0x69957776, 0x67c57300],
    merkle_root: [0x1cc4a1ca, 0x9a6a8bf6, 0xd5879497, 0x8cf61208, 0xebe8d298, 0xbe6bb156, 0xd9fb0c5d, 0xc85dff8b],
    reversed_timestamp: 0x28526859,
    nbits: 0xffff7f1f,
    nonce: 0x0000001e
};
const BLOCKHEADER_16: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x857fa0ee, 0x7215ef5b, 0xa636cc8b, 0x6f1196c0, 0x22b003ca, 0xcdcea7c1, 0x1e63d6a7, 0xa17b2500],
    merkle_root: [0x53d27e8b, 0x1f07a5f9, 0xa6cec46f, 0xbc151999, 0x84e8fb54, 0x2131900d, 0x96ffc10e, 0x3c481b13],
    reversed_timestamp: 0x80546859,
    nbits: 0xffff7f1f,
    nonce: 0x000004ce
};
const BLOCKHEADER_17: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xea12280d, 0xa558aa86, 0x5e5189fb, 0xca24a35b, 0xdb11f48a, 0x79bf019c, 0x8e1ec00f, 0x4c031600],
    merkle_root: [0x8d983995, 0x0227a4d9, 0xaa1af969, 0x1760f077, 0xadccaddd, 0x56893830, 0xf2a45106, 0x6b7366f0],
    reversed_timestamp: 0xd8566859,
    nbits: 0xffff7f1f,
    nonce: 0x00000520
};
const BLOCKHEADER_18: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xedd2afe7, 0x3e5e2b6a, 0x0ef44462, 0x388f7576, 0x3a6f19f4, 0x6409c09b, 0xd449852b, 0xd5fe5d00],
    merkle_root: [0xde714e83, 0x771efdb4, 0x979142dc, 0x9d0a7478, 0xf64c1123, 0xd6712ab6, 0x3e6813a4, 0x5dc80d4c],
    reversed_timestamp: 0x30596859,
    nbits: 0xffff7f1f,
    nonce: 0x000000f0
};
const BLOCKHEADER_19: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf540c141, 0xc5e1cecf, 0x5e1526e2, 0x02981a92, 0x2316ba7c, 0xf1eced49, 0xd400951e, 0xdc744700],
    merkle_root: [0xafefe671, 0x624340cc, 0x1810d357, 0x66733227, 0x61e5c839, 0x48ab1bca, 0x182d98fd, 0x1c97a56b],
    reversed_timestamp: 0x885b6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000119
};
const BLOCKHEADER_20: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9da176cc, 0x71480e4d, 0x8777d77c, 0x06b19088, 0x469c54f2, 0xae6de94d, 0x1a55af2b, 0x50410600],
    merkle_root: [0x41ea338e, 0xe860bccb, 0xd66e8230, 0x209f208b, 0xf15a4ae9, 0x65d2ee79, 0xd2f2ce7a, 0x6d1574d5],
    reversed_timestamp: 0xe05d6859,
    nbits: 0xffff7f1f,
    nonce: 0x000000a9
};
const BLOCKHEADER_21: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x994181fc, 0x2af46f88, 0x29203420, 0x3c02f4ef, 0xb673b442, 0xf72b31d3, 0xec8c82d8, 0x8d6d4600],
    merkle_root: [0x2396d454, 0x2130a258, 0xacb38d73, 0xa03476fd, 0xc0dd6032, 0xee64389d, 0x8920fb49, 0x7061995a],
    reversed_timestamp: 0x38606859,
    nbits: 0xffff7f1f,
    nonce: 0x00000391
};
const BLOCKHEADER_22: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3b49a890, 0x791002f8, 0xb117edb0, 0x671fc5a6, 0x383d3e50, 0x5fcff298, 0x24d1f9cd, 0x5fda4f00],
    merkle_root: [0x69d7f925, 0x49c68b8c, 0x377c067a, 0x68dc2642, 0xb7dee632, 0x837c4e67, 0x7d68472b, 0x0e576217],
    reversed_timestamp: 0x90626859,
    nbits: 0xffff7f1f,
    nonce: 0x00000235
};
const BLOCKHEADER_23: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x45452f20, 0x8ac5b9b2, 0x825bcd80, 0xba5f7231, 0xc9b810e4, 0xf9ca5d1c, 0x161e7f19, 0xfd1b2200],
    merkle_root: [0xc15a9f95, 0x1b38e177, 0xe8880e3f, 0x7ae821fd, 0xa50c1832, 0x967f6725, 0xa3403d20, 0xf686c2a5],
    reversed_timestamp: 0xe8646859,
    nbits: 0xffff7f1f,
    nonce: 0x00000116
};
const BLOCKHEADER_24: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x485df829, 0x8ca18da4, 0xdcc4c290, 0x0090e5fd, 0x1ad22388, 0x798deced, 0x320c2585, 0xfc0a1a00],
    merkle_root: [0x63192ca0, 0x4154ae05, 0xc91325d9, 0x80dacf4c, 0x9258a710, 0x2f0c8ba9, 0xebcb1e4d, 0x3f5f0611],
    reversed_timestamp: 0x40676859,
    nbits: 0xffff7f1f,
    nonce: 0x00000176
};

pub const BLOCKHEADERS: [BlockHeader; 20] = [
    BLOCKHEADER_5,
    BLOCKHEADER_6,
    BLOCKHEADER_7,
    BLOCKHEADER_8,
    BLOCKHEADER_9,
    BLOCKHEADER_10,
    BLOCKHEADER_11,
    BLOCKHEADER_12,
    BLOCKHEADER_13,
    BLOCKHEADER_14,
    BLOCKHEADER_15,
    BLOCKHEADER_16,
    BLOCKHEADER_17,
    BLOCKHEADER_18,
    BLOCKHEADER_19,
    BLOCKHEADER_20,
    BLOCKHEADER_21,
    BLOCKHEADER_22,
    BLOCKHEADER_23,
    BLOCKHEADER_24,
];

pub const STORED_BLOCKHEADERS: [StoredBlockHeader; 21] = [
    StoredBlockHeader {
        blockheader: BLOCKHEADER_4,
        block_hash: [0x86583419, 0x25603e86, 0x65fbcd01, 0x6ce658d1, 0x9bdc0e2e, 0x7df03462, 0xaeebebe1, 0xa9d90700],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000a00,
        block_height: 4,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_5,
        block_hash: [0x04fc1335, 0x32f282c6, 0xf9872660, 0x776c24f4, 0x86897c32, 0x0947bd2c, 0xe5680419, 0x0f9b0c00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000c00,
        block_height: 5,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_6,
        block_hash: [0x1a2ff260, 0xe90cd48b, 0xe0bb2f74, 0x1d5786ab, 0xa4b9d243, 0x87f1903d, 0xc3497db4, 0xd5ec3f00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000e00,
        block_height: 6,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_7,
        block_hash: [0xb7b4675e, 0x157fbc73, 0xbd115bc0, 0x6b6f9919, 0x9c0ae2a0, 0x44873c8a, 0xfdcf9bd5, 0x990d6500],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001000,
        block_height: 7,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_8,
        block_hash: [0x0b0ea516, 0x30a7f7f4, 0x991c3c22, 0xaca6cbc9, 0xf62a51e1, 0x9330a60f, 0xd49fca2f, 0xef0b1700],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001200,
        block_height: 8,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_9,
        block_hash: [0x2ee6421d, 0x01accac2, 0xcb580878, 0xa3521af1, 0xfdcc8186, 0x9e89471d, 0x26495125, 0x1f845f00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001400,
        block_height: 9,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_10,
        block_hash: [0x1d66a3fe, 0x397715a0, 0xda21926a, 0x668694bf, 0xf68f9365, 0xb80614b8, 0x38d5c6bd, 0xfa224200],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001600,
        block_height: 10,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_11,
        block_hash: [0xb62a2a06, 0xb80ea998, 0x85930612, 0x55914e32, 0x3dad1507, 0x28e0d95a, 0x02024860, 0x89197d00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001800,
        block_height: 11,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_12,
        block_hash: [0xfb599897, 0x2a7db542, 0xf8fac3af, 0x587ad7e6, 0xc3b79716, 0x50580e6f, 0xe5fada63, 0x1de13f00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001a00,
        block_height: 12,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_13,
        block_hash: [0x9ea819c2, 0xd1f1bee8, 0x4c12688c, 0x3e485a96, 0x85579598, 0xca4238f8, 0x1ea46cd8, 0x6e085d00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001c00,
        block_height: 13,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_14,
        block_hash: [0x8773609f, 0x9d3d8245, 0xc84d4453, 0x9ec49d6b, 0x192fdf36, 0x032396fb, 0x69957776, 0x67c57300],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001e00,
        block_height: 14,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_15,
        block_hash: [0x857fa0ee, 0x7215ef5b, 0xa636cc8b, 0x6f1196c0, 0x22b003ca, 0xcdcea7c1, 0x1e63d6a7, 0xa17b2500],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002000,
        block_height: 15,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_16,
        block_hash: [0xea12280d, 0xa558aa86, 0x5e5189fb, 0xca24a35b, 0xdb11f48a, 0x79bf019c, 0x8e1ec00f, 0x4c031600],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002200,
        block_height: 16,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_17,
        block_hash: [0xedd2afe7, 0x3e5e2b6a, 0x0ef44462, 0x388f7576, 0x3a6f19f4, 0x6409c09b, 0xd449852b, 0xd5fe5d00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002400,
        block_height: 17,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_18,
        block_hash: [0xf540c141, 0xc5e1cecf, 0x5e1526e2, 0x02981a92, 0x2316ba7c, 0xf1eced49, 0xd400951e, 0xdc744700],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002600,
        block_height: 18,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600, 1500010200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_19,
        block_hash: [0x9da176cc, 0x71480e4d, 0x8777d77c, 0x06b19088, 0x469c54f2, 0xae6de94d, 0x1a55af2b, 0x50410600],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002800,
        block_height: 19,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600, 1500010200, 1500010800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_20,
        block_hash: [0x994181fc, 0x2af46f88, 0x29203420, 0x3c02f4ef, 0xb673b442, 0xf72b31d3, 0xec8c82d8, 0x8d6d4600],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002a00,
        block_height: 20,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600, 1500010200, 1500010800, 1500011400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_21,
        block_hash: [0x3b49a890, 0x791002f8, 0xb117edb0, 0x671fc5a6, 0x383d3e50, 0x5fcff298, 0x24d1f9cd, 0x5fda4f00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002c00,
        block_height: 21,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600, 1500010200, 1500010800, 1500011400, 1500012000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_22,
        block_hash: [0x45452f20, 0x8ac5b9b2, 0x825bcd80, 0xba5f7231, 0xc9b810e4, 0xf9ca5d1c, 0x161e7f19, 0xfd1b2200],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002e00,
        block_height: 22,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500007200, 1500007800, 1500008400, 1500009000, 1500009600, 1500010200, 1500010800, 1500011400, 1500012000, 1500012600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_23,
        block_hash: [0x485df829, 0x8ca18da4, 0xdcc4c290, 0x0090e5fd, 0x1ad22388, 0x798deced, 0x320c2585, 0xfc0a1a00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000003000,
        block_height: 23,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500007800, 1500008400, 1500009000, 1500009600, 1500010200, 1500010800, 1500011400, 1500012000, 1500012600, 1500013200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_24,
        block_hash: [0xb4a2ceb8, 0x7dccf5dd, 0x7a92557e, 0x5b6b1046, 0x48cecb38, 0x49a1290f, 0x0586d570, 0x8d784400],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000003200,
        block_height: 24,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500008400, 1500009000, 1500009600, 1500010200, 1500010800, 1500011400, 1500012000, 1500012600, 1500013200, 1500013800]
    },
];
