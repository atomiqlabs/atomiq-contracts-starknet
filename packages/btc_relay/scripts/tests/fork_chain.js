const {createChain, mine} = require("../utils/blockchain_utils");
const { exportToCairoFile } = require('../utils/cairo_structs');

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, "1f7fffff");

//Create canonical chain of 20 blocks
const cannonicalChain = createChain(
    [genesis],
    600,
    20
);

//Create fork at blockheight 4, i.e. block 5 is the first different block
const successfulForkChain = createChain(
    cannonicalChain.slice(0, 5),
    600,
    20
);

exportToCairoFile(cannonicalChain, 0, 20, 1700000000, "./tests/data/fork_chain/main_chain.cairo");
exportToCairoFile(successfulForkChain, 4, 24, 1700000000, "./tests/data/fork_chain/fork_chain.cairo");
