const {getBlockWithTransactions, getTransaction} = require("../utils/bitcoind_rpc_utils");
const {toCairoSerializedByteArray, buffer256bitToU32Arr, poseidonHashRange} = require("../utils/cairo_structs");
const bitcoin = require("bitcoinjs-lib");
const crypto = require("crypto");

const randomU32 = () => Math.floor(Math.random() * 0x100000000);
const randomU31 = () => Math.floor(Math.random() * 0x80000000);
const getRandomBlockheight = () => Math.floor(Math.random() * 840000);

function getDefineTransaction(txId, txBuffer) {
    return "// Transaction ID: "+txId+"\n"+
        "let mut serialized_byte_array = "+toCairoSerializedByteArray(txBuffer)+".span();\n"+
        "let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();\n"+
        "let result = BitcoinTransactionImpl::from_byte_array(@byte_array);\n";
}

function getScriptHash(scriptBuffer) {
    return poseidonHashRange(scriptBuffer, 0, scriptBuffer.length);
}

async function getRandomRealTxId() {
    const height = getRandomBlockheight();
    const block = await getBlockWithTransactions(height);
    const txIndex = Math.floor(Math.random() * block.tx.length);
    return block.tx[txIndex];
}

//This expects a parsed bitcoinjs transaction
function getTransactionTest(bitcoinjsTx) {
    const txId = bitcoinjsTx.getId();
    const txBuffer = bitcoinjsTx.toBuffer();

    const assertions = [
        ["get_version()", bitcoinjsTx.version],
        ["get_locktime()", bitcoinjsTx.locktime],
        ["get_hash()", buffer256bitToU32Arr(Buffer.from(txId, "hex").reverse())]
    ];

    for(let i=0;i<bitcoinjsTx.ins.length;i++) {
        const vin = bitcoinjsTx.ins[i];
        assertions.push(["get_in("+i+").unwrap().unbox().get_utxo()", "(0x"+vin.hash.toString("hex")+", "+vin.index+")"]);
        assertions.push(["get_in("+i+").unwrap().unbox().get_script_hash()", "0x"+getScriptHash(vin.script).toString(16)]);
        assertions.push(["get_in("+i+").unwrap().unbox().get_n_sequence()", "0x"+vin.sequence.toString(16)]);
    }
    assertions.push(["get_in("+bitcoinjsTx.ins.length+").is_none()", "true"]);

    for(let i=0;i<bitcoinjsTx.outs.length;i++) {
        const vout = bitcoinjsTx.outs[i];
        assertions.push(["get_out("+i+").unwrap().unbox().get_value()", vout.value]);
        assertions.push(["get_out("+i+").unwrap().unbox().get_script_hash()", "0x"+getScriptHash(vout.script).toString(16)]);
    }
    assertions.push(["get_out("+bitcoinjsTx.outs.length+").is_none()", "true"]);
    
    const assertionsStr = assertions.map(([method, value]) => "assert_eq!(result."+method+", "+value.toString()+");").join("\n")

    return getDefineTransaction(txId, txBuffer)+assertionsStr+"\n";
}

function getRandomTransaction() {
    const tx = new bitcoin.Transaction();
    tx.locktime = randomU32();
    tx.version = randomU31();
    const inputs = 1+Math.floor(Math.random() * 5);
    for(let i=0;i<inputs;i++) {
        tx.addInput(crypto.randomBytes(32), randomU32(), randomU32(), crypto.randomBytes(Math.floor(Math.random() * 512)));
    }
    const outputs = 1+Math.floor(Math.random() * 5);
    for(let i=0;i<outputs;i++) {
        tx.addOutput(crypto.randomBytes(Math.floor(Math.random() * 64)), Math.floor(Math.random() * 2100_000_000_000_000));
    }
    return tx;
}

function getRandomTransactionTest() {
    return getTransactionTest(getRandomTransaction());
}

//This fetches transaction as parsed from bitcoind
async function getRealTransactionTest(txId, noStripWitness) {
    const tx = await getTransaction(txId);
    //Strip witness data
    const bitcoinjsTx = bitcoin.Transaction.fromHex(tx.hex);
    if(!noStripWitness) bitcoinjsTx.ins.forEach(input => {
        input.witness = [];
    });
    const txBuffer = bitcoinjsTx.toBuffer();

    const assertions = [
        ["get_version()", tx.version],
        ["get_locktime()", tx.locktime],
        ["get_hash()", buffer256bitToU32Arr(Buffer.from(txId, "hex").reverse())]
    ];

    for(let i=0;i<tx.vin.length;i++) {
        const vin = tx.vin[i];
        assertions.push(["get_in("+i+").unwrap().unbox().get_utxo()", "(0x"+Buffer.from(vin.txid ?? "0000000000000000000000000000000000000000000000000000000000000000", "hex").reverse().toString("hex")+", "+(vin.vout ?? "0xFFFFFFFF")+")"]);
        assertions.push(["get_in("+i+").unwrap().unbox().get_script_hash()", "0x"+getScriptHash(Buffer.from(vin.scriptSig?.hex ?? vin.coinbase, "hex")).toString(16)]);
        assertions.push(["get_in("+i+").unwrap().unbox().get_n_sequence()", "0x"+vin.sequence.toString(16)]);
    }
    assertions.push(["get_in("+tx.vin.length+").is_none()", "true"]);

    for(let i=0;i<tx.vout.length;i++) {
        const vout = tx.vout[i];
        assertions.push(["get_out("+i+").unwrap().unbox().get_value()", Math.round(vout.value*100000000)]);
        assertions.push(["get_out("+i+").unwrap().unbox().get_script_hash()", "0x"+getScriptHash(Buffer.from(vout.scriptPubKey.hex, "hex")).toString(16)]);
    }
    assertions.push(["get_out("+tx.vout.length+").is_none()", "true"]);
    
    const assertionsStr = assertions.map(([method, value]) => "assert_eq!(result."+method+", "+value.toString()+");").join("\n")

    return getDefineTransaction(txId, txBuffer)+assertionsStr+"\n";
}

async function getRealRandomTransactionTest() {
    return await getRealTransactionTest(await getRandomRealTxId());
}

async function main() {
    console.log("\n// Randomly generated transactions \n");
    for(let i=0;i<10;i++) {
        console.log(getRandomTransactionTest());
    }
    console.log("\n// Real on-chain transactions \n");
    const numTests = 20;
    for(let i=0;i<numTests;i++) {
        console.log(await getRealRandomTransactionTest());
    }
    console.log("\n// Invalid TX with witness data not stripped \n");
    console.log(await getRealTransactionTest("ce3a49a4bd21f09fd8bf04399434e0bc4b311f254ce2cdc1ae4a41cd80e05566", true));
    console.log("\n// Invalid TX with random data appended \n");
    const txExtended = getRandomTransaction();
    console.log(getDefineTransaction(txExtended.getId(), Buffer.concat([txExtended.toBuffer(), crypto.randomBytes(41)])));
}

main();
