const {getBlockheader} = require("../../utils/bitcoind_rpc_utils");
const {toCairoBlockheader} = require("../../utils/blockheaders");
const {toU32Array, toCairoArray} = require("../../utils/cairo_structs");
const crypto = require("crypto");

function getRandomBlockheader() {
    const blockheader = crypto.randomBytes(80);

    return {
        height: 0,
        hash: crypto.createHash("sha256").update(crypto.createHash("sha256").update(blockheader).digest()).digest().reverse().toString("hex"),
        version: blockheader.readUInt32LE(0),
        previousblockhash: blockheader.subarray(4, 36).reverse().toString("hex"),
        merkleroot: blockheader.subarray(36, 68).reverse().toString("hex"),
        time: blockheader.readUInt32LE(68),
        bits: blockheader.readUInt32LE(72).toString(16),
        nonce: blockheader.readUInt32LE(76)
    }
}

function getBlockheaderHashAssertion(blockheader) {
    return "//Blockheight: "+blockheader.height+"\n" +
        "let blockheader: BlockHeader = "+toCairoBlockheader(blockheader)+";\n" + 
        "assert_eq!(blockheader.dbl_sha256_hash(), "+toCairoArray(toU32Array(Buffer.from(blockheader.hash, "hex")))+");\n";
}

async function generateRealBlockAssertion(height) {
    const blockheader = await getBlockheader(height);
    return getBlockheaderHashAssertion(blockheader);
} 

const numTests = 10;

async function main() {
    console.log("\n// Random blockheaders test cases\n")
    for(let i=0;i<numTests;i++) {
        console.log(getBlockheaderHashAssertion(getRandomBlockheader()));
    }

    const maxBlockheight = 879768;
    console.log("\n// Real blockheaders test cases\n")
    for(let i=0;i<numTests;i++) {
        const height = Math.floor(Math.random() * maxBlockheight);
        console.log(await generateRealBlockAssertion(height));
        await new Promise(resolve => setTimeout(resolve, 250));
    }
}

main();
