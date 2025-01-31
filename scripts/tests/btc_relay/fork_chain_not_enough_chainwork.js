
const {createChain, mine} = require("../../utils/blockchain_utils");
const { exportChainToCairoFile } = require('../../utils/blockheaders');
const fs = require("fs");

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, "1f7fffff");

//Create a canonical chain of 2201 blocks mined at usual speed
//Total timespan = 600 * 2015 = 1209000
const cannonicalChain = createChain(
    [genesis],
    600,
    2015 + 8
);

//Create fork at blockheight 1900, i.e. block 1901 is the first different block
//The fork is mined extremely slowly compared to cannonical chain
//Total timespan = 600 * 1900 + 2400 * 115 = 1416000
//The difficulty should therefore be ~14% lower here, so we need a chain of 10 blocks,
// to overwrite a cannonical chain with 8 blocks
//So if we mine just 9 blocks on the fork, it should not be enough to overrun
// the canonical chain with 8 blocks, even though fork is longer
const failedForkChain = createChain(
    cannonicalChain.slice(0, 1901),
    2400,
    116+9
);

if(!fs.existsSync("../packages/btc_relay/tests/data/fork_chain_not_enough_chainwork")) fs.mkdirSync("../packages/btc_relay/tests/data/fork_chain_not_enough_chainwork");
exportChainToCairoFile(cannonicalChain, 1900, 2015 + 8, 1700000000, "../packages/btc_relay/tests/data/fork_chain_not_enough_chainwork/main_chain.cairo");
exportChainToCairoFile(failedForkChain, 1900, 2015 + 9, 1700000000, "../packages/btc_relay/tests/data/fork_chain_not_enough_chainwork/fork_chain.cairo");

fs.writeFileSync("../packages/btc_relay/tests/data/fork_chain_not_enough_chainwork.cairo", "pub mod fork_chain;\npub mod main_chain;\n");
