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
    merkle_root: [0x393f4963, 0xed62ad52, 0xb449161b, 0x1797f8c5, 0x8d1216db, 0x6186998e, 0x9d1ea5e6, 0x0818c98a],
    reversed_timestamp: 0x78967959,
    nbits: 0xffff7f1f,
    nonce: 0x0000000c
};
const BLOCKHEADER_1902: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa644e45f, 0x59a32043, 0x4147256f, 0x09d9e38f, 0xe0cc6490, 0x2431ad22, 0x67afccbf, 0xac150300],
    merkle_root: [0x1fd69d3b, 0x48206f3c, 0xbf79b531, 0x6eb9740c, 0x029a22a8, 0x698f1a59, 0x3c6357b6, 0x6e9356f4],
    reversed_timestamp: 0xd0987959,
    nbits: 0xffff7f1f,
    nonce: 0x00000220
};
const BLOCKHEADER_1903: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3a0404f0, 0x2ed35711, 0x2c97bbc7, 0xb0a09258, 0xfd14419d, 0x9628631c, 0xf8244756, 0xcc802900],
    merkle_root: [0x544e8e1d, 0x8426b13e, 0x01db0e80, 0xe1e2a6d0, 0xfb6f0e87, 0xd0dc87c1, 0x73385ba9, 0x2554b9db],
    reversed_timestamp: 0x289b7959,
    nbits: 0xffff7f1f,
    nonce: 0x0000005f
};
const BLOCKHEADER_1904: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x46f58296, 0x1598ac90, 0xdc79ea84, 0xe9c66110, 0x3d0561f2, 0x206f1227, 0x79e89db7, 0xe10f6600],
    merkle_root: [0xb61f10b5, 0xa1b5733c, 0x8d83973a, 0x9e756e21, 0x95596d47, 0xd7593eef, 0xb90a47d3, 0x3144b9ed],
    reversed_timestamp: 0x809d7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000090
};
const BLOCKHEADER_1905: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf417c67f, 0x86d846d4, 0xbd99a0a3, 0xe0e62759, 0xf8ee6f5c, 0x292e8433, 0xad6d80ec, 0x3c9e2000],
    merkle_root: [0xa5a22aae, 0x3cb83219, 0xac102ed1, 0x9ea7cfd5, 0x3e61639f, 0x8ed281a5, 0xec02acaa, 0x2746eeab],
    reversed_timestamp: 0xd89f7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000036
};
const BLOCKHEADER_1906: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xbefa4bb8, 0x5357c21c, 0x5b9c6d82, 0x7b5d2155, 0x3aea974c, 0xb1cfbfc5, 0x6151c691, 0xc7cb4100],
    merkle_root: [0x4ae9184b, 0xad9f843d, 0xd4ecc905, 0xd5a3cff6, 0x19d006c0, 0x6db2a375, 0x1476372c, 0x98a2efb2],
    reversed_timestamp: 0x30a27959,
    nbits: 0xffff7f1f,
    nonce: 0x00000139
};
const BLOCKHEADER_1907: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5c6c27bb, 0x04a40cd9, 0x3de85058, 0x8a46ee6d, 0x610e2837, 0xb4f58052, 0x43924d30, 0x9d810c00],
    merkle_root: [0x987442d2, 0x2721352b, 0x938ea2f6, 0x3ea9fc3b, 0x1570994d, 0x9c40de07, 0x5480d242, 0x133f5995],
    reversed_timestamp: 0x88a47959,
    nbits: 0xffff7f1f,
    nonce: 0x0000016f
};
const BLOCKHEADER_1908: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x72415b0c, 0x602b8576, 0xb7dbc296, 0x9a011402, 0x9019078b, 0xdf6a0412, 0x9f0ca74f, 0x94111700],
    merkle_root: [0x377da1e7, 0x871301e3, 0xc4d143cc, 0xc93df222, 0x60805b7d, 0xaf5b724b, 0x6c7e21e5, 0x70c5c2c8],
    reversed_timestamp: 0xe0a67959,
    nbits: 0xffff7f1f,
    nonce: 0x0000003f
};
const BLOCKHEADER_1909: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd118bada, 0xeee52c89, 0xe962e6c6, 0x1fd8b81e, 0x19b4f1a3, 0xbd29ebcf, 0x0209066c, 0x2ec41400],
    merkle_root: [0x4b2e1df3, 0x925908af, 0x80bca3fd, 0x57d32ab8, 0x14e0be61, 0xb6e6f069, 0xd4a04e03, 0xd5e12af8],
    reversed_timestamp: 0x38a97959,
    nbits: 0xffff7f1f,
    nonce: 0x00000ad1
};
const BLOCKHEADER_1910: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x27ebdad4, 0x34f256c5, 0xd848de93, 0xe957a34f, 0x3dc26714, 0x56e50dfa, 0xc9d647e8, 0xa5fb2900],
    merkle_root: [0xfeb0cd8e, 0x8db2697a, 0x7936bfd5, 0x1f563d79, 0x69fa8181, 0xe5733851, 0x6788a2ff, 0xb15fe6ec],
    reversed_timestamp: 0x90ab7959,
    nbits: 0xffff7f1f,
    nonce: 0x0000067b
};
const BLOCKHEADER_1911: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x0e3b6c26, 0xfd8ff06c, 0xa7e7ac64, 0xa8914d1f, 0xbf33f0d0, 0xc16f520b, 0x364187e5, 0xdacc6000],
    merkle_root: [0x73e9e3d0, 0xda2f0eba, 0x80f54efd, 0xc3b1a682, 0x45e9c9a5, 0xea5b1617, 0x7320e4f0, 0x0c58805a],
    reversed_timestamp: 0xe8ad7959,
    nbits: 0xffff7f1f,
    nonce: 0x000001d6
};
const BLOCKHEADER_1912: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9be9b953, 0xc0707179, 0xaf7a1c2e, 0x171ea18d, 0xa802bec1, 0x2fa0c1cc, 0xcc9031b3, 0xe94f5800],
    merkle_root: [0xa8c3a602, 0x8f82317f, 0x5bc4720a, 0x75304a44, 0x677f1552, 0xab633e00, 0x52d382ef, 0x5eecb90c],
    reversed_timestamp: 0x40b07959,
    nbits: 0xffff7f1f,
    nonce: 0x0000008f
};
const BLOCKHEADER_1913: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xdf2719ae, 0xc4ec2035, 0x6d261f41, 0xf0810fe4, 0xd0cc4d7f, 0x3e16e1ec, 0x4fc21572, 0xc6b23600],
    merkle_root: [0x6a98c006, 0xea578a59, 0x30d310f4, 0xe53991ff, 0xddeae622, 0x9350827d, 0xfade76a3, 0xda3238ba],
    reversed_timestamp: 0x98b27959,
    nbits: 0xffff7f1f,
    nonce: 0x000003a3
};
const BLOCKHEADER_1914: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1f32e6ae, 0x12402df9, 0x12ce5e96, 0x298c8e88, 0x0c08241a, 0xd968715d, 0xca4c7e12, 0x5a0f3b00],
    merkle_root: [0xcebc3cd1, 0xf910f23d, 0x832f9170, 0x6c6b5b28, 0x13a9729c, 0x601752e7, 0x7786df19, 0x4be0ac4b],
    reversed_timestamp: 0xf0b47959,
    nbits: 0xffff7f1f,
    nonce: 0x000002aa
};
const BLOCKHEADER_1915: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb64ca86b, 0x72502d18, 0x5e97facf, 0x4e287b29, 0x0e896e01, 0x828baa1a, 0x235f7f34, 0xc4273500],
    merkle_root: [0x2431985c, 0x17517a57, 0x0277a115, 0x88a679da, 0x14b0d12f, 0x99c8b8b1, 0xfa16f042, 0x8b8eec62],
    reversed_timestamp: 0x48b77959,
    nbits: 0xffff7f1f,
    nonce: 0x0000006f
};
const BLOCKHEADER_1916: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe3c55c07, 0x2ff66bb0, 0x5dfb0604, 0xbb0ce081, 0x7f5196df, 0xf2a3fe65, 0x5c48c25a, 0x60be5c00],
    merkle_root: [0xfff3a3a9, 0x08593d48, 0xa9f7b146, 0x2b2a4ba1, 0xb129baf4, 0xa18df087, 0x1086b865, 0x38291716],
    reversed_timestamp: 0xa0b97959,
    nbits: 0xffff7f1f,
    nonce: 0x0000017c
};
const BLOCKHEADER_1917: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd82c8c23, 0x22521d73, 0xc0e5cef1, 0xa10a7f7c, 0x171e609f, 0x55b14fa7, 0xc4cb0e52, 0x81837d00],
    merkle_root: [0xd2ffecb7, 0xc605c7ce, 0x22f0f8d2, 0x31571d51, 0x73b2df29, 0xc4699021, 0xa294b9c7, 0x175bd366],
    reversed_timestamp: 0xf8bb7959,
    nbits: 0xffff7f1f,
    nonce: 0x000000d5
};
const BLOCKHEADER_1918: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf0c597d6, 0xac3cb66f, 0x52a59560, 0x8b5e4123, 0xc74256a6, 0x81ce179a, 0xd436f537, 0x07306000],
    merkle_root: [0xa735dc82, 0x0ffc8fa3, 0xa9dddffe, 0x87f171be, 0xce724245, 0x4674c61b, 0x3b381f14, 0x445666ba],
    reversed_timestamp: 0x50be7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000058
};
const BLOCKHEADER_1919: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa9640b9c, 0xf89d9785, 0xfd378847, 0x312bfec4, 0xe250c34d, 0xac6a05cf, 0xea46967a, 0x6a2f6700],
    merkle_root: [0xd0c267b8, 0x12545238, 0xb24fe1b7, 0x0dac2c14, 0x9385f091, 0x42230715, 0x74e15a5a, 0x2bade34c],
    reversed_timestamp: 0xa8c07959,
    nbits: 0xffff7f1f,
    nonce: 0x000002da
};
const BLOCKHEADER_1920: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x706c7b21, 0xf79ef8df, 0xd93d0715, 0xb562bb76, 0x3ab0d4bd, 0x243513c0, 0xc9902484, 0x0bf00a00],
    merkle_root: [0x9d9285b1, 0x7792ae17, 0x2c3fee48, 0x26590464, 0x4bf00547, 0xfcaeda84, 0x7c6cdf58, 0x794f16e6],
    reversed_timestamp: 0x00c37959,
    nbits: 0xffff7f1f,
    nonce: 0x0000015c
};
const BLOCKHEADER_1921: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x206541b8, 0x0f513937, 0x526d2ef4, 0x83c0322c, 0x1731fe86, 0x262dc26c, 0x1da87d1f, 0x96946200],
    merkle_root: [0xadb98c4f, 0x8e3378d3, 0xc39ba29c, 0x6ac64a64, 0x6361d468, 0x6701014f, 0xda8d529f, 0x67ac7474],
    reversed_timestamp: 0x58c57959,
    nbits: 0xffff7f1f,
    nonce: 0x000000c8
};
const BLOCKHEADER_1922: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb0de0ef2, 0x21f9b5aa, 0x421965af, 0xc7ef0da3, 0x98799458, 0x3066dca3, 0x943a91a4, 0xc51c0c00],
    merkle_root: [0x87d62af1, 0x5d1f2709, 0x534f9047, 0x20c0d5dc, 0xfe7cc369, 0x1518691a, 0x140a6674, 0x04395127],
    reversed_timestamp: 0xb0c77959,
    nbits: 0xffff7f1f,
    nonce: 0x0000000c
};
const BLOCKHEADER_1923: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa752eb93, 0xd6b1d554, 0x9d8af9a6, 0xce591f67, 0xa6c6bcea, 0x22211d01, 0xd07718a9, 0xfacd0100],
    merkle_root: [0x7ffa864e, 0x5fd26451, 0xae3381a9, 0xacd503e8, 0x0123b6c4, 0x4b228a3f, 0xbceca6c9, 0x8895286d],
    reversed_timestamp: 0x08ca7959,
    nbits: 0xffff7f1f,
    nonce: 0x0000029b
};
const BLOCKHEADER_1924: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x42e0330c, 0x361337c4, 0x3027cc08, 0x8e60fdd9, 0x87fa4fc8, 0x83c45d13, 0x231ff222, 0xc48d6b00],
    merkle_root: [0x9b9bb91b, 0xd619ea10, 0xb8d26ddf, 0xa1cb4637, 0x4b20f0f2, 0x168b7bb3, 0x55ff7049, 0x40382425],
    reversed_timestamp: 0x60cc7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000158
};
const BLOCKHEADER_1925: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9555d98d, 0x04692412, 0xbc9a4a78, 0x5241bde9, 0x16c8b2ce, 0xdd9f36bf, 0x5cf60230, 0x61836700],
    merkle_root: [0xe373e7d2, 0x53e3e4b1, 0x67670898, 0xbeb75b81, 0x7eee8ef4, 0x59a203d1, 0x20e173f0, 0x87064088],
    reversed_timestamp: 0xb8ce7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000095
};
const BLOCKHEADER_1926: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa8e3b19e, 0xa497007e, 0x54f48184, 0xd9c9f4e6, 0xca39b1d8, 0x73a69076, 0x1b1bf3e7, 0x06dc0a00],
    merkle_root: [0x3f79dd5e, 0xad74ebfc, 0x433f2b7f, 0x928b1c40, 0xba5264ad, 0x6c1d45ac, 0x10030f38, 0xebeadaab],
    reversed_timestamp: 0x10d17959,
    nbits: 0xffff7f1f,
    nonce: 0x00000198
};
const BLOCKHEADER_1927: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x79e231a3, 0x8460644d, 0x57fb91bc, 0x3f6655d2, 0xc1c5ac2f, 0x53d70a99, 0x5c4f01e3, 0x6a8b7600],
    merkle_root: [0xd4a6d25d, 0x8e4a9c7a, 0x5b84342b, 0x6a060658, 0xcb9660eb, 0x70964a12, 0xff338598, 0x65675ca7],
    reversed_timestamp: 0x68d37959,
    nbits: 0xffff7f1f,
    nonce: 0x00000229
};
const BLOCKHEADER_1928: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9c517758, 0x4b0e2dc9, 0x107223dd, 0x366aede3, 0xae44b03b, 0xfe666959, 0x8b31bf0a, 0x29b54000],
    merkle_root: [0x7f33f4c6, 0x54e3107f, 0x76fa7033, 0xf9863fcc, 0x671ac8de, 0x6ab785eb, 0x6c33ce07, 0xc2925ce3],
    reversed_timestamp: 0xc0d57959,
    nbits: 0xffff7f1f,
    nonce: 0x00000083
};
const BLOCKHEADER_1929: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa35fe26d, 0xd7f4eb02, 0xaf0a2e5a, 0x22d1be11, 0xb0fabaec, 0x8b318096, 0x111d68db, 0xe6b35000],
    merkle_root: [0xef40cb3c, 0xd93a518f, 0xc0575520, 0x2e20b026, 0xf492081f, 0xddb068b3, 0x6b974bfa, 0x68a51523],
    reversed_timestamp: 0x18d87959,
    nbits: 0xffff7f1f,
    nonce: 0x000005a8
};
const BLOCKHEADER_1930: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xad826f8b, 0x59f489ba, 0x3c153ca8, 0x444eb36e, 0xe395ba71, 0x96358b06, 0x96e97776, 0x4b700d00],
    merkle_root: [0x3a278d56, 0xcf3f5070, 0x7ee79653, 0x4fc0f522, 0x981aefe3, 0x6ae7546e, 0x8f6987ad, 0x1241fc49],
    reversed_timestamp: 0x70da7959,
    nbits: 0xffff7f1f,
    nonce: 0x0000014c
};
const BLOCKHEADER_1931: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8fdbc3ed, 0x303ecda2, 0xbdd515b2, 0x1bfd0727, 0x7ea520c1, 0x68409ba0, 0x0dac9d2c, 0x59ee1600],
    merkle_root: [0x79472d17, 0xdccb58f6, 0xf01f3160, 0x636d8c7f, 0xc4e64542, 0x813941bb, 0x24ce0c52, 0x04a2e8ae],
    reversed_timestamp: 0xc8dc7959,
    nbits: 0xffff7f1f,
    nonce: 0x000002cd
};
const BLOCKHEADER_1932: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xbd455094, 0x8e6df1a7, 0xdddcfc24, 0x9d0014c8, 0x5288b947, 0x6400c3ca, 0xba78882b, 0xb4157800],
    merkle_root: [0xa3f7d973, 0x62c2872b, 0xef9bfc91, 0x80b23240, 0x20ad3136, 0x0f1bbc5b, 0x65179ea1, 0xbcaf3840],
    reversed_timestamp: 0x20df7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000062
};
const BLOCKHEADER_1933: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6d7b488b, 0x95822b12, 0x36bf4fba, 0x7daaf472, 0xe24192ef, 0x1ecdcc05, 0x86396328, 0xb9a86000],
    merkle_root: [0xb3d3ab1b, 0x1dcea48e, 0xecbe51cf, 0x020c09f9, 0x6e98e3fd, 0xb09a0643, 0x484b1dce, 0xe7220094],
    reversed_timestamp: 0x78e17959,
    nbits: 0xffff7f1f,
    nonce: 0x0000012b
};
const BLOCKHEADER_1934: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x4c3f505d, 0xebf9e1a5, 0xd0c459f7, 0x52f21962, 0x71b4391d, 0x376f9a49, 0x84ada30c, 0x667c3000],
    merkle_root: [0x37522b27, 0x5137d702, 0x65415269, 0xe8d74fe7, 0x47a05424, 0x98ce4b29, 0x0451dcc8, 0x581bbabc],
    reversed_timestamp: 0xd0e37959,
    nbits: 0xffff7f1f,
    nonce: 0x00000106
};
const BLOCKHEADER_1935: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x6c4c4177, 0x54cef314, 0x9ab49855, 0xf5b2f93f, 0x66647438, 0xf6fd6ef6, 0x24246c27, 0x1c930f00],
    merkle_root: [0x6f69757a, 0x4b9b0cad, 0x0dfb4269, 0x33326333, 0x2f2b2c8c, 0xadf6a324, 0x36bbcff8, 0x512fcfea],
    reversed_timestamp: 0x28e67959,
    nbits: 0xffff7f1f,
    nonce: 0x00000436
};
const BLOCKHEADER_1936: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe901f9b2, 0x8def8eed, 0xc321fc0b, 0x90573c03, 0xb3d819b9, 0x46ee4b1b, 0xde35a8c6, 0xb0a20e00],
    merkle_root: [0x2789344a, 0xa6be9bb9, 0xbd2dba74, 0x360e74b5, 0x5524dc68, 0x604c5088, 0xc7cb1dab, 0x5ffa024e],
    reversed_timestamp: 0x80e87959,
    nbits: 0xffff7f1f,
    nonce: 0x00000306
};
const BLOCKHEADER_1937: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3ebaf392, 0xb695a8fe, 0x514e2e58, 0x6842749d, 0xe349974c, 0x72f9f928, 0xb0e42c14, 0x67686700],
    merkle_root: [0xa6a57bd7, 0xdb276d04, 0xad991e81, 0xd3a731f7, 0x2241e1ec, 0xebff9b85, 0x07c0e5e2, 0x4c8573e1],
    reversed_timestamp: 0xd8ea7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000038
};
const BLOCKHEADER_1938: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3e4302d5, 0x63173c40, 0x5976793a, 0xa3f0aefc, 0x87ac205b, 0x00c59fd0, 0x5ee668d4, 0x6a081d00],
    merkle_root: [0xfcf557ce, 0x12434bfc, 0x20f83d01, 0xfc59a582, 0x3c7e5d25, 0x009c6343, 0xeceec388, 0xbeb14e7f],
    reversed_timestamp: 0x30ed7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000227
};
const BLOCKHEADER_1939: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3af43465, 0x5a1b41c6, 0x83d609bf, 0x39a1f321, 0x747f4a6c, 0xc8dda4c9, 0x52f307df, 0xe3594100],
    merkle_root: [0x6c89eeb5, 0xdb89fe15, 0x134ef546, 0xfe4283ce, 0x81bbb67f, 0x0a01ff54, 0xabc03377, 0x5b85367e],
    reversed_timestamp: 0x88ef7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000184
};
const BLOCKHEADER_1940: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x21ef96a9, 0xdf56f4ea, 0xebff6f48, 0x2d82dce0, 0xb51070c1, 0xa6392294, 0x5c44718e, 0x4e324500],
    merkle_root: [0x651573a6, 0xa7bc2b70, 0x63263f7c, 0xa291a18b, 0x21903aad, 0x8731b0f5, 0xc848e290, 0xb9376dfd],
    reversed_timestamp: 0xe0f17959,
    nbits: 0xffff7f1f,
    nonce: 0x00000288
};
const BLOCKHEADER_1941: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1e22a50b, 0xf0bf606a, 0x8e43b9ac, 0x8d77b44d, 0xffb9a807, 0x79493724, 0x5022ff34, 0x678e0600],
    merkle_root: [0xc931e437, 0x96cf08dd, 0x588e24a4, 0x34890414, 0x25cdb9bd, 0x8f721079, 0xd51c5576, 0x732a8e28],
    reversed_timestamp: 0x38f47959,
    nbits: 0xffff7f1f,
    nonce: 0x0000006c
};
const BLOCKHEADER_1942: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x639d096d, 0x9ebc6ea4, 0x5262c1fd, 0x054e2e4f, 0x9f5fba7b, 0xd8665580, 0x8619d2f9, 0xa91e5200],
    merkle_root: [0x6676f13b, 0x92d298cc, 0x1f41aa17, 0xaeefc746, 0x32ccbc17, 0xbd7126cf, 0x05cc8da4, 0x98b329d1],
    reversed_timestamp: 0x90f67959,
    nbits: 0xffff7f1f,
    nonce: 0x00000040
};
const BLOCKHEADER_1943: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x560a4528, 0xd1c25b8d, 0xbab9fce6, 0x2e3d8199, 0x41b651db, 0x1e76c126, 0x265b579b, 0xa9923c00],
    merkle_root: [0x5b0f6f7a, 0x23e0ed13, 0x15e824cc, 0x652496fb, 0xcd8cc536, 0x271f9837, 0x0beef844, 0xec58c330],
    reversed_timestamp: 0xe8f87959,
    nbits: 0xffff7f1f,
    nonce: 0x000002de
};
const BLOCKHEADER_1944: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8f64f0f2, 0x944c4c83, 0x1453113e, 0x21637265, 0x3bd9e06e, 0xdde837aa, 0xab437ad6, 0xb6ec4300],
    merkle_root: [0x7ceab00b, 0x3d167084, 0x7b956da6, 0xc162a262, 0x56eb38a2, 0x1db3fd80, 0xf7423525, 0x19df3aa2],
    reversed_timestamp: 0x40fb7959,
    nbits: 0xffff7f1f,
    nonce: 0x00000053
};
const BLOCKHEADER_1945: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1e619657, 0x70b1f8e4, 0x0f405725, 0xd59935d4, 0x5dc269ca, 0xa9fed66f, 0xaf1cd919, 0x68992500],
    merkle_root: [0x762f4a29, 0x289ec57f, 0xb7feeef6, 0x6c56e214, 0x5a5fc9ff, 0x490047cc, 0x57b7f77b, 0x945c22ee],
    reversed_timestamp: 0x98fd7959,
    nbits: 0xffff7f1f,
    nonce: 0x000001f1
};
const BLOCKHEADER_1946: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x68bae0bb, 0xf9165644, 0xe4582926, 0x89d3c024, 0xdcf570c5, 0x94977541, 0xe0f8416f, 0x6ef60600],
    merkle_root: [0xb218cd7c, 0xa9900590, 0xfdfc7382, 0x3a7b8101, 0x7b423e5a, 0xf9400b3f, 0x9dcabbfc, 0xee25946d],
    reversed_timestamp: 0xf0ff7959,
    nbits: 0xffff7f1f,
    nonce: 0x000003dd
};
const BLOCKHEADER_1947: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x0a376d76, 0xe71a859b, 0x718caeb0, 0x25a838d6, 0x507d3f6f, 0x9d6d9e38, 0x0d9d0dde, 0x284c3b00],
    merkle_root: [0x61b579a7, 0x967d202d, 0x5060517e, 0x7d9cf199, 0x250a95e1, 0x9cf88d64, 0xe06019bb, 0x884eeaf8],
    reversed_timestamp: 0x48027a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000d5
};
const BLOCKHEADER_1948: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2362ff81, 0x67ef9fb1, 0x7a4bcd8d, 0xd05f4b1a, 0xc6443e27, 0xb36f867f, 0x61124947, 0x71327100],
    merkle_root: [0xd78684b3, 0x864ba737, 0x7d3e9533, 0x306d0675, 0xce24d292, 0x2a1c2403, 0xecf973c9, 0x10cc7b73],
    reversed_timestamp: 0xa0047a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000153
};
const BLOCKHEADER_1949: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb9d63aed, 0xd6b21649, 0x146bdf3d, 0xc4057686, 0x228fdbd5, 0x8dfdc3d4, 0xe827e5a4, 0x88567000],
    merkle_root: [0x8a2c3a5d, 0xa1e22bfb, 0x46de044f, 0x549a720a, 0x36fe4c69, 0xd5607ce9, 0x5f657a9b, 0xf604f4f6],
    reversed_timestamp: 0xf8067a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000031a
};
const BLOCKHEADER_1950: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x822e89d8, 0x774e6f4d, 0x2ba88154, 0x4dc9bc5a, 0x6996c0b0, 0x81e4ce2b, 0x33b08e50, 0x5a283b00],
    merkle_root: [0x0c6b65f6, 0xd89f0643, 0x77beaf45, 0x5c5cb562, 0x93aba43f, 0xbd00e88b, 0xdf37402f, 0xfd92aca1],
    reversed_timestamp: 0x50097a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000007b
};
const BLOCKHEADER_1951: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x3783888f, 0xe47cdbe8, 0x3c1b94e7, 0xc33ce085, 0x672c4b3d, 0x0d0df801, 0xb4c3411b, 0xe1263900],
    merkle_root: [0x76a79086, 0xf4b00ec4, 0xe7dfe056, 0x1fa7502f, 0xd4c64941, 0x2e0e042a, 0x7c76becf, 0xcd02e7fc],
    reversed_timestamp: 0xa80b7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000014b
};
const BLOCKHEADER_1952: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf18ec7a0, 0x80bb293b, 0x1a9b9a3f, 0xad403328, 0xdb311732, 0xebd52a0f, 0x2adb9c54, 0x73fc2b00],
    merkle_root: [0x85119dad, 0x74dd97ec, 0x5c0710c2, 0x7085610e, 0x301b39ac, 0x29fe3d82, 0x29048573, 0x4113f9ca],
    reversed_timestamp: 0x000e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000004aa
};
const BLOCKHEADER_1953: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5a3aff41, 0x1f908dcb, 0xdad7d346, 0xbd67c077, 0xf39768bc, 0x40cf926b, 0x488823d1, 0x9a844100],
    merkle_root: [0x3f8047d9, 0x8a6bb737, 0x32e3ec9e, 0xfeb28db7, 0x85df3411, 0x41f82456, 0x9a265bf9, 0xe01f2486],
    reversed_timestamp: 0x58107a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000023d
};
const BLOCKHEADER_1954: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x767364a4, 0xd568fd79, 0x5349f05d, 0x111136dd, 0x0d06c08a, 0xb7a4776e, 0x97d21c20, 0x9e551200],
    merkle_root: [0xb91575f3, 0x72dca1f8, 0x151a060f, 0x88d99f89, 0xaeb24c40, 0x7490b111, 0x65537ab6, 0x4a43913d],
    reversed_timestamp: 0xb0127a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001f4
};
const BLOCKHEADER_1955: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x99ceb60e, 0xfc4b467e, 0x33146d18, 0x8190b9b9, 0x9467e59b, 0x4ad46d04, 0x07f9d662, 0xb1095c00],
    merkle_root: [0x9d5b0893, 0x456c17d2, 0xa6f63f11, 0x014a32d7, 0xa5a57b17, 0x05452ccc, 0x09396584, 0xee596dd1],
    reversed_timestamp: 0x08157a59,
    nbits: 0xffff7f1f,
    nonce: 0x000002cd
};
const BLOCKHEADER_1956: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x0daaaa2b, 0xaa565014, 0xb97a5cb8, 0x72a4f267, 0xc5b05dcb, 0x3829aa68, 0x92a8eb3e, 0xe63e1900],
    merkle_root: [0x635534bb, 0x0d5dd8e5, 0x0719264b, 0x538305e5, 0x67f0d702, 0x2b50bcd8, 0xf80d6965, 0x285cb0cc],
    reversed_timestamp: 0x60177a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000a3
};
const BLOCKHEADER_1957: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5810f00b, 0xcd3962df, 0x9cbe6c0f, 0xc5349544, 0xce82bbb2, 0xae9a129b, 0x808994cb, 0x0e327900],
    merkle_root: [0x3e8ca4bc, 0x206d29d2, 0xd29dd049, 0xe49e990e, 0x95d5cfcd, 0x59afe0c4, 0x8dbe8202, 0x90abfefd],
    reversed_timestamp: 0xb8197a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000024
};
const BLOCKHEADER_1958: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2ba36738, 0x4ba59401, 0x746ac77f, 0xf0fd43d4, 0x768a10ed, 0x9bb5b681, 0x3a71b7e1, 0x281f1d00],
    merkle_root: [0x2c3fd8b4, 0xc3e9db2a, 0xc39f22aa, 0xa33e808a, 0x277d0807, 0x0932933a, 0x1a208013, 0x194021e3],
    reversed_timestamp: 0x101c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000300
};
const BLOCKHEADER_1959: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2b7f1f0f, 0xa8806f03, 0xd8a10416, 0xe0e2c378, 0x66cae77a, 0xe7b5f69b, 0x3e57d7ab, 0x34381f00],
    merkle_root: [0x752d1901, 0x6ab3a3ad, 0x54c8c7e5, 0x560cd0cf, 0x580f61f6, 0xc7071fdc, 0x0929b60a, 0xe4514eaa],
    reversed_timestamp: 0x681e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000006f
};
const BLOCKHEADER_1960: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x2ba3b491, 0x50c01292, 0xadc74a2f, 0x080e70be, 0xeb7c9dec, 0x94d2eab2, 0x6dfd3c0c, 0xd55c5300],
    merkle_root: [0x49eac68f, 0xb32ca046, 0xcee8442d, 0xacc247b6, 0x41aeacaa, 0x70914694, 0x9260bd06, 0xa2e4bc3f],
    reversed_timestamp: 0xc0207a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000056
};
const BLOCKHEADER_1961: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb34c99a4, 0x18054c43, 0x6b9db8f5, 0x29b15117, 0x337c8f16, 0xc9b6d389, 0x34b5d38c, 0xdcf14900],
    merkle_root: [0xe675294e, 0xcf180e00, 0x13b51db6, 0x342741bd, 0xafb4050a, 0x11eda72c, 0xf4a52de4, 0x9ae698d0],
    reversed_timestamp: 0x18237a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000009b
};
const BLOCKHEADER_1962: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x71c4ea41, 0x3155a5d0, 0x7556d587, 0x3cda0a33, 0xcff7e034, 0x5536da63, 0x57319fb2, 0x644a4900],
    merkle_root: [0x6914368b, 0x0827961b, 0x096da4ca, 0x69518140, 0xa36fa318, 0x10f68c8b, 0xd900fc17, 0xf9729de5],
    reversed_timestamp: 0x70257a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000063
};
const BLOCKHEADER_1963: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xda22310f, 0x06dd26ef, 0x80dc7fe5, 0x3d6067b7, 0xd555fdf5, 0xb9fc382a, 0x98a94e1f, 0x7fca1d00],
    merkle_root: [0x45076120, 0xfe2c8c7f, 0x9f4d04dc, 0x39fd0dac, 0x6c862c49, 0x2c732289, 0x8c3d6aca, 0x76a05a4d],
    reversed_timestamp: 0xc8277a59,
    nbits: 0xffff7f1f,
    nonce: 0x000003da
};
const BLOCKHEADER_1964: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x09ddee46, 0xb23f587b, 0x33abcfb7, 0x306d3de1, 0x61c00b10, 0x6b015ac2, 0x854d9a3d, 0xb9ae7c00],
    merkle_root: [0x7b11cc48, 0x159fe524, 0x1fc16585, 0xe30d58eb, 0x5df85402, 0x8b7b7b3c, 0x66e4f12e, 0xe6bd228f],
    reversed_timestamp: 0x202a7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001b3
};
const BLOCKHEADER_1965: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc311437d, 0xb1768c1c, 0xf10c04dd, 0x0e362494, 0x94b26e82, 0x28f6bc1f, 0x072b28c6, 0x1d392700],
    merkle_root: [0xfa64c952, 0x372d8494, 0x79d00646, 0x61f29500, 0x58cd0560, 0x9c7bdd79, 0xdce2a0ba, 0x5ce2143a],
    reversed_timestamp: 0x782c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000003a5
};
const BLOCKHEADER_1966: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa439b2fb, 0x58858755, 0x206ac5d7, 0x57575ebd, 0xaae86b0f, 0x07f71235, 0xbaca3d80, 0x0d1d5100],
    merkle_root: [0x4a86428c, 0x8e14e9fa, 0x3f703633, 0xc0ba0dc6, 0x25f98975, 0x5f76a433, 0x0d636ad2, 0x8af327b3],
    reversed_timestamp: 0xd02e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001ea
};
const BLOCKHEADER_1967: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc0f304f4, 0x19f70755, 0xc086e5aa, 0x15ac48f7, 0xd0bf6aff, 0x3ac42507, 0x61561962, 0x53783f00],
    merkle_root: [0x967fcc69, 0x5ebf4f74, 0x4ec4b97b, 0xa55d82a4, 0xe6ca3ccd, 0x421b3a5e, 0x7f4eb582, 0xd6742554],
    reversed_timestamp: 0x28317a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000026a
};
const BLOCKHEADER_1968: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x82f9ca45, 0x76b054a1, 0x93bfcb74, 0x7622a531, 0x6514cb2b, 0x141559c7, 0x9f4e2f7a, 0x831f4c00],
    merkle_root: [0x58fbb7bf, 0xa8a6edf3, 0x08c6b006, 0x93abbefa, 0xdabdd375, 0x652935ae, 0x9b0331af, 0xab8a9ea4],
    reversed_timestamp: 0x80337a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000010
};
const BLOCKHEADER_1969: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd04c5fe5, 0x173a2d6d, 0xcfc1cac1, 0x14f35f87, 0x2075d7a8, 0x3ff94c1c, 0xd8b96dad, 0xd8426100],
    merkle_root: [0xe8978d5f, 0x8830c44d, 0x234a74dc, 0xa988787a, 0x2fac42e7, 0xc6776cd3, 0xdc0548b1, 0x58c8f07a],
    reversed_timestamp: 0xd8357a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001f4
};
const BLOCKHEADER_1970: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x45992b8a, 0xa8998ca0, 0x06656a35, 0x7fe36400, 0xbc59a276, 0xd60e74f1, 0xfece9694, 0x71e32b00],
    merkle_root: [0x26e67862, 0x51831c43, 0xbdf1167c, 0x159d6dce, 0xa31f1638, 0xdfd69339, 0x42ee26e7, 0x46270030],
    reversed_timestamp: 0x30387a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000019
};
const BLOCKHEADER_1971: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x26945df1, 0xf3857151, 0x3e26dbcd, 0xa315a458, 0xacc760d3, 0x6ad9070f, 0x28351e0a, 0x126f0e00],
    merkle_root: [0x8cafc2cd, 0x25cc2111, 0xdeab091d, 0xd8999d98, 0xdd391cec, 0x5e89079a, 0x87d0c1ba, 0x32243557],
    reversed_timestamp: 0x883a7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000047
};
const BLOCKHEADER_1972: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x28cf7cbf, 0x8123d386, 0x66e8c8dc, 0xd571b97d, 0x9c0fd061, 0x0df0be0a, 0xa1b7e57d, 0x7af55b00],
    merkle_root: [0x09cbea01, 0xf144be66, 0xc3a095a7, 0x43f6647a, 0x76071124, 0xbb01d97a, 0xdd4f4094, 0x103f0773],
    reversed_timestamp: 0xe03c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000002f6
};
const BLOCKHEADER_1973: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8dfcabcb, 0xf32d7652, 0x0fdf43ea, 0x9665ed82, 0xdf04394f, 0x8e58b354, 0xcce38d8b, 0x7e555700],
    merkle_root: [0xf33e2ccc, 0xb12cfaa0, 0x1edd3fa8, 0x33eb2dd1, 0x0723d6b2, 0xd708e564, 0xc47f4a05, 0xb72f3a6b],
    reversed_timestamp: 0x383f7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000188
};
const BLOCKHEADER_1974: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x05ba86e5, 0xfde94e65, 0xeb600114, 0xc93795a5, 0xd0dc3bee, 0x60be6429, 0x19240cbf, 0x71675300],
    merkle_root: [0xfb31f125, 0x6e87c495, 0xeea0bb3a, 0x7408b696, 0xf698b278, 0x90ae85c9, 0x6602666e, 0x45015205],
    reversed_timestamp: 0x90417a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000013a
};
const BLOCKHEADER_1975: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x97741862, 0xb1466466, 0x85624216, 0xc136a444, 0x8b3a7df5, 0xea0224d1, 0xa2dc7e66, 0xbf350800],
    merkle_root: [0x4e914e94, 0xb30a40fa, 0xa003a387, 0x60ccf7cb, 0x4266e7d1, 0x48022782, 0xf641d440, 0x5d485f10],
    reversed_timestamp: 0xe8437a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000085
};
const BLOCKHEADER_1976: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xdd321e9b, 0xf8d0c90a, 0x3d62a215, 0xb0ca7754, 0x60396a13, 0xda958685, 0x1ef54a24, 0x62fb0e00],
    merkle_root: [0xda00f606, 0x7e7d61fc, 0xba42e192, 0xcd439d1d, 0xc5680ca5, 0xc88d4ae7, 0x41f6a54a, 0x05732f53],
    reversed_timestamp: 0x40467a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000110
};
const BLOCKHEADER_1977: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x04738d3f, 0x211cd132, 0x703c733a, 0x7eee6adc, 0x23e23e3f, 0xee0c9ae1, 0x96442ff6, 0x19581600],
    merkle_root: [0x93dd5f52, 0x480df65f, 0x1645887a, 0x181e1bb5, 0x73b6ad37, 0xa5402a41, 0xb50ca3c1, 0x08c2e288],
    reversed_timestamp: 0x98487a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000394
};
const BLOCKHEADER_1978: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7ac0c473, 0x9e7c5704, 0xa341d6c3, 0x0b3eb4c7, 0x2983e51f, 0x2de3fd2e, 0x618739aa, 0x3aed4b00],
    merkle_root: [0x78e26421, 0xd9e864d9, 0x1a7ab994, 0xc365949f, 0x1682784e, 0xc7628346, 0xa90ee63b, 0x3e1f663d],
    reversed_timestamp: 0xf04a7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000cf
};
const BLOCKHEADER_1979: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x00c3e9ff, 0x8eb38ef3, 0x28fe4d1e, 0xbcad7169, 0xf0d90b12, 0x61075cff, 0x626c0e8b, 0x24737700],
    merkle_root: [0x3d953200, 0x2654bc47, 0x7d925816, 0xf64dd73a, 0xa5d511c0, 0xa3c82465, 0x0c893601, 0x7355e239],
    reversed_timestamp: 0x484d7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000002a6
};
const BLOCKHEADER_1980: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x0756efef, 0xb259d7be, 0xcef7ddf4, 0xf373ecdc, 0x17996438, 0xd2626b86, 0x1f3997c5, 0xbf980600],
    merkle_root: [0xc9a3f844, 0x28abff7e, 0x34515001, 0x4616e8d1, 0xdc30683b, 0x46d006c2, 0x8837e99f, 0x33fa37b7],
    reversed_timestamp: 0xa04f7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000c3
};
const BLOCKHEADER_1981: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1fa1535a, 0x647b511a, 0x5fa7941b, 0x4c940482, 0xc588f87f, 0x1af5da11, 0x2f35f88c, 0x5c173900],
    merkle_root: [0x7af43b2c, 0x231674ee, 0xb83af5f3, 0x450772ea, 0x97c2db3b, 0xe08e5e9f, 0xc45e075d, 0x2d9c3673],
    reversed_timestamp: 0xf8517a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000588
};
const BLOCKHEADER_1982: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd9eb4f23, 0xffdc5085, 0x2cda2d30, 0x87ae882b, 0x3d7a07d6, 0xb928d684, 0x22ab8bca, 0x3f156100],
    merkle_root: [0x7e1dee78, 0xa935db52, 0x2f650e36, 0x89eaf7fd, 0x71b00203, 0x26d1f11d, 0x637dc7ec, 0xc6c760b1],
    reversed_timestamp: 0x50547a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000027f
};
const BLOCKHEADER_1983: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf0cb4de9, 0x115bc674, 0x17a89b45, 0x8c57215f, 0x4bbdce39, 0x48476e19, 0x05ad16d6, 0x1d2e4d00],
    merkle_root: [0x294729d4, 0xc611bf02, 0xc6cb9323, 0x093d34b9, 0x2ddd7901, 0xded23228, 0xca8a49cd, 0x7aaeacd5],
    reversed_timestamp: 0xa8567a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000389
};
const BLOCKHEADER_1984: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7a64a872, 0x4ce9ab48, 0x0b60cba6, 0x92179cbb, 0xae08bd0a, 0x9bceec2e, 0x514d4254, 0x3af56700],
    merkle_root: [0x065ee807, 0x8d10b9e6, 0xfdb0ac5f, 0x39c2f074, 0x1fff8d23, 0x9f4fd2d5, 0x7da6b4af, 0x5456c62b],
    reversed_timestamp: 0x00597a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000035b
};
const BLOCKHEADER_1985: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8fb85566, 0x93807c94, 0xed5eed50, 0x4521d069, 0xb61b5360, 0x6c212314, 0x8d4f48ba, 0x068d4000],
    merkle_root: [0xfaf7f542, 0xf174fc4b, 0x05719849, 0x19688854, 0x80ce3415, 0x4ef65d06, 0xd5310dc0, 0x79132e52],
    reversed_timestamp: 0x585b7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000020c
};
const BLOCKHEADER_1986: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x5760d13a, 0x3b9e4399, 0x51fc9bad, 0x66197c2e, 0xf8bce5e4, 0x5de3407d, 0x32d4322b, 0x2c734100],
    merkle_root: [0x77d1bccc, 0x81c19914, 0xf73c4add, 0x16191f70, 0xd06cebfc, 0xf03a8763, 0x488b444d, 0xdb163db6],
    reversed_timestamp: 0xb05d7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000001c4
};
const BLOCKHEADER_1987: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xffb6c32c, 0x0411352c, 0x93d166c3, 0xc681c551, 0x08412370, 0x61bfb29d, 0x8eabbd5f, 0x334a2a00],
    merkle_root: [0xefdb6544, 0xefce1cf0, 0xbc297ab6, 0x49e2b955, 0xcb307cb6, 0x02f2ce0e, 0x9e7f4276, 0x6e1ca351],
    reversed_timestamp: 0x08607a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000084
};
const BLOCKHEADER_1988: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x029e99f7, 0xec865836, 0xfd2d4410, 0x461673c8, 0x42a3a7e6, 0xe8509bcf, 0xaa8fa717, 0x764a1f00],
    merkle_root: [0x2e29e117, 0x68b7eb09, 0x0b15dac5, 0xac97a7fd, 0x8a33b0fe, 0xf7d6fb7c, 0x56e64976, 0x6c006640],
    reversed_timestamp: 0x60627a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000038
};
const BLOCKHEADER_1989: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd43ccd65, 0xb0e0a1fc, 0x50f58cf6, 0x3507e2b4, 0x49f4d4fa, 0x2b57f5ff, 0x39471dd6, 0x04ab4e00],
    merkle_root: [0xcebafb32, 0x098fd51b, 0xf3228cfd, 0x896c6743, 0x1d02ef72, 0xb48bf17b, 0xa8434a5e, 0xa8cbb9e3],
    reversed_timestamp: 0xb8647a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000015e
};
const BLOCKHEADER_1990: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe1bdc12d, 0x2bf8bffa, 0x46eb3ea6, 0x2b49c1db, 0x452cd73a, 0x18501565, 0x93e54e92, 0xdbaa4200],
    merkle_root: [0xe779895b, 0x095d1521, 0x2a70b8e1, 0xd4e15627, 0xd0b37274, 0xfb3639d6, 0x90fb95c1, 0xded435d9],
    reversed_timestamp: 0x10677a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000000a
};
const BLOCKHEADER_1991: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x720a2267, 0x1489cec4, 0x0e66d086, 0x942b1da6, 0xfe41ea16, 0x9323f509, 0x453c5ca0, 0xcb533800],
    merkle_root: [0x79f1fa2d, 0xe3f0db22, 0x8687cdee, 0x128c162c, 0x28b9f58e, 0x2c917d00, 0xbdd48fcc, 0x14d6ea01],
    reversed_timestamp: 0x68697a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000017a
};
const BLOCKHEADER_1992: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x974036d2, 0xb2bfdcb2, 0x0335ae58, 0xd3d8bbf3, 0xad0a0c4f, 0x7aac55f2, 0xa46d889a, 0x68635400],
    merkle_root: [0x86338907, 0x95907f04, 0x4fa26dbd, 0xe8c0505b, 0x0a1f889e, 0x304c952a, 0xddd0dbd7, 0xb3540e9e],
    reversed_timestamp: 0xc06b7a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000004f
};
const BLOCKHEADER_1993: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc10a7e7c, 0xcb97609c, 0xbdcde6e7, 0xa21b38af, 0xc90d354a, 0x2ca38591, 0xacc382a1, 0x387c1f00],
    merkle_root: [0xc96da0bb, 0xef63dc65, 0x0828a50e, 0xea6d0a98, 0x1dee53b4, 0x3d6a4273, 0x46c38502, 0xd9a1a7bd],
    reversed_timestamp: 0x186e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000191
};
const BLOCKHEADER_1994: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd710ff63, 0xbb952f58, 0xb9360760, 0x71720db5, 0x152d47b4, 0x3bab2041, 0xbe946e7d, 0xd2194000],
    merkle_root: [0xf9fa5282, 0xeaabbb77, 0xfe942f83, 0x32568b70, 0x706cd7c8, 0xd8201470, 0x8c8f2c50, 0x7d9c7dd7],
    reversed_timestamp: 0x70707a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000325
};
const BLOCKHEADER_1995: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x31f57f13, 0x7d7ab3d7, 0x650a0ce9, 0xe39ea0fc, 0x534084b7, 0x9e941661, 0x6ee92abe, 0x8dbc5300],
    merkle_root: [0x22371d58, 0x22ed57b9, 0x144e654c, 0x3072c52c, 0xd593f04c, 0xb1b36f56, 0x72905b07, 0x058c62a4],
    reversed_timestamp: 0xc8727a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000119
};
const BLOCKHEADER_1996: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x044c0a16, 0x04d138bf, 0xdf0a5c0d, 0x4b762f7f, 0x2463f785, 0x5b2662eb, 0xbd920eb2, 0x6f355100],
    merkle_root: [0xdcedb52d, 0x7e7e589d, 0xddc0e01c, 0x9b4a6663, 0x46cfcafa, 0x23af87c4, 0xca7181e7, 0x2545b0b5],
    reversed_timestamp: 0x20757a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000164
};
const BLOCKHEADER_1997: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc81eba61, 0xdbcbee28, 0x74307dd9, 0x109adccd, 0xaa3c50ee, 0xf896f374, 0xf6bbd8e9, 0xb9793c00],
    merkle_root: [0xdd8014f9, 0x479f2c50, 0x94a0a949, 0xaf7e318f, 0x42f8e77f, 0x5f22fa42, 0x6aae4203, 0x384041b6],
    reversed_timestamp: 0x78777a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000fa
};
const BLOCKHEADER_1998: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xcc0d7358, 0x572de46f, 0x571c5ead, 0x71f7ada7, 0x6a7f7d34, 0xf0eb7708, 0x842b1cef, 0xc9675c00],
    merkle_root: [0x71fdac2f, 0x4336990b, 0x10870a56, 0x336c6fe0, 0x76672e57, 0x961ef009, 0xa32e3134, 0xae677e13],
    reversed_timestamp: 0xd0797a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000188
};
const BLOCKHEADER_1999: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xf4cf299b, 0x429b33ab, 0xf7f3bd1f, 0x2b51a33e, 0xb6e9b767, 0x84a67a1e, 0x673d7112, 0x96d74300],
    merkle_root: [0xa08aa5f2, 0x29fb86f6, 0x6e47107b, 0x535425d8, 0x8ec689d0, 0x5ab05678, 0x637f8462, 0x05fb0dd1],
    reversed_timestamp: 0x287c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000ee
};
const BLOCKHEADER_2000: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x51fe36d6, 0x7f7055d0, 0xaab8d53a, 0x54ffe46a, 0x1ba8a665, 0xb8ca1c25, 0x0275e069, 0x01971d00],
    merkle_root: [0x94ff12e1, 0xfff40847, 0x7f277a4d, 0x55eac223, 0x2001f2f8, 0x8cdad396, 0xad1945dc, 0x3b2d8e6e],
    reversed_timestamp: 0x807e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000011
};
const BLOCKHEADER_2001: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x163fbd89, 0xd0bf817a, 0xea586259, 0x949ecdd4, 0x443a47fc, 0xfe0eedd5, 0x81f074f1, 0x57893900],
    merkle_root: [0x5e701168, 0x216421b6, 0x8d00c987, 0x0f94297c, 0xfc08377e, 0x3a4039fe, 0xce86e38e, 0x7459abf9],
    reversed_timestamp: 0xd8807a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000042d
};
const BLOCKHEADER_2002: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9a8577ba, 0xb63fd8f0, 0x65b946bc, 0x43285731, 0x87f3755a, 0x4108c2a5, 0x8801bf16, 0x90701d00],
    merkle_root: [0xe665a71e, 0xdc0f6118, 0x0f4710cc, 0x815d13f5, 0x6c50b24c, 0x4d3d443e, 0x0776e670, 0x148428dc],
    reversed_timestamp: 0x30837a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000098
};
const BLOCKHEADER_2003: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xecf3680e, 0x790aca04, 0xb0962f9e, 0x717edc90, 0xe8c2fbde, 0x7eda6d3f, 0x55930078, 0x2a061c00],
    merkle_root: [0x57e54052, 0x033113f1, 0x15fb45e9, 0xa63ea9e1, 0x8ef1cb03, 0xd0a4a795, 0x5fe2d735, 0x5e1c0e36],
    reversed_timestamp: 0x88857a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000036d
};
const BLOCKHEADER_2004: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x904731c9, 0xecb34561, 0x4246ed11, 0x1cf61317, 0x7c8f2e66, 0x804d7724, 0x0c164fb6, 0x3dfc0000],
    merkle_root: [0x9a6ad416, 0xa6ce9c9e, 0xecc2700a, 0x3f13ba53, 0x330cccef, 0x73c720a4, 0xe8c414e5, 0xa493c831],
    reversed_timestamp: 0xe0877a59,
    nbits: 0xffff7f1f,
    nonce: 0x0000005b
};
const BLOCKHEADER_2005: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x8b87228a, 0x0416e042, 0x54f8c94e, 0x31ee59d7, 0x4857d316, 0x5ebf6991, 0x8b57561d, 0xad1b4500],
    merkle_root: [0x35b036ec, 0xa51e5b57, 0x7eec6400, 0x717afe2c, 0x334c7d71, 0x627417bf, 0xa416e5fa, 0xaec7f789],
    reversed_timestamp: 0x388a7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000528
};
const BLOCKHEADER_2006: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x493888d7, 0xf2faede2, 0x32ba98a2, 0xea11e639, 0x3ba6dff5, 0x274e2aa4, 0x8badc443, 0x18726100],
    merkle_root: [0x40fa91a4, 0xeb0e0673, 0xaf251801, 0xdaafcac2, 0x2811bf94, 0x98e083d5, 0x0f1deca7, 0x3be632b3],
    reversed_timestamp: 0x908c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000002c9
};
const BLOCKHEADER_2007: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xa820a9c3, 0xec375df0, 0x99977d33, 0x6ed6d90a, 0x0c5b08c2, 0x5e7bf2ba, 0xcb1b31ab, 0x16004500],
    merkle_root: [0x0f495a68, 0x02efa326, 0x849a1f1d, 0xd8bb42bd, 0xedebd0d5, 0x2a7d0320, 0x467af404, 0x0811beb4],
    reversed_timestamp: 0xe88e7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000583
};
const BLOCKHEADER_2008: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc55dd756, 0x1b05e3ab, 0x42be743c, 0x3a431dbe, 0xb3ec325b, 0xfe67cf55, 0x60d57c44, 0xc3704900],
    merkle_root: [0xb82ab650, 0x3a3babb9, 0x330d78ad, 0xdb1b77ab, 0x05865b1e, 0x3e997bd2, 0xe151ee1b, 0x383df122],
    reversed_timestamp: 0x40917a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000571
};
const BLOCKHEADER_2009: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9d1b6cd1, 0x48867824, 0xb5e2c0f8, 0x02b0d1da, 0x996427c5, 0x69eb6b22, 0xf0508719, 0x359a5900],
    merkle_root: [0xdef424bc, 0x7d00acd6, 0x8db8fb4f, 0xd5da1262, 0x6f80f301, 0xda1c311e, 0x360c18e3, 0x3176b642],
    reversed_timestamp: 0x98937a59,
    nbits: 0xffff7f1f,
    nonce: 0x000003b7
};
const BLOCKHEADER_2010: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xb7a09792, 0xc99bf065, 0x7fb5a4ca, 0x67b39bbc, 0x1c8ca147, 0xdcd70c57, 0xeb267582, 0x3b847100],
    merkle_root: [0xe566a228, 0x28bc4106, 0x04865ebd, 0x2f8a0697, 0x3d9a9924, 0x30131072, 0x4306b39e, 0x5eb63699],
    reversed_timestamp: 0xf0957a59,
    nbits: 0xffff7f1f,
    nonce: 0x000006d8
};
const BLOCKHEADER_2011: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x7a34a578, 0x7a68899f, 0x0703274b, 0xca4a8438, 0x164cfc7c, 0x8b92e678, 0x72895bbc, 0x4b622300],
    merkle_root: [0xc67718a8, 0xf9037919, 0x5a35bf02, 0x5cd4fe73, 0x3cc6650f, 0xbc7a74f0, 0x76038487, 0x3796e403],
    reversed_timestamp: 0x48987a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000458
};
const BLOCKHEADER_2012: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xcd5c2aef, 0xe7fee677, 0x09de8807, 0xcbe8ec78, 0x2b7bd15b, 0x6c94f5fb, 0xab2c12c0, 0x95f74b00],
    merkle_root: [0x62814f69, 0xa3c8eb3b, 0xb350f26f, 0x39dfc62f, 0xc52b0496, 0xdb830374, 0xd6f50ba6, 0x42da78db],
    reversed_timestamp: 0xa09a7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000000f4
};
const BLOCKHEADER_2013: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x64ed0199, 0xd2af8825, 0xf0d64cec, 0x0864d8a4, 0x238c91d7, 0x4f5a0cbc, 0x1d3bb719, 0x41485700],
    merkle_root: [0xb64a7fd2, 0x7a7b75d6, 0x5a0107d4, 0x4d8ec856, 0x36b0139f, 0xfa308a14, 0xb1b71fbb, 0x6d437887],
    reversed_timestamp: 0xf89c7a59,
    nbits: 0xffff7f1f,
    nonce: 0x000002f2
};
const BLOCKHEADER_2014: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x77eb7745, 0x1aa0dccc, 0xbc1114b7, 0x300bae29, 0xb6f0ed2d, 0xb2f7fb75, 0x6b55a7c0, 0x78783000],
    merkle_root: [0x176bbbdb, 0x113cd822, 0x4a1d7a38, 0xddab7707, 0xf0ea6586, 0x845549d7, 0xc07c182a, 0x0010042b],
    reversed_timestamp: 0x509f7a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000097
};
const BLOCKHEADER_2015: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x816d4621, 0xe7dfec98, 0x450e274d, 0x87d10e1b, 0xed21d29c, 0x8d1d0983, 0xa76e3550, 0x7c761800],
    merkle_root: [0x50619d1e, 0xc9b5cdcc, 0xf4f10775, 0xbe9d14cb, 0x3ec9b678, 0xd5744480, 0xb3eb453e, 0x2540682d],
    reversed_timestamp: 0xa8a17a59,
    nbits: 0xffff7f1f,
    nonce: 0x00000150
};
const BLOCKHEADER_2016: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xbe97423b, 0x47262e17, 0x0e42136c, 0x3f2b07d1, 0x8e6f21d5, 0x2e3c5d19, 0xef446290, 0xa8533b00],
    merkle_root: [0x946547c2, 0xe75de422, 0xdb5caca0, 0xbe6dbef5, 0x9de6d5bc, 0xb63128ed, 0x77fc21b5, 0x90259bc2],
    reversed_timestamp: 0x00a47a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000006be
};
const BLOCKHEADER_2017: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1e37d420, 0xa0144549, 0xc38db1f2, 0x4d62b88e, 0x9b8be8c4, 0x842a9082, 0xb626e629, 0x70105e00],
    merkle_root: [0x73d44980, 0x8696136b, 0x0d38d6c2, 0xfd7cf5c7, 0x021917b6, 0x6f0de9ff, 0xd1e00255, 0x89af2cd2],
    reversed_timestamp: 0x58a67a59,
    nbits: 0xbdef7f1f,
    nonce: 0x0000004c
};
const BLOCKHEADER_2018: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x9f9f22e7, 0x800036e8, 0xd18c881e, 0x7eb1c731, 0xb6587b66, 0xf4ff605d, 0xac438bdb, 0x4a183900],
    merkle_root: [0x9a9f935f, 0x303707a9, 0x8e80ec8a, 0xc15937a0, 0x7ec61f7a, 0x0ed648a9, 0x4aeb48d4, 0x04af46ef],
    reversed_timestamp: 0xb0a87a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000046
};
const BLOCKHEADER_2019: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xc691d1b5, 0x077eafdb, 0x0ebe8447, 0xb135b307, 0x93654532, 0x1f7611ce, 0x4691773c, 0x97b65500],
    merkle_root: [0x8d81b22d, 0x92aef9f2, 0xba181422, 0x1e0e55ef, 0xb6d6f9f2, 0x3c5cbcf1, 0xd00b4049, 0x8daf6e34],
    reversed_timestamp: 0x08ab7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000023
};
const BLOCKHEADER_2020: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xe02ff6d8, 0xccbb157b, 0x44c77dd1, 0x3e7c3a60, 0x47ff0c4b, 0x34760ccd, 0x10e94a85, 0x8c9d4000],
    merkle_root: [0x9fa35f38, 0xae223bad, 0xf46b0efe, 0x0bd5214f, 0xd18d9154, 0xf4a14fce, 0xeb3be57a, 0xae2f83e2],
    reversed_timestamp: 0x60ad7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x0000029f
};
const BLOCKHEADER_2021: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x1cd3595e, 0x1871c0c8, 0xf46a7ef9, 0x36d6531d, 0x91633ef6, 0x58925137, 0xb839b0a9, 0xb87a7300],
    merkle_root: [0x05e91ba5, 0x7752be92, 0x8fd1f54a, 0xd8405839, 0x9bb0396a, 0x08cb3e29, 0xf3273ed6, 0x7545ed07],
    reversed_timestamp: 0xb8af7a59,
    nbits: 0xbdef7f1f,
    nonce: 0x0000014e
};
const BLOCKHEADER_2022: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0xd3d00b19, 0x6f8da9c0, 0x9f418222, 0xecb78652, 0x4ba2b539, 0x773fc960, 0x7f34afbd, 0x02587e00],
    merkle_root: [0x955b5f08, 0xbfc99fee, 0x79b1ae6e, 0xedd78929, 0xa8b35f7e, 0x34464040, 0xfe5dc58f, 0x8731d681],
    reversed_timestamp: 0x10b27a59,
    nbits: 0xbdef7f1f,
    nonce: 0x00000222
};
const BLOCKHEADER_2023: BlockHeader = BlockHeader {
    reversed_version: 0x00000000,
    previous_blockhash: [0x78bf98ed, 0x78471ea5, 0x259c3308, 0x7e26981f, 0x071fb1fc, 0x30e1157a, 0x54b5e968, 0x6eb21200],
    merkle_root: [0x4e01bbea, 0xb64b13f9, 0xbacea0a5, 0xa2ebe02d, 0x17f0ec5b, 0x9fb2e371, 0xe75dd9c6, 0x23dfdaba],
    reversed_timestamp: 0x68b47a59,
    nbits: 0xbdef7f1f,
    nonce: 0x000000db
};

