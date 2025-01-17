const { mine, mineAfterBlock, createChain } = require("../utils/blockchain_utils");
const { exportToCairoFile } = require('../utils/cairo_structs');
const BN = require("bn.js");

const initialnBits = "1f7fffff";

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, initialnBits);
const cannonicalChain = createChain(
    [genesis],
    600,
    10
);

const invalidMedianTimestampHeader = mineAfterBlock(cannonicalChain[cannonicalChain.length - 1], 1500000000 + (5*600));
cannonicalChain.push(invalidMedianTimestampHeader);

exportToCairoFile(cannonicalChain, 10, 11, 1700000000, "./tests/data/block_invalid_median_timestamp.cairo");
