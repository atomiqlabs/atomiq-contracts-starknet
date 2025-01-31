const { mine, createChain } = require("../../utils/blockchain_utils");
const { toCairoBlockheader, toCairoStoredBlockheader } = require('../../utils/blockheaders');
const { getBlockheader } = require('../../utils/bitcoind_rpc_utils');
const crypto = require("crypto");
const BN = require("bn.js");

function shuffle(array) {
    let currentIndex = array.length;
  
    // While there remain elements to shuffle...
    while (currentIndex != 0) {
  
      // Pick a remaining element...
      let randomIndex = Math.floor(Math.random() * currentIndex);
      currentIndex--;
  
      // And swap it with the current element.
      [array[currentIndex], array[randomIndex]] = [
        array[randomIndex], array[currentIndex]];
    }

    return array;
}
const getRandomTimestamp = () => Math.floor(Math.random() * (Date.now()/1000));
const getRandomEpoch = () => Math.floor(500 * Math.random());
const getRandomnBits = () => {
    const randomBytes = crypto.randomBytes(3);
    if(randomBytes[0] >= 0x10) randomBytes[0] = 0x10;
    return "1f"+randomBytes.toString("hex");
};
const getRandomChainwork = () => new BN(crypto.randomBytes(32)).shrn(32 + Math.floor(224 * Math.random()));
const getRandomBlockheight = () => {
    const initialHeight = Math.floor(Math.random() * 1000000);
    if(initialHeight % 2016 === 2015) initialHeight++;
    return initialHeight;
};

//Utility for checking which bitcoin's epoch reached the PoW retarget bounds i.e. the target cannot adjust more than 4x upwards and downwards
async function findEpochWithPoWRetargetBounds() {
    for(let i=0;i<433;i++) {
        console.log("Checking epoch: "+i);
        const startHeight = i * 2016;
        const endHeight = startHeight + 2015;
        const startBlockheader = await getBlockheader(startHeight);
        const endBlockheader = await getBlockheader(endHeight);

        const timespan = endBlockheader.time - startBlockheader.time;
        if(timespan < 14 * 24 * 60 * 60 / 4) {
            console.log("Epoch "+i+" timespan too low, timespan: "+timespan);
        }
        if(timespan > 14 * 24 * 60 * 60 * 4) {
            console.log("Epoch "+i+" timespan too high, timespan: "+timespan);
        }
        await new Promise(resolve => setTimeout(resolve, 250));
    }
}

function generateBlockUpdate(initialBlock, nextBlock, previousBlocksTimestamps, submissionTimestamp = nextBlock.time) {
    if(previousBlocksTimestamps==null) {
        previousBlocksTimestamps = [];
        for(let i=0; i<10; i++) {
            previousBlocksTimestamps[9-i] = initialBlock.time - (600 * (i + 1));
        }
    }

    return "let BLOCKHEADER_"+initialBlock.height+": BlockHeader = "+toCairoBlockheader(initialBlock)+";\n" +
        "let BLOCKHEADER_"+nextBlock.height+": BlockHeader = "+toCairoBlockheader(nextBlock)+";\n" + 
        "let mut stored_blockheader_0: StoredBlockHeader = "+toCairoStoredBlockheader(initialBlock, initialBlock.epochstart, previousBlocksTimestamps, "BLOCKHEADER_"+initialBlock.height)+";\n" +
        "stored_blockheader_0.update_chain(BLOCKHEADER_"+nextBlock.height+", "+submissionTimestamp+");\n";
}

function generateBlockUpdateAssertion(initialBlock, nextBlock, previousBlocksTimestamps, submissionTimestamp = nextBlock.time) {
    if(previousBlocksTimestamps==null) {
        previousBlocksTimestamps = [];
        for(let i=0; i<10; i++) {
            previousBlocksTimestamps[9-i] = initialBlock.time - (600 * (i + 1));
        }
    }
    const nextPreviousBlocksTimestamps = [...previousBlocksTimestamps];
    nextPreviousBlocksTimestamps.shift();
    nextPreviousBlocksTimestamps.push(initialBlock.time);

    return "let BLOCKHEADER_"+initialBlock.height+": BlockHeader = "+toCairoBlockheader(initialBlock)+";\n" +
        "let BLOCKHEADER_"+nextBlock.height+": BlockHeader = "+toCairoBlockheader(nextBlock)+";\n" + 
        "let mut stored_blockheader_0: StoredBlockHeader = "+toCairoStoredBlockheader(initialBlock, initialBlock.epochstart, previousBlocksTimestamps, "BLOCKHEADER_"+initialBlock.height)+";\n" +
        "let stored_blockheader_1: StoredBlockHeader = "+toCairoStoredBlockheader(nextBlock, nextBlock.epochstart, nextPreviousBlocksTimestamps, "BLOCKHEADER_"+nextBlock.height)+";\n" +
        "stored_blockheader_0.update_chain(BLOCKHEADER_"+nextBlock.height+", "+submissionTimestamp+");\n" +
        "let mut serialized_0: Array<felt252> = array![];\n" +
        "stored_blockheader_0.serialize(ref serialized_0);\n" +
        "let mut serialized_1: Array<felt252> = array![];\n" +
        "stored_blockheader_1.serialize(ref serialized_1);\n" +
        "assert_eq!(serialized_0, serialized_1);\n";
}