pub const BLOCKHEADERS: [BlockHeader; 123] = [
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
];

pub const STORED_BLOCKHEADERS: [StoredBlockHeader; 124] = [
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
        block_hash: [0xa644e45f, 0x59a32043, 0x4147256f, 0x09d9e38f, 0xe0cc6490, 0x2431ad22, 0x67afccbf, 0xac150300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000edc00,
        block_height: 1901,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501134600, 1501135200, 1501135800, 1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1902,
        block_hash: [0x3a0404f0, 0x2ed35711, 0x2c97bbc7, 0xb0a09258, 0xfd14419d, 0x9628631c, 0xf8244756, 0xcc802900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ede00,
        block_height: 1902,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501135200, 1501135800, 1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1903,
        block_hash: [0x46f58296, 0x1598ac90, 0xdc79ea84, 0xe9c66110, 0x3d0561f2, 0x206f1227, 0x79e89db7, 0xe10f6600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee000,
        block_height: 1903,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501135800, 1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140600, 1501141200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1904,
        block_hash: [0xf417c67f, 0x86d846d4, 0xbd99a0a3, 0xe0e62759, 0xf8ee6f5c, 0x292e8433, 0xad6d80ec, 0x3c9e2000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee200,
        block_height: 1904,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501136400, 1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140600, 1501141200, 1501141800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1905,
        block_hash: [0xbefa4bb8, 0x5357c21c, 0x5b9c6d82, 0x7b5d2155, 0x3aea974c, 0xb1cfbfc5, 0x6151c691, 0xc7cb4100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee400,
        block_height: 1905,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501137000, 1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140600, 1501141200, 1501141800, 1501142400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1906,
        block_hash: [0x5c6c27bb, 0x04a40cd9, 0x3de85058, 0x8a46ee6d, 0x610e2837, 0xb4f58052, 0x43924d30, 0x9d810c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee600,
        block_height: 1906,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501137600, 1501138200, 1501138800, 1501139400, 1501140000, 1501140600, 1501141200, 1501141800, 1501142400, 1501143000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1907,
        block_hash: [0x72415b0c, 0x602b8576, 0xb7dbc296, 0x9a011402, 0x9019078b, 0xdf6a0412, 0x9f0ca74f, 0x94111700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ee800,
        block_height: 1907,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501138200, 1501138800, 1501139400, 1501140000, 1501140600, 1501141200, 1501141800, 1501142400, 1501143000, 1501143600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1908,
        block_hash: [0xd118bada, 0xeee52c89, 0xe962e6c6, 0x1fd8b81e, 0x19b4f1a3, 0xbd29ebcf, 0x0209066c, 0x2ec41400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000eea00,
        block_height: 1908,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501138800, 1501139400, 1501140000, 1501140600, 1501141200, 1501141800, 1501142400, 1501143000, 1501143600, 1501144200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1909,
        block_hash: [0x27ebdad4, 0x34f256c5, 0xd848de93, 0xe957a34f, 0x3dc26714, 0x56e50dfa, 0xc9d647e8, 0xa5fb2900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000eec00,
        block_height: 1909,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501139400, 1501140000, 1501140600, 1501141200, 1501141800, 1501142400, 1501143000, 1501143600, 1501144200, 1501144800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1910,
        block_hash: [0x0e3b6c26, 0xfd8ff06c, 0xa7e7ac64, 0xa8914d1f, 0xbf33f0d0, 0xc16f520b, 0x364187e5, 0xdacc6000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000eee00,
        block_height: 1910,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140000, 1501140600, 1501141200, 1501141800, 1501142400, 1501143000, 1501143600, 1501144200, 1501144800, 1501145400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1911,
        block_hash: [0x9be9b953, 0xc0707179, 0xaf7a1c2e, 0x171ea18d, 0xa802bec1, 0x2fa0c1cc, 0xcc9031b3, 0xe94f5800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef000,
        block_height: 1911,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501140600, 1501141200, 1501141800, 1501142400, 1501143000, 1501143600, 1501144200, 1501144800, 1501145400, 1501146000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1912,
        block_hash: [0xdf2719ae, 0xc4ec2035, 0x6d261f41, 0xf0810fe4, 0xd0cc4d7f, 0x3e16e1ec, 0x4fc21572, 0xc6b23600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef200,
        block_height: 1912,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501141200, 1501141800, 1501142400, 1501143000, 1501143600, 1501144200, 1501144800, 1501145400, 1501146000, 1501146600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1913,
        block_hash: [0x1f32e6ae, 0x12402df9, 0x12ce5e96, 0x298c8e88, 0x0c08241a, 0xd968715d, 0xca4c7e12, 0x5a0f3b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef400,
        block_height: 1913,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501141800, 1501142400, 1501143000, 1501143600, 1501144200, 1501144800, 1501145400, 1501146000, 1501146600, 1501147200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1914,
        block_hash: [0xb64ca86b, 0x72502d18, 0x5e97facf, 0x4e287b29, 0x0e896e01, 0x828baa1a, 0x235f7f34, 0xc4273500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef600,
        block_height: 1914,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501142400, 1501143000, 1501143600, 1501144200, 1501144800, 1501145400, 1501146000, 1501146600, 1501147200, 1501147800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1915,
        block_hash: [0xe3c55c07, 0x2ff66bb0, 0x5dfb0604, 0xbb0ce081, 0x7f5196df, 0xf2a3fe65, 0x5c48c25a, 0x60be5c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000ef800,
        block_height: 1915,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501143000, 1501143600, 1501144200, 1501144800, 1501145400, 1501146000, 1501146600, 1501147200, 1501147800, 1501148400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1916,
        block_hash: [0xd82c8c23, 0x22521d73, 0xc0e5cef1, 0xa10a7f7c, 0x171e609f, 0x55b14fa7, 0xc4cb0e52, 0x81837d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000efa00,
        block_height: 1916,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501143600, 1501144200, 1501144800, 1501145400, 1501146000, 1501146600, 1501147200, 1501147800, 1501148400, 1501149000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1917,
        block_hash: [0xf0c597d6, 0xac3cb66f, 0x52a59560, 0x8b5e4123, 0xc74256a6, 0x81ce179a, 0xd436f537, 0x07306000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000efc00,
        block_height: 1917,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501144200, 1501144800, 1501145400, 1501146000, 1501146600, 1501147200, 1501147800, 1501148400, 1501149000, 1501149600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1918,
        block_hash: [0xa9640b9c, 0xf89d9785, 0xfd378847, 0x312bfec4, 0xe250c34d, 0xac6a05cf, 0xea46967a, 0x6a2f6700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000efe00,
        block_height: 1918,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501144800, 1501145400, 1501146000, 1501146600, 1501147200, 1501147800, 1501148400, 1501149000, 1501149600, 1501150200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1919,
        block_hash: [0x706c7b21, 0xf79ef8df, 0xd93d0715, 0xb562bb76, 0x3ab0d4bd, 0x243513c0, 0xc9902484, 0x0bf00a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0000,
        block_height: 1919,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501145400, 1501146000, 1501146600, 1501147200, 1501147800, 1501148400, 1501149000, 1501149600, 1501150200, 1501150800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1920,
        block_hash: [0x206541b8, 0x0f513937, 0x526d2ef4, 0x83c0322c, 0x1731fe86, 0x262dc26c, 0x1da87d1f, 0x96946200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0200,
        block_height: 1920,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501146000, 1501146600, 1501147200, 1501147800, 1501148400, 1501149000, 1501149600, 1501150200, 1501150800, 1501151400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1921,
        block_hash: [0xb0de0ef2, 0x21f9b5aa, 0x421965af, 0xc7ef0da3, 0x98799458, 0x3066dca3, 0x943a91a4, 0xc51c0c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0400,
        block_height: 1921,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501146600, 1501147200, 1501147800, 1501148400, 1501149000, 1501149600, 1501150200, 1501150800, 1501151400, 1501152000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1922,
        block_hash: [0xa752eb93, 0xd6b1d554, 0x9d8af9a6, 0xce591f67, 0xa6c6bcea, 0x22211d01, 0xd07718a9, 0xfacd0100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0600,
        block_height: 1922,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501147200, 1501147800, 1501148400, 1501149000, 1501149600, 1501150200, 1501150800, 1501151400, 1501152000, 1501152600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1923,
        block_hash: [0x42e0330c, 0x361337c4, 0x3027cc08, 0x8e60fdd9, 0x87fa4fc8, 0x83c45d13, 0x231ff222, 0xc48d6b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0800,
        block_height: 1923,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501147800, 1501148400, 1501149000, 1501149600, 1501150200, 1501150800, 1501151400, 1501152000, 1501152600, 1501153200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1924,
        block_hash: [0x9555d98d, 0x04692412, 0xbc9a4a78, 0x5241bde9, 0x16c8b2ce, 0xdd9f36bf, 0x5cf60230, 0x61836700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0a00,
        block_height: 1924,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501148400, 1501149000, 1501149600, 1501150200, 1501150800, 1501151400, 1501152000, 1501152600, 1501153200, 1501153800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1925,
        block_hash: [0xa8e3b19e, 0xa497007e, 0x54f48184, 0xd9c9f4e6, 0xca39b1d8, 0x73a69076, 0x1b1bf3e7, 0x06dc0a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0c00,
        block_height: 1925,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501149000, 1501149600, 1501150200, 1501150800, 1501151400, 1501152000, 1501152600, 1501153200, 1501153800, 1501154400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1926,
        block_hash: [0x79e231a3, 0x8460644d, 0x57fb91bc, 0x3f6655d2, 0xc1c5ac2f, 0x53d70a99, 0x5c4f01e3, 0x6a8b7600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f0e00,
        block_height: 1926,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501149600, 1501150200, 1501150800, 1501151400, 1501152000, 1501152600, 1501153200, 1501153800, 1501154400, 1501155000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1927,
        block_hash: [0x9c517758, 0x4b0e2dc9, 0x107223dd, 0x366aede3, 0xae44b03b, 0xfe666959, 0x8b31bf0a, 0x29b54000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1000,
        block_height: 1927,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501150200, 1501150800, 1501151400, 1501152000, 1501152600, 1501153200, 1501153800, 1501154400, 1501155000, 1501155600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1928,
        block_hash: [0xa35fe26d, 0xd7f4eb02, 0xaf0a2e5a, 0x22d1be11, 0xb0fabaec, 0x8b318096, 0x111d68db, 0xe6b35000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1200,
        block_height: 1928,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501150800, 1501151400, 1501152000, 1501152600, 1501153200, 1501153800, 1501154400, 1501155000, 1501155600, 1501156200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1929,
        block_hash: [0xad826f8b, 0x59f489ba, 0x3c153ca8, 0x444eb36e, 0xe395ba71, 0x96358b06, 0x96e97776, 0x4b700d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1400,
        block_height: 1929,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501151400, 1501152000, 1501152600, 1501153200, 1501153800, 1501154400, 1501155000, 1501155600, 1501156200, 1501156800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1930,
        block_hash: [0x8fdbc3ed, 0x303ecda2, 0xbdd515b2, 0x1bfd0727, 0x7ea520c1, 0x68409ba0, 0x0dac9d2c, 0x59ee1600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1600,
        block_height: 1930,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501152000, 1501152600, 1501153200, 1501153800, 1501154400, 1501155000, 1501155600, 1501156200, 1501156800, 1501157400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1931,
        block_hash: [0xbd455094, 0x8e6df1a7, 0xdddcfc24, 0x9d0014c8, 0x5288b947, 0x6400c3ca, 0xba78882b, 0xb4157800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1800,
        block_height: 1931,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501152600, 1501153200, 1501153800, 1501154400, 1501155000, 1501155600, 1501156200, 1501156800, 1501157400, 1501158000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1932,
        block_hash: [0x6d7b488b, 0x95822b12, 0x36bf4fba, 0x7daaf472, 0xe24192ef, 0x1ecdcc05, 0x86396328, 0xb9a86000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1a00,
        block_height: 1932,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501153200, 1501153800, 1501154400, 1501155000, 1501155600, 1501156200, 1501156800, 1501157400, 1501158000, 1501158600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1933,
        block_hash: [0x4c3f505d, 0xebf9e1a5, 0xd0c459f7, 0x52f21962, 0x71b4391d, 0x376f9a49, 0x84ada30c, 0x667c3000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1c00,
        block_height: 1933,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501153800, 1501154400, 1501155000, 1501155600, 1501156200, 1501156800, 1501157400, 1501158000, 1501158600, 1501159200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1934,
        block_hash: [0x6c4c4177, 0x54cef314, 0x9ab49855, 0xf5b2f93f, 0x66647438, 0xf6fd6ef6, 0x24246c27, 0x1c930f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f1e00,
        block_height: 1934,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501154400, 1501155000, 1501155600, 1501156200, 1501156800, 1501157400, 1501158000, 1501158600, 1501159200, 1501159800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1935,
        block_hash: [0xe901f9b2, 0x8def8eed, 0xc321fc0b, 0x90573c03, 0xb3d819b9, 0x46ee4b1b, 0xde35a8c6, 0xb0a20e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2000,
        block_height: 1935,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501155000, 1501155600, 1501156200, 1501156800, 1501157400, 1501158000, 1501158600, 1501159200, 1501159800, 1501160400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1936,
        block_hash: [0x3ebaf392, 0xb695a8fe, 0x514e2e58, 0x6842749d, 0xe349974c, 0x72f9f928, 0xb0e42c14, 0x67686700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2200,
        block_height: 1936,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501155600, 1501156200, 1501156800, 1501157400, 1501158000, 1501158600, 1501159200, 1501159800, 1501160400, 1501161000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1937,
        block_hash: [0x3e4302d5, 0x63173c40, 0x5976793a, 0xa3f0aefc, 0x87ac205b, 0x00c59fd0, 0x5ee668d4, 0x6a081d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2400,
        block_height: 1937,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501156200, 1501156800, 1501157400, 1501158000, 1501158600, 1501159200, 1501159800, 1501160400, 1501161000, 1501161600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1938,
        block_hash: [0x3af43465, 0x5a1b41c6, 0x83d609bf, 0x39a1f321, 0x747f4a6c, 0xc8dda4c9, 0x52f307df, 0xe3594100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2600,
        block_height: 1938,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501156800, 1501157400, 1501158000, 1501158600, 1501159200, 1501159800, 1501160400, 1501161000, 1501161600, 1501162200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1939,
        block_hash: [0x21ef96a9, 0xdf56f4ea, 0xebff6f48, 0x2d82dce0, 0xb51070c1, 0xa6392294, 0x5c44718e, 0x4e324500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2800,
        block_height: 1939,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501157400, 1501158000, 1501158600, 1501159200, 1501159800, 1501160400, 1501161000, 1501161600, 1501162200, 1501162800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1940,
        block_hash: [0x1e22a50b, 0xf0bf606a, 0x8e43b9ac, 0x8d77b44d, 0xffb9a807, 0x79493724, 0x5022ff34, 0x678e0600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2a00,
        block_height: 1940,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501158000, 1501158600, 1501159200, 1501159800, 1501160400, 1501161000, 1501161600, 1501162200, 1501162800, 1501163400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1941,
        block_hash: [0x639d096d, 0x9ebc6ea4, 0x5262c1fd, 0x054e2e4f, 0x9f5fba7b, 0xd8665580, 0x8619d2f9, 0xa91e5200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2c00,
        block_height: 1941,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501158600, 1501159200, 1501159800, 1501160400, 1501161000, 1501161600, 1501162200, 1501162800, 1501163400, 1501164000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1942,
        block_hash: [0x560a4528, 0xd1c25b8d, 0xbab9fce6, 0x2e3d8199, 0x41b651db, 0x1e76c126, 0x265b579b, 0xa9923c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f2e00,
        block_height: 1942,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501159200, 1501159800, 1501160400, 1501161000, 1501161600, 1501162200, 1501162800, 1501163400, 1501164000, 1501164600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1943,
        block_hash: [0x8f64f0f2, 0x944c4c83, 0x1453113e, 0x21637265, 0x3bd9e06e, 0xdde837aa, 0xab437ad6, 0xb6ec4300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3000,
        block_height: 1943,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501159800, 1501160400, 1501161000, 1501161600, 1501162200, 1501162800, 1501163400, 1501164000, 1501164600, 1501165200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1944,
        block_hash: [0x1e619657, 0x70b1f8e4, 0x0f405725, 0xd59935d4, 0x5dc269ca, 0xa9fed66f, 0xaf1cd919, 0x68992500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3200,
        block_height: 1944,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501160400, 1501161000, 1501161600, 1501162200, 1501162800, 1501163400, 1501164000, 1501164600, 1501165200, 1501165800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1945,
        block_hash: [0x68bae0bb, 0xf9165644, 0xe4582926, 0x89d3c024, 0xdcf570c5, 0x94977541, 0xe0f8416f, 0x6ef60600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3400,
        block_height: 1945,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501161000, 1501161600, 1501162200, 1501162800, 1501163400, 1501164000, 1501164600, 1501165200, 1501165800, 1501166400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1946,
        block_hash: [0x0a376d76, 0xe71a859b, 0x718caeb0, 0x25a838d6, 0x507d3f6f, 0x9d6d9e38, 0x0d9d0dde, 0x284c3b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3600,
        block_height: 1946,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501161600, 1501162200, 1501162800, 1501163400, 1501164000, 1501164600, 1501165200, 1501165800, 1501166400, 1501167000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1947,
        block_hash: [0x2362ff81, 0x67ef9fb1, 0x7a4bcd8d, 0xd05f4b1a, 0xc6443e27, 0xb36f867f, 0x61124947, 0x71327100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3800,
        block_height: 1947,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501162200, 1501162800, 1501163400, 1501164000, 1501164600, 1501165200, 1501165800, 1501166400, 1501167000, 1501167600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1948,
        block_hash: [0xb9d63aed, 0xd6b21649, 0x146bdf3d, 0xc4057686, 0x228fdbd5, 0x8dfdc3d4, 0xe827e5a4, 0x88567000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3a00,
        block_height: 1948,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501162800, 1501163400, 1501164000, 1501164600, 1501165200, 1501165800, 1501166400, 1501167000, 1501167600, 1501168200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1949,
        block_hash: [0x822e89d8, 0x774e6f4d, 0x2ba88154, 0x4dc9bc5a, 0x6996c0b0, 0x81e4ce2b, 0x33b08e50, 0x5a283b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3c00,
        block_height: 1949,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501163400, 1501164000, 1501164600, 1501165200, 1501165800, 1501166400, 1501167000, 1501167600, 1501168200, 1501168800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1950,
        block_hash: [0x3783888f, 0xe47cdbe8, 0x3c1b94e7, 0xc33ce085, 0x672c4b3d, 0x0d0df801, 0xb4c3411b, 0xe1263900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f3e00,
        block_height: 1950,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501164000, 1501164600, 1501165200, 1501165800, 1501166400, 1501167000, 1501167600, 1501168200, 1501168800, 1501169400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1951,
        block_hash: [0xf18ec7a0, 0x80bb293b, 0x1a9b9a3f, 0xad403328, 0xdb311732, 0xebd52a0f, 0x2adb9c54, 0x73fc2b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4000,
        block_height: 1951,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501164600, 1501165200, 1501165800, 1501166400, 1501167000, 1501167600, 1501168200, 1501168800, 1501169400, 1501170000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1952,
        block_hash: [0x5a3aff41, 0x1f908dcb, 0xdad7d346, 0xbd67c077, 0xf39768bc, 0x40cf926b, 0x488823d1, 0x9a844100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4200,
        block_height: 1952,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501165200, 1501165800, 1501166400, 1501167000, 1501167600, 1501168200, 1501168800, 1501169400, 1501170000, 1501170600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1953,
        block_hash: [0x767364a4, 0xd568fd79, 0x5349f05d, 0x111136dd, 0x0d06c08a, 0xb7a4776e, 0x97d21c20, 0x9e551200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4400,
        block_height: 1953,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501165800, 1501166400, 1501167000, 1501167600, 1501168200, 1501168800, 1501169400, 1501170000, 1501170600, 1501171200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1954,
        block_hash: [0x99ceb60e, 0xfc4b467e, 0x33146d18, 0x8190b9b9, 0x9467e59b, 0x4ad46d04, 0x07f9d662, 0xb1095c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4600,
        block_height: 1954,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501166400, 1501167000, 1501167600, 1501168200, 1501168800, 1501169400, 1501170000, 1501170600, 1501171200, 1501171800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1955,
        block_hash: [0x0daaaa2b, 0xaa565014, 0xb97a5cb8, 0x72a4f267, 0xc5b05dcb, 0x3829aa68, 0x92a8eb3e, 0xe63e1900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4800,
        block_height: 1955,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501167000, 1501167600, 1501168200, 1501168800, 1501169400, 1501170000, 1501170600, 1501171200, 1501171800, 1501172400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1956,
        block_hash: [0x5810f00b, 0xcd3962df, 0x9cbe6c0f, 0xc5349544, 0xce82bbb2, 0xae9a129b, 0x808994cb, 0x0e327900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4a00,
        block_height: 1956,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501167600, 1501168200, 1501168800, 1501169400, 1501170000, 1501170600, 1501171200, 1501171800, 1501172400, 1501173000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1957,
        block_hash: [0x2ba36738, 0x4ba59401, 0x746ac77f, 0xf0fd43d4, 0x768a10ed, 0x9bb5b681, 0x3a71b7e1, 0x281f1d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4c00,
        block_height: 1957,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501168200, 1501168800, 1501169400, 1501170000, 1501170600, 1501171200, 1501171800, 1501172400, 1501173000, 1501173600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1958,
        block_hash: [0x2b7f1f0f, 0xa8806f03, 0xd8a10416, 0xe0e2c378, 0x66cae77a, 0xe7b5f69b, 0x3e57d7ab, 0x34381f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f4e00,
        block_height: 1958,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501168800, 1501169400, 1501170000, 1501170600, 1501171200, 1501171800, 1501172400, 1501173000, 1501173600, 1501174200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1959,
        block_hash: [0x2ba3b491, 0x50c01292, 0xadc74a2f, 0x080e70be, 0xeb7c9dec, 0x94d2eab2, 0x6dfd3c0c, 0xd55c5300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5000,
        block_height: 1959,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501169400, 1501170000, 1501170600, 1501171200, 1501171800, 1501172400, 1501173000, 1501173600, 1501174200, 1501174800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1960,
        block_hash: [0xb34c99a4, 0x18054c43, 0x6b9db8f5, 0x29b15117, 0x337c8f16, 0xc9b6d389, 0x34b5d38c, 0xdcf14900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5200,
        block_height: 1960,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501170000, 1501170600, 1501171200, 1501171800, 1501172400, 1501173000, 1501173600, 1501174200, 1501174800, 1501175400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1961,
        block_hash: [0x71c4ea41, 0x3155a5d0, 0x7556d587, 0x3cda0a33, 0xcff7e034, 0x5536da63, 0x57319fb2, 0x644a4900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5400,
        block_height: 1961,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501170600, 1501171200, 1501171800, 1501172400, 1501173000, 1501173600, 1501174200, 1501174800, 1501175400, 1501176000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1962,
        block_hash: [0xda22310f, 0x06dd26ef, 0x80dc7fe5, 0x3d6067b7, 0xd555fdf5, 0xb9fc382a, 0x98a94e1f, 0x7fca1d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5600,
        block_height: 1962,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501171200, 1501171800, 1501172400, 1501173000, 1501173600, 1501174200, 1501174800, 1501175400, 1501176000, 1501176600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1963,
        block_hash: [0x09ddee46, 0xb23f587b, 0x33abcfb7, 0x306d3de1, 0x61c00b10, 0x6b015ac2, 0x854d9a3d, 0xb9ae7c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5800,
        block_height: 1963,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501171800, 1501172400, 1501173000, 1501173600, 1501174200, 1501174800, 1501175400, 1501176000, 1501176600, 1501177200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1964,
        block_hash: [0xc311437d, 0xb1768c1c, 0xf10c04dd, 0x0e362494, 0x94b26e82, 0x28f6bc1f, 0x072b28c6, 0x1d392700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5a00,
        block_height: 1964,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501172400, 1501173000, 1501173600, 1501174200, 1501174800, 1501175400, 1501176000, 1501176600, 1501177200, 1501177800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1965,
        block_hash: [0xa439b2fb, 0x58858755, 0x206ac5d7, 0x57575ebd, 0xaae86b0f, 0x07f71235, 0xbaca3d80, 0x0d1d5100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5c00,
        block_height: 1965,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501173000, 1501173600, 1501174200, 1501174800, 1501175400, 1501176000, 1501176600, 1501177200, 1501177800, 1501178400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1966,
        block_hash: [0xc0f304f4, 0x19f70755, 0xc086e5aa, 0x15ac48f7, 0xd0bf6aff, 0x3ac42507, 0x61561962, 0x53783f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f5e00,
        block_height: 1966,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501173600, 1501174200, 1501174800, 1501175400, 1501176000, 1501176600, 1501177200, 1501177800, 1501178400, 1501179000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1967,
        block_hash: [0x82f9ca45, 0x76b054a1, 0x93bfcb74, 0x7622a531, 0x6514cb2b, 0x141559c7, 0x9f4e2f7a, 0x831f4c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6000,
        block_height: 1967,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501174200, 1501174800, 1501175400, 1501176000, 1501176600, 1501177200, 1501177800, 1501178400, 1501179000, 1501179600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1968,
        block_hash: [0xd04c5fe5, 0x173a2d6d, 0xcfc1cac1, 0x14f35f87, 0x2075d7a8, 0x3ff94c1c, 0xd8b96dad, 0xd8426100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6200,
        block_height: 1968,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501174800, 1501175400, 1501176000, 1501176600, 1501177200, 1501177800, 1501178400, 1501179000, 1501179600, 1501180200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1969,
        block_hash: [0x45992b8a, 0xa8998ca0, 0x06656a35, 0x7fe36400, 0xbc59a276, 0xd60e74f1, 0xfece9694, 0x71e32b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6400,
        block_height: 1969,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501175400, 1501176000, 1501176600, 1501177200, 1501177800, 1501178400, 1501179000, 1501179600, 1501180200, 1501180800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1970,
        block_hash: [0x26945df1, 0xf3857151, 0x3e26dbcd, 0xa315a458, 0xacc760d3, 0x6ad9070f, 0x28351e0a, 0x126f0e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6600,
        block_height: 1970,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501176000, 1501176600, 1501177200, 1501177800, 1501178400, 1501179000, 1501179600, 1501180200, 1501180800, 1501181400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1971,
        block_hash: [0x28cf7cbf, 0x8123d386, 0x66e8c8dc, 0xd571b97d, 0x9c0fd061, 0x0df0be0a, 0xa1b7e57d, 0x7af55b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6800,
        block_height: 1971,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501176600, 1501177200, 1501177800, 1501178400, 1501179000, 1501179600, 1501180200, 1501180800, 1501181400, 1501182000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1972,
        block_hash: [0x8dfcabcb, 0xf32d7652, 0x0fdf43ea, 0x9665ed82, 0xdf04394f, 0x8e58b354, 0xcce38d8b, 0x7e555700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6a00,
        block_height: 1972,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501177200, 1501177800, 1501178400, 1501179000, 1501179600, 1501180200, 1501180800, 1501181400, 1501182000, 1501182600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1973,
        block_hash: [0x05ba86e5, 0xfde94e65, 0xeb600114, 0xc93795a5, 0xd0dc3bee, 0x60be6429, 0x19240cbf, 0x71675300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6c00,
        block_height: 1973,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501177800, 1501178400, 1501179000, 1501179600, 1501180200, 1501180800, 1501181400, 1501182000, 1501182600, 1501183200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1974,
        block_hash: [0x97741862, 0xb1466466, 0x85624216, 0xc136a444, 0x8b3a7df5, 0xea0224d1, 0xa2dc7e66, 0xbf350800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f6e00,
        block_height: 1974,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501178400, 1501179000, 1501179600, 1501180200, 1501180800, 1501181400, 1501182000, 1501182600, 1501183200, 1501183800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1975,
        block_hash: [0xdd321e9b, 0xf8d0c90a, 0x3d62a215, 0xb0ca7754, 0x60396a13, 0xda958685, 0x1ef54a24, 0x62fb0e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7000,
        block_height: 1975,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501179000, 1501179600, 1501180200, 1501180800, 1501181400, 1501182000, 1501182600, 1501183200, 1501183800, 1501184400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1976,
        block_hash: [0x04738d3f, 0x211cd132, 0x703c733a, 0x7eee6adc, 0x23e23e3f, 0xee0c9ae1, 0x96442ff6, 0x19581600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7200,
        block_height: 1976,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501179600, 1501180200, 1501180800, 1501181400, 1501182000, 1501182600, 1501183200, 1501183800, 1501184400, 1501185000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1977,
        block_hash: [0x7ac0c473, 0x9e7c5704, 0xa341d6c3, 0x0b3eb4c7, 0x2983e51f, 0x2de3fd2e, 0x618739aa, 0x3aed4b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7400,
        block_height: 1977,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501180200, 1501180800, 1501181400, 1501182000, 1501182600, 1501183200, 1501183800, 1501184400, 1501185000, 1501185600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1978,
        block_hash: [0x00c3e9ff, 0x8eb38ef3, 0x28fe4d1e, 0xbcad7169, 0xf0d90b12, 0x61075cff, 0x626c0e8b, 0x24737700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7600,
        block_height: 1978,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501180800, 1501181400, 1501182000, 1501182600, 1501183200, 1501183800, 1501184400, 1501185000, 1501185600, 1501186200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1979,
        block_hash: [0x0756efef, 0xb259d7be, 0xcef7ddf4, 0xf373ecdc, 0x17996438, 0xd2626b86, 0x1f3997c5, 0xbf980600],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7800,
        block_height: 1979,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501181400, 1501182000, 1501182600, 1501183200, 1501183800, 1501184400, 1501185000, 1501185600, 1501186200, 1501186800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1980,
        block_hash: [0x1fa1535a, 0x647b511a, 0x5fa7941b, 0x4c940482, 0xc588f87f, 0x1af5da11, 0x2f35f88c, 0x5c173900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7a00,
        block_height: 1980,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501182000, 1501182600, 1501183200, 1501183800, 1501184400, 1501185000, 1501185600, 1501186200, 1501186800, 1501187400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1981,
        block_hash: [0xd9eb4f23, 0xffdc5085, 0x2cda2d30, 0x87ae882b, 0x3d7a07d6, 0xb928d684, 0x22ab8bca, 0x3f156100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7c00,
        block_height: 1981,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501182600, 1501183200, 1501183800, 1501184400, 1501185000, 1501185600, 1501186200, 1501186800, 1501187400, 1501188000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1982,
        block_hash: [0xf0cb4de9, 0x115bc674, 0x17a89b45, 0x8c57215f, 0x4bbdce39, 0x48476e19, 0x05ad16d6, 0x1d2e4d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f7e00,
        block_height: 1982,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501183200, 1501183800, 1501184400, 1501185000, 1501185600, 1501186200, 1501186800, 1501187400, 1501188000, 1501188600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1983,
        block_hash: [0x7a64a872, 0x4ce9ab48, 0x0b60cba6, 0x92179cbb, 0xae08bd0a, 0x9bceec2e, 0x514d4254, 0x3af56700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8000,
        block_height: 1983,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501183800, 1501184400, 1501185000, 1501185600, 1501186200, 1501186800, 1501187400, 1501188000, 1501188600, 1501189200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1984,
        block_hash: [0x8fb85566, 0x93807c94, 0xed5eed50, 0x4521d069, 0xb61b5360, 0x6c212314, 0x8d4f48ba, 0x068d4000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8200,
        block_height: 1984,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501184400, 1501185000, 1501185600, 1501186200, 1501186800, 1501187400, 1501188000, 1501188600, 1501189200, 1501189800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1985,
        block_hash: [0x5760d13a, 0x3b9e4399, 0x51fc9bad, 0x66197c2e, 0xf8bce5e4, 0x5de3407d, 0x32d4322b, 0x2c734100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8400,
        block_height: 1985,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501185000, 1501185600, 1501186200, 1501186800, 1501187400, 1501188000, 1501188600, 1501189200, 1501189800, 1501190400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1986,
        block_hash: [0xffb6c32c, 0x0411352c, 0x93d166c3, 0xc681c551, 0x08412370, 0x61bfb29d, 0x8eabbd5f, 0x334a2a00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8600,
        block_height: 1986,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501185600, 1501186200, 1501186800, 1501187400, 1501188000, 1501188600, 1501189200, 1501189800, 1501190400, 1501191000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1987,
        block_hash: [0x029e99f7, 0xec865836, 0xfd2d4410, 0x461673c8, 0x42a3a7e6, 0xe8509bcf, 0xaa8fa717, 0x764a1f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8800,
        block_height: 1987,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501186200, 1501186800, 1501187400, 1501188000, 1501188600, 1501189200, 1501189800, 1501190400, 1501191000, 1501191600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1988,
        block_hash: [0xd43ccd65, 0xb0e0a1fc, 0x50f58cf6, 0x3507e2b4, 0x49f4d4fa, 0x2b57f5ff, 0x39471dd6, 0x04ab4e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8a00,
        block_height: 1988,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501186800, 1501187400, 1501188000, 1501188600, 1501189200, 1501189800, 1501190400, 1501191000, 1501191600, 1501192200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1989,
        block_hash: [0xe1bdc12d, 0x2bf8bffa, 0x46eb3ea6, 0x2b49c1db, 0x452cd73a, 0x18501565, 0x93e54e92, 0xdbaa4200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8c00,
        block_height: 1989,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501187400, 1501188000, 1501188600, 1501189200, 1501189800, 1501190400, 1501191000, 1501191600, 1501192200, 1501192800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1990,
        block_hash: [0x720a2267, 0x1489cec4, 0x0e66d086, 0x942b1da6, 0xfe41ea16, 0x9323f509, 0x453c5ca0, 0xcb533800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f8e00,
        block_height: 1990,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501188000, 1501188600, 1501189200, 1501189800, 1501190400, 1501191000, 1501191600, 1501192200, 1501192800, 1501193400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1991,
        block_hash: [0x974036d2, 0xb2bfdcb2, 0x0335ae58, 0xd3d8bbf3, 0xad0a0c4f, 0x7aac55f2, 0xa46d889a, 0x68635400],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9000,
        block_height: 1991,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501188600, 1501189200, 1501189800, 1501190400, 1501191000, 1501191600, 1501192200, 1501192800, 1501193400, 1501194000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1992,
        block_hash: [0xc10a7e7c, 0xcb97609c, 0xbdcde6e7, 0xa21b38af, 0xc90d354a, 0x2ca38591, 0xacc382a1, 0x387c1f00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9200,
        block_height: 1992,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501189200, 1501189800, 1501190400, 1501191000, 1501191600, 1501192200, 1501192800, 1501193400, 1501194000, 1501194600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1993,
        block_hash: [0xd710ff63, 0xbb952f58, 0xb9360760, 0x71720db5, 0x152d47b4, 0x3bab2041, 0xbe946e7d, 0xd2194000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9400,
        block_height: 1993,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501189800, 1501190400, 1501191000, 1501191600, 1501192200, 1501192800, 1501193400, 1501194000, 1501194600, 1501195200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1994,
        block_hash: [0x31f57f13, 0x7d7ab3d7, 0x650a0ce9, 0xe39ea0fc, 0x534084b7, 0x9e941661, 0x6ee92abe, 0x8dbc5300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9600,
        block_height: 1994,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501190400, 1501191000, 1501191600, 1501192200, 1501192800, 1501193400, 1501194000, 1501194600, 1501195200, 1501195800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1995,
        block_hash: [0x044c0a16, 0x04d138bf, 0xdf0a5c0d, 0x4b762f7f, 0x2463f785, 0x5b2662eb, 0xbd920eb2, 0x6f355100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9800,
        block_height: 1995,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501191000, 1501191600, 1501192200, 1501192800, 1501193400, 1501194000, 1501194600, 1501195200, 1501195800, 1501196400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1996,
        block_hash: [0xc81eba61, 0xdbcbee28, 0x74307dd9, 0x109adccd, 0xaa3c50ee, 0xf896f374, 0xf6bbd8e9, 0xb9793c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9a00,
        block_height: 1996,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501191600, 1501192200, 1501192800, 1501193400, 1501194000, 1501194600, 1501195200, 1501195800, 1501196400, 1501197000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1997,
        block_hash: [0xcc0d7358, 0x572de46f, 0x571c5ead, 0x71f7ada7, 0x6a7f7d34, 0xf0eb7708, 0x842b1cef, 0xc9675c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9c00,
        block_height: 1997,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501192200, 1501192800, 1501193400, 1501194000, 1501194600, 1501195200, 1501195800, 1501196400, 1501197000, 1501197600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1998,
        block_hash: [0xf4cf299b, 0x429b33ab, 0xf7f3bd1f, 0x2b51a33e, 0xb6e9b767, 0x84a67a1e, 0x673d7112, 0x96d74300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000f9e00,
        block_height: 1998,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501192800, 1501193400, 1501194000, 1501194600, 1501195200, 1501195800, 1501196400, 1501197000, 1501197600, 1501198200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_1999,
        block_hash: [0x51fe36d6, 0x7f7055d0, 0xaab8d53a, 0x54ffe46a, 0x1ba8a665, 0xb8ca1c25, 0x0275e069, 0x01971d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa000,
        block_height: 1999,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501193400, 1501194000, 1501194600, 1501195200, 1501195800, 1501196400, 1501197000, 1501197600, 1501198200, 1501198800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2000,
        block_hash: [0x163fbd89, 0xd0bf817a, 0xea586259, 0x949ecdd4, 0x443a47fc, 0xfe0eedd5, 0x81f074f1, 0x57893900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa200,
        block_height: 2000,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501194000, 1501194600, 1501195200, 1501195800, 1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2001,
        block_hash: [0x9a8577ba, 0xb63fd8f0, 0x65b946bc, 0x43285731, 0x87f3755a, 0x4108c2a5, 0x8801bf16, 0x90701d00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa400,
        block_height: 2001,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501194600, 1501195200, 1501195800, 1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2002,
        block_hash: [0xecf3680e, 0x790aca04, 0xb0962f9e, 0x717edc90, 0xe8c2fbde, 0x7eda6d3f, 0x55930078, 0x2a061c00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa600,
        block_height: 2002,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501195200, 1501195800, 1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2003,
        block_hash: [0x904731c9, 0xecb34561, 0x4246ed11, 0x1cf61317, 0x7c8f2e66, 0x804d7724, 0x0c164fb6, 0x3dfc0000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fa800,
        block_height: 2003,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501195800, 1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2004,
        block_hash: [0x8b87228a, 0x0416e042, 0x54f8c94e, 0x31ee59d7, 0x4857d316, 0x5ebf6991, 0x8b57561d, 0xad1b4500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000faa00,
        block_height: 2004,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501196400, 1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2005,
        block_hash: [0x493888d7, 0xf2faede2, 0x32ba98a2, 0xea11e639, 0x3ba6dff5, 0x274e2aa4, 0x8badc443, 0x18726100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fac00,
        block_height: 2005,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501197000, 1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2006,
        block_hash: [0xa820a9c3, 0xec375df0, 0x99977d33, 0x6ed6d90a, 0x0c5b08c2, 0x5e7bf2ba, 0xcb1b31ab, 0x16004500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fae00,
        block_height: 2006,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501197600, 1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2007,
        block_hash: [0xc55dd756, 0x1b05e3ab, 0x42be743c, 0x3a431dbe, 0xb3ec325b, 0xfe67cf55, 0x60d57c44, 0xc3704900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb000,
        block_height: 2007,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501198200, 1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2008,
        block_hash: [0x9d1b6cd1, 0x48867824, 0xb5e2c0f8, 0x02b0d1da, 0x996427c5, 0x69eb6b22, 0xf0508719, 0x359a5900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb200,
        block_height: 2008,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501198800, 1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2009,
        block_hash: [0xb7a09792, 0xc99bf065, 0x7fb5a4ca, 0x67b39bbc, 0x1c8ca147, 0xdcd70c57, 0xeb267582, 0x3b847100],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb400,
        block_height: 2009,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501199400, 1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2010,
        block_hash: [0x7a34a578, 0x7a68899f, 0x0703274b, 0xca4a8438, 0x164cfc7c, 0x8b92e678, 0x72895bbc, 0x4b622300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb600,
        block_height: 2010,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501200000, 1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2011,
        block_hash: [0xcd5c2aef, 0xe7fee677, 0x09de8807, 0xcbe8ec78, 0x2b7bd15b, 0x6c94f5fb, 0xab2c12c0, 0x95f74b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fb800,
        block_height: 2011,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501200600, 1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2012,
        block_hash: [0x64ed0199, 0xd2af8825, 0xf0d64cec, 0x0864d8a4, 0x238c91d7, 0x4f5a0cbc, 0x1d3bb719, 0x41485700],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fba00,
        block_height: 2012,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501201200, 1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2013,
        block_hash: [0x77eb7745, 0x1aa0dccc, 0xbc1114b7, 0x300bae29, 0xb6f0ed2d, 0xb2f7fb75, 0x6b55a7c0, 0x78783000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fbc00,
        block_height: 2013,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501201800, 1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2014,
        block_hash: [0x816d4621, 0xe7dfec98, 0x450e274d, 0x87d10e1b, 0xed21d29c, 0x8d1d0983, 0xa76e3550, 0x7c761800],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fbe00,
        block_height: 2014,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501202400, 1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2015,
        block_hash: [0xbe97423b, 0x47262e17, 0x0e42136c, 0x3f2b07d1, 0x8e6f21d5, 0x2e3c5d19, 0xef446290, 0xa8533b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc000,
        block_height: 2015,
        last_diff_adjustment: 1500000000,
        prev_block_timestamps: [1501203000, 1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2016,
        block_hash: [0x1e37d420, 0xa0144549, 0xc38db1f2, 0x4d62b88e, 0x9b8be8c4, 0x842a9082, 0xb626e629, 0x70105e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc200,
        block_height: 2016,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501203600, 1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2017,
        block_hash: [0x9f9f22e7, 0x800036e8, 0xd18c881e, 0x7eb1c731, 0xb6587b66, 0xf4ff605d, 0xac438bdb, 0x4a183900],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc400,
        block_height: 2017,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501204200, 1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2018,
        block_hash: [0xc691d1b5, 0x077eafdb, 0x0ebe8447, 0xb135b307, 0x93654532, 0x1f7611ce, 0x4691773c, 0x97b65500],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc600,
        block_height: 2018,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501204800, 1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2019,
        block_hash: [0xe02ff6d8, 0xccbb157b, 0x44c77dd1, 0x3e7c3a60, 0x47ff0c4b, 0x34760ccd, 0x10e94a85, 0x8c9d4000],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fc800,
        block_height: 2019,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501205400, 1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2020,
        block_hash: [0x1cd3595e, 0x1871c0c8, 0xf46a7ef9, 0x36d6531d, 0x91633ef6, 0x58925137, 0xb839b0a9, 0xb87a7300],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fca00,
        block_height: 2020,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501206000, 1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800, 1501211400]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2021,
        block_hash: [0xd3d00b19, 0x6f8da9c0, 0x9f418222, 0xecb78652, 0x4ba2b539, 0x773fc960, 0x7f34afbd, 0x02587e00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fcc00,
        block_height: 2021,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501206600, 1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800, 1501211400, 1501212000]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2022,
        block_hash: [0x78bf98ed, 0x78471ea5, 0x259c3308, 0x7e26981f, 0x071fb1fc, 0x30e1157a, 0x54b5e968, 0x6eb21200],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fce00,
        block_height: 2022,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501207200, 1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800, 1501211400, 1501212000, 1501212600]
    },
    StoredBlockHeader {
        blockheader: BLOCKHEADER_2023,
        block_hash: [0x2884498c, 0xe6f6794d, 0x98cdb339, 0xcb1397e3, 0x4bca62ce, 0x77c643e0, 0xd4004f4f, 0x7e521b00],
        chain_work: 0x00000000000000000000000000000000000000000000000000000000000fd000,
        block_height: 2023,
        last_diff_adjustment: 1501209600,
        prev_block_timestamps: [1501207800, 1501208400, 1501209000, 1501209600, 1501210200, 1501210800, 1501211400, 1501212000, 1501212600, 1501213200]
    },
];
