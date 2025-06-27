const fs = require("fs/promises");
const path = require("path");
const {getBlockheader} = require("../utils/bitcoind_rpc_utils");
const {u32ToReversedHex} = require("../utils/blockheaders");
const {toU32Array} = require("../utils/cairo_structs");
const {cairo} = require("starknet");

async function getBlockheaderConstructorArguments(height) {
    const blockheader = await getBlockheader(height);
    const epochStartBlockheader = await getBlockheader(Math.floor(height/2016)*2016);
    const prevBlockTimestamps = [];
    for(let i=1;i<11;i++) {
        const prevBlock = await getBlockheader(Math.max(height-i, 0));
        prevBlockTimestamps.unshift(prevBlock.time);
    }
    const chainWork = cairo.uint256("0x"+blockheader.chainwork);
    return [
        u32ToReversedHex(blockheader.version),
        ...toU32Array(Buffer.from(blockheader.previousblockhash, "hex").reverse()),
        ...toU32Array(Buffer.from(blockheader.merkleroot, "hex").reverse()),
        u32ToReversedHex(blockheader.time),
        "0x"+Buffer.from(blockheader.bits, "hex").reverse().toString("hex"),
        u32ToReversedHex(blockheader.nonce),

        ...toU32Array(Buffer.from(blockheader.hash, "hex").reverse()),
        chainWork.low,
        chainWork.high,
        height,
        epochStartBlockheader.time,
        ...prevBlockTimestamps
    ];
}

async function getCompiledCode(filename) {
    const sierraFilePath = path.join(
    __dirname,
    `../../target/dev/${filename}.contract_class.json`
    );
    const casmFilePath = path.join(
    __dirname,
    `../../target/dev/${filename}.compiled_contract_class.json`
    );

    const code = [sierraFilePath, casmFilePath].map(async (filePath) => {
        const file = await fs.readFile(filePath);
        return JSON.parse(file.toString("ascii"));
    });

    const [contract, casm] = await Promise.all(code);

    return {
        contract,
        casm
    };
}

module.exports = {
    getCompiledCode,
    getBlockheaderConstructorArguments
};