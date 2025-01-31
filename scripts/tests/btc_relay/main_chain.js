/**
 * Script for generating blockheaders for:
 * - Submit main chain blockheaders
 */

const {createChain, mine} = require("../../utils/blockchain_utils");
const { exportChainToCairoFile } = require('../../utils/blockheaders');

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, "1f7fffff");

const cannonicalChain = createChain(
    [genesis],
    600,
    20
);

exportChainToCairoFile(cannonicalChain, 0, 20, 1700000000, "../packages/btc_relay/tests/data/main_chain.cairo");
