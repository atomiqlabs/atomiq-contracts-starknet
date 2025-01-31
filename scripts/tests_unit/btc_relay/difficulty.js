const {nbitsToTarget, getDifficulty} = require("../../utils/blockchain_utils");
const {getBlockheader} = require("../../utils/bitcoind_rpc_utils");
const BN = require("bn.js");
const crypto = require("crypto");

async function generateComputeNewTargetAssertion(epoch) {
    const epochStartHeight = epoch * 2016;
    const epochEndHeight = epochStartHeight + 2015;
    const nextEpochHeight = epochEndHeight + 1;

    const epochStart = await getBlockheader(epochStartHeight);
    const epochEnd = await getBlockheader(epochEndHeight);
    const nextEpoch = await getBlockheader(nextEpochHeight);

    const timestampStart = epochStart.time;
    const timestampEnd = epochEnd.time;

    const epochTarget = nbitsToTarget(Buffer.from(epochStart.bits, "hex"));
    
    return "//Epoch "+epoch+" ("+epochStartHeight+"-"+epochEndHeight+")\n" +
        "let nbits: nbits = 0x"+Buffer.from(epochStart.bits, "hex").reverse().toString("hex")+";\n" + 
        "let target: u256 = 0x"+epochTarget.toBuffer("be", 32).toString("hex")+";\n" +
        "assert_eq!(nbits.to_target(), target);\n" +
        "let next_target: u256 = compute_new_target_release("+timestampEnd+", "+timestampStart+", target);\n" + 
        "let next_nbits: nbits = 0x"+Buffer.from(nextEpoch.bits, "hex").reverse().toString("hex")+";\n" + 
        "assert_eq!(next_target.to_nbits(), next_nbits);\n";
}

async function generateGetChainworkAssertion(height) {
    const initial = await getBlockheader(height - 1);
    const next = await getBlockheader(height);

    const initialChainwork = new BN(initial.chainwork, "hex");
    const nextChainwork = new BN(next.chainwork, "hex");
    const chainwork = nextChainwork.sub(initialChainwork);

    const nextBlockTarget = nbitsToTarget(Buffer.from(next.bits, "hex"));
    
    return "//Blockheight "+height+"\n" +
        "let nbits: nbits = 0x"+Buffer.from(next.bits, "hex").reverse().toString("hex")+";\n" + 
        "let target: u256 = 0x"+nextBlockTarget.toBuffer("be", 32).toString("hex")+";\n" +
        "assert_eq!(nbits.to_target(), target);\n" +
        "assert_eq!(get_chainwork(target), 0x"+chainwork.toBuffer("be", 32).toString("hex")+");\n";
}

function generateGetChainworkRandomAssertion() {
    const target = new BN(crypto.randomBytes(32)).shrn(Math.floor(224 * Math.random()));
    const chainwork = getDifficulty(target);
    
    return "assert_eq!(get_chainwork(0x"+target.toBuffer("be", 32).toString("hex")+"), 0x"+chainwork.toBuffer("be", 32).toString("hex")+");";
}

const numTests = 10;

async function main() {
    const maxBlockheight = 879768;
    const maxEpoch = Math.floor(maxBlockheight / 2016) - 1;

    console.log("\n// Random chainwork test cases \n");
    for(let i=0;i<numTests;i++) {
        console.log(generateGetChainworkRandomAssertion());
    }

    console.log("\n// Real get chainwork test cases \n");
    for(let i=0;i<numTests;i++) {
        const height = Math.floor((maxBlockheight - 1) * Math.random()) + 1;
        console.log(await generateGetChainworkAssertion(height));
        await new Promise(resolve => setTimeout(resolve, 250));
    }

    console.log("\n// Real difficulty adjustment test cases \n");
    for(let i=0;i<numTests;i++) {
        const epoch = Math.floor(maxEpoch * Math.random());
        console.log(await generateComputeNewTargetAssertion(epoch));
        await new Promise(resolve => setTimeout(resolve, 250));
    }
}

main();
