
const { mine} = require("../../utils/blockchain_utils");
const { exportChainToCairoFile } = require('../../utils/blockheaders');
const BN = require("bn.js");
const crypto = require("crypto");

const initialnBits = "1f7fffff";

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, initialnBits);
const invalidPrevBlockHeader = mine(crypto.randomBytes(32).toString("hex"), genesis.time + 600, initialnBits, genesis.chainwork, genesis.height, genesis.epochstart);

exportChainToCairoFile([genesis, invalidPrevBlockHeader], 0, 1, 1700000000, "../packages/btc_relay/tests/data/block_invalid_prev_block.cairo");
