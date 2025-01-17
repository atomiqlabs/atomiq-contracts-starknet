use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

pub const TIMESTAMP: u64 = 1700000000;

const BLOCKHEADER_1900: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe73b6dd7, 0xa518a9e7, 0x2e897292, 0x9b83253b, 0x8bd11c67, 0x2817917b, 0xe07be1ff, 0x3b670300],
    merkle_root: [0xc0276045, 0xc95cfda9, 0xca7d5450, 0xba7cc8a5, 0x21707928, 0x3fcd9465, 0x1a9906c8, 0x1c9724b6],
    reversed_timestamp: 0x20947959,
    nbits: 0xffff7f1f,
    nonce: 0x000000f8
};
const BLOCKHEADER_1901: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x743ce276, 0x7297cff4, 0xf9d5f871, 0x1e294745, 0xb9fa84e9, 0xac5bc59f, 0x190d4dcf, 0x82f97600],
    merkle_root: [0xae2163b7, 0x6a75f0c5, 0x52e33697, 0x2de6b268, 0x6070cf81, 0x95928dd2, 0x21f3d89a, 0xdf32dd4f],
    reversed_timestamp: 0x78967959,
    nbits: 0xffff7f1f,
    nonce: 0x000000ad
};
const BLOCKHEADER_1902: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x22291c36, 0x6cc3c99d, 0xbce05a37, 0x303104cb, 0xed3e9412, 0xd386336b, 0x6bf30486, 0xfd6f2000],
    merkle_root: [0xe62c95a0, 0xfc5aed6e, 0x7bdd2fee, 0x7292cce8, 0xb8882736, 0x7cad924f, 0xeeed184d, 0xc8c026c4],
    reversed_timestamp: 0xd0987959,
    nbits: 0xffff7f1f,
    nonce: 0x0000015b
};
const BLOCKHEADER_1903: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x81cbcc76, 0xed402bc0, 0x292e8c1f, 0x68cf81f1, 0x7e217e54, 0x9c4a6178, 0xe3ded6e7, 0x2e246d00],
    merkle_root: [0x07cb175c, 0x12b8ac84, 0xbbbb5848, 0x399e20f5, 0x011fca9c, 0x99a29a72, 0x1535ae61, 0xf1774a12],
    reversed_timestamp: 0x289b7959,
    nbits: 0xffff7f1f,
    nonce: 0x000001dc
};
const BLOCKHEADER_1904: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb9adc773, 0xa53ba742, 0x14de6054, 0x03dac4c0, 0xff354c7a, 0xcbf1e56a, 0x0f9fb152, 0xbc783700],
    merkle_root: [0xdd101fd1, 0x6004ffd1, 0x34fa82dc, 0x38f858a2, 0xe521516f, 0xef6ef5f3, 0x1e168af7, 0x180b5c62],
    reversed_timestamp: 0x809d7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000561
};
const BLOCKHEADER_1905: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9195a32b, 0xd788b123, 0x25cba3b7, 0x2d7246bc, 0xe2c91685, 0xb3c4e656, 0x2db9a553, 0xb42c3e00],
    merkle_root: [0x8aa6b539, 0x1511ff1f, 0x16294115, 0x0895568e, 0x0915e041, 0x028af7ee, 0x99a3562d, 0x82b7039d],
    reversed_timestamp: 0xd89f7959,
    nbits: 0xffff7f1f,
    nonce: 0x000006cf
};
const BLOCKHEADER_1906: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1788abc6, 0x92d9b20b, 0x6fce1358, 0x2f489f81, 0xeacd3e97, 0xdc8b3854, 0x6640d6e9, 0xf31b5000],
    merkle_root: [0xb337290b, 0x929cd1b1, 0x26da6272, 0xa97be40b, 0xc20e14ae, 0x6e76146b, 0x8a28d971, 0x173de870],
    reversed_timestamp: 0x30a27959,
    nbits: 0xffff7f1f,
    nonce: 0x0000013e
};
const BLOCKHEADER_1907: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xdbbd31a3, 0xfc65a428, 0xfb14866f, 0xb9461d55, 0xf359c970, 0xeefa5784, 0x7d1ffe1f, 0x45833f00],
    merkle_root: [0x00412ea8, 0xd7bee620, 0x7eba7d62, 0x512f8bc6, 0xce7f0d0e, 0x28540f53, 0xbcfa8cee, 0x9a1be5df],
    reversed_timestamp: 0x88a47959,
    nbits: 0xffff7f1f,
    nonce: 0x0000033c
};
const BLOCKHEADER_1908: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xbe058e0c, 0x83f7d73e, 0xc6fbc750, 0x93d02961, 0x8c493769, 0xef9196ab, 0x66d237f7, 0xe8c64200],
    merkle_root: [0x82cee5e7, 0xb281c4fd, 0x2b05619c, 0x20e97237, 0xffb03740, 0x9c2bb431, 0xc751f9b6, 0xed186f88],
    reversed_timestamp: 0xe0a67959,
    nbits: 0xffff7f1f,
    nonce: 0x0000004c
};
const BLOCKHEADER_1909: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2336b3d3, 0xf1fe9382, 0x6e348b93, 0x16716b77, 0xa5dfdf54, 0x61ad974c, 0xb3955cd2, 0xb3072b00],
    merkle_root: [0x3c824665, 0xcd8168e9, 0x30f34fcd, 0x4f4474f9, 0x261e2abd, 0x789c0567, 0x73d8b75c, 0x922999e2],
    reversed_timestamp: 0x38a97959,
    nbits: 0xffff7f1f,
    nonce: 0x00000037
};
const BLOCKHEADER_1910: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3d91877d, 0x4bc929f4, 0x80a85b66, 0x799369fb, 0x6384caa3, 0xcb5ad4b8, 0x786c1a52, 0x7c212600],
    merkle_root: [0x8e898cea, 0x4039ed7b, 0x80b8abd5, 0xa2163cfa, 0xdd0985bd, 0xc140df70, 0x3362c4e2, 0xe6a1ebb0],
    reversed_timestamp: 0x90ab7959,
    nbits: 0xffff7f1f,
    nonce: 0x000001c5
};
const BLOCKHEADER_1911: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd4961063, 0xca23a378, 0x1279cfd2, 0x970d0c16, 0xaf22fcde, 0x3d286f34, 0xcff741ca, 0x4b237300],
    merkle_root: [0x0fed26c7, 0x876edea6, 0xfc30fb03, 0xb74e8907, 0xcd8d3e06, 0x5b18c47f, 0x2762b32e, 0xd7e4b88f],
    reversed_timestamp: 0xe8ad7959,
    nbits: 0xffff7f1f,
    nonce: 0x0000007b
};
const BLOCKHEADER_1912: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x96900034, 0xe26bca1d, 0xb96ceb56, 0x6349d38f, 0x3adacb3c, 0xc5734fe0, 0xda792035, 0xe8d44600],
    merkle_root: [0x7a58d0a1, 0x32886dc1, 0xf0ba7b40, 0x1d7039f4, 0xd449be66, 0xaa9e2d42, 0x9942fdfd, 0x5afea23b],
    reversed_timestamp: 0x40b07959,
    nbits: 0xffff7f1f,
    nonce: 0x0000018a
};
const BLOCKHEADER_1913: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x35d59181, 0xe09ad19d, 0x74f93850, 0x83d61812, 0x59da315d, 0x586b0652, 0x2ebc3554, 0x608f0500],
    merkle_root: [0xcba5977f, 0xd120e156, 0xc0c840af, 0xdfa4530c, 0x3d65f5d1, 0x022e851f, 0x5c2acd07, 0x6e4c6eb5],
    reversed_timestamp: 0x98b27959,
    nbits: 0xffff7f1f,
    nonce: 0x000003fe
};
const BLOCKHEADER_1914: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x34b933f1, 0x2fce3119, 0x236dac55, 0xd6467ecd, 0xfab3bc45, 0xd5613281, 0x5c8f4870, 0x4d1b4900],
    merkle_root: [0x77af5d33, 0xfe5b6c8c, 0x16f51aa9, 0x49e515e7, 0xe6136b8a, 0xb2438767, 0x3859165d, 0x651791d2],
    reversed_timestamp: 0xf0b47959,
    nbits: 0xffff7f1f,
    nonce: 0x000000c3
};
const BLOCKHEADER_1915: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd5fcc658, 0xbbfd862d, 0xf8400557, 0x50fce39d, 0x07eb6782, 0x3c694d0b, 0x43e6653e, 0x7bfe3c00],
    merkle_root: [0xaaa3b254, 0xbd08d27a, 0xa17142c6, 0x205ee015, 0xb9104783, 0x3390f944, 0xe12c282a, 0xc4f2b855],
    reversed_timestamp: 0x48b77959,
    nbits: 0xffff7f1f,
    nonce: 0x000000a0
};
const BLOCKHEADER_1916: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe7847ff7, 0xa7b6288d, 0x42e1442a, 0x73ea3d65, 0x408a66be, 0x1921346c, 0xb4687be5, 0xfb124900],
    merkle_root: [0xce11e544, 0xee4235c3, 0x72b481c3, 0x017a1d75, 0x1ee9ba7e, 0x0f7b234e, 0xc91d0936, 0x4086c6de],
    reversed_timestamp: 0xa0b97959,
    nbits: 0xffff7f1f,
    nonce: 0x00000248
};
const BLOCKHEADER_1917: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa75ba060, 0x5ba2ec2a, 0x419e44d8, 0x53e85a65, 0xdce4244b, 0x48dc52a7, 0x98a7946b, 0x0d676f00],
    merkle_root: [0x759932f6, 0x3fa4b223, 0x7c4e6799, 0x72a3c83b, 0x44ed6bdf, 0xe6a41437, 0x62803580, 0xf8461c71],
    reversed_timestamp: 0xf8bb7959,
    nbits: 0xffff7f1f,
    nonce: 0x000002d2
};
const BLOCKHEADER_1918: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x023a2e49, 0x1ff6d3da, 0x94c56046, 0x4e621715, 0x7565962e, 0x7fa7ad85, 0x18521273, 0x11b43000],
    merkle_root: [0x47b7c2cb, 0xc5c3db92, 0xc9f6184f, 0xca1887e8, 0x52af7be1, 0x99acd04b, 0x10c62fc4, 0xb63a102e],
    reversed_timestamp: 0x50be7959,
    nbits: 0xffff7f1f,
    nonce: 0x0000014f
};
const BLOCKHEADER_1919: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf9e8ebf7, 0x6cbc670e, 0xe743fb5e, 0xd71fde22, 0xc5679f38, 0x1e98df47, 0x52ee74d9, 0x7e854100],
    merkle_root: [0x0ae2eff6, 0x687ac7ad, 0xd9d8da47, 0xf9c1c77d, 0x9d3212fe, 0x0d95b99f, 0xe3249ac0, 0xeb5ddd29],
    reversed_timestamp: 0xa8c07959,
    nbits: 0xffff7f1f,
    nonce: 0x000004fa
};
const BLOCKHEADER_1920: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x95300d31, 0x667608cb, 0x99411d77, 0xfca8ff91, 0xb3e4ce93, 0x0343dedb, 0x9409f358, 0x68902200],
    merkle_root: [0x0284066d, 0x2a1776e4, 0x6d688784, 0x5116ed93, 0x1e54ed74, 0x38f100e6, 0x62193e91, 0x63f8eb70],
    reversed_timestamp: 0x00c37959,
    nbits: 0xffff7f1f,
    nonce: 0x0000017e
};
const BLOCKHEADER_1921: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x0421a4bf, 0xdfaed5a0, 0xf95d84f4, 0x57d0ccef, 0x7d769f73, 0x8c7381dc, 0x2e03fddd, 0x09747900],
    merkle_root: [0xf5a9260d, 0xbb358822, 0x6224f9bf, 0x9bca12d6, 0x2358f62d, 0xd874969a, 0x33aa076a, 0x856cc484],
    reversed_timestamp: 0x58c57959,
    nbits: 0xffff7f1f,
    nonce: 0x00000104
};
const BLOCKHEADER_1922: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x484d85b7, 0xa7973843, 0x3e580cdc, 0x7e8afaef, 0x9963a98e, 0xe997a338, 0x0971837a, 0x8d9b5b00],
    merkle_root: [0xb3626384, 0x1d7e5d7d, 0xe2fc0d8d, 0xc0a48c70, 0x6d9e58de, 0x173f3c85, 0x9a631f38, 0x7e199c11],
    reversed_timestamp: 0xb0c77959,
    nbits: 0xffff7f1f,
    nonce: 0x00000233
};
const BLOCKHEADER_1923: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x27ccd57d, 0x183a9ddd, 0x1c2932d3, 0x8ef22895, 0x71972a52, 0xe43b8916, 0xa70a69bd, 0xa1386b00],
    merkle_root: [0x7e1697f1, 0xb536a640, 0xbb0bb88b, 0xd839c238, 0x683e0a0e, 0x3d57d8a3, 0x00abdccb, 0xc542b811],
    reversed_timestamp: 0x08ca7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000042
};
const BLOCKHEADER_1924: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x59853be0, 0xcbe5d908, 0xca96078c, 0xa0f3f012, 0x3750bd4f, 0x6980a0bf, 0xa6b02c66, 0xd44b7500],
    merkle_root: [0xd9cd0fef, 0xf87a3417, 0x6174bf3e, 0x19e5a3bb, 0x72569926, 0x8483ca63, 0x1b487e28, 0x1220873a],
    reversed_timestamp: 0x60cc7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000126
};
const BLOCKHEADER_1925: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x35224f6e, 0x63c53232, 0xed3ed7a5, 0x9d0601fb, 0xbe18a843, 0x5a9e437e, 0x79e0abab, 0x20b30a00],
    merkle_root: [0x8d26070d, 0xdb1f09b5, 0x9c8d2fbe, 0x8a87dc6f, 0x8271e633, 0xfb8acb8b, 0xc0b2a834, 0x7e309d71],
    reversed_timestamp: 0xb8ce7959,
    nbits: 0xffff7f1f,
    nonce: 0x0000016a
};
const BLOCKHEADER_1926: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x86185566, 0xea3b1a97, 0xea200160, 0x2fa62cbb, 0x26205b86, 0xe195b9dd, 0x051a69ac, 0x81800700],
    merkle_root: [0xda911543, 0x257a03aa, 0x4c7037d1, 0xdc94f9c0, 0x21cf57cc, 0x0be075e8, 0xdcaee87b, 0x2123c1a0],
    reversed_timestamp: 0x10d17959,
    nbits: 0xffff7f1f,
    nonce: 0x00000926
};
const BLOCKHEADER_1927: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd5272a21, 0x1a46cc35, 0x1ea71c5f, 0x37de58c5, 0x69ef0cb7, 0x7d0da021, 0x04e32e93, 0xc1d37000],
    merkle_root: [0x69ca355b, 0x7032b052, 0x9daf9aff, 0x556c754b, 0xcc13f262, 0x6c94df0f, 0xf6d68a8f, 0x6161c58e],
    reversed_timestamp: 0x68d37959,
    nbits: 0xffff7f1f,
    nonce: 0x00000016
};
const BLOCKHEADER_1928: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x34e37c22, 0x1e6ad706, 0xd61646a7, 0xc56bb91b, 0xe35f4f06, 0x2a7bf52e, 0x35c4cb89, 0x4f972100],
    merkle_root: [0x38779513, 0xb29d0f06, 0xcf32dcbf, 0x21a40f63, 0x6be5be57, 0x3afead6a, 0x9f4a8e9a, 0x653633e3],
    reversed_timestamp: 0xc0d57959,
    nbits: 0xffff7f1f,
    nonce: 0x0000007e
};
const BLOCKHEADER_1929: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4828f699, 0xeea36880, 0x9e18d656, 0xef80b4a4, 0x61c3db2e, 0x264740b2, 0x4be38a94, 0xf6cd1100],
    merkle_root: [0x23669698, 0x334a15b0, 0xa88f55df, 0x11ac8146, 0x8aabc7c4, 0x25e25c7c, 0x2995aa21, 0xfd8f35bf],
    reversed_timestamp: 0x18d87959,
    nbits: 0xffff7f1f,
    nonce: 0x0000027b
};
const BLOCKHEADER_1930: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x248922e3, 0x071e1128, 0x174e00ad, 0xde957ba9, 0xbff9c521, 0x8490fb7f, 0xb7628270, 0x3bfd0c00],
    merkle_root: [0xded29166, 0xfa670df9, 0x6d62aade, 0x61fd5153, 0xbec9b241, 0x7d0b9245, 0x560779f0, 0x88a941b4],
    reversed_timestamp: 0x70da7959,
    nbits: 0xffff7f1f,
    nonce: 0x0000049a
};
const BLOCKHEADER_1931: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x564602b1, 0x880a0fe9, 0x911efc64, 0x64a835fb, 0x38d54263, 0x22020ef9, 0x0f27344b, 0xc10c7c00],
    merkle_root: [0x5fee890e, 0x987c2189, 0x49e438f6, 0x2ced9f01, 0xfb35366d, 0x4414a345, 0xf0a31ddd, 0x697065b6],
    reversed_timestamp: 0xc8dc7959,
    nbits: 0xffff7f1f,
    nonce: 0x000000c0
};
const BLOCKHEADER_1932: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc35b8e19, 0xbd3d1358, 0x4f338502, 0xbf884e78, 0xfe0e5201, 0xad933897, 0xe63772bd, 0x5db71700],
    merkle_root: [0x6c0d9015, 0xe08b53ec, 0x53577787, 0xade50db3, 0x4369b31c, 0x8bd02749, 0xb364a94e, 0x1db6ef6c],
    reversed_timestamp: 0x20df7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000090
};
const BLOCKHEADER_1933: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3bda1ee5, 0x2efe4ce6, 0x6d863a72, 0xe8bbe3b9, 0x339f241f, 0x0727e178, 0xa24f3546, 0xdbb04100],
    merkle_root: [0x836e55ad, 0x03c6303a, 0xda71f263, 0xa6622be4, 0xf559103e, 0xc5491c0f, 0x755e27fc, 0x23d749d3],
    reversed_timestamp: 0x78e17959,
    nbits: 0xffff7f1f,
    nonce: 0x000003a0
};
const BLOCKHEADER_1934: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x08593a66, 0xb32151ae, 0x0cc138b9, 0xe0290646, 0xa7b79a72, 0x54befaef, 0x99276224, 0x54454e00],
    merkle_root: [0x152fc09f, 0x25d7a4fc, 0x9520b72b, 0x7b719162, 0xb333cbd3, 0xe29e8349, 0xeefb31d4, 0xcbf1094a],
    reversed_timestamp: 0xd0e37959,
    nbits: 0xffff7f1f,
    nonce: 0x00000666
};
const BLOCKHEADER_1935: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9ffe9b8e, 0x19fd435a, 0xf297acc2, 0xb20202b8, 0x23275264, 0xe9a9e786, 0xf8c9954a, 0x78eb1300],
    merkle_root: [0x7c2fbbf9, 0xe56671a7, 0x872850f2, 0x0b68051a, 0x378c7106, 0xd509eab1, 0xbf7d413c, 0xd6580bb0],
    reversed_timestamp: 0x28e67959,
    nbits: 0xffff7f1f,
    nonce: 0x0000017c
};
const BLOCKHEADER_1936: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe6ad1313, 0xbc246ef5, 0x0ab648a7, 0x669e9ae3, 0x13cc5c27, 0xb78c747b, 0xc97102ef, 0x10711300],
    merkle_root: [0x9e5e25f6, 0x3910673f, 0x3cd7cefd, 0x03362b3d, 0xf92443f2, 0x01f00cf3, 0xe795091e, 0xe4c329a4],
    reversed_timestamp: 0x80e87959,
    nbits: 0xffff7f1f,
    nonce: 0x000001cd
};
const BLOCKHEADER_1937: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x73eb5655, 0xfacecdff, 0x72d233ad, 0x89486c22, 0x5f4cee3e, 0x49ae2a48, 0xccf35a62, 0xef371b00],
    merkle_root: [0xa801c26a, 0x430eec3b, 0x4e8711da, 0xd6a8d391, 0x4f2b1420, 0x9b0033c6, 0x8d0c2bb4, 0xc0650286],
    reversed_timestamp: 0xd8ea7959,
    nbits: 0xffff7f1f,
    nonce: 0x000002fd
};
const BLOCKHEADER_1938: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x292079f6, 0xfacd6161, 0x11fb5bd8, 0xab3d8483, 0x641ed0da, 0xa0349c81, 0xc9b76f59, 0xa2467200],
    merkle_root: [0x4c36bb70, 0x733dabf4, 0xfe382810, 0x25701031, 0x584b7d24, 0x0bac66a8, 0x8b81169b, 0x25303171],
    reversed_timestamp: 0x30ed7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000085
};
const BLOCKHEADER_1939: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x75b0e38b, 0x748f45a6, 0xa854f2ca, 0x32d44e2b, 0x97100d85, 0xdcc4b18b, 0xf3d685cc, 0x7a4a6500],
    merkle_root: [0x62eeefdc, 0x0cd34f79, 0x1ce0845c, 0x5e1ce795, 0xe5e0d1d7, 0x0adad9b7, 0xdfc1fe50, 0x1e36b71c],
    reversed_timestamp: 0x88ef7959,
    nbits: 0xffff7f1f,
    nonce: 0x000001ec
};
const BLOCKHEADER_1940: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2a532003, 0xaea9905f, 0x1f1cc2d1, 0x7d8d047d, 0x80851bd1, 0x3492c79a, 0xb8ed467c, 0xccc01700],
    merkle_root: [0x337d4601, 0x5305f52a, 0xdb38f2bb, 0x91139560, 0xd857f671, 0x8c87c5bd, 0x7f69543b, 0x601ad6e6],
    reversed_timestamp: 0xe0f17959,
    nbits: 0xffff7f1f,
    nonce: 0x000001bb
};
const BLOCKHEADER_1941: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4e3a670a, 0x086f97a2, 0x3fe4af13, 0x5392d53a, 0x724b11b8, 0x5494bce7, 0xa2476ece, 0x13e52700],
    merkle_root: [0xa85e3be7, 0x96573e00, 0xba4f0c66, 0x2398b4bb, 0x01c60f73, 0xb3154a19, 0xe2096916, 0x2274dc64],
    reversed_timestamp: 0x38f47959,
    nbits: 0xffff7f1f,
    nonce: 0x00000433
};
const BLOCKHEADER_1942: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9c3fa76f, 0x69d89271, 0x03c01519, 0x7d8544f9, 0x786375d9, 0x971b64d7, 0xbabe12e6, 0x10303c00],
    merkle_root: [0xd2dd0f2a, 0xfdcf4ef3, 0xa715c86d, 0xc8e16b63, 0x87909feb, 0xeeb0bb64, 0xf857be64, 0x8eef0dcc],
    reversed_timestamp: 0x90f67959,
    nbits: 0xffff7f1f,
    nonce: 0x00000261
};
const BLOCKHEADER_1943: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc68d063b, 0x0b9560bd, 0xe1e35beb, 0x70dc76b4, 0xc31da80f, 0xa4942b37, 0xe5ca2d8e, 0xf7ff4a00],
    merkle_root: [0xafcd6feb, 0x42aad8b8, 0x8d16907a, 0xbdc27ef8, 0xcfd728ac, 0xcd81ea31, 0xb428a7dc, 0xc74d8ced],
    reversed_timestamp: 0xe8f87959,
    nbits: 0xffff7f1f,
    nonce: 0x0000023d
};
const BLOCKHEADER_1944: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x48f4e8dc, 0x2d285211, 0x4190cb4b, 0xcef0be74, 0x1cdf11d2, 0x2f63dcde, 0x52fb4451, 0x9fd07d00],
    merkle_root: [0x1ec2f94f, 0xf63149c0, 0x0334ff69, 0x9930893f, 0x9cfd138f, 0x29c53929, 0x05eabaaa, 0xf653fd3b],
    reversed_timestamp: 0x40fb7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000160
};
const BLOCKHEADER_1945: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa2269a56, 0xc84c3d4d, 0x0b320775, 0xbdce5951, 0x94339e5e, 0xb2c12d8f, 0xe2310d45, 0x35b60a00],
    merkle_root: [0xa5acaff9, 0x89d8fd18, 0xbc57bde3, 0xd82aab2d, 0x4b7d244a, 0x1c0aeedb, 0xcf61555d, 0xad4a50d9],
    reversed_timestamp: 0x98fd7959,
    nbits: 0xffff7f1f,
    nonce: 0x0000013e
};
const BLOCKHEADER_1946: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8e3386a3, 0xeb94556f, 0x22e40f7a, 0x5100a4fe, 0x8476f42a, 0xfb45c8ec, 0xdf13fadc, 0x24cc7a00],
    merkle_root: [0x08704ddc, 0x1955e0cb, 0x7c493f10, 0x66e0962f, 0x04a06b31, 0x2d9842a1, 0x07a27cb1, 0x3185db9b],
    reversed_timestamp: 0xf0ff7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000209
};
const BLOCKHEADER_1947: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2e75b641, 0xa6dbb8c7, 0xef5191c1, 0x2fa30303, 0xbfe59a04, 0x43681785, 0xca7dc3db, 0x08b97b00],
    merkle_root: [0xc82af554, 0xf9539e2c, 0x13723fb5, 0x9001cd7e, 0x6f234e65, 0x18490e92, 0x3c1c0490, 0xb47d216a],
    reversed_timestamp: 0x48027a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000023b
};
const BLOCKHEADER_1948: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x59c9a4be, 0x766d2cae, 0x242ca4c7, 0x007bb569, 0xbeb590ef, 0xf8fb6d09, 0x7c049804, 0xe0c72a00],
    merkle_root: [0xb5a12651, 0x2508c8fc, 0x803030ed, 0x60769405, 0xe6485864, 0x1f01b826, 0x3a1d0e80, 0x3d198579],
    reversed_timestamp: 0xa0047a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000078c
};
const BLOCKHEADER_1949: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7c450bec, 0x4ea27a2c, 0x8b336c5b, 0x6ca13a88, 0x1eabdf1b, 0x167d88e7, 0x5be6bb4a, 0x5a3d4a00],
    merkle_root: [0x5f99ac88, 0x3c75648d, 0x792bac84, 0xe3fb851a, 0x7c4d7854, 0x17c2c504, 0xd249ae9c, 0xe8901137],
    reversed_timestamp: 0xf8067a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000021a
};
const BLOCKHEADER_1950: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x47dc6d80, 0x9869b58f, 0x0d85cba0, 0x5414a70e, 0x80bec83e, 0x59477960, 0x5e05cb1b, 0x95921000],
    merkle_root: [0x321b55ae, 0x3b892f2d, 0xd55b597b, 0xf4d1924b, 0xd3fce02e, 0x5c9b759c, 0x7ca20c5e, 0x3dead2c5],
    reversed_timestamp: 0x50097a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000074
};
const BLOCKHEADER_1951: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5252d38d, 0xa904b53e, 0x6b902fd3, 0x3472fa7e, 0x978c2ad5, 0xeadb0058, 0x18466c9a, 0x1c9e5a00],
    merkle_root: [0x86cce9fc, 0x1c5c154b, 0xe10a99d1, 0x0de0f741, 0x4873eccb, 0x066b6e3a, 0xb56a63c8, 0x2ea7385f],
    reversed_timestamp: 0xa80b7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000e6
};
const BLOCKHEADER_1952: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xebf0a03d, 0xed51b033, 0xf2cedc78, 0xe708089d, 0xacf84774, 0x47cc91bc, 0x5aeafd8f, 0xc9ab4f00],
    merkle_root: [0x863f4135, 0x0204ca9a, 0x3929eaeb, 0x0d159623, 0x9d51db52, 0x74bf451f, 0x26a0103d, 0xd34f0036],
    reversed_timestamp: 0x000e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000171
};
const BLOCKHEADER_1953: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x977ff275, 0x489b7ef9, 0x4e747b54, 0x8706b9d5, 0x0af3bc27, 0xb5405945, 0x55c1ee42, 0x9bc22400],
    merkle_root: [0x0c78a503, 0x6bf87262, 0xb9d7ee33, 0x829765fe, 0x2a691402, 0xb521c0ff, 0x764288a8, 0x9d3bd8a6],
    reversed_timestamp: 0x58107a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000ec
};
const BLOCKHEADER_1954: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xaeaef84b, 0x27b6fa66, 0x04c5bb69, 0x80f46aba, 0x847f8fb5, 0x83324ff9, 0x90552c59, 0x11fb1400],
    merkle_root: [0xfe67997f, 0x6f193071, 0x7052e234, 0xa7d438a3, 0xff0225f2, 0x725d7aa5, 0x87b1bfa6, 0x5a327cb4],
    reversed_timestamp: 0xb0127a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000024a
};
const BLOCKHEADER_1955: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xae5b8773, 0x0ddfe88d, 0xa1cdf366, 0x99e3b1a9, 0x8db68860, 0xa01a267b, 0x2e11e8ae, 0x481b4500],
    merkle_root: [0x630b8c2d, 0x77d55db8, 0xd0d7d923, 0xe1ba9813, 0x004a994e, 0xdc9c916d, 0xf729ece8, 0x585a74cb],
    reversed_timestamp: 0x08157a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000039
};
const BLOCKHEADER_1956: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2e70f9cd, 0x7676f5ab, 0xfa853616, 0x5bae6ad0, 0x12f3457c, 0x05cc8e6e, 0xbf797fd2, 0x4cda3c00],
    merkle_root: [0x5281adc0, 0xbb4bc67e, 0x8dd24071, 0x47ec44b1, 0x28eb587c, 0xfe4cb081, 0x898e4b11, 0x2d0dd950],
    reversed_timestamp: 0x60177a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000366
};
const BLOCKHEADER_1957: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6f08408c, 0xdd7aa6be, 0xef80f730, 0x4787bf8d, 0x0639531e, 0xaf76fd1e, 0xf27d4a8a, 0xe6e04700],
    merkle_root: [0xacbdef2c, 0xf6cab0af, 0x0c5858d7, 0x081dc091, 0x7e6fba76, 0x36ec02dd, 0x11513dc5, 0x789d5468],
    reversed_timestamp: 0xb8197a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000002
};
const BLOCKHEADER_1958: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa99a4831, 0xe522f4ba, 0x32295152, 0xce24f94f, 0x98fa49f0, 0x32f476b3, 0x942dfb80, 0x0a430000],
    merkle_root: [0x6e0bc0c8, 0xb0a0f194, 0x0e71adf1, 0x4b35a96c, 0x46122554, 0xd92f9764, 0x37f46927, 0x05f08128],
    reversed_timestamp: 0x101c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000003c
};
const BLOCKHEADER_1959: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3b7ed034, 0xaafb179f, 0x579aa46e, 0x42a77a01, 0x537e7d99, 0x90aaacce, 0xf75b8b50, 0x14736600],
    merkle_root: [0xbb9db2b6, 0xfbbc6591, 0x6cef1fe0, 0x989db18f, 0x0f7e19ba, 0xc2224ac3, 0x88bdd499, 0xc63c5d98],
    reversed_timestamp: 0x681e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000003e
};
const BLOCKHEADER_1960: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xdbb5ef6d, 0x10d02756, 0x2ff669cf, 0x549169c3, 0xacc5f76d, 0x05c27d8e, 0x5872d8b7, 0xe3311000],
    merkle_root: [0x7cc816b0, 0x88ad019e, 0x1b784487, 0x74014cc1, 0x3efbaaaf, 0xe492844c, 0xaa557ccf, 0x2d6d2974],
    reversed_timestamp: 0xc0207a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000b3
};
const BLOCKHEADER_1961: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa776e74a, 0x7a3101b7, 0x676869b2, 0x5526c2e5, 0xd275e4f1, 0x61e7fa6e, 0xf5446e43, 0xfa572500],
    merkle_root: [0xadfd274f, 0xe4c66017, 0x4b3087dc, 0xd3d71fbc, 0xcebf6a3d, 0x532dcb3d, 0x045f867e, 0x5a688e62],
    reversed_timestamp: 0x18237a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000003
};
const BLOCKHEADER_1962: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf4663cc2, 0x871689a4, 0x69493bd5, 0x72cca127, 0x0aaa1b44, 0x2ce8edac, 0x6f58abf2, 0x45ab4f00],
    merkle_root: [0x53577f43, 0x741fbcf3, 0x6b1065b2, 0x930fdf06, 0x746b2b4e, 0xb6b58059, 0xe418698c, 0xc0004673],
    reversed_timestamp: 0x70257a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000c0
};
const BLOCKHEADER_1963: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x925c4366, 0x0a235844, 0x7b007b2e, 0xf3ba4aba, 0x6c3551ee, 0x91db39b3, 0x571d2280, 0xc98c3f00],
    merkle_root: [0x20e9cdf3, 0xd28fb7df, 0x84004ff9, 0x6b417f1b, 0xba8eb803, 0xc6734c9c, 0xea917435, 0x13d96b03],
    reversed_timestamp: 0xc8277a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000dd
};
const BLOCKHEADER_1964: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa3b34e40, 0x02f84649, 0x3eefd6ba, 0x50562219, 0x2e1dbfe1, 0x6c5d2037, 0x387e78d7, 0x5b005600],
    merkle_root: [0x8c10cbdb, 0x0d300117, 0xb1e3624f, 0x99f905c9, 0x29338c60, 0x323ca17b, 0x172ebc6d, 0x03161608],
    reversed_timestamp: 0x202a7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001f3
};
const BLOCKHEADER_1965: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xad1db6f5, 0x90cd8351, 0x8d0c8895, 0x4f0f35eb, 0x7dce8813, 0xa85f5845, 0x969f8bbe, 0xc36c1300],
    merkle_root: [0x24582232, 0xf7138b5d, 0x1c8b8dfc, 0xb818e825, 0x4a693fc9, 0x96eb6475, 0xe31dee7b, 0xc4eaff80],
    reversed_timestamp: 0x782c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000ab
};
const BLOCKHEADER_1966: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xfcc96ae0, 0xe6d635b4, 0xc8bff40b, 0x3ba44709, 0xcdbd7d15, 0x6e98008d, 0xd09d3766, 0x9d993a00],
    merkle_root: [0x5a74a0ba, 0x44844d53, 0x9298373c, 0xadfacdd3, 0x3254176f, 0x75ff0f4b, 0xd1484409, 0x63907205],
    reversed_timestamp: 0xd02e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000002e0
};
const BLOCKHEADER_1967: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe160f447, 0x4835ddbb, 0x8167ad75, 0x371a676e, 0x6762107f, 0x442d7a45, 0xc8fc68bf, 0x63e47400],
    merkle_root: [0xeeab61e4, 0x020ed997, 0x01c19f2d, 0x6737cefa, 0x78b0d8e2, 0x6be84165, 0x4c16c0f5, 0x046b99da],
    reversed_timestamp: 0x28317a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000019b
};
const BLOCKHEADER_1968: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd4a257b4, 0x76436e4b, 0x8d232954, 0x5ca9e529, 0x8ab60a3c, 0xd0421948, 0x23760fd1, 0xc4944900],
    merkle_root: [0x0232a355, 0xa62bdf0a, 0xa1915d06, 0x3374be8e, 0x75ed9d87, 0x3ecbaa05, 0xdece40f6, 0x73975721],
    reversed_timestamp: 0x80337a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000f0
};
const BLOCKHEADER_1969: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc412dd58, 0xd3904ada, 0x3be9163f, 0x183b9c81, 0x7354adb0, 0xec8edccd, 0xc840df20, 0x32091f00],
    merkle_root: [0x54b4f431, 0x275fcfcb, 0xbae11d8e, 0x5fcdbad0, 0x5ec09a49, 0xe84a49fa, 0xb2faeb0e, 0xfbd9cd69],
    reversed_timestamp: 0xd8357a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000022f
};
const BLOCKHEADER_1970: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1bedf06e, 0xfcd3350f, 0x7fb61ba2, 0x59d7ff94, 0x2fb17b06, 0x233d6430, 0x50866148, 0x50356c00],
    merkle_root: [0x16a1fc48, 0xa8bf0920, 0x18d288e5, 0xbd71caf6, 0x5a6932eb, 0xd7c0589c, 0xa9e681c0, 0xa8c143aa],
    reversed_timestamp: 0x30387a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000022e
};
const BLOCKHEADER_1971: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x76ef7d98, 0x057831bd, 0x27520001, 0x5a8aa537, 0x52eccfe0, 0xb1dc7d01, 0x7bbd3547, 0x063f5900],
    merkle_root: [0x1ee8c442, 0x2fe51327, 0x17a5f44e, 0x90539144, 0x79a4f180, 0x00e252e2, 0x26869889, 0x4fc05ee0],
    reversed_timestamp: 0x883a7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000005f9
};
const BLOCKHEADER_1972: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xba9e31ac, 0x7111ee39, 0x28970e09, 0xf10bff64, 0x353a31a2, 0xb72ae0e0, 0x85c1dabd, 0x08b14500],
    merkle_root: [0x2c9496fa, 0x3fa14911, 0xd991e39d, 0x2fb0529c, 0x38b01199, 0x11d1b47f, 0xf209c016, 0xbe618a01],
    reversed_timestamp: 0xe03c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000010d
};
const BLOCKHEADER_1973: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2165f051, 0x24ddabdb, 0xc86ea322, 0x290d431c, 0x89903f5c, 0xa49c4b2c, 0xdfe77709, 0xc6184e00],
    merkle_root: [0x78c77216, 0x3864a3ab, 0xd4440639, 0xb950c6e6, 0x51ffaa93, 0xd5070c60, 0x08907f5f, 0x7cfb39f4],
    reversed_timestamp: 0x383f7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000053
};
const BLOCKHEADER_1974: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2e27b62f, 0x107e4b05, 0x59dca747, 0x84cc4225, 0xa1e8a893, 0x7d7d1013, 0x7490471a, 0x142d2500],
    merkle_root: [0x20504a46, 0x10f23730, 0xde094124, 0xa66b4ca5, 0x5d3f370f, 0x4c4dfbf1, 0x921d50c9, 0x968b6b9f],
    reversed_timestamp: 0x90417a59,
    nbits: 0xffff7f1f,
    nonce: 0x000008d5
};
const BLOCKHEADER_1975: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x660ea39d, 0xc43ba1f9, 0x987d93b3, 0xd23511be, 0x09ddf8f7, 0x46435484, 0x8cc03786, 0x15593f00],
    merkle_root: [0x6b213609, 0x633e1668, 0x6a55ff6f, 0x37a9c14c, 0xad39d781, 0x891e4609, 0xb274322c, 0x79250c06],
    reversed_timestamp: 0xe8437a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000382
};
const BLOCKHEADER_1976: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x674a3da9, 0x992e4c90, 0xeb8cd079, 0x6f296f7d, 0x46a6c96b, 0x91ecf336, 0xcce8648f, 0xe31e6b00],
    merkle_root: [0x8c51d906, 0x73f5608d, 0x75bf8329, 0xcd6dbf5d, 0xd5e70a5b, 0x4ae2fbd5, 0x1cc4206c, 0xda69c7e0],
    reversed_timestamp: 0x40467a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000eb
};
const BLOCKHEADER_1977: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3adbe5f5, 0xe1a37e0e, 0xc4810733, 0x2dd0efb7, 0xf9a670ac, 0x4babe464, 0x0d595457, 0xc0052d00],
    merkle_root: [0x7c7c6396, 0xea68e8be, 0x95641630, 0xaa2f2640, 0x13307d31, 0xd56deba0, 0x0d3a0edb, 0xfc4707f5],
    reversed_timestamp: 0x98487a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000187
};
const BLOCKHEADER_1978: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x15dc326a, 0xdf69b93e, 0xe0825a50, 0xab04a12f, 0xc04baef7, 0x29a76b92, 0xdbb183f4, 0x3fb40100],
    merkle_root: [0x296b7d8e, 0xa4e60055, 0xf6e54673, 0x893fa3d3, 0x658e78b7, 0xc6c133ff, 0x8174391b, 0xec318492],
    reversed_timestamp: 0xf04a7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000008b
};
const BLOCKHEADER_1979: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x18d725bc, 0x868629b4, 0xe458ceb6, 0xead48731, 0x90810130, 0x1c3f9a33, 0x3ba3caa5, 0x5aa25f00],
    merkle_root: [0x5911ef0f, 0x230478cb, 0xe08abe2c, 0x0ba27c7b, 0x231277e6, 0xa30d4741, 0xc33e8cb7, 0xf021c82a],
    reversed_timestamp: 0x484d7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000008d
};
const BLOCKHEADER_1980: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x0c5bbc1d, 0xaa446091, 0x7926947e, 0x3118ca89, 0xc665f81c, 0x238938b9, 0xb9c2bcde, 0x45bf5d00],
    merkle_root: [0xe9ce31cc, 0x0e19b115, 0xc10855af, 0x7c2bc8a9, 0xae14077c, 0xd37dcbce, 0xdb118931, 0xebe369fc],
    reversed_timestamp: 0xa04f7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001e4
};
const BLOCKHEADER_1981: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x55e064d5, 0x5ed4e813, 0x73735db4, 0x0ebcfa24, 0x4823b1f4, 0x07f8120d, 0x17e0d7c2, 0x7e260e00],
    merkle_root: [0x3aa88a83, 0xc19f69e5, 0xe273e1a0, 0xf56dd024, 0x7a671314, 0xc5876560, 0x47cf1da3, 0x300ee8b0],
    reversed_timestamp: 0xf8517a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000167
};
const BLOCKHEADER_1982: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x0f4f90d4, 0x05c41269, 0x1b98cde9, 0x5cac0930, 0x751153f6, 0x3dc58427, 0xca4040a3, 0x37886300],
    merkle_root: [0x28bd3901, 0x6d8ce6d3, 0x6fa6f46c, 0x66a20b8f, 0xcc16a480, 0x8c5db260, 0xdfc68d61, 0xb9bcb6bf],
    reversed_timestamp: 0x50547a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000060
};
const BLOCKHEADER_1983: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa48f14d4, 0x92bcb7a4, 0x9ee1a08e, 0x829b4cad, 0xd04cd48a, 0x3692891f, 0x4eca92f9, 0x48c55f00],
    merkle_root: [0x3ed5c01c, 0xe1484cc5, 0x7bfcbc92, 0xdffc2b11, 0xd0c88063, 0xfca58cd5, 0x6732d90c, 0xb2aca0f8],
    reversed_timestamp: 0xa8567a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001a5
};
const BLOCKHEADER_1984: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x51ac1413, 0x572960ba, 0xd4902013, 0x56ffb97f, 0x4c468111, 0x1092c660, 0x5b534cb5, 0x58885e00],
    merkle_root: [0x0e6f65a5, 0x6ce11607, 0xf3ffe07f, 0x345bfd45, 0xac716fd7, 0xa0f01f98, 0x572cc595, 0xbaa2f657],
    reversed_timestamp: 0x00597a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000ca
};
const BLOCKHEADER_1985: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf246f17f, 0x53e50720, 0x5277f185, 0x4ac1dd73, 0xa7fecbe2, 0x6b6449b2, 0xe6663e0f, 0x1a4c3f00],
    merkle_root: [0x248bd26d, 0x02ae185a, 0x9f47a84c, 0xc777712e, 0xea5062ac, 0xbe253d1b, 0x7b196d3e, 0x82a89f0f],
    reversed_timestamp: 0x585b7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000b5
};
const BLOCKHEADER_1986: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x48fef6fc, 0x854ccf61, 0x61a3cd83, 0x72730040, 0x514068cb, 0xa8f42625, 0xd31b2d44, 0xfc541800],
    merkle_root: [0xa3153b65, 0x36be9d14, 0xfdb9fd11, 0x4fc5a526, 0x0e44304e, 0x066dd6cb, 0x8fc17204, 0x9bc0339c],
    reversed_timestamp: 0xb05d7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000118
};
const BLOCKHEADER_1987: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5c6fa1e0, 0x81138e66, 0xa28b9de2, 0xc82acec6, 0xef96be77, 0x6850706e, 0x4b95f93e, 0x2c5e7700],
    merkle_root: [0x0a757fd0, 0x121a0e85, 0xf2a35ad8, 0x71ba2a8c, 0x5f9ab8fc, 0xc0dac0a4, 0xc458f629, 0xf851f39c],
    reversed_timestamp: 0x08607a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000074
};
const BLOCKHEADER_1988: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1c97c848, 0xc3d29f92, 0xb629928f, 0x5b9391af, 0x2cec3c41, 0x945dba6a, 0xc65804e3, 0x00c85900],
    merkle_root: [0xf026a7a1, 0x8abb5172, 0x0c540c77, 0xebbf1677, 0x422b11c5, 0x805a9b75, 0x91c17926, 0x2319d56e],
    reversed_timestamp: 0x60627a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000016b
};
const BLOCKHEADER_1989: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4eaa98fe, 0xff72895a, 0x6cf5ac10, 0x29d588da, 0x65e80d51, 0x059bfb10, 0x8f68e361, 0x3c7f5b00],
    merkle_root: [0x2bd6a351, 0x42b6fcde, 0xc6a8e33e, 0x1eff5bac, 0x5b88e1ac, 0x8063e402, 0xb27c6398, 0x978d368b],
    reversed_timestamp: 0xb8647a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000034d
};
const BLOCKHEADER_1990: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd289b669, 0x1d686387, 0xd35cea5e, 0x4ce4d924, 0xb8d9f309, 0x89d2321b, 0x9485f4ed, 0x9edf1500],
    merkle_root: [0xa55f4cb9, 0x3169bba3, 0x7950ffe5, 0x407f57ff, 0xb68ffbc8, 0x89ce1647, 0x76c78555, 0x8f2ab600],
    reversed_timestamp: 0x10677a59,
    nbits: 0xffff7f1f,
    nonce: 0x000002d8
};
const BLOCKHEADER_1991: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x57483f46, 0x4811b49d, 0x43468698, 0x778e6e2d, 0x60ba5677, 0xd6405111, 0xaa921d81, 0xefae6300],
    merkle_root: [0xbd377c6c, 0x21206c73, 0xa2f71563, 0x7942d16d, 0x2b721800, 0x807244a9, 0x7c0cd688, 0xddd33a07],
    reversed_timestamp: 0x68697a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001fb
};
const BLOCKHEADER_1992: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa3aff5f7, 0x7578704b, 0x1a0c1d41, 0xd93ae0c7, 0x1947a8d2, 0xf8e08123, 0x2ad20e3f, 0x5b425c00],
    merkle_root: [0x90d10c17, 0xa6b1be43, 0x6df9bdca, 0x6855f593, 0xa9df35e9, 0x4ac554b4, 0x613b30d6, 0x0c0e5b71],
    reversed_timestamp: 0xc06b7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000006a0
};
const BLOCKHEADER_1993: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2012fc5d, 0x991a125d, 0x2498c4d6, 0x4ad894e6, 0x0d116326, 0x09a88928, 0xc78607b6, 0x7a617a00],
    merkle_root: [0x60c1d00e, 0xd88130ec, 0xf598901b, 0xadfbe312, 0xde2a1bfe, 0xceb3e4b4, 0xaecbd33b, 0x8d9401d9],
    reversed_timestamp: 0x186e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000001
};
const BLOCKHEADER_1994: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x31bf3c69, 0x44d3167c, 0x8778c9bb, 0x471f39fb, 0xf431b262, 0xa83e1919, 0x7bc91cdd, 0xa86a5000],
    merkle_root: [0xcdd80d60, 0xb8609fe1, 0x1cd04bf5, 0xba6d0314, 0xd3071165, 0xffd5fa7f, 0x7582abec, 0xce223c9a],
    reversed_timestamp: 0x70707a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000b2
};
const BLOCKHEADER_1995: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf408ea9e, 0xce700868, 0x95d85885, 0xc72d597d, 0x18b2fc74, 0x1c4cf5cd, 0xddad5baf, 0x54fb5500],
    merkle_root: [0xfd0af768, 0x0f15e204, 0xc13a4d0b, 0x0cb75814, 0xaa9bbcbe, 0x96f2eac4, 0x898eb2b7, 0x4ed32116],
    reversed_timestamp: 0xc8727a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001a1
};
const BLOCKHEADER_1996: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf984508a, 0xeecb295a, 0xa84696c9, 0x6fa191b1, 0x68b4b89f, 0xbf0ec114, 0x445fdc4b, 0x5ca04800],
    merkle_root: [0xb87fe48b, 0x4f6f7215, 0x3f92e09c, 0xd86e05e6, 0x75d3a0a1, 0x1422fe30, 0xec8919bc, 0x98de4d46],
    reversed_timestamp: 0x20757a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000331
};
const BLOCKHEADER_1997: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x649f7de3, 0xde7055dc, 0xcd0526aa, 0xd03d7c29, 0xf10dd6a8, 0xf88408b6, 0x52632011, 0x70c03d00],
    merkle_root: [0x0c47cfc8, 0x59038556, 0x70ce675a, 0x091c3c28, 0x91f08af5, 0x4712a060, 0x0a3bbd39, 0x63222f75],
    reversed_timestamp: 0x78777a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000013e
};
const BLOCKHEADER_1998: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x46b3283a, 0x11313fe9, 0x0f050197, 0xe74b6049, 0x9c464a89, 0x6625cd78, 0x8c00ae25, 0x97151600],
    merkle_root: [0x820577c7, 0xced67d49, 0xa362c5d0, 0xbfe70475, 0x3c30e9d2, 0x86d5d2b0, 0xbb2959d0, 0x42cf8248],
    reversed_timestamp: 0xd0797a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001a9
};
const BLOCKHEADER_1999: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1c7f68ce, 0x7720eccc, 0x558fde15, 0x3a0a0e4d, 0xc1f373de, 0x68ba0654, 0x2a0aa737, 0x4edb4c00],
    merkle_root: [0xb371202b, 0x17b6f206, 0xb8b6b161, 0xc9169e45, 0x5c117112, 0xea6c85a2, 0x4296eb73, 0x11f62e49],
    reversed_timestamp: 0x287c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000169
};
const BLOCKHEADER_2000: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x05032487, 0xf4e3169a, 0xc5b14522, 0xc0780817, 0x19c4785c, 0xc142d188, 0x66aa2810, 0x4b547c00],
    merkle_root: [0xc7e28a68, 0x6f9b55e0, 0x9ba320ed, 0x8490f4ae, 0x9bd9fc49, 0x8671b23d, 0x9ae31092, 0x9ca81881],
    reversed_timestamp: 0x807e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000005ad
};
const BLOCKHEADER_2001: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc97aa923, 0x9a2e2561, 0x0d39c154, 0xbcba0059, 0x6d8c901a, 0x96b27439, 0xfcf8b60b, 0x6e914000],
    merkle_root: [0xaf4b1f4c, 0xb032054e, 0xb94c79f7, 0x130bbebc, 0x46c97b3c, 0x82a57858, 0x4e9a9feb, 0xe021ef30],
    reversed_timestamp: 0xd8807a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000b2
};
const BLOCKHEADER_2002: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x0caeeb2f, 0xe6c7feb3, 0x9ea6d5df, 0x8fcec623, 0x444cae88, 0x557b0a31, 0x685fd573, 0x80d36300],
    merkle_root: [0xc36aebf2, 0x3d4792d6, 0xa76a28ca, 0x60ee1772, 0x3571bd9c, 0xa83c31d0, 0x9b5df348, 0x822192b7],
    reversed_timestamp: 0x30837a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000017d
};
const BLOCKHEADER_2003: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xfc30e493, 0x2f9399ee, 0xa886b496, 0x5171a6ca, 0x926a7f39, 0x1a41adbf, 0x5921d8b7, 0x63374100],
    merkle_root: [0x64933ea3, 0x89f18895, 0xb68713ae, 0xc754ca2a, 0x984c9616, 0xf2d0e268, 0x399be754, 0xfca485e1],
    reversed_timestamp: 0x88857a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000d0
};
const BLOCKHEADER_2004: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7b5c9be6, 0xa665f35c, 0x1d9c32c9, 0x665393fb, 0x0ef836c8, 0x272b4fca, 0x8a4d5798, 0x182a1d00],
    merkle_root: [0x2d3e8b0d, 0x99a30bd9, 0x864e1792, 0x1b76a294, 0xb210182d, 0xd52276c8, 0x5a075883, 0x5aa8e2d6],
    reversed_timestamp: 0xe0877a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000d2
};
const BLOCKHEADER_2005: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb03df587, 0xabc58548, 0x95f59302, 0x2987ebae, 0x12fadc2d, 0xf74e1c3b, 0xe6a1586a, 0x43c25400],
    merkle_root: [0x53f22ee1, 0x640cafe2, 0xda9aa6e7, 0xd8b37c43, 0x97a79b68, 0xc0103b84, 0xfa9c5083, 0xee856b5e],
    reversed_timestamp: 0x388a7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000033c
};
const BLOCKHEADER_2006: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xde0274d0, 0x6eb3855c, 0x348a1e61, 0x579c0717, 0x201b62da, 0x18ec42ff, 0xea325950, 0xe5b11300],
    merkle_root: [0x9d5f03d4, 0xa9600d2f, 0x5301059e, 0x0b556edd, 0x649f3a2e, 0x4bb4bc52, 0x98e975cb, 0x5b9f8717],
    reversed_timestamp: 0x908c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000018f
};
const BLOCKHEADER_2007: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc7c2baf7, 0x6aa173b9, 0x0d67dd6c, 0x264e3421, 0xc7a8f245, 0xcf1c6688, 0x7cfdff01, 0x6b9d0600],
    merkle_root: [0xb5e226c1, 0x9ed34fa8, 0x453d6dc8, 0xaf6090fb, 0x550868ad, 0x0430d369, 0x25940420, 0x4ae6cc2e],
    reversed_timestamp: 0xe88e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001a5
};
const BLOCKHEADER_2008: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x60124b59, 0x98bfdc35, 0xd79a9cf2, 0xcd6b9916, 0xaf80cc1b, 0xbc6e56e5, 0x5c55d22e, 0xba946c00],
    merkle_root: [0xea08b245, 0xf41cd720, 0xcf0ecc0f, 0x53d480e2, 0xa7f358d4, 0x0a4342c3, 0xf2993c9d, 0x7fc9918a],
    reversed_timestamp: 0x40917a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000120
};
const BLOCKHEADER_2009: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xbd33cbbf, 0x6c2a4223, 0xe2b593a3, 0xa656f74e, 0x56185d30, 0x33c31360, 0x12acd02f, 0xfeb96600],
    merkle_root: [0xc9302392, 0xdda526f3, 0x9683620a, 0x5f540f62, 0xb4cbeaed, 0x622e5963, 0x8803cd92, 0x507163de],
    reversed_timestamp: 0x98937a59,
    nbits: 0xffff7f1f,
    nonce: 0x000004d0
};
const BLOCKHEADER_2010: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xcb52c88e, 0xc2d70600, 0x1f8820b3, 0x6d337337, 0xc81b03a1, 0xc00da474, 0xf7380978, 0x1dd71500],
    merkle_root: [0xd43d89fa, 0xe66b9ee0, 0x287aa06e, 0x8646ef57, 0xaea56692, 0x7d7cd2e7, 0x6b914bef, 0x4f3ae386],
    reversed_timestamp: 0xf0957a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000147
};
const BLOCKHEADER_2011: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7ceb9fa6, 0x9eb4fb64, 0x570ca78e, 0xa9ad802a, 0x3cd36a2e, 0x2747447d, 0xf7a8d745, 0x582f6c00],
    merkle_root: [0x578f2a48, 0xae32b17f, 0xc88c0537, 0x699e1662, 0xcb918026, 0xa711cece, 0x1b6f7b6f, 0x4f17d960],
    reversed_timestamp: 0x48987a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000068
};
const BLOCKHEADER_2012: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x68c7a40e, 0x34de94a1, 0x56e41426, 0x13e5da94, 0x81722381, 0x533edff1, 0x0721e5b7, 0x7a651100],
    merkle_root: [0x2ce09cc1, 0x5b6abcfc, 0xc8059ad9, 0x9019abde, 0x4a6979d6, 0x52d8755f, 0x5d95e382, 0x92b7ae06],
    reversed_timestamp: 0xa09a7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001e3
};
const BLOCKHEADER_2013: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8c381622, 0x3bd42fdd, 0x96055fa5, 0x522062f6, 0x2c0da7af, 0xdeb06f0e, 0x6c19b913, 0xace12400],
    merkle_root: [0x6bfb8234, 0xf0baf364, 0xa4ac57ac, 0x664bc327, 0x141d96c8, 0xa0472a7b, 0x237dbbda, 0xce251fff],
    reversed_timestamp: 0xf89c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000009
};
const BLOCKHEADER_2014: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9b409371, 0x70c69446, 0xe5ef9e76, 0xc8f3a5d9, 0xd5f34916, 0x9af7c2b0, 0xe9673918, 0xf46d1200],
    merkle_root: [0x91d7c849, 0xb7ac2878, 0xb5042672, 0xa74184e1, 0x9258a412, 0xad215a32, 0x34f93e53, 0xbb23dd8a],
    reversed_timestamp: 0x509f7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001a4
};
const BLOCKHEADER_2015: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3949ac77, 0x25c010cb, 0x2c279433, 0xb8ff5b62, 0xb53abb40, 0x86ea25a8, 0xe7946e03, 0x44d27500],
    merkle_root: [0x36ac8763, 0x85e81a3e, 0x681f863d, 0x43f440fb, 0x4bda7aca, 0xa33dc977, 0x4a52aa90, 0x987eafc4],
    reversed_timestamp: 0xa8a17a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000c6
};
const BLOCKHEADER_2016: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa3d10d2d, 0xd4ddb445, 0x7df1a269, 0x0137dd3f, 0xd90a7114, 0x6677e72a, 0xf8d1d1bd, 0x08624700],
    merkle_root: [0x44ef9a55, 0x607048f1, 0x479da02b, 0x8d74f954, 0x155b62de, 0xe61a9ecc, 0x18597b53, 0x9bde49f4],
    reversed_timestamp: 0x00a47a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000081
};
const BLOCKHEADER_2017: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd2d551d6, 0xdadce6e7, 0xac97d76c, 0x6eca8ddc, 0xb8bf5f9e, 0x22123531, 0x84f06f4c, 0xed124000],
    merkle_root: [0xc9470981, 0x0be528c0, 0x72412961, 0xc04d3a00, 0x98aef4c6, 0xec52c170, 0x1f75b849, 0x19e84081],
    reversed_timestamp: 0x58a67a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000000df
};
const BLOCKHEADER_2018: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xaa792a8d, 0xf5d8c9ef, 0xd314ffae, 0x9793b109, 0xc8e04c7d, 0xf415cc0e, 0xa8507d2b, 0xa0d16200],
    merkle_root: [0x553a3ddf, 0xa334b055, 0x9c61ad55, 0x90450c74, 0x1c5576f4, 0x22f30902, 0x2ea97a09, 0xcdd4bf3f],
    reversed_timestamp: 0xb0a87a59,
    nbits: 0xbdef7f1f,
    nonce: 0x0000011a
};
const BLOCKHEADER_2019: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xbaf21e25, 0x20cb236c, 0xb2470ba4, 0xa6b369d2, 0xbd794885, 0x06b59f22, 0xa655411a, 0x0c8f2f00],
    merkle_root: [0x4b65ff99, 0xb2462513, 0xc134a57d, 0x134c1936, 0x3a6d61ad, 0xcd164386, 0xac19ccec, 0x8524f8c2],
    reversed_timestamp: 0x08ab7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000486
};
const BLOCKHEADER_2020: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3670229b, 0x0c06f6a1, 0xd39ab46b, 0x46a169d4, 0xf778e0b6, 0x05ec9675, 0x33d12a3f, 0x1e0c3600],
    merkle_root: [0x25e0d7d9, 0x33a06f7b, 0x9f477a57, 0x3ac71621, 0xd176b7ef, 0x259744d8, 0x2131607b, 0x394e4724],
    reversed_timestamp: 0x60ad7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000808
};
const BLOCKHEADER_2021: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb0ba2caa, 0x9c4c0351, 0x9a59f420, 0x48f9750f, 0x5723379c, 0xb45b741d, 0xa354db30, 0x997f5d00],
    merkle_root: [0x0d49eded, 0x6ce44ed0, 0x9482c9dc, 0x51b7785a, 0x010a1d3a, 0x450429a8, 0xa539aed4, 0x7c38f979],
    reversed_timestamp: 0xb8af7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000000b3
};
const BLOCKHEADER_2022: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x42347cf1, 0x541ed4e3, 0x92969a41, 0x043604bd, 0x29671c10, 0xe36ac09c, 0xdc44dcca, 0x25fe7600],
    merkle_root: [0x1fe29891, 0x59a98c64, 0xe49856f7, 0x0d92865c, 0xd907b4c1, 0x08d4e0e0, 0x4e904904, 0xba5b7c9a],
    reversed_timestamp: 0x10b27a59,
    nbits: 0xbdef7f1f,
    nonce: 0x0000084e
};
const BLOCKHEADER_2023: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc50f23c5, 0x73ae157f, 0x7aca83d1, 0xb2bd7458, 0xdc540964, 0x003568da, 0x0b596f98, 0x46a45c00],
    merkle_root: [0xb6e523cf, 0x3615cec4, 0xeb147992, 0x2aed464c, 0xc70a2be6, 0x5e8cb8cc, 0xe6e0e35e, 0x4fac237d],
    reversed_timestamp: 0x68b47a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000001a8
};
const BLOCKHEADER_2024: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1c4d364b, 0x9afb0a42, 0x72c31c81, 0xa2da9163, 0x0818df15, 0x17ab07d8, 0x9ea85831, 0xf5224900],
    merkle_root: [0xef6e306e, 0x4d74b311, 0xac10aad5, 0x7ec8315c, 0xad25d547, 0xb6a90765, 0xca35b310, 0x0e217042],
    reversed_timestamp: 0xc0b67a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000002d6
};
const BLOCKHEADER_2025: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1f35c2b2, 0x0650e583, 0xa3b01229, 0x5227b364, 0xc95ce8d9, 0x1fd1148f, 0x49955e8f, 0x280c4000],
    merkle_root: [0x2a2a089e, 0x4cc64449, 0xc03934ae, 0xda364390, 0x8baa73e9, 0xb7a6e3da, 0xe3c3ac55, 0x7d493365],
    reversed_timestamp: 0x18b97a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000001ff
};
const BLOCKHEADER_2026: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x801d61ef, 0x0e20faf3, 0xda1b5de4, 0x8f343c86, 0x12a369a4, 0x12d31931, 0x6ee2bc82, 0x5a907e00],
    merkle_root: [0x0a0e230d, 0x53ec027e, 0x31ca68b1, 0xa85770c4, 0x4da448f5, 0xd4a52431, 0x7e7bb316, 0xecad157e],
    reversed_timestamp: 0x70bb7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000044
};
const BLOCKHEADER_2027: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xea3e524e, 0xf0ee83a6, 0x28b3945f, 0xb66afc68, 0x626948e1, 0xa67c184a, 0x0f13be55, 0x733c6500],
    merkle_root: [0x4400f3ba, 0x5e641b72, 0x7decef0f, 0x405660e5, 0x3b0abd44, 0xb378fd67, 0xb903bbd8, 0x595fc1e3],
    reversed_timestamp: 0xc8bd7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000084
};
const BLOCKHEADER_2028: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1eff9dc9, 0x94f8a560, 0xf50c0d8b, 0x86e75663, 0x2ac6bdb5, 0x24fbe88c, 0x66ff6d08, 0x46be6700],
    merkle_root: [0xf2ca0dcd, 0x4d048e44, 0xb0057f02, 0x1ba90634, 0x93655697, 0xb27694c3, 0x9720e520, 0x82bd5546],
    reversed_timestamp: 0x20c07a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000079
};
const BLOCKHEADER_2029: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6405ff96, 0x0a355a03, 0xf938716d, 0xe9a2159c, 0x30828415, 0xea665544, 0x279051fc, 0x02410f00],
    merkle_root: [0x13223d6a, 0x966264d5, 0xaf9a00c6, 0x1e667a77, 0x472de42f, 0x26484352, 0xbd1ccdfe, 0x78ec837c],
    reversed_timestamp: 0x78c27a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000147
};
const BLOCKHEADER_2030: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x971fe6bf, 0x493760cb, 0x70ae7b7a, 0x368b9371, 0x55bd2ce3, 0xbe85ebfe, 0x1893ed5d, 0x1ce77000],
    merkle_root: [0x40589814, 0xf8536a4a, 0x95c4cb05, 0xce8bb5eb, 0xa4c32fd5, 0xe6b9b309, 0xeb66cf1b, 0xde8733f5],
    reversed_timestamp: 0xd0c47a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000040
};
const BLOCKHEADER_2031: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x158ad39c, 0xbfcc3154, 0xf6e55354, 0x2c2ad132, 0x99b2db55, 0xb351903b, 0x9102faef, 0xc7902300],
    merkle_root: [0x20786ba8, 0xe5969130, 0xb848e80f, 0xc49bcf83, 0x78aa7df6, 0x0f26e211, 0xb534f440, 0x90ef227a],
    reversed_timestamp: 0x28c77a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000003d9
};
const BLOCKHEADER_2032: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4c42c725, 0x24fd72ee, 0x8ccf1913, 0x5e6e4286, 0x7962f628, 0xa138b8a7, 0x71ac710d, 0x5b4b6000],
    merkle_root: [0x00d95fc9, 0x52916492, 0x456a75c2, 0xc2e79c37, 0xa1988b3c, 0x9a761cf2, 0x567fd0df, 0x13750766],
    reversed_timestamp: 0x80c97a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000239
};
const BLOCKHEADER_2033: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc70ec52c, 0x3d7858ed, 0xcedd4ee3, 0x62aef9fb, 0x4296c2ad, 0xb99e95fb, 0x8c44d9bb, 0x40c51a00],
    merkle_root: [0x3a72276d, 0x93d75f23, 0x1863edf1, 0x57e00f54, 0x324ea86b, 0x1aa4bdc7, 0x21165ae0, 0x8e208bf0],
    reversed_timestamp: 0xd8cb7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000007a0
};
const BLOCKHEADER_2034: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8ed5f34d, 0x161d0fad, 0xb74ee977, 0x281279e6, 0xcba39302, 0x0a49a230, 0x9236fd43, 0xc1522e00],
    merkle_root: [0xfe6eca8e, 0x720cf9d4, 0x9a122eb3, 0x903f8737, 0xbceddcd0, 0xcb89b855, 0xe51ca21b, 0x9ee21368],
    reversed_timestamp: 0x30ce7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000037
};
const BLOCKHEADER_2035: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe234cf2e, 0x16e50596, 0x7e0bd958, 0x775168c1, 0x79e50796, 0xed1bfca9, 0xec695cc9, 0xe4785a00],
    merkle_root: [0xecdd834d, 0xeccf9523, 0xf4c9f0b4, 0x7009f832, 0x23d60be5, 0x3346180f, 0xe7ad36be, 0xb66b294c],
    reversed_timestamp: 0x88d07a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000372
};

