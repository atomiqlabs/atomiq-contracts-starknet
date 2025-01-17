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
    merkle_root: [0xab1f14fd, 0x64fd4635, 0x1f686a8f, 0xcafe5d1c, 0xba38a73c, 0x9d50f6f0, 0x4ebae62d, 0x79ce5712],
    reversed_timestamp: 0x21947959,
    nbits: 0xffff7f1f,
    nonce: 0x000005a5
};
const BLOCKHEADER_1902: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa7faddeb, 0x2dd79abb, 0xe27f3acd, 0x6897e161, 0x378a526c, 0x4bf718ab, 0x45eed7d3, 0x232a5000],
    merkle_root: [0x60ac5908, 0x9d94990b, 0x0a13fe0f, 0x37038186, 0xda6595f9, 0xf4cb408a, 0xbd195f3a, 0x04ae788f],
    reversed_timestamp: 0x22947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000078c
};
const BLOCKHEADER_1903: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x02230b43, 0xece00e11, 0x6fcc6b7e, 0x4e6c448d, 0x0d559ae5, 0xa8da724d, 0xdb39f203, 0x2ab07400],
    merkle_root: [0x580eee22, 0xea18314d, 0x2bf37f9a, 0xcd968ad9, 0x6359dd44, 0xbc5fa409, 0x61fec3cb, 0xda6cb9b1],
    reversed_timestamp: 0x23947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000373
};
const BLOCKHEADER_1904: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x81684f1a, 0xf6e5b880, 0xd5de8549, 0x452d66fd, 0xf7ea1ae0, 0x623c23c8, 0xdcd4e668, 0x5cb56c00],
    merkle_root: [0x4be00727, 0x0eb17bcc, 0x32719494, 0x0b412860, 0x3fed8eb2, 0x6bbc8733, 0xb14d1029, 0xb6575ced],
    reversed_timestamp: 0x24947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000407
};
const BLOCKHEADER_1905: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf3582d9c, 0xf07f8e70, 0x7ea30466, 0x37176ad7, 0x54677db0, 0xe764f685, 0xb34c53cb, 0x0aab6f00],
    merkle_root: [0x00d9022f, 0x762e6bee, 0xa00056cc, 0x59d23131, 0xdb540a67, 0x2f7a4bb4, 0x0077f969, 0xf1f1c116],
    reversed_timestamp: 0x25947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000802
};
const BLOCKHEADER_1906: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x70f468f0, 0xec111cf9, 0x5a802687, 0x4963c93d, 0xd9153c32, 0x07320f2b, 0xe75e3007, 0xb9206400],
    merkle_root: [0x400aed21, 0xbe2f4053, 0x2e5bd47d, 0x362342df, 0x28c6e880, 0x3aade5ff, 0xe7738f81, 0x06f0559f],
    reversed_timestamp: 0x26947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000009a
};
const BLOCKHEADER_1907: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5dee0da7, 0x04429769, 0x78acca39, 0x106dafda, 0x2de0c56a, 0xc34e0eee, 0x6ac213e4, 0x7e642c00],
    merkle_root: [0xb0114305, 0xd7357a14, 0x30eb992d, 0xd121d370, 0x1d292f7c, 0xe857664c, 0x9e0a4409, 0x6e9133ee],
    reversed_timestamp: 0x27947959,
    nbits: 0xffff7f1f,
    nonce: 0x000005a3
};
const BLOCKHEADER_1908: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9c8389ae, 0x77f33384, 0xe50041f2, 0xcdb48701, 0x9dc08ee3, 0x42871fc4, 0x13d04a3c, 0x70503800],
    merkle_root: [0xf3c42b94, 0xfe343965, 0x89d689a4, 0xe58f4309, 0x929f1a17, 0x28c9bb3a, 0x725d0d09, 0x9172f699],
    reversed_timestamp: 0x28947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000190
};
const BLOCKHEADER_1909: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4c3afdd9, 0x88b95338, 0x2eb90a3c, 0x9ff35682, 0x57768bc4, 0x2d9d528e, 0xa00efa68, 0x8a7e0a00],
    merkle_root: [0x60efe53e, 0x9b90d0fd, 0x5062acac, 0x0e7c9d30, 0x67a03fe0, 0xd4ccc2e1, 0x4ed47cd1, 0xe513116f],
    reversed_timestamp: 0x29947959,
    nbits: 0xffff7f1f,
    nonce: 0x000001db
};
const BLOCKHEADER_1910: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5627620e, 0x549008c8, 0x340f336e, 0xf14d6d18, 0x44cd505b, 0x6e148b28, 0xd1e0347e, 0x5a6d1100],
    merkle_root: [0xaa26e53e, 0x6a72d94d, 0x79ce6c32, 0x3d415360, 0xbd7125b9, 0x4a0fcbaf, 0x5488d6a2, 0xc7e9a1e2],
    reversed_timestamp: 0x2a947959,
    nbits: 0xffff7f1f,
    nonce: 0x000001db
};
const BLOCKHEADER_1911: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x461bb7a5, 0xc227a15f, 0xd5cb61b7, 0x2bb863bd, 0x2994b830, 0xe069f04e, 0x6efbe455, 0x65026d00],
    merkle_root: [0xd5d65d45, 0x5370125f, 0x14abea0e, 0x08359166, 0x17b0b0cb, 0xad5dccea, 0xe9355802, 0x42d7ad35],
    reversed_timestamp: 0x2b947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000078
};
const BLOCKHEADER_1912: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5575a948, 0x86406f4b, 0xeb4a204c, 0xb7e73e62, 0x004d6c25, 0x505100c4, 0xa4cb0bf8, 0xb04d7c00],
    merkle_root: [0x91d1e982, 0xefa500cd, 0x6abbaf89, 0x27f9c818, 0x035d8e95, 0x5844f6af, 0xe5646172, 0xbc67d071],
    reversed_timestamp: 0x2c947959,
    nbits: 0xffff7f1f,
    nonce: 0x000000ac
};
const BLOCKHEADER_1913: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x04bee7b3, 0x165ef22b, 0xb0d5905a, 0xad2212ca, 0xc0c62912, 0xeac0a6ca, 0x80253e3c, 0xf0d41c00],
    merkle_root: [0x55b2d825, 0xacbafebc, 0xc9992b0c, 0x33138254, 0x145d4d2e, 0x1f473482, 0xb61b0929, 0x3b7c0971],
    reversed_timestamp: 0x2d947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000017b
};
const BLOCKHEADER_1914: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xfb828206, 0xc674c3f3, 0x617e43b7, 0x3e15d2e5, 0x1fb603e3, 0xba5bbf3c, 0x59d3a272, 0x17a51100],
    merkle_root: [0xb3a55d43, 0x403b682e, 0x800a823d, 0x29b7b130, 0x4fad30a5, 0x5b0fe43b, 0x12224dbd, 0x78db43ce],
    reversed_timestamp: 0x2e947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000444
};
const BLOCKHEADER_1915: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc34c2396, 0x538d3139, 0x45c455a9, 0xe465eb78, 0x0e0ff435, 0x0c1a43b3, 0xe3df2ff2, 0x0e3d0400],
    merkle_root: [0x7d2ac533, 0x1d7e34e3, 0x0de7cf3c, 0x48510d1d, 0xddfbd2a4, 0x1e79f337, 0x3a6784d6, 0xd07d24c8],
    reversed_timestamp: 0x2f947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000009b
};
const BLOCKHEADER_1916: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xda97e267, 0x0222abe0, 0x63c1ed0a, 0xb64c69b4, 0xe1108eeb, 0x17f4d6b9, 0x2bcb858d, 0xb1074f00],
    merkle_root: [0x75144cf8, 0x097e864d, 0x460d4942, 0xa8ff7ae7, 0x575fd580, 0xcbfc3670, 0x3be41e36, 0x582b44f1],
    reversed_timestamp: 0x30947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000021
};
const BLOCKHEADER_1917: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1c030fac, 0x4dda76d3, 0x6e2ad18b, 0x0a40fb61, 0xa152ec45, 0x18b7e32b, 0x35cd2d81, 0x9f311b00],
    merkle_root: [0x5a4a9612, 0xf5855ddb, 0xf5e09577, 0x10e09150, 0xb7abfa4c, 0x928cf307, 0xa5de0686, 0x9b572e4b],
    reversed_timestamp: 0x31947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000438
};
const BLOCKHEADER_1918: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb8b970d3, 0x23278a78, 0xc153fc6b, 0x2c61aabe, 0x169c9b33, 0xdb360e93, 0x9886f9c7, 0x3a371100],
    merkle_root: [0x68710375, 0xcfc8bb7c, 0xd58c1f78, 0xb9068784, 0x2e8da453, 0xd10bf7c4, 0x34632b07, 0x16f29465],
    reversed_timestamp: 0x32947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000016a
};
const BLOCKHEADER_1919: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xeac372af, 0xc51dc283, 0x4bf2188d, 0xee59b264, 0x8b5f2a17, 0x8b30619a, 0xdb4d5802, 0xb7da1a00],
    merkle_root: [0x85ded91c, 0xb26a795a, 0xb6de473d, 0xcf327746, 0xcef3ecb3, 0x384e5d2e, 0x110a3dc3, 0x43e8f49c],
    reversed_timestamp: 0x33947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000000d
};
const BLOCKHEADER_1920: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf5720820, 0x62a15009, 0xee74d589, 0xf07ca358, 0x35195e33, 0x0c21ca7e, 0x20cc25c8, 0x11877600],
    merkle_root: [0x19eb698b, 0xd012cb09, 0xcac646e2, 0xc5d6ea0a, 0x67b6a7f4, 0xe42413a0, 0xa6405974, 0xf4e4940b],
    reversed_timestamp: 0x34947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000259
};
const BLOCKHEADER_1921: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x65c93a03, 0x70220a11, 0xfb4b70e4, 0xf81f6c95, 0x5fa70e44, 0x028133b5, 0x1fdc2363, 0x637a3100],
    merkle_root: [0x064a3dba, 0x27367307, 0x3fdc55bb, 0x24f2901d, 0x7e4bb0cf, 0xa60fd654, 0xc2c09d43, 0x4dea0c41],
    reversed_timestamp: 0x35947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000279
};
const BLOCKHEADER_1922: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb180c1b3, 0x346a4631, 0x3cf96a4f, 0x42f4d685, 0x8f733bf9, 0x15c527a0, 0xdc5d866c, 0xe57f0900],
    merkle_root: [0xb33c4624, 0xd2b4aed5, 0x6df4253d, 0xbeedc5ab, 0x46baf5c2, 0x35f66189, 0xd3cec173, 0x8c74583e],
    reversed_timestamp: 0x36947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000036
};
const BLOCKHEADER_1923: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x55637c57, 0x49933364, 0xc39786ab, 0x83f1f9ef, 0x59407e51, 0x14b5b18a, 0x4616e8cb, 0x85652c00],
    merkle_root: [0xde844faf, 0xcd4a2d09, 0xf65cea1c, 0x52e1ab59, 0xb3b6c836, 0xf3d7ad6f, 0xcdd25457, 0x18c61148],
    reversed_timestamp: 0x37947959,
    nbits: 0xffff7f1f,
    nonce: 0x000004af
};
const BLOCKHEADER_1924: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3a1b7dff, 0x83b0b1b4, 0x423e7d12, 0x1d8daca2, 0xcc38125f, 0x836a6060, 0xf230b679, 0x45fd6000],
    merkle_root: [0x6be3570c, 0x1a66832d, 0x028a6281, 0xea929fda, 0xdda0c08e, 0x23b3aaf6, 0xc8274c10, 0x197db3ce],
    reversed_timestamp: 0x38947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000495
};
const BLOCKHEADER_1925: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa2b8cff8, 0x24769896, 0x3db654d5, 0x10e1ff0a, 0xa2eae614, 0xb6e9a659, 0xc2979ce5, 0x56a72200],
    merkle_root: [0x749e5d39, 0xd57056fd, 0x19bb6587, 0xb190f56b, 0x649c1a0a, 0x277002c0, 0xddd96678, 0x5c4d9e38],
    reversed_timestamp: 0x39947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000042
};
const BLOCKHEADER_1926: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x12451adf, 0x814592c4, 0x7a84bad5, 0xd04ba704, 0xdbc830ad, 0x8ef55c23, 0xb6bdede1, 0x6dfc2000],
    merkle_root: [0x0a285a1b, 0x9c441abe, 0x9766671f, 0xe02059c4, 0x8f7cea24, 0x80160e54, 0xf9eb7755, 0x03662746],
    reversed_timestamp: 0x3a947959,
    nbits: 0xffff7f1f,
    nonce: 0x000005a5
};
const BLOCKHEADER_1927: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2240e4ab, 0x92e87e76, 0x7b683604, 0x1d142f73, 0x5aa99c87, 0x4947d356, 0x802570c4, 0xc0ee1200],
    merkle_root: [0x70c4bef8, 0xe2435398, 0x4b603de2, 0xfa1125be, 0xb23fd205, 0x761ee7c3, 0xa902f2e8, 0x8765bb24],
    reversed_timestamp: 0x3b947959,
    nbits: 0xffff7f1f,
    nonce: 0x000003f1
};
const BLOCKHEADER_1928: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9dfc9ad1, 0xaa43ea01, 0x2dfe621b, 0xd0f3ad29, 0xe2bf484a, 0xce195012, 0x14ada066, 0xfefc0b00],
    merkle_root: [0x9348fa40, 0xf1bb78af, 0xdc77f93b, 0x694deb81, 0xbbe59d45, 0x14257544, 0x4e2ca110, 0x829d49c9],
    reversed_timestamp: 0x3c947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000106
};
const BLOCKHEADER_1929: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4d500f88, 0xc606b31d, 0xcd6b6e29, 0xc3e395c7, 0x61eaf744, 0x24dc09d5, 0xbe2c4022, 0xfdcc7500],
    merkle_root: [0xa8ce4f25, 0x2d1b47de, 0xe5dab31b, 0x504f4005, 0x6696fac1, 0x71f25eac, 0x6c5853d1, 0x45e5e53c],
    reversed_timestamp: 0x3d947959,
    nbits: 0xffff7f1f,
    nonce: 0x000002ac
};
const BLOCKHEADER_1930: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc7bec8c6, 0x44bf3b79, 0xe455100e, 0xae450346, 0x71af4da5, 0xd560ed80, 0xc24d9475, 0xfab82b00],
    merkle_root: [0xb591e0d4, 0x52d6ac3f, 0x4501c93e, 0xdde4d27a, 0x8dc444d4, 0x8aa2266b, 0xc1a02354, 0x3fcf4c7a],
    reversed_timestamp: 0x3e947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000282
};
const BLOCKHEADER_1931: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7c3d6526, 0xcf5b927e, 0x6efd7294, 0xa4258afd, 0x62c240ed, 0x9f772bae, 0xa78f5f44, 0x95331900],
    merkle_root: [0xee27a8e4, 0x3d4f73c1, 0x2da3b4d8, 0xa0d447a7, 0x50d2a93e, 0xa44f6ff2, 0x6c6c3bd9, 0x789f592a],
    reversed_timestamp: 0x3f947959,
    nbits: 0xffff7f1f,
    nonce: 0x000001ad
};
const BLOCKHEADER_1932: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x544c8ef3, 0xd62c3872, 0xcb3a8521, 0x7aee9fe6, 0xb5907407, 0x4f8d7b54, 0x48e540ab, 0x6c286500],
    merkle_root: [0x28339ef3, 0xe019ce94, 0xbbc99e3c, 0x72cbdd56, 0x30b823dc, 0x33f2903f, 0x59f38361, 0xc5d44784],
    reversed_timestamp: 0x40947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000621
};
const BLOCKHEADER_1933: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9cb09c56, 0x03e72561, 0xc07c90d4, 0x12a75369, 0xf9201b37, 0xa9953b10, 0x1a7f9941, 0x5e007400],
    merkle_root: [0x8c4bd08d, 0x3e92c333, 0x610d1c2a, 0x297bb270, 0x9b0e7b87, 0xd54fc2fd, 0xa47e1621, 0x8771e554],
    reversed_timestamp: 0x41947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000186
};
const BLOCKHEADER_1934: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3b16052f, 0x4ebbdfad, 0x81d08e06, 0x874ac6de, 0x4ccd51cf, 0x7d26ff0f, 0xffc9f3cc, 0xa42c0e00],
    merkle_root: [0x49beef02, 0x09182fe8, 0x5fef3798, 0xc7af55c8, 0x6833940b, 0x8c6d6852, 0xbfcd61a2, 0x5af92fa4],
    reversed_timestamp: 0x42947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000008e
};
const BLOCKHEADER_1935: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8e98cbb2, 0x42af6e9e, 0x68d1fc9d, 0x885342d5, 0x39c0b56c, 0x7c9eabd5, 0xfabcd11e, 0x6e960d00],
    merkle_root: [0x8b69694f, 0x3dc7476a, 0x4e02369c, 0x11b53fbc, 0xe585e922, 0x9b847606, 0xba55bb5c, 0xa441673e],
    reversed_timestamp: 0x43947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000034
};
const BLOCKHEADER_1936: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xbd5cc918, 0xb5239ae7, 0x768dd132, 0xcbcb7e26, 0xd9b4a458, 0x98ea3dd6, 0x29f57813, 0x4cfd1400],
    merkle_root: [0x78f259d0, 0x95414fb4, 0xbc2555c9, 0x56a8a754, 0x2f727dda, 0x70c5be6e, 0x6762f9cf, 0x99db035d],
    reversed_timestamp: 0x44947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000007e
};
const BLOCKHEADER_1937: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xdf6194e9, 0xa650ea6a, 0x05fb1fdd, 0x75c49cc0, 0x250d1181, 0xf1e8668d, 0x069fb803, 0x35b90a00],
    merkle_root: [0xc98dc06b, 0x669b77c9, 0x5daea985, 0x0cd16117, 0x81d93cf3, 0x830e3faa, 0xfc368c5e, 0xecccc5ce],
    reversed_timestamp: 0x45947959,
    nbits: 0xffff7f1f,
    nonce: 0x000001e3
};
const BLOCKHEADER_1938: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x035797b8, 0x4abd7c73, 0x58cb21cc, 0x7649c51c, 0x8579ab44, 0xaa8f9617, 0x3be10c52, 0x2d714800],
    merkle_root: [0x05345edd, 0x7481710c, 0x36b39bd4, 0x5c593164, 0x34d9ef6a, 0x80205060, 0xfb9abd41, 0x73705021],
    reversed_timestamp: 0x46947959,
    nbits: 0xffff7f1f,
    nonce: 0x000001c4
};
const BLOCKHEADER_1939: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x21cb2561, 0xe2d05277, 0x18a1e62f, 0x67e615e4, 0xcc1f8e66, 0xfdf0a639, 0x7889a667, 0x97006f00],
    merkle_root: [0x12e2c9cf, 0x2cb1d50e, 0xd10a755b, 0x1887d13e, 0x5a5a4e2f, 0x1ae7d55e, 0xb6b49309, 0xabd81244],
    reversed_timestamp: 0x47947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000011
};
const BLOCKHEADER_1940: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x14fbec1c, 0xf09b83d8, 0xb4127d92, 0x2baadbd2, 0x5fb3bde7, 0x9e207c50, 0x6433f5fd, 0x36535f00],
    merkle_root: [0xb50c748c, 0x282f8346, 0x70a55e35, 0x3bf97505, 0x0cea55bc, 0x4de5d77f, 0x0ecfd04c, 0x900d27c0],
    reversed_timestamp: 0x48947959,
    nbits: 0xffff7f1f,
    nonce: 0x000003f1
};
const BLOCKHEADER_1941: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x96fbb089, 0x7f81a6ba, 0xb8195e8a, 0x8bea39d5, 0xe491d3db, 0x4527b250, 0xf55c903a, 0x3f4f0a00],
    merkle_root: [0x6468072a, 0x2c16dc9a, 0xe86997fe, 0xc9257a46, 0x1211638e, 0xfd8667fd, 0xd8af9fcd, 0xdbb4ef8f],
    reversed_timestamp: 0x49947959,
    nbits: 0xffff7f1f,
    nonce: 0x000004bb
};
const BLOCKHEADER_1942: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5790f7f2, 0xf3dac1e9, 0x2887cec7, 0x5d6983dd, 0x9de79894, 0xcea910fa, 0x0d6a0b75, 0x9a735f00],
    merkle_root: [0x042d9a83, 0xdaa60d0f, 0x0faf912a, 0xbc312abf, 0xd627cc91, 0x41d0a30c, 0xc505d7f9, 0x6c52b054],
    reversed_timestamp: 0x4a947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000020f
};
const BLOCKHEADER_1943: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x16b48b01, 0x361ebe7c, 0x29510857, 0x29a8933c, 0xd925947e, 0x7e423806, 0xf90c218c, 0xa0793000],
    merkle_root: [0x372759fe, 0x7644c894, 0x20319d23, 0x3a01c397, 0x759da648, 0x93bdfb0c, 0x7aa1a78a, 0xb1aaca1b],
    reversed_timestamp: 0x4b947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000001a
};
const BLOCKHEADER_1944: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5e4b4814, 0xe3fcdf5a, 0xfb88bb12, 0xf0c464c5, 0x4438ca56, 0x043d20e9, 0xc4abff03, 0xc8fd1700],
    merkle_root: [0xad70cc52, 0xc1a89888, 0xed657196, 0x86ea9ba0, 0x5d8707ff, 0x22a079d7, 0x07373a31, 0x738df40a],
    reversed_timestamp: 0x4c947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000260
};
const BLOCKHEADER_1945: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x682a1a98, 0xe3baabf8, 0xaa8c34e5, 0xf1a866b5, 0x13fd4d1b, 0x4b55f521, 0x577034f9, 0x74e11e00],
    merkle_root: [0xdc02865b, 0x334c6566, 0xc2cbfb10, 0x694e1553, 0x365ba3d2, 0x23f20926, 0xa9de6539, 0x61e9fcd6],
    reversed_timestamp: 0x4d947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000041d
};
const BLOCKHEADER_1946: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x53e53b17, 0x7110ae69, 0xa40b4217, 0x8fda9537, 0x8446ad17, 0xb40ac060, 0x2ad94aca, 0xc12b2400],
    merkle_root: [0x50d4c13c, 0x0faf64d1, 0x26a0dec5, 0xe564d4c7, 0x0f479c44, 0x14ea9519, 0xaf06f899, 0x383750f8],
    reversed_timestamp: 0x4e947959,
    nbits: 0xffff7f1f,
    nonce: 0x000002b3
};
const BLOCKHEADER_1947: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x0b331556, 0x5892daa8, 0xfe55c1b2, 0x43193280, 0xb5539c2f, 0x461ac330, 0x020e41ae, 0x17026a00],
    merkle_root: [0xa9a87bd1, 0xdc81e192, 0xc488871f, 0xf7a06b0e, 0xf1e21e76, 0x5b77e10c, 0x6f6fe297, 0x21ee3bd1],
    reversed_timestamp: 0x4f947959,
    nbits: 0xffff7f1f,
    nonce: 0x000001ad
};
const BLOCKHEADER_1948: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xaffd74f6, 0x3695a04a, 0x69a7fef9, 0xde2e7a84, 0xa868aed3, 0xaf0cde97, 0xc6ccc0ea, 0xeb7c6a00],
    merkle_root: [0x6811163b, 0x35af0c91, 0x9e0b4a7b, 0x7f074dd0, 0x08017c8b, 0x2aa7a6f3, 0x8f939d4c, 0x56cfb585],
    reversed_timestamp: 0x50947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000074
};
const BLOCKHEADER_1949: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x08c89e17, 0xdc7de220, 0x224c2cab, 0x5b6a9638, 0x1bf7edf4, 0xad1f2c3a, 0x417a08b2, 0x1d7b1000],
    merkle_root: [0x2236bc2f, 0xbe25ddcf, 0xe8961e08, 0x88e86032, 0xdf8b9473, 0xc86cd4f5, 0x1f2c9aa4, 0x5c361975],
    reversed_timestamp: 0x51947959,
    nbits: 0xffff7f1f,
    nonce: 0x000001e1
};
const BLOCKHEADER_1950: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9e3b52f5, 0xcebe5c28, 0x31f24b19, 0xc7e4dd44, 0x4ff8e0c8, 0x160dacf6, 0x0ca5cbf8, 0xcf5f0500],
    merkle_root: [0xb00d3c0d, 0x57d1c88c, 0x7dfbce61, 0xb828efd1, 0x9be0b034, 0xa593920f, 0x85d80807, 0x9eaf8727],
    reversed_timestamp: 0x52947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000371
};
const BLOCKHEADER_1951: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x0301dcae, 0xde833b6c, 0xd3ac8826, 0x7ab1edcc, 0x4cd8c9c7, 0x86dc5b0a, 0x35ec15d8, 0x19481200],
    merkle_root: [0xab890be2, 0x03e48ef8, 0x4af314f0, 0xa8e3f431, 0x06f33915, 0xb91d89c2, 0xee5ee3c9, 0x0d4c8601],
    reversed_timestamp: 0x53947959,
    nbits: 0xffff7f1f,
    nonce: 0x000001e7
};
const BLOCKHEADER_1952: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5c155301, 0xabc3ed59, 0x1f47492f, 0xa3c03c11, 0x3f2f8af5, 0x14aff319, 0x6ec55d15, 0x994c6a00],
    merkle_root: [0xf80aca8b, 0x713e3f1a, 0x3143a78d, 0xd47a1a16, 0x0e0c9b8d, 0xbd74c586, 0x9faf32f0, 0x7109edb1],
    reversed_timestamp: 0x54947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000019a
};
const BLOCKHEADER_1953: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7d886c43, 0x64fdc6e3, 0x1729b15e, 0x303b15a4, 0x7ea8889c, 0xff73ee71, 0xfcbe158b, 0x0b416d00],
    merkle_root: [0x8edcdb64, 0xd1abf3eb, 0x154e4c2c, 0x13cf55d7, 0x8182565d, 0xc207088f, 0x90da579e, 0x42e20343],
    reversed_timestamp: 0x55947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000012a
};
const BLOCKHEADER_1954: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc7dfcd9d, 0x08c4c047, 0x99252bb4, 0xef7d7e29, 0x17626a81, 0xbe2c8eb0, 0x94abc6d2, 0x755c7900],
    merkle_root: [0x0ce2a52d, 0xf6d176e4, 0x3e9ecfa5, 0x7607d08f, 0xbe595cf9, 0x1ffad1bd, 0x034b7247, 0xcfdf5fcf],
    reversed_timestamp: 0x56947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000770
};
const BLOCKHEADER_1955: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2fc653c2, 0xdcadc395, 0x645bef40, 0xd7a64929, 0x19b97b47, 0xbae3b611, 0x8e2ee8d6, 0x3df26800],
    merkle_root: [0xfb8d9840, 0xbfab6b81, 0xf2d5bf80, 0xb7642b76, 0xe4d28dfc, 0x8172d238, 0x2684d0a6, 0x2f56c751],
    reversed_timestamp: 0x57947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000019d
};
const BLOCKHEADER_1956: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9368e7a5, 0x6526d53a, 0xfec6d8fd, 0x5c8c3964, 0x8455536b, 0x1cc9adf8, 0x19953b18, 0xdc3a3a00],
    merkle_root: [0x85da59d6, 0x148b5182, 0x4bfd87f5, 0x12e21af0, 0x2c4b4034, 0xa5d778fb, 0xb3debb68, 0xc835f784],
    reversed_timestamp: 0x58947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000010
};
const BLOCKHEADER_1957: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd45651b1, 0xa58defe1, 0xd143f878, 0xd160e9d5, 0x907cb653, 0x51c6d5db, 0x6d43eb13, 0x29632b00],
    merkle_root: [0x71334d42, 0x0ee605ac, 0x6a79cddc, 0x7d3c3555, 0x7754d61c, 0x82965af9, 0xd9c930cc, 0x62079f7b],
    reversed_timestamp: 0x59947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000462
};
const BLOCKHEADER_1958: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x63c5d5cd, 0x9a3cdd12, 0xbdc3de9c, 0x0618e38e, 0x7d3d20be, 0x5e1e0f7e, 0xfabd262d, 0x2e271800],
    merkle_root: [0xf21b4a6c, 0x2c01c402, 0x54173e3a, 0x2d1cf1b5, 0xb91e45c4, 0xb6da724a, 0x5c14eb9d, 0x2ecb50a7],
    reversed_timestamp: 0x5a947959,
    nbits: 0xffff7f1f,
    nonce: 0x000002c5
};
const BLOCKHEADER_1959: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x58bb2e19, 0x24870a15, 0x3728f19c, 0x8188787b, 0x84bc5838, 0x5c510a8e, 0xa282316c, 0x49983000],
    merkle_root: [0x4970abf9, 0xaba22c02, 0xa00dac85, 0x3f2cfec4, 0xbabf6b06, 0xc98cc2e7, 0x7af8c01d, 0x389b2eab],
    reversed_timestamp: 0x5b947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000005e
};
const BLOCKHEADER_1960: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb4a6d257, 0xc1550b8f, 0xdb7c86bb, 0x171954d9, 0x6ab0824c, 0xd703586f, 0x960cbd54, 0xb4e77b00],
    merkle_root: [0xf5f4a774, 0xe00f84d6, 0x3d1005a6, 0x2c8984ba, 0x9176811e, 0x7051332a, 0xdf1ec9de, 0xcc3b088b],
    reversed_timestamp: 0x5c947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000090
};
const BLOCKHEADER_1961: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x698fd83d, 0x319cf2b1, 0x39895e64, 0x593f837e, 0x0dd6fc09, 0x943e89e3, 0x728efcb7, 0x58366c00],
    merkle_root: [0x2107c321, 0xf0447835, 0xa70c8748, 0xf6f2118c, 0xebfc195b, 0x533fad46, 0x62cf2a13, 0xaca05a0d],
    reversed_timestamp: 0x5d947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000004c
};
const BLOCKHEADER_1962: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x431864e6, 0x6cbff18f, 0x01c7a37a, 0x253063b9, 0x0ebbfeaa, 0x440a4892, 0x7eb25f87, 0x17f27500],
    merkle_root: [0x4f405a74, 0x1f353eb6, 0x80775565, 0x974d59d9, 0x37a6ec75, 0x676157b5, 0x0b3c6561, 0x1f9704e2],
    reversed_timestamp: 0x5e947959,
    nbits: 0xffff7f1f,
    nonce: 0x000001b4
};
const BLOCKHEADER_1963: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xddeeffce, 0x6ac75164, 0x50a29844, 0x59670938, 0x63c95ce3, 0x420b9209, 0x01c44e82, 0xf39c2b00],
    merkle_root: [0xa6289dc8, 0x34c3245a, 0x4d9e8dc6, 0x85453868, 0xf5887b2b, 0x1aadb70f, 0xef611510, 0xbb3a463a],
    reversed_timestamp: 0x5f947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000017
};
const BLOCKHEADER_1964: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xfae31133, 0xed920d22, 0x9bcc3868, 0x7461d47e, 0x538a6ac8, 0x9f6646c7, 0x20d615c0, 0x5ed15400],
    merkle_root: [0xcd1cd781, 0x9b755ed9, 0xa716abf3, 0x7692e42e, 0x301526bf, 0x3dc902e3, 0x5871b5e8, 0x50861076],
    reversed_timestamp: 0x60947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000016f
};
const BLOCKHEADER_1965: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc137822c, 0x542997cf, 0x04bc91ad, 0x92586aa6, 0x25561d0b, 0x068144b3, 0xc373b186, 0x9fd37700],
    merkle_root: [0x30a3d373, 0x1066f265, 0xfdbcc621, 0x83c2a271, 0xe1b620d1, 0xd0a7cf37, 0x42eae6f0, 0xebcfa8bb],
    reversed_timestamp: 0x61947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000027e
};
const BLOCKHEADER_1966: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xefc50ba8, 0xab1e8d3c, 0x8f966b63, 0x87b79f38, 0xc0fa8314, 0x1455a100, 0x5a4f8a99, 0x17792000],
    merkle_root: [0x91924df5, 0xe2852545, 0x0df42eee, 0xca90da15, 0x01f4f0c8, 0x0f6e9849, 0xedbb4efa, 0x7efc6232],
    reversed_timestamp: 0x62947959,
    nbits: 0xffff7f1f,
    nonce: 0x000000e2
};
const BLOCKHEADER_1967: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa3bec3a1, 0x810031cb, 0x9a523dc9, 0xc781e5eb, 0x087816fd, 0xa0d73fd4, 0x945180d0, 0x84746c00],
    merkle_root: [0xf48e54c0, 0x3f83eef9, 0x3b17a388, 0xccaa47a2, 0x1ccbb3f3, 0xafb4e5e7, 0xeea9b705, 0x9a7c5045],
    reversed_timestamp: 0x63947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000014c
};
const BLOCKHEADER_1968: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf9c84d22, 0x256f7bbd, 0x73dfb6bc, 0xf2307c85, 0x8c96b835, 0x926543d8, 0xd4297476, 0x56201f00],
    merkle_root: [0xdff0bff9, 0x819b7b82, 0x65b31d94, 0x4c0375ca, 0xbbbbcbee, 0xcc53c6f0, 0x6f60a741, 0xf3c945b4],
    reversed_timestamp: 0x64947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000038
};
const BLOCKHEADER_1969: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4f49d55b, 0x4331e7d7, 0x3c3bd019, 0x4bee7798, 0xa48f1c91, 0xd1f04f43, 0x30a060a0, 0x001c0300],
    merkle_root: [0xe2ffae3a, 0xd3ec92be, 0x7fae393b, 0xb2e3fead, 0x3af4e060, 0x9910d816, 0xc7c8b68c, 0xb38c68ac],
    reversed_timestamp: 0x65947959,
    nbits: 0xffff7f1f,
    nonce: 0x000000fd
};
const BLOCKHEADER_1970: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xcf7540d5, 0xfaf93163, 0xc03e0d2b, 0x8c0fe65c, 0xa6c18841, 0x2133ae70, 0xcf19b380, 0x5a7a2800],
    merkle_root: [0xb509164f, 0x5449621f, 0xcdc86aff, 0x65572ee6, 0x8dce73a2, 0xaef48068, 0xf1ac0aef, 0x775533c7],
    reversed_timestamp: 0x66947959,
    nbits: 0xffff7f1f,
    nonce: 0x000000f4
};
const BLOCKHEADER_1971: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7155c194, 0x3bedbea2, 0xbb5968fe, 0x48f54914, 0xdbb8a1e5, 0xa270d7c5, 0xdff36614, 0xc35f1f00],
    merkle_root: [0x6f217642, 0x531a4966, 0xa8f00080, 0xc0d66c94, 0x25583500, 0x2f731eef, 0xd505c155, 0xcb272c77],
    reversed_timestamp: 0x67947959,
    nbits: 0xffff7f1f,
    nonce: 0x000003f5
};
const BLOCKHEADER_1972: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4aac6ebf, 0x81369f17, 0x16916797, 0xdaac4275, 0xad454e65, 0x82fdd7d3, 0xf175255d, 0x8ea05f00],
    merkle_root: [0xb306dac0, 0x75c6d867, 0x513c2534, 0x39e60e51, 0xc017d8d7, 0x4e3aaaef, 0x24e90497, 0x7382374b],
    reversed_timestamp: 0x68947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000400
};
const BLOCKHEADER_1973: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x862a6c96, 0x1b6cd19f, 0x26e32334, 0xde0265ea, 0x83cac387, 0x5198256b, 0x2c13ffe2, 0x348b5400],
    merkle_root: [0xe7a30dba, 0x28ae61fe, 0xadf7b3b7, 0x1103e2c9, 0xc70f8688, 0xc7a5ccac, 0xbb3af4b0, 0x128fcab6],
    reversed_timestamp: 0x69947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000016e
};
const BLOCKHEADER_1974: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x915a1607, 0x6d62386b, 0xa937aeba, 0x0c022f04, 0x24afd43a, 0x9eb49563, 0xf5f76af7, 0x04536100],
    merkle_root: [0xbed96093, 0x87d4b856, 0x715225e1, 0x7aec753a, 0x2b7b972e, 0xf174bff8, 0x95e17416, 0xae09ec34],
    reversed_timestamp: 0x6a947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000179
};
const BLOCKHEADER_1975: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x311c5d24, 0x502874ab, 0x5b5f99f6, 0xf3112aad, 0x170e7bc0, 0xe4b5012b, 0x16e713df, 0x7f127200],
    merkle_root: [0x3af787ff, 0xd527d562, 0x8fb1c6a9, 0x15c78df5, 0xea1fc162, 0x3cebd52f, 0xa6d4134d, 0x02dbdb25],
    reversed_timestamp: 0x6b947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000045
};
const BLOCKHEADER_1976: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xcc744cc1, 0x656ccfd6, 0x8d903327, 0x974ed6e5, 0x03d41815, 0xe7adfb19, 0xb5a13d9a, 0xe9ba5300],
    merkle_root: [0xee2c0b8a, 0x659ae020, 0x10799e9a, 0x4da60920, 0xc18ba27b, 0x711fd005, 0x0889c679, 0xb6e9d348],
    reversed_timestamp: 0x6c947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000004c
};
const BLOCKHEADER_1977: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x57b311d3, 0xf13738da, 0x2cfde58b, 0x7f5171b2, 0x54aa2014, 0xa6fc2202, 0xd1340d73, 0x21cf4700],
    merkle_root: [0xa4892cc0, 0x456958c8, 0x24b19c99, 0x467cbdb8, 0x06f8115d, 0x936e37f1, 0xabd7acf6, 0x448f8f04],
    reversed_timestamp: 0x6d947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000042e
};
const BLOCKHEADER_1978: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe4e6a189, 0xdb0f8042, 0x6bf9c6fe, 0x92d6b119, 0x4645f629, 0xd87f53da, 0xb3f0376d, 0x1cce0200],
    merkle_root: [0x443915a6, 0x3541c1f8, 0x7d5b4610, 0x6fc79771, 0x2aca531a, 0x287e7800, 0x58df534c, 0xaf577b18],
    reversed_timestamp: 0x6e947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000007b
};
const BLOCKHEADER_1979: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4c983ae4, 0xf7dc20ba, 0x6c0147cb, 0xcb0c2e44, 0xafde2a3f, 0x08f8c9c6, 0x74f00c50, 0x9f3a7f00],
    merkle_root: [0x769cb6a7, 0xf172234d, 0xc20a884c, 0x532d56bc, 0x2dbad81b, 0x21988671, 0xf5c21eac, 0xa3df1bdd],
    reversed_timestamp: 0x6f947959,
    nbits: 0xffff7f1f,
    nonce: 0x000000cc
};
const BLOCKHEADER_1980: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x865da117, 0x8f1aca0f, 0xdbe78a97, 0x4c05d29b, 0xdac6612d, 0x032c6296, 0x47c26c6b, 0xce522300],
    merkle_root: [0x694b16df, 0x2fdf8fea, 0xabdf1ad8, 0xb4a9959c, 0x37f4dfc1, 0x027fc448, 0xd93f60ab, 0x025889a2],
    reversed_timestamp: 0x70947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000004f
};
const BLOCKHEADER_1981: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf094813a, 0xc0c349ec, 0x25c2cb96, 0x97f1a876, 0xde76d058, 0x6cc00cae, 0x6a86a10f, 0xcb766700],
    merkle_root: [0x78bc3bf2, 0x8c939a5e, 0x56c16361, 0xf75d5e0e, 0x5b23a963, 0x83f5501e, 0x3ea8ce41, 0xbd770322],
    reversed_timestamp: 0x71947959,
    nbits: 0xffff7f1f,
    nonce: 0x000000b9
};
const BLOCKHEADER_1982: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x47a39968, 0x0506b418, 0x8ec13f1d, 0x66b7d8d5, 0xd876dc8f, 0xcfb542e4, 0x7d1040f1, 0x55235b00],
    merkle_root: [0xca8485f6, 0x97640b8a, 0x466bcd91, 0x890644b7, 0xae09175a, 0xb7a9dc58, 0x1788052b, 0x96bb2753],
    reversed_timestamp: 0x72947959,
    nbits: 0xffff7f1f,
    nonce: 0x000002a0
};
const BLOCKHEADER_1983: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x04d8c8e4, 0xcf73dda2, 0x10bd581b, 0x26fd59f5, 0x89a895a2, 0x44fd9b1d, 0xcb8849c6, 0xc55d2400],
    merkle_root: [0xa4350d5f, 0x2018988f, 0xa3499983, 0x055291ca, 0xc44b2050, 0x05c2aab4, 0x6164c5c6, 0x15e156c8],
    reversed_timestamp: 0x73947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000181
};
const BLOCKHEADER_1984: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7c7bd06a, 0x90025c02, 0x20e60d99, 0xdb4b95c2, 0x3b0f7e59, 0x88bf208e, 0x1afbe9fe, 0xab707f00],
    merkle_root: [0x44c47b19, 0xe3b2185e, 0xfa5bac66, 0x4049f15b, 0x1a530dd5, 0xe906f292, 0xd06d885c, 0x1f84af19],
    reversed_timestamp: 0x74947959,
    nbits: 0xffff7f1f,
    nonce: 0x000002b9
};
const BLOCKHEADER_1985: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa8a84653, 0xf631608f, 0x3f25a98d, 0xfbbb25d9, 0x9a182494, 0x074301ff, 0x688347e9, 0x42f36e00],
    merkle_root: [0x777ca297, 0x88c3cfff, 0x255c8bb5, 0x63588e55, 0x55a3e65a, 0x3f9014f3, 0xaa91a988, 0x59e5a3e4],
    reversed_timestamp: 0x75947959,
    nbits: 0xffff7f1f,
    nonce: 0x000000cd
};
const BLOCKHEADER_1986: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x52757d41, 0x5bb966c3, 0xa393055a, 0x9db65ce3, 0x85dce94a, 0x8227b00b, 0x3921c1be, 0xec654f00],
    merkle_root: [0xe2288c8e, 0x5fc0f79e, 0xcfd4eea6, 0x3f9c7845, 0x77b3ca6e, 0x28e83ffd, 0xb6c676ea, 0x27a53396],
    reversed_timestamp: 0x76947959,
    nbits: 0xffff7f1f,
    nonce: 0x000000d8
};
const BLOCKHEADER_1987: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x36d9b1a4, 0x8819d207, 0xed96dfb3, 0x95a2dad8, 0x96c926a4, 0x689a773d, 0xdf7a835b, 0x55ee3500],
    merkle_root: [0xd80c81a9, 0x21cf9145, 0x1a672148, 0x18d787ca, 0x60769a58, 0x8ef31597, 0x037d3779, 0xa110b7b0],
    reversed_timestamp: 0x77947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000071
};
const BLOCKHEADER_1988: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1fede42a, 0x6604ad13, 0x820b642b, 0xdcf16bba, 0x2ce3e638, 0x8ab92650, 0xf2ed8387, 0xf22e4400],
    merkle_root: [0xc02fafbc, 0xb4d1353f, 0x8b619e7e, 0x766912f0, 0x61b68d93, 0x505618c2, 0xbe4ba620, 0x8b8863eb],
    reversed_timestamp: 0x78947959,
    nbits: 0xffff7f1f,
    nonce: 0x000002fc
};
const BLOCKHEADER_1989: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x62245cb9, 0xbf96e6ea, 0x744f7e84, 0x4a7eb97d, 0x345745ab, 0xa7fa7f5d, 0x9574b294, 0x69512d00],
    merkle_root: [0x9db0f811, 0x97d423c2, 0xb99256f6, 0x10a861b1, 0xfd2b0552, 0x8e6cdd1b, 0x1c2633cd, 0x044989bc],
    reversed_timestamp: 0x79947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000033b
};
const BLOCKHEADER_1990: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1d3974a0, 0x173c3323, 0x18242ef2, 0x4a6b4b73, 0x173c4e99, 0x09bd8a00, 0xae28fa7c, 0xd9453000],
    merkle_root: [0x1af63c73, 0x6727988f, 0x1ade49a3, 0xf9b32d10, 0xb2d88b59, 0xba29025d, 0xeb122c65, 0x9ff02f4b],
    reversed_timestamp: 0x7a947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000036a
};
const BLOCKHEADER_1991: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6a402e14, 0xf57f38ae, 0x39aa659d, 0x983b4141, 0x40923db2, 0xb4ec5d18, 0x9149e7d7, 0x241c7700],
    merkle_root: [0xf5bf3f32, 0x7fd77847, 0x7e8efb6d, 0xb4b00a62, 0x6c52e320, 0x5faf4d91, 0x1e0f6860, 0x7469b7ab],
    reversed_timestamp: 0x7b947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000011f
};
const BLOCKHEADER_1992: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1d8f193f, 0x81807f06, 0x5ce3529c, 0x01769b85, 0x25bcaa38, 0xa1ab9043, 0xe58610ad, 0x499f7100],
    merkle_root: [0x23855e52, 0xa1df22bd, 0xe781a881, 0x636dbc10, 0x2aa3bf68, 0xe4270274, 0xe58e419f, 0xff07ec85],
    reversed_timestamp: 0x7c947959,
    nbits: 0xffff7f1f,
    nonce: 0x000002cd
};
const BLOCKHEADER_1993: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf76da9b1, 0x2086c7c6, 0x018c3705, 0xddc73d38, 0x21861619, 0x6062a87c, 0x97c9303c, 0x4a472c00],
    merkle_root: [0x8db50b44, 0xefc0c0dd, 0x43845775, 0x88642604, 0x666135b4, 0x45ee34ba, 0xe5f5c533, 0xca627dd3],
    reversed_timestamp: 0x7d947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000079d
};
const BLOCKHEADER_1994: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6cdc3530, 0x45ecbd76, 0x28d04290, 0xf5a39e83, 0x68998e26, 0xa299be6e, 0x94ba19df, 0x44a36300],
    merkle_root: [0x6088a116, 0xbe90064b, 0x1295efbb, 0x6db70d79, 0xb1ed8e86, 0xe4e1e8e3, 0x3401ca77, 0x381b02f8],
    reversed_timestamp: 0x7e947959,
    nbits: 0xffff7f1f,
    nonce: 0x000001b8
};
const BLOCKHEADER_1995: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5557c0b9, 0xa6a51328, 0xcf56535b, 0x4e3da77b, 0xa6831e2f, 0x53eee90a, 0xe0e5c6e2, 0x44915700],
    merkle_root: [0x42490b5d, 0x0396d2dd, 0x558636ec, 0xc5279a28, 0xaaca445b, 0x89da21ae, 0x43176ae0, 0xcd7178c3],
    reversed_timestamp: 0x7f947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000210
};
const BLOCKHEADER_1996: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2fdbc432, 0x665c51f6, 0x6f4c435e, 0x582467ed, 0xc9dc6f50, 0x5d88a209, 0x079a8483, 0x625e4900],
    merkle_root: [0x7be0c2c5, 0x919ee0a6, 0x24b0823f, 0x375b0059, 0x4c6846b4, 0x9cf6a37e, 0x71e87a39, 0xa662139f],
    reversed_timestamp: 0x80947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000053
};
const BLOCKHEADER_1997: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2eaec321, 0x981e6270, 0x09f8d08f, 0x375c1c4c, 0xec2b9920, 0x64577407, 0x4a936293, 0x1e0c7600],
    merkle_root: [0xf852e551, 0xef5ddb59, 0xde4f54aa, 0x8d90bf51, 0x47b378de, 0x50b97b60, 0x0abbbea9, 0x431ebe39],
    reversed_timestamp: 0x81947959,
    nbits: 0xffff7f1f,
    nonce: 0x000000ea
};
const BLOCKHEADER_1998: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf511e787, 0x58056912, 0x39d125aa, 0x3404d909, 0x14cd1add, 0x4f9dbe4d, 0xc795945b, 0x89ea2a00],
    merkle_root: [0xf4509160, 0x85667008, 0xd8e5b608, 0x813f1820, 0x366aa9c2, 0x733369d6, 0x6783f9c1, 0x427230f2],
    reversed_timestamp: 0x82947959,
    nbits: 0xffff7f1f,
    nonce: 0x000001c7
};
const BLOCKHEADER_1999: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x32e09796, 0xd4b41325, 0x70fed417, 0x5372cb4e, 0x0ec81e35, 0xef7f0614, 0xd9d8e9f0, 0x84dc0f00],
    merkle_root: [0xb9edc4a7, 0xde96ae6a, 0x85b66594, 0xb7c739b8, 0x5bae5eec, 0xb47545ce, 0xe6d9255f, 0x70c51862],
    reversed_timestamp: 0x83947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000082
};
const BLOCKHEADER_2000: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xcd59576a, 0x9e0241c1, 0x132df6be, 0x36c5d650, 0x32691a77, 0x2ea68056, 0x942f74c3, 0xb2cd4b00],
    merkle_root: [0xef582ef5, 0x060d6507, 0x04fac305, 0x9d870ce0, 0x7a0323c6, 0x650dbb37, 0x8434e6c5, 0xa256fc4b],
    reversed_timestamp: 0x84947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000216
};
const BLOCKHEADER_2001: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x83f04343, 0xbd6da67a, 0x1c9a296c, 0x97713024, 0xfd2bbd85, 0xa54bd2cc, 0xe068ad66, 0x65cd7f00],
    merkle_root: [0x38ba1bbb, 0x0dacefaa, 0x5169e7cc, 0x34f8192c, 0x4a807b00, 0xb822f6f9, 0xd95216f4, 0x78de6380],
    reversed_timestamp: 0x85947959,
    nbits: 0xffff7f1f,
    nonce: 0x000000b9
};
const BLOCKHEADER_2002: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x462ba230, 0xe2009a21, 0x20a66ccf, 0xb7e4ee9f, 0xc1eafbd5, 0x03a661bb, 0xd6a6b79e, 0x4c121b00],
    merkle_root: [0x91a5fe91, 0x177a94c6, 0xe24be3d6, 0x434d515b, 0x7c78c297, 0x9979f29f, 0x8c147ecb, 0xb9ae8e82],
    reversed_timestamp: 0x86947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000088
};
const BLOCKHEADER_2003: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x01593dd3, 0x25cc381e, 0x05bc7549, 0x80425ff1, 0x5a278128, 0x5f28d47d, 0x60f9368b, 0x660d5400],
    merkle_root: [0x57403a27, 0x7344c8ec, 0xec6190ae, 0xe1d54384, 0x73664c45, 0x1ee923f7, 0xe50ce13f, 0x66fb36c9],
    reversed_timestamp: 0x87947959,
    nbits: 0xffff7f1f,
    nonce: 0x000000c2
};
const BLOCKHEADER_2004: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x119ea803, 0x009cedde, 0xf788c236, 0x41b0949e, 0xbd4995b9, 0x08c2d6d7, 0xb53888f7, 0x93c96200],
    merkle_root: [0x6bebe274, 0xa746fc2c, 0x2ac40ee8, 0xe8975a27, 0xffd6974a, 0x087297a6, 0xf3abe599, 0xac4411c3],
    reversed_timestamp: 0x88947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000061b
};
const BLOCKHEADER_2005: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf2fa166b, 0x1d093090, 0xf434539f, 0x6f038110, 0x3269ed3b, 0xa5052c0c, 0xb5844638, 0xc41a5400],
    merkle_root: [0x4c1c84ff, 0x12eb5224, 0x606466ac, 0x9a4f072f, 0x578048ab, 0x61131785, 0x2f0eeaa2, 0xb72e720f],
    reversed_timestamp: 0x89947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000008
};
const BLOCKHEADER_2006: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x0697cdbb, 0x10cd7090, 0xd1573e7f, 0x45906f49, 0xba249e8f, 0x17da6495, 0xe5489a56, 0xf6fa6000],
    merkle_root: [0xd2d35b27, 0xa50e325a, 0x0eeb497b, 0x941b4ea9, 0x67b64700, 0xa51360f6, 0x83373e1d, 0x3a5ac79e],
    reversed_timestamp: 0x8a947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000005f
};
const BLOCKHEADER_2007: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb632718f, 0xb340923f, 0x2241558e, 0xb53b78c3, 0xdf2df23f, 0x99df6031, 0x87b4ef79, 0xfe694000],
    merkle_root: [0x010a2020, 0xb450522b, 0x9e621c25, 0x1e45d1f9, 0x5a719da5, 0xa2965a77, 0x1beafaf2, 0x6909114f],
    reversed_timestamp: 0x8b947959,
    nbits: 0xffff7f1f,
    nonce: 0x000003db
};
const BLOCKHEADER_2008: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xbc836049, 0xa4d9b069, 0xee8906bb, 0xa3a8e47f, 0x18e51134, 0xa7f37239, 0x2886f2a8, 0x5e187f00],
    merkle_root: [0x5d3cf7a5, 0x0df7938d, 0x896f8b01, 0x182e5566, 0xe351bad2, 0x3058795d, 0x8a6166b9, 0x7e4ae988],
    reversed_timestamp: 0x8c947959,
    nbits: 0xffff7f1f,
    nonce: 0x000001f3
};
const BLOCKHEADER_2009: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x686881ad, 0xca4c8526, 0xe0493539, 0x6a3a568b, 0x595d8dae, 0x16d7f2f3, 0xb6830f8d, 0x1c012800],
    merkle_root: [0xb1615273, 0xa2afa7ca, 0x598396bf, 0x62b7ccb0, 0x6371beee, 0x880d5ce3, 0x6aedd814, 0x1e73261c],
    reversed_timestamp: 0x8d947959,
    nbits: 0xffff7f1f,
    nonce: 0x000003c5
};
const BLOCKHEADER_2010: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa214e7c9, 0x57225a84, 0xb9d3b8cf, 0x9656aa7d, 0xacc9b10e, 0x75d861d7, 0x2a6ed653, 0x68830f00],
    merkle_root: [0x484a774d, 0x29e15eb1, 0xbe4c0403, 0x61878d2b, 0x4cc9a035, 0x259666c0, 0x7a5731ec, 0x52922371],
    reversed_timestamp: 0x8e947959,
    nbits: 0xffff7f1f,
    nonce: 0x000000be
};
const BLOCKHEADER_2011: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4696cb78, 0xf3ab0c18, 0xdc6135fd, 0x339d90cb, 0xf99c94e8, 0x8f4ec607, 0x7b161fed, 0x25c05400],
    merkle_root: [0x993e18c6, 0x2b97709d, 0xb9882ba1, 0x2abfceb0, 0x5023932e, 0x30460668, 0x6362b1d9, 0x9d550c21],
    reversed_timestamp: 0x8f947959,
    nbits: 0xffff7f1f,
    nonce: 0x000000ca
};
const BLOCKHEADER_2012: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd1f54732, 0x3a853936, 0xd58e38ac, 0x15db01a4, 0x5ac0981a, 0xc0e3bdd6, 0x085601e8, 0xe5381b00],
    merkle_root: [0x54a2b2bc, 0xf140cebe, 0xfb9de891, 0xf930c961, 0x24cea971, 0x5e9f16be, 0x272f45d1, 0xf79e4b01],
    reversed_timestamp: 0x90947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000172
};
const BLOCKHEADER_2013: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb6207c4d, 0x7b1bccf9, 0xe4485121, 0xc5b532f8, 0x91f32787, 0x5db2ce5d, 0x47651a62, 0x0d640700],
    merkle_root: [0x49117b2f, 0x4ca4b39a, 0xd63e9209, 0xd09ed94d, 0xd56f713d, 0x720f08a7, 0xe01e2ac7, 0x885df5f6],
    reversed_timestamp: 0x91947959,
    nbits: 0xffff7f1f,
    nonce: 0x0000019e
};
const BLOCKHEADER_2014: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2d5d998b, 0x9512bbca, 0xe3ce419e, 0xa124dd54, 0xd418ed0b, 0xc415088e, 0xc5522d5a, 0xcc747800],
    merkle_root: [0xcbce2186, 0xedc608c5, 0x1f68090f, 0x59ba672f, 0x20441442, 0xae5439be, 0xbc9e3cb3, 0xb280b05b],
    reversed_timestamp: 0x92947959,
    nbits: 0xffff7f1f,
    nonce: 0x000003a9
};
const BLOCKHEADER_2015: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xeb5c38fa, 0xfb5e795f, 0x9a2317d5, 0x24c4ab63, 0x38a2d356, 0x42088cdf, 0x8333bd64, 0xc8bc5000],
    merkle_root: [0x102f8370, 0x121b6a90, 0xe97d0f84, 0xc88f7d5c, 0x0741dd6e, 0xb9fd803e, 0xb12b0fc1, 0x45a601d8],
    reversed_timestamp: 0x93947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000a23
};
const BLOCKHEADER_2016: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd8104fa2, 0x72c9d843, 0x2f3d12d6, 0xdbf332f1, 0x41ba30d6, 0x4778be68, 0x52c0aa03, 0x4b0d4000],
    merkle_root: [0x23aa9f06, 0x5042934d, 0xbb07e8bd, 0x0204e597, 0xbf79a1f3, 0xe9df7f8e, 0xb99ac168, 0x0ec84b5f],
    reversed_timestamp: 0x94947959,
    nbits: 0xa6a5781f,
    nonce: 0x0000095b
};
const BLOCKHEADER_2017: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x06a84211, 0x4ad0b986, 0xb91079d4, 0x6a934424, 0x2cccf144, 0xbe7b2b9c, 0x9e6ff93a, 0xfbd93800],
    merkle_root: [0xec755efa, 0xf42733bc, 0xc6b784b1, 0xb08172f9, 0x365f6d78, 0xeeae8ccd, 0xca0051ee, 0xc0d5afd1],
    reversed_timestamp: 0x95947959,
    nbits: 0xa6a5781f,
    nonce: 0x0000041e
};
const BLOCKHEADER_2018: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf4782d9f, 0x8c0327b2, 0x8bcd43fc, 0xaca9b61c, 0xf6ea3a68, 0x1cff2f69, 0x16efb94b, 0x1eae0a00],
    merkle_root: [0xe04a1421, 0xb7c1bed4, 0x7ac15146, 0x30d326e4, 0xcae197ff, 0xb45564b3, 0x3b72a13f, 0xaada9ff2],
    reversed_timestamp: 0x96947959,
    nbits: 0xa6a5781f,
    nonce: 0x00000010
};
const BLOCKHEADER_2019: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd79fa1d9, 0xe9bf4e79, 0x02443b62, 0xa8ad4a18, 0xe8173df0, 0x2459f458, 0xf9afc36b, 0x82920a00],
    merkle_root: [0x894621d3, 0x62fba927, 0xd6902b17, 0xd84cb5d5, 0x7a3c02ee, 0x8fde259b, 0x49ffa896, 0xb1673cd4],
    reversed_timestamp: 0x97947959,
    nbits: 0xa6a5781f,
    nonce: 0x00000196
};
const BLOCKHEADER_2020: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6f65e35b, 0x6ce71247, 0x5160c8ad, 0x1741d91d, 0x100c756e, 0xf257ee60, 0x75d3a15b, 0xb2b82b00],
    merkle_root: [0x11f486f2, 0xcf00549f, 0x15032822, 0xe7f55dcb, 0x4f132c0d, 0xaacd94da, 0x599836cb, 0x401a93e7],
    reversed_timestamp: 0x98947959,
    nbits: 0xa6a5781f,
    nonce: 0x000001d1
};
const BLOCKHEADER_2021: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xfd378487, 0xe99a8fc6, 0x7e38363f, 0xd4cd5a63, 0xf4459105, 0x5b3d05fa, 0xedfcd8c3, 0xcf171900],
    merkle_root: [0x3b11f9db, 0xef1aee4f, 0x13a78f45, 0x696b8b53, 0x912e26f7, 0x69441ac6, 0xe9539109, 0xf24c7459],
    reversed_timestamp: 0x99947959,
    nbits: 0xa6a5781f,
    nonce: 0x00000036
};
const BLOCKHEADER_2022: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x35eaa69a, 0xb9c2cf2b, 0xc4892241, 0x522e6b26, 0xbbf80fa3, 0x4feb9a03, 0x6aecebd6, 0x0c294300],
    merkle_root: [0xe18eba47, 0x7db9501c, 0x74bf118b, 0xe8aa219d, 0xece8b9ce, 0xc87fd6f8, 0x84805291, 0xe4cb16b3],
    reversed_timestamp: 0x9a947959,
    nbits: 0xa6a5781f,
    nonce: 0x0000038b
};
const BLOCKHEADER_2023: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xefb885b8, 0xd05816ff, 0x76fd66a3, 0x19b67c43, 0x125f0733, 0xd235e550, 0xf3a42efe, 0xfc195600],
    merkle_root: [0x5b13498f, 0x451a3111, 0x6670d8c5, 0xbc251df0, 0x241b1330, 0x84a7fdf7, 0xd69e2df1, 0xb66b3a1e],
    reversed_timestamp: 0x9b947959,
    nbits: 0xa6a5781f,
    nonce: 0x0000039a
};
const BLOCKHEADER_2024: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x0a89746f, 0x043bef15, 0x13b47918, 0x4b823a7c, 0xb1477542, 0x36d0768b, 0x1eaee070, 0x129b7300],
    merkle_root: [0x5b059b9b, 0xcc2dd9e6, 0xabb75681, 0x1d781e68, 0x7e570ce1, 0x2709652b, 0x4e978757, 0x64d83009],
    reversed_timestamp: 0x9c947959,
    nbits: 0xa6a5781f,
    nonce: 0x00000029
};
const BLOCKHEADER_2025: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7a9a5735, 0x59cc1727, 0x493f8297, 0xc21058e9, 0xcc206c97, 0x9cd763fb, 0x1af57702, 0x302e4200],
    merkle_root: [0x4b8c6217, 0x78f3a5c0, 0x8f7b3d30, 0x9f8525f1, 0x2b41e24b, 0x4ec817b0, 0xee88aa6b, 0x03fec38c],
    reversed_timestamp: 0x9d947959,
    nbits: 0xa6a5781f,
    nonce: 0x00000041
};
const BLOCKHEADER_2026: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x61309750, 0xf4b148ec, 0xb8ad074f, 0xcc728e6b, 0x4f9889a0, 0x6063ec64, 0x01ec178c, 0xccf80400],
    merkle_root: [0x2071671d, 0x8db417fb, 0x1241700c, 0x006c724c, 0x2fc0f2a3, 0xdd6a2aa4, 0x2108b62b, 0x2fb73c30],
    reversed_timestamp: 0x9e947959,
    nbits: 0xa6a5781f,
    nonce: 0x0000001d
};
const BLOCKHEADER_2027: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xda61f2e8, 0x3ad683e7, 0xe11e5eed, 0xebbb2c98, 0x79e795b3, 0xc4524d4e, 0x5d914978, 0x292f6500],
    merkle_root: [0xd3c96e28, 0xac56b3fe, 0x417758ba, 0xeb928402, 0x3a8041c6, 0xea1b627d, 0x98444ffc, 0xf3195453],
    reversed_timestamp: 0x9f947959,
    nbits: 0xa6a5781f,
    nonce: 0x00000097
};
const BLOCKHEADER_2028: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x74e4a487, 0x0590d6ff, 0xfcf9e3c0, 0x65d928da, 0x40ff27ab, 0xf431dd01, 0x6a3363ed, 0x1af32100],
    merkle_root: [0x66e2af31, 0x995b13b7, 0x33c583fb, 0x9edd1bac, 0x862ece16, 0x1c686109, 0x8003a7cc, 0x8ef63228],
    reversed_timestamp: 0xa0947959,
    nbits: 0xa6a5781f,
    nonce: 0x0000003a
};
const BLOCKHEADER_2029: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5b56e7a8, 0x71ec9b96, 0x18eb19a2, 0xb5a395b4, 0x29430157, 0xe3bec3f8, 0x068da1c5, 0xa7005a00],
    merkle_root: [0x9c4c6799, 0xa7a5f390, 0xcb0c709f, 0xcee12a6a, 0x09bd2f93, 0x81465e29, 0x2c1fd34b, 0x195359ba],
    reversed_timestamp: 0xa1947959,
    nbits: 0xa6a5781f,
    nonce: 0x000003cd
};
const BLOCKHEADER_2030: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x247f7081, 0xbaef9d6b, 0xdeee61d4, 0xc5af703d, 0xf65371c7, 0xf07311ce, 0x648229be, 0xa1515200],
    merkle_root: [0x7656c018, 0xd2f80980, 0xcc7f670a, 0x9a0eb422, 0x189fffe6, 0xe27cdec9, 0x22135d56, 0xb4237684],
    reversed_timestamp: 0xa2947959,
    nbits: 0xa6a5781f,
    nonce: 0x000000c0
};
const BLOCKHEADER_2031: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x918a6879, 0x17bb64a8, 0x0f39c1d6, 0x467012af, 0xc4f55647, 0xd3577f1d, 0xa416024f, 0xf7a06100],
    merkle_root: [0xe8105e42, 0xc2423ee7, 0x06e27415, 0x0be8f5e8, 0xa2d752e6, 0x357f0822, 0x2be0935b, 0xa13ddd8f],
    reversed_timestamp: 0xa3947959,
    nbits: 0xa6a5781f,
    nonce: 0x000000ea
};
const BLOCKHEADER_2032: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa6b58aac, 0x65fe890f, 0x90718443, 0x7ab167b3, 0x9cb99309, 0x0c4571d0, 0xd19ddbec, 0x74422e00],
    merkle_root: [0xf1979858, 0x6eef8fda, 0x142df2f4, 0x99ad3293, 0x15b652fe, 0x589206c2, 0xd449c2c8, 0x751a878b],
    reversed_timestamp: 0xa4947959,
    nbits: 0xa6a5781f,
    nonce: 0x00000189
};
const BLOCKHEADER_2033: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb11172ef, 0xa39d8abe, 0xfded72ab, 0xdc8d593b, 0xb3955cad, 0x7ddf01b3, 0xfb30e460, 0x96c81600],
    merkle_root: [0xea7f646a, 0xd953e07b, 0xbbcdc0b3, 0xdbe78c14, 0xd7954640, 0x5fc09e75, 0x138ae59e, 0x83af0ccd],
    reversed_timestamp: 0xa5947959,
    nbits: 0xa6a5781f,
    nonce: 0x00000015
};
const BLOCKHEADER_2034: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1c8fa87b, 0x51177fc3, 0x293570fb, 0xc22b47f5, 0x25393727, 0x7061d1a7, 0x38e58451, 0x91e66200],
    merkle_root: [0x2b383d99, 0x11250e53, 0x57b6a432, 0xbfcde7fd, 0x377683e1, 0xc483a5d0, 0x73bc24f7, 0xdcc94ff2],
    reversed_timestamp: 0xa6947959,
    nbits: 0xa6a5781f,
    nonce: 0x000001e3
};

