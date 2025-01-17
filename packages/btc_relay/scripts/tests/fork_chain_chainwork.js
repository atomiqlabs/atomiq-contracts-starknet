const {createChain, mine} = require("../utils/blockchain_utils");
const { exportToCairoFile } = require('../utils/cairo_structs');

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, "1f7fffff");

//Create a canonical chain of 2201 blocks mined at usual speed
//Total timespan = 600 * 2015 = 1209000
const cannonicalChain = createChain(
    [genesis],
    600,
    2015 + 20
);

//Create fork at blockheight 1900, i.e. block 1901 is the first different block
//The fork is mined extremely fast compared to cannonical chain
//Total timestpan = 600 * 1900 + 1 * 115 = 1140115
//The difficulty should be ~5% higher here, so we can ovewrite a chain of 20 blocks, with 19 blocks
const successfulForkChain = createChain(
    cannonicalChain.slice(0, 1901),
    1,
    116+19
);

exportToCairoFile(cannonicalChain, 1900, 2015 + 20, 1700000000, "./tests/data/fork_chain_chainwork/main_chain.cairo");
exportToCairoFile(successfulForkChain, 1900, 2015 + 19, 1700000000, "./tests/data/fork_chain_chainwork/fork_chain.cairo");
