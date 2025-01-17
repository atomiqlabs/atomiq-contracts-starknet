const { mine } = require("../utils/blockchain_utils");
const { exportToCairoFile } = require('../utils/cairo_structs');
const BN = require("bn.js");
const crypto = require("crypto");

const initialnBits = "1f7fffff";

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, initialnBits);
const invalidPrevBlockHeader = mine(crypto.randomBytes(32).toString("hex"), genesis.time + 600, initialnBits, genesis.chainwork, genesis.height, genesis.epochstart);

exportToCairoFile([genesis, invalidPrevBlockHeader], 0, 1, 1700000000, "./tests/data/block_invalid_prev_block.cairo");
