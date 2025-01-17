use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::StoredBlockHeader;

pub const TIMESTAMP: u64 = 1700000000;

const BLOCKHEADER_1900: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x89670c2b, 0x658ea886, 0xf8123f0b, 0x287f38c1, 0x8e9a374a, 0xdeb2f13b, 0x7ca393aa, 0xdff10500],
    merkle_root: [0xb7d4f606, 0x6b497024, 0x9656faa3, 0xc88225c5, 0x57d3b36d, 0xaf2aa7b3, 0xd300f3bb, 0x4155f6af],
    reversed_timestamp: 0x20947959,
    nbits: 0xffff7f1f,
    nonce: 0x00000445
};
const BLOCKHEADER_1901: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf0bfd844, 0x0b47361e, 0x2610cab7, 0x417d1887, 0x4a18ff8a, 0x47b9b555, 0xe828f619, 0x80d21200],
    merkle_root: [0x597d40f7, 0x0c62805e, 0x2e28b3b2, 0x37062af0, 0xb19d8fb6, 0x460ddf3a, 0x7584fa35, 0x19e5468c],
    reversed_timestamp: 0x809d7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000119
};
const BLOCKHEADER_1902: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1ed10ae1, 0xfbe16914, 0x2bc7a517, 0x9955d084, 0xf594931b, 0x96f9ff11, 0x7aa1226e, 0xfac25f00],
    merkle_root: [0x72b30be4, 0x96b99a3b, 0xc7a08a49, 0x0fd7e44c, 0xafc98d39, 0x44038afe, 0x27546aee, 0xa8c983d8],
    reversed_timestamp: 0xe0a67959,
    nbits: 0xffff7f1f,
    nonce: 0x000000e5
};
const BLOCKHEADER_1903: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf199ae85, 0x0f8f2a7a, 0xce8baac2, 0x6dee70fd, 0x7c5e588e, 0xdbdd9c1c, 0xe4399e3b, 0x4c223600],
    merkle_root: [0xd94308b9, 0x516d30dc, 0x662ec866, 0x037a84a1, 0xf1099e90, 0xf715afda, 0x5b1bfc65, 0x7961b7be],
    reversed_timestamp: 0x40b07959,
    nbits: 0xffff7f1f,
    nonce: 0x00000006
};
const BLOCKHEADER_1904: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x34a8960e, 0x78ca201d, 0xd3a3ef21, 0x95cd4033, 0x168845af, 0xfa5be269, 0x1bf09042, 0x2a800f00],
    merkle_root: [0x714b9fe8, 0x875d5a14, 0x8ec30e27, 0xb34db36d, 0x605d8a8a, 0xb7811055, 0x1ba3cca4, 0x632fa64d],
    reversed_timestamp: 0xa0b97959,
    nbits: 0xffff7f1f,
    nonce: 0x000001be
};
const BLOCKHEADER_1905: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x01f88da3, 0x725b17e3, 0x1fa73cf3, 0x40018835, 0xcd911f7f, 0xa419344a, 0xce622ac7, 0x51060200],
    merkle_root: [0x29639348, 0xb8b420a9, 0x2f7fc530, 0x4e385058, 0xa85234f6, 0x43e880d0, 0xf236d666, 0x6a2eb3b7],
    reversed_timestamp: 0x00c37959,
    nbits: 0xffff7f1f,
    nonce: 0x000000b9
};
const BLOCKHEADER_1906: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x071884c2, 0x3a226d94, 0x8580f2b8, 0xfb453b1b, 0x561488f6, 0xf796379f, 0x8e934ca6, 0x011d1000],
    merkle_root: [0x280a4a0f, 0x92d46cbe, 0x5eec55c0, 0x4182c818, 0xba6cbfae, 0xc9b452dd, 0x8b7e94f7, 0x98b96c8e],
    reversed_timestamp: 0x60cc7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000052
};
const BLOCKHEADER_1907: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x82846a45, 0xdbdd082c, 0xb553b9ee, 0xcd36ac8d, 0xca3bea60, 0x8e9651ff, 0x43f75aaf, 0x1b1e6100],
    merkle_root: [0xcd74cb74, 0x49ac6b22, 0x4b6c8464, 0x6a24ee0c, 0x86c63d2b, 0xdbdd3797, 0x0107c73b, 0xee69e20a],
    reversed_timestamp: 0xc0d57959,
    nbits: 0xffff7f1f,
    nonce: 0x0000070c
};
const BLOCKHEADER_1908: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xea617eb0, 0x9061f36d, 0xf6792697, 0x27798722, 0x7efd5d29, 0xf9d8d610, 0x0394a6bd, 0xdec37000],
    merkle_root: [0xd20e072d, 0x1f29f270, 0x672937b2, 0x6d917261, 0x1070b836, 0x30e1a964, 0xfc914826, 0xe5faf22b],
    reversed_timestamp: 0x20df7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000107
};
const BLOCKHEADER_1909: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa4a84963, 0x35f16ce7, 0x79a673b5, 0xb20809db, 0x9554a47c, 0xc8f2a797, 0xca348943, 0xcb667e00],
    merkle_root: [0xc2a77d3b, 0x4d1163cb, 0xcce10adf, 0x9e88dfca, 0x3a470ca3, 0x50b8913a, 0x2265c423, 0x6d0eef83],
    reversed_timestamp: 0x80e87959,
    nbits: 0xffff7f1f,
    nonce: 0x000000b6
};
const BLOCKHEADER_1910: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4b9f188a, 0x1b9fdc9e, 0xe180858c, 0x141701ca, 0x43eae170, 0x42b983de, 0x7fdb7f28, 0x96725200],
    merkle_root: [0xdab0a2df, 0x202fe97e, 0x4f5b9bb8, 0x2bb8071b, 0x0b514035, 0xde2b5eac, 0xbb56cca5, 0xaba673f5],
    reversed_timestamp: 0xe0f17959,
    nbits: 0xffff7f1f,
    nonce: 0x00000452
};
const BLOCKHEADER_1911: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc28fe42f, 0x43fe5d09, 0x18b72e5e, 0x2ffec8b8, 0x772a924a, 0x8f7f7fd1, 0xf7e7ae7e, 0x4b787f00],
    merkle_root: [0x4241f7da, 0xa194b1f5, 0x59e656ac, 0x6276443e, 0xd12e00c2, 0xc6e87c2a, 0xdfb2f427, 0xd8e84968],
    reversed_timestamp: 0x40fb7959,
    nbits: 0xffff7f1f,
    nonce: 0x000001f9
};
const BLOCKHEADER_1912: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xca9db28f, 0xb28efc2a, 0xb7737497, 0x979af69d, 0x5a1cd8eb, 0xc7229b69, 0x9ef469a9, 0x7a633900],
    merkle_root: [0x4ac1ac42, 0x7c4fb36c, 0x51e58d6b, 0x2d13900e, 0xced208ac, 0x8a885cae, 0x24b14578, 0x487ff8ea],
    reversed_timestamp: 0xa0047a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000102
};
const BLOCKHEADER_1913: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x92281e0e, 0x63c0c9c0, 0x7c5732dc, 0xb26ec9e5, 0x3d007b3e, 0x06e9d5ad, 0xb6c2186a, 0xe0861300],
    merkle_root: [0xe7e8b275, 0xcab82e97, 0x1e16a6eb, 0xb93a48ff, 0x09cf83a2, 0x71e4a079, 0xb2dcc1db, 0xae0de525],
    reversed_timestamp: 0x000e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000050c
};
const BLOCKHEADER_1914: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa0c2ce97, 0x4eb4dc11, 0xc4345bd2, 0xc5209d6f, 0x24cf815f, 0xd8d6f16c, 0x3319d264, 0xb95f7c00],
    merkle_root: [0xac4aca21, 0xe60bee9c, 0x152ec655, 0xfa653c48, 0x5b6e8bf5, 0x1aa6c8e5, 0x3e9fb302, 0xace90393],
    reversed_timestamp: 0x60177a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000ec
};
const BLOCKHEADER_1915: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb2a03cc9, 0xdc23e628, 0x22e88ed7, 0x1251d7be, 0x2c731c84, 0x877ce65e, 0x9907c7b1, 0x22377a00],
    merkle_root: [0xe4d8f6eb, 0xd28dae84, 0xd8eb6c68, 0x98559fad, 0x308c655d, 0x8df1b802, 0x8e72a349, 0xbbc14df6],
    reversed_timestamp: 0xc0207a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000002a
};
const BLOCKHEADER_1916: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7b64c11b, 0x9a2aaba3, 0xca452447, 0xc3dca64f, 0x840cc8e9, 0x389230e0, 0x830fced5, 0xb4a84e00],
    merkle_root: [0xf0927abe, 0xb160973c, 0x848d5a63, 0x9e8a7403, 0x3ce2c68e, 0xd05ed6ae, 0x5764f5e1, 0x635b7a7d],
    reversed_timestamp: 0x202a7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000632
};
const BLOCKHEADER_1917: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc2624c18, 0x2dfdf16c, 0x738ab009, 0x739de433, 0x6c4cc74c, 0x20e7ffab, 0xa3acd2c4, 0x667a7000],
    merkle_root: [0xc1be7438, 0x32314869, 0xe8009296, 0xbd6bd6de, 0x77208e27, 0x2d273328, 0xe397b9ae, 0x330992d9],
    reversed_timestamp: 0x80337a59,
    nbits: 0xffff7f1f,
    nonce: 0x000002a7
};
const BLOCKHEADER_1918: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5cbbcd7e, 0xc25a08e2, 0x17828e4b, 0xe1f9195e, 0xa60b494d, 0xf491b840, 0x2b60a1a6, 0x93752500],
    merkle_root: [0x3729bc68, 0xca79e2f4, 0x7665aa9d, 0xa691a902, 0x0dde1b0a, 0x5f0ff292, 0x66c2386b, 0x6b87a140],
    reversed_timestamp: 0xe03c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000cc
};
const BLOCKHEADER_1919: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1def4973, 0xddadd08f, 0x025801a3, 0x9cf51873, 0xbf798351, 0x7e22fc7e, 0xdd47723a, 0xecac0200],
    merkle_root: [0xcaf29423, 0x5d999ae9, 0x969b3bfd, 0x5206aed1, 0x9e1fc4ea, 0x1bb2c242, 0x60766d1f, 0x8fd535a7],
    reversed_timestamp: 0x40467a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000022
};
const BLOCKHEADER_1920: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xaddc5b2e, 0x9ec4088d, 0x02f4a196, 0x0d0341ac, 0xcf533669, 0x2b317dbe, 0x79f3a316, 0x428a2400],
    merkle_root: [0x217f6f11, 0x2523774e, 0x8100210e, 0x376a534b, 0xff54bdeb, 0x75283752, 0x5cbff461, 0xa813e3bc],
    reversed_timestamp: 0xa04f7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000055
};
const BLOCKHEADER_1921: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x452b0bb2, 0xa6df0d38, 0x2d5b1c92, 0x18bdb2d5, 0x2808bf67, 0xc92b07bb, 0x0b200c27, 0xbc113100],
    merkle_root: [0xfc9fac31, 0x4a209efa, 0xa02ff582, 0x756cf034, 0xd9af2566, 0x716d7b1d, 0x6ad89bf0, 0x651c6047],
    reversed_timestamp: 0x00597a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000017e
};
const BLOCKHEADER_1922: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x36534e1e, 0xcbc17626, 0xc1ec0364, 0x74c88c5f, 0xde527e02, 0x7eafabaa, 0x2d36d746, 0x867d1800],
    merkle_root: [0x6eb0d871, 0x8f593e98, 0xe4703b1b, 0x6fae664c, 0xe3a086a8, 0x98e08e58, 0xd77e82ad, 0xe6135a69],
    reversed_timestamp: 0x60627a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000046a
};
const BLOCKHEADER_1923: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe1d25079, 0xccf75db3, 0x28f70fa5, 0xd5b3bfc6, 0xa7543a39, 0x879be1e4, 0xa44df4a1, 0x0b803700],
    merkle_root: [0xf6586a3a, 0xa277436f, 0x00419614, 0x5d8060eb, 0xce04de61, 0xf2848b49, 0x70098542, 0x7d9dc632],
    reversed_timestamp: 0xc06b7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000858
};
const BLOCKHEADER_1924: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xec5f18a9, 0xb7c36dce, 0x890542f4, 0xd87af9ba, 0xfd3077c6, 0xf073d47f, 0x892f3522, 0xb9576a00],
    merkle_root: [0xe082f2cc, 0x055825f8, 0xe101e98e, 0x1a2ae92f, 0xde776579, 0x0aae460c, 0x07e96331, 0xca0f6e09],
    reversed_timestamp: 0x20757a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000183
};
const BLOCKHEADER_1925: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x16b6de8a, 0x779052ac, 0x5e2b978b, 0x0e8ce454, 0x91649394, 0xfcb33824, 0xa058f0b4, 0x43417c00],
    merkle_root: [0x199306ed, 0x0452fba2, 0x158127b0, 0x9fb11778, 0xfce33119, 0xb50817c6, 0x62c1b351, 0x5ebf7fae],
    reversed_timestamp: 0x807e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000016
};
const BLOCKHEADER_1926: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9ee7abbf, 0x14d5a0af, 0x3551f242, 0x22c3c5c5, 0x6c006b53, 0x3a9be8b6, 0x34baa797, 0x7bf03900],
    merkle_root: [0x5620f96f, 0x65e52005, 0x8a01da9b, 0xef430ab3, 0x32a671e6, 0x9e0389af, 0x71f41142, 0x7ad57ffc],
    reversed_timestamp: 0xe0877a59,
    nbits: 0xffff7f1f,
    nonce: 0x000002f7
};
const BLOCKHEADER_1927: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc13c6981, 0x2eaf24bf, 0xadee0d2c, 0x3d95bd35, 0x47ff13e7, 0x0c99c57d, 0x50f588f2, 0xa4261400],
    merkle_root: [0x1d23bca4, 0x7a0abb30, 0x099ee390, 0xcd1d472b, 0x41901d48, 0xf3bb7bed, 0x34600c07, 0x69a1cb51],
    reversed_timestamp: 0x40917a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000137
};
const BLOCKHEADER_1928: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb2f8d803, 0x233d9efd, 0xd4d66860, 0xfcbe3708, 0x2f5fc66c, 0x76ccddf9, 0x99aad9af, 0x970e5b00],
    merkle_root: [0xa8bed6f0, 0xcde1d72d, 0x8ca35cd2, 0xc1735163, 0x0ebb6ca4, 0x993f1284, 0xca5f44b5, 0xc65cbe81],
    reversed_timestamp: 0xa09a7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000000d
};
const BLOCKHEADER_1929: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2047c133, 0x1172209d, 0x29358843, 0x1db0a419, 0xd2448042, 0x466c8f12, 0xccee2b7c, 0x2b637e00],
    merkle_root: [0xb6886827, 0x410eb1db, 0xf6df1e67, 0x9c4aded6, 0x65cf0516, 0x1e918db7, 0xa474e85e, 0x38db836b],
    reversed_timestamp: 0x00a47a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000102
};
const BLOCKHEADER_1930: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x959fc25f, 0x1eeaa0f5, 0x2c1bccb3, 0xcbe74372, 0x21c3bd39, 0xcc1b6d86, 0xb648af29, 0xe3986400],
    merkle_root: [0xc4113cb7, 0xbc60f51d, 0x73d50aeb, 0x540e0c2e, 0x5428f854, 0xd4b0c5ba, 0xeb89da43, 0x7b166555],
    reversed_timestamp: 0x60ad7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000123
};
const BLOCKHEADER_1931: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6588494e, 0x26b8c2a9, 0x854c384f, 0x80cbef6c, 0x5d213dc4, 0x1dafd881, 0xdbac2afe, 0x53c00500],
    merkle_root: [0xfc84db2f, 0xe6d7bd50, 0x8ce763dc, 0x161a6497, 0x47913c42, 0x50745abb, 0x5cca6566, 0x1bd3e8e6],
    reversed_timestamp: 0xc0b67a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000112
};
const BLOCKHEADER_1932: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7fca0e04, 0x520cfa60, 0x524bf672, 0xe54e55f5, 0x7f258241, 0x0712ce9d, 0x49aa23be, 0x24a64700],
    merkle_root: [0x12f90923, 0x49231ccc, 0xd1415c8c, 0xa1b843f5, 0x2d434d84, 0xcff027dd, 0xa4833c45, 0x33931f81],
    reversed_timestamp: 0x20c07a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000003d
};
const BLOCKHEADER_1933: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1e9a7c18, 0x75fa7921, 0x1af64d80, 0xcc6dee1b, 0x7b6e3ab6, 0xdbfe09fb, 0x51d77288, 0x88d33e00],
    merkle_root: [0x49b5dab0, 0xf8f26e2b, 0x217a59b8, 0x604765d3, 0x11b8d644, 0xf470f9f7, 0x36228b84, 0x1233ed7d],
    reversed_timestamp: 0x80c97a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000003b
};
const BLOCKHEADER_1934: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x31ad49ba, 0xbc58a536, 0x5da2c2be, 0xe4c2b54a, 0x1c2ef594, 0x145700ce, 0x377473a1, 0xe4de4700],
    merkle_root: [0xe33c61ca, 0xb01e19e8, 0x83de9b3a, 0x016c3f68, 0x2c2adaf7, 0xb05a4d23, 0xb4c66abf, 0x5fb95d75],
    reversed_timestamp: 0xe0d27a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000000f
};
const BLOCKHEADER_1935: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x33731dbf, 0x097d79e8, 0x08ba019c, 0xdd7f8479, 0x6c70391d, 0x6cec0865, 0x084fc349, 0x01041800],
    merkle_root: [0x97c18c86, 0x7d78ca90, 0x6f99a6fd, 0xd2e57336, 0x9d0ec10f, 0x50b19d55, 0xc7ab204c, 0x61fa6403],
    reversed_timestamp: 0x40dc7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000002d2
};
const BLOCKHEADER_1936: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8a5888e6, 0x0bedae9a, 0xa505de17, 0x8fb7f82f, 0x3e2c20df, 0x4adab871, 0x62dcc0bd, 0xf8f10000],
    merkle_root: [0x0a0b7646, 0x69fd6467, 0x140ce109, 0x269d2198, 0xc5a813ff, 0xd1730faa, 0x9a2a0b8f, 0x7c6c3979],
    reversed_timestamp: 0xa0e57a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000007c
};
const BLOCKHEADER_1937: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x354cf12e, 0x42b56ba9, 0xf22d6f98, 0xc503344c, 0x064f4c31, 0x70f89f86, 0xe200fc18, 0xcab03d00],
    merkle_root: [0x91bd8667, 0xaafaf1e4, 0x3cb0634e, 0x88107dc6, 0x46bd8a18, 0x2e818011, 0xceafd7bf, 0x8ad6bc55],
    reversed_timestamp: 0x00ef7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000b4
};
const BLOCKHEADER_1938: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4584354f, 0x9450e5e3, 0x7b89c840, 0xccdb0cc4, 0x698edb2c, 0x0e549b45, 0xb5ced8eb, 0x6ae62000],
    merkle_root: [0x9522691f, 0x58bee610, 0x4cee8493, 0xca24dade, 0xc48d76e3, 0x4792b7eb, 0x6037ee06, 0xa458b227],
    reversed_timestamp: 0x60f87a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001a8
};
const BLOCKHEADER_1939: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1c02eb87, 0x2a7391bd, 0xdc5fec5a, 0x76f27431, 0x3bdc2042, 0x3fb9fb03, 0x7f6dd2ce, 0x96451d00],
    merkle_root: [0x2e6f9287, 0x58617cb9, 0xba5350ed, 0x30778a29, 0x69135acd, 0x6670974b, 0x31be39ab, 0x5e6244f1],
    reversed_timestamp: 0xc0017b59,
    nbits: 0xffff7f1f,
    nonce: 0x0000002f
};
const BLOCKHEADER_1940: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x779989c5, 0xb3aebaa6, 0xf2c475d8, 0x607d058e, 0x875c0ea3, 0xe4b2b9db, 0x7f089150, 0x628e0900],
    merkle_root: [0xa637737c, 0xa3c6b15d, 0x96d4377b, 0xec8c3a05, 0xeb0c9e91, 0x5b60d669, 0x8483e49e, 0x3ac99a65],
    reversed_timestamp: 0x200b7b59,
    nbits: 0xffff7f1f,
    nonce: 0x000001c1
};
const BLOCKHEADER_1941: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd738a68e, 0xf7103513, 0xe0ba21a9, 0x48ccbdfe, 0x9636648d, 0x1979b8d6, 0x80502f04, 0x34221f00],
    merkle_root: [0x24866804, 0x5ca29b11, 0xfb40aebe, 0x1d2fe7ca, 0x99b043ce, 0x5527b7c0, 0xebc51f2d, 0x294f3226],
    reversed_timestamp: 0x80147b59,
    nbits: 0xffff7f1f,
    nonce: 0x00000273
};
const BLOCKHEADER_1942: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x954bba88, 0xecca3cd2, 0xf96cf508, 0xbf2ed36c, 0xaed902d0, 0x82eb103f, 0xb9850df3, 0x81ba4500],
    merkle_root: [0x4f7c1feb, 0x7c991957, 0xe46ab942, 0x168b6795, 0x6a918308, 0x2a95d1b7, 0xeb2bbbb5, 0x45e7908b],
    reversed_timestamp: 0xe01d7b59,
    nbits: 0xffff7f1f,
    nonce: 0x000004c1
};
const BLOCKHEADER_1943: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4df3eee2, 0x25482b2c, 0x07cae377, 0xfca9f501, 0xcd23b2f5, 0x9e80d582, 0xfc2d6d77, 0x253d3200],
    merkle_root: [0x9c0c8633, 0x82b81d08, 0xe580780a, 0x9b426100, 0x88963aef, 0xde5c44b9, 0x9d222403, 0x0253c99c],
    reversed_timestamp: 0x40277b59,
    nbits: 0xffff7f1f,
    nonce: 0x00000059
};
const BLOCKHEADER_1944: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8d0b4e26, 0xd296b74c, 0x9816f91c, 0x58398c28, 0x4c408056, 0x9b67a068, 0x9c52d66b, 0x05e80400],
    merkle_root: [0x7eec3672, 0xd3bd3981, 0x02eda4c7, 0x8790ecb4, 0xb58fd69b, 0x1085fdad, 0x02ac85f6, 0x513b9604],
    reversed_timestamp: 0xa0307b59,
    nbits: 0xffff7f1f,
    nonce: 0x0000005d
};
const BLOCKHEADER_1945: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x47d4bc42, 0x429c11e1, 0x532a36e7, 0xc023fa69, 0xbba7e742, 0x992c195d, 0xd33ce77d, 0x60595000],
    merkle_root: [0xaa545ccf, 0x0cb8d91f, 0x6e4875ed, 0xfd7a233d, 0xbe0e8fbb, 0x0fb80a83, 0x41890f21, 0x61c79ab9],
    reversed_timestamp: 0x003a7b59,
    nbits: 0xffff7f1f,
    nonce: 0x00000189
};
const BLOCKHEADER_1946: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3456d915, 0xf8f29881, 0xc571cc14, 0xc0862c4c, 0x7713f33b, 0xf153e179, 0x6044acb6, 0x89f66500],
    merkle_root: [0x384aa363, 0x8bf800a9, 0x8e02dac9, 0x9873c30d, 0x3f89605c, 0x6a139c0f, 0x9e086535, 0x038596a2],
    reversed_timestamp: 0x60437b59,
    nbits: 0xffff7f1f,
    nonce: 0x00000360
};
const BLOCKHEADER_1947: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xbd08a5ce, 0xfbd48779, 0x97626bba, 0x2db1a35b, 0xb0c532fc, 0xfa4dcb6f, 0x700792d1, 0xe7c33f00],
    merkle_root: [0xc173d0e3, 0x228c4f96, 0x8354f63d, 0xd5f620c7, 0x0db0be98, 0x53b67636, 0x423ec857, 0xdf7fe9a7],
    reversed_timestamp: 0xc04c7b59,
    nbits: 0xffff7f1f,
    nonce: 0x0000010d
};
const BLOCKHEADER_1948: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc2caca12, 0x05d6aff6, 0xaf7fece5, 0x1be5004b, 0x25ddbd48, 0xa1bfc6d8, 0xd688c23e, 0xb8c20200],
    merkle_root: [0x85f70ea3, 0x43e9fe57, 0x685e9ff0, 0x5fa506bc, 0xd499352a, 0xcce378b5, 0x43c6eb0d, 0x6b6475d0],
    reversed_timestamp: 0x20567b59,
    nbits: 0xffff7f1f,
    nonce: 0x000001b9
};
const BLOCKHEADER_1949: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9bc9dc5a, 0x94832f25, 0xf8f9b92e, 0x28c2a66d, 0xb82cd237, 0x91df0cf2, 0xa4c36006, 0x2a4f5b00],
    merkle_root: [0x33fdd242, 0x31fcc73c, 0xf3091303, 0xbfe9be28, 0xfdf28d3e, 0x249f7e74, 0x63fbecd3, 0x908701b5],
    reversed_timestamp: 0x805f7b59,
    nbits: 0xffff7f1f,
    nonce: 0x000002df
};
const BLOCKHEADER_1950: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5f4d2c67, 0x8f335d00, 0x05b81f2e, 0x852103d0, 0x87ee6a32, 0xbf7130b3, 0xa011e63a, 0xe1c24800],
    merkle_root: [0x831cdd09, 0xf65a7963, 0x22f39ddf, 0x10c67db3, 0x1621efec, 0xeceb1307, 0x44017a8f, 0x637c08f2],
    reversed_timestamp: 0xe0687b59,
    nbits: 0xffff7f1f,
    nonce: 0x0000025e
};
const BLOCKHEADER_1951: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x46d6ed6b, 0x9606d5e5, 0xcd502c88, 0x80190938, 0x93257a2b, 0x9aa49f77, 0x20f4af4c, 0x35020900],
    merkle_root: [0x77db2ade, 0x93db2e48, 0x5518cd0c, 0x879f3676, 0xbb24e814, 0xc0a0f18f, 0x6f6ecdc5, 0x2eb57e58],
    reversed_timestamp: 0x40727b59,
    nbits: 0xffff7f1f,
    nonce: 0x000001f7
};
const BLOCKHEADER_1952: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x18982e32, 0xc3bf963d, 0x9ce794ea, 0xbd92cdb1, 0xb9e39097, 0xfa2a4684, 0x2384392a, 0xfe5c5800],
    merkle_root: [0x34f4cf90, 0xd2e8c0a1, 0xe64a1f1f, 0xe0948015, 0x998f93cf, 0x499f1c63, 0xb34b05ee, 0xf3515fc0],
    reversed_timestamp: 0xa07b7b59,
    nbits: 0xffff7f1f,
    nonce: 0x00000008
};
const BLOCKHEADER_1953: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2bd41f42, 0xa1dd6f95, 0xf4a0f484, 0x20344599, 0x631dac00, 0x38b68aa2, 0x8dbbced7, 0x7a624f00],
    merkle_root: [0x68031381, 0x016b917b, 0xcc88480d, 0x15cd4674, 0x081531f9, 0x808a1a05, 0x8a5e9636, 0x1a0a61c4],
    reversed_timestamp: 0x00857b59,
    nbits: 0xffff7f1f,
    nonce: 0x00000354
};
const BLOCKHEADER_1954: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x32b7c382, 0x5b2382d4, 0xbee5dab6, 0xaf189f80, 0x3c7096dd, 0x241249fa, 0x8ce5493f, 0xdbd32b00],
    merkle_root: [0xade8117b, 0x10b32144, 0x47fa1708, 0x791e7555, 0x64f3397b, 0x2b22d462, 0x67c4054b, 0x487f51f4],
    reversed_timestamp: 0x608e7b59,
    nbits: 0xffff7f1f,
    nonce: 0x000000e6
};
const BLOCKHEADER_1955: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x048cbd4a, 0x35eb46f0, 0x12051da0, 0x0bf6af01, 0x6fc97c11, 0x76ac7660, 0xa14d30c8, 0x50024e00],
    merkle_root: [0x1233c1b2, 0x685ae96e, 0x21a857d2, 0x49c1d756, 0x72bbf0c8, 0x10efed8a, 0x96807775, 0x24498e72],
    reversed_timestamp: 0xc0977b59,
    nbits: 0xffff7f1f,
    nonce: 0x0000036b
};
const BLOCKHEADER_1956: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb045dbbd, 0x8887e457, 0x1fc67b4e, 0x14b5ecb4, 0xba83cad7, 0xe12c833d, 0xfad874af, 0xc1327f00],
    merkle_root: [0xda5fbb2a, 0xecf5aab3, 0x83621b99, 0xc80526f3, 0xec1eb2c7, 0xb20b033b, 0x7d875869, 0x68160d48],
    reversed_timestamp: 0x20a17b59,
    nbits: 0xffff7f1f,
    nonce: 0x00000092
};
const BLOCKHEADER_1957: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4e465858, 0x5e3a6659, 0x366b0ecf, 0x9ef50dfa, 0x8cbc4112, 0x9faa69e3, 0xae273a08, 0xb3692d00],
    merkle_root: [0xbce45185, 0x27c8fa0b, 0x790fe311, 0xafc8afee, 0x9da39c44, 0x7d285769, 0xa6d54848, 0xdac39b6f],
    reversed_timestamp: 0x80aa7b59,
    nbits: 0xffff7f1f,
    nonce: 0x000000aa
};
const BLOCKHEADER_1958: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x751c1675, 0xcbf0328a, 0x78d0363a, 0x3a8e4dcf, 0x3a8e22c7, 0x45c32aaa, 0x65444bd2, 0x41580100],
    merkle_root: [0x7155a78c, 0xe2aa60fb, 0xb2a8f3dd, 0xa249504e, 0xe75d4c51, 0x2df93905, 0x636efbc3, 0x1fd0df52],
    reversed_timestamp: 0xe0b37b59,
    nbits: 0xffff7f1f,
    nonce: 0x00000073
};
const BLOCKHEADER_1959: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xfc683ebe, 0x413bb29f, 0x285e6470, 0xbb03ac7f, 0x1d7ca91c, 0xf97b1103, 0x186ecaff, 0x37716e00],
    merkle_root: [0x89f3784d, 0xa1b3ce35, 0x1abc5763, 0xc5304f3a, 0xfe2d38dd, 0x1d75ed34, 0xf19c8a99, 0xa9e7820c],
    reversed_timestamp: 0x40bd7b59,
    nbits: 0xffff7f1f,
    nonce: 0x00000175
};
const BLOCKHEADER_1960: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3a04be7b, 0xa1861b14, 0x87fa2bc2, 0x57916be8, 0x3703d8e1, 0xf9bb1e0e, 0x7b4765c9, 0x37457100],
    merkle_root: [0x2db4b275, 0xc7da5ffd, 0x6f17ec0c, 0xdfd983c9, 0xfcf83bf4, 0x2daf06c5, 0x928399ae, 0x65179dd3],
    reversed_timestamp: 0xa0c67b59,
    nbits: 0xffff7f1f,
    nonce: 0x00000072
};
const BLOCKHEADER_1961: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x38001165, 0x9a16ee2e, 0xa1dbfe43, 0xf521e5a6, 0x79d656ad, 0x4e92f222, 0xa544aa8d, 0xf75a6d00],
    merkle_root: [0x452c5525, 0xf710926d, 0x632d14f8, 0x097989a5, 0xdfe2c1db, 0xfc901df0, 0xb1641ae9, 0xc4715c7e],
    reversed_timestamp: 0x00d07b59,
    nbits: 0xffff7f1f,
    nonce: 0x00000362
};
const BLOCKHEADER_1962: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xfc1a529f, 0xf8190fc4, 0xc814c7b6, 0x61105aeb, 0xc8f810fd, 0x00ded077, 0xf1d75c05, 0xa2411e00],
    merkle_root: [0x0481b987, 0x826583ba, 0x4bd6eeef, 0xa2b5ccc6, 0xf2bccb9c, 0xa3c04f85, 0x2c029438, 0x10ae49e3],
    reversed_timestamp: 0x60d97b59,
    nbits: 0xffff7f1f,
    nonce: 0x0000015e
};
const BLOCKHEADER_1963: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4e72b8c6, 0x50779733, 0x28f8b2d1, 0x50bb7399, 0xc0ec1d53, 0x37aa651b, 0xec08aae7, 0x8c197900],
    merkle_root: [0xec1e8a2c, 0x652af808, 0x2e77b116, 0xb036d758, 0xe027b158, 0xd812443a, 0x096deea5, 0xe12d8901],
    reversed_timestamp: 0xc0e27b59,
    nbits: 0xffff7f1f,
    nonce: 0x00000023
};
const BLOCKHEADER_1964: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x644eac1e, 0x5363e1a5, 0x944b50e8, 0x1e42a099, 0x18572d7e, 0x3d934034, 0x1c73a491, 0x6df00400],
    merkle_root: [0x29b15f66, 0x9e6250f2, 0x6c623a29, 0x6e4a41c3, 0x2814c96d, 0x27d603e0, 0xd47ebc8b, 0xf492ca38],
    reversed_timestamp: 0x20ec7b59,
    nbits: 0xffff7f1f,
    nonce: 0x000003db
};
const BLOCKHEADER_1965: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb72ec8a0, 0x3e8d9f84, 0xc09bbefd, 0xd6572f57, 0x84d9811a, 0x5926184d, 0xdddde690, 0xd7993b00],
    merkle_root: [0xdd15d622, 0xfffc3f39, 0xc163d4de, 0x27f0e8d3, 0x4f5122a1, 0x15732699, 0x9dc673fd, 0x714bf269],
    reversed_timestamp: 0x80f57b59,
    nbits: 0xffff7f1f,
    nonce: 0x00000059
};
const BLOCKHEADER_1966: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd7a7063d, 0x217f912e, 0x12747ce5, 0x7754a117, 0x6bf3a912, 0xb5af15fa, 0x71a25dac, 0xd3d21b00],
    merkle_root: [0x1a3b3ea5, 0xcab0da6f, 0xc315a71d, 0x30a1d252, 0x468d523e, 0xa874bb85, 0xa55771b6, 0xc6112016],
    reversed_timestamp: 0xe0fe7b59,
    nbits: 0xffff7f1f,
    nonce: 0x00000325
};
const BLOCKHEADER_1967: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe8f1fd2f, 0x713637b1, 0xd3379541, 0xc8349345, 0xaaae2fa3, 0x5a959a4d, 0x7f78639c, 0x7f5f5900],
    merkle_root: [0xf2633def, 0x858b9432, 0x352daef5, 0xdfeca984, 0x97a586ee, 0x446aeecb, 0x8d5ea920, 0x4d1e23dd],
    reversed_timestamp: 0x40087c59,
    nbits: 0xffff7f1f,
    nonce: 0x000003ec
};
const BLOCKHEADER_1968: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xce04987d, 0x0fb15a60, 0xab41bf54, 0x6acbcc0b, 0xbf7fe5d7, 0xea2f2ab8, 0x9a3a6f85, 0x11f93300],
    merkle_root: [0x59676c16, 0x8f3aa641, 0xb3e3f899, 0x98e96f93, 0x9af677e8, 0x80354837, 0x84fcf6bf, 0x9a9c144b],
    reversed_timestamp: 0xa0117c59,
    nbits: 0xffff7f1f,
    nonce: 0x0000034a
};
const BLOCKHEADER_1969: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6fe422ec, 0x9adff92a, 0x54e1e29c, 0x756450a9, 0x1ad6305b, 0x25cfa617, 0x1277f704, 0xaa9d0300],
    merkle_root: [0x1a0cab55, 0xbfd8280c, 0xd2cd7462, 0xd252fdd3, 0x2b3f3fe3, 0x08396a9f, 0x3c963f2c, 0xf2531ee0],
    reversed_timestamp: 0x001b7c59,
    nbits: 0xffff7f1f,
    nonce: 0x000001ac
};
const BLOCKHEADER_1970: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x583015ed, 0x60346a2b, 0x22062a74, 0xbe861c45, 0x51765ea3, 0x8a9b68a6, 0xcd2c8c9c, 0x07b02100],
    merkle_root: [0x8147125c, 0x3d04afeb, 0x499ec59e, 0xaa5df121, 0xee49fbc2, 0xa6202d12, 0xd321fd01, 0x3730d8c2],
    reversed_timestamp: 0x60247c59,
    nbits: 0xffff7f1f,
    nonce: 0x000003ed
};
const BLOCKHEADER_1971: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xaa7fb744, 0x015b118a, 0x720f836e, 0xc6e1d792, 0xd4106c66, 0x99f4a235, 0xb074904f, 0x37234500],
    merkle_root: [0x33a0dd56, 0x0990d900, 0xd65aaa2d, 0x458cfd1a, 0x1463b9d0, 0x5f048cd5, 0xd1a791fc, 0x09761966],
    reversed_timestamp: 0xc02d7c59,
    nbits: 0xffff7f1f,
    nonce: 0x000004b4
};
const BLOCKHEADER_1972: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4244016b, 0x886d426c, 0xdbe50e5b, 0xb6447059, 0x7fd4c394, 0xa6d2b5e8, 0x0474eaf5, 0xa3ca3c00],
    merkle_root: [0x5ea243e4, 0x010ff922, 0x80fc4c3d, 0x826c359f, 0x2b65706c, 0x09d76fba, 0x8a8d90a9, 0xff5cc483],
    reversed_timestamp: 0x20377c59,
    nbits: 0xffff7f1f,
    nonce: 0x000000f0
};
const BLOCKHEADER_1973: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1d79d474, 0xc1cfd3f1, 0x2cc39d7e, 0x85e186bd, 0x887ab05e, 0xa48c98a4, 0x4683fc23, 0xbe9f0c00],
    merkle_root: [0x8ae82246, 0xf7f8fdbf, 0xad01de7b, 0xe00c5b59, 0xc0ee4fcf, 0x89c68088, 0xba899331, 0x3bdcc555],
    reversed_timestamp: 0x80407c59,
    nbits: 0xffff7f1f,
    nonce: 0x00000231
};
const BLOCKHEADER_1974: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x04b554e3, 0x28ff8d04, 0x8ff95fa1, 0xba4ad71f, 0x834360cf, 0x1a3c896a, 0xd613e57f, 0xb5d83600],
    merkle_root: [0x27f524b6, 0xc1ad0ac3, 0xd5a7b0b9, 0x776e1bb0, 0x997f8c14, 0x5ce2e0ef, 0x6d696c4a, 0x8ed32702],
    reversed_timestamp: 0xe0497c59,
    nbits: 0xffff7f1f,
    nonce: 0x0000018f
};
const BLOCKHEADER_1975: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2dd5c179, 0xd88560dc, 0xbf2e096a, 0x100ce43e, 0x75e9e5e0, 0xd53553db, 0xa87260eb, 0xae9c7900],
    merkle_root: [0x8847427b, 0x76481f53, 0x4c86722b, 0x86d8e8fa, 0x0e15d6b4, 0x142fc434, 0x3106abdf, 0xc4ca29e9],
    reversed_timestamp: 0x40537c59,
    nbits: 0xffff7f1f,
    nonce: 0x00000199
};
const BLOCKHEADER_1976: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x756b67b8, 0x107b9e35, 0x96c47abc, 0xed651c51, 0xe593b81f, 0xb1ef852b, 0xfc061945, 0xee412200],
    merkle_root: [0x64546ba6, 0xacc04c99, 0x393b2862, 0x93920c23, 0xe58c4474, 0x462a87e9, 0x98ecc4d7, 0xc81f5581],
    reversed_timestamp: 0xa05c7c59,
    nbits: 0xffff7f1f,
    nonce: 0x00000b89
};
const BLOCKHEADER_1977: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4ed19946, 0x1be93e07, 0xcccffef4, 0xc72a03ac, 0x96058e8f, 0xa07477b5, 0xfbbbc7d4, 0xa0cc0800],
    merkle_root: [0x80993544, 0xf94c64a9, 0x208ebca4, 0xc882f1f3, 0xd849e55e, 0xb98c0a1d, 0x133fc99e, 0x29c4bbe8],
    reversed_timestamp: 0x00667c59,
    nbits: 0xffff7f1f,
    nonce: 0x0000010f
};
const BLOCKHEADER_1978: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7c3b3a57, 0xed4e0b40, 0xf4ad1fce, 0x32fc29f2, 0x6f38e37f, 0xcc229712, 0x56e3a51f, 0x6e290c00],
    merkle_root: [0x6680d883, 0xe26e0c33, 0x50296b54, 0xecc0e0fd, 0x55f06a64, 0xc73b09b2, 0x5f0bd41a, 0x56ada1c3],
    reversed_timestamp: 0x606f7c59,
    nbits: 0xffff7f1f,
    nonce: 0x0000019a
};
const BLOCKHEADER_1979: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x67aa5155, 0xafd1f9eb, 0xf043f5e4, 0xcc51fc0d, 0xb902183c, 0xf8acdbb7, 0x2d130af4, 0xa5087600],
    merkle_root: [0x141a2d1b, 0x8a02854a, 0xb87a6470, 0xf38ada62, 0xb744f3bf, 0x13ff6ef0, 0x2b86d35d, 0xef8013d2],
    reversed_timestamp: 0xc0787c59,
    nbits: 0xffff7f1f,
    nonce: 0x00000181
};
const BLOCKHEADER_1980: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x13804384, 0x9a6e1dd3, 0xad458cbd, 0xaf3191e1, 0x023d2faf, 0xd0c1ce15, 0x37448f2b, 0x5f075800],
    merkle_root: [0xfbf41e22, 0x9c4a3a93, 0x5c2471ba, 0x59e8dcf1, 0xc925ae5b, 0x9bbe005d, 0x6b015faf, 0x5211c45c],
    reversed_timestamp: 0x20827c59,
    nbits: 0xffff7f1f,
    nonce: 0x00000176
};
const BLOCKHEADER_1981: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x87ed5329, 0x8179a52b, 0xfc7b5c10, 0xfa810831, 0xedc9527b, 0x0a67dc8e, 0x2c28d56c, 0x6b234d00],
    merkle_root: [0x51adeebf, 0x66c35f5d, 0xe75dd1ed, 0xb89e61f3, 0x5fa8e432, 0x1310d187, 0xcfdfc697, 0xa4d487ba],
    reversed_timestamp: 0x808b7c59,
    nbits: 0xffff7f1f,
    nonce: 0x000002df
};
const BLOCKHEADER_1982: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd875c70a, 0x1c9d1f37, 0xdf55943b, 0x36fe44a8, 0x6fd6b6dc, 0xa32bb4d9, 0xd6ca42e0, 0x0bbe1c00],
    merkle_root: [0xdf6d8ab0, 0x04c71630, 0x8b4041cc, 0x2930933c, 0xb20419bb, 0x77be13fd, 0x87f53341, 0x4f0aceef],
    reversed_timestamp: 0xe0947c59,
    nbits: 0xffff7f1f,
    nonce: 0x0000016e
};
const BLOCKHEADER_1983: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4968de46, 0xf5e15d33, 0x94db30cb, 0xc649f8e4, 0x47b26406, 0x76569840, 0xdadeb83c, 0xa5992b00],
    merkle_root: [0x0d7ead79, 0xfefadb4e, 0xda48c4c3, 0x4fe7de6b, 0x46bf6d2e, 0x39911c9a, 0x2a9ac91e, 0x3e2a1e6d],
    reversed_timestamp: 0x409e7c59,
    nbits: 0xffff7f1f,
    nonce: 0x000004f5
};
const BLOCKHEADER_1984: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1f0452e6, 0x44744bf1, 0x8eafc409, 0xcb2bdd60, 0xa75a0cdd, 0x90e1362a, 0xc3063b0a, 0x1e577600],
    merkle_root: [0x769a693f, 0xe838a145, 0xc95f335d, 0xf77e86b2, 0x654535dc, 0xdf28e3a3, 0xb2e75c1a, 0x81242767],
    reversed_timestamp: 0xa0a77c59,
    nbits: 0xffff7f1f,
    nonce: 0x0000018a
};
const BLOCKHEADER_1985: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1f25225d, 0x1e0c2d24, 0x4a745f8a, 0xde4cfb5e, 0xd1577fcb, 0x764bde67, 0x881b71f1, 0x56a82800],
    merkle_root: [0xfb8f1c6d, 0x153bc38e, 0xe348a7c9, 0x6f0d9d77, 0xb60b2263, 0x98d7523a, 0xbee78ead, 0x8f203a36],
    reversed_timestamp: 0x00b17c59,
    nbits: 0xffff7f1f,
    nonce: 0x0000014c
};
const BLOCKHEADER_1986: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xac3ba336, 0xeeac40af, 0xe6c4abea, 0x2df4b236, 0x34c728df, 0xff01ee05, 0x172a65e0, 0x93982300],
    merkle_root: [0xd1502e91, 0x0076820a, 0x4484784f, 0x64628367, 0x1ff57266, 0xe80a987a, 0x252843e8, 0x39229513],
    reversed_timestamp: 0x60ba7c59,
    nbits: 0xffff7f1f,
    nonce: 0x0000005f
};
const BLOCKHEADER_1987: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9ec5fa4a, 0x94f57987, 0x605a3b73, 0x7501bfcd, 0xffa86446, 0xd3fbc267, 0xebf953df, 0xb0b24100],
    merkle_root: [0x0bf99716, 0x0671dc7a, 0x4dc94714, 0x083a2cf8, 0x380b36e1, 0xec389b23, 0x1c99e044, 0x86597e57],
    reversed_timestamp: 0xc0c37c59,
    nbits: 0xffff7f1f,
    nonce: 0x000000a8
};
const BLOCKHEADER_1988: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xfd943529, 0x2ec83c67, 0xc454046e, 0xe9c9af6a, 0x986cd956, 0xaca919fa, 0x3cfdb673, 0xb19a7a00],
    merkle_root: [0xc85fb36b, 0x2593983e, 0x13a56ba8, 0x220819df, 0x2cc352bb, 0xdca0be9c, 0x4255b688, 0x2f411e03],
    reversed_timestamp: 0x20cd7c59,
    nbits: 0xffff7f1f,
    nonce: 0x00000415
};
const BLOCKHEADER_1989: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x35a6024f, 0x22e67430, 0xd001a774, 0x64e8c995, 0xe63a588f, 0x38627b0e, 0x73c61087, 0x38601700],
    merkle_root: [0x0158f993, 0x40516647, 0x0c4845db, 0x147e07aa, 0x6ffe932e, 0x1303ef92, 0xf133b7c4, 0xa438259c],
    reversed_timestamp: 0x80d67c59,
    nbits: 0xffff7f1f,
    nonce: 0x0000020e
};
const BLOCKHEADER_1990: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5009cb1c, 0xd7fca022, 0xd1b7e418, 0x0baea29e, 0x8bfbb5a3, 0xae53c32e, 0x651b47f1, 0x67fc2c00],
    merkle_root: [0xef9cd644, 0x6a19cfee, 0x33d6bb48, 0xba43a760, 0x3c517ee4, 0xf9509c61, 0x5ce0a8a3, 0xd03bbe86],
    reversed_timestamp: 0xe0df7c59,
    nbits: 0xffff7f1f,
    nonce: 0x0000028c
};
const BLOCKHEADER_1991: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x0c7601e9, 0x8ff42344, 0xfe6c7851, 0xc21381a8, 0xaa56d485, 0xde6bd8cb, 0x58adf44b, 0xb28d3100],
    merkle_root: [0xf214f1b8, 0xb5815c61, 0xeb129267, 0x6cf91bcf, 0xac02ce6e, 0x96b16c1f, 0x06209b68, 0x5ac22dd1],
    reversed_timestamp: 0x40e97c59,
    nbits: 0xffff7f1f,
    nonce: 0x000006f3
};
const BLOCKHEADER_1992: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4caa3400, 0x7c9857f8, 0x8495d411, 0x79ef4a42, 0xa23b4d9f, 0xd7c3bcef, 0xd9084ed9, 0x5d115d00],
    merkle_root: [0xd0296339, 0x730e3116, 0x09dae92a, 0x7f316cba, 0x4100099c, 0xc631361e, 0xeffad946, 0xb5db77bc],
    reversed_timestamp: 0xa0f27c59,
    nbits: 0xffff7f1f,
    nonce: 0x0000025f
};
const BLOCKHEADER_1993: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x43367f50, 0xaaa79d84, 0x8676ba15, 0x7ea6832e, 0x9a3e4550, 0x145e596e, 0x6b0e791e, 0xc44c1e00],
    merkle_root: [0x253cb4ef, 0xecc4b82a, 0x87daeb64, 0x60f7d67b, 0x159b530d, 0x1ded60ca, 0xc71b5641, 0xde37cd1a],
    reversed_timestamp: 0x00fc7c59,
    nbits: 0xffff7f1f,
    nonce: 0x00000063
};
const BLOCKHEADER_1994: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x030a444a, 0xd00687d0, 0x61d375df, 0x307d122d, 0x4b8651db, 0x58a1fe8a, 0x09a29f0e, 0xdcbf5c00],
    merkle_root: [0x94ef36d4, 0xe1bd9335, 0x134d46d8, 0x53e21045, 0x498fbed5, 0xceb769e0, 0xfae59e67, 0x91a7debb],
    reversed_timestamp: 0x60057d59,
    nbits: 0xffff7f1f,
    nonce: 0x00000447
};
const BLOCKHEADER_1995: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1e244f2a, 0x7a71a814, 0x33cdef55, 0xf7b83367, 0x3eab5c8e, 0xd95cec2e, 0xf46fedf9, 0xacb25700],
    merkle_root: [0x1707bf9f, 0xbf7f0b8f, 0x9745c347, 0x5c4a701f, 0xc886fd6c, 0x60a3dc41, 0xee782965, 0xd36e684d],
    reversed_timestamp: 0xc00e7d59,
    nbits: 0xffff7f1f,
    nonce: 0x00000386
};
const BLOCKHEADER_1996: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x96cf1744, 0x6f168a08, 0x5c57d39a, 0x70b25e0b, 0x07786eb6, 0x43ec71d6, 0x33b3f619, 0xe6775000],
    merkle_root: [0x9e26966e, 0xf80c0514, 0xe41e132e, 0x3b57cb4c, 0x3deb1a55, 0x8bff3778, 0x5eeea274, 0xa2b05f2e],
    reversed_timestamp: 0x20187d59,
    nbits: 0xffff7f1f,
    nonce: 0x000002a8
};
const BLOCKHEADER_1997: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x318570c3, 0xf39c6312, 0x52656073, 0x4fb4a840, 0x445a62d4, 0xa6d22442, 0x5dc30800, 0x9a227b00],
    merkle_root: [0x1953eebc, 0x090c7a46, 0xfb36b8cf, 0xcfc3ccf8, 0xbee06b34, 0xf2b3820c, 0x8c651fdd, 0x33e3d933],
    reversed_timestamp: 0x80217d59,
    nbits: 0xffff7f1f,
    nonce: 0x00000233
};
const BLOCKHEADER_1998: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x85627123, 0x221f0be9, 0xf517ba0c, 0x2a57913b, 0x471055e3, 0x94bde12e, 0x9feebe04, 0xc4675c00],
    merkle_root: [0xc9532293, 0x2980cb99, 0xce4c7acb, 0x3380f2f5, 0x51f996ed, 0xdfc524db, 0xa3e1abfe, 0xbd8e30bc],
    reversed_timestamp: 0xe02a7d59,
    nbits: 0xffff7f1f,
    nonce: 0x00000052
};
const BLOCKHEADER_1999: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x56fd4f48, 0xc1389fcc, 0x8e7f472b, 0xc57623ff, 0x617874de, 0xefbbf14a, 0xce683667, 0xf54a7f00],
    merkle_root: [0x008d10b3, 0x6e96ba74, 0x4c8c0151, 0x7a21fbb5, 0x10a6178b, 0x5d5e3e47, 0x4a42b8bf, 0x440b2357],
    reversed_timestamp: 0x40347d59,
    nbits: 0xffff7f1f,
    nonce: 0x000000e1
};
const BLOCKHEADER_2000: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x49ebcfff, 0x9ca774e3, 0x84734638, 0xa13e117f, 0xe17d5dd8, 0x519c1ebc, 0xa26e3fa5, 0xbfbc5a00],
    merkle_root: [0x2df00d80, 0x99d6fff3, 0x3dc104f3, 0x606eb257, 0x8b4f1442, 0xcdd2a874, 0x7256f231, 0x915a11c7],
    reversed_timestamp: 0xa03d7d59,
    nbits: 0xffff7f1f,
    nonce: 0x0000037c
};
const BLOCKHEADER_2001: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xfb22fd7e, 0x88aeac22, 0xe22f0252, 0x929b04b1, 0x5587a096, 0x89e11214, 0xf0d5154c, 0x726b2d00],
    merkle_root: [0xbc264dee, 0x05fc99db, 0xd95fd6e7, 0x00e580f7, 0x89d7ca37, 0xad5aa101, 0x03ff3ce8, 0x89a32336],
    reversed_timestamp: 0x00477d59,
    nbits: 0xffff7f1f,
    nonce: 0x000003aa
};
const BLOCKHEADER_2002: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf30e5f18, 0x17727b43, 0x02e343c9, 0xf5d4362f, 0x915b6833, 0x6c9c92b4, 0x18e8ad4b, 0x9b691500],
    merkle_root: [0x02caaade, 0xf0a62607, 0xd50555d8, 0xb8f99529, 0xff60f305, 0xf7881dc6, 0xca5e87a6, 0xf667c307],
    reversed_timestamp: 0x60507d59,
    nbits: 0xffff7f1f,
    nonce: 0x000000df
};
const BLOCKHEADER_2003: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9d8e1cf6, 0x7b05f01d, 0xac0934a3, 0xc62f5bc3, 0xbb478747, 0xabb25b74, 0x9ea5f44e, 0xde4a1700],
    merkle_root: [0xdff51306, 0xcc136b7d, 0xe84827b4, 0xdca70326, 0x056ae86e, 0x1867a061, 0x12235af1, 0xe69d1702],
    reversed_timestamp: 0xc0597d59,
    nbits: 0xffff7f1f,
    nonce: 0x00000052
};
const BLOCKHEADER_2004: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5f858e76, 0x9c779bb4, 0xad854570, 0x870b0f77, 0x2af13930, 0x08cee56d, 0x34b45bc8, 0x22cf3200],
    merkle_root: [0x6c01256d, 0x6147190d, 0x19916c7b, 0x2e0a2463, 0x9b31dc27, 0xeec9aeae, 0x286efb13, 0xe16b9764],
    reversed_timestamp: 0x20637d59,
    nbits: 0xffff7f1f,
    nonce: 0x0000017c
};
const BLOCKHEADER_2005: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xad1ef21d, 0x939fea80, 0xb883e925, 0xd1d20d1c, 0x7cd49b40, 0xdda9f665, 0x18792ae6, 0x477b6900],
    merkle_root: [0xd28405a9, 0x10433a41, 0x95ea42db, 0x3e0f0839, 0x3b2767c6, 0xfb893468, 0xafd34b26, 0xfbffd1b4],
    reversed_timestamp: 0x806c7d59,
    nbits: 0xffff7f1f,
    nonce: 0x00000229
};
const BLOCKHEADER_2006: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x575621cb, 0x581aa664, 0x12e60356, 0x528cb2c0, 0x715c23cc, 0x002363f0, 0x6f7966d9, 0xfc5f3a00],
    merkle_root: [0xaca789fc, 0x761297ec, 0x03775d75, 0x0e79e765, 0x024b1ca4, 0x0c5daf17, 0x3b9eda27, 0x73a7d7e5],
    reversed_timestamp: 0xe0757d59,
    nbits: 0xffff7f1f,
    nonce: 0x000000c2
};
const BLOCKHEADER_2007: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5fd9fc9c, 0x4591cc3d, 0xedee9b8f, 0x99770a8d, 0x9ec7d69a, 0x7693ecb6, 0x79c28b9e, 0x66c45d00],
    merkle_root: [0x3e87665f, 0xe528b1cf, 0xf7a82678, 0x517546b4, 0xdf205f8e, 0x7ca9857b, 0x5da7189e, 0x39cbfd56],
    reversed_timestamp: 0x407f7d59,
    nbits: 0xffff7f1f,
    nonce: 0x00000056
};
const BLOCKHEADER_2008: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7298798e, 0x624aaf2f, 0x089f5a2e, 0x12c10c11, 0xa77e28a2, 0xf44c669e, 0x435a7f4e, 0xc9665100],
    merkle_root: [0xc7314b75, 0x68ece4eb, 0x249c6262, 0xf58481b2, 0x6ba56b80, 0x9058cb7d, 0x21f8fc6e, 0x16cea86a],
    reversed_timestamp: 0xa0887d59,
    nbits: 0xffff7f1f,
    nonce: 0x00000023
};
const BLOCKHEADER_2009: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x89813a61, 0x3409d602, 0x22b5d560, 0xe1262bb7, 0x00195356, 0x030c9b62, 0xb0d773c7, 0x5a4d4100],
    merkle_root: [0x317c68fc, 0xbb7cd691, 0xc65ce1a7, 0x72e749d3, 0x520a6143, 0xf11a604a, 0x13a7f9a8, 0xafbd5deb],
    reversed_timestamp: 0x00927d59,
    nbits: 0xffff7f1f,
    nonce: 0x000000cd
};
const BLOCKHEADER_2010: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa13b8604, 0x673b0c84, 0x5060b273, 0xb03aefcd, 0x12bd633b, 0xbb431bae, 0xea12e602, 0x85386e00],
    merkle_root: [0x2783f743, 0xb0f5d951, 0x74834024, 0x1cb3ff00, 0xe71f9799, 0x5e92cdcf, 0x9f7e194c, 0x723a6e85],
    reversed_timestamp: 0x609b7d59,
    nbits: 0xffff7f1f,
    nonce: 0x00000348
};
const BLOCKHEADER_2011: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd3136b0e, 0xd97c08b0, 0xbfc8c3dc, 0xc812abe5, 0x6b645869, 0xfbf08935, 0x97134cb8, 0x96ac4600],
    merkle_root: [0xb9469c50, 0x4deb4039, 0x6df0bfbd, 0xaf22f94b, 0xbc65c91f, 0xa1436b48, 0xa2b094cd, 0xffafc0d5],
    reversed_timestamp: 0xc0a47d59,
    nbits: 0xffff7f1f,
    nonce: 0x000003e0
};
const BLOCKHEADER_2012: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9e49a0c3, 0x597cbdaa, 0x0d053cc7, 0x95d76ddf, 0x9a5c3d83, 0x5e40c1e7, 0xd57a8125, 0xbb8f7f00],
    merkle_root: [0x33a432ea, 0xba8d58f5, 0xff2dcc62, 0x4379b816, 0xc90c0f6f, 0x183ac298, 0x8cdadb0e, 0xd9786ef4],
    reversed_timestamp: 0x20ae7d59,
    nbits: 0xffff7f1f,
    nonce: 0x0000028c
};
const BLOCKHEADER_2013: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x86bc3572, 0xfe06c5dc, 0xcb448f27, 0x92ddaecf, 0x2406d240, 0xc242f074, 0x07517c1c, 0xdbba3900],
    merkle_root: [0x92214e62, 0xe82a7428, 0xee89d0f5, 0xaea9509c, 0x6ad790ea, 0xe603e5f2, 0x1b222d2c, 0x5bd2119a],
    reversed_timestamp: 0x80b77d59,
    nbits: 0xffff7f1f,
    nonce: 0x000006b0
};
const BLOCKHEADER_2014: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3843d4ac, 0x14d77777, 0x79660d01, 0x3a195a4e, 0x22b6f805, 0xea567ca0, 0x5c9a83df, 0x24113900],
    merkle_root: [0x8964069d, 0xaba586a1, 0x9a10b13c, 0xbd43c9f4, 0xfa5c65e2, 0x250cb83d, 0xab22af9e, 0x7f6b7dd1],
    reversed_timestamp: 0xe0c07d59,
    nbits: 0xffff7f1f,
    nonce: 0x00000091
};
const BLOCKHEADER_2015: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xff8d6d86, 0xe4a10f46, 0x17cd5af8, 0xc0e55560, 0x2f9f8e8d, 0x34d50fbc, 0xf2580c26, 0xefc01000],
    merkle_root: [0xfea8a3df, 0x04382ab0, 0x8e19f986, 0x476f1757, 0x58db48d6, 0x8bc4ab63, 0xd8823e3e, 0x0e3a9544],
    reversed_timestamp: 0x40ca7d59,
    nbits: 0xffff7f1f,
    nonce: 0x00000323
};
const BLOCKHEADER_2016: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe291b006, 0x2bb24318, 0x4e462c34, 0xffc0db87, 0xb1a0e8a0, 0xb818ce12, 0xa8eccd75, 0x0d396a00],
    merkle_root: [0x50ae1f63, 0x9fbea417, 0xe064bef2, 0xa85c81fc, 0x1a4593f0, 0x385d52bd, 0x30171f51, 0x80ea5115],
    reversed_timestamp: 0xa0d37d59,
    nbits: 0xd7950020,
    nonce: 0x00000100
};
const BLOCKHEADER_2017: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x99a0e69b, 0x6c27c98d, 0x5841e121, 0x34044af9, 0x43945030, 0x250d32d1, 0x150eb5ed, 0x84cc4a00],
    merkle_root: [0xc4c372a2, 0x71f4555b, 0xec9fcdaa, 0x79ea58ce, 0xc8221531, 0x825cb88c, 0x56bf20d5, 0x9ad7c30e],
    reversed_timestamp: 0x00dd7d59,
    nbits: 0xd7950020,
    nonce: 0x000003ec
};
const BLOCKHEADER_2018: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9d1708c4, 0xd8b0d093, 0xc277fcd4, 0x3524be40, 0x2c5a3eeb, 0x1522810a, 0x48e0d35e, 0xd0530d00],
    merkle_root: [0xc8637115, 0xc8ddc5d3, 0xbe032eba, 0x4d7fe859, 0x13ef905c, 0x9e282913, 0x42251c91, 0xe0d143d1],
    reversed_timestamp: 0x60e67d59,
    nbits: 0xd7950020,
    nonce: 0x00000262
};
const BLOCKHEADER_2019: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8b5786f3, 0x780ba6e9, 0xfdda1cd7, 0x012ccef2, 0x24bff7c4, 0x86713c4f, 0xdfff7d77, 0x37f56000],
    merkle_root: [0xcfe130d1, 0x51bf250c, 0x9ec267b1, 0x91cf1496, 0x4d1ea281, 0x1f2f5142, 0x12f6393f, 0x270bdf64],
    reversed_timestamp: 0xc0ef7d59,
    nbits: 0xd7950020,
    nonce: 0x00000533
};
const BLOCKHEADER_2020: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x751bd255, 0x746bfc6a, 0x5d818caa, 0x17e73f48, 0xaa296afc, 0x0852a3b1, 0x19434ec4, 0xd0f47d00],
    merkle_root: [0x5f1185c0, 0x370c3a1e, 0x771aa104, 0xca8e8cd2, 0xfece6b1f, 0x425fe65a, 0xb0ba7a46, 0xbcc1c76e],
    reversed_timestamp: 0x20f97d59,
    nbits: 0xd7950020,
    nonce: 0x00000284
};
const BLOCKHEADER_2021: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa3484f46, 0x4e72fa80, 0x7ebc07da, 0x18d37384, 0x6e328262, 0x575ae5be, 0x4aea8137, 0xd56d0f00],
    merkle_root: [0xec0fc55f, 0xfb3c6aff, 0x6242a6d9, 0x6a0648ab, 0x2dbdc913, 0x671b3f45, 0x3be2b849, 0xb87c755a],
    reversed_timestamp: 0x80027e59,
    nbits: 0xd7950020,
    nonce: 0x0000015d
};
const BLOCKHEADER_2022: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4d91902b, 0x568131ef, 0x47edbe8a, 0xf761936a, 0x440357b8, 0x8f16112e, 0x41ce2330, 0x864e2600],
    merkle_root: [0x3dc26818, 0xb22a67c1, 0x71978dc2, 0x0ccb2cd3, 0x47a54bf1, 0x4c95f47c, 0xe4535f5f, 0x2396adb6],
    reversed_timestamp: 0xe00b7e59,
    nbits: 0xd7950020,
    nonce: 0x00000083
};
const BLOCKHEADER_2023: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd2545e7f, 0x37add0a7, 0x72058377, 0x16be5a41, 0xd98c06b4, 0x13dcea5d, 0xea21aea0, 0xb2285600],
    merkle_root: [0x4061f547, 0x59971361, 0x65a1f660, 0x87aaa2bc, 0x1ddbd455, 0x1b1a18ec, 0xf584a284, 0xcdce1b2f],
    reversed_timestamp: 0x40157e59,
    nbits: 0xd7950020,
    nonce: 0x00000442
};
const BLOCKHEADER_2024: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x72214919, 0x06a612a9, 0x4ef8db13, 0xd1ccf6fc, 0x89f4957d, 0x2283efaa, 0x35a5d4a9, 0x64341a00],
    merkle_root: [0xb330cb7f, 0x2bb11094, 0x55e253f5, 0x03eaec06, 0x60c5ad0a, 0xf02658a7, 0x68dd6ab2, 0x6693f8e8],
    reversed_timestamp: 0xa01e7e59,
    nbits: 0xd7950020,
    nonce: 0x0000009e
};

