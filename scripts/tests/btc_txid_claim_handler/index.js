const starknet = require("micro-starknet");
const crypto = require("crypto");
const { exportToCairoFile, toU32Array, toCairoTuple, toCairoDynamicArray, toCairoArray, toCairoStruct } = require("../../utils/cairo_structs");
const { toCairoStoredBlockheader } = require("../../utils/blockheaders");
const { generateRoot } = require("../../utils/merkle_tree");
const { mine } = require("../../utils/blockchain_utils");
const { getBlockWithTransactions, getBlockheader } = require("../../utils/bitcoind_rpc_utils");
const {getMerkleProof} = require("../../utils/mempool_utils");

const getRandomBlockheight = () => Math.floor(Math.random() * 800000);

function arrayPadEnd(array, length) {
    const arr = [...array];
    while(arr.length<length) {
        arr.push("0000000000000000000000000000000000000000000000000000000000000000");
    }
    return arr;
}

function generateTestCase(txId, confirmations, blockheader, relayHeight, merkleProof, position, proofHeader = blockheader) {
    return toCairoTuple([
        toCairoTuple([
            toCairoStoredBlockheader(blockheader, 0, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], undefined, 12),
            relayHeight
        ], 8, true),
        toCairoTuple([
            toU32Array(Buffer.from(txId, "hex").reverse()),
            confirmations,
            toCairoStoredBlockheader(proofHeader, 0, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], undefined, 12),
            toCairoArray(arrayPadEnd(merkleProof, 20).map(e => toU32Array(Buffer.from(e, "hex").reverse())), 12, true),
            merkleProof.length,
            position
        ], 8, true)
    ], 4, true);
}

async function generateRealValidTestCase() {
    const blockheight = getRandomBlockheight();
    const block = await getBlockWithTransactions(blockheight);
    const txIndex = Math.floor(Math.random() * block.tx.length);
    const txId = block.tx[txIndex];
    const blockheader = await getBlockheader(blockheight);
    const merkleProof = await getMerkleProof(txId);
    
    const confirmations = 1+Math.floor(Math.random() * 49);
    const relayHeight = blockheight + confirmations - 1 + Math.floor(Math.random() * 5);

    return "    // Block height: "+blockheight+" Position: "+txIndex+" txId: "+txId+"\n"+ 
        generateTestCase(txId, confirmations, blockheader, relayHeight, merkleProof.merkle, merkleProof.pos);
}

function generateRandomValidTestCase() {
    const txHash = crypto.randomBytes(32);
    const [root, proof, position] = generateRoot(txHash, Math.floor(Math.random() * 20));

    const blockHeight = Math.floor(Math.random()*1000000);

    const header = mine(
        Buffer.alloc(32).toString("hex"), 
        Math.floor(0x100000000*Math.random()),
        "1f7fffff", undefined, blockHeight-1,
        undefined, undefined, root
    );

    const confirmations = 1+Math.floor(Math.random() * 49);
    const relayHeight = blockHeight + confirmations - 1 + Math.floor(Math.random() * 5);

    return generateTestCase(txHash.reverse().toString("hex"), confirmations, header, relayHeight, proof, position);
}

function generateRandomInvalidMerkleTestCase() {
    const txHash = crypto.randomBytes(32);
    const [root, proof, position] = generateRoot(txHash, Math.floor(Math.random() * 20));

    const blockHeight = Math.floor(Math.random()*1000000);

    //Create a block with random merkle root
    const header = mine(
        Buffer.alloc(32).toString("hex"), 
        Math.floor(0x100000000*Math.random()),
        "1f7fffff", undefined, blockHeight-1
    );

    const confirmations = 1+Math.floor(Math.random() * 49);
    const relayHeight = blockHeight + confirmations - 1 + Math.floor(Math.random() * 5);

    return generateTestCase(txHash.reverse().toString("hex"), confirmations, header, relayHeight, proof, position);
}

function generateRandomInvalidBlockheaderTestCase() {
    const txHash = crypto.randomBytes(32);
    const [root, proof, position] = generateRoot(txHash, Math.floor(Math.random() * 20));

    const blockHeight = Math.floor(Math.random()*1000000);

    //Create a block with correct merkle root
    const header = mine(
        Buffer.alloc(32).toString("hex"), 
        Math.floor(0x100000000*Math.random()),
        "1f7fffff", undefined, blockHeight-1,
        undefined, undefined, root
    );

    //Create a block with the incorrect merkle root
    const incorrect_header = mine(
        Buffer.alloc(32).toString("hex"), 
        Math.floor(0x100000000*Math.random()),
        "1f7fffff", undefined, blockHeight-1
    );

    const confirmations = 1+Math.floor(Math.random() * 49);
    const relayHeight = blockHeight + confirmations - 1 + Math.floor(Math.random() * 5);

    return generateTestCase(txHash.reverse().toString("hex"), confirmations, incorrect_header, relayHeight, proof, position, header);
}

async function main() {
    const numTests = 10;

    const testsValid = [];
    for(let i=0;i<numTests;i++) {
        testsValid.push(generateRandomValidTestCase());
    }
    
    const testsInvalidMerkle = [];
    for(let i=0;i<numTests;i++) {
        testsInvalidMerkle.push(generateRandomInvalidMerkleTestCase());
    }
    
    const testsInvalidBlockheader = [];
    for(let i=0;i<numTests;i++) {
        testsInvalidBlockheader.push(generateRandomInvalidBlockheaderTestCase());
    }

    const testsValidReal = [];
    for(let i=0;i<numTests;i++) {
        testsValidReal.push(await generateRealValidTestCase());
    }
    
    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), ([u32; 8], u32, StoredBlockHeader, [[u32; 8]; 20], usize, u32)); "+testsValidReal.length+"]",
        value: toCairoArray(testsValidReal, 0, true)
    }], "../packages/btc_txid_claim_handler/tests/data/valid_real.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);

    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), ([u32; 8], u32, StoredBlockHeader, [[u32; 8]; 20], usize, u32)); "+testsValid.length+"]",
        value: toCairoArray(testsValid, 0, true)
    }], "../packages/btc_txid_claim_handler/tests/data/valid_random.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);
    
    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), ([u32; 8], u32, StoredBlockHeader, [[u32; 8]; 20], usize, u32)); "+testsInvalidMerkle.length+"]",
        value: toCairoArray(testsInvalidMerkle, 0, true)
    }], "../packages/btc_txid_claim_handler/tests/data/invalid_random_merkle.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);
    
    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), ([u32; 8], u32, StoredBlockHeader, [[u32; 8]; 20], usize, u32)); "+testsInvalidBlockheader.length+"]",
        value: toCairoArray(testsInvalidBlockheader, 0, true)
    }], "../packages/btc_txid_claim_handler/tests/data/invalid_random_blockheader.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);    
}

main();
