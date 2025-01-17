use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

pub const TIMESTAMP: u64 = 1700000000;

const BLOCKHEADER_0: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000],
    merkle_root: [0xccbf5f6a, 0x8f3ebb2e, 0x79557384, 0xd100325f, 0xd64d81ab, 0xb0aff34b, 0x75210275, 0x04841909],
    reversed_timestamp: 0x002f6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000243
};
const BLOCKHEADER_1: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xbcc3d141, 0x8c33bea8, 0x0294bd6b, 0x1554e602, 0x746126fe, 0xbff3bb64, 0x49f1e066, 0x91e80900],
    merkle_root: [0x14fe58d1, 0x23b942a0, 0xa44cca77, 0x0bb90ed4, 0x8d75426f, 0xc965e40a, 0xfdd14113, 0x9745fc44],
    reversed_timestamp: 0x58316859,
    nbits: 0xffff7f1f,
    nonce: 0x000001fc
};
const BLOCKHEADER_2: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x29506475, 0xb16d8cfd, 0xabefd379, 0x17aa2a54, 0x34c85cdf, 0xdc2c8a92, 0x2e1ea6f2, 0x34fe4100],
    merkle_root: [0x6e1b050f, 0x375c76aa, 0xb8cfcdbd, 0x403ca233, 0xb3792fdc, 0x79591685, 0x9ccfee8c, 0xed2f0d87],
    reversed_timestamp: 0xb0336859,
    nbits: 0xffff7f1f,
    nonce: 0x000000ea
};
const BLOCKHEADER_3: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8d39c521, 0x49338125, 0x814c98be, 0x5a7c5b3e, 0x7418eb50, 0x73d129e2, 0x0b442c4a, 0xa1da4300],
    merkle_root: [0x9b74591c, 0x8d4e0736, 0xc02de523, 0x436b7717, 0x3628ed03, 0x1079e5c0, 0x812f560b, 0x409bf168],
    reversed_timestamp: 0x08366859,
    nbits: 0xffff7f1f,
    nonce: 0x0000021b
};
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
    merkle_root: [0xe3640007, 0x496d2715, 0x066804a4, 0xd6b4dc60, 0x0d676eb0, 0xd4e330d6, 0x81dc0773, 0x23e7406d],
    reversed_timestamp: 0xb83a6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000494
};
const BLOCKHEADER_6: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x72062c33, 0x71ed9297, 0x83db4eb0, 0x4ba035a4, 0x3921f70d, 0xae8abe66, 0xf9a12dba, 0x4ed27e00],
    merkle_root: [0xac9a24df, 0x697bd910, 0x8dfa8966, 0x66fe5181, 0x8ecbfbc8, 0xcb5d7c04, 0xee1ab7c7, 0x2ced0f39],
    reversed_timestamp: 0x103d6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000169
};
const BLOCKHEADER_7: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x52c2fa09, 0xb6c035f7, 0x1ea76cf7, 0xdb406c60, 0x56a29c98, 0x9646c381, 0x4d8c39d6, 0x653b2300],
    merkle_root: [0x0882e58e, 0xc802db87, 0xd3541412, 0x2b55a399, 0xfaf3363d, 0x1629f315, 0xe142ff40, 0xc6206445],
    reversed_timestamp: 0x683f6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000332
};
const BLOCKHEADER_8: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x95d50da1, 0x39eccace, 0x5236f3ff, 0xc5e04233, 0x12984b5e, 0xd6c76b18, 0xab839e4f, 0x409c2300],
    merkle_root: [0xdfe85064, 0x3d017d75, 0x8256f0bf, 0x5752b4ce, 0x75050a63, 0x6c5daf2d, 0xf71c1b9f, 0x39812101],
    reversed_timestamp: 0xc0416859,
    nbits: 0xffff7f1f,
    nonce: 0x0000036f
};
const BLOCKHEADER_9: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xdff11219, 0xfed81ab4, 0x59f8cba4, 0x319b9a40, 0x18da6c63, 0x7678a85f, 0x359f7137, 0x78355c00],
    merkle_root: [0x7de41e65, 0x409d0656, 0x9e526b1d, 0xc08ca2be, 0x60d65b26, 0x03b2a3b0, 0x492b3205, 0x45939cfa],
    reversed_timestamp: 0x18446859,
    nbits: 0xffff7f1f,
    nonce: 0x00000110
};
const BLOCKHEADER_10: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5cfec843, 0x1a1507d1, 0x2e7c38fc, 0x11c8860c, 0x10337f84, 0xe3ecb841, 0x04d893cb, 0xb0f84700],
    merkle_root: [0x815de7e2, 0x1b9cdae2, 0xf59b5178, 0xc801416f, 0x605d54a1, 0x1dd9ef83, 0x474b3433, 0x6c901ccc],
    reversed_timestamp: 0x70466859,
    nbits: 0xffff7f1f,
    nonce: 0x0000015a
};
const BLOCKHEADER_11: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xfbdfa38c, 0x32b7fd5d, 0xea1a3c7a, 0x7a78ad81, 0xec55be98, 0x0e541ce2, 0xec9e2c63, 0xfc900c00],
    merkle_root: [0xe01187ec, 0x424f2574, 0x901fc4ee, 0xbfc824f2, 0x24714995, 0x8956b470, 0x22a7a39d, 0x40ecb11f],
    reversed_timestamp: 0xc8486859,
    nbits: 0xffff7f1f,
    nonce: 0x00000003
};
const BLOCKHEADER_12: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x80938edf, 0x802bd61d, 0x4f3e02c7, 0x6bc29608, 0x51dbde71, 0xc4c96df9, 0xa67c43ca, 0x4cd96500],
    merkle_root: [0x307b5f0e, 0xe5c5ad2b, 0xebd261c4, 0x4bf5b911, 0x5debb38c, 0x66bdb1e8, 0x5a9734e9, 0xe8d8547b],
    reversed_timestamp: 0x204b6859,
    nbits: 0xffff7f1f,
    nonce: 0x00000034
};
const BLOCKHEADER_13: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6e9f4e96, 0x60c15027, 0x52d4ab8e, 0x71e75788, 0x31235b00, 0x9c37c182, 0x45850642, 0xdcb64b00],
    merkle_root: [0xa772defd, 0x47a8fdad, 0xd60bef36, 0xa45f7a88, 0x238336b2, 0x5edd6a9d, 0x7aee1c06, 0x386cbf98],
    reversed_timestamp: 0x784d6859,
    nbits: 0xffff7f1f,
    nonce: 0x000000ce
};
const BLOCKHEADER_14: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x95ae1237, 0x8673c045, 0x8964d957, 0x092e3aa5, 0x8ad42f92, 0xac6a2cdd, 0x407f66e7, 0x3f5a5600],
    merkle_root: [0x63af6efb, 0xca2bd72a, 0x34e52595, 0xa0668cff, 0x6781ef27, 0xf730d35d, 0x1fd8f0c6, 0x30caaa1b],
    reversed_timestamp: 0xd04f6859,
    nbits: 0xffff7f1f,
    nonce: 0x0000012b
};
const BLOCKHEADER_15: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x004389dd, 0xd86b2dbd, 0x62669484, 0xf213001a, 0xa76bea98, 0x7d01f5f9, 0xff86b492, 0x6a771d00],
    merkle_root: [0x69e25d05, 0xb25d94d8, 0x03bcbcd0, 0x502c2e8e, 0xf937d48e, 0x2c760112, 0x33ea2d70, 0x374314c8],
    reversed_timestamp: 0x28526859,
    nbits: 0xffff7f1f,
    nonce: 0x000001a6
};
const BLOCKHEADER_16: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3c3a5748, 0x1aa81e78, 0xd7ef6939, 0xc70b8d31, 0xf2af3be2, 0xff7da839, 0x980fbbe3, 0xae891600],
    merkle_root: [0x4c305a3a, 0xe5f33eae, 0x4c19b2bc, 0x5bc70807, 0xbcebed26, 0x6d640a2e, 0x792ce87d, 0xe2b7d4eb],
    reversed_timestamp: 0x80546859,
    nbits: 0xffff7f1f,
    nonce: 0x00000273
};
const BLOCKHEADER_17: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xfd7d5d61, 0x4901d461, 0x7b5f2ea0, 0x619fc836, 0xba827b12, 0xfda3712c, 0x5fc06a22, 0xeb811200],
    merkle_root: [0xce37ea1f, 0x4fd6ace6, 0xfe35358f, 0xac09f62f, 0x16aa109d, 0xb73a589a, 0x8276a22b, 0xbb7bbbbd],
    reversed_timestamp: 0xd8566859,
    nbits: 0xffff7f1f,
    nonce: 0x0000026f
};
const BLOCKHEADER_18: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2a8717cb, 0xb3610167, 0x6ea5e817, 0x50adad40, 0xd56336a8, 0xbd2ddf7a, 0x52d35c5a, 0xb1b92700],
    merkle_root: [0x559e89b2, 0x2c605761, 0xa22ed601, 0xfef0c4cb, 0xdde54246, 0x5444e98e, 0xd8f65a5d, 0xc0bec916],
    reversed_timestamp: 0x30596859,
    nbits: 0xffff7f1f,
    nonce: 0x0000032f
};
const BLOCKHEADER_19: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5268581e, 0xb60a30d1, 0x2fa1effc, 0x2f23d772, 0xcc1a3721, 0xd5ec06e3, 0xad1ea394, 0x8ccc3700],
    merkle_root: [0xe105f352, 0x858c275d, 0xc62ca854, 0x0b2b9a83, 0xbd392ad6, 0x81fb04c1, 0xc38c80ab, 0xbee4a285],
    reversed_timestamp: 0x885b6859,
    nbits: 0xffff7f1f,
    nonce: 0x0000056a
};
const BLOCKHEADER_20: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x33eb997d, 0x021e9aa9, 0x5b9afaec, 0xaf46bda1, 0x33762b0c, 0x8871f236, 0x3bd37cb6, 0x79475300],
    merkle_root: [0x87192fc2, 0xbc3d4809, 0xc0f5a94d, 0xe4824f07, 0xc4711d67, 0x3bd7274c, 0x4513411b, 0x8467ad89],
    reversed_timestamp: 0xe05d6859,
    nbits: 0xffff7f1f,
    nonce: 0x0000009c
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
        block_hash: [0xbcc3d141, 0x8c33bea8, 0x0294bd6b, 0x1554e602, 0x746126fe, 0xbff3bb64, 0x49f1e066, 0x91e80900],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000200,
        block_height: 0,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1,
        block_hash: [0x29506475, 0xb16d8cfd, 0xabefd379, 0x17aa2a54, 0x34c85cdf, 0xdc2c8a92, 0x2e1ea6f2, 0x34fe4100],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000400,
        block_height: 1,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2,
        block_hash: [0x8d39c521, 0x49338125, 0x814c98be, 0x5a7c5b3e, 0x7418eb50, 0x73d129e2, 0x0b442c4a, 0xa1da4300],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000600,
        block_height: 2,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_3,
        block_hash: [0xe227d753, 0x9d6b363f, 0x4b5ca68c, 0xa67c1c34, 0xfc9750bb, 0x542a52dc, 0xdfbba94f, 0x7b8e7c00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000800,
        block_height: 3,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200]
    },
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
        block_hash: [0x72062c33, 0x71ed9297, 0x83db4eb0, 0x4ba035a4, 0x3921f70d, 0xae8abe66, 0xf9a12dba, 0x4ed27e00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000c00,
        block_height: 5,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_6,
        block_hash: [0x52c2fa09, 0xb6c035f7, 0x1ea76cf7, 0xdb406c60, 0x56a29c98, 0x9646c381, 0x4d8c39d6, 0x653b2300],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000e00,
        block_height: 6,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_7,
        block_hash: [0x95d50da1, 0x39eccace, 0x5236f3ff, 0xc5e04233, 0x12984b5e, 0xd6c76b18, 0xab839e4f, 0x409c2300],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001000,
        block_height: 7,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_8,
        block_hash: [0xdff11219, 0xfed81ab4, 0x59f8cba4, 0x319b9a40, 0x18da6c63, 0x7678a85f, 0x359f7137, 0x78355c00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001200,
        block_height: 8,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_9,
        block_hash: [0x5cfec843, 0x1a1507d1, 0x2e7c38fc, 0x11c8860c, 0x10337f84, 0xe3ecb841, 0x04d893cb, 0xb0f84700],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001400,
        block_height: 9,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_10,
        block_hash: [0xfbdfa38c, 0x32b7fd5d, 0xea1a3c7a, 0x7a78ad81, 0xec55be98, 0x0e541ce2, 0xec9e2c63, 0xfc900c00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001600,
        block_height: 10,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000000, 1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_11,
        block_hash: [0x80938edf, 0x802bd61d, 0x4f3e02c7, 0x6bc29608, 0x51dbde71, 0xc4c96df9, 0xa67c43ca, 0x4cd96500],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001800,
        block_height: 11,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500000600, 1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_12,
        block_hash: [0x6e9f4e96, 0x60c15027, 0x52d4ab8e, 0x71e75788, 0x31235b00, 0x9c37c182, 0x45850642, 0xdcb64b00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001a00,
        block_height: 12,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500001200, 1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_13,
        block_hash: [0x95ae1237, 0x8673c045, 0x8964d957, 0x092e3aa5, 0x8ad42f92, 0xac6a2cdd, 0x407f66e7, 0x3f5a5600],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001c00,
        block_height: 13,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500001800, 1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_14,
        block_hash: [0x004389dd, 0xd86b2dbd, 0x62669484, 0xf213001a, 0xa76bea98, 0x7d01f5f9, 0xff86b492, 0x6a771d00],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000001e00,
        block_height: 14,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500002400, 1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_15,
        block_hash: [0x3c3a5748, 0x1aa81e78, 0xd7ef6939, 0xc70b8d31, 0xf2af3be2, 0xff7da839, 0x980fbbe3, 0xae891600],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002000,
        block_height: 15,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500003000, 1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_16,
        block_hash: [0xfd7d5d61, 0x4901d461, 0x7b5f2ea0, 0x619fc836, 0xba827b12, 0xfda3712c, 0x5fc06a22, 0xeb811200],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002200,
        block_height: 16,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500003600, 1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_17,
        block_hash: [0x2a8717cb, 0xb3610167, 0x6ea5e817, 0x50adad40, 0xd56336a8, 0xbd2ddf7a, 0x52d35c5a, 0xb1b92700],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002400,
        block_height: 17,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500004200, 1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_18,
        block_hash: [0x5268581e, 0xb60a30d1, 0x2fa1effc, 0x2f23d772, 0xcc1a3721, 0xd5ec06e3, 0xad1ea394, 0x8ccc3700],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002600,
        block_height: 18,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500004800, 1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600, 1500010200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_19,
        block_hash: [0x33eb997d, 0x021e9aa9, 0x5b9afaec, 0xaf46bda1, 0x33762b0c, 0x8871f236, 0x3bd37cb6, 0x79475300],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002800,
        block_height: 19,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500005400, 1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600, 1500010200, 1500010800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_20,
        block_hash: [0x4e98ea8b, 0x4a231cc0, 0x3d6dcf35, 0x680f4e72, 0x42815a5e, 0xb4d1040b, 0xab56faf4, 0x43a85300],
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000002a00,
        block_height: 20,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1500006000, 1500006600, 1500007200, 1500007800, 1500008400, 1500009000, 1500009600, 1500010200, 1500010800, 1500011400]
    },
];
