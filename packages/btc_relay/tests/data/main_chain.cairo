use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

pub const TIMESTAMP: u64 = 1700000000;

const BLOCKHEADER_0: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000],
    merkle_root: [0x54206ac1, 0xb717504f, 0x058d0158, 0x9f651964, 0x5f9a67c5, 0xa13170d7, 0xad149345, 0xfbd761df],
    reversed_timestamp: 0x002f6859,
    nbits: 0xffff7f1f,
    nonce: 0x0000015d
};
const BLOCKHEADER_1: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x619314ce, 0x618ffe87, 0xe563e15d, 0xa160e4fc, 0x380760fb, 0x835ff351, 0x14afb098, 0x74620800],
    merkle_root: [0x0fc3de15, 0x1241935c, 0x4fd86312, 0x980d349d, 0x461d8a6d, 0x4c3da3b8, 0x4bad763d, 0x04c316b1],
    reversed_timestamp: 0x58316859,
    nbits: 0xffff7f1f,
    nonce: 0x00000363
};
const BLOCKHEADER_2: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc22170e5, 0x978f3240, 0xc793e3d0, 0x005d7576, 0xbaf1ba15, 0xff5da0ce, 0x8f6096c6, 0xe0153d00],
    merkle_root: [0x4d7cc547, 0xe7ddd941, 0xd47aa5e3, 0xfbb4e964, 0xd0c1686d, 0x9195403e, 0x1ec9c7b9, 0xb166452c],
    reversed_timestamp: 0xb0336859,
    nbits: 0xffff7f1f,
    nonce: 0x00000118
};
const BLOCKHEADER_3: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6964b5f9, 0x8c4968a9, 0xc3947332, 0xf182f790, 0xe71e3c45, 0xb5571e2e, 0x3c5976cb, 0xd9587600],
    merkle_root: [0xfdd8d4e5, 0x6e1036eb, 0x7adc64fc, 0xc66880c1, 0x826ed40a, 0x892c7619, 0x5ddcb5ec, 0x967c8c16],
    reversed_timestamp: 0x08366859,
    nbits: 0xffff7f1f,
    nonce: 0x0000006c
};
const BLOCKHEADER_4: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x64cd3727, 0xc1b3ae09, 0x0deaa342, 0xcdcdd7b8, 0xdf7ede83, 0x0d3b45c0, 0xdf57aafb, 0x8f693e00],
    merkle_root: [0x0d7758b1, 0x6c0ec225, 0xcf62a00a, 0xae564991, 0x24ea9e30, 0x3b18f495, 0x2fe12b64, 0xc2cbbb6c],
    reversed_timestamp: 0x60386859,
    nbits: 0xffff7f1f,
    nonce: 0x000002a5
};
const BLOCKHEADER_5: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2d6b5003, 0x9c6c471b, 0x9ccd2244, 0x27997893, 0xf4d6298e, 0xa56a32f9, 0x2cf84f5d, 0x68ff2a00],
    merkle_root: [0x1e81f601, 0xdcd6b8a7, 0x71443525, 0xe826e516, 0x0a690b4e, 0xc264af79, 0x1e40c2f4, 0x4a84d1ef],
    reversed_timestamp: 0xb83a6859,
    nbits: 0xffff7f1f,
    nonce: 0x000001f4
};
const BLOCKHEADER_6: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe23650de, 0x8f34e9ca, 0xdb7227b7, 0xc101ca64, 0xf9c16441, 0x063df312, 0x17c32c86, 0x35247f00],
    merkle_root: [0x1994b0cc, 0x3ebfeb61, 0x082d8f75, 0x4d8670f0, 0xde08ca55, 0x3525b159, 0x7571c452, 0x1ff08c65],
    reversed_timestamp: 0x103d6859,
    nbits: 0xffff7f1f,
    nonce: 0x000000d8
};
const BLOCKHEADER_7: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8547da57, 0x3134cedb, 0xd99faa30, 0x95321d35, 0xbc2de6bb, 0x643fa2ec, 0x9780f81b, 0x52097900],
    merkle_root: [0x30625780, 0xb9c93d91, 0x53278e3a, 0x57492787, 0xedc55311, 0x5c22a64f, 0x31921c8e, 0x2e56121a],
    reversed_timestamp: 0x683f6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000316
};
const BLOCKHEADER_8: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x850cd32f, 0xb5aae431, 0x77c71fb7, 0x43bcaf24, 0x1079a586, 0xed869e03, 0x2ad5f012, 0xa5cb0500],
    merkle_root: [0x545af3a4, 0x51222143, 0xbb1bf490, 0xe20debef, 0x25f49d79, 0xedc90bcd, 0xed9f3478, 0x201b37cc],
    reversed_timestamp: 0xc0416859,
    nbits: 0xffff7f1f,
    nonce: 0x000002c9
};
const BLOCKHEADER_9: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3b84827d, 0xd7921c4e, 0xf11aff43, 0x675eefc2, 0x9390be5d, 0xcfff8731, 0x91b65689, 0x4c625b00],
    merkle_root: [0x9bfdb3b5, 0x22b4c8da, 0xaa2eb917, 0xd5eb7c02, 0xfeaedcca, 0x9eeaf3b6, 0x49878c02, 0x7c631cf5],
    reversed_timestamp: 0x18446859,
    nbits: 0xffff7f1f,
    nonce: 0x000002a7
};
const BLOCKHEADER_10: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x90f34a71, 0x20bfba58, 0x250203ed, 0x13cfa828, 0x62f564db, 0xa8b828c5, 0xb871b01e, 0xb2463500],
    merkle_root: [0x4a6859e3, 0xda802af4, 0x7921e58a, 0x0a65a351, 0xf69843ce, 0x0478e5e7, 0x36117a70, 0x0ab75418],
    reversed_timestamp: 0x70466859,
    nbits: 0xffff7f1f,
    nonce: 0x00000173
};
const BLOCKHEADER_11: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xacac6bb1, 0x3406628e, 0x390b4cc7, 0xf286ae48, 0xa226f43a, 0x34decd06, 0x87b0b8c8, 0x33674e00],
    merkle_root: [0xe00b0b5b, 0x499da809, 0x73bfc294, 0x42bab38c, 0xf35284e1, 0x48605c99, 0x96432da5, 0xc6c091fc],
    reversed_timestamp: 0xc8486859,
    nbits: 0xffff7f1f,
    nonce: 0x00000009
};
const BLOCKHEADER_12: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x256107e5, 0x35300e1b, 0x0bfe24df, 0xc156d22c, 0xa91ca22b, 0xb8a0c688, 0xf6b4cfa7, 0x9eb77500],
    merkle_root: [0x8060ee65, 0xfdfa81c3, 0x01f31860, 0xc56cf599, 0xd862f223, 0x590dc656, 0x1477e771, 0x62b6280b],
    reversed_timestamp: 0x204b6859,
    nbits: 0xffff7f1f,
    nonce: 0x0000032f
};
const BLOCKHEADER_13: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xee69048f, 0x5a8b10fb, 0x1b5a25a4, 0xd061dd20, 0xb7a09cf1, 0x67641c72, 0xa0f0baea, 0x240e2000],
    merkle_root: [0x096e2561, 0x994d9e14, 0x98f955c2, 0x1502f795, 0x98dfd354, 0xc9e4524d, 0xcad03c94, 0x75b51b74],
    reversed_timestamp: 0x784d6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000560
};
const BLOCKHEADER_14: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa48e1fcf, 0x51828cd4, 0x252b6e51, 0xaaa355ea, 0x4050c30e, 0xcd89a77f, 0x0bd84d4b, 0x84e22500],
    merkle_root: [0xc3e4b392, 0x78d531aa, 0x9092995d, 0x6b7ec5d9, 0xb6af2fc2, 0x1e7fe802, 0x4b3dfc8a, 0xb14be4c5],
    reversed_timestamp: 0xd04f6859,
    nbits: 0xffff7f1f,
    nonce: 0x000005a2
};
const BLOCKHEADER_15: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xacd272e8, 0x01950820, 0xa5007e28, 0x87537f68, 0xc342e2b7, 0xfd4d691c, 0x3e13c48d, 0xb53e3100],
    merkle_root: [0x7446a028, 0x1b12451e, 0x43a12b31, 0x383350b5, 0x970f261b, 0xfcd43f88, 0x89b887d9, 0xfb669ee8],
    reversed_timestamp: 0x28526859,
    nbits: 0xffff7f1f,
    nonce: 0x0000018d
};
const BLOCKHEADER_16: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x39de9807, 0xb610a607, 0x4a421ac3, 0x6e1c6979, 0x0c28cdb8, 0x51b02b97, 0xebea3f01, 0x85404e00],
    merkle_root: [0x919c5a29, 0xfa899081, 0x9da5a75a, 0x747d41cf, 0xfe0da9a6, 0x35e42952, 0xf66cb85d, 0x8fe8ace3],
    reversed_timestamp: 0x80546859,
    nbits: 0xffff7f1f,
    nonce: 0x00000258
};
const BLOCKHEADER_17: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x825f9c2c, 0x07a2deaf, 0x7ec47aae, 0xf4f42366, 0x3a327988, 0x78102451, 0x13de55a8, 0x62ec5600],
    merkle_root: [0x556683ed, 0x4f01f4d9, 0x4c6d2ab1, 0xf12bdda3, 0xea732d26, 0xc01c1897, 0x637bf68f, 0x2d4a39d1],
    reversed_timestamp: 0xd8566859,
    nbits: 0xffff7f1f,
    nonce: 0x00000224
};
const BLOCKHEADER_18: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x26c76f18, 0xe8e13cda, 0xb2942fec, 0x93511fc9, 0x2e371439, 0xa95e0eae, 0x1a05151d, 0xafd74f00],
    merkle_root: [0x2d6922e0, 0xa56ff32a, 0xd86fc419, 0xca3407b5, 0x9f4f82fa, 0x06c9c0aa, 0x25964aa7, 0x1607c2ba],
    reversed_timestamp: 0x30596859,
    nbits: 0xffff7f1f,
    nonce: 0x00000269
};
const BLOCKHEADER_19: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x304fe2b7, 0xa2e21eb8, 0xe5fa4a27, 0x655afece, 0x9df754f5, 0xfd25bb12, 0x74cff133, 0x20190d00],
    merkle_root: [0xa1de79bd, 0x858b330a, 0x49b47a1b, 0x7eb61874, 0x44f2c458, 0x3c19aeb0, 0x509858d5, 0x9117ffa7],
    reversed_timestamp: 0x885b6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000aab
};
const BLOCKHEADER_20: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9e05626e, 0x2b36bd6b, 0x51226801, 0x6f5d98c8, 0xa9cd06ac, 0x27b81fd8, 0x5e3d24ed, 0x7c333600],
    merkle_root: [0x2b06162b, 0x7dd88d22, 0xb357333a, 0xdb3777ee, 0x5a05e741, 0xbcdfed89, 0x89c402aa, 0x9a1976b6],
    reversed_timestamp: 0xe05d6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000423
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
        block_hash: [0x619314ce, 0x618ffe87, 0xe563e15d, 0xa160e4fc, 0x380760fb, 0x835ff351, 0x14afb098, 0x74620800],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000200,
        block_height: 0,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1,
        block_hash: [0xc22170e5, 0x978f3240, 0xc793e3d0, 0x005d7576, 0xbaf1ba15, 0xff5da0ce, 0x8f6096c6, 0xe0153d00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000400,
        block_height: 1,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2,
        block_hash: [0x6964b5f9, 0x8c4968a9, 0xc3947332, 0xf182f790, 0xe71e3c45, 0xb5571e2e, 0x3c5976cb, 0xd9587600],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000600,
        block_height: 2,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_3,
        block_hash: [0x64cd3727, 0xc1b3ae09, 0x0deaa342, 0xcdcdd7b8, 0xdf7ede83, 0x0d3b45c0, 0xdf57aafb, 0x8f693e00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000800,
        block_height: 3,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_4,
        block_hash: [0x2d6b5003, 0x9c6c471b, 0x9ccd2244, 0x27997893, 0xf4d6298e, 0xa56a32f9, 0x2cf84f5d, 0x68ff2a00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000a00,
        block_height: 4,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_5,
        block_hash: [0xe23650de, 0x8f34e9ca, 0xdb7227b7, 0xc101ca64, 0xf9c16441, 0x063df312, 0x17c32c86, 0x35247f00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000c00,
        block_height: 5,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_6,
        block_hash: [0x8547da57, 0x3134cedb, 0xd99faa30, 0x95321d35, 0xbc2de6bb, 0x643fa2ec, 0x9780f81b, 0x52097900],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000e00,
        block_height: 6,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_7,
        block_hash: [0x850cd32f, 0xb5aae431, 0x77c71fb7, 0x43bcaf24, 0x1079a586, 0xed869e03, 0x2ad5f012, 0xa5cb0500],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001000,
        block_height: 7,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_8,
        block_hash: [0x3b84827d, 0xd7921c4e, 0xf11aff43, 0x675eefc2, 0x9390be5d, 0xcfff8731, 0x91b65689, 0x4c625b00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001200,
        block_height: 8,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_9,
        block_hash: [0x90f34a71, 0x20bfba58, 0x250203ed, 0x13cfa828, 0x62f564db, 0xa8b828c5, 0xb871b01e, 0xb2463500],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001400,
        block_height: 9,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_10,
        block_hash: [0xacac6bb1, 0x3406628e, 0x390b4cc7, 0xf286ae48, 0xa226f43a, 0x34decd06, 0x87b0b8c8, 0x33674e00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001600,
        block_height: 10,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_11,
        block_hash: [0x256107e5, 0x35300e1b, 0x0bfe24df, 0xc156d22c, 0xa91ca22b, 0xb8a0c688, 0xf6b4cfa7, 0x9eb77500],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001800,
        block_height: 11,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_12,
        block_hash: [0xee69048f, 0x5a8b10fb, 0x1b5a25a4, 0xd061dd20, 0xb7a09cf1, 0x67641c72, 0xa0f0baea, 0x240e2000],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001a00,
        block_height: 12,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_13,
        block_hash: [0xa48e1fcf, 0x51828cd4, 0x252b6e51, 0xaaa355ea, 0x4050c30e, 0xcd89a77f, 0x0bd84d4b, 0x84e22500],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001c00,
        block_height: 13,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_14,
        block_hash: [0xacd272e8, 0x01950820, 0xa5007e28, 0x87537f68, 0xc342e2b7, 0xfd4d691c, 0x3e13c48d, 0xb53e3100],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001e00,
        block_height: 14,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_15,
        block_hash: [0x39de9807, 0xb610a607, 0x4a421ac3, 0x6e1c6979, 0x0c28cdb8, 0x51b02b97, 0xebea3f01, 0x85404e00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002000,
        block_height: 15,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_16,
        block_hash: [0x825f9c2c, 0x07a2deaf, 0x7ec47aae, 0xf4f42366, 0x3a327988, 0x78102451, 0x13de55a8, 0x62ec5600],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002200,
        block_height: 16,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_17,
        block_hash: [0x26c76f18, 0xe8e13cda, 0xb2942fec, 0x93511fc9, 0x2e371439, 0xa95e0eae, 0x1a05151d, 0xafd74f00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002400,
        block_height: 17,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_18,
        block_hash: [0x304fe2b7, 0xa2e21eb8, 0xe5fa4a27, 0x655afece, 0x9df754f5, 0xfd25bb12, 0x74cff133, 0x20190d00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002600,
        block_height: 18,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600, 1500010200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_19,
        block_hash: [0x9e05626e, 0x2b36bd6b, 0x51226801, 0x6f5d98c8, 0xa9cd06ac, 0x27b81fd8, 0x5e3d24ed, 0x7c333600],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002800,
        block_height: 19,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600, 1500010200, 1500010800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_20,
        block_hash: [0x52f65fc1, 0x1f4257f2, 0x16e21833, 0x024249e0, 0xaabd5850, 0xb7162e1e, 0xfbaf81a3, 0x05bb7d00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002a00,
        block_height: 20,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600, 1500010200, 1500010800, 1500011400]
    },
];
