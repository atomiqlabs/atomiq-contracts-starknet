
const { mine, mineAfterBlock } = require("../../utils/blockchain_utils");
const { exportChainToCairoFile } = require('../../utils/blockheaders');

const initialnBits = "1f7fffff";

const MAXIMUM_ALLOWED_FUTURE_DELTA = 4 * 60 * 60;

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, initialnBits);
const invalidTimestampHeader = mineAfterBlock(genesis, 1500000000 + MAXIMUM_ALLOWED_FUTURE_DELTA + 600);

exportChainToCairoFile([genesis, invalidTimestampHeader], 0, 1, 1500000000, "../packages/btc_relay/tests/data/block_invalid_future_timestamp.cairo");
