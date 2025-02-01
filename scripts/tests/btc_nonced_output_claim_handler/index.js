const starknet = require("micro-starknet");
const crypto = require("crypto");
const { exportToCairoFile, toU32Array, toCairoTuple, toCairoArray, serializeByteArray } = require("../../utils/cairo_structs");
const { toCairoStoredBlockheader } = require("../../utils/blockheaders");
const { generateRoot } = require("../../utils/merkle_tree");
const { mine } = require("../../utils/blockchain_utils");
const {poseidonHashRange} = require("../../utils/poseidon");
const {getRandomTransaction: _getRandomTransaction} = require("../../utils/bitcoin_tx");
const BN = require("bn.js");

const randomU31 = () => Math.floor(Math.random() * 0x80000000);
const randomU24 = () => Math.floor(Math.random() * 0x1000000);
const randomU4 = () => Math.floor(Math.random() * 0x10);
const randomU8sub16 = () => Math.floor(Math.random() * 0xF0);

function getRandomTransaction(minInputs, minOuts) {
    const bitcoinjsTx = _getRandomTransaction(minInputs, minOuts);
    const nSequenceBase = randomU24();
    bitcoinjsTx.ins.forEach(input => input.sequence = 0xF0000000 + (randomU4()*Math.pow(2, 24)) + nSequenceBase);
    bitcoinjsTx.locktime = 500_000_000 + randomU31();
    return bitcoinjsTx;
}

function getTxoHash(txOutput, nonceOrTx) {
    let nonce;
    if(BN.isBN(nonceOrTx)) {
        nonce = nonceOrTx;
    } else {
        let nSequence = null;
        nonceOrTx.ins.forEach((input) => {
            if(input.nSequence & 0xF0000000 != 0xF0000000) throw new Error("nSequence has consensus meaning");
            if(nSequence==null) nSequence = input.sequence & 0x00FFFFFF;
            if(nSequence != (input.sequence & 0x00FFFFFF)) throw new Error("Not all inputs have the same nSequence");
        });
        if(nonceOrTx.locktime < 500_000_000) throw new Error("Locktime too low");
        nonce = new BN(nonceOrTx.locktime - 500_000_000).shln(24).or(new BN(nSequence));
    }
    return starknet.poseidonHashMany([BigInt(nonce.toString(10)), BigInt(txOutput.value), poseidonHashRange(txOutput.script, 0, txOutput.script.length)]);
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
    txoHash = getTxoHash(bitcoinjsTx.outs[vout], bitcoinjsTx)
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
        getTxoHash({value: Math.floor(Math.random()*1000000000), script: crypto.randomBytes(16+Math.floor(Math.random() * 32))}, new BN(crypto.randomBytes(7))) //Use random txo hash
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
        getTxoHash({value: Math.floor(Math.random()*1000000000), script: crypto.randomBytes(16+Math.floor(Math.random() * 32))}, new BN(crypto.randomBytes(7))) //Use random txo hash
    );
}

function generateRandomInvalidEmptyInputs() {
    //Make sure to generate at least 2 outputs, otherwise the empty input count 0x00 and following
    // output count 0x01 acts as a witness flag, and panics during transaction parsing
    const bitcoinjsTx = getRandomTransaction(undefined, 2);
    bitcoinjsTx.ins = [];

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
        getTxoHash({value: Math.floor(Math.random()*1000000000), script: crypto.randomBytes(16+Math.floor(Math.random() * 32))}, new BN(crypto.randomBytes(7))) //Use random txo hash
    );
}

function generateRandomInvalidSequenceBitsUnset() {
    const bitcoinjsTx = getRandomTransaction();
    //Make sure the 4 high bits are not all set
    bitcoinjsTx.ins.forEach(input => input.sequence = (randomU8sub16() * 0x1000000) + (input.sequence & 0x00FFFFFF));

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
        getTxoHash({value: Math.floor(Math.random()*1000000000), script: crypto.randomBytes(16+Math.floor(Math.random() * 32))}, new BN(crypto.randomBytes(7))) //Use random txo hash
    );
}

