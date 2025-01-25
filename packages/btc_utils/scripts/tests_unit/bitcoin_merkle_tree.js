const {getBlockWithTransactions} = require("../utils/bitcoind_rpc_utils");
const {getMerkleProof} = require("../utils/mempool_utils");
const {toCairoTuple} = require("../utils/cairo_structs");
const crypto = require("crypto");

const getRandomBlockheight = () => Math.floor(Math.random() * 840000);

function dblSha256(valueBuffer) {
    return crypto.createHash("sha256").update(crypto.createHash("sha256").update(valueBuffer).digest()).digest();
}

function getTestCase(root, txId, proof, position) {
    return "let (root, txId, proof, position) = "+toCairoTuple(root, txId, proof, position, 0)+";\n"+
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
    let position = 0;
    let root = value;
    const proof = [];
    for(let i=0;i<depth;i++) {
        const sibling = crypto.randomBytes(32);
        proof.push(sibling);
        const leftOrRight = Math.floor(2*Math.random());
        root = dblSha256(Buffer.concat(leftOrRight==0 ? [
            root, sibling
        ] : [
            sibling, root
        ]));
        position += leftOrRight << i;
    }
    return getTestCase(root.reverse().toString("hex"), value.reverse().toString("hex"), proof.map(e => e.reverse().toString("hex")), position);
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
