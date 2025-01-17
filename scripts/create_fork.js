const {createChain, mine} = require("./utils/blockchain_utils");
const { exportToCairoFile } = require('./utils/cairo_structs');

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, "1f7fffff");

const cannonicalChain = createChain(
    [genesis],
    600,
    20
);

const successfulForkChain = createChain(
    cannonicalChain.slice(0, 15),
    600,
    20
);

exportToCairoFile(cannonicalChain, 0, 20, 1700000000, "../packages/btc_relay/tests/data/mock_main_chain.cairo");
exportToCairoFile(successfulForkChain, 14, 24, 1700000000, "../packages/btc_relay/tests/data/mock_fork_chain.cairo");

console.log("Done!");
