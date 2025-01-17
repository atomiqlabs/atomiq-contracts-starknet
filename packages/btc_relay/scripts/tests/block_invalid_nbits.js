const { mine, mineAfterBlock, nbitsToTarget } = require("../utils/blockchain_utils");
const { exportToCairoFile } = require('../utils/cairo_structs');
const BN = require("bn.js");

const initialnBits = "1f00ffff";
const lowernBits = "1f7fffff";

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, initialnBits);
const invalidnBitsHeader = mine(genesis.hash, genesis.time + 600, lowernBits, genesis.chainwork, genesis.height, genesis.epochstart);

exportToCairoFile([genesis, invalidnBitsHeader], 0, 1, 1700000000, "./tests/data/block_invalid_nbits.cairo");
