const {toCairoStruct, toU32Array, exportToCairoFile, toCairoArray} = require("./cairo_structs");

function u32ToReversedHex(int) {
    const buffer = Buffer.alloc(4);
    buffer.writeUInt32LE(int, 0);
    return "0x"+buffer.toString("hex");
}

function toCairoBlockheader(header, spaces = 0) {
    return toCairoStruct("BlockHeader", {
        reversed_version: u32ToReversedHex(header.version),
        previous_blockhash: toU32Array(Buffer.from(header.previousblockhash, "hex").reverse()),
        merkle_root: toU32Array(Buffer.from(header.merkleroot, "hex").reverse()),
        reversed_timestamp: u32ToReversedHex(header.time),
        nbits: Buffer.from(header.bits, "hex").reverse(),
        nonce: u32ToReversedHex(header.nonce)
    }, spaces, true);
}

function toCairoStoredBlockheader(header, epochStartTimestamp, prevBlockTimestamps, blockheaderVar, spaces = 0) {
    return toCairoStruct("StoredBlockHeader", {
        blockheader: blockheaderVar ?? toCairoBlockheader(header),
        block_hash: toU32Array(Buffer.from(header.hash, "hex").reverse()),
        chain_work: "0x"+header.chainwork,
        block_height: header.height,
        last_diff_adjustment: epochStartTimestamp,
        prev_block_timestamps: prevBlockTimestamps
    }, spaces, true);
}

function getPrevBlockTimestamps(headers, height) {
    const timestamps = [];
    for(let i=height-10;i<height;i++) {
        timestamps.push(i<0 ? headers[0].time : headers[i].time);
    }
    return timestamps;
}

function _toCairoStoredBlockheader(headers, height, spaces) {
    const epochFirstBlockheight = Math.floor(height/2016) * 2016;
    const header = headers[height];
    return toCairoStoredBlockheader(
        header, headers[epochFirstBlockheight].time, 
        getPrevBlockTimestamps(headers, height), "BLOCKHEADER_"+height, spaces
    );
}

function exportChainToCairoFile(headers, startBlock, endBlock, currTimestamp, outputFile) {
    const variables = [
        {name: "TIMESTAMP", type: "u64", value: currTimestamp},
    ];

    const blockheaderVarNames = [];
    for(let i=startBlock;i<=endBlock;i++) {
        variables.push({name: "BLOCKHEADER_"+i, type: "BlockHeader", value: toCairoBlockheader(headers[i])});
        //Leave out first block
        if(i!=startBlock) blockheaderVarNames.push("BLOCKHEADER_"+i);
    }
    variables.push({name: "BLOCKHEADERS", type: "[BlockHeader; "+blockheaderVarNames.length+"]", value: toCairoArray(blockheaderVarNames, 0, true)});
    
    const storedBlockheaderStructs = [];
    for(let i=startBlock;i<=endBlock;i++) {
        storedBlockheaderStructs.push(_toCairoStoredBlockheader(headers, i, 4));
    }
    variables.push({name: "STORED_BLOCKHEADERS", type: "[StoredBlockHeader; "+storedBlockheaderStructs.length+"]", value: toCairoArray(storedBlockheaderStructs, 0, true)});

    exportToCairoFile(variables, outputFile, [
        "btc_relay::structs::blockheader::BlockHeader",
        "btc_relay::structs::stored_blockheader::StoredBlockHeader"
    ]);
}

module.exports = {
    toCairoBlockheader,
    toCairoStoredBlockheader,
    exportChainToCairoFile
};