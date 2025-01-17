use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

pub const TIMESTAMP: u64 = 1700000000;

const BLOCKHEADER_0: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000],
    merkle_root: [0x6819243a, 0x02d43014, 0x81c7458f, 0xa9cbfa81, 0x79182752, 0xaa835f32, 0x06a73104, 0x8aacf1a0],
    reversed_timestamp: 0x002f6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000014
};
const BLOCKHEADER_1: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x522be796, 0x1586d6fb, 0x7166d5c4, 0xe96adacc, 0x13274de6, 0xa4e0b8c9, 0x732553d7, 0x26b57300],
    merkle_root: [0x0e1bdeaa, 0xa619ad49, 0x912a9516, 0xdbeeb943, 0x4ba48eb7, 0x35a2831f, 0xd09dcd62, 0x98be8dbd],
    reversed_timestamp: 0x58316859,
    nbits: 0xffff7f1f,
    nonce: 0x00000273
};
const BLOCKHEADER_2: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe312120a, 0xad188eca, 0x71e9c984, 0x376f8330, 0x6285eb62, 0x3eae8f0f, 0xfc0150b8, 0x12115800],
    merkle_root: [0x0eee7868, 0xd8e0a73e, 0x5dae480e, 0xac6538e3, 0x1ee468df, 0x5ed59063, 0x4b57d8e3, 0xb3d4f8db],
    reversed_timestamp: 0xb0336859,
    nbits: 0xffff7f1f,
    nonce: 0x0000049b
};
const BLOCKHEADER_3: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4e465c57, 0x983d32da, 0x2fc2bc20, 0x0613be7f, 0x60cb6148, 0x14e2405c, 0x462b0365, 0x79b50700],
    merkle_root: [0x229a2792, 0x164e4fcb, 0x41989432, 0x44c377b3, 0x00218f90, 0x74786537, 0x238b52bd, 0xd694d77f],
    reversed_timestamp: 0x08366859,
    nbits: 0xffff7f1f,
    nonce: 0x000000e0
};
const BLOCKHEADER_4: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4233bcd7, 0x75cd8ac1, 0xace00c5f, 0x8cb55a5b, 0x36eca32f, 0x15414807, 0x9cad0324, 0x6b9d2500],
    merkle_root: [0xa7547c7f, 0xc34bc1dd, 0x95d4a032, 0x7219646b, 0xf075b85c, 0x5eff96cd, 0xeb090e8c, 0x39b6130e],
    reversed_timestamp: 0x60386859,
    nbits: 0xffff7f1f,
    nonce: 0x0000001a
};
const BLOCKHEADER_5: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3b085c91, 0x2a367d87, 0xa2d90dbe, 0xacbc5e14, 0x230a7498, 0xf53b9267, 0x097d121a, 0xf5a03d00],
    merkle_root: [0xccb0f914, 0x05bc2bdf, 0x6ac33564, 0x5b0e852d, 0xeb02eb80, 0x2670a9cf, 0x5f1d7e02, 0x595eed4e],
    reversed_timestamp: 0xb83a6859,
    nbits: 0xffff7f1f,
    nonce: 0x0000000c
};
const BLOCKHEADER_6: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa9606529, 0x7efc3e77, 0xf7745fcd, 0xb3322ccc, 0x75b05228, 0xfa17e619, 0x9e37e15d, 0x41cf3300],
    merkle_root: [0x8254c4ea, 0xcfdf32c5, 0x049b5703, 0xd6fb2743, 0x5a1b48d2, 0x7a15b202, 0xcd5f9d92, 0xa0711014],
    reversed_timestamp: 0x103d6859,
    nbits: 0xffff7f1f,
    nonce: 0x000000ef
};
const BLOCKHEADER_7: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd08f859c, 0x27a3f612, 0xb6b23ef4, 0x4ba9ab76, 0xb480d7f8, 0x56da2cea, 0x86eb0775, 0x386c4900],
    merkle_root: [0xdefe3092, 0x872d8d18, 0xd3aa17aa, 0xca9d1008, 0xc235f058, 0xb1b33538, 0xdf0296ab, 0x54e9f3e7],
    reversed_timestamp: 0x683f6859,
    nbits: 0xffff7f1f,
    nonce: 0x000000d6
};
const BLOCKHEADER_8: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc1a34f72, 0x0c168efa, 0x00d4f61b, 0xa30e33ba, 0x11731913, 0xaf38d19f, 0x9f1e5ef9, 0xb25f2b00],
    merkle_root: [0xda5264e6, 0xb816a921, 0x0fc7fee8, 0x8216d555, 0x2787421d, 0x9470d000, 0x7f32900a, 0x79afe370],
    reversed_timestamp: 0xc0416859,
    nbits: 0xffff7f1f,
    nonce: 0x0000018a
};
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
    merkle_root: [0xd36e39ad, 0xf2baa7fe, 0xdb8e2b49, 0x6626126c, 0x481d8e67, 0xb5dc020c, 0x1a1b3c88, 0xd677c6a4],
    reversed_timestamp: 0x70466859,
    nbits: 0xffff7f1f,
    nonce: 0x0000010b
};
const BLOCKHEADER_11: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd7a889ab, 0xc756407e, 0x5997f01f, 0x6229ab49, 0x1e1b1f2b, 0xa60bb46a, 0x48ae2254, 0x71ed7d00],
    merkle_root: [0xba49110e, 0x0398f40a, 0xd153f76c, 0x6154c2ef, 0xef2d5df2, 0x4ae7a61e, 0x59595f6e, 0xba9b60d0],
    reversed_timestamp: 0xc8486859,
    nbits: 0xffff7f1f,
    nonce: 0x00000263
};
const BLOCKHEADER_12: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf8708952, 0x904f7e3f, 0x0bff36d3, 0x40fcafe1, 0x8447558b, 0x61c91ac3, 0x738617d6, 0xc4931d00],
    merkle_root: [0x795cb4ea, 0x53a89479, 0xce5845a7, 0x5df7ff71, 0xb3f7381d, 0x1430b6cb, 0x485c0d49, 0x4e7efbb8],
    reversed_timestamp: 0x204b6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000086
};
const BLOCKHEADER_13: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x26c3e9b8, 0xe5d29e87, 0x85d79a55, 0xbd44a62f, 0x327a9f20, 0x025d7065, 0x6d98fc5b, 0x22813700],
    merkle_root: [0x451e4abc, 0xc7e2cf01, 0x1072928c, 0x8e9fd1da, 0x331b6d19, 0xa5c08674, 0x7695820a, 0xe8b8d5ac],
    reversed_timestamp: 0x784d6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000045
};
const BLOCKHEADER_14: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xba3f8841, 0xd33fe4c1, 0x75b5e73b, 0x60065bd6, 0x4f9e4607, 0x8621e7e5, 0x48ffe6e4, 0xa5857200],
    merkle_root: [0x2988dab7, 0x71565609, 0xfd46fa45, 0x8eefbd8b, 0x41b45d34, 0x66a48465, 0x07fb3410, 0xba52f8be],
    reversed_timestamp: 0xd04f6859,
    nbits: 0xffff7f1f,
    nonce: 0x000001f9
};
const BLOCKHEADER_15: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4d53f037, 0x7385de38, 0x51a46e15, 0x9ffd9a06, 0x1c0438f3, 0x04ecb87e, 0x19b8ca4f, 0x0acd4900],
    merkle_root: [0x448117d6, 0xfc4dc35e, 0xb21ae529, 0xa3c05ed5, 0x45a7372c, 0x061eca7c, 0xa2d053c5, 0x45efd635],
    reversed_timestamp: 0x28526859,
    nbits: 0xffff7f1f,
    nonce: 0x000001c1
};
const BLOCKHEADER_16: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3e2c4e65, 0x2ba48145, 0x68631a50, 0xf0bd223d, 0x8539043a, 0x22c0a865, 0xda44da4d, 0x8bde5500],
    merkle_root: [0xcd4b79ee, 0xd6f60605, 0x186f7860, 0xab5a9ee6, 0x1391f585, 0x2484aa29, 0xcf8a9f67, 0x8c3d4554],
    reversed_timestamp: 0x80546859,
    nbits: 0xffff7f1f,
    nonce: 0x00000018
};
const BLOCKHEADER_17: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xfe623677, 0xaceffd2e, 0x172eae24, 0xd4afcfb2, 0x1374eb6d, 0xe388d0a2, 0x5327ce6f, 0xb9b65900],
    merkle_root: [0xf53f3feb, 0x8d28cdac, 0x707f11e1, 0x62da451c, 0x92193fab, 0xdd0856ef, 0xa444d461, 0x89824911],
    reversed_timestamp: 0xd8566859,
    nbits: 0xffff7f1f,
    nonce: 0x000001d4
};
const BLOCKHEADER_18: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3b2f33a2, 0xfb3fa0a3, 0xa620ddfd, 0x93d1989b, 0x08168017, 0x48eb84af, 0x5643337d, 0xb1174700],
    merkle_root: [0x7bd7606c, 0xf43d93db, 0x97e2edd9, 0xe7fda877, 0x57ee69a8, 0x3661feca, 0x78a280a3, 0x8abdea2b],
    reversed_timestamp: 0x30596859,
    nbits: 0xffff7f1f,
    nonce: 0x00000541
};
const BLOCKHEADER_19: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4c3de9be, 0xb8d39b84, 0xef5ca397, 0x1ffecb47, 0x4c8d1502, 0x6fc6adda, 0x69e6f5a0, 0xbb9c5800],
    merkle_root: [0xaf7ba499, 0x0068498a, 0x43802235, 0x1c155408, 0x249d990e, 0x9166b3d0, 0xf064e7c4, 0x34d96f0b],
    reversed_timestamp: 0x885b6859,
    nbits: 0xffff7f1f,
    nonce: 0x000003bf
};
const BLOCKHEADER_20: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd7ed3010, 0xf5ef6df7, 0xce939627, 0xddab81ad, 0xbb0d26f8, 0x23260111, 0xa10f31bc, 0xfe582100],
    merkle_root: [0x5436917b, 0xff2b2491, 0xfad3692b, 0x76de3037, 0x1d3b878b, 0xbcd90f9c, 0xe2331762, 0x07b27cc6],
    reversed_timestamp: 0xe05d6859,
    nbits: 0xffff7f1f,
    nonce: 0x0000030f
};

