/**
 * Script for generating blockheaders for:
 * - Submit main chain blockheaders with difficulty adjustment
 */

const {createChain, mine} = require("../utils/blockchain_utils");
const { exportToCairoFile } = require('../utils/cairo_structs');

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, "1f7fffff");

const cannonicalChain = createChain(
    [genesis],
    600,
    2030
);

exportToCairoFile(cannonicalChain, 2000, 2030, 1700000000, "./tests/data/main_chain_diff_adjustment.cairo");
