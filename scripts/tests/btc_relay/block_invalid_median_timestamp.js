
const { mine, createChain, mineAfterBlock } = require("../../utils/blockchain_utils");
const { exportChainToCairoFile } = require('../../utils/blockheaders');

const initialnBits = "1f7fffff";

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, initialnBits);
const cannonicalChain = createChain(
    [genesis],
    600,
    10
);

const invalidMedianTimestampHeader = mineAfterBlock(cannonicalChain[cannonicalChain.length - 1], 1500000000 + (5*600));
cannonicalChain.push(invalidMedianTimestampHeader);

exportChainToCairoFile(cannonicalChain, 10, 11, 1700000000, "../packages/btc_relay/tests/data/block_invalid_median_timestamp.cairo");
