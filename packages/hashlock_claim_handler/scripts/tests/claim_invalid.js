const starknet = require("micro-starknet");
const crypto = require("crypto");
const { exportToCairoFile, toU32Array } = require("../utils/cairo_structs");

function generateTestCaseWrongSecret(secret) {
    const secret2 = crypto.randomBytes(32);
    const hash = toU32Array(crypto.createHash("sha256").update(secret2).digest());
    const result = starknet.poseidonHashMany(hash);
    return [result, secret];
}

function generateTestCaseWrongHash(secret) {
    const hash2 = toU32Array(crypto.createHash("sha256").update(crypto.randomBytes(32)).digest());
    const result = starknet.poseidonHashMany(hash2);
    return [result, secret];
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
exportToCairoFile(testsWrongSecret, "./tests/data/invalid_wrong_secret.cairo");

const testsWrongHash = [];
for(let i=0;i<numTests;i++) {
    testsWrongHash.push(generateRandomTestCaseWrongHash());
}
exportToCairoFile(testsWrongHash, "./tests/data/invalid_wrong_hash.cairo");