pub const BLOCKHEADERS: [BlockHeader; 20] = [
    BLOCKHEADER_1,
    BLOCKHEADER_2,
    BLOCKHEADER_3,
    BLOCKHEADER_4,
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
];

pub const STORED_BLOCKHEADERS: [StoredBlockHeader; 21] = [
    StoredBlockHeader {
        blockheader: BLOCKHEADER_0,
        block_hash: [0x522be796, 0x1586d6fb, 0x7166d5c4, 0xe96adacc, 0x13274de6, 0xa4e0b8c9, 0x732553d7, 0x26b57300],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000200,
        block_height: 0,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1,
        block_hash: [0xe312120a, 0xad188eca, 0x71e9c984, 0x376f8330, 0x6285eb62, 0x3eae8f0f, 0xfc0150b8, 0x12115800],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000400,
        block_height: 1,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2,
        block_hash: [0x4e465c57, 0x983d32da, 0x2fc2bc20, 0x0613be7f, 0x60cb6148, 0x14e2405c, 0x462b0365, 0x79b50700],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000600,
        block_height: 2,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_3,
        block_hash: [0x4233bcd7, 0x75cd8ac1, 0xace00c5f, 0x8cb55a5b, 0x36eca32f, 0x15414807, 0x9cad0324, 0x6b9d2500],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000800,
        block_height: 3,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_4,
        block_hash: [0x3b085c91, 0x2a367d87, 0xa2d90dbe, 0xacbc5e14, 0x230a7498, 0xf53b9267, 0x097d121a, 0xf5a03d00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000a00,
        block_height: 4,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_5,
        block_hash: [0xa9606529, 0x7efc3e77, 0xf7745fcd, 0xb3322ccc, 0x75b05228, 0xfa17e619, 0x9e37e15d, 0x41cf3300],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000c00,
        block_height: 5,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_6,
        block_hash: [0xd08f859c, 0x27a3f612, 0xb6b23ef4, 0x4ba9ab76, 0xb480d7f8, 0x56da2cea, 0x86eb0775, 0x386c4900],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000e00,
        block_height: 6,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_7,
        block_hash: [0xc1a34f72, 0x0c168efa, 0x00d4f61b, 0xa30e33ba, 0x11731913, 0xaf38d19f, 0x9f1e5ef9, 0xb25f2b00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001000,
        block_height: 7,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_8,
        block_hash: [0xa65702c7, 0x0a242b04, 0x20a3d8c5, 0xb078736e, 0xbe9339ff, 0x2db15bcc, 0x379fc765, 0xbb8c4d00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001200,
        block_height: 8,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200]
    },
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
        block_hash: [0xd7a889ab, 0xc756407e, 0x5997f01f, 0x6229ab49, 0x1e1b1f2b, 0xa60bb46a, 0x48ae2254, 0x71ed7d00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001600,
        block_height: 10,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_11,
        block_hash: [0xf8708952, 0x904f7e3f, 0x0bff36d3, 0x40fcafe1, 0x8447558b, 0x61c91ac3, 0x738617d6, 0xc4931d00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001800,
        block_height: 11,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_12,
        block_hash: [0x26c3e9b8, 0xe5d29e87, 0x85d79a55, 0xbd44a62f, 0x327a9f20, 0x025d7065, 0x6d98fc5b, 0x22813700],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001a00,
        block_height: 12,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_13,
        block_hash: [0xba3f8841, 0xd33fe4c1, 0x75b5e73b, 0x60065bd6, 0x4f9e4607, 0x8621e7e5, 0x48ffe6e4, 0xa5857200],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001c00,
        block_height: 13,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_14,
        block_hash: [0x4d53f037, 0x7385de38, 0x51a46e15, 0x9ffd9a06, 0x1c0438f3, 0x04ecb87e, 0x19b8ca4f, 0x0acd4900],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001e00,
        block_height: 14,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_15,
        block_hash: [0x3e2c4e65, 0x2ba48145, 0x68631a50, 0xf0bd223d, 0x8539043a, 0x22c0a865, 0xda44da4d, 0x8bde5500],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002000,
        block_height: 15,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_16,
        block_hash: [0xfe623677, 0xaceffd2e, 0x172eae24, 0xd4afcfb2, 0x1374eb6d, 0xe388d0a2, 0x5327ce6f, 0xb9b65900],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002200,
        block_height: 16,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_17,
        block_hash: [0x3b2f33a2, 0xfb3fa0a3, 0xa620ddfd, 0x93d1989b, 0x08168017, 0x48eb84af, 0x5643337d, 0xb1174700],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002400,
        block_height: 17,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_18,
        block_hash: [0x4c3de9be, 0xb8d39b84, 0xef5ca397, 0x1ffecb47, 0x4c8d1502, 0x6fc6adda, 0x69e6f5a0, 0xbb9c5800],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002600,
        block_height: 18,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600, 1500010200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_19,
        block_hash: [0xd7ed3010, 0xf5ef6df7, 0xce939627, 0xddab81ad, 0xbb0d26f8, 0x23260111, 0xa10f31bc, 0xfe582100],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002800,
        block_height: 19,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600, 1500010200, 1500010800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_20,
        block_hash: [0x4b9a532a, 0xd22c539c, 0xd5b2dc80, 0x4558245c, 0x6b18d3e2, 0xd45e001d, 0x12060994, 0x55847e00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002a00,
        block_height: 20,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600, 1500010200, 1500010800, 1500011400]
    },
];
