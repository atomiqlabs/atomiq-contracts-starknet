const starknet = require("micro-starknet");
const crypto = require("crypto");
const { exportToCairoFile, toU32Array, toCairoTuple, toCairoDynamicArray, toCairoArray, toCairoStruct, serializeByteArray } = require("../../utils/cairo_structs");
const { toCairoStoredBlockheader } = require("../../utils/blockheaders");
const { generateRoot } = require("../../utils/merkle_tree");
const { mine } = require("../../utils/blockchain_utils");
const { getBlockWithTransactions, getBlockheader, getTransaction } = require("../../utils/bitcoind_rpc_utils");
const {getMerkleProof} = require("../../utils/mempool_utils");
const {poseidonHashRange} = require("../../utils/poseidon");
const {getRandomTransaction} = require("../../utils/bitcoin_tx");
const bitcoin = require("bitcoinjs-lib");

const getRandomBlockheight = () => Math.floor(Math.random() * 800000);

function getTxoHash(txOutput) {
    return starknet.poseidonHashMany([BigInt(txOutput.value), poseidonHashRange(txOutput.script, 0, txOutput.script.length)]);
}

function arrayPadEnd(array, length, padWith) {
    const arr = [...array];
    while(arr.length<length) {
        arr.push(padWith);
    }
    return arr;
}

function generateTestCase(txoHash, confirmations, blockheader, relayHeight, transactionHex, txId, vout, merkleProof, position, proofHeader = blockheader) {
    const serializedTxData = serializeByteArray(Buffer.from(transactionHex, "hex"));
    if(serializedTxData.length>50) throw new Error("TX too large!");
    return toCairoTuple([
        toCairoTuple([
            toCairoStoredBlockheader(blockheader, 0, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], undefined, 12),
            relayHeight
        ], 8, true),
        toCairoTuple([
            txoHash,
            confirmations,
            toCairoStoredBlockheader(proofHeader, 0, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], undefined, 12),
            toCairoArray(arrayPadEnd(serializedTxData, 50, "0x0000000000000000000000000000000000000000000000000000000000000000"), 12),
            serializedTxData.length,
            vout,
            toCairoArray(arrayPadEnd(merkleProof, 20, "0000000000000000000000000000000000000000000000000000000000000000").map(e => toU32Array(Buffer.from(e, "hex").reverse())), 12, true),
            merkleProof.length,
            position,
            toCairoArray(toU32Array(Buffer.from(txId, "hex").reverse()))
        ], 8, true)
    ], 4, true);
}

function generateTestCaseWithTx(
    bitcoinjsTx, blockheader, merkleProof, position,
    proofHeader = blockheader,
    vout = Math.floor(Math.random() * bitcoinjsTx.outs.length),
    txoHash = getTxoHash(bitcoinjsTx.outs[vout])
) {
    bitcoinjsTx.ins.forEach(input => input.witness = []);
    const txId = bitcoinjsTx.getId();
    const txHex = bitcoinjsTx.toHex();
    if(txHex.length > 1488) return null; //Transaction too large
    
    const confirmations = 1+Math.floor(Math.random() * 49);
    const relayHeight = blockheader.height + confirmations - 1 + Math.floor(Math.random() * 5);

    return "    // Block height: "+blockheader.height+" txId: "+txId+" vout: "+vout+"\n"+ 
        generateTestCase(txoHash, confirmations, blockheader, relayHeight, txHex, txId, vout, merkleProof, position, proofHeader);
}

async function generateRealValidTestCase() {
    const blockheight = getRandomBlockheight();
    const block = await getBlockWithTransactions(blockheight);
    const txIndex = Math.floor(Math.random() * block.tx.length);
    const txId = block.tx[txIndex];
    const transaction = await getTransaction(txId);

    const bitcoinjsTx = bitcoin.Transaction.fromHex(transaction.hex);
    
    const blockheader = await getBlockheader(blockheight);
    const merkleProof = await getMerkleProof(txId);

    return generateTestCaseWithTx(bitcoinjsTx, blockheader, merkleProof.merkle, merkleProof.pos);
}

function generateRandomValidTestCase() {
    const bitcoinjsTx = getRandomTransaction();

    const txHash = bitcoinjsTx.getHash();
    const [root, proof, position] = generateRoot(txHash, Math.floor(Math.random() * 20));

    const blockHeight = Math.floor(Math.random()*1000000);

    const header = mine(
        Buffer.alloc(32).toString("hex"), 
        Math.floor(0x100000000*Math.random()),
        "1f7fffff", undefined, blockHeight-1,
        undefined, undefined, root
    );

    return generateTestCaseWithTx(bitcoinjsTx, header, proof, position);
}

