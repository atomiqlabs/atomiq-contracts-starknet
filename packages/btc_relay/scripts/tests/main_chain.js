/**
 * Script for generating blockheaders for:
 * - Submit main chain blockheaders
 */

const {createChain, mine} = require("../utils/blockchain_utils");
const { exportToCairoFile } = require('../utils/cairo_structs');

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, "1f7fffff");

const cannonicalChain = createChain(
    [genesis],
    600,
    20
);

exportToCairoFile(cannonicalChain, 0, 20, 1700000000, "./tests/data/main_chain.cairo");