function generateRandomInvalidSequenceMatch() {
    const bitcoinjsTx = getRandomTransaction(2);
    //Make sure inputs use non-matching random nSequences
    bitcoinjsTx.ins.forEach(input => input.sequence = 0xF0000000 + randomU24());

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
        getTxoHash({value: Math.floor(Math.random()*1000000000), script: crypto.randomBytes(16+Math.floor(Math.random() * 32))}, new BN(crypto.randomBytes(7))) //Use random txo hash
    );
}

function generateRandomInvalidTimelockTooLow() {
    const bitcoinjsTx = getRandomTransaction();
    //Make sure locktime is < 500,000,000
    bitcoinjsTx.locktime = Math.floor(Math.random() * 500_000_000);

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
        getTxoHash({value: Math.floor(Math.random()*1000000000), script: crypto.randomBytes(16+Math.floor(Math.random() * 32))}, new BN(crypto.randomBytes(7))) //Use random txo hash
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

function genTests(func) {
    const tests = [];
    for(let i=0;i<numTests;i++) {
        const res = func();
        if(res==null) {
            i--;
            continue;
        }
        tests.push(res);
    }
    return tests;
}

function main() {

    const testsValid = genTests(generateRandomValidTestCase);
    const testsInvalidVout = genTests(generateRandomInvalidVoutOutOfBoundsTestCase);
    const testsInvalidOutput = genTests(generateRandomInvalidOutputTestCase);
    const testsInvalidMerkle = genTests(generateRandomInvalidMerkleTestCase);
    const testsInvalidBlockheader = genTests(generateRandomInvalidBlockheaderTestCase);
    const testsInvalidEmptyIns = genTests(generateRandomInvalidEmptyInputs);
    const testsInvalidSequenceBits = genTests(generateRandomInvalidSequenceBitsUnset);
    const testsInvalidSequenceMatch = genTests(generateRandomInvalidSequenceMatch);
    const testsInvalidTimelock = genTests(generateRandomInvalidTimelockTooLow);


    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsValid.length+"]",
        value: toCairoArray(testsValid, 0, true)
    }], "../packages/btc_nonced_output_claim_handler/tests/data/valid_random.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);

    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsInvalidVout.length+"]",
        value: toCairoArray(testsInvalidVout, 0, true)
    }], "../packages/btc_nonced_output_claim_handler/tests/data/invalid_random_vout_out_of_bounds.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);

    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsInvalidOutput.length+"]",
        value: toCairoArray(testsInvalidOutput, 0, true)
    }], "../packages/btc_nonced_output_claim_handler/tests/data/invalid_random_output.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);

    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsInvalidMerkle.length+"]",
        value: toCairoArray(testsInvalidMerkle, 0, true)
    }], "../packages/btc_nonced_output_claim_handler/tests/data/invalid_random_merkle.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);

    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsInvalidBlockheader.length+"]",
        value: toCairoArray(testsInvalidBlockheader, 0, true)
    }], "../packages/btc_nonced_output_claim_handler/tests/data/invalid_random_blockheader.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);

    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsInvalidEmptyIns.length+"]",
        value: toCairoArray(testsInvalidEmptyIns, 0, true)
    }], "../packages/btc_nonced_output_claim_handler/tests/data/invalid_random_empty_ins.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);

    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsInvalidSequenceBits.length+"]",
        value: toCairoArray(testsInvalidSequenceBits, 0, true)
    }], "../packages/btc_nonced_output_claim_handler/tests/data/invalid_random_sequence_bits.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);

    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsInvalidSequenceMatch.length+"]",
        value: toCairoArray(testsInvalidSequenceMatch, 0, true)
    }], "../packages/btc_nonced_output_claim_handler/tests/data/invalid_random_sequence_match.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);

    exportToCairoFile([{
        name: "TEST_DATA",
        type: "[((StoredBlockHeader, u32), (felt252, u32, StoredBlockHeader, [felt252; 50], usize, u32, [[u32; 8]; 20], usize, u32, [u32; 8])); "+testsInvalidTimelock.length+"]",
        value: toCairoArray(testsInvalidTimelock, 0, true)
    }], "../packages/btc_nonced_output_claim_handler/tests/data/invalid_random_timelock_too_low.cairo", [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);
}

main();