function generateRandomInvalidVoutOutOfBoundsTestCase() {
    const bitcoinjsTx = getRandomTransaction();

    const txHash = bitcoinjsTx.getHash();
    const [root, proof, position] = generateRoot(txHash, Math.floor(Math.random() * 20));

    const blockHeight = Math.floor(Math.random()*1000000);

    const header = mine(
        Buffer.alloc(32).toString("hex"), 
        Math.floor(0x100000000*Math.random()),
        "1f7fffff", undefined, blockHeight-1,
        undefined, undefined, root
    );

    return generateTestCaseWithTx(
        bitcoinjsTx, header, proof, position, undefined, 
        bitcoinjsTx.outs.length, //Use vout that is out of bounds
        getTxoHash({value: Math.floor(Math.random()*1000000000), script: crypto.randomBytes(16+Math.floor(Math.random() * 32))}) //Use random txo hash
    );
}

function generateRandomInvalidOutputTestCase() {
    const bitcoinjsTx = getRandomTransaction();

    const txHash = bitcoinjsTx.getHash();
    const [root, proof, position] = generateRoot(txHash, Math.floor(Math.random() * 20));

    const blockHeight = Math.floor(Math.random()*1000000);

    const header = mine(
        Buffer.alloc(32).toString("hex"), 
        Math.floor(0x100000000*Math.random()),
        "1f7fffff", undefined, blockHeight-1,
        undefined, undefined, root
    );

    return generateTestCaseWithTx(
        bitcoinjsTx, header, proof, position, undefined, 
        undefined, //Pick random output
        getTxoHash({value: Math.floor(Math.random()*1000000000), script: crypto.randomBytes(16+Math.floor(Math.random() * 32))}) //Use random txo hash
    );
}

function generateRandomInvalidMerkleTestCase() {
    const bitcoinjsTx = getRandomTransaction();

    const txHash = bitcoinjsTx.getHash();
    const [root, proof, position] = generateRoot(txHash, Math.floor(Math.random() * 20));

    const blockHeight = Math.floor(Math.random()*1000000);

    //Create a block with random merkle root
    const header = mine(
        Buffer.alloc(32).toString("hex"), 
        Math.floor(0x100000000*Math.random()),
        "1f7fffff", undefined, blockHeight-1
    );

    return generateTestCaseWithTx(bitcoinjsTx, header, proof, position);
}

function generateRandomInvalidBlockheaderTestCase() {
    const bitcoinjsTx = getRandomTransaction();

    const txHash = bitcoinjsTx.getHash();
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

    return generateTestCaseWithTx(bitcoinjsTx, incorrect_header, proof, position, header);
}

const numTests = 10;

async function genTests(func) {
    const tests = [];
    for(let i=0;i<numTests;i++) {
        const res = await func();
        if(res==null) {
            i--;
            continue;
        }
        tests.push(res);
    }
    return tests;
}

async function main() {

    const testsValid = await genTests(generateRandomValidTestCase);
    const testsInvalidVout = await genTests(generateRandomInvalidVoutOutOfBoundsTestCase);
    const testsInvalidOutput = await genTests(generateRandomInvalidOutputTestCase);
    const testsInvalidMerkle = await genTests(generateRandomInvalidMerkleTestCase);
    const testsInvalidBlockheader = await genTests(generateRandomInvalidBlockheaderTestCase);
    const testsValidReal = await genTests(generateRealValidTestCase);
    
    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsValidReal.length+"]",
        value: toCairoArray(testsValidReal, 0, true)
    }], "../packages/btc_output_claim_handler/tests/data/valid_real.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);

    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsValid.length+"]",
        value: toCairoArray(testsValid, 0, true)
    }], "../packages/btc_output_claim_handler/tests/data/valid_random.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);

    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsInvalidVout.length+"]",
        value: toCairoArray(testsInvalidVout, 0, true)
    }], "../packages/btc_output_claim_handler/tests/data/invalid_random_vout_out_of_bounds.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);

    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsInvalidOutput.length+"]",
        value: toCairoArray(testsInvalidOutput, 0, true)
    }], "../packages/btc_output_claim_handler/tests/data/invalid_random_output.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);

    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsInvalidMerkle.length+"]",
        value: toCairoArray(testsInvalidMerkle, 0, true)
    }], "../packages/btc_output_claim_handler/tests/data/invalid_random_merkle.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);

    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsInvalidBlockheader.length+"]",
        value: toCairoArray(testsInvalidBlockheader, 0, true)
    }], "../packages/btc_output_claim_handler/tests/data/invalid_random_blockheader.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);
}

main();
