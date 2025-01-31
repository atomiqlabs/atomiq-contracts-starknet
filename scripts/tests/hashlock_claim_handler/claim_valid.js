const starknet = require("micro-starknet");
const crypto = require("crypto");
const { exportToCairoFile, toU32Array, toCairoTuple, toCairoArray } = require("../../utils/cairo_structs");

function generateTestCase(secret) {
    const hash = toU32Array(crypto.createHash("sha256").update(secret).digest());
    const result = starknet.poseidonHashMany(hash);
    return toCairoTuple([result, toU32Array(secret)]);
}

function generateRandomTestCase() {
    return generateTestCase(crypto.randomBytes(32));
}

const numTests = 10;

const testsRandom = [];
for(let i=0;i<numTests;i++) {
    testsRandom.push(generateRandomTestCase());
}
exportToCairoFile([{
    name: "TEST_DATA",
    type: "[(felt252, [u32; 8]); "+testsRandom.length+"]",
    value: toCairoArray(testsRandom, 0, true)
}], "../packages/hashlock_claim_handler/tests/data/valid_random.cairo");

const manualCases = [
    "0000000000000000000000000000000000000000000000000000000000000000",
    "0000000000000000000000000000000000000000000000000000000000000001",
    "1000000000000000000000000000000000000000000000000000000000000000",
    "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f",
    "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
    "ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00",
].map(e => Buffer.from(e, "hex"));

exportToCairoFile([{
    name: "TEST_DATA",
    type: "[(felt252, [u32; 8]); "+manualCases.length+"]",
    value: toCairoArray(manualCases.map(generateTestCase), 0, true)
}], "../packages/hashlock_claim_handler/tests/data/valid_manual.cairo");
