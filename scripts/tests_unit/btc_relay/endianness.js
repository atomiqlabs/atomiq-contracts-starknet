const BN = require("bn.js");
const crypto = require("crypto");

const testCases = 10;

function generateAssertion(u32) {
    return "assert_eq!(0x"+u32.toBuffer("le", 4).toString("hex")+"_u32.rev_endianness(), 0x"+u32.toBuffer("be", 4).toString("hex")+");";
}

function generateRandomTestCase() {
    const u32 = new BN(crypto.randomBytes(4));
    return generateAssertion(u32);
}

console.log("\n// Random test cases\n");
for(let i=0;i<testCases;i++) {
    console.log(generateRandomTestCase());
}

console.log("\n// Manual test cases\n");
const manualCases = [
    "00010203",
    "00000001",
    "FFFF0000",
    "0000FFFF",
    "FF0000FF",
    "01000000",
    "FFFFFFFF",
    "00000000"
];
manualCases.forEach(manualCase => console.log(generateAssertion(new BN(manualCase, 16))));