function generateRandomValidBlockAssertion() {
    const initialTimestamp = getRandomTimestamp();
    const initialHeight = getRandomBlockheight();

    const blocksFromEpochStart = initialHeight % 2016
    const initialBlock = mine(
        crypto.randomBytes(32).toString("hex"), initialTimestamp, 
        getRandomnBits(), getRandomChainwork().toString("hex"), initialHeight-1, initialTimestamp - (blocksFromEpochStart*600)
    );
    const blocks = createChain([initialBlock], 300 + Math.floor(1200 * Math.random()), 1);

    return generateBlockUpdateAssertion(blocks[0], blocks[1]);
}

function generateRandomPoWAdjustmentBlockAssertion(avgBlockTime = 550) {
    const initialTimestamp = getRandomTimestamp();
    const epoch = getRandomEpoch();
    const initialHeight = epoch * 2016 + 2015;

    const initialBlock = mine(
        crypto.randomBytes(32).toString("hex"), initialTimestamp, 
        getRandomnBits(), getRandomChainwork().toString("hex"), initialHeight-1, initialTimestamp - (2015 * avgBlockTime)
    );
    const blocks = createChain([initialBlock], 300 + Math.floor(1200 * Math.random()), 1);

    return generateBlockUpdateAssertion(blocks[0], blocks[1]);
}

function generateRandomInvalidPoWAssertion() {
    const initialTimestamp = getRandomTimestamp();
    const initialHeight = getRandomBlockheight();

    const blocksFromEpochStart = initialHeight % 2016
    const initialBlock = mine(
        crypto.randomBytes(32).toString("hex"), initialTimestamp, 
        "1f19ffff", getRandomChainwork().toString("hex"), initialHeight-1, initialTimestamp - (blocksFromEpochStart*600)
    );
    const endBlock = mine(
        initialBlock.hash, initialBlock.time + 300 + Math.floor(1200 * Math.random()),
        initialBlock.bits, initialBlock.chainwork, initialBlock.height, initialBlock.epochstart, "1f4fffff" 
    );

    return generateBlockUpdate(initialBlock, endBlock);
}

function generateRandomInvalidnBitsAssertion() {
    const initialTimestamp = getRandomTimestamp();
    const initialHeight = getRandomBlockheight();

    const blocksFromEpochStart = initialHeight % 2016
    const initialBlock = mine(
        crypto.randomBytes(32).toString("hex"), initialTimestamp, 
        "1f19ffff", getRandomChainwork().toString("hex"), initialHeight-1, initialTimestamp - (blocksFromEpochStart*600)
    );
    const endBlock = mine(
        initialBlock.hash, initialBlock.time + 300 + Math.floor(1200 * Math.random()),
        "1f4fffff", initialBlock.chainwork, initialBlock.height, initialBlock.epochstart 
    );

    return generateBlockUpdate(initialBlock, endBlock);
}

function generateRandomInvalidnBitsDiffAdjustmentAssertion() {
    const initialTimestamp = getRandomTimestamp();
    const initialHeight = (getRandomEpoch() * 2016) + 2015;

    const blocksFromEpochStart = initialHeight % 2016
    const initialBlock = mine(
        crypto.randomBytes(32).toString("hex"), initialTimestamp, 
        "1f19ffff", getRandomChainwork().toString("hex"), initialHeight-1, initialTimestamp - (blocksFromEpochStart*600)
    );
    const endBlock = mine(
        initialBlock.hash, initialBlock.time + 300 + Math.floor(1200 * Math.random()),
        "1f4fffff", initialBlock.chainwork, initialBlock.height, initialBlock.epochstart 
    );

    return generateBlockUpdate(initialBlock, endBlock);
}

function generateRandomInvalidPrevBlockhashAssertion() {
    const initialTimestamp = getRandomTimestamp();
    const initialHeight = getRandomBlockheight();

    const blocksFromEpochStart = initialHeight % 2016;
    const initialBlock = mine(
        crypto.randomBytes(32).toString("hex"), initialTimestamp, 
        getRandomnBits(), getRandomChainwork().toString("hex"), initialHeight-1, initialTimestamp - (blocksFromEpochStart*600)
    );
    const endBlock = mine(
        crypto.randomBytes(32).toString("hex"), initialBlock.time + 300 + Math.floor(1200 * Math.random()),
        initialBlock.bits, initialBlock.chainwork, initialBlock.height, initialBlock.epochstart 
    );

    return generateBlockUpdate(initialBlock, endBlock);
}

