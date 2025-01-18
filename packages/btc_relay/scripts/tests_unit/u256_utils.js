const BN = require("bn.js");
const crypto = require("crypto");

const testCases = 10;

function generateAssertion(u256) {
    const buffer = u256.toBuffer('le', 32);
    const u32Arr = [];
    for(let i=0;i<8;i++) {
        u32Arr.push("0x"+buffer.readUInt32BE(i*4).toString(16).padStart(8, "0"));
    }
    return "let input: [u32; 8] = ["+u32Arr.join(", ")+"];\n" +
        "assert_eq!(input.from_le_to_u256(), 0x"+u256.toString("hex").padStart(64, "0")+");\n";
}

function generateRandomTestCase() {
    const u256 = new BN(crypto.randomBytes(32));
    return generateAssertion(u256);
}

console.log("\n// Random test cases\n");
for(let i=0;i<testCases;i++) {
    console.log(generateRandomTestCase());
}

console.log("\n// Block hashes\n");
const blockHashes = [
    "000000000a78fed5bde3dbe879c0dc84536ec750793ff3be29f4cf5e846561b1",
    "000000000000832cc67ec1aed671961356a286616cb8a0148d78d39b18f82441",
    "000000000000041100716a4636db18d9a80c96da1e55f08be7bfe161bcddbe58",
    "000000000000000019065fcc1ea22aa218ae12a6ee96a7a015c506834bfe6908",
    "00000000000000000136cb955d4c6862e13148357cd1a80846e763bcba9e8d0d",
    "00000000000000000009bbbbfea38e2878756b30522142767edc7fc7b26a6f82",
    "000000000000000000067bea442af50a91377ac796e63b8d284354feff4042b3",
    "000000000000000000085ac540d19de9fc56387f42c6532a70e5253dbeb03f27",
    "00000000000000000001f32923ab4730b4c81721b0dd974209def710b194bfdf"
];
blockHashes.forEach(blockHash => console.log(generateAssertion(new BN(blockHash, 16))));

console.log("\n// Manual test cases\n");
const manualCases = [
    "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1f20",
    "0000000000000000000000000000000000000000000000000000000000000001",
    "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000",
    "00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
    "FF00FF00FF00FF00FF00FF00FF00FF0000FF00FF00FF00FF00FF00FF00FF00FF",
    "0100000000000000000000000000000000000000000000000000000000000000",
    "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
    "0000000000000000000000000000000000000000000000000000000000000000"
];
manualCases.forEach(manualCase => console.log(generateAssertion(new BN(manualCase, 16))));
