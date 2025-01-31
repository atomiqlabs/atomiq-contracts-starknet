
const { mine } = require("../../utils/blockchain_utils");
const { exportChainToCairoFile } = require('../../utils/blockheaders');

const initialnBits = "1f00ffff";
const lowernBits = "1f7fffff";

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, initialnBits);
const invalidnBitsHeader = mine(genesis.hash, genesis.time + 600, lowernBits, genesis.chainwork, genesis.height, genesis.epochstart);

exportChainToCairoFile([genesis, invalidnBitsHeader], 0, 1, 1700000000, "../packages/btc_relay/tests/data/block_invalid_nbits.cairo");