pub const BLOCKHEADERS: [BlockHeader; 135] = [
    BLOCKHEADER_1901,
    BLOCKHEADER_1902,
    BLOCKHEADER_1903,
    BLOCKHEADER_1904,
    BLOCKHEADER_1905,
    BLOCKHEADER_1906,
    BLOCKHEADER_1907,
    BLOCKHEADER_1908,
    BLOCKHEADER_1909,
    BLOCKHEADER_1910,
    BLOCKHEADER_1911,
    BLOCKHEADER_1912,
    BLOCKHEADER_1913,
    BLOCKHEADER_1914,
    BLOCKHEADER_1915,
    BLOCKHEADER_1916,
    BLOCKHEADER_1917,
    BLOCKHEADER_1918,
    BLOCKHEADER_1919,
    BLOCKHEADER_1920,
    BLOCKHEADER_1921,
    BLOCKHEADER_1922,
    BLOCKHEADER_1923,
    BLOCKHEADER_1924,
    BLOCKHEADER_1925,
    BLOCKHEADER_1926,
    BLOCKHEADER_1927,
    BLOCKHEADER_1928,
    BLOCKHEADER_1929,
    BLOCKHEADER_1930,
    BLOCKHEADER_1931,
    BLOCKHEADER_1932,
    BLOCKHEADER_1933,
    BLOCKHEADER_1934,
    BLOCKHEADER_1935,
    BLOCKHEADER_1936,
    BLOCKHEADER_1937,
    BLOCKHEADER_1938,
    BLOCKHEADER_1939,
    BLOCKHEADER_1940,
    BLOCKHEADER_1941,
    BLOCKHEADER_1942,
    BLOCKHEADER_1943,
    BLOCKHEADER_1944,
    BLOCKHEADER_1945,
    BLOCKHEADER_1946,
    BLOCKHEADER_1947,
    BLOCKHEADER_1948,
    BLOCKHEADER_1949,
    BLOCKHEADER_1950,
    BLOCKHEADER_1951,
    BLOCKHEADER_1952,
    BLOCKHEADER_1953,
    BLOCKHEADER_1954,
    BLOCKHEADER_1955,
    BLOCKHEADER_1956,
    BLOCKHEADER_1957,
    BLOCKHEADER_1958,
    BLOCKHEADER_1959,
    BLOCKHEADER_1960,
    BLOCKHEADER_1961,
    BLOCKHEADER_1962,
    BLOCKHEADER_1963,
    BLOCKHEADER_1964,
    BLOCKHEADER_1965,
    BLOCKHEADER_1966,
    BLOCKHEADER_1967,
    BLOCKHEADER_1968,
    BLOCKHEADER_1969,
    BLOCKHEADER_1970,
    BLOCKHEADER_1971,
    BLOCKHEADER_1972,
    BLOCKHEADER_1973,
    BLOCKHEADER_1974,
    BLOCKHEADER_1975,
    BLOCKHEADER_1976,
    BLOCKHEADER_1977,
    BLOCKHEADER_1978,
    BLOCKHEADER_1979,
    BLOCKHEADER_1980,
    BLOCKHEADER_1981,
    BLOCKHEADER_1982,
    BLOCKHEADER_1983,
    BLOCKHEADER_1984,
    BLOCKHEADER_1985,
    BLOCKHEADER_1986,
    BLOCKHEADER_1987,
    BLOCKHEADER_1988,
    BLOCKHEADER_1989,
    BLOCKHEADER_1990,
    BLOCKHEADER_1991,
    BLOCKHEADER_1992,
    BLOCKHEADER_1993,
    BLOCKHEADER_1994,
    BLOCKHEADER_1995,
    BLOCKHEADER_1996,
    BLOCKHEADER_1997,
    BLOCKHEADER_1998,
    BLOCKHEADER_1999,
    BLOCKHEADER_2000,
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
    BLOCKHEADER_2031,
    BLOCKHEADER_2032,
    BLOCKHEADER_2033,
    BLOCKHEADER_2034,
    BLOCKHEADER_2035,
];

