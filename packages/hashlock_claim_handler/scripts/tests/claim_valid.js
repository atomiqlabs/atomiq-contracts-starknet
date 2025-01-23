const starknet = require("micro-starknet");
const crypto = require("crypto");
const { exportToCairoFile, toU32Array } = require("../utils/cairo_structs");

function generateTestCase(secret) {
    const hash = toU32Array(crypto.createHash("sha256").update(secret).digest());
    const result = starknet.poseidonHashMany(hash);
    return [result, secret];
}

function generateRandomTestCase() {
    return generateTestCase(crypto.randomBytes(32));
}

const numTests = 10;

const testsRandom = [];
for(let i=0;i<numTests;i++) {
    testsRandom.push(generateRandomTestCase());
}
exportToCairoFile(testsRandom, "./tests/data/valid_random.cairo");

const manualCases = [
    "0000000000000000000000000000000000000000000000000000000000000000",
    "0000000000000000000000000000000000000000000000000000000000000001",
    "1000000000000000000000000000000000000000000000000000000000000000",
    "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f",
    "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
    "ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00",
].map(e => Buffer.from(e, "hex"));

exportToCairoFile(manualCases.map(generateTestCase), "./tests/data/valid_manual.cairo");
