const {getBlockWithTransactions} = require("../../utils/bitcoind_rpc_utils");
const {getMerkleProof} = require("../../utils/mempool_utils");
const {toCairoTuple, toU32Array, toCairoSpan} = require("../../utils/cairo_structs");
const {generateRoot} = require("../../utils/merkle_tree");
const crypto = require("crypto");

const getRandomBlockheight = () => Math.floor(Math.random() * 840000);

function getTestCase(root, txId, proof, position) {
    return "let (root, txId, proof, position) = "+
        toCairoTuple([
            toU32Array(Buffer.from(root, "hex").reverse()), 
            toU32Array(Buffer.from(txId, "hex").reverse()), 
            toCairoSpan(proof.map(e => toU32Array(Buffer.from(e, "hex").reverse())), 4, true), 
            position
        ], 0, true)+";\n"+
        "verify(root, txId, proof, position);\n";
}

async function getRealTestCase(txId, root) {
    const merkleProof = await getMerkleProof(txId);
    return getTestCase(root, txId, merkleProof.merkle, merkleProof.pos);
}

async function getRealRandomTestCase() {
    const height = getRandomBlockheight();
    const block = await getBlockWithTransactions(height);
    const txIndex = Math.floor(Math.random() * block.tx.length);
    const txId = block.tx[txIndex];
    return "// Block height: "+height+" Position: "+txIndex+" txId: "+txId+"\n" + 
        (await getRealTestCase(txId, block.merkleroot));
}

function generateRandomTestCase() {
    const depth = Math.floor(24*Math.random());
    const value = crypto.randomBytes(32);
    const [root, proof, position] = generateRoot(value, depth);
    return getTestCase(root, value.reverse().toString("hex"), proof, position);
}

async function main() {
    const numTests = 10;
    console.log("\n// Random generated tests\n");
    for(let i=0;i<numTests;i++) {
        console.log(generateRandomTestCase());
    }
    console.log("\n// Real data tests\n");
    for(let i=0;i<numTests;i++) {
        console.log(await getRealRandomTestCase());
    }
}

main();
