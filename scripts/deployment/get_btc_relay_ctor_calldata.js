const {getBlockheader} = require("../utils/bitcoind_rpc_utils");
const {u32ToReversedHex} = require("../utils/blockheaders");
const {toU32Array} = require("../utils/cairo_structs");
const {cairo, CallData} = require("starknet");

async function main() {
    const height = 883853;
    const blockheader = await getBlockheader(height);
    const epochStartBlockheader = await getBlockheader(Math.floor(height/2016)*2016);
    const prevBlockTimestamps = [];
    for(let i=1;i<11;i++) {
        const prevBlock = await getBlockheader(height-i);
        prevBlockTimestamps.unshift(prevBlock.time);
    }
    const chainWork = cairo.uint256("0x"+blockheader.chainwork);
    const arr = [
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

    console.log(CallData.toHex(arr).join(" "));
}

main();
