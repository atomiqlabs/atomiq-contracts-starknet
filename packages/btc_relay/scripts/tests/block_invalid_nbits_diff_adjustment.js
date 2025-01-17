
const {createChain, mine} = require("../utils/blockchain_utils");
const { exportToCairoFile } = require('../utils/cairo_structs');

const initialnBits = "1f6fffff";
const lowernBits = "1f7fffff";

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, initialnBits);
const cannonicalChain = createChain(
    [genesis],
    600,
    2015
);

const lastBlock = cannonicalChain[cannonicalChain.length - 1];

const invalidnBitsHeader = mine(lastBlock.hash, lastBlock.time + 600, lowernBits, lastBlock.chainwork, lastBlock.height, lastBlock.epochstart);

cannonicalChain.push(invalidnBitsHeader);

exportToCairoFile(cannonicalChain, 2015, 2016, 1700000000, "./tests/data/block_invalid_nbits_diff_adjustment.cairo");
