const BN = require('bn.js');
const crypto = require("crypto");

const TIMESPAN_TARGET = new BN(14 * 24 * 60 * 60);
const TIMESPAN_TARGET_DIV4 = TIMESPAN_TARGET.div(new BN(4));
const TIMESPAN_TARGET_MUL4 = TIMESPAN_TARGET.mul(new BN(4));

function nbitsToTarget(nbitsBuff) {
    const result = Buffer.alloc(32);
    for(let i = 0; i<3; i++) {
        result[34-nbitsBuff[0]-i] = nbitsBuff[3-i];
    }
    return new BN(result);
}

function targetTonBits(target) {
    const targetBuff = target.toBuffer();
    const nbitsBuff = Buffer.alloc(4);

    let firstNonZeroIndex = 0;
    for(let i=0;i<targetBuff.length;i++) {
        if(targetBuff[i] !== 0) {
            firstNonZeroIndex = i;
            break;
        }
    }

    if((targetBuff[firstNonZeroIndex] & 0x80) === 0x80) firstNonZeroIndex--;

    nbitsBuff[1] = targetBuff[firstNonZeroIndex];
    nbitsBuff[2] = targetBuff[firstNonZeroIndex+1];
    nbitsBuff[3] = targetBuff[firstNonZeroIndex+2];

    nbitsBuff[0] = targetBuff.length-firstNonZeroIndex;

    return nbitsBuff;
}

function computeNewTarget(target, epochStartTimestamp, prevBlockTimestamp) {
    let timespan = prevBlockTimestamp.sub(epochStartTimestamp);

    //Difficulty increase/decrease multiples are clamped between 0.25 (-75%) and 4 (+300%)
    if(timespan.lt(TIMESPAN_TARGET_DIV4)) {
        timespan = TIMESPAN_TARGET_DIV4;
    }
    if(timespan.gt(TIMESPAN_TARGET_MUL4)) {
        timespan = TIMESPAN_TARGET_MUL4;
    }

    return target.mul(timespan).div(TIMESPAN_TARGET);
}

function getDifficulty(target) {
    return target.notn(256).div(target.add(new BN(1))).add(new BN(1));
}

function mine(previousBlockhash, timestampNumber, nbits, previousChainwork = "0", previousBlockheight = -1, epochStartTimestamp, targetnBits = nbits, merkleRoot = crypto.randomBytes(32)) {
    const timestamp = new BN(timestampNumber);
    const nbitsBuffer = Buffer.from(nbits, "hex");
    const realTarget = nbitsToTarget(nbitsBuffer);
    const target = nbitsToTarget(Buffer.from(targetnBits, "hex"));

    const previousChainworkBN = new BN(previousChainwork, 16);

    const blockheaderBuffer = Buffer.concat([
        Buffer.alloc(4),
        Buffer.from(previousBlockhash, "hex").reverse(),
        merkleRoot,
        timestamp.toBuffer("le", 4),
        Buffer.from(nbitsBuffer).reverse(),
        Buffer.alloc(4)
    ]);

    let hash;
    let found = false;
    for(let e=0;e<Math.pow(2, 32);e++) {
        blockheaderBuffer.writeUint32BE(e, 0);
        for(let i=0;i<Math.pow(2, 32);i++) {
            blockheaderBuffer.writeUInt32BE(i, 76);
            hash = crypto.createHash("sha256").update(crypto.createHash("sha256").update(blockheaderBuffer).digest()).digest();
            const hashBN = new BN(hash, 16, "le");
            if(hashBN.lt(target)) {
                found = true;
                break;
            }
        }
        if(found) break;
    }
    // console.log("blockheader: ", blockheaderBuffer.toString("hex"));

    const height = previousBlockheight+1;

    return {
        hash: hash.reverse().toString("hex"),
        version: 0,
        previousblockhash: previousBlockhash,
        merkleroot: blockheaderBuffer.slice(36, 36+32).reverse().toString("hex"),
        time: timestampNumber,
        bits: nbitsBuffer.toString("hex"),
        nonce: blockheaderBuffer.readUInt32LE(76),
        chainwork: previousChainworkBN.add(getDifficulty(realTarget)).toString("hex").padStart(64, "0"),
        height,
        epochstart: height % 2016 === 0 ? timestampNumber : epochStartTimestamp
    };
}

function mineAfterBlock(previousBlock, timestampNumber) {
    return mine(previousBlock.hash, timestampNumber, previousBlock.bits, previousBlock.chainwork, previousBlock.height, previousBlock.epochstart);
}

function createChain(blocks, deltaTimestamp, length) {
    let startingBlock = blocks[blocks.length-1];
    let timestamp = startingBlock.time;

    for(let i=0;i<length;i++) {
        timestamp += deltaTimestamp;
        if(startingBlock.height % 2016 === 2015) {
            const oldTarget = nbitsToTarget(Buffer.from(startingBlock.bits, "hex"));
            const newTarget = computeNewTarget(oldTarget, new BN(startingBlock.epochstart), new BN(startingBlock.time));
            const newnBits = targetTonBits(newTarget);
            startingBlock = mine(startingBlock.hash, timestamp, newnBits, startingBlock.chainwork, startingBlock.height)
        } else {
            startingBlock = mineAfterBlock(startingBlock, timestamp);
        }

        blocks.push(startingBlock);
    }

    return blocks;
}

module.exports = {
    createChain,
    mine,
    mineAfterBlock,
    nbitsToTarget,
    targetTonBits,
    computeNewTarget,
    getDifficulty
};