function generateRandomValidTimestampMedianAssertion() {
    const initialTimestamp = getRandomTimestamp();
    const initialHeight = getRandomBlockheight();

    const previousBlockTimestamps = [];
    previousBlockTimestamps[9] = initialTimestamp - (300 + Math.floor(Math.random() * 900));
    for(let i=8;i>=0;i--) {
        previousBlockTimestamps[i] = previousBlockTimestamps[i+1] - (300 + Math.floor(Math.random() * 900));
    }
    const medianTimestamp = previousBlockTimestamps[5];

    const blocksFromEpochStart = initialHeight % 2016;
    const initialBlock = mine(
        crypto.randomBytes(32).toString("hex"), initialTimestamp, 
        getRandomnBits(), getRandomChainwork().toString("hex"), initialHeight-1, initialTimestamp - (blocksFromEpochStart*600)
    );
    const endBlock = mine(
        initialBlock.hash, medianTimestamp + Math.floor(Math.random() * 200),
        initialBlock.bits, initialBlock.chainwork, initialBlock.height, initialBlock.epochstart 
    );

    return generateBlockUpdate(initialBlock, endBlock, shuffle(previousBlockTimestamps));
}

function generateRandomInvalidTimestampMedianAssertion() {
    const initialTimestamp = getRandomTimestamp();
    const initialHeight = getRandomBlockheight();

    const previousBlockTimestamps = [];
    previousBlockTimestamps[9] = initialTimestamp - (300 + Math.floor(Math.random() * 900));
    for(let i=8;i>=0;i--) {
        previousBlockTimestamps[i] = previousBlockTimestamps[i+1] - (300 + Math.floor(Math.random() * 900));
    }
    const medianTimestamp = previousBlockTimestamps[5];

    const blocksFromEpochStart = initialHeight % 2016;
    const initialBlock = mine(
        crypto.randomBytes(32).toString("hex"), initialTimestamp, 
        getRandomnBits(), getRandomChainwork().toString("hex"), initialHeight-1, initialTimestamp - (blocksFromEpochStart*600)
    );
    const endBlock = mine(
        initialBlock.hash, medianTimestamp - Math.floor(Math.random() * 200),
        initialBlock.bits, initialBlock.chainwork, initialBlock.height, initialBlock.epochstart 
    );

    return generateBlockUpdate(initialBlock, endBlock, shuffle(previousBlockTimestamps));
}

async function generateRealValidBlockAssertion(initHeight) {
    const startBlockheader = await getBlockheader(initHeight);
    const endBlockheader = await getBlockheader(initHeight+1);

    const epochStartHeight = Math.floor(initHeight / 2016) * 2016;
    let epochStartBlock = await getBlockheader(epochStartHeight);
    if(initHeight % 2016 == 2015) {
        startBlockheader.epochstart = epochStartBlock.time;
        endBlockheader.epochstart = endBlockheader.time;
    } else {
        startBlockheader.epochstart = epochStartBlock.time;
        endBlockheader.epochstart = epochStartBlock.time;
    }

    return generateBlockUpdateAssertion(startBlockheader, endBlockheader);
}

const MAX_ALLOWED_RETARGET_EPOCH = 33;

async function main() {
    console.log("\n// Valid random block update\n");
    console.log(generateRandomValidBlockAssertion());
    console.log("\n// Valid random block update on PoW readjustment\n");
    console.log(generateRandomPoWAdjustmentBlockAssertion());
    console.log("\n// Valid random block update on PoW readjustment, too fast\n");
    console.log(generateRandomPoWAdjustmentBlockAssertion(100));
    console.log("\n// Valid random block update on PoW readjustment, too slow\n");
    console.log(generateRandomPoWAdjustmentBlockAssertion(3000));
    console.log("\n// Valid random block update, with timestamp larger than median of last 11 blocks\n");
    console.log(generateRandomValidTimestampMedianAssertion());

    console.log("\n// Invalid random block update, due to low PoW\n");
    console.log(generateRandomInvalidPoWAssertion());
    console.log("\n// Invalid random block update, due to wrong nBits\n");
    console.log(generateRandomInvalidnBitsAssertion());
    console.log("\n// Invalid random block update, due to wrong nBits during difficulty retarget\n");
    console.log(generateRandomInvalidnBitsDiffAdjustmentAssertion());
    console.log("\n// Invalid random block update, due to wrong previous blockhash\n");
    console.log(generateRandomInvalidPrevBlockhashAssertion());
    console.log("\n// Invalid random block update, due to timestamp not being larger than median of last 11 blocks\n");
    console.log(generateRandomInvalidTimestampMedianAssertion());

    console.log("\n// Valid real block update\n");
    console.log(await generateRealValidBlockAssertion(Math.floor(Math.random() * 840000)));
    console.log("\n// Valid real block update on PoW readjustment\n");
    console.log(await generateRealValidBlockAssertion((Math.floor(Math.random() * 433) * 2016) + 2015));
    console.log("\n// Valid real block update on PoW readjustment, too fast\n");
    console.log(await generateRealValidBlockAssertion((MAX_ALLOWED_RETARGET_EPOCH * 2016) + 2015));
}

main();