pub const BLOCKHEADERS: [BlockHeader; 124] = [
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
];

pub const STORED_BLOCKHEADERS: [StoredBlockHeader; 125] = [
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1900,
        block_hash: [0xf0bfd844, 0x0b47361e, 0x2610cab7, 0x417d1887, 0x4a18ff8a, 0x47b9b555, 0xe828f619, 0x80d21200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000eda00,
        block_height: 1900,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501134000, 1501134600, 1501135200, 1501135800, 1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1901,
        block_hash: [0x1ed10ae1, 0xfbe16914, 0x2bc7a517, 0x9955d084, 0xf594931b, 0x96f9ff11, 0x7aa1226e, 0xfac25f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000edc00,
        block_height: 1901,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501134600, 1501135200, 1501135800, 1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1902,
        block_hash: [0xf199ae85, 0x0f8f2a7a, 0xce8baac2, 0x6dee70fd, 0x7c5e588e, 0xdbdd9c1c, 0xe4399e3b, 0x4c223600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ede00,
        block_height: 1902,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501135200, 1501135800, 1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501142400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1903,
        block_hash: [0x34a8960e, 0x78ca201d, 0xd3a3ef21, 0x95cd4033, 0x168845af, 0xfa5be269, 0x1bf09042, 0x2a800f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee000,
        block_height: 1903,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501135800, 1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501142400, 1501144800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1904,
        block_hash: [0x01f88da3, 0x725b17e3, 0x1fa73cf3, 0x40018835, 0xcd911f7f, 0xa419344a, 0xce622ac7, 0x51060200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee200,
        block_height: 1904,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501142400, 1501144800, 1501147200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1905,
        block_hash: [0x071884c2, 0x3a226d94, 0x8580f2b8, 0xfb453b1b, 0x561488f6, 0xf796379f, 0x8e934ca6, 0x011d1000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee400,
        block_height: 1905,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501142400, 1501144800, 1501147200, 1501149600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1906,
        block_hash: [0x82846a45, 0xdbdd082c, 0xb553b9ee, 0xcd36ac8d, 0xca3bea60, 0x8e9651ff, 0x43f75aaf, 0x1b1e6100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee600,
        block_height: 1906,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501142400, 1501144800, 1501147200, 1501149600, 1501152000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1907,
        block_hash: [0xea617eb0, 0x9061f36d, 0xf6792697, 0x27798722, 0x7efd5d29, 0xf9d8d610, 0x0394a6bd, 0xdec37000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee800,
        block_height: 1907,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501138200, 1501138800, 1501139400, 1501140000, 1501142400, 1501144800, 1501147200, 1501149600, 1501152000, 1501154400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1908,
        block_hash: [0xa4a84963, 0x35f16ce7, 0x79a673b5, 0xb20809db, 0x9554a47c, 0xc8f2a797, 0xca348943, 0xcb667e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000eea00,
        block_height: 1908,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501138800, 1501139400, 1501140000, 1501142400, 1501144800, 1501147200, 1501149600, 1501152000, 1501154400, 1501156800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1909,
        block_hash: [0x4b9f188a, 0x1b9fdc9e, 0xe180858c, 0x141701ca, 0x43eae170, 0x42b983de, 0x7fdb7f28, 0x96725200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000eec00,
        block_height: 1909,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501139400, 1501140000, 1501142400, 1501144800, 1501147200, 1501149600, 1501152000, 1501154400, 1501156800, 1501159200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1910,
        block_hash: [0xc28fe42f, 0x43fe5d09, 0x18b72e5e, 0x2ffec8b8, 0x772a924a, 0x8f7f7fd1, 0xf7e7ae7e, 0x4b787f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000eee00,
        block_height: 1910,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140000, 1501142400, 1501144800, 1501147200, 1501149600, 1501152000, 1501154400, 1501156800, 1501159200, 1501161600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1911,
        block_hash: [0xca9db28f, 0xb28efc2a, 0xb7737497, 0x979af69d, 0x5a1cd8eb, 0xc7229b69, 0x9ef469a9, 0x7a633900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef000,
        block_height: 1911,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501142400, 1501144800, 1501147200, 1501149600, 1501152000, 1501154400, 1501156800, 1501159200, 1501161600, 1501164000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1912,
        block_hash: [0x92281e0e, 0x63c0c9c0, 0x7c5732dc, 0xb26ec9e5, 0x3d007b3e, 0x06e9d5ad, 0xb6c2186a, 0xe0861300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef200,
        block_height: 1912,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501144800, 1501147200, 1501149600, 1501152000, 1501154400, 1501156800, 1501159200, 1501161600, 1501164000, 1501166400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1913,
        block_hash: [0xa0c2ce97, 0x4eb4dc11, 0xc4345bd2, 0xc5209d6f, 0x24cf815f, 0xd8d6f16c, 0x3319d264, 0xb95f7c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef400,
        block_height: 1913,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501147200, 1501149600, 1501152000, 1501154400, 1501156800, 1501159200, 1501161600, 1501164000, 1501166400, 1501168800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1914,
        block_hash: [0xb2a03cc9, 0xdc23e628, 0x22e88ed7, 0x1251d7be, 0x2c731c84, 0x877ce65e, 0x9907c7b1, 0x22377a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef600,
        block_height: 1914,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501149600, 1501152000, 1501154400, 1501156800, 1501159200, 1501161600, 1501164000, 1501166400, 1501168800, 1501171200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1915,
        block_hash: [0x7b64c11b, 0x9a2aaba3, 0xca452447, 0xc3dca64f, 0x840cc8e9, 0x389230e0, 0x830fced5, 0xb4a84e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef800,
        block_height: 1915,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501152000, 1501154400, 1501156800, 1501159200, 1501161600, 1501164000, 1501166400, 1501168800, 1501171200, 1501173600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1916,
        block_hash: [0xc2624c18, 0x2dfdf16c, 0x738ab009, 0x739de433, 0x6c4cc74c, 0x20e7ffab, 0xa3acd2c4, 0x667a7000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000efa00,
        block_height: 1916,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501154400, 1501156800, 1501159200, 1501161600, 1501164000, 1501166400, 1501168800, 1501171200, 1501173600, 1501176000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1917,
        block_hash: [0x5cbbcd7e, 0xc25a08e2, 0x17828e4b, 0xe1f9195e, 0xa60b494d, 0xf491b840, 0x2b60a1a6, 0x93752500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000efc00,
        block_height: 1917,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501156800, 1501159200, 1501161600, 1501164000, 1501166400, 1501168800, 1501171200, 1501173600, 1501176000, 1501178400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1918,
        block_hash: [0x1def4973, 0xddadd08f, 0x025801a3, 0x9cf51873, 0xbf798351, 0x7e22fc7e, 0xdd47723a, 0xecac0200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000efe00,
        block_height: 1918,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501159200, 1501161600, 1501164000, 1501166400, 1501168800, 1501171200, 1501173600, 1501176000, 1501178400, 1501180800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1919,
        block_hash: [0xaddc5b2e, 0x9ec4088d, 0x02f4a196, 0x0d0341ac, 0xcf533669, 0x2b317dbe, 0x79f3a316, 0x428a2400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0000,
        block_height: 1919,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501161600, 1501164000, 1501166400, 1501168800, 1501171200, 1501173600, 1501176000, 1501178400, 1501180800, 1501183200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1920,
        block_hash: [0x452b0bb2, 0xa6df0d38, 0x2d5b1c92, 0x18bdb2d5, 0x2808bf67, 0xc92b07bb, 0x0b200c27, 0xbc113100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0200,
        block_height: 1920,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501164000, 1501166400, 1501168800, 1501171200, 1501173600, 1501176000, 1501178400, 1501180800, 1501183200, 1501185600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1921,
        block_hash: [0x36534e1e, 0xcbc17626, 0xc1ec0364, 0x74c88c5f, 0xde527e02, 0x7eafabaa, 0x2d36d746, 0x867d1800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0400,
        block_height: 1921,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501166400, 1501168800, 1501171200, 1501173600, 1501176000, 1501178400, 1501180800, 1501183200, 1501185600, 1501188000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1922,
        block_hash: [0xe1d25079, 0xccf75db3, 0x28f70fa5, 0xd5b3bfc6, 0xa7543a39, 0x879be1e4, 0xa44df4a1, 0x0b803700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0600,
        block_height: 1922,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501168800, 1501171200, 1501173600, 1501176000, 1501178400, 1501180800, 1501183200, 1501185600, 1501188000, 1501190400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1923,
        block_hash: [0xec5f18a9, 0xb7c36dce, 0x890542f4, 0xd87af9ba, 0xfd3077c6, 0xf073d47f, 0x892f3522, 0xb9576a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0800,
        block_height: 1923,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501171200, 1501173600, 1501176000, 1501178400, 1501180800, 1501183200, 1501185600, 1501188000, 1501190400, 1501192800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1924,
        block_hash: [0x16b6de8a, 0x779052ac, 0x5e2b978b, 0x0e8ce454, 0x91649394, 0xfcb33824, 0xa058f0b4, 0x43417c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0a00,
        block_height: 1924,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501173600, 1501176000, 1501178400, 1501180800, 1501183200, 1501185600, 1501188000, 1501190400, 1501192800, 1501195200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1925,
        block_hash: [0x9ee7abbf, 0x14d5a0af, 0x3551f242, 0x22c3c5c5, 0x6c006b53, 0x3a9be8b6, 0x34baa797, 0x7bf03900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0c00,
        block_height: 1925,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501176000, 1501178400, 1501180800, 1501183200, 1501185600, 1501188000, 1501190400, 1501192800, 1501195200, 1501197600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1926,
        block_hash: [0xc13c6981, 0x2eaf24bf, 0xadee0d2c, 0x3d95bd35, 0x47ff13e7, 0x0c99c57d, 0x50f588f2, 0xa4261400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0e00,
        block_height: 1926,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501178400, 1501180800, 1501183200, 1501185600, 1501188000, 1501190400, 1501192800, 1501195200, 1501197600, 1501200000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1927,
        block_hash: [0xb2f8d803, 0x233d9efd, 0xd4d66860, 0xfcbe3708, 0x2f5fc66c, 0x76ccddf9, 0x99aad9af, 0x970e5b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1000,
        block_height: 1927,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501180800, 1501183200, 1501185600, 1501188000, 1501190400, 1501192800, 1501195200, 1501197600, 1501200000, 1501202400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1928,
        block_hash: [0x2047c133, 0x1172209d, 0x29358843, 0x1db0a419, 0xd2448042, 0x466c8f12, 0xccee2b7c, 0x2b637e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1200,
        block_height: 1928,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501183200, 1501185600, 1501188000, 1501190400, 1501192800, 1501195200, 1501197600, 1501200000, 1501202400, 1501204800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1929,
        block_hash: [0x959fc25f, 0x1eeaa0f5, 0x2c1bccb3, 0xcbe74372, 0x21c3bd39, 0xcc1b6d86, 0xb648af29, 0xe3986400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1400,
        block_height: 1929,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501185600, 1501188000, 1501190400, 1501192800, 1501195200, 1501197600, 1501200000, 1501202400, 1501204800, 1501207200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1930,
        block_hash: [0x6588494e, 0x26b8c2a9, 0x854c384f, 0x80cbef6c, 0x5d213dc4, 0x1dafd881, 0xdbac2afe, 0x53c00500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1600,
        block_height: 1930,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501188000, 1501190400, 1501192800, 1501195200, 1501197600, 1501200000, 1501202400, 1501204800, 1501207200, 1501209600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1931,
        block_hash: [0x7fca0e04, 0x520cfa60, 0x524bf672, 0xe54e55f5, 0x7f258241, 0x0712ce9d, 0x49aa23be, 0x24a64700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1800,
        block_height: 1931,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501190400, 1501192800, 1501195200, 1501197600, 1501200000, 1501202400, 1501204800, 1501207200, 1501209600, 1501212000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1932,
        block_hash: [0x1e9a7c18, 0x75fa7921, 0x1af64d80, 0xcc6dee1b, 0x7b6e3ab6, 0xdbfe09fb, 0x51d77288, 0x88d33e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1a00,
        block_height: 1932,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501192800, 1501195200, 1501197600, 1501200000, 1501202400, 1501204800, 1501207200, 1501209600, 1501212000, 1501214400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1933,
        block_hash: [0x31ad49ba, 0xbc58a536, 0x5da2c2be, 0xe4c2b54a, 0x1c2ef594, 0x145700ce, 0x377473a1, 0xe4de4700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1c00,
        block_height: 1933,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501195200, 1501197600, 1501200000, 1501202400, 1501204800, 1501207200, 1501209600, 1501212000, 1501214400, 1501216800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1934,
        block_hash: [0x33731dbf, 0x097d79e8, 0x08ba019c, 0xdd7f8479, 0x6c70391d, 0x6cec0865, 0x084fc349, 0x01041800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1e00,
        block_height: 1934,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501197600, 1501200000, 1501202400, 1501204800, 1501207200, 1501209600, 1501212000, 1501214400, 1501216800, 1501219200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1935,
        block_hash: [0x8a5888e6, 0x0bedae9a, 0xa505de17, 0x8fb7f82f, 0x3e2c20df, 0x4adab871, 0x62dcc0bd, 0xf8f10000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2000,
        block_height: 1935,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501200000, 1501202400, 1501204800, 1501207200, 1501209600, 1501212000, 1501214400, 1501216800, 1501219200, 1501221600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1936,
        block_hash: [0x354cf12e, 0x42b56ba9, 0xf22d6f98, 0xc503344c, 0x064f4c31, 0x70f89f86, 0xe200fc18, 0xcab03d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2200,
        block_height: 1936,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501202400, 1501204800, 1501207200, 1501209600, 1501212000, 1501214400, 1501216800, 1501219200, 1501221600, 1501224000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1937,
        block_hash: [0x4584354f, 0x9450e5e3, 0x7b89c840, 0xccdb0cc4, 0x698edb2c, 0x0e549b45, 0xb5ced8eb, 0x6ae62000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2400,
        block_height: 1937,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501204800, 1501207200, 1501209600, 1501212000, 1501214400, 1501216800, 1501219200, 1501221600, 1501224000, 1501226400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1938,
        block_hash: [0x1c02eb87, 0x2a7391bd, 0xdc5fec5a, 0x76f27431, 0x3bdc2042, 0x3fb9fb03, 0x7f6dd2ce, 0x96451d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2600,
        block_height: 1938,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501207200, 1501209600, 1501212000, 1501214400, 1501216800, 1501219200, 1501221600, 1501224000, 1501226400, 1501228800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1939,
        block_hash: [0x779989c5, 0xb3aebaa6, 0xf2c475d8, 0x607d058e, 0x875c0ea3, 0xe4b2b9db, 0x7f089150, 0x628e0900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2800,
        block_height: 1939,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501209600, 1501212000, 1501214400, 1501216800, 1501219200, 1501221600, 1501224000, 1501226400, 1501228800, 1501231200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1940,
        block_hash: [0xd738a68e, 0xf7103513, 0xe0ba21a9, 0x48ccbdfe, 0x9636648d, 0x1979b8d6, 0x80502f04, 0x34221f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2a00,
        block_height: 1940,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501212000, 1501214400, 1501216800, 1501219200, 1501221600, 1501224000, 1501226400, 1501228800, 1501231200, 1501233600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1941,
        block_hash: [0x954bba88, 0xecca3cd2, 0xf96cf508, 0xbf2ed36c, 0xaed902d0, 0x82eb103f, 0xb9850df3, 0x81ba4500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2c00,
        block_height: 1941,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501214400, 1501216800, 1501219200, 1501221600, 1501224000, 1501226400, 1501228800, 1501231200, 1501233600, 1501236000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1942,
        block_hash: [0x4df3eee2, 0x25482b2c, 0x07cae377, 0xfca9f501, 0xcd23b2f5, 0x9e80d582, 0xfc2d6d77, 0x253d3200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2e00,
        block_height: 1942,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501216800, 1501219200, 1501221600, 1501224000, 1501226400, 1501228800, 1501231200, 1501233600, 1501236000, 1501238400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1943,
        block_hash: [0x8d0b4e26, 0xd296b74c, 0x9816f91c, 0x58398c28, 0x4c408056, 0x9b67a068, 0x9c52d66b, 0x05e80400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3000,
        block_height: 1943,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501219200, 1501221600, 1501224000, 1501226400, 1501228800, 1501231200, 1501233600, 1501236000, 1501238400, 1501240800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1944,
        block_hash: [0x47d4bc42, 0x429c11e1, 0x532a36e7, 0xc023fa69, 0xbba7e742, 0x992c195d, 0xd33ce77d, 0x60595000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3200,
        block_height: 1944,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501221600, 1501224000, 1501226400, 1501228800, 1501231200, 1501233600, 1501236000, 1501238400, 1501240800, 1501243200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1945,
        block_hash: [0x3456d915, 0xf8f29881, 0xc571cc14, 0xc0862c4c, 0x7713f33b, 0xf153e179, 0x6044acb6, 0x89f66500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3400,
        block_height: 1945,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501224000, 1501226400, 1501228800, 1501231200, 1501233600, 1501236000, 1501238400, 1501240800, 1501243200, 1501245600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1946,
        block_hash: [0xbd08a5ce, 0xfbd48779, 0x97626bba, 0x2db1a35b, 0xb0c532fc, 0xfa4dcb6f, 0x700792d1, 0xe7c33f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3600,
        block_height: 1946,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501226400, 1501228800, 1501231200, 1501233600, 1501236000, 1501238400, 1501240800, 1501243200, 1501245600, 1501248000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1947,
        block_hash: [0xc2caca12, 0x05d6aff6, 0xaf7fece5, 0x1be5004b, 0x25ddbd48, 0xa1bfc6d8, 0xd688c23e, 0xb8c20200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3800,
        block_height: 1947,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501228800, 1501231200, 1501233600, 1501236000, 1501238400, 1501240800, 1501243200, 1501245600, 1501248000, 1501250400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1948,
        block_hash: [0x9bc9dc5a, 0x94832f25, 0xf8f9b92e, 0x28c2a66d, 0xb82cd237, 0x91df0cf2, 0xa4c36006, 0x2a4f5b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3a00,
        block_height: 1948,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501231200, 1501233600, 1501236000, 1501238400, 1501240800, 1501243200, 1501245600, 1501248000, 1501250400, 1501252800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1949,
        block_hash: [0x5f4d2c67, 0x8f335d00, 0x05b81f2e, 0x852103d0, 0x87ee6a32, 0xbf7130b3, 0xa011e63a, 0xe1c24800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3c00,
        block_height: 1949,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501233600, 1501236000, 1501238400, 1501240800, 1501243200, 1501245600, 1501248000, 1501250400, 1501252800, 1501255200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1950,
        block_hash: [0x46d6ed6b, 0x9606d5e5, 0xcd502c88, 0x80190938, 0x93257a2b, 0x9aa49f77, 0x20f4af4c, 0x35020900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3e00,
        block_height: 1950,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501236000, 1501238400, 1501240800, 1501243200, 1501245600, 1501248000, 1501250400, 1501252800, 1501255200, 1501257600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1951,
        block_hash: [0x18982e32, 0xc3bf963d, 0x9ce794ea, 0xbd92cdb1, 0xb9e39097, 0xfa2a4684, 0x2384392a, 0xfe5c5800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4000,
        block_height: 1951,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501238400, 1501240800, 1501243200, 1501245600, 1501248000, 1501250400, 1501252800, 1501255200, 1501257600, 1501260000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1952,
        block_hash: [0x2bd41f42, 0xa1dd6f95, 0xf4a0f484, 0x20344599, 0x631dac00, 0x38b68aa2, 0x8dbbced7, 0x7a624f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4200,
        block_height: 1952,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501240800, 1501243200, 1501245600, 1501248000, 1501250400, 1501252800, 1501255200, 1501257600, 1501260000, 1501262400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1953,
        block_hash: [0x32b7c382, 0x5b2382d4, 0xbee5dab6, 0xaf189f80, 0x3c7096dd, 0x241249fa, 0x8ce5493f, 0xdbd32b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4400,
        block_height: 1953,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501243200, 1501245600, 1501248000, 1501250400, 1501252800, 1501255200, 1501257600, 1501260000, 1501262400, 1501264800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1954,
        block_hash: [0x048cbd4a, 0x35eb46f0, 0x12051da0, 0x0bf6af01, 0x6fc97c11, 0x76ac7660, 0xa14d30c8, 0x50024e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4600,
        block_height: 1954,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501245600, 1501248000, 1501250400, 1501252800, 1501255200, 1501257600, 1501260000, 1501262400, 1501264800, 1501267200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1955,
        block_hash: [0xb045dbbd, 0x8887e457, 0x1fc67b4e, 0x14b5ecb4, 0xba83cad7, 0xe12c833d, 0xfad874af, 0xc1327f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4800,
        block_height: 1955,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501248000, 1501250400, 1501252800, 1501255200, 1501257600, 1501260000, 1501262400, 1501264800, 1501267200, 1501269600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1956,
        block_hash: [0x4e465858, 0x5e3a6659, 0x366b0ecf, 0x9ef50dfa, 0x8cbc4112, 0x9faa69e3, 0xae273a08, 0xb3692d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4a00,
        block_height: 1956,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501250400, 1501252800, 1501255200, 1501257600, 1501260000, 1501262400, 1501264800, 1501267200, 1501269600, 1501272000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1957,
        block_hash: [0x751c1675, 0xcbf0328a, 0x78d0363a, 0x3a8e4dcf, 0x3a8e22c7, 0x45c32aaa, 0x65444bd2, 0x41580100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4c00,
        block_height: 1957,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501252800, 1501255200, 1501257600, 1501260000, 1501262400, 1501264800, 1501267200, 1501269600, 1501272000, 1501274400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1958,
        block_hash: [0xfc683ebe, 0x413bb29f, 0x285e6470, 0xbb03ac7f, 0x1d7ca91c, 0xf97b1103, 0x186ecaff, 0x37716e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4e00,
        block_height: 1958,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501255200, 1501257600, 1501260000, 1501262400, 1501264800, 1501267200, 1501269600, 1501272000, 1501274400, 1501276800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1959,
        block_hash: [0x3a04be7b, 0xa1861b14, 0x87fa2bc2, 0x57916be8, 0x3703d8e1, 0xf9bb1e0e, 0x7b4765c9, 0x37457100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5000,
        block_height: 1959,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501257600, 1501260000, 1501262400, 1501264800, 1501267200, 1501269600, 1501272000, 1501274400, 1501276800, 1501279200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1960,
        block_hash: [0x38001165, 0x9a16ee2e, 0xa1dbfe43, 0xf521e5a6, 0x79d656ad, 0x4e92f222, 0xa544aa8d, 0xf75a6d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5200,
        block_height: 1960,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501260000, 1501262400, 1501264800, 1501267200, 1501269600, 1501272000, 1501274400, 1501276800, 1501279200, 1501281600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1961,
        block_hash: [0xfc1a529f, 0xf8190fc4, 0xc814c7b6, 0x61105aeb, 0xc8f810fd, 0x00ded077, 0xf1d75c05, 0xa2411e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5400,
        block_height: 1961,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501262400, 1501264800, 1501267200, 1501269600, 1501272000, 1501274400, 1501276800, 1501279200, 1501281600, 1501284000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1962,
        block_hash: [0x4e72b8c6, 0x50779733, 0x28f8b2d1, 0x50bb7399, 0xc0ec1d53, 0x37aa651b, 0xec08aae7, 0x8c197900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5600,
        block_height: 1962,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501264800, 1501267200, 1501269600, 1501272000, 1501274400, 1501276800, 1501279200, 1501281600, 1501284000, 1501286400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1963,
        block_hash: [0x644eac1e, 0x5363e1a5, 0x944b50e8, 0x1e42a099, 0x18572d7e, 0x3d934034, 0x1c73a491, 0x6df00400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5800,
        block_height: 1963,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501267200, 1501269600, 1501272000, 1501274400, 1501276800, 1501279200, 1501281600, 1501284000, 1501286400, 1501288800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1964,
        block_hash: [0xb72ec8a0, 0x3e8d9f84, 0xc09bbefd, 0xd6572f57, 0x84d9811a, 0x5926184d, 0xdddde690, 0xd7993b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5a00,
        block_height: 1964,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501269600, 1501272000, 1501274400, 1501276800, 1501279200, 1501281600, 1501284000, 1501286400, 1501288800, 1501291200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1965,
        block_hash: [0xd7a7063d, 0x217f912e, 0x12747ce5, 0x7754a117, 0x6bf3a912, 0xb5af15fa, 0x71a25dac, 0xd3d21b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5c00,
        block_height: 1965,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501272000, 1501274400, 1501276800, 1501279200, 1501281600, 1501284000, 1501286400, 1501288800, 1501291200, 1501293600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1966,
        block_hash: [0xe8f1fd2f, 0x713637b1, 0xd3379541, 0xc8349345, 0xaaae2fa3, 0x5a959a4d, 0x7f78639c, 0x7f5f5900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5e00,
        block_height: 1966,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501274400, 1501276800, 1501279200, 1501281600, 1501284000, 1501286400, 1501288800, 1501291200, 1501293600, 1501296000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1967,
        block_hash: [0xce04987d, 0x0fb15a60, 0xab41bf54, 0x6acbcc0b, 0xbf7fe5d7, 0xea2f2ab8, 0x9a3a6f85, 0x11f93300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6000,
        block_height: 1967,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501276800, 1501279200, 1501281600, 1501284000, 1501286400, 1501288800, 1501291200, 1501293600, 1501296000, 1501298400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1968,
        block_hash: [0x6fe422ec, 0x9adff92a, 0x54e1e29c, 0x756450a9, 0x1ad6305b, 0x25cfa617, 0x1277f704, 0xaa9d0300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6200,
        block_height: 1968,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501279200, 1501281600, 1501284000, 1501286400, 1501288800, 1501291200, 1501293600, 1501296000, 1501298400, 1501300800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1969,
        block_hash: [0x583015ed, 0x60346a2b, 0x22062a74, 0xbe861c45, 0x51765ea3, 0x8a9b68a6, 0xcd2c8c9c, 0x07b02100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6400,
        block_height: 1969,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501281600, 1501284000, 1501286400, 1501288800, 1501291200, 1501293600, 1501296000, 1501298400, 1501300800, 1501303200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1970,
        block_hash: [0xaa7fb744, 0x015b118a, 0x720f836e, 0xc6e1d792, 0xd4106c66, 0x99f4a235, 0xb074904f, 0x37234500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6600,
        block_height: 1970,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501284000, 1501286400, 1501288800, 1501291200, 1501293600, 1501296000, 1501298400, 1501300800, 1501303200, 1501305600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1971,
        block_hash: [0x4244016b, 0x886d426c, 0xdbe50e5b, 0xb6447059, 0x7fd4c394, 0xa6d2b5e8, 0x0474eaf5, 0xa3ca3c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6800,
        block_height: 1971,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501286400, 1501288800, 1501291200, 1501293600, 1501296000, 1501298400, 1501300800, 1501303200, 1501305600, 1501308000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1972,
        block_hash: [0x1d79d474, 0xc1cfd3f1, 0x2cc39d7e, 0x85e186bd, 0x887ab05e, 0xa48c98a4, 0x4683fc23, 0xbe9f0c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6a00,
        block_height: 1972,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501288800, 1501291200, 1501293600, 1501296000, 1501298400, 1501300800, 1501303200, 1501305600, 1501308000, 1501310400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1973,
        block_hash: [0x04b554e3, 0x28ff8d04, 0x8ff95fa1, 0xba4ad71f, 0x834360cf, 0x1a3c896a, 0xd613e57f, 0xb5d83600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6c00,
        block_height: 1973,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501291200, 1501293600, 1501296000, 1501298400, 1501300800, 1501303200, 1501305600, 1501308000, 1501310400, 1501312800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1974,
        block_hash: [0x2dd5c179, 0xd88560dc, 0xbf2e096a, 0x100ce43e, 0x75e9e5e0, 0xd53553db, 0xa87260eb, 0xae9c7900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6e00,
        block_height: 1974,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501293600, 1501296000, 1501298400, 1501300800, 1501303200, 1501305600, 1501308000, 1501310400, 1501312800, 1501315200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1975,
        block_hash: [0x756b67b8, 0x107b9e35, 0x96c47abc, 0xed651c51, 0xe593b81f, 0xb1ef852b, 0xfc061945, 0xee412200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7000,
        block_height: 1975,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501296000, 1501298400, 1501300800, 1501303200, 1501305600, 1501308000, 1501310400, 1501312800, 1501315200, 1501317600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1976,
        block_hash: [0x4ed19946, 0x1be93e07, 0xcccffef4, 0xc72a03ac, 0x96058e8f, 0xa07477b5, 0xfbbbc7d4, 0xa0cc0800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7200,
        block_height: 1976,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501298400, 1501300800, 1501303200, 1501305600, 1501308000, 1501310400, 1501312800, 1501315200, 1501317600, 1501320000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1977,
        block_hash: [0x7c3b3a57, 0xed4e0b40, 0xf4ad1fce, 0x32fc29f2, 0x6f38e37f, 0xcc229712, 0x56e3a51f, 0x6e290c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7400,
        block_height: 1977,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501300800, 1501303200, 1501305600, 1501308000, 1501310400, 1501312800, 1501315200, 1501317600, 1501320000, 1501322400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1978,
        block_hash: [0x67aa5155, 0xafd1f9eb, 0xf043f5e4, 0xcc51fc0d, 0xb902183c, 0xf8acdbb7, 0x2d130af4, 0xa5087600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7600,
        block_height: 1978,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501303200, 1501305600, 1501308000, 1501310400, 1501312800, 1501315200, 1501317600, 1501320000, 1501322400, 1501324800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1979,
        block_hash: [0x13804384, 0x9a6e1dd3, 0xad458cbd, 0xaf3191e1, 0x023d2faf, 0xd0c1ce15, 0x37448f2b, 0x5f075800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7800,
        block_height: 1979,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501305600, 1501308000, 1501310400, 1501312800, 1501315200, 1501317600, 1501320000, 1501322400, 1501324800, 1501327200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1980,
        block_hash: [0x87ed5329, 0x8179a52b, 0xfc7b5c10, 0xfa810831, 0xedc9527b, 0x0a67dc8e, 0x2c28d56c, 0x6b234d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7a00,
        block_height: 1980,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501308000, 1501310400, 1501312800, 1501315200, 1501317600, 1501320000, 1501322400, 1501324800, 1501327200, 1501329600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1981,
        block_hash: [0xd875c70a, 0x1c9d1f37, 0xdf55943b, 0x36fe44a8, 0x6fd6b6dc, 0xa32bb4d9, 0xd6ca42e0, 0x0bbe1c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7c00,
        block_height: 1981,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501310400, 1501312800, 1501315200, 1501317600, 1501320000, 1501322400, 1501324800, 1501327200, 1501329600, 1501332000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1982,
        block_hash: [0x4968de46, 0xf5e15d33, 0x94db30cb, 0xc649f8e4, 0x47b26406, 0x76569840, 0xdadeb83c, 0xa5992b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7e00,
        block_height: 1982,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501312800, 1501315200, 1501317600, 1501320000, 1501322400, 1501324800, 1501327200, 1501329600, 1501332000, 1501334400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1983,
        block_hash: [0x1f0452e6, 0x44744bf1, 0x8eafc409, 0xcb2bdd60, 0xa75a0cdd, 0x90e1362a, 0xc3063b0a, 0x1e577600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8000,
        block_height: 1983,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501315200, 1501317600, 1501320000, 1501322400, 1501324800, 1501327200, 1501329600, 1501332000, 1501334400, 1501336800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1984,
        block_hash: [0x1f25225d, 0x1e0c2d24, 0x4a745f8a, 0xde4cfb5e, 0xd1577fcb, 0x764bde67, 0x881b71f1, 0x56a82800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8200,
        block_height: 1984,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501317600, 1501320000, 1501322400, 1501324800, 1501327200, 1501329600, 1501332000, 1501334400, 1501336800, 1501339200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1985,
        block_hash: [0xac3ba336, 0xeeac40af, 0xe6c4abea, 0x2df4b236, 0x34c728df, 0xff01ee05, 0x172a65e0, 0x93982300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8400,
        block_height: 1985,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501320000, 1501322400, 1501324800, 1501327200, 1501329600, 1501332000, 1501334400, 1501336800, 1501339200, 1501341600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1986,
        block_hash: [0x9ec5fa4a, 0x94f57987, 0x605a3b73, 0x7501bfcd, 0xffa86446, 0xd3fbc267, 0xebf953df, 0xb0b24100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8600,
        block_height: 1986,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501322400, 1501324800, 1501327200, 1501329600, 1501332000, 1501334400, 1501336800, 1501339200, 1501341600, 1501344000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1987,
        block_hash: [0xfd943529, 0x2ec83c67, 0xc454046e, 0xe9c9af6a, 0x986cd956, 0xaca919fa, 0x3cfdb673, 0xb19a7a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8800,
        block_height: 1987,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501324800, 1501327200, 1501329600, 1501332000, 1501334400, 1501336800, 1501339200, 1501341600, 1501344000, 1501346400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1988,
        block_hash: [0x35a6024f, 0x22e67430, 0xd001a774, 0x64e8c995, 0xe63a588f, 0x38627b0e, 0x73c61087, 0x38601700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8a00,
        block_height: 1988,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501327200, 1501329600, 1501332000, 1501334400, 1501336800, 1501339200, 1501341600, 1501344000, 1501346400, 1501348800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1989,
        block_hash: [0x5009cb1c, 0xd7fca022, 0xd1b7e418, 0x0baea29e, 0x8bfbb5a3, 0xae53c32e, 0x651b47f1, 0x67fc2c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8c00,
        block_height: 1989,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501329600, 1501332000, 1501334400, 1501336800, 1501339200, 1501341600, 1501344000, 1501346400, 1501348800, 1501351200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1990,
        block_hash: [0x0c7601e9, 0x8ff42344, 0xfe6c7851, 0xc21381a8, 0xaa56d485, 0xde6bd8cb, 0x58adf44b, 0xb28d3100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8e00,
        block_height: 1990,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501332000, 1501334400, 1501336800, 1501339200, 1501341600, 1501344000, 1501346400, 1501348800, 1501351200, 1501353600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1991,
        block_hash: [0x4caa3400, 0x7c9857f8, 0x8495d411, 0x79ef4a42, 0xa23b4d9f, 0xd7c3bcef, 0xd9084ed9, 0x5d115d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9000,
        block_height: 1991,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501334400, 1501336800, 1501339200, 1501341600, 1501344000, 1501346400, 1501348800, 1501351200, 1501353600, 1501356000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1992,
        block_hash: [0x43367f50, 0xaaa79d84, 0x8676ba15, 0x7ea6832e, 0x9a3e4550, 0x145e596e, 0x6b0e791e, 0xc44c1e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9200,
        block_height: 1992,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501336800, 1501339200, 1501341600, 1501344000, 1501346400, 1501348800, 1501351200, 1501353600, 1501356000, 1501358400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1993,
        block_hash: [0x030a444a, 0xd00687d0, 0x61d375df, 0x307d122d, 0x4b8651db, 0x58a1fe8a, 0x09a29f0e, 0xdcbf5c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9400,
        block_height: 1993,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501339200, 1501341600, 1501344000, 1501346400, 1501348800, 1501351200, 1501353600, 1501356000, 1501358400, 1501360800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1994,
        block_hash: [0x1e244f2a, 0x7a71a814, 0x33cdef55, 0xf7b83367, 0x3eab5c8e, 0xd95cec2e, 0xf46fedf9, 0xacb25700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9600,
        block_height: 1994,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501341600, 1501344000, 1501346400, 1501348800, 1501351200, 1501353600, 1501356000, 1501358400, 1501360800, 1501363200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1995,
        block_hash: [0x96cf1744, 0x6f168a08, 0x5c57d39a, 0x70b25e0b, 0x07786eb6, 0x43ec71d6, 0x33b3f619, 0xe6775000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9800,
        block_height: 1995,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501344000, 1501346400, 1501348800, 1501351200, 1501353600, 1501356000, 1501358400, 1501360800, 1501363200, 1501365600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1996,
        block_hash: [0x318570c3, 0xf39c6312, 0x52656073, 0x4fb4a840, 0x445a62d4, 0xa6d22442, 0x5dc30800, 0x9a227b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9a00,
        block_height: 1996,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501346400, 1501348800, 1501351200, 1501353600, 1501356000, 1501358400, 1501360800, 1501363200, 1501365600, 1501368000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1997,
        block_hash: [0x85627123, 0x221f0be9, 0xf517ba0c, 0x2a57913b, 0x471055e3, 0x94bde12e, 0x9feebe04, 0xc4675c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9c00,
        block_height: 1997,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501348800, 1501351200, 1501353600, 1501356000, 1501358400, 1501360800, 1501363200, 1501365600, 1501368000, 1501370400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1998,
        block_hash: [0x56fd4f48, 0xc1389fcc, 0x8e7f472b, 0xc57623ff, 0x617874de, 0xefbbf14a, 0xce683667, 0xf54a7f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9e00,
        block_height: 1998,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501351200, 1501353600, 1501356000, 1501358400, 1501360800, 1501363200, 1501365600, 1501368000, 1501370400, 1501372800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1999,
        block_hash: [0x49ebcfff, 0x9ca774e3, 0x84734638, 0xa13e117f, 0xe17d5dd8, 0x519c1ebc, 0xa26e3fa5, 0xbfbc5a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa000,
        block_height: 1999,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501353600, 1501356000, 1501358400, 1501360800, 1501363200, 1501365600, 1501368000, 1501370400, 1501372800, 1501375200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2000,
        block_hash: [0xfb22fd7e, 0x88aeac22, 0xe22f0252, 0x929b04b1, 0x5587a096, 0x89e11214, 0xf0d5154c, 0x726b2d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa200,
        block_height: 2000,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501356000, 1501358400, 1501360800, 1501363200, 1501365600, 1501368000, 1501370400, 1501372800, 1501375200, 1501377600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2001,
        block_hash: [0xf30e5f18, 0x17727b43, 0x02e343c9, 0xf5d4362f, 0x915b6833, 0x6c9c92b4, 0x18e8ad4b, 0x9b691500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa400,
        block_height: 2001,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501358400, 1501360800, 1501363200, 1501365600, 1501368000, 1501370400, 1501372800, 1501375200, 1501377600, 1501380000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2002,
        block_hash: [0x9d8e1cf6, 0x7b05f01d, 0xac0934a3, 0xc62f5bc3, 0xbb478747, 0xabb25b74, 0x9ea5f44e, 0xde4a1700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa600,
        block_height: 2002,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501360800, 1501363200, 1501365600, 1501368000, 1501370400, 1501372800, 1501375200, 1501377600, 1501380000, 1501382400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2003,
        block_hash: [0x5f858e76, 0x9c779bb4, 0xad854570, 0x870b0f77, 0x2af13930, 0x08cee56d, 0x34b45bc8, 0x22cf3200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa800,
        block_height: 2003,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501363200, 1501365600, 1501368000, 1501370400, 1501372800, 1501375200, 1501377600, 1501380000, 1501382400, 1501384800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2004,
        block_hash: [0xad1ef21d, 0x939fea80, 0xb883e925, 0xd1d20d1c, 0x7cd49b40, 0xdda9f665, 0x18792ae6, 0x477b6900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000faa00,
        block_height: 2004,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501365600, 1501368000, 1501370400, 1501372800, 1501375200, 1501377600, 1501380000, 1501382400, 1501384800, 1501387200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2005,
        block_hash: [0x575621cb, 0x581aa664, 0x12e60356, 0x528cb2c0, 0x715c23cc, 0x002363f0, 0x6f7966d9, 0xfc5f3a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fac00,
        block_height: 2005,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501368000, 1501370400, 1501372800, 1501375200, 1501377600, 1501380000, 1501382400, 1501384800, 1501387200, 1501389600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2006,
        block_hash: [0x5fd9fc9c, 0x4591cc3d, 0xedee9b8f, 0x99770a8d, 0x9ec7d69a, 0x7693ecb6, 0x79c28b9e, 0x66c45d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fae00,
        block_height: 2006,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501370400, 1501372800, 1501375200, 1501377600, 1501380000, 1501382400, 1501384800, 1501387200, 1501389600, 1501392000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2007,
        block_hash: [0x7298798e, 0x624aaf2f, 0x089f5a2e, 0x12c10c11, 0xa77e28a2, 0xf44c669e, 0x435a7f4e, 0xc9665100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb000,
        block_height: 2007,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501372800, 1501375200, 1501377600, 1501380000, 1501382400, 1501384800, 1501387200, 1501389600, 1501392000, 1501394400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2008,
        block_hash: [0x89813a61, 0x3409d602, 0x22b5d560, 0xe1262bb7, 0x00195356, 0x030c9b62, 0xb0d773c7, 0x5a4d4100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb200,
        block_height: 2008,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501375200, 1501377600, 1501380000, 1501382400, 1501384800, 1501387200, 1501389600, 1501392000, 1501394400, 1501396800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2009,
        block_hash: [0xa13b8604, 0x673b0c84, 0x5060b273, 0xb03aefcd, 0x12bd633b, 0xbb431bae, 0xea12e602, 0x85386e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb400,
        block_height: 2009,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501377600, 1501380000, 1501382400, 1501384800, 1501387200, 1501389600, 1501392000, 1501394400, 1501396800, 1501399200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2010,
        block_hash: [0xd3136b0e, 0xd97c08b0, 0xbfc8c3dc, 0xc812abe5, 0x6b645869, 0xfbf08935, 0x97134cb8, 0x96ac4600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb600,
        block_height: 2010,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501380000, 1501382400, 1501384800, 1501387200, 1501389600, 1501392000, 1501394400, 1501396800, 1501399200, 1501401600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2011,
        block_hash: [0x9e49a0c3, 0x597cbdaa, 0x0d053cc7, 0x95d76ddf, 0x9a5c3d83, 0x5e40c1e7, 0xd57a8125, 0xbb8f7f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb800,
        block_height: 2011,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501382400, 1501384800, 1501387200, 1501389600, 1501392000, 1501394400, 1501396800, 1501399200, 1501401600, 1501404000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2012,
        block_hash: [0x86bc3572, 0xfe06c5dc, 0xcb448f27, 0x92ddaecf, 0x2406d240, 0xc242f074, 0x07517c1c, 0xdbba3900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fba00,
        block_height: 2012,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501384800, 1501387200, 1501389600, 1501392000, 1501394400, 1501396800, 1501399200, 1501401600, 1501404000, 1501406400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2013,
        block_hash: [0x3843d4ac, 0x14d77777, 0x79660d01, 0x3a195a4e, 0x22b6f805, 0xea567ca0, 0x5c9a83df, 0x24113900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fbc00,
        block_height: 2013,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501387200, 1501389600, 1501392000, 1501394400, 1501396800, 1501399200, 1501401600, 1501404000, 1501406400, 1501408800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2014,
        block_hash: [0xff8d6d86, 0xe4a10f46, 0x17cd5af8, 0xc0e55560, 0x2f9f8e8d, 0x34d50fbc, 0xf2580c26, 0xefc01000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fbe00,
        block_height: 2014,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501389600, 1501392000, 1501394400, 1501396800, 1501399200, 1501401600, 1501404000, 1501406400, 1501408800, 1501411200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2015,
        block_hash: [0xe291b006, 0x2bb24318, 0x4e462c34, 0xffc0db87, 0xb1a0e8a0, 0xb818ce12, 0xa8eccd75, 0x0d396a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc000,
        block_height: 2015,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501392000, 1501394400, 1501396800, 1501399200, 1501401600, 1501404000, 1501406400, 1501408800, 1501411200, 1501413600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2016,
        block_hash: [0x99a0e69b, 0x6c27c98d, 0x5841e121, 0x34044af9, 0x43945030, 0x250d32d1, 0x150eb5ed, 0x84cc4a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc1b5,
        block_height: 2016,
        last_diff_adjustment: 1501418400,
        prev_block_timestamps: [1501394400, 1501396800, 1501399200, 1501401600, 1501404000, 1501406400, 1501408800, 1501411200, 1501413600, 1501416000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2017,
        block_hash: [0x9d1708c4, 0xd8b0d093, 0xc277fcd4, 0x3524be40, 0x2c5a3eeb, 0x1522810a, 0x48e0d35e, 0xd0530d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc36a,
        block_height: 2017,
        last_diff_adjustment: 1501418400,
        prev_block_timestamps: [1501396800, 1501399200, 1501401600, 1501404000, 1501406400, 1501408800, 1501411200, 1501413600, 1501416000, 1501418400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2018,
        block_hash: [0x8b5786f3, 0x780ba6e9, 0xfdda1cd7, 0x012ccef2, 0x24bff7c4, 0x86713c4f, 0xdfff7d77, 0x37f56000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc51f,
        block_height: 2018,
        last_diff_adjustment: 1501418400,
        prev_block_timestamps: [1501399200, 1501401600, 1501404000, 1501406400, 1501408800, 1501411200, 1501413600, 1501416000, 1501418400, 1501420800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2019,
        block_hash: [0x751bd255, 0x746bfc6a, 0x5d818caa, 0x17e73f48, 0xaa296afc, 0x0852a3b1, 0x19434ec4, 0xd0f47d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc6d4,
        block_height: 2019,
        last_diff_adjustment: 1501418400,
        prev_block_timestamps: [1501401600, 1501404000, 1501406400, 1501408800, 1501411200, 1501413600, 1501416000, 1501418400, 1501420800, 1501423200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2020,
        block_hash: [0xa3484f46, 0x4e72fa80, 0x7ebc07da, 0x18d37384, 0x6e328262, 0x575ae5be, 0x4aea8137, 0xd56d0f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc889,
        block_height: 2020,
        last_diff_adjustment: 1501418400,
        prev_block_timestamps: [1501404000, 1501406400, 1501408800, 1501411200, 1501413600, 1501416000, 1501418400, 1501420800, 1501423200, 1501425600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2021,
        block_hash: [0x4d91902b, 0x568131ef, 0x47edbe8a, 0xf761936a, 0x440357b8, 0x8f16112e, 0x41ce2330, 0x864e2600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fca3e,
        block_height: 2021,
        last_diff_adjustment: 1501418400,
        prev_block_timestamps: [1501406400, 1501408800, 1501411200, 1501413600, 1501416000, 1501418400, 1501420800, 1501423200, 1501425600, 1501428000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2022,
        block_hash: [0xd2545e7f, 0x37add0a7, 0x72058377, 0x16be5a41, 0xd98c06b4, 0x13dcea5d, 0xea21aea0, 0xb2285600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fcbf3,
        block_height: 2022,
        last_diff_adjustment: 1501418400,
        prev_block_timestamps: [1501408800, 1501411200, 1501413600, 1501416000, 1501418400, 1501420800, 1501423200, 1501425600, 1501428000, 1501430400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2023,
        block_hash: [0x72214919, 0x06a612a9, 0x4ef8db13, 0xd1ccf6fc, 0x89f4957d, 0x2283efaa, 0x35a5d4a9, 0x64341a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fcda8,
        block_height: 2023,
        last_diff_adjustment: 1501418400,
        prev_block_timestamps: [1501411200, 1501413600, 1501416000, 1501418400, 1501420800, 1501423200, 1501425600, 1501428000, 1501430400, 1501432800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2024,
        block_hash: [0x2541970b, 0x7fa38830, 0xe238d590, 0x2a41714a, 0x38ceff31, 0x1dfa1d4a, 0xfaaff52d, 0x8df92500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fcf5d,
        block_height: 2024,
        last_diff_adjustment: 1501418400,
        prev_block_timestamps: [1501413600, 1501416000, 1501418400, 1501420800, 1501423200, 1501425600, 1501428000, 1501430400, 1501432800, 1501435200]
    },
];
