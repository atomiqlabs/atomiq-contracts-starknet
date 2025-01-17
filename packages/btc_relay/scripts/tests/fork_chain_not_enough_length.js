const {createChain, mine} = require("../utils/blockchain_utils");
const { exportToCairoFile } = require('../utils/cairo_structs');
const fs = require("fs");

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, "1f7fffff");

//Create canonical chain of 20 blocks
const cannonicalChain = createChain(
    [genesis],
    600,
    20
);

//Create fork at blockheight 9, i.e. block 10 is the first different block
const failedForkChain = createChain(
    cannonicalChain.slice(0, 10),
    600,
    5
);

if(!fs.existsSync("./tests/data/fork_chain_not_enough_length")) fs.mkdirSync("./tests/data/fork_chain_not_enough_length");
exportToCairoFile(cannonicalChain, 0, 20, 1700000000, "./tests/data/fork_chain_not_enough_length/main_chain.cairo");
exportToCairoFile(failedForkChain, 9, 14, 1700000000, "./tests/data/fork_chain_not_enough_length/fork_chain.cairo");

fs.writeFileSync("./tests/data/fork_chain_not_enough_length.cairo", "pub mod fork_chain;\npub mod main_chain;\n");