pub const STORED_BLOCKHEADERS: [StoredBlockHeader; 136] = [
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1900,
        block_hash: [0x743ce276, 0x7297cff4, 0xf9d5f871, 0x1e294745, 0xb9fa84e9, 0xac5bc59f, 0x190d4dcf, 0x82f97600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000eda00,
        block_height: 1900,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501134000, 1501134600, 1501135200, 1501135800, 1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1901,
        block_hash: [0x22291c36, 0x6cc3c99d, 0xbce05a37, 0x303104cb, 0xed3e9412, 0xd386336b, 0x6bf30486, 0xfd6f2000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000edc00,
        block_height: 1901,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501134600, 1501135200, 1501135800, 1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1902,
        block_hash: [0x81cbcc76, 0xed402bc0, 0x292e8c1f, 0x68cf81f1, 0x7e217e54, 0x9c4a6178, 0xe3ded6e7, 0x2e246d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ede00,
        block_height: 1902,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501135200, 1501135800, 1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1903,
        block_hash: [0xb9adc773, 0xa53ba742, 0x14de6054, 0x03dac4c0, 0xff354c7a, 0xcbf1e56a, 0x0f9fb152, 0xbc783700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee000,
        block_height: 1903,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501135800, 1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140600, 1501141200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1904,
        block_hash: [0x9195a32b, 0xd788b123, 0x25cba3b7, 0x2d7246bc, 0xe2c91685, 0xb3c4e656, 0x2db9a553, 0xb42c3e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee200,
        block_height: 1904,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140600, 1501141200, 1501141800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1905,
        block_hash: [0x1788abc6, 0x92d9b20b, 0x6fce1358, 0x2f489f81, 0xeacd3e97, 0xdc8b3854, 0x6640d6e9, 0xf31b5000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee400,
        block_height: 1905,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140600, 1501141200, 1501141800, 1501142400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1906,
        block_hash: [0xdbbd31a3, 0xfc65a428, 0xfb14866f, 0xb9461d55, 0xf359c970, 0xeefa5784, 0x7d1ffe1f, 0x45833f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee600,
        block_height: 1906,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140600, 1501141200, 1501141800, 1501142400, 1501143000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1907,
        block_hash: [0xbe058e0c, 0x83f7d73e, 0xc6fbc750, 0x93d02961, 0x8c493769, 0xef9196ab, 0x66d237f7, 0xe8c64200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee800,
        block_height: 1907,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501138200, 1501138800, 1501139400, 1501140000, 1501140600, 1501141200, 1501141800, 1501142400, 1501143000, 1501143600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1908,
        block_hash: [0x2336b3d3, 0xf1fe9382, 0x6e348b93, 0x16716b77, 0xa5dfdf54, 0x61ad974c, 0xb3955cd2, 0xb3072b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000eea00,
        block_height: 1908,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501138800, 1501139400, 1501140000, 1501140600, 1501141200, 1501141800, 1501142400, 1501143000, 1501143600, 1501144200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1909,
        block_hash: [0x3d91877d, 0x4bc929f4, 0x80a85b66, 0x799369fb, 0x6384caa3, 0xcb5ad4b8, 0x786c1a52, 0x7c212600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000eec00,
        block_height: 1909,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501139400, 1501140000, 1501140600, 1501141200, 1501141800, 1501142400, 1501143000, 1501143600, 1501144200, 1501144800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1910,
        block_hash: [0xd4961063, 0xca23a378, 0x1279cfd2, 0x970d0c16, 0xaf22fcde, 0x3d286f34, 0xcff741ca, 0x4b237300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000eee00,
        block_height: 1910,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140000, 1501140600, 1501141200, 1501141800, 1501142400, 1501143000, 1501143600, 1501144200, 1501144800, 1501145400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1911,
        block_hash: [0x96900034, 0xe26bca1d, 0xb96ceb56, 0x6349d38f, 0x3adacb3c, 0xc5734fe0, 0xda792035, 0xe8d44600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef000,
        block_height: 1911,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140600, 1501141200, 1501141800, 1501142400, 1501143000, 1501143600, 1501144200, 1501144800, 1501145400, 1501146000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1912,
        block_hash: [0x35d59181, 0xe09ad19d, 0x74f93850, 0x83d61812, 0x59da315d, 0x586b0652, 0x2ebc3554, 0x608f0500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef200,
        block_height: 1912,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501141200, 1501141800, 1501142400, 1501143000, 1501143600, 1501144200, 1501144800, 1501145400, 1501146000, 1501146600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1913,
        block_hash: [0x34b933f1, 0x2fce3119, 0x236dac55, 0xd6467ecd, 0xfab3bc45, 0xd5613281, 0x5c8f4870, 0x4d1b4900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef400,
        block_height: 1913,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501141800, 1501142400, 1501143000, 1501143600, 1501144200, 1501144800, 1501145400, 1501146000, 1501146600, 1501147200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1914,
        block_hash: [0xd5fcc658, 0xbbfd862d, 0xf8400557, 0x50fce39d, 0x07eb6782, 0x3c694d0b, 0x43e6653e, 0x7bfe3c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef600,
        block_height: 1914,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501142400, 1501143000, 1501143600, 1501144200, 1501144800, 1501145400, 1501146000, 1501146600, 1501147200, 1501147800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1915,
        block_hash: [0xe7847ff7, 0xa7b6288d, 0x42e1442a, 0x73ea3d65, 0x408a66be, 0x1921346c, 0xb4687be5, 0xfb124900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef800,
        block_height: 1915,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501143000, 1501143600, 1501144200, 1501144800, 1501145400, 1501146000, 1501146600, 1501147200, 1501147800, 1501148400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1916,
        block_hash: [0xa75ba060, 0x5ba2ec2a, 0x419e44d8, 0x53e85a65, 0xdce4244b, 0x48dc52a7, 0x98a7946b, 0x0d676f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000efa00,
        block_height: 1916,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501143600, 1501144200, 1501144800, 1501145400, 1501146000, 1501146600, 1501147200, 1501147800, 1501148400, 1501149000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1917,
        block_hash: [0x023a2e49, 0x1ff6d3da, 0x94c56046, 0x4e621715, 0x7565962e, 0x7fa7ad85, 0x18521273, 0x11b43000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000efc00,
        block_height: 1917,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501144200, 1501144800, 1501145400, 1501146000, 1501146600, 1501147200, 1501147800, 1501148400, 1501149000, 1501149600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1918,
        block_hash: [0xf9e8ebf7, 0x6cbc670e, 0xe743fb5e, 0xd71fde22, 0xc5679f38, 0x1e98df47, 0x52ee74d9, 0x7e854100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000efe00,
        block_height: 1918,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501144800, 1501145400, 1501146000, 1501146600, 1501147200, 1501147800, 1501148400, 1501149000, 1501149600, 1501150200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1919,
        block_hash: [0x95300d31, 0x667608cb, 0x99411d77, 0xfca8ff91, 0xb3e4ce93, 0x0343dedb, 0x9409f358, 0x68902200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0000,
        block_height: 1919,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501145400, 1501146000, 1501146600, 1501147200, 1501147800, 1501148400, 1501149000, 1501149600, 1501150200, 1501150800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1920,
        block_hash: [0x0421a4bf, 0xdfaed5a0, 0xf95d84f4, 0x57d0ccef, 0x7d769f73, 0x8c7381dc, 0x2e03fddd, 0x09747900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0200,
        block_height: 1920,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501146000, 1501146600, 1501147200, 1501147800, 1501148400, 1501149000, 1501149600, 1501150200, 1501150800, 1501151400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1921,
        block_hash: [0x484d85b7, 0xa7973843, 0x3e580cdc, 0x7e8afaef, 0x9963a98e, 0xe997a338, 0x0971837a, 0x8d9b5b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0400,
        block_height: 1921,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501146600, 1501147200, 1501147800, 1501148400, 1501149000, 1501149600, 1501150200, 1501150800, 1501151400, 1501152000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1922,
        block_hash: [0x27ccd57d, 0x183a9ddd, 0x1c2932d3, 0x8ef22895, 0x71972a52, 0xe43b8916, 0xa70a69bd, 0xa1386b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0600,
        block_height: 1922,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501147200, 1501147800, 1501148400, 1501149000, 1501149600, 1501150200, 1501150800, 1501151400, 1501152000, 1501152600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1923,
        block_hash: [0x59853be0, 0xcbe5d908, 0xca96078c, 0xa0f3f012, 0x3750bd4f, 0x6980a0bf, 0xa6b02c66, 0xd44b7500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0800,
        block_height: 1923,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501147800, 1501148400, 1501149000, 1501149600, 1501150200, 1501150800, 1501151400, 1501152000, 1501152600, 1501153200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1924,
        block_hash: [0x35224f6e, 0x63c53232, 0xed3ed7a5, 0x9d0601fb, 0xbe18a843, 0x5a9e437e, 0x79e0abab, 0x20b30a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0a00,
        block_height: 1924,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501148400, 1501149000, 1501149600, 1501150200, 1501150800, 1501151400, 1501152000, 1501152600, 1501153200, 1501153800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1925,
        block_hash: [0x86185566, 0xea3b1a97, 0xea200160, 0x2fa62cbb, 0x26205b86, 0xe195b9dd, 0x051a69ac, 0x81800700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0c00,
        block_height: 1925,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501149000, 1501149600, 1501150200, 1501150800, 1501151400, 1501152000, 1501152600, 1501153200, 1501153800, 1501154400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1926,
        block_hash: [0xd5272a21, 0x1a46cc35, 0x1ea71c5f, 0x37de58c5, 0x69ef0cb7, 0x7d0da021, 0x04e32e93, 0xc1d37000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0e00,
        block_height: 1926,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501149600, 1501150200, 1501150800, 1501151400, 1501152000, 1501152600, 1501153200, 1501153800, 1501154400, 1501155000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1927,
        block_hash: [0x34e37c22, 0x1e6ad706, 0xd61646a7, 0xc56bb91b, 0xe35f4f06, 0x2a7bf52e, 0x35c4cb89, 0x4f972100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1000,
        block_height: 1927,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501150200, 1501150800, 1501151400, 1501152000, 1501152600, 1501153200, 1501153800, 1501154400, 1501155000, 1501155600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1928,
        block_hash: [0x4828f699, 0xeea36880, 0x9e18d656, 0xef80b4a4, 0x61c3db2e, 0x264740b2, 0x4be38a94, 0xf6cd1100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1200,
        block_height: 1928,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501150800, 1501151400, 1501152000, 1501152600, 1501153200, 1501153800, 1501154400, 1501155000, 1501155600, 1501156200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1929,
        block_hash: [0x248922e3, 0x071e1128, 0x174e00ad, 0xde957ba9, 0xbff9c521, 0x8490fb7f, 0xb7628270, 0x3bfd0c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1400,
        block_height: 1929,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501151400, 1501152000, 1501152600, 1501153200, 1501153800, 1501154400, 1501155000, 1501155600, 1501156200, 1501156800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1930,
        block_hash: [0x564602b1, 0x880a0fe9, 0x911efc64, 0x64a835fb, 0x38d54263, 0x22020ef9, 0x0f27344b, 0xc10c7c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1600,
        block_height: 1930,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501152000, 1501152600, 1501153200, 1501153800, 1501154400, 1501155000, 1501155600, 1501156200, 1501156800, 1501157400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1931,
        block_hash: [0xc35b8e19, 0xbd3d1358, 0x4f338502, 0xbf884e78, 0xfe0e5201, 0xad933897, 0xe63772bd, 0x5db71700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1800,
        block_height: 1931,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501152600, 1501153200, 1501153800, 1501154400, 1501155000, 1501155600, 1501156200, 1501156800, 1501157400, 1501158000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1932,
        block_hash: [0x3bda1ee5, 0x2efe4ce6, 0x6d863a72, 0xe8bbe3b9, 0x339f241f, 0x0727e178, 0xa24f3546, 0xdbb04100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1a00,
        block_height: 1932,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501153200, 1501153800, 1501154400, 1501155000, 1501155600, 1501156200, 1501156800, 1501157400, 1501158000, 1501158600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1933,
        block_hash: [0x08593a66, 0xb32151ae, 0x0cc138b9, 0xe0290646, 0xa7b79a72, 0x54befaef, 0x99276224, 0x54454e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1c00,
        block_height: 1933,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501153800, 1501154400, 1501155000, 1501155600, 1501156200, 1501156800, 1501157400, 1501158000, 1501158600, 1501159200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1934,
        block_hash: [0x9ffe9b8e, 0x19fd435a, 0xf297acc2, 0xb20202b8, 0x23275264, 0xe9a9e786, 0xf8c9954a, 0x78eb1300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1e00,
        block_height: 1934,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501154400, 1501155000, 1501155600, 1501156200, 1501156800, 1501157400, 1501158000, 1501158600, 1501159200, 1501159800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1935,
        block_hash: [0xe6ad1313, 0xbc246ef5, 0x0ab648a7, 0x669e9ae3, 0x13cc5c27, 0xb78c747b, 0xc97102ef, 0x10711300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2000,
        block_height: 1935,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501155000, 1501155600, 1501156200, 1501156800, 1501157400, 1501158000, 1501158600, 1501159200, 1501159800, 1501160400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1936,
        block_hash: [0x73eb5655, 0xfacecdff, 0x72d233ad, 0x89486c22, 0x5f4cee3e, 0x49ae2a48, 0xccf35a62, 0xef371b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2200,
        block_height: 1936,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501155600, 1501156200, 1501156800, 1501157400, 1501158000, 1501158600, 1501159200, 1501159800, 1501160400, 1501161000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1937,
        block_hash: [0x292079f6, 0xfacd6161, 0x11fb5bd8, 0xab3d8483, 0x641ed0da, 0xa0349c81, 0xc9b76f59, 0xa2467200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2400,
        block_height: 1937,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501156200, 1501156800, 1501157400, 1501158000, 1501158600, 1501159200, 1501159800, 1501160400, 1501161000, 1501161600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1938,
        block_hash: [0x75b0e38b, 0x748f45a6, 0xa854f2ca, 0x32d44e2b, 0x97100d85, 0xdcc4b18b, 0xf3d685cc, 0x7a4a6500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2600,
        block_height: 1938,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501156800, 1501157400, 1501158000, 1501158600, 1501159200, 1501159800, 1501160400, 1501161000, 1501161600, 1501162200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1939,
        block_hash: [0x2a532003, 0xaea9905f, 0x1f1cc2d1, 0x7d8d047d, 0x80851bd1, 0x3492c79a, 0xb8ed467c, 0xccc01700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2800,
        block_height: 1939,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501157400, 1501158000, 1501158600, 1501159200, 1501159800, 1501160400, 1501161000, 1501161600, 1501162200, 1501162800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1940,
        block_hash: [0x4e3a670a, 0x086f97a2, 0x3fe4af13, 0x5392d53a, 0x724b11b8, 0x5494bce7, 0xa2476ece, 0x13e52700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2a00,
        block_height: 1940,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501158000, 1501158600, 1501159200, 1501159800, 1501160400, 1501161000, 1501161600, 1501162200, 1501162800, 1501163400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1941,
        block_hash: [0x9c3fa76f, 0x69d89271, 0x03c01519, 0x7d8544f9, 0x786375d9, 0x971b64d7, 0xbabe12e6, 0x10303c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2c00,
        block_height: 1941,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501158600, 1501159200, 1501159800, 1501160400, 1501161000, 1501161600, 1501162200, 1501162800, 1501163400, 1501164000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1942,
        block_hash: [0xc68d063b, 0x0b9560bd, 0xe1e35beb, 0x70dc76b4, 0xc31da80f, 0xa4942b37, 0xe5ca2d8e, 0xf7ff4a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2e00,
        block_height: 1942,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501159200, 1501159800, 1501160400, 1501161000, 1501161600, 1501162200, 1501162800, 1501163400, 1501164000, 1501164600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1943,
        block_hash: [0x48f4e8dc, 0x2d285211, 0x4190cb4b, 0xcef0be74, 0x1cdf11d2, 0x2f63dcde, 0x52fb4451, 0x9fd07d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3000,
        block_height: 1943,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501159800, 1501160400, 1501161000, 1501161600, 1501162200, 1501162800, 1501163400, 1501164000, 1501164600, 1501165200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1944,
        block_hash: [0xa2269a56, 0xc84c3d4d, 0x0b320775, 0xbdce5951, 0x94339e5e, 0xb2c12d8f, 0xe2310d45, 0x35b60a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3200,
        block_height: 1944,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501160400, 1501161000, 1501161600, 1501162200, 1501162800, 1501163400, 1501164000, 1501164600, 1501165200, 1501165800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1945,
        block_hash: [0x8e3386a3, 0xeb94556f, 0x22e40f7a, 0x5100a4fe, 0x8476f42a, 0xfb45c8ec, 0xdf13fadc, 0x24cc7a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3400,
        block_height: 1945,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501161000, 1501161600, 1501162200, 1501162800, 1501163400, 1501164000, 1501164600, 1501165200, 1501165800, 1501166400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1946,
        block_hash: [0x2e75b641, 0xa6dbb8c7, 0xef5191c1, 0x2fa30303, 0xbfe59a04, 0x43681785, 0xca7dc3db, 0x08b97b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3600,
        block_height: 1946,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501161600, 1501162200, 1501162800, 1501163400, 1501164000, 1501164600, 1501165200, 1501165800, 1501166400, 1501167000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1947,
        block_hash: [0x59c9a4be, 0x766d2cae, 0x242ca4c7, 0x007bb569, 0xbeb590ef, 0xf8fb6d09, 0x7c049804, 0xe0c72a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3800,
        block_height: 1947,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501162200, 1501162800, 1501163400, 1501164000, 1501164600, 1501165200, 1501165800, 1501166400, 1501167000, 1501167600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1948,
        block_hash: [0x7c450bec, 0x4ea27a2c, 0x8b336c5b, 0x6ca13a88, 0x1eabdf1b, 0x167d88e7, 0x5be6bb4a, 0x5a3d4a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3a00,
        block_height: 1948,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501162800, 1501163400, 1501164000, 1501164600, 1501165200, 1501165800, 1501166400, 1501167000, 1501167600, 1501168200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1949,
        block_hash: [0x47dc6d80, 0x9869b58f, 0x0d85cba0, 0x5414a70e, 0x80bec83e, 0x59477960, 0x5e05cb1b, 0x95921000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3c00,
        block_height: 1949,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501163400, 1501164000, 1501164600, 1501165200, 1501165800, 1501166400, 1501167000, 1501167600, 1501168200, 1501168800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1950,
        block_hash: [0x5252d38d, 0xa904b53e, 0x6b902fd3, 0x3472fa7e, 0x978c2ad5, 0xeadb0058, 0x18466c9a, 0x1c9e5a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3e00,
        block_height: 1950,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501164000, 1501164600, 1501165200, 1501165800, 1501166400, 1501167000, 1501167600, 1501168200, 1501168800, 1501169400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1951,
        block_hash: [0xebf0a03d, 0xed51b033, 0xf2cedc78, 0xe708089d, 0xacf84774, 0x47cc91bc, 0x5aeafd8f, 0xc9ab4f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4000,
        block_height: 1951,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501164600, 1501165200, 1501165800, 1501166400, 1501167000, 1501167600, 1501168200, 1501168800, 1501169400, 1501170000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1952,
        block_hash: [0x977ff275, 0x489b7ef9, 0x4e747b54, 0x8706b9d5, 0x0af3bc27, 0xb5405945, 0x55c1ee42, 0x9bc22400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4200,
        block_height: 1952,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501165200, 1501165800, 1501166400, 1501167000, 1501167600, 1501168200, 1501168800, 1501169400, 1501170000, 1501170600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1953,
        block_hash: [0xaeaef84b, 0x27b6fa66, 0x04c5bb69, 0x80f46aba, 0x847f8fb5, 0x83324ff9, 0x90552c59, 0x11fb1400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4400,
        block_height: 1953,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501165800, 1501166400, 1501167000, 1501167600, 1501168200, 1501168800, 1501169400, 1501170000, 1501170600, 1501171200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1954,
        block_hash: [0xae5b8773, 0x0ddfe88d, 0xa1cdf366, 0x99e3b1a9, 0x8db68860, 0xa01a267b, 0x2e11e8ae, 0x481b4500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4600,
        block_height: 1954,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501166400, 1501167000, 1501167600, 1501168200, 1501168800, 1501169400, 1501170000, 1501170600, 1501171200, 1501171800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1955,
        block_hash: [0x2e70f9cd, 0x7676f5ab, 0xfa853616, 0x5bae6ad0, 0x12f3457c, 0x05cc8e6e, 0xbf797fd2, 0x4cda3c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4800,
        block_height: 1955,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501167000, 1501167600, 1501168200, 1501168800, 1501169400, 1501170000, 1501170600, 1501171200, 1501171800, 1501172400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1956,
        block_hash: [0x6f08408c, 0xdd7aa6be, 0xef80f730, 0x4787bf8d, 0x0639531e, 0xaf76fd1e, 0xf27d4a8a, 0xe6e04700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4a00,
        block_height: 1956,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501167600, 1501168200, 1501168800, 1501169400, 1501170000, 1501170600, 1501171200, 1501171800, 1501172400, 1501173000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1957,
        block_hash: [0xa99a4831, 0xe522f4ba, 0x32295152, 0xce24f94f, 0x98fa49f0, 0x32f476b3, 0x942dfb80, 0x0a430000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4c00,
        block_height: 1957,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501168200, 1501168800, 1501169400, 1501170000, 1501170600, 1501171200, 1501171800, 1501172400, 1501173000, 1501173600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1958,
        block_hash: [0x3b7ed034, 0xaafb179f, 0x579aa46e, 0x42a77a01, 0x537e7d99, 0x90aaacce, 0xf75b8b50, 0x14736600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4e00,
        block_height: 1958,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501168800, 1501169400, 1501170000, 1501170600, 1501171200, 1501171800, 1501172400, 1501173000, 1501173600, 1501174200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1959,
        block_hash: [0xdbb5ef6d, 0x10d02756, 0x2ff669cf, 0x549169c3, 0xacc5f76d, 0x05c27d8e, 0x5872d8b7, 0xe3311000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5000,
        block_height: 1959,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501169400, 1501170000, 1501170600, 1501171200, 1501171800, 1501172400, 1501173000, 1501173600, 1501174200, 1501174800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1960,
        block_hash: [0xa776e74a, 0x7a3101b7, 0x676869b2, 0x5526c2e5, 0xd275e4f1, 0x61e7fa6e, 0xf5446e43, 0xfa572500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5200,
        block_height: 1960,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501170000, 1501170600, 1501171200, 1501171800, 1501172400, 1501173000, 1501173600, 1501174200, 1501174800, 1501175400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1961,
        block_hash: [0xf4663cc2, 0x871689a4, 0x69493bd5, 0x72cca127, 0x0aaa1b44, 0x2ce8edac, 0x6f58abf2, 0x45ab4f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5400,
        block_height: 1961,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501170600, 1501171200, 1501171800, 1501172400, 1501173000, 1501173600, 1501174200, 1501174800, 1501175400, 1501176000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1962,
        block_hash: [0x925c4366, 0x0a235844, 0x7b007b2e, 0xf3ba4aba, 0x6c3551ee, 0x91db39b3, 0x571d2280, 0xc98c3f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5600,
        block_height: 1962,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501171200, 1501171800, 1501172400, 1501173000, 1501173600, 1501174200, 1501174800, 1501175400, 1501176000, 1501176600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1963,
        block_hash: [0xa3b34e40, 0x02f84649, 0x3eefd6ba, 0x50562219, 0x2e1dbfe1, 0x6c5d2037, 0x387e78d7, 0x5b005600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5800,
        block_height: 1963,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501171800, 1501172400, 1501173000, 1501173600, 1501174200, 1501174800, 1501175400, 1501176000, 1501176600, 1501177200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1964,
        block_hash: [0xad1db6f5, 0x90cd8351, 0x8d0c8895, 0x4f0f35eb, 0x7dce8813, 0xa85f5845, 0x969f8bbe, 0xc36c1300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5a00,
        block_height: 1964,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501172400, 1501173000, 1501173600, 1501174200, 1501174800, 1501175400, 1501176000, 1501176600, 1501177200, 1501177800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1965,
        block_hash: [0xfcc96ae0, 0xe6d635b4, 0xc8bff40b, 0x3ba44709, 0xcdbd7d15, 0x6e98008d, 0xd09d3766, 0x9d993a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5c00,
        block_height: 1965,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501173000, 1501173600, 1501174200, 1501174800, 1501175400, 1501176000, 1501176600, 1501177200, 1501177800, 1501178400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1966,
        block_hash: [0xe160f447, 0x4835ddbb, 0x8167ad75, 0x371a676e, 0x6762107f, 0x442d7a45, 0xc8fc68bf, 0x63e47400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5e00,
        block_height: 1966,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501173600, 1501174200, 1501174800, 1501175400, 1501176000, 1501176600, 1501177200, 1501177800, 1501178400, 1501179000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1967,
        block_hash: [0xd4a257b4, 0x76436e4b, 0x8d232954, 0x5ca9e529, 0x8ab60a3c, 0xd0421948, 0x23760fd1, 0xc4944900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6000,
        block_height: 1967,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501174200, 1501174800, 1501175400, 1501176000, 1501176600, 1501177200, 1501177800, 1501178400, 1501179000, 1501179600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1968,
        block_hash: [0xc412dd58, 0xd3904ada, 0x3be9163f, 0x183b9c81, 0x7354adb0, 0xec8edccd, 0xc840df20, 0x32091f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6200,
        block_height: 1968,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501174800, 1501175400, 1501176000, 1501176600, 1501177200, 1501177800, 1501178400, 1501179000, 1501179600, 1501180200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1969,
        block_hash: [0x1bedf06e, 0xfcd3350f, 0x7fb61ba2, 0x59d7ff94, 0x2fb17b06, 0x233d6430, 0x50866148, 0x50356c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6400,
        block_height: 1969,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501175400, 1501176000, 1501176600, 1501177200, 1501177800, 1501178400, 1501179000, 1501179600, 1501180200, 1501180800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1970,
        block_hash: [0x76ef7d98, 0x057831bd, 0x27520001, 0x5a8aa537, 0x52eccfe0, 0xb1dc7d01, 0x7bbd3547, 0x063f5900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6600,
        block_height: 1970,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501176000, 1501176600, 1501177200, 1501177800, 1501178400, 1501179000, 1501179600, 1501180200, 1501180800, 1501181400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1971,
        block_hash: [0xba9e31ac, 0x7111ee39, 0x28970e09, 0xf10bff64, 0x353a31a2, 0xb72ae0e0, 0x85c1dabd, 0x08b14500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6800,
        block_height: 1971,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501176600, 1501177200, 1501177800, 1501178400, 1501179000, 1501179600, 1501180200, 1501180800, 1501181400, 1501182000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1972,
        block_hash: [0x2165f051, 0x24ddabdb, 0xc86ea322, 0x290d431c, 0x89903f5c, 0xa49c4b2c, 0xdfe77709, 0xc6184e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6a00,
        block_height: 1972,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501177200, 1501177800, 1501178400, 1501179000, 1501179600, 1501180200, 1501180800, 1501181400, 1501182000, 1501182600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1973,
        block_hash: [0x2e27b62f, 0x107e4b05, 0x59dca747, 0x84cc4225, 0xa1e8a893, 0x7d7d1013, 0x7490471a, 0x142d2500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6c00,
        block_height: 1973,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501177800, 1501178400, 1501179000, 1501179600, 1501180200, 1501180800, 1501181400, 1501182000, 1501182600, 1501183200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1974,
        block_hash: [0x660ea39d, 0xc43ba1f9, 0x987d93b3, 0xd23511be, 0x09ddf8f7, 0x46435484, 0x8cc03786, 0x15593f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6e00,
        block_height: 1974,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501178400, 1501179000, 1501179600, 1501180200, 1501180800, 1501181400, 1501182000, 1501182600, 1501183200, 1501183800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1975,
        block_hash: [0x674a3da9, 0x992e4c90, 0xeb8cd079, 0x6f296f7d, 0x46a6c96b, 0x91ecf336, 0xcce8648f, 0xe31e6b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7000,
        block_height: 1975,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501179000, 1501179600, 1501180200, 1501180800, 1501181400, 1501182000, 1501182600, 1501183200, 1501183800, 1501184400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1976,
        block_hash: [0x3adbe5f5, 0xe1a37e0e, 0xc4810733, 0x2dd0efb7, 0xf9a670ac, 0x4babe464, 0x0d595457, 0xc0052d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7200,
        block_height: 1976,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501179600, 1501180200, 1501180800, 1501181400, 1501182000, 1501182600, 1501183200, 1501183800, 1501184400, 1501185000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1977,
        block_hash: [0x15dc326a, 0xdf69b93e, 0xe0825a50, 0xab04a12f, 0xc04baef7, 0x29a76b92, 0xdbb183f4, 0x3fb40100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7400,
        block_height: 1977,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501180200, 1501180800, 1501181400, 1501182000, 1501182600, 1501183200, 1501183800, 1501184400, 1501185000, 1501185600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1978,
        block_hash: [0x18d725bc, 0x868629b4, 0xe458ceb6, 0xead48731, 0x90810130, 0x1c3f9a33, 0x3ba3caa5, 0x5aa25f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7600,
        block_height: 1978,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501180800, 1501181400, 1501182000, 1501182600, 1501183200, 1501183800, 1501184400, 1501185000, 1501185600, 1501186200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1979,
        block_hash: [0x0c5bbc1d, 0xaa446091, 0x7926947e, 0x3118ca89, 0xc665f81c, 0x238938b9, 0xb9c2bcde, 0x45bf5d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7800,
        block_height: 1979,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501181400, 1501182000, 1501182600, 1501183200, 1501183800, 1501184400, 1501185000, 1501185600, 1501186200, 1501186800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1980,
        block_hash: [0x55e064d5, 0x5ed4e813, 0x73735db4, 0x0ebcfa24, 0x4823b1f4, 0x07f8120d, 0x17e0d7c2, 0x7e260e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7a00,
        block_height: 1980,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501182000, 1501182600, 1501183200, 1501183800, 1501184400, 1501185000, 1501185600, 1501186200, 1501186800, 1501187400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1981,
        block_hash: [0x0f4f90d4, 0x05c41269, 0x1b98cde9, 0x5cac0930, 0x751153f6, 0x3dc58427, 0xca4040a3, 0x37886300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7c00,
        block_height: 1981,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501182600, 1501183200, 1501183800, 1501184400, 1501185000, 1501185600, 1501186200, 1501186800, 1501187400, 1501188000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1982,
        block_hash: [0xa48f14d4, 0x92bcb7a4, 0x9ee1a08e, 0x829b4cad, 0xd04cd48a, 0x3692891f, 0x4eca92f9, 0x48c55f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7e00,
        block_height: 1982,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501183200, 1501183800, 1501184400, 1501185000, 1501185600, 1501186200, 1501186800, 1501187400, 1501188000, 1501188600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1983,
        block_hash: [0x51ac1413, 0x572960ba, 0xd4902013, 0x56ffb97f, 0x4c468111, 0x1092c660, 0x5b534cb5, 0x58885e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8000,
        block_height: 1983,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501183800, 1501184400, 1501185000, 1501185600, 1501186200, 1501186800, 1501187400, 1501188000, 1501188600, 1501189200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1984,
        block_hash: [0xf246f17f, 0x53e50720, 0x5277f185, 0x4ac1dd73, 0xa7fecbe2, 0x6b6449b2, 0xe6663e0f, 0x1a4c3f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8200,
        block_height: 1984,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501184400, 1501185000, 1501185600, 1501186200, 1501186800, 1501187400, 1501188000, 1501188600, 1501189200, 1501189800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1985,
        block_hash: [0x48fef6fc, 0x854ccf61, 0x61a3cd83, 0x72730040, 0x514068cb, 0xa8f42625, 0xd31b2d44, 0xfc541800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8400,
        block_height: 1985,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501185000, 1501185600, 1501186200, 1501186800, 1501187400, 1501188000, 1501188600, 1501189200, 1501189800, 1501190400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1986,
        block_hash: [0x5c6fa1e0, 0x81138e66, 0xa28b9de2, 0xc82acec6, 0xef96be77, 0x6850706e, 0x4b95f93e, 0x2c5e7700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8600,
        block_height: 1986,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501185600, 1501186200, 1501186800, 1501187400, 1501188000, 1501188600, 1501189200, 1501189800, 1501190400, 1501191000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1987,
        block_hash: [0x1c97c848, 0xc3d29f92, 0xb629928f, 0x5b9391af, 0x2cec3c41, 0x945dba6a, 0xc65804e3, 0x00c85900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8800,
        block_height: 1987,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501186200, 1501186800, 1501187400, 1501188000, 1501188600, 1501189200, 1501189800, 1501190400, 1501191000, 1501191600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1988,
        block_hash: [0x4eaa98fe, 0xff72895a, 0x6cf5ac10, 0x29d588da, 0x65e80d51, 0x059bfb10, 0x8f68e361, 0x3c7f5b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8a00,
        block_height: 1988,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501186800, 1501187400, 1501188000, 1501188600, 1501189200, 1501189800, 1501190400, 1501191000, 1501191600, 1501192200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1989,
        block_hash: [0xd289b669, 0x1d686387, 0xd35cea5e, 0x4ce4d924, 0xb8d9f309, 0x89d2321b, 0x9485f4ed, 0x9edf1500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8c00,
        block_height: 1989,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501187400, 1501188000, 1501188600, 1501189200, 1501189800, 1501190400, 1501191000, 1501191600, 1501192200, 1501192800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1990,
        block_hash: [0x57483f46, 0x4811b49d, 0x43468698, 0x778e6e2d, 0x60ba5677, 0xd6405111, 0xaa921d81, 0xefae6300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8e00,
        block_height: 1990,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501188000, 1501188600, 1501189200, 1501189800, 1501190400, 1501191000, 1501191600, 1501192200, 1501192800, 1501193400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1991,
        block_hash: [0xa3aff5f7, 0x7578704b, 0x1a0c1d41, 0xd93ae0c7, 0x1947a8d2, 0xf8e08123, 0x2ad20e3f, 0x5b425c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9000,
        block_height: 1991,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501188600, 1501189200, 1501189800, 1501190400, 1501191000, 1501191600, 1501192200, 1501192800, 1501193400, 1501194000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1992,
        block_hash: [0x2012fc5d, 0x991a125d, 0x2498c4d6, 0x4ad894e6, 0x0d116326, 0x09a88928, 0xc78607b6, 0x7a617a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9200,
        block_height: 1992,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501189200, 1501189800, 1501190400, 1501191000, 1501191600, 1501192200, 1501192800, 1501193400, 1501194000, 1501194600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1993,
        block_hash: [0x31bf3c69, 0x44d3167c, 0x8778c9bb, 0x471f39fb, 0xf431b262, 0xa83e1919, 0x7bc91cdd, 0xa86a5000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9400,
        block_height: 1993,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501189800, 1501190400, 1501191000, 1501191600, 1501192200, 1501192800, 1501193400, 1501194000, 1501194600, 1501195200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1994,
        block_hash: [0xf408ea9e, 0xce700868, 0x95d85885, 0xc72d597d, 0x18b2fc74, 0x1c4cf5cd, 0xddad5baf, 0x54fb5500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9600,
        block_height: 1994,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501190400, 1501191000, 1501191600, 1501192200, 1501192800, 1501193400, 1501194000, 1501194600, 1501195200, 1501195800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1995,
        block_hash: [0xf984508a, 0xeecb295a, 0xa84696c9, 0x6fa191b1, 0x68b4b89f, 0xbf0ec114, 0x445fdc4b, 0x5ca04800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9800,
        block_height: 1995,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501191000, 1501191600, 1501192200, 1501192800, 1501193400, 1501194000, 1501194600, 1501195200, 1501195800, 1501196400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1996,
        block_hash: [0x649f7de3, 0xde7055dc, 0xcd0526aa, 0xd03d7c29, 0xf10dd6a8, 0xf88408b6, 0x52632011, 0x70c03d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9a00,
        block_height: 1996,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501191600, 1501192200, 1501192800, 1501193400, 1501194000, 1501194600, 1501195200, 1501195800, 1501196400, 1501197000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1997,
        block_hash: [0x46b3283a, 0x11313fe9, 0x0f050197, 0xe74b6049, 0x9c464a89, 0x6625cd78, 0x8c00ae25, 0x97151600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9c00,
        block_height: 1997,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501192200, 1501192800, 1501193400, 1501194000, 1501194600, 1501195200, 1501195800, 1501196400, 1501197000, 1501197600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1998,
        block_hash: [0x1c7f68ce, 0x7720eccc, 0x558fde15, 0x3a0a0e4d, 0xc1f373de, 0x68ba0654, 0x2a0aa737, 0x4edb4c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9e00,
        block_height: 1998,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501192800, 1501193400, 1501194000, 1501194600, 1501195200, 1501195800, 1501196400, 1501197000, 1501197600, 1501198200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1999,
        block_hash: [0x05032487, 0xf4e3169a, 0xc5b14522, 0xc0780817, 0x19c4785c, 0xc142d188, 0x66aa2810, 0x4b547c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa000,
        block_height: 1999,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501193400, 1501194000, 1501194600, 1501195200, 1501195800, 1501196400, 1501197000, 1501197600, 1501198200, 1501198800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2000,
        block_hash: [0xc97aa923, 0x9a2e2561, 0x0d39c154, 0xbcba0059, 0x6d8c901a, 0x96b27439, 0xfcf8b60b, 0x6e914000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa200,
        block_height: 2000,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501194000, 1501194600, 1501195200, 1501195800, 1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2001,
        block_hash: [0x0caeeb2f, 0xe6c7feb3, 0x9ea6d5df, 0x8fcec623, 0x444cae88, 0x557b0a31, 0x685fd573, 0x80d36300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa400,
        block_height: 2001,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501194600, 1501195200, 1501195800, 1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2002,
        block_hash: [0xfc30e493, 0x2f9399ee, 0xa886b496, 0x5171a6ca, 0x926a7f39, 0x1a41adbf, 0x5921d8b7, 0x63374100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa600,
        block_height: 2002,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501195200, 1501195800, 1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2003,
        block_hash: [0x7b5c9be6, 0xa665f35c, 0x1d9c32c9, 0x665393fb, 0x0ef836c8, 0x272b4fca, 0x8a4d5798, 0x182a1d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa800,
        block_height: 2003,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501195800, 1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2004,
        block_hash: [0xb03df587, 0xabc58548, 0x95f59302, 0x2987ebae, 0x12fadc2d, 0xf74e1c3b, 0xe6a1586a, 0x43c25400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000faa00,
        block_height: 2004,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2005,
        block_hash: [0xde0274d0, 0x6eb3855c, 0x348a1e61, 0x579c0717, 0x201b62da, 0x18ec42ff, 0xea325950, 0xe5b11300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fac00,
        block_height: 2005,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2006,
        block_hash: [0xc7c2baf7, 0x6aa173b9, 0x0d67dd6c, 0x264e3421, 0xc7a8f245, 0xcf1c6688, 0x7cfdff01, 0x6b9d0600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fae00,
        block_height: 2006,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2007,
        block_hash: [0x60124b59, 0x98bfdc35, 0xd79a9cf2, 0xcd6b9916, 0xaf80cc1b, 0xbc6e56e5, 0x5c55d22e, 0xba946c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb000,
        block_height: 2007,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2008,
        block_hash: [0xbd33cbbf, 0x6c2a4223, 0xe2b593a3, 0xa656f74e, 0x56185d30, 0x33c31360, 0x12acd02f, 0xfeb96600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb200,
        block_height: 2008,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2009,
        block_hash: [0xcb52c88e, 0xc2d70600, 0x1f8820b3, 0x6d337337, 0xc81b03a1, 0xc00da474, 0xf7380978, 0x1dd71500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb400,
        block_height: 2009,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2010,
        block_hash: [0x7ceb9fa6, 0x9eb4fb64, 0x570ca78e, 0xa9ad802a, 0x3cd36a2e, 0x2747447d, 0xf7a8d745, 0x582f6c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb600,
        block_height: 2010,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2011,
        block_hash: [0x68c7a40e, 0x34de94a1, 0x56e41426, 0x13e5da94, 0x81722381, 0x533edff1, 0x0721e5b7, 0x7a651100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb800,
        block_height: 2011,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2012,
        block_hash: [0x8c381622, 0x3bd42fdd, 0x96055fa5, 0x522062f6, 0x2c0da7af, 0xdeb06f0e, 0x6c19b913, 0xace12400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fba00,
        block_height: 2012,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2013,
        block_hash: [0x9b409371, 0x70c69446, 0xe5ef9e76, 0xc8f3a5d9, 0xd5f34916, 0x9af7c2b0, 0xe9673918, 0xf46d1200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fbc00,
        block_height: 2013,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2014,
        block_hash: [0x3949ac77, 0x25c010cb, 0x2c279433, 0xb8ff5b62, 0xb53abb40, 0x86ea25a8, 0xe7946e03, 0x44d27500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fbe00,
        block_height: 2014,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2015,
        block_hash: [0xa3d10d2d, 0xd4ddb445, 0x7df1a269, 0x0137dd3f, 0xd90a7114, 0x6677e72a, 0xf8d1d1bd, 0x08624700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc000,
        block_height: 2015,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2016,
        block_hash: [0xd2d551d6, 0xdadce6e7, 0xac97d76c, 0x6eca8ddc, 0xb8bf5f9e, 0x22123531, 0x84f06f4c, 0xed124000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc200,
        block_height: 2016,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2017,
        block_hash: [0xaa792a8d, 0xf5d8c9ef, 0xd314ffae, 0x9793b109, 0xc8e04c7d, 0xf415cc0e, 0xa8507d2b, 0xa0d16200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc400,
        block_height: 2017,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2018,
        block_hash: [0xbaf21e25, 0x20cb236c, 0xb2470ba4, 0xa6b369d2, 0xbd794885, 0x06b59f22, 0xa655411a, 0x0c8f2f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc600,
        block_height: 2018,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2019,
        block_hash: [0x3670229b, 0x0c06f6a1, 0xd39ab46b, 0x46a169d4, 0xf778e0b6, 0x05ec9675, 0x33d12a3f, 0x1e0c3600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc800,
        block_height: 2019,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2020,
        block_hash: [0xb0ba2caa, 0x9c4c0351, 0x9a59f420, 0x48f9750f, 0x5723379c, 0xb45b741d, 0xa354db30, 0x997f5d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fca00,
        block_height: 2020,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800, 1501211400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2021,
        block_hash: [0x42347cf1, 0x541ed4e3, 0x92969a41, 0x043604bd, 0x29671c10, 0xe36ac09c, 0xdc44dcca, 0x25fe7600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fcc00,
        block_height: 2021,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800, 1501211400, 1501212000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2022,
        block_hash: [0xc50f23c5, 0x73ae157f, 0x7aca83d1, 0xb2bd7458, 0xdc540964, 0x003568da, 0x0b596f98, 0x46a45c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fce00,
        block_height: 2022,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800, 1501211400, 1501212000, 1501212600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2023,
        block_hash: [0x1c4d364b, 0x9afb0a42, 0x72c31c81, 0xa2da9163, 0x0818df15, 0x17ab07d8, 0x9ea85831, 0xf5224900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd000,
        block_height: 2023,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800, 1501211400, 1501212000, 1501212600, 1501213200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2024,
        block_hash: [0x1f35c2b2, 0x0650e583, 0xa3b01229, 0x5227b364, 0xc95ce8d9, 0x1fd1148f, 0x49955e8f, 0x280c4000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd200,
        block_height: 2024,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501208400, 1501209000, 1501209600, 1501210200, 1501210800, 1501211400, 1501212000, 1501212600, 1501213200, 1501213800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2025,
        block_hash: [0x801d61ef, 0x0e20faf3, 0xda1b5de4, 0x8f343c86, 0x12a369a4, 0x12d31931, 0x6ee2bc82, 0x5a907e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd400,
        block_height: 2025,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501209000, 1501209600, 1501210200, 1501210800, 1501211400, 1501212000, 1501212600, 1501213200, 1501213800, 1501214400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2026,
        block_hash: [0xea3e524e, 0xf0ee83a6, 0x28b3945f, 0xb66afc68, 0x626948e1, 0xa67c184a, 0x0f13be55, 0x733c6500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd600,
        block_height: 2026,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501209600, 1501210200, 1501210800, 1501211400, 1501212000, 1501212600, 1501213200, 1501213800, 1501214400, 1501215000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2027,
        block_hash: [0x1eff9dc9, 0x94f8a560, 0xf50c0d8b, 0x86e75663, 0x2ac6bdb5, 0x24fbe88c, 0x66ff6d08, 0x46be6700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd800,
        block_height: 2027,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501210200, 1501210800, 1501211400, 1501212000, 1501212600, 1501213200, 1501213800, 1501214400, 1501215000, 1501215600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2028,
        block_hash: [0x6405ff96, 0x0a355a03, 0xf938716d, 0xe9a2159c, 0x30828415, 0xea665544, 0x279051fc, 0x02410f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fda00,
        block_height: 2028,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501210800, 1501211400, 1501212000, 1501212600, 1501213200, 1501213800, 1501214400, 1501215000, 1501215600, 1501216200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2029,
        block_hash: [0x971fe6bf, 0x493760cb, 0x70ae7b7a, 0x368b9371, 0x55bd2ce3, 0xbe85ebfe, 0x1893ed5d, 0x1ce77000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fdc00,
        block_height: 2029,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501211400, 1501212000, 1501212600, 1501213200, 1501213800, 1501214400, 1501215000, 1501215600, 1501216200, 1501216800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2030,
        block_hash: [0x158ad39c, 0xbfcc3154, 0xf6e55354, 0x2c2ad132, 0x99b2db55, 0xb351903b, 0x9102faef, 0xc7902300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fde00,
        block_height: 2030,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501212000, 1501212600, 1501213200, 1501213800, 1501214400, 1501215000, 1501215600, 1501216200, 1501216800, 1501217400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2031,
        block_hash: [0x4c42c725, 0x24fd72ee, 0x8ccf1913, 0x5e6e4286, 0x7962f628, 0xa138b8a7, 0x71ac710d, 0x5b4b6000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fe000,
        block_height: 2031,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501212600, 1501213200, 1501213800, 1501214400, 1501215000, 1501215600, 1501216200, 1501216800, 1501217400, 1501218000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2032,
        block_hash: [0xc70ec52c, 0x3d7858ed, 0xcedd4ee3, 0x62aef9fb, 0x4296c2ad, 0xb99e95fb, 0x8c44d9bb, 0x40c51a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fe200,
        block_height: 2032,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501213200, 1501213800, 1501214400, 1501215000, 1501215600, 1501216200, 1501216800, 1501217400, 1501218000, 1501218600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2033,
        block_hash: [0x8ed5f34d, 0x161d0fad, 0xb74ee977, 0x281279e6, 0xcba39302, 0x0a49a230, 0x9236fd43, 0xc1522e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fe400,
        block_height: 2033,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501213800, 1501214400, 1501215000, 1501215600, 1501216200, 1501216800, 1501217400, 1501218000, 1501218600, 1501219200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2034,
        block_hash: [0xe234cf2e, 0x16e50596, 0x7e0bd958, 0x775168c1, 0x79e50796, 0xed1bfca9, 0xec695cc9, 0xe4785a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fe600,
        block_height: 2034,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501214400, 1501215000, 1501215600, 1501216200, 1501216800, 1501217400, 1501218000, 1501218600, 1501219200, 1501219800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2035,
        block_hash: [0x780e59e9, 0x57785b7c, 0x6462930a, 0x376c1353, 0xf0a8c13d, 0xb6e5d74b, 0x6ffcd549, 0xac363800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fe800,
        block_height: 2035,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501215000, 1501215600, 1501216200, 1501216800, 1501217400, 1501218000, 1501218600, 1501219200, 1501219800, 1501220400]
    },
];
