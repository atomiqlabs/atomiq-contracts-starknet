use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

pub const TIMESTAMP: u64 = 1700000000;

const BLOCKHEADER_2000: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x303a000d, 0x23cd5c80, 0x56df0f44, 0xde8fc17b, 0xa3021d1d, 0x479557c3, 0xd65c7731, 0xdaaf6b00],
    merkle_root: [0xa8219802, 0xe462d86f, 0xe2f6c683, 0x25c214ac, 0x637c2336, 0x2eb046f3, 0x8ad199de, 0xde1bbe8c],
    reversed_timestamp: 0x807e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000003a9
};
const BLOCKHEADER_2001: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf27f92a3, 0xed967c40, 0x52f33e6d, 0xdf7c5a45, 0x829c19a9, 0x812a101a, 0xe70cada0, 0x5d2e5900],
    merkle_root: [0x46248d61, 0xa35f880e, 0xc4bebfb4, 0x68722088, 0xe580a68c, 0xdf5128f1, 0x4eb34dcf, 0x9267b727],
    reversed_timestamp: 0xd8807a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000000f
};
const BLOCKHEADER_2002: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa1774f70, 0x3eb1975c, 0x859c53d1, 0x8f0213fd, 0x25877120, 0x539e43e0, 0xe0f7b4d0, 0x04ba4e00],
    merkle_root: [0xc46065ad, 0xc4827f12, 0x98fb0d74, 0x5cd557f5, 0xb541b146, 0x8a3757f6, 0x90db00fd, 0x3e07a374],
    reversed_timestamp: 0x30837a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000d8
};
const BLOCKHEADER_2003: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xce554a60, 0x4149ebf8, 0x6e958fbf, 0x37bc12a0, 0x0672daf3, 0xec51b7e7, 0x24df1bc7, 0xd0234600],
    merkle_root: [0x72dda709, 0x45d6a71e, 0x0d6a99d8, 0x4eb9acd5, 0x55971407, 0xb86c0d95, 0x0abf8e11, 0x0171fcdc],
    reversed_timestamp: 0x88857a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000ec
};
const BLOCKHEADER_2004: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa46acd39, 0x40b70553, 0xf941b93f, 0x50123cc9, 0x959de5fb, 0xf05d6f7c, 0x375b6f09, 0x10220200],
    merkle_root: [0xed05f3a8, 0x2f6e8ff9, 0xceeb65f7, 0xb0c14577, 0xc7c7f856, 0xced2f55a, 0xd9793d41, 0x9b84ce37],
    reversed_timestamp: 0xe0877a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000769
};
const BLOCKHEADER_2005: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5fc02f9a, 0xefb28637, 0xf28f3192, 0x510f6ff9, 0x03106b3f, 0x74e9c5d0, 0xdadfbe92, 0xcf673800],
    merkle_root: [0xee35ab4e, 0xd526c736, 0xca58cba4, 0x16b4cc58, 0xaf900e76, 0x54db5aa0, 0x8bb5890e, 0x62d3cb26],
    reversed_timestamp: 0x388a7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000309
};
const BLOCKHEADER_2006: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xcffd211d, 0xac823eb8, 0x66ead637, 0x7e917c79, 0xd6a5d8f4, 0x1bc72e06, 0x5944674d, 0xe9766900],
    merkle_root: [0x337d4b3e, 0x0f7ef63b, 0x7320ebb5, 0x32463547, 0x990b8afd, 0x549a719b, 0xcf8f07bc, 0x7681a28a],
    reversed_timestamp: 0x908c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000020d
};
const BLOCKHEADER_2007: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa8e156a2, 0x06deea89, 0x4a7cd798, 0x70877de8, 0x415f63f8, 0xa0a8f9d1, 0x546e28da, 0x0f2d6b00],
    merkle_root: [0x41b89758, 0x5210b68a, 0xff97b8e7, 0x6e7cc0c2, 0xd030ae4c, 0xb0e789a0, 0x9a319281, 0x75e0f92d],
    reversed_timestamp: 0xe88e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000049
};
const BLOCKHEADER_2008: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x68adef27, 0x6474954d, 0xd621ccb2, 0xec855883, 0x1e0c3ec5, 0x27ad0979, 0xe8b6a42f, 0x8f0b4100],
    merkle_root: [0xfbf73421, 0xfa71fc4b, 0x10d90df6, 0x0f735d5a, 0x754b2499, 0x25c52e23, 0x20b35978, 0x255250c8],
    reversed_timestamp: 0x40917a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000e8
};
const BLOCKHEADER_2009: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9304349b, 0xa11235a0, 0x4dda9fdc, 0x24ec43d9, 0x09394dfe, 0x22807c25, 0xe34b44ce, 0x781e3200],
    merkle_root: [0xf8b373ac, 0xe60830be, 0xf6b86b05, 0x0bba2231, 0xab3e7818, 0xc58e03ba, 0xc4b91a09, 0xa6e1f230],
    reversed_timestamp: 0x98937a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000297
};
const BLOCKHEADER_2010: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf1b70738, 0xc5b4c801, 0xe9ad0270, 0x703ff5c4, 0x3f3ff80e, 0x86a5c2b3, 0x32e02ee9, 0x51165600],
    merkle_root: [0xa68d1c3e, 0x6f082615, 0xf65fd50e, 0x0d58f529, 0xcafa099b, 0xe6817372, 0xf8683d4b, 0xd109b995],
    reversed_timestamp: 0xf0957a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000037
};
const BLOCKHEADER_2011: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf2d6306f, 0x01d9e652, 0x73b3881a, 0x6a85a8d2, 0x86133df7, 0x04670b09, 0x64759390, 0xf1141d00],
    merkle_root: [0x67ea1649, 0x66120110, 0x15ea2aa7, 0x7ea9530e, 0xa175399e, 0x7197c042, 0xaca84846, 0x3e36fa88],
    reversed_timestamp: 0x48987a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000000f
};
const BLOCKHEADER_2012: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xbdcc4bbb, 0x898c547f, 0x9e9b7f06, 0x792ec05e, 0xbb87937d, 0xd33fc659, 0x54a75662, 0x6e177c00],
    merkle_root: [0xa76f58a5, 0x884cfbd4, 0x3777f1a6, 0x1afe8f94, 0x62b58c1c, 0x1ca53122, 0xf9eca113, 0x69e845da],
    reversed_timestamp: 0xa09a7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000031f
};
const BLOCKHEADER_2013: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9f6aab93, 0x7af367fc, 0xc85ee8f4, 0x6b59b9c1, 0x4f3c53f0, 0x3fbb2996, 0x7155231b, 0x24ac1400],
    merkle_root: [0xac87c5a9, 0x52cf5b91, 0xaf14877b, 0x0899404c, 0x61fd4c60, 0xb5f0f1e0, 0xb3ad1d25, 0x23302201],
    reversed_timestamp: 0xf89c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000002fb
};
const BLOCKHEADER_2014: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5bff1ad6, 0x370a11b3, 0x16029d3d, 0x56b8572a, 0x7eb0cb65, 0x810869a4, 0x4cc807f5, 0xbdb71c00],
    merkle_root: [0x1a979300, 0xee8f4c92, 0xce22fa79, 0x2af39d2c, 0x1258f7d9, 0x469c2acb, 0xe263dd56, 0x28b62574],
    reversed_timestamp: 0x509f7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000024d
};
const BLOCKHEADER_2015: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7942c45b, 0xb728acc3, 0x43a2d7a9, 0xf5a4ff81, 0x43594851, 0x1ae3884b, 0x61480e88, 0x36061a00],
    merkle_root: [0x5628c463, 0x4486e4e8, 0x17cf7bd0, 0xe19043d7, 0xa199139c, 0xad437207, 0x6b5ec2de, 0x98392eef],
    reversed_timestamp: 0xa8a17a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001bd
};
const BLOCKHEADER_2016: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2dad9408, 0xcae5dac5, 0x98a36a2c, 0x23abab74, 0x45e79b64, 0xa171e4f6, 0x97990696, 0x18436c00],
    merkle_root: [0x779a0eaf, 0x263ecb2f, 0x98f497ce, 0x0d19723a, 0xebe4f249, 0x67bf5204, 0x10c56349, 0x176aa950],
    reversed_timestamp: 0x00a47a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000193
};
const BLOCKHEADER_2017: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4529f982, 0xf42df71c, 0xcb78b02b, 0x88fb25a6, 0xee4fef1b, 0x261a62b6, 0xeb7f91bf, 0xc9225200],
    merkle_root: [0xb57f2cf5, 0xc9baddb2, 0xffd38564, 0x21d405b9, 0xe3b9e8ed, 0x43a7ce02, 0xf11fef68, 0xacf8e53f],
    reversed_timestamp: 0x58a67a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000001dc
};
const BLOCKHEADER_2018: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xcf7ea81c, 0xd1622ba3, 0x6e0a9ee3, 0x50e68063, 0xde274c2a, 0x929fe824, 0x727dfddb, 0x04674300],
    merkle_root: [0x1e8a1b23, 0x72550f6c, 0x686e09de, 0x3d254c22, 0x29fc0760, 0x4e27e6a9, 0xa70c7356, 0xb959757f],
    reversed_timestamp: 0xb0a87a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000005c9
};
const BLOCKHEADER_2019: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3bda3a95, 0xcc1b0fd0, 0x77e1782d, 0x97970bd8, 0x5fb5dafd, 0x75244526, 0x34110bd1, 0x341e0d00],
    merkle_root: [0x94439aaa, 0xe71535c7, 0x48fc5f48, 0x063321fd, 0xe346e76b, 0xafa093fc, 0xf0582609, 0x8b05aa16],
    reversed_timestamp: 0x08ab7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x0000024b
};
const BLOCKHEADER_2020: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1c632458, 0x2c64d7c8, 0x0d888f9e, 0x465d58b2, 0x6f016002, 0x50c1214d, 0xadd9a6c9, 0x28451c00],
    merkle_root: [0xa9e3ada7, 0x3c31ef42, 0x043b697c, 0x43070296, 0x07981058, 0xb0624c25, 0xbd881c6c, 0x66bcc48d],
    reversed_timestamp: 0x60ad7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000002c0
};
const BLOCKHEADER_2021: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x037253b6, 0xf755fc9a, 0xe5fe41b0, 0xc6b9093b, 0x26c3eb78, 0xc3487123, 0x9c59dd83, 0xf9263500],
    merkle_root: [0x91f592dd, 0xdb45055e, 0x5f6e1627, 0x4a423cc6, 0x3ce34f5b, 0xbf1d616d, 0xe7215b59, 0x3dc497ef],
    reversed_timestamp: 0xb8af7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000001a2
};
const BLOCKHEADER_2022: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3cc3cf05, 0x188d02ef, 0x8cfcbb5b, 0x0419f41e, 0xf10ffb51, 0x6ccc8857, 0x02831ffb, 0x07675600],
    merkle_root: [0x71067565, 0xcdecb465, 0x59cb3863, 0x22a3b7d2, 0x50cc12bd, 0xd2357df3, 0x46d9ff21, 0xdda68eb8],
    reversed_timestamp: 0x10b27a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000002d4
};
const BLOCKHEADER_2023: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x61743969, 0xc9b0199d, 0xcc7d6eb6, 0x2e41fb35, 0x6cda380f, 0xf195a465, 0x203c3816, 0xd6d21500],
    merkle_root: [0xd3b722d0, 0xcdffa440, 0x4ea87aff, 0xff61a33e, 0x30985b0e, 0xf7562253, 0xb5104b00, 0x7891b669],
    reversed_timestamp: 0x68b47a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000004a8
};
const BLOCKHEADER_2024: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf43fa0a3, 0x3edccca5, 0xbe3d4a44, 0x9be7f41d, 0x62312910, 0x98ade969, 0x746ed9b5, 0x56793200],
    merkle_root: [0x1ed86263, 0x840cd401, 0xed6ff89d, 0x2d86b374, 0xa56905c8, 0x2303775d, 0xffaad120, 0x14bdbf7f],
    reversed_timestamp: 0xc0b67a59,
    nbits: 0xbdef7f1f,
    nonce: 0x0000039e
};
const BLOCKHEADER_2025: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x52bf77ed, 0xa44e3e6a, 0xc5181aa3, 0x17636298, 0x868b3fb2, 0xf8c32db4, 0x95c973f4, 0xc8185200],
    merkle_root: [0xd27343f7, 0xc8e5593d, 0x6e096474, 0xdd161e51, 0xe9e5cc03, 0x1050834b, 0x40c1e398, 0x923b25bd],
    reversed_timestamp: 0x18b97a59,
    nbits: 0xbdef7f1f,
    nonce: 0x0000016f
};
const BLOCKHEADER_2026: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8361dd4d, 0xafc2c32a, 0x32c1a397, 0x5297677c, 0x5fceef0f, 0x658c3f83, 0x315dc5d4, 0x68975700],
    merkle_root: [0x0be0610f, 0x52e20768, 0x302a80af, 0xe93f3749, 0x42de5c0c, 0x145341fb, 0x35a5fb8f, 0x3b207357],
    reversed_timestamp: 0x70bb7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x0000010c
};
const BLOCKHEADER_2027: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xae62191c, 0x7e74e833, 0xb7e3a610, 0x0770b1d0, 0x86d420f2, 0x922fb7be, 0xf3fcb1ce, 0x11771e00],
    merkle_root: [0x3e8800cf, 0x37dfc542, 0x3eb7af8d, 0x06883dd1, 0x741725e0, 0x3b6d35eb, 0xc2016faa, 0x3b9d9c1a],
    reversed_timestamp: 0xc8bd7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x0000019a
};
const BLOCKHEADER_2028: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6121a47e, 0x31d45f3c, 0x5c488263, 0x38cfd289, 0x3d09f3d0, 0xa479a75e, 0xd5caed85, 0xe8842e00],
    merkle_root: [0x3a948ea9, 0x5b32b73c, 0x07887616, 0x2d19cda5, 0xa744c9f7, 0x360c98e3, 0x0abb4a72, 0x70f732ce],
    reversed_timestamp: 0x20c07a59,
    nbits: 0xbdef7f1f,
    nonce: 0x0000035e
};
const BLOCKHEADER_2029: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9677e7b2, 0x912d2462, 0x646da2a3, 0xf36741a4, 0x49c1d705, 0x3aedfb94, 0x862d6dbb, 0xf9761b00],
    merkle_root: [0xac44aae0, 0xfa2944f5, 0x42e47b85, 0x6ae05c0a, 0x3cfeb784, 0x270d29e7, 0x16d72012, 0xcd142458],
    reversed_timestamp: 0x78c27a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000052
};
const BLOCKHEADER_2030: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xec18c617, 0xf1b47118, 0x6c04e29a, 0xa139eb71, 0xed1e69ff, 0x65c9f691, 0xbddd40d1, 0x34d90900],
    merkle_root: [0xb7cb0b18, 0x4c0892d7, 0xd469babd, 0x63a89276, 0xa1411019, 0x84ccbda4, 0xde77414c, 0x2cfaee23],
    reversed_timestamp: 0xd0c47a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000002c3
};

