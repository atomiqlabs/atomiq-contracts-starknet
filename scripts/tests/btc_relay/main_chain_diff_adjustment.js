/**
 * Script for generating blockheaders for:
 * - Submit main chain blockheaders with difficulty adjustment
 */

const {createChain, mine} = require("../../utils/blockchain_utils");
const { exportChainToCairoFile } = require('../../utils/blockheaders');

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, "1f7fffff");

const cannonicalChain = createChain(
    [genesis],
    600,
    2030
);

exportChainToCairoFile(cannonicalChain, 2000, 2030, 1700000000, "../packages/btc_relay/tests/data/main_chain_diff_adjustment.cairo");
