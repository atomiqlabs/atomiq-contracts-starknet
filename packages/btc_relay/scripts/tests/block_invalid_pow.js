const { mine, mineAfterBlock, nbitsToTarget } = require("../utils/blockchain_utils");
const { exportToCairoFile } = require('../utils/cairo_structs');
const BN = require("bn.js");

const initialnBits = "1f00ffff";
const lowernBits = "1f7fffff";

const genesis = mine(Buffer.alloc(32).toString("hex"), 1500000000, initialnBits);
const validPoWHeader = mineAfterBlock(genesis, genesis.time + 600);

let invalidPoWHeader;
while(true) {
    //Mine an invalid header with higher target - lower difficulty
    invalidPoWHeader = mine(genesis.hash, genesis.time + 600, lowernBits);

    //There is still a slight probability that we mined a block with a low enough hash
    if(new BN(invalidPoWHeader.hash, 16).lt(nbitsToTarget(Buffer.from(initialnBits, "hex")))) {
        console.log("Not a valid hash, retrying...");
        continue;
    }

    //Set nBits and chainwork as if it were to be mined genuinely
    invalidPoWHeader.chainwork = validPoWHeader.chainwork;
    invalidPoWHeader.bits = validPoWHeader.bits;
    break;
}

exportToCairoFile([genesis, invalidPoWHeader], 0, 1, 1700000000, "./tests/data/block_invalid_pow.cairo");