pub const BLOCKHEADERS: [BlockHeader; 30] = [
    BLOCKHEADER_2001,
    BLOCKHEADER_2002,
    BLOCKHEADER_2003,
    BLOCKHEADER_2004,
    BLOCKHEADER_2005,
    BLOCKHEADER_2006,
    BLOCKHEADER_2007,
    BLOCKHEADER_2008,
    BLOCKHEADER_2009,
    BLOCKHEADER_2010,
    BLOCKHEADER_2011,
    BLOCKHEADER_2012,
    BLOCKHEADER_2013,
    BLOCKHEADER_2014,
    BLOCKHEADER_2015,
    BLOCKHEADER_2016,
    BLOCKHEADER_2017,
    BLOCKHEADER_2018,
    BLOCKHEADER_2019,
    BLOCKHEADER_2020,
    BLOCKHEADER_2021,
    BLOCKHEADER_2022,
    BLOCKHEADER_2023,
    BLOCKHEADER_2024,
    BLOCKHEADER_2025,
    BLOCKHEADER_2026,
    BLOCKHEADER_2027,
    BLOCKHEADER_2028,
    BLOCKHEADER_2029,
    BLOCKHEADER_2030,
];

pub const STORED_BLOCKHEADERS: [StoredBlockHeader; 31] = [
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2000,
        block_hash: [0xf27f92a3, 0xed967c40, 0x52f33e6d, 0xdf7c5a45, 0x829c19a9, 0x812a101a, 0xe70cada0, 0x5d2e5900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa200,
        block_height: 2000,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501194000, 1501194600, 1501195200, 1501195800, 1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2001,
        block_hash: [0xa1774f70, 0x3eb1975c, 0x859c53d1, 0x8f0213fd, 0x25877120, 0x539e43e0, 0xe0f7b4d0, 0x04ba4e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa400,
        block_height: 2001,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501194600, 1501195200, 1501195800, 1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2002,
        block_hash: [0xce554a60, 0x4149ebf8, 0x6e958fbf, 0x37bc12a0, 0x0672daf3, 0xec51b7e7, 0x24df1bc7, 0xd0234600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa600,
        block_height: 2002,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501195200, 1501195800, 1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2003,
        block_hash: [0xa46acd39, 0x40b70553, 0xf941b93f, 0x50123cc9, 0x959de5fb, 0xf05d6f7c, 0x375b6f09, 0x10220200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa800,
        block_height: 2003,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501195800, 1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2004,
        block_hash: [0x5fc02f9a, 0xefb28637, 0xf28f3192, 0x510f6ff9, 0x03106b3f, 0x74e9c5d0, 0xdadfbe92, 0xcf673800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000faa00,
        block_height: 2004,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2005,
        block_hash: [0xcffd211d, 0xac823eb8, 0x66ead637, 0x7e917c79, 0xd6a5d8f4, 0x1bc72e06, 0x5944674d, 0xe9766900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fac00,
        block_height: 2005,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2006,
        block_hash: [0xa8e156a2, 0x06deea89, 0x4a7cd798, 0x70877de8, 0x415f63f8, 0xa0a8f9d1, 0x546e28da, 0x0f2d6b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fae00,
        block_height: 2006,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2007,
        block_hash: [0x68adef27, 0x6474954d, 0xd621ccb2, 0xec855883, 0x1e0c3ec5, 0x27ad0979, 0xe8b6a42f, 0x8f0b4100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb000,
        block_height: 2007,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2008,
        block_hash: [0x9304349b, 0xa11235a0, 0x4dda9fdc, 0x24ec43d9, 0x09394dfe, 0x22807c25, 0xe34b44ce, 0x781e3200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb200,
        block_height: 2008,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2009,
        block_hash: [0xf1b70738, 0xc5b4c801, 0xe9ad0270, 0x703ff5c4, 0x3f3ff80e, 0x86a5c2b3, 0x32e02ee9, 0x51165600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb400,
        block_height: 2009,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2010,
        block_hash: [0xf2d6306f, 0x01d9e652, 0x73b3881a, 0x6a85a8d2, 0x86133df7, 0x04670b09, 0x64759390, 0xf1141d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb600,
        block_height: 2010,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2011,
        block_hash: [0xbdcc4bbb, 0x898c547f, 0x9e9b7f06, 0x792ec05e, 0xbb87937d, 0xd33fc659, 0x54a75662, 0x6e177c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb800,
        block_height: 2011,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2012,
        block_hash: [0x9f6aab93, 0x7af367fc, 0xc85ee8f4, 0x6b59b9c1, 0x4f3c53f0, 0x3fbb2996, 0x7155231b, 0x24ac1400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fba00,
        block_height: 2012,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2013,
        block_hash: [0x5bff1ad6, 0x370a11b3, 0x16029d3d, 0x56b8572a, 0x7eb0cb65, 0x810869a4, 0x4cc807f5, 0xbdb71c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fbc00,
        block_height: 2013,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2014,
        block_hash: [0x7942c45b, 0xb728acc3, 0x43a2d7a9, 0xf5a4ff81, 0x43594851, 0x1ae3884b, 0x61480e88, 0x36061a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fbe00,
        block_height: 2014,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2015,
        block_hash: [0x2dad9408, 0xcae5dac5, 0x98a36a2c, 0x23abab74, 0x45e79b64, 0xa171e4f6, 0x97990696, 0x18436c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc000,
        block_height: 2015,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2016,
        block_hash: [0x4529f982, 0xf42df71c, 0xcb78b02b, 0x88fb25a6, 0xee4fef1b, 0x261a62b6, 0xeb7f91bf, 0xc9225200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc200,
        block_height: 2016,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2017,
        block_hash: [0xcf7ea81c, 0xd1622ba3, 0x6e0a9ee3, 0x50e68063, 0xde274c2a, 0x929fe824, 0x727dfddb, 0x04674300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc400,
        block_height: 2017,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2018,
        block_hash: [0x3bda3a95, 0xcc1b0fd0, 0x77e1782d, 0x97970bd8, 0x5fb5dafd, 0x75244526, 0x34110bd1, 0x341e0d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc600,
        block_height: 2018,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2019,
        block_hash: [0x1c632458, 0x2c64d7c8, 0x0d888f9e, 0x465d58b2, 0x6f016002, 0x50c1214d, 0xadd9a6c9, 0x28451c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc800,
        block_height: 2019,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2020,
        block_hash: [0x037253b6, 0xf755fc9a, 0xe5fe41b0, 0xc6b9093b, 0x26c3eb78, 0xc3487123, 0x9c59dd83, 0xf9263500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fca00,
        block_height: 2020,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800, 1501211400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2021,
        block_hash: [0x3cc3cf05, 0x188d02ef, 0x8cfcbb5b, 0x0419f41e, 0xf10ffb51, 0x6ccc8857, 0x02831ffb, 0x07675600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fcc00,
        block_height: 2021,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800, 1501211400, 1501212000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2022,
        block_hash: [0x61743969, 0xc9b0199d, 0xcc7d6eb6, 0x2e41fb35, 0x6cda380f, 0xf195a465, 0x203c3816, 0xd6d21500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fce00,
        block_height: 2022,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800, 1501211400, 1501212000, 1501212600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2023,
        block_hash: [0xf43fa0a3, 0x3edccca5, 0xbe3d4a44, 0x9be7f41d, 0x62312910, 0x98ade969, 0x746ed9b5, 0x56793200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd000,
        block_height: 2023,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800, 1501211400, 1501212000, 1501212600, 1501213200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2024,
        block_hash: [0x52bf77ed, 0xa44e3e6a, 0xc5181aa3, 0x17636298, 0x868b3fb2, 0xf8c32db4, 0x95c973f4, 0xc8185200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd200,
        block_height: 2024,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501208400, 1501209000, 1501209600, 1501210200, 1501210800, 1501211400, 1501212000, 1501212600, 1501213200, 1501213800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2025,
        block_hash: [0x8361dd4d, 0xafc2c32a, 0x32c1a397, 0x5297677c, 0x5fceef0f, 0x658c3f83, 0x315dc5d4, 0x68975700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd400,
        block_height: 2025,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501209000, 1501209600, 1501210200, 1501210800, 1501211400, 1501212000, 1501212600, 1501213200, 1501213800, 1501214400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2026,
        block_hash: [0xae62191c, 0x7e74e833, 0xb7e3a610, 0x0770b1d0, 0x86d420f2, 0x922fb7be, 0xf3fcb1ce, 0x11771e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd600,
        block_height: 2026,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501209600, 1501210200, 1501210800, 1501211400, 1501212000, 1501212600, 1501213200, 1501213800, 1501214400, 1501215000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2027,
        block_hash: [0x6121a47e, 0x31d45f3c, 0x5c488263, 0x38cfd289, 0x3d09f3d0, 0xa479a75e, 0xd5caed85, 0xe8842e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd800,
        block_height: 2027,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501210200, 1501210800, 1501211400, 1501212000, 1501212600, 1501213200, 1501213800, 1501214400, 1501215000, 1501215600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2028,
        block_hash: [0x9677e7b2, 0x912d2462, 0x646da2a3, 0xf36741a4, 0x49c1d705, 0x3aedfb94, 0x862d6dbb, 0xf9761b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fda00,
        block_height: 2028,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501210800, 1501211400, 1501212000, 1501212600, 1501213200, 1501213800, 1501214400, 1501215000, 1501215600, 1501216200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2029,
        block_hash: [0xec18c617, 0xf1b47118, 0x6c04e29a, 0xa139eb71, 0xed1e69ff, 0x65c9f691, 0xbddd40d1, 0x34d90900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fdc00,
        block_height: 2029,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501211400, 1501212000, 1501212600, 1501213200, 1501213800, 1501214400, 1501215000, 1501215600, 1501216200, 1501216800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2030,
        block_hash: [0xec127770, 0x46b2c435, 0x27cf38de, 0xb2018555, 0xfe2d7e24, 0x3f7c55c5, 0xb06e2bf7, 0x4eaf7500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fde00,
        block_height: 2030,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501212000, 1501212600, 1501213200, 1501213800, 1501214400, 1501215000, 1501215600, 1501216200, 1501216800, 1501217400]
    },
];
