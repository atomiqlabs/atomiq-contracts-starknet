const crypto = require("crypto");
const bitcoin = require("bitcoinjs-lib");

const randomU32 = () => Math.floor(Math.random() * 0x100000000);
const randomU31 = () => Math.floor(Math.random() * 0x80000000);

function getRandomTransaction(minInputs = 1, minOutputs = 1) {
    const tx = new bitcoin.Transaction();
    tx.locktime = randomU32();
    tx.version = randomU31();
    const inputs = minInputs+Math.floor(Math.random() * 5);
    for(let i=0;i<inputs;i++) {
        tx.addInput(crypto.randomBytes(32), randomU32(), randomU32(), crypto.randomBytes(Math.floor(Math.random() * 512)));
    }
    const outputs = minOutputs+Math.floor(Math.random() * 5);
    for(let i=0;i<outputs;i++) {
        tx.addOutput(crypto.randomBytes(Math.floor(Math.random() * 64)), Math.floor(Math.random() * 2100_000_000_000_000));
    }
    return tx;
}

module.exports = {
    getRandomTransaction
};
