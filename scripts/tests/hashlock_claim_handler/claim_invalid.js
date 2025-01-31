const starknet = require("micro-starknet");
const crypto = require("crypto");
const { exportToCairoFile, toU32Array, toCairoTuple, toCairoArray } = require("../../utils/cairo_structs");

function generateTestCaseWrongSecret(secret) {
    const secret2 = crypto.randomBytes(32);
    const hash = toU32Array(crypto.createHash("sha256").update(secret2).digest());
    const result = starknet.poseidonHashMany(hash);
    return toCairoTuple([result, toU32Array(secret)]);
}

function generateTestCaseWrongHash(secret) {
    const hash2 = toU32Array(crypto.createHash("sha256").update(crypto.randomBytes(32)).digest());
    const result = starknet.poseidonHashMany(hash2);
    return toCairoTuple([result, toU32Array(secret)]);
}

function generateRandomTestCaseWrongSecret() {
    return generateTestCaseWrongSecret(crypto.randomBytes(32));
}

function generateRandomTestCaseWrongHash() {
    return generateTestCaseWrongHash(crypto.randomBytes(32));
}

const numTests = 10;

const testsWrongSecret = [];
for(let i=0;i<numTests;i++) {
    testsWrongSecret.push(generateRandomTestCaseWrongSecret());
}
exportToCairoFile([{
    name: "TEST_DATA",
    type: "[(felt252, [u32; 8]); "+testsWrongSecret.length+"]",
    value: toCairoArray(testsWrongSecret, 0, true)
}], "../packages/hashlock_claim_handler/tests/data/invalid_wrong_secret.cairo");

const testsWrongHash = [];
for(let i=0;i<numTests;i++) {
    testsWrongHash.push(generateRandomTestCaseWrongHash());
}
exportToCairoFile([{
    name: "TEST_DATA",
    type: "[(felt252, [u32; 8]); "+testsWrongHash.length+"]",
    value: toCairoArray(testsWrongHash, 0, true)
}], "../packages/hashlock_claim_handler/tests/data/invalid_wrong_hash.cairo");
