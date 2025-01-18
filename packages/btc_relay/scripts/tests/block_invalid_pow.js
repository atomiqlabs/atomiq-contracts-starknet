const { mine, nbitsToTarget } = require("../utils/blockchain_utils");
const { exportToCairoFile } = require('../utils/cairo_structs');
const BN = require("bn.js");

const initialnBits = "1f00ffff";
const lowernBits = "1f7fffff";

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, initialnBits);

let invalidPoWHeader;
while(true) {
    //Mine an invalid header with higher target - lower difficulty
    invalidPoWHeader = mine(genesis.hash, genesis.time + 600, initialnBits, genesis.chainwork, genesis.height, genesis.epochstart, lowernBits);

    //There is still a slight probability that we mined a block with a low enough hash
    if(new BN(invalidPoWHeader.hash, 16).gte(nbitsToTarget(Buffer.from(initialnBits, "hex")))) {
        break;
    }

    console.log("Not a valid hash, retrying...");
}

exportToCairoFile([genesis, invalidPoWHeader], 0, 1, 1700000000, "./tests/data/block_invalid_pow.cairo");
