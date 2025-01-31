const BN = require("bn.js");
const crypto = require("crypto");
const { exportToCairoFile, toCairoTuple, toCairoArray } = require("../../utils/cairo_structs");

function generateRandomTestCase() {
    const expiryTimestamp = BN.min(new BN(crypto.randomBytes(8)), new BN("FFFFFFFFFFFFFFFE", 16));
    const delta = new BN(crypto.randomBytes(7));
    const currentTimestamp = BN.min(expiryTimestamp.add(delta), new BN("FFFFFFFFFFFFFFFF", 16));
    return toCairoTuple([expiryTimestamp, currentTimestamp]);
}

const numTests = 10;

const tests = [];
for(let i=0;i<numTests;i++) {
    tests.push(generateRandomTestCase());
}

exportToCairoFile([{
    name: "TEST_DATA",
    type: "[(felt252, u64); "+tests.length+"]",
    value: toCairoArray(tests, 0, true)
}], "../packages/timelock_refund_handler/tests/data/valid.cairo");