pub const BLOCKHEADERS: [BlockHeader; 134] = [
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
];

pub const STORED_BLOCKHEADERS: [StoredBlockHeader; 135] = [
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
        block_hash: [0xa7faddeb, 0x2dd79abb, 0xe27f3acd, 0x6897e161, 0x378a526c, 0x4bf718ab, 0x45eed7d3, 0x232a5000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000edc00,
        block_height: 1901,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501134600, 1501135200, 1501135800, 1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1902,
        block_hash: [0x02230b43, 0xece00e11, 0x6fcc6b7e, 0x4e6c448d, 0x0d559ae5, 0xa8da724d, 0xdb39f203, 0x2ab07400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ede00,
        block_height: 1902,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501135200, 1501135800, 1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140001]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1903,
        block_hash: [0x81684f1a, 0xf6e5b880, 0xd5de8549, 0x452d66fd, 0xf7ea1ae0, 0x623c23c8, 0xdcd4e668, 0x5cb56c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee000,
        block_height: 1903,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501135800, 1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140001, 1501140002]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1904,
        block_hash: [0xf3582d9c, 0xf07f8e70, 0x7ea30466, 0x37176ad7, 0x54677db0, 0xe764f685, 0xb34c53cb, 0x0aab6f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee200,
        block_height: 1904,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140001, 1501140002, 1501140003]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1905,
        block_hash: [0x70f468f0, 0xec111cf9, 0x5a802687, 0x4963c93d, 0xd9153c32, 0x07320f2b, 0xe75e3007, 0xb9206400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee400,
        block_height: 1905,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140001, 1501140002, 1501140003, 1501140004]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1906,
        block_hash: [0x5dee0da7, 0x04429769, 0x78acca39, 0x106dafda, 0x2de0c56a, 0xc34e0eee, 0x6ac213e4, 0x7e642c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee600,
        block_height: 1906,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140001, 1501140002, 1501140003, 1501140004, 1501140005]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1907,
        block_hash: [0x9c8389ae, 0x77f33384, 0xe50041f2, 0xcdb48701, 0x9dc08ee3, 0x42871fc4, 0x13d04a3c, 0x70503800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee800,
        block_height: 1907,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501138200, 1501138800, 1501139400, 1501140000, 1501140001, 1501140002, 1501140003, 1501140004, 1501140005, 1501140006]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1908,
        block_hash: [0x4c3afdd9, 0x88b95338, 0x2eb90a3c, 0x9ff35682, 0x57768bc4, 0x2d9d528e, 0xa00efa68, 0x8a7e0a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000eea00,
        block_height: 1908,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501138800, 1501139400, 1501140000, 1501140001, 1501140002, 1501140003, 1501140004, 1501140005, 1501140006, 1501140007]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1909,
        block_hash: [0x5627620e, 0x549008c8, 0x340f336e, 0xf14d6d18, 0x44cd505b, 0x6e148b28, 0xd1e0347e, 0x5a6d1100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000eec00,
        block_height: 1909,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501139400, 1501140000, 1501140001, 1501140002, 1501140003, 1501140004, 1501140005, 1501140006, 1501140007, 1501140008]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1910,
        block_hash: [0x461bb7a5, 0xc227a15f, 0xd5cb61b7, 0x2bb863bd, 0x2994b830, 0xe069f04e, 0x6efbe455, 0x65026d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000eee00,
        block_height: 1910,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140000, 1501140001, 1501140002, 1501140003, 1501140004, 1501140005, 1501140006, 1501140007, 1501140008, 1501140009]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1911,
        block_hash: [0x5575a948, 0x86406f4b, 0xeb4a204c, 0xb7e73e62, 0x004d6c25, 0x505100c4, 0xa4cb0bf8, 0xb04d7c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef000,
        block_height: 1911,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140001, 1501140002, 1501140003, 1501140004, 1501140005, 1501140006, 1501140007, 1501140008, 1501140009, 1501140010]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1912,
        block_hash: [0x04bee7b3, 0x165ef22b, 0xb0d5905a, 0xad2212ca, 0xc0c62912, 0xeac0a6ca, 0x80253e3c, 0xf0d41c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef200,
        block_height: 1912,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140002, 1501140003, 1501140004, 1501140005, 1501140006, 1501140007, 1501140008, 1501140009, 1501140010, 1501140011]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1913,
        block_hash: [0xfb828206, 0xc674c3f3, 0x617e43b7, 0x3e15d2e5, 0x1fb603e3, 0xba5bbf3c, 0x59d3a272, 0x17a51100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef400,
        block_height: 1913,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140003, 1501140004, 1501140005, 1501140006, 1501140007, 1501140008, 1501140009, 1501140010, 1501140011, 1501140012]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1914,
        block_hash: [0xc34c2396, 0x538d3139, 0x45c455a9, 0xe465eb78, 0x0e0ff435, 0x0c1a43b3, 0xe3df2ff2, 0x0e3d0400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef600,
        block_height: 1914,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140004, 1501140005, 1501140006, 1501140007, 1501140008, 1501140009, 1501140010, 1501140011, 1501140012, 1501140013]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1915,
        block_hash: [0xda97e267, 0x0222abe0, 0x63c1ed0a, 0xb64c69b4, 0xe1108eeb, 0x17f4d6b9, 0x2bcb858d, 0xb1074f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef800,
        block_height: 1915,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140005, 1501140006, 1501140007, 1501140008, 1501140009, 1501140010, 1501140011, 1501140012, 1501140013, 1501140014]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1916,
        block_hash: [0x1c030fac, 0x4dda76d3, 0x6e2ad18b, 0x0a40fb61, 0xa152ec45, 0x18b7e32b, 0x35cd2d81, 0x9f311b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000efa00,
        block_height: 1916,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140006, 1501140007, 1501140008, 1501140009, 1501140010, 1501140011, 1501140012, 1501140013, 1501140014, 1501140015]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1917,
        block_hash: [0xb8b970d3, 0x23278a78, 0xc153fc6b, 0x2c61aabe, 0x169c9b33, 0xdb360e93, 0x9886f9c7, 0x3a371100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000efc00,
        block_height: 1917,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140007, 1501140008, 1501140009, 1501140010, 1501140011, 1501140012, 1501140013, 1501140014, 1501140015, 1501140016]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1918,
        block_hash: [0xeac372af, 0xc51dc283, 0x4bf2188d, 0xee59b264, 0x8b5f2a17, 0x8b30619a, 0xdb4d5802, 0xb7da1a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000efe00,
        block_height: 1918,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140008, 1501140009, 1501140010, 1501140011, 1501140012, 1501140013, 1501140014, 1501140015, 1501140016, 1501140017]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1919,
        block_hash: [0xf5720820, 0x62a15009, 0xee74d589, 0xf07ca358, 0x35195e33, 0x0c21ca7e, 0x20cc25c8, 0x11877600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0000,
        block_height: 1919,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140009, 1501140010, 1501140011, 1501140012, 1501140013, 1501140014, 1501140015, 1501140016, 1501140017, 1501140018]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1920,
        block_hash: [0x65c93a03, 0x70220a11, 0xfb4b70e4, 0xf81f6c95, 0x5fa70e44, 0x028133b5, 0x1fdc2363, 0x637a3100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0200,
        block_height: 1920,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140010, 1501140011, 1501140012, 1501140013, 1501140014, 1501140015, 1501140016, 1501140017, 1501140018, 1501140019]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1921,
        block_hash: [0xb180c1b3, 0x346a4631, 0x3cf96a4f, 0x42f4d685, 0x8f733bf9, 0x15c527a0, 0xdc5d866c, 0xe57f0900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0400,
        block_height: 1921,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140011, 1501140012, 1501140013, 1501140014, 1501140015, 1501140016, 1501140017, 1501140018, 1501140019, 1501140020]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1922,
        block_hash: [0x55637c57, 0x49933364, 0xc39786ab, 0x83f1f9ef, 0x59407e51, 0x14b5b18a, 0x4616e8cb, 0x85652c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0600,
        block_height: 1922,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140012, 1501140013, 1501140014, 1501140015, 1501140016, 1501140017, 1501140018, 1501140019, 1501140020, 1501140021]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1923,
        block_hash: [0x3a1b7dff, 0x83b0b1b4, 0x423e7d12, 0x1d8daca2, 0xcc38125f, 0x836a6060, 0xf230b679, 0x45fd6000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0800,
        block_height: 1923,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140013, 1501140014, 1501140015, 1501140016, 1501140017, 1501140018, 1501140019, 1501140020, 1501140021, 1501140022]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1924,
        block_hash: [0xa2b8cff8, 0x24769896, 0x3db654d5, 0x10e1ff0a, 0xa2eae614, 0xb6e9a659, 0xc2979ce5, 0x56a72200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0a00,
        block_height: 1924,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140014, 1501140015, 1501140016, 1501140017, 1501140018, 1501140019, 1501140020, 1501140021, 1501140022, 1501140023]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1925,
        block_hash: [0x12451adf, 0x814592c4, 0x7a84bad5, 0xd04ba704, 0xdbc830ad, 0x8ef55c23, 0xb6bdede1, 0x6dfc2000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0c00,
        block_height: 1925,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140015, 1501140016, 1501140017, 1501140018, 1501140019, 1501140020, 1501140021, 1501140022, 1501140023, 1501140024]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1926,
        block_hash: [0x2240e4ab, 0x92e87e76, 0x7b683604, 0x1d142f73, 0x5aa99c87, 0x4947d356, 0x802570c4, 0xc0ee1200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0e00,
        block_height: 1926,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140016, 1501140017, 1501140018, 1501140019, 1501140020, 1501140021, 1501140022, 1501140023, 1501140024, 1501140025]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1927,
        block_hash: [0x9dfc9ad1, 0xaa43ea01, 0x2dfe621b, 0xd0f3ad29, 0xe2bf484a, 0xce195012, 0x14ada066, 0xfefc0b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1000,
        block_height: 1927,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140017, 1501140018, 1501140019, 1501140020, 1501140021, 1501140022, 1501140023, 1501140024, 1501140025, 1501140026]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1928,
        block_hash: [0x4d500f88, 0xc606b31d, 0xcd6b6e29, 0xc3e395c7, 0x61eaf744, 0x24dc09d5, 0xbe2c4022, 0xfdcc7500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1200,
        block_height: 1928,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140018, 1501140019, 1501140020, 1501140021, 1501140022, 1501140023, 1501140024, 1501140025, 1501140026, 1501140027]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1929,
        block_hash: [0xc7bec8c6, 0x44bf3b79, 0xe455100e, 0xae450346, 0x71af4da5, 0xd560ed80, 0xc24d9475, 0xfab82b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1400,
        block_height: 1929,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140019, 1501140020, 1501140021, 1501140022, 1501140023, 1501140024, 1501140025, 1501140026, 1501140027, 1501140028]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1930,
        block_hash: [0x7c3d6526, 0xcf5b927e, 0x6efd7294, 0xa4258afd, 0x62c240ed, 0x9f772bae, 0xa78f5f44, 0x95331900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1600,
        block_height: 1930,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140020, 1501140021, 1501140022, 1501140023, 1501140024, 1501140025, 1501140026, 1501140027, 1501140028, 1501140029]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1931,
        block_hash: [0x544c8ef3, 0xd62c3872, 0xcb3a8521, 0x7aee9fe6, 0xb5907407, 0x4f8d7b54, 0x48e540ab, 0x6c286500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1800,
        block_height: 1931,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140021, 1501140022, 1501140023, 1501140024, 1501140025, 1501140026, 1501140027, 1501140028, 1501140029, 1501140030]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1932,
        block_hash: [0x9cb09c56, 0x03e72561, 0xc07c90d4, 0x12a75369, 0xf9201b37, 0xa9953b10, 0x1a7f9941, 0x5e007400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1a00,
        block_height: 1932,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140022, 1501140023, 1501140024, 1501140025, 1501140026, 1501140027, 1501140028, 1501140029, 1501140030, 1501140031]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1933,
        block_hash: [0x3b16052f, 0x4ebbdfad, 0x81d08e06, 0x874ac6de, 0x4ccd51cf, 0x7d26ff0f, 0xffc9f3cc, 0xa42c0e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1c00,
        block_height: 1933,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140023, 1501140024, 1501140025, 1501140026, 1501140027, 1501140028, 1501140029, 1501140030, 1501140031, 1501140032]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1934,
        block_hash: [0x8e98cbb2, 0x42af6e9e, 0x68d1fc9d, 0x885342d5, 0x39c0b56c, 0x7c9eabd5, 0xfabcd11e, 0x6e960d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1e00,
        block_height: 1934,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140024, 1501140025, 1501140026, 1501140027, 1501140028, 1501140029, 1501140030, 1501140031, 1501140032, 1501140033]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1935,
        block_hash: [0xbd5cc918, 0xb5239ae7, 0x768dd132, 0xcbcb7e26, 0xd9b4a458, 0x98ea3dd6, 0x29f57813, 0x4cfd1400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2000,
        block_height: 1935,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140025, 1501140026, 1501140027, 1501140028, 1501140029, 1501140030, 1501140031, 1501140032, 1501140033, 1501140034]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1936,
        block_hash: [0xdf6194e9, 0xa650ea6a, 0x05fb1fdd, 0x75c49cc0, 0x250d1181, 0xf1e8668d, 0x069fb803, 0x35b90a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2200,
        block_height: 1936,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140026, 1501140027, 1501140028, 1501140029, 1501140030, 1501140031, 1501140032, 1501140033, 1501140034, 1501140035]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1937,
        block_hash: [0x035797b8, 0x4abd7c73, 0x58cb21cc, 0x7649c51c, 0x8579ab44, 0xaa8f9617, 0x3be10c52, 0x2d714800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2400,
        block_height: 1937,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140027, 1501140028, 1501140029, 1501140030, 1501140031, 1501140032, 1501140033, 1501140034, 1501140035, 1501140036]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1938,
        block_hash: [0x21cb2561, 0xe2d05277, 0x18a1e62f, 0x67e615e4, 0xcc1f8e66, 0xfdf0a639, 0x7889a667, 0x97006f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2600,
        block_height: 1938,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140028, 1501140029, 1501140030, 1501140031, 1501140032, 1501140033, 1501140034, 1501140035, 1501140036, 1501140037]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1939,
        block_hash: [0x14fbec1c, 0xf09b83d8, 0xb4127d92, 0x2baadbd2, 0x5fb3bde7, 0x9e207c50, 0x6433f5fd, 0x36535f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2800,
        block_height: 1939,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140029, 1501140030, 1501140031, 1501140032, 1501140033, 1501140034, 1501140035, 1501140036, 1501140037, 1501140038]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1940,
        block_hash: [0x96fbb089, 0x7f81a6ba, 0xb8195e8a, 0x8bea39d5, 0xe491d3db, 0x4527b250, 0xf55c903a, 0x3f4f0a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2a00,
        block_height: 1940,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140030, 1501140031, 1501140032, 1501140033, 1501140034, 1501140035, 1501140036, 1501140037, 1501140038, 1501140039]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1941,
        block_hash: [0x5790f7f2, 0xf3dac1e9, 0x2887cec7, 0x5d6983dd, 0x9de79894, 0xcea910fa, 0x0d6a0b75, 0x9a735f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2c00,
        block_height: 1941,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140031, 1501140032, 1501140033, 1501140034, 1501140035, 1501140036, 1501140037, 1501140038, 1501140039, 1501140040]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1942,
        block_hash: [0x16b48b01, 0x361ebe7c, 0x29510857, 0x29a8933c, 0xd925947e, 0x7e423806, 0xf90c218c, 0xa0793000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2e00,
        block_height: 1942,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140032, 1501140033, 1501140034, 1501140035, 1501140036, 1501140037, 1501140038, 1501140039, 1501140040, 1501140041]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1943,
        block_hash: [0x5e4b4814, 0xe3fcdf5a, 0xfb88bb12, 0xf0c464c5, 0x4438ca56, 0x043d20e9, 0xc4abff03, 0xc8fd1700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3000,
        block_height: 1943,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140033, 1501140034, 1501140035, 1501140036, 1501140037, 1501140038, 1501140039, 1501140040, 1501140041, 1501140042]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1944,
        block_hash: [0x682a1a98, 0xe3baabf8, 0xaa8c34e5, 0xf1a866b5, 0x13fd4d1b, 0x4b55f521, 0x577034f9, 0x74e11e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3200,
        block_height: 1944,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140034, 1501140035, 1501140036, 1501140037, 1501140038, 1501140039, 1501140040, 1501140041, 1501140042, 1501140043]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1945,
        block_hash: [0x53e53b17, 0x7110ae69, 0xa40b4217, 0x8fda9537, 0x8446ad17, 0xb40ac060, 0x2ad94aca, 0xc12b2400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3400,
        block_height: 1945,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140035, 1501140036, 1501140037, 1501140038, 1501140039, 1501140040, 1501140041, 1501140042, 1501140043, 1501140044]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1946,
        block_hash: [0x0b331556, 0x5892daa8, 0xfe55c1b2, 0x43193280, 0xb5539c2f, 0x461ac330, 0x020e41ae, 0x17026a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3600,
        block_height: 1946,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140036, 1501140037, 1501140038, 1501140039, 1501140040, 1501140041, 1501140042, 1501140043, 1501140044, 1501140045]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1947,
        block_hash: [0xaffd74f6, 0x3695a04a, 0x69a7fef9, 0xde2e7a84, 0xa868aed3, 0xaf0cde97, 0xc6ccc0ea, 0xeb7c6a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3800,
        block_height: 1947,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140037, 1501140038, 1501140039, 1501140040, 1501140041, 1501140042, 1501140043, 1501140044, 1501140045, 1501140046]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1948,
        block_hash: [0x08c89e17, 0xdc7de220, 0x224c2cab, 0x5b6a9638, 0x1bf7edf4, 0xad1f2c3a, 0x417a08b2, 0x1d7b1000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3a00,
        block_height: 1948,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140038, 1501140039, 1501140040, 1501140041, 1501140042, 1501140043, 1501140044, 1501140045, 1501140046, 1501140047]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1949,
        block_hash: [0x9e3b52f5, 0xcebe5c28, 0x31f24b19, 0xc7e4dd44, 0x4ff8e0c8, 0x160dacf6, 0x0ca5cbf8, 0xcf5f0500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3c00,
        block_height: 1949,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140039, 1501140040, 1501140041, 1501140042, 1501140043, 1501140044, 1501140045, 1501140046, 1501140047, 1501140048]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1950,
        block_hash: [0x0301dcae, 0xde833b6c, 0xd3ac8826, 0x7ab1edcc, 0x4cd8c9c7, 0x86dc5b0a, 0x35ec15d8, 0x19481200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3e00,
        block_height: 1950,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140040, 1501140041, 1501140042, 1501140043, 1501140044, 1501140045, 1501140046, 1501140047, 1501140048, 1501140049]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1951,
        block_hash: [0x5c155301, 0xabc3ed59, 0x1f47492f, 0xa3c03c11, 0x3f2f8af5, 0x14aff319, 0x6ec55d15, 0x994c6a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4000,
        block_height: 1951,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140041, 1501140042, 1501140043, 1501140044, 1501140045, 1501140046, 1501140047, 1501140048, 1501140049, 1501140050]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1952,
        block_hash: [0x7d886c43, 0x64fdc6e3, 0x1729b15e, 0x303b15a4, 0x7ea8889c, 0xff73ee71, 0xfcbe158b, 0x0b416d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4200,
        block_height: 1952,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140042, 1501140043, 1501140044, 1501140045, 1501140046, 1501140047, 1501140048, 1501140049, 1501140050, 1501140051]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1953,
        block_hash: [0xc7dfcd9d, 0x08c4c047, 0x99252bb4, 0xef7d7e29, 0x17626a81, 0xbe2c8eb0, 0x94abc6d2, 0x755c7900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4400,
        block_height: 1953,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140043, 1501140044, 1501140045, 1501140046, 1501140047, 1501140048, 1501140049, 1501140050, 1501140051, 1501140052]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1954,
        block_hash: [0x2fc653c2, 0xdcadc395, 0x645bef40, 0xd7a64929, 0x19b97b47, 0xbae3b611, 0x8e2ee8d6, 0x3df26800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4600,
        block_height: 1954,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140044, 1501140045, 1501140046, 1501140047, 1501140048, 1501140049, 1501140050, 1501140051, 1501140052, 1501140053]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1955,
        block_hash: [0x9368e7a5, 0x6526d53a, 0xfec6d8fd, 0x5c8c3964, 0x8455536b, 0x1cc9adf8, 0x19953b18, 0xdc3a3a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4800,
        block_height: 1955,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140045, 1501140046, 1501140047, 1501140048, 1501140049, 1501140050, 1501140051, 1501140052, 1501140053, 1501140054]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1956,
        block_hash: [0xd45651b1, 0xa58defe1, 0xd143f878, 0xd160e9d5, 0x907cb653, 0x51c6d5db, 0x6d43eb13, 0x29632b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4a00,
        block_height: 1956,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140046, 1501140047, 1501140048, 1501140049, 1501140050, 1501140051, 1501140052, 1501140053, 1501140054, 1501140055]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1957,
        block_hash: [0x63c5d5cd, 0x9a3cdd12, 0xbdc3de9c, 0x0618e38e, 0x7d3d20be, 0x5e1e0f7e, 0xfabd262d, 0x2e271800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4c00,
        block_height: 1957,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140047, 1501140048, 1501140049, 1501140050, 1501140051, 1501140052, 1501140053, 1501140054, 1501140055, 1501140056]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1958,
        block_hash: [0x58bb2e19, 0x24870a15, 0x3728f19c, 0x8188787b, 0x84bc5838, 0x5c510a8e, 0xa282316c, 0x49983000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4e00,
        block_height: 1958,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140048, 1501140049, 1501140050, 1501140051, 1501140052, 1501140053, 1501140054, 1501140055, 1501140056, 1501140057]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1959,
        block_hash: [0xb4a6d257, 0xc1550b8f, 0xdb7c86bb, 0x171954d9, 0x6ab0824c, 0xd703586f, 0x960cbd54, 0xb4e77b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5000,
        block_height: 1959,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140049, 1501140050, 1501140051, 1501140052, 1501140053, 1501140054, 1501140055, 1501140056, 1501140057, 1501140058]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1960,
        block_hash: [0x698fd83d, 0x319cf2b1, 0x39895e64, 0x593f837e, 0x0dd6fc09, 0x943e89e3, 0x728efcb7, 0x58366c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5200,
        block_height: 1960,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140050, 1501140051, 1501140052, 1501140053, 1501140054, 1501140055, 1501140056, 1501140057, 1501140058, 1501140059]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1961,
        block_hash: [0x431864e6, 0x6cbff18f, 0x01c7a37a, 0x253063b9, 0x0ebbfeaa, 0x440a4892, 0x7eb25f87, 0x17f27500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5400,
        block_height: 1961,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140051, 1501140052, 1501140053, 1501140054, 1501140055, 1501140056, 1501140057, 1501140058, 1501140059, 1501140060]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1962,
        block_hash: [0xddeeffce, 0x6ac75164, 0x50a29844, 0x59670938, 0x63c95ce3, 0x420b9209, 0x01c44e82, 0xf39c2b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5600,
        block_height: 1962,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140052, 1501140053, 1501140054, 1501140055, 1501140056, 1501140057, 1501140058, 1501140059, 1501140060, 1501140061]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1963,
        block_hash: [0xfae31133, 0xed920d22, 0x9bcc3868, 0x7461d47e, 0x538a6ac8, 0x9f6646c7, 0x20d615c0, 0x5ed15400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5800,
        block_height: 1963,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140053, 1501140054, 1501140055, 1501140056, 1501140057, 1501140058, 1501140059, 1501140060, 1501140061, 1501140062]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1964,
        block_hash: [0xc137822c, 0x542997cf, 0x04bc91ad, 0x92586aa6, 0x25561d0b, 0x068144b3, 0xc373b186, 0x9fd37700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5a00,
        block_height: 1964,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140054, 1501140055, 1501140056, 1501140057, 1501140058, 1501140059, 1501140060, 1501140061, 1501140062, 1501140063]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1965,
        block_hash: [0xefc50ba8, 0xab1e8d3c, 0x8f966b63, 0x87b79f38, 0xc0fa8314, 0x1455a100, 0x5a4f8a99, 0x17792000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5c00,
        block_height: 1965,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140055, 1501140056, 1501140057, 1501140058, 1501140059, 1501140060, 1501140061, 1501140062, 1501140063, 1501140064]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1966,
        block_hash: [0xa3bec3a1, 0x810031cb, 0x9a523dc9, 0xc781e5eb, 0x087816fd, 0xa0d73fd4, 0x945180d0, 0x84746c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5e00,
        block_height: 1966,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140056, 1501140057, 1501140058, 1501140059, 1501140060, 1501140061, 1501140062, 1501140063, 1501140064, 1501140065]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1967,
        block_hash: [0xf9c84d22, 0x256f7bbd, 0x73dfb6bc, 0xf2307c85, 0x8c96b835, 0x926543d8, 0xd4297476, 0x56201f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6000,
        block_height: 1967,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140057, 1501140058, 1501140059, 1501140060, 1501140061, 1501140062, 1501140063, 1501140064, 1501140065, 1501140066]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1968,
        block_hash: [0x4f49d55b, 0x4331e7d7, 0x3c3bd019, 0x4bee7798, 0xa48f1c91, 0xd1f04f43, 0x30a060a0, 0x001c0300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6200,
        block_height: 1968,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140058, 1501140059, 1501140060, 1501140061, 1501140062, 1501140063, 1501140064, 1501140065, 1501140066, 1501140067]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1969,
        block_hash: [0xcf7540d5, 0xfaf93163, 0xc03e0d2b, 0x8c0fe65c, 0xa6c18841, 0x2133ae70, 0xcf19b380, 0x5a7a2800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6400,
        block_height: 1969,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140059, 1501140060, 1501140061, 1501140062, 1501140063, 1501140064, 1501140065, 1501140066, 1501140067, 1501140068]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1970,
        block_hash: [0x7155c194, 0x3bedbea2, 0xbb5968fe, 0x48f54914, 0xdbb8a1e5, 0xa270d7c5, 0xdff36614, 0xc35f1f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6600,
        block_height: 1970,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140060, 1501140061, 1501140062, 1501140063, 1501140064, 1501140065, 1501140066, 1501140067, 1501140068, 1501140069]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1971,
        block_hash: [0x4aac6ebf, 0x81369f17, 0x16916797, 0xdaac4275, 0xad454e65, 0x82fdd7d3, 0xf175255d, 0x8ea05f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6800,
        block_height: 1971,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140061, 1501140062, 1501140063, 1501140064, 1501140065, 1501140066, 1501140067, 1501140068, 1501140069, 1501140070]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1972,
        block_hash: [0x862a6c96, 0x1b6cd19f, 0x26e32334, 0xde0265ea, 0x83cac387, 0x5198256b, 0x2c13ffe2, 0x348b5400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6a00,
        block_height: 1972,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140062, 1501140063, 1501140064, 1501140065, 1501140066, 1501140067, 1501140068, 1501140069, 1501140070, 1501140071]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1973,
        block_hash: [0x915a1607, 0x6d62386b, 0xa937aeba, 0x0c022f04, 0x24afd43a, 0x9eb49563, 0xf5f76af7, 0x04536100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6c00,
        block_height: 1973,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140063, 1501140064, 1501140065, 1501140066, 1501140067, 1501140068, 1501140069, 1501140070, 1501140071, 1501140072]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1974,
        block_hash: [0x311c5d24, 0x502874ab, 0x5b5f99f6, 0xf3112aad, 0x170e7bc0, 0xe4b5012b, 0x16e713df, 0x7f127200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6e00,
        block_height: 1974,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140064, 1501140065, 1501140066, 1501140067, 1501140068, 1501140069, 1501140070, 1501140071, 1501140072, 1501140073]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1975,
        block_hash: [0xcc744cc1, 0x656ccfd6, 0x8d903327, 0x974ed6e5, 0x03d41815, 0xe7adfb19, 0xb5a13d9a, 0xe9ba5300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7000,
        block_height: 1975,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140065, 1501140066, 1501140067, 1501140068, 1501140069, 1501140070, 1501140071, 1501140072, 1501140073, 1501140074]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1976,
        block_hash: [0x57b311d3, 0xf13738da, 0x2cfde58b, 0x7f5171b2, 0x54aa2014, 0xa6fc2202, 0xd1340d73, 0x21cf4700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7200,
        block_height: 1976,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140066, 1501140067, 1501140068, 1501140069, 1501140070, 1501140071, 1501140072, 1501140073, 1501140074, 1501140075]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1977,
        block_hash: [0xe4e6a189, 0xdb0f8042, 0x6bf9c6fe, 0x92d6b119, 0x4645f629, 0xd87f53da, 0xb3f0376d, 0x1cce0200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7400,
        block_height: 1977,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140067, 1501140068, 1501140069, 1501140070, 1501140071, 1501140072, 1501140073, 1501140074, 1501140075, 1501140076]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1978,
        block_hash: [0x4c983ae4, 0xf7dc20ba, 0x6c0147cb, 0xcb0c2e44, 0xafde2a3f, 0x08f8c9c6, 0x74f00c50, 0x9f3a7f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7600,
        block_height: 1978,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140068, 1501140069, 1501140070, 1501140071, 1501140072, 1501140073, 1501140074, 1501140075, 1501140076, 1501140077]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1979,
        block_hash: [0x865da117, 0x8f1aca0f, 0xdbe78a97, 0x4c05d29b, 0xdac6612d, 0x032c6296, 0x47c26c6b, 0xce522300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7800,
        block_height: 1979,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140069, 1501140070, 1501140071, 1501140072, 1501140073, 1501140074, 1501140075, 1501140076, 1501140077, 1501140078]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1980,
        block_hash: [0xf094813a, 0xc0c349ec, 0x25c2cb96, 0x97f1a876, 0xde76d058, 0x6cc00cae, 0x6a86a10f, 0xcb766700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7a00,
        block_height: 1980,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140070, 1501140071, 1501140072, 1501140073, 1501140074, 1501140075, 1501140076, 1501140077, 1501140078, 1501140079]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1981,
        block_hash: [0x47a39968, 0x0506b418, 0x8ec13f1d, 0x66b7d8d5, 0xd876dc8f, 0xcfb542e4, 0x7d1040f1, 0x55235b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7c00,
        block_height: 1981,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140071, 1501140072, 1501140073, 1501140074, 1501140075, 1501140076, 1501140077, 1501140078, 1501140079, 1501140080]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1982,
        block_hash: [0x04d8c8e4, 0xcf73dda2, 0x10bd581b, 0x26fd59f5, 0x89a895a2, 0x44fd9b1d, 0xcb8849c6, 0xc55d2400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7e00,
        block_height: 1982,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140072, 1501140073, 1501140074, 1501140075, 1501140076, 1501140077, 1501140078, 1501140079, 1501140080, 1501140081]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1983,
        block_hash: [0x7c7bd06a, 0x90025c02, 0x20e60d99, 0xdb4b95c2, 0x3b0f7e59, 0x88bf208e, 0x1afbe9fe, 0xab707f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8000,
        block_height: 1983,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140073, 1501140074, 1501140075, 1501140076, 1501140077, 1501140078, 1501140079, 1501140080, 1501140081, 1501140082]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1984,
        block_hash: [0xa8a84653, 0xf631608f, 0x3f25a98d, 0xfbbb25d9, 0x9a182494, 0x074301ff, 0x688347e9, 0x42f36e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8200,
        block_height: 1984,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140074, 1501140075, 1501140076, 1501140077, 1501140078, 1501140079, 1501140080, 1501140081, 1501140082, 1501140083]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1985,
        block_hash: [0x52757d41, 0x5bb966c3, 0xa393055a, 0x9db65ce3, 0x85dce94a, 0x8227b00b, 0x3921c1be, 0xec654f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8400,
        block_height: 1985,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140075, 1501140076, 1501140077, 1501140078, 1501140079, 1501140080, 1501140081, 1501140082, 1501140083, 1501140084]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1986,
        block_hash: [0x36d9b1a4, 0x8819d207, 0xed96dfb3, 0x95a2dad8, 0x96c926a4, 0x689a773d, 0xdf7a835b, 0x55ee3500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8600,
        block_height: 1986,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140076, 1501140077, 1501140078, 1501140079, 1501140080, 1501140081, 1501140082, 1501140083, 1501140084, 1501140085]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1987,
        block_hash: [0x1fede42a, 0x6604ad13, 0x820b642b, 0xdcf16bba, 0x2ce3e638, 0x8ab92650, 0xf2ed8387, 0xf22e4400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8800,
        block_height: 1987,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140077, 1501140078, 1501140079, 1501140080, 1501140081, 1501140082, 1501140083, 1501140084, 1501140085, 1501140086]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1988,
        block_hash: [0x62245cb9, 0xbf96e6ea, 0x744f7e84, 0x4a7eb97d, 0x345745ab, 0xa7fa7f5d, 0x9574b294, 0x69512d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8a00,
        block_height: 1988,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140078, 1501140079, 1501140080, 1501140081, 1501140082, 1501140083, 1501140084, 1501140085, 1501140086, 1501140087]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1989,
        block_hash: [0x1d3974a0, 0x173c3323, 0x18242ef2, 0x4a6b4b73, 0x173c4e99, 0x09bd8a00, 0xae28fa7c, 0xd9453000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8c00,
        block_height: 1989,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140079, 1501140080, 1501140081, 1501140082, 1501140083, 1501140084, 1501140085, 1501140086, 1501140087, 1501140088]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1990,
        block_hash: [0x6a402e14, 0xf57f38ae, 0x39aa659d, 0x983b4141, 0x40923db2, 0xb4ec5d18, 0x9149e7d7, 0x241c7700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8e00,
        block_height: 1990,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140080, 1501140081, 1501140082, 1501140083, 1501140084, 1501140085, 1501140086, 1501140087, 1501140088, 1501140089]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1991,
        block_hash: [0x1d8f193f, 0x81807f06, 0x5ce3529c, 0x01769b85, 0x25bcaa38, 0xa1ab9043, 0xe58610ad, 0x499f7100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9000,
        block_height: 1991,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140081, 1501140082, 1501140083, 1501140084, 1501140085, 1501140086, 1501140087, 1501140088, 1501140089, 1501140090]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1992,
        block_hash: [0xf76da9b1, 0x2086c7c6, 0x018c3705, 0xddc73d38, 0x21861619, 0x6062a87c, 0x97c9303c, 0x4a472c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9200,
        block_height: 1992,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140082, 1501140083, 1501140084, 1501140085, 1501140086, 1501140087, 1501140088, 1501140089, 1501140090, 1501140091]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1993,
        block_hash: [0x6cdc3530, 0x45ecbd76, 0x28d04290, 0xf5a39e83, 0x68998e26, 0xa299be6e, 0x94ba19df, 0x44a36300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9400,
        block_height: 1993,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140083, 1501140084, 1501140085, 1501140086, 1501140087, 1501140088, 1501140089, 1501140090, 1501140091, 1501140092]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1994,
        block_hash: [0x5557c0b9, 0xa6a51328, 0xcf56535b, 0x4e3da77b, 0xa6831e2f, 0x53eee90a, 0xe0e5c6e2, 0x44915700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9600,
        block_height: 1994,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140084, 1501140085, 1501140086, 1501140087, 1501140088, 1501140089, 1501140090, 1501140091, 1501140092, 1501140093]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1995,
        block_hash: [0x2fdbc432, 0x665c51f6, 0x6f4c435e, 0x582467ed, 0xc9dc6f50, 0x5d88a209, 0x079a8483, 0x625e4900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9800,
        block_height: 1995,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140085, 1501140086, 1501140087, 1501140088, 1501140089, 1501140090, 1501140091, 1501140092, 1501140093, 1501140094]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1996,
        block_hash: [0x2eaec321, 0x981e6270, 0x09f8d08f, 0x375c1c4c, 0xec2b9920, 0x64577407, 0x4a936293, 0x1e0c7600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9a00,
        block_height: 1996,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140086, 1501140087, 1501140088, 1501140089, 1501140090, 1501140091, 1501140092, 1501140093, 1501140094, 1501140095]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1997,
        block_hash: [0xf511e787, 0x58056912, 0x39d125aa, 0x3404d909, 0x14cd1add, 0x4f9dbe4d, 0xc795945b, 0x89ea2a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9c00,
        block_height: 1997,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140087, 1501140088, 1501140089, 1501140090, 1501140091, 1501140092, 1501140093, 1501140094, 1501140095, 1501140096]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1998,
        block_hash: [0x32e09796, 0xd4b41325, 0x70fed417, 0x5372cb4e, 0x0ec81e35, 0xef7f0614, 0xd9d8e9f0, 0x84dc0f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9e00,
        block_height: 1998,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140088, 1501140089, 1501140090, 1501140091, 1501140092, 1501140093, 1501140094, 1501140095, 1501140096, 1501140097]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1999,
        block_hash: [0xcd59576a, 0x9e0241c1, 0x132df6be, 0x36c5d650, 0x32691a77, 0x2ea68056, 0x942f74c3, 0xb2cd4b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa000,
        block_height: 1999,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140089, 1501140090, 1501140091, 1501140092, 1501140093, 1501140094, 1501140095, 1501140096, 1501140097, 1501140098]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2000,
        block_hash: [0x83f04343, 0xbd6da67a, 0x1c9a296c, 0x97713024, 0xfd2bbd85, 0xa54bd2cc, 0xe068ad66, 0x65cd7f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa200,
        block_height: 2000,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140090, 1501140091, 1501140092, 1501140093, 1501140094, 1501140095, 1501140096, 1501140097, 1501140098, 1501140099]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2001,
        block_hash: [0x462ba230, 0xe2009a21, 0x20a66ccf, 0xb7e4ee9f, 0xc1eafbd5, 0x03a661bb, 0xd6a6b79e, 0x4c121b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa400,
        block_height: 2001,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140091, 1501140092, 1501140093, 1501140094, 1501140095, 1501140096, 1501140097, 1501140098, 1501140099, 1501140100]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2002,
        block_hash: [0x01593dd3, 0x25cc381e, 0x05bc7549, 0x80425ff1, 0x5a278128, 0x5f28d47d, 0x60f9368b, 0x660d5400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa600,
        block_height: 2002,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140092, 1501140093, 1501140094, 1501140095, 1501140096, 1501140097, 1501140098, 1501140099, 1501140100, 1501140101]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2003,
        block_hash: [0x119ea803, 0x009cedde, 0xf788c236, 0x41b0949e, 0xbd4995b9, 0x08c2d6d7, 0xb53888f7, 0x93c96200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa800,
        block_height: 2003,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140093, 1501140094, 1501140095, 1501140096, 1501140097, 1501140098, 1501140099, 1501140100, 1501140101, 1501140102]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2004,
        block_hash: [0xf2fa166b, 0x1d093090, 0xf434539f, 0x6f038110, 0x3269ed3b, 0xa5052c0c, 0xb5844638, 0xc41a5400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000faa00,
        block_height: 2004,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140094, 1501140095, 1501140096, 1501140097, 1501140098, 1501140099, 1501140100, 1501140101, 1501140102, 1501140103]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2005,
        block_hash: [0x0697cdbb, 0x10cd7090, 0xd1573e7f, 0x45906f49, 0xba249e8f, 0x17da6495, 0xe5489a56, 0xf6fa6000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fac00,
        block_height: 2005,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140095, 1501140096, 1501140097, 1501140098, 1501140099, 1501140100, 1501140101, 1501140102, 1501140103, 1501140104]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2006,
        block_hash: [0xb632718f, 0xb340923f, 0x2241558e, 0xb53b78c3, 0xdf2df23f, 0x99df6031, 0x87b4ef79, 0xfe694000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fae00,
        block_height: 2006,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140096, 1501140097, 1501140098, 1501140099, 1501140100, 1501140101, 1501140102, 1501140103, 1501140104, 1501140105]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2007,
        block_hash: [0xbc836049, 0xa4d9b069, 0xee8906bb, 0xa3a8e47f, 0x18e51134, 0xa7f37239, 0x2886f2a8, 0x5e187f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb000,
        block_height: 2007,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140097, 1501140098, 1501140099, 1501140100, 1501140101, 1501140102, 1501140103, 1501140104, 1501140105, 1501140106]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2008,
        block_hash: [0x686881ad, 0xca4c8526, 0xe0493539, 0x6a3a568b, 0x595d8dae, 0x16d7f2f3, 0xb6830f8d, 0x1c012800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb200,
        block_height: 2008,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140098, 1501140099, 1501140100, 1501140101, 1501140102, 1501140103, 1501140104, 1501140105, 1501140106, 1501140107]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2009,
        block_hash: [0xa214e7c9, 0x57225a84, 0xb9d3b8cf, 0x9656aa7d, 0xacc9b10e, 0x75d861d7, 0x2a6ed653, 0x68830f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb400,
        block_height: 2009,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140099, 1501140100, 1501140101, 1501140102, 1501140103, 1501140104, 1501140105, 1501140106, 1501140107, 1501140108]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2010,
        block_hash: [0x4696cb78, 0xf3ab0c18, 0xdc6135fd, 0x339d90cb, 0xf99c94e8, 0x8f4ec607, 0x7b161fed, 0x25c05400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb600,
        block_height: 2010,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140100, 1501140101, 1501140102, 1501140103, 1501140104, 1501140105, 1501140106, 1501140107, 1501140108, 1501140109]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2011,
        block_hash: [0xd1f54732, 0x3a853936, 0xd58e38ac, 0x15db01a4, 0x5ac0981a, 0xc0e3bdd6, 0x085601e8, 0xe5381b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb800,
        block_height: 2011,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140101, 1501140102, 1501140103, 1501140104, 1501140105, 1501140106, 1501140107, 1501140108, 1501140109, 1501140110]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2012,
        block_hash: [0xb6207c4d, 0x7b1bccf9, 0xe4485121, 0xc5b532f8, 0x91f32787, 0x5db2ce5d, 0x47651a62, 0x0d640700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fba00,
        block_height: 2012,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140102, 1501140103, 1501140104, 1501140105, 1501140106, 1501140107, 1501140108, 1501140109, 1501140110, 1501140111]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2013,
        block_hash: [0x2d5d998b, 0x9512bbca, 0xe3ce419e, 0xa124dd54, 0xd418ed0b, 0xc415088e, 0xc5522d5a, 0xcc747800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fbc00,
        block_height: 2013,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140103, 1501140104, 1501140105, 1501140106, 1501140107, 1501140108, 1501140109, 1501140110, 1501140111, 1501140112]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2014,
        block_hash: [0xeb5c38fa, 0xfb5e795f, 0x9a2317d5, 0x24c4ab63, 0x38a2d356, 0x42088cdf, 0x8333bd64, 0xc8bc5000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fbe00,
        block_height: 2014,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140104, 1501140105, 1501140106, 1501140107, 1501140108, 1501140109, 1501140110, 1501140111, 1501140112, 1501140113]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2015,
        block_hash: [0xd8104fa2, 0x72c9d843, 0x2f3d12d6, 0xdbf332f1, 0x41ba30d6, 0x4778be68, 0x52c0aa03, 0x4b0d4000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc000,
        block_height: 2015,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140105, 1501140106, 1501140107, 1501140108, 1501140109, 1501140110, 1501140111, 1501140112, 1501140113, 1501140114]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2016,
        block_hash: [0x06a84211, 0x4ad0b986, 0xb91079d4, 0x6a934424, 0x2cccf144, 0xbe7b2b9c, 0x9e6ff93a, 0xfbd93800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc21f,
        block_height: 2016,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140106, 1501140107, 1501140108, 1501140109, 1501140110, 1501140111, 1501140112, 1501140113, 1501140114, 1501140115]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2017,
        block_hash: [0xf4782d9f, 0x8c0327b2, 0x8bcd43fc, 0xaca9b61c, 0xf6ea3a68, 0x1cff2f69, 0x16efb94b, 0x1eae0a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc43e,
        block_height: 2017,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140107, 1501140108, 1501140109, 1501140110, 1501140111, 1501140112, 1501140113, 1501140114, 1501140115, 1501140116]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2018,
        block_hash: [0xd79fa1d9, 0xe9bf4e79, 0x02443b62, 0xa8ad4a18, 0xe8173df0, 0x2459f458, 0xf9afc36b, 0x82920a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc65d,
        block_height: 2018,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140108, 1501140109, 1501140110, 1501140111, 1501140112, 1501140113, 1501140114, 1501140115, 1501140116, 1501140117]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2019,
        block_hash: [0x6f65e35b, 0x6ce71247, 0x5160c8ad, 0x1741d91d, 0x100c756e, 0xf257ee60, 0x75d3a15b, 0xb2b82b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc87c,
        block_height: 2019,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140109, 1501140110, 1501140111, 1501140112, 1501140113, 1501140114, 1501140115, 1501140116, 1501140117, 1501140118]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2020,
        block_hash: [0xfd378487, 0xe99a8fc6, 0x7e38363f, 0xd4cd5a63, 0xf4459105, 0x5b3d05fa, 0xedfcd8c3, 0xcf171900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fca9b,
        block_height: 2020,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140110, 1501140111, 1501140112, 1501140113, 1501140114, 1501140115, 1501140116, 1501140117, 1501140118, 1501140119]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2021,
        block_hash: [0x35eaa69a, 0xb9c2cf2b, 0xc4892241, 0x522e6b26, 0xbbf80fa3, 0x4feb9a03, 0x6aecebd6, 0x0c294300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fccba,
        block_height: 2021,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140111, 1501140112, 1501140113, 1501140114, 1501140115, 1501140116, 1501140117, 1501140118, 1501140119, 1501140120]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2022,
        block_hash: [0xefb885b8, 0xd05816ff, 0x76fd66a3, 0x19b67c43, 0x125f0733, 0xd235e550, 0xf3a42efe, 0xfc195600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fced9,
        block_height: 2022,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140112, 1501140113, 1501140114, 1501140115, 1501140116, 1501140117, 1501140118, 1501140119, 1501140120, 1501140121]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2023,
        block_hash: [0x0a89746f, 0x043bef15, 0x13b47918, 0x4b823a7c, 0xb1477542, 0x36d0768b, 0x1eaee070, 0x129b7300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd0f8,
        block_height: 2023,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140113, 1501140114, 1501140115, 1501140116, 1501140117, 1501140118, 1501140119, 1501140120, 1501140121, 1501140122]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2024,
        block_hash: [0x7a9a5735, 0x59cc1727, 0x493f8297, 0xc21058e9, 0xcc206c97, 0x9cd763fb, 0x1af57702, 0x302e4200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd317,
        block_height: 2024,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140114, 1501140115, 1501140116, 1501140117, 1501140118, 1501140119, 1501140120, 1501140121, 1501140122, 1501140123]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2025,
        block_hash: [0x61309750, 0xf4b148ec, 0xb8ad074f, 0xcc728e6b, 0x4f9889a0, 0x6063ec64, 0x01ec178c, 0xccf80400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd536,
        block_height: 2025,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140115, 1501140116, 1501140117, 1501140118, 1501140119, 1501140120, 1501140121, 1501140122, 1501140123, 1501140124]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2026,
        block_hash: [0xda61f2e8, 0x3ad683e7, 0xe11e5eed, 0xebbb2c98, 0x79e795b3, 0xc4524d4e, 0x5d914978, 0x292f6500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd755,
        block_height: 2026,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140116, 1501140117, 1501140118, 1501140119, 1501140120, 1501140121, 1501140122, 1501140123, 1501140124, 1501140125]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2027,
        block_hash: [0x74e4a487, 0x0590d6ff, 0xfcf9e3c0, 0x65d928da, 0x40ff27ab, 0xf431dd01, 0x6a3363ed, 0x1af32100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd974,
        block_height: 2027,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140117, 1501140118, 1501140119, 1501140120, 1501140121, 1501140122, 1501140123, 1501140124, 1501140125, 1501140126]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2028,
        block_hash: [0x5b56e7a8, 0x71ec9b96, 0x18eb19a2, 0xb5a395b4, 0x29430157, 0xe3bec3f8, 0x068da1c5, 0xa7005a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fdb93,
        block_height: 2028,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140118, 1501140119, 1501140120, 1501140121, 1501140122, 1501140123, 1501140124, 1501140125, 1501140126, 1501140127]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2029,
        block_hash: [0x247f7081, 0xbaef9d6b, 0xdeee61d4, 0xc5af703d, 0xf65371c7, 0xf07311ce, 0x648229be, 0xa1515200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fddb2,
        block_height: 2029,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140119, 1501140120, 1501140121, 1501140122, 1501140123, 1501140124, 1501140125, 1501140126, 1501140127, 1501140128]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2030,
        block_hash: [0x918a6879, 0x17bb64a8, 0x0f39c1d6, 0x467012af, 0xc4f55647, 0xd3577f1d, 0xa416024f, 0xf7a06100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fdfd1,
        block_height: 2030,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140120, 1501140121, 1501140122, 1501140123, 1501140124, 1501140125, 1501140126, 1501140127, 1501140128, 1501140129]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2031,
        block_hash: [0xa6b58aac, 0x65fe890f, 0x90718443, 0x7ab167b3, 0x9cb99309, 0x0c4571d0, 0xd19ddbec, 0x74422e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fe1f0,
        block_height: 2031,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140121, 1501140122, 1501140123, 1501140124, 1501140125, 1501140126, 1501140127, 1501140128, 1501140129, 1501140130]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2032,
        block_hash: [0xb11172ef, 0xa39d8abe, 0xfded72ab, 0xdc8d593b, 0xb3955cad, 0x7ddf01b3, 0xfb30e460, 0x96c81600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fe40f,
        block_height: 2032,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140122, 1501140123, 1501140124, 1501140125, 1501140126, 1501140127, 1501140128, 1501140129, 1501140130, 1501140131]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2033,
        block_hash: [0x1c8fa87b, 0x51177fc3, 0x293570fb, 0xc22b47f5, 0x25393727, 0x7061d1a7, 0x38e58451, 0x91e66200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fe62e,
        block_height: 2033,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140123, 1501140124, 1501140125, 1501140126, 1501140127, 1501140128, 1501140129, 1501140130, 1501140131, 1501140132]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2034,
        block_hash: [0x3e492b25, 0x597664a5, 0x46fb6810, 0x67e161b9, 0xe4e3c5c7, 0x5d51224a, 0xbbb47b6d, 0xa6be4900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fe84d,
        block_height: 2034,
        last_diff_adjustment: 1501140116,
        prev_block_timestamps: [1501140124, 1501140125, 1501140126, 1501140127, 1501140128, 1501140129, 1501140130, 1501140131, 1501140132, 1501140133]
    },
];
