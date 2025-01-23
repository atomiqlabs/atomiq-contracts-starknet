const BN = require("bn.js");
const crypto = require("crypto");
const { exportToCairoFile } = require("../utils/cairo_structs");

function generateRandomTestCase() {
    const expiryTimestamp = BN.max(new BN(crypto.randomBytes(8)), new BN(1));
    const delta = new BN(crypto.randomBytes(7));
    const currentTimestamp = BN.max(expiryTimestamp.sub(delta), new BN(0));
    return [expiryTimestamp, currentTimestamp];
}

const numTests = 10;

const tests = [];
for(let i=0;i<numTests;i++) {
    tests.push(generateRandomTestCase());
}

exportToCairoFile(tests, "./tests/data/invalid.cairo");
