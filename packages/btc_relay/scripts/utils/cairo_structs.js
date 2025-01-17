const fs = require('fs');

function u32ToReversedHex(int) {
    const buffer = Buffer.alloc(4);
    buffer.writeUInt32LE(int, 0);
    return "0x"+buffer.toString("hex");
}

function hexReverse(str) {
    return "0x"+Buffer.from(str, "hex").reverse().toString("hex");
}

function hex256bitReverseToU32Arr(str) {
    const reversed = Buffer.from(str, "hex").reverse().toString("hex")
    const resultArr = [];
    for(let i=0;i<64;i+=8) {
        resultArr.push("0x"+reversed.substring(i, i+8));
    }
    return "["+resultArr.join(", ")+"]"
}

function toCairoBlockheader(header, spaces) {
    const prefix = " ".repeat(spaces);
    return prefix+"BlockHeader {\n"+
    prefix+"    reversed_version: "+u32ToReversedHex(header.version)+",\n"+
    prefix+"    previous_blockhash: "+hex256bitReverseToU32Arr(header.previousblockhash)+",\n"+
    prefix+"    merkle_root: "+hex256bitReverseToU32Arr(header.merkleroot)+",\n"+
    prefix+"    reversed_timestamp: "+u32ToReversedHex(header.time)+",\n"+
    prefix+"    nbits: "+hexReverse(header.bits)+",\n"+
    prefix+"    nonce: "+u32ToReversedHex(header.nonce)+"\n"+
    prefix+"}";
}

function getPrevBlockTimestamps(headers, height) {
    const timestamps = [];
    for(let i=height-10;i<height;i++) {
        timestamps.push(i<0 ? headers[0].time : headers[i].time);
    }
    return "["+timestamps.join(", ")+"]";
}

function toCairoStoredBlockheader(headers, height, spaces) {
    const prefix = " ".repeat(spaces);
    const epochFirstBlockheight = Math.floor(height/2016) * 2016;
    const header = headers[height];
    return prefix+"StoredBlockHeader {\n"+
    prefix+"    blockheader: BLOCKHEADER_"+height+",\n"+
    prefix+"    block_hash: "+hex256bitReverseToU32Arr(header.hash)+",\n"+
    prefix+"    chain_work: 0x"+header.chainwork+",\n"+
    prefix+"    block_height: "+height+",\n"+
    prefix+"    last_diff_adjustment: "+headers[epochFirstBlockheight].time+",\n"+
    prefix+"    prev_block_timestamps: "+getPrevBlockTimestamps(headers, height)+"\n"+
    prefix+"}";
}

function exportToCairoFile(headers, startBlock, endBlock, currTimestamp, outputFile) {
    fs.writeFileSync(outputFile,
        "use btc_relay::structs::blockheader::BlockHeader;\n"+
        "use btc_relay::structs::stored_blockheader::StoredBlockHeader;\n"+
        "\n"
    );

    fs.appendFileSync(outputFile, "pub const TIMESTAMP: u64 = "+currTimestamp+";\n");
    fs.appendFileSync(outputFile, "\n");

    for(let i=startBlock;i<=endBlock;i++) {
        fs.appendFileSync(outputFile, "const BLOCKHEADER_"+i+": BlockHeader = "+toCairoBlockheader(headers[i])+";\n");
    }

    fs.appendFileSync(outputFile, "\n");
    fs.appendFileSync(outputFile, "pub const BLOCKHEADERS: [BlockHeader; "+(endBlock-startBlock)+"] = [\n");
    for(let i=startBlock+1;i<=endBlock;i++) {
        fs.appendFileSync(outputFile, "    BLOCKHEADER_"+i+",\n");
    }
    fs.appendFileSync(outputFile, "];\n");

    fs.appendFileSync(outputFile, "\n");
    fs.appendFileSync(outputFile, "pub const STORED_BLOCKHEADERS: [StoredBlockHeader; "+(endBlock-startBlock+1)+"] = [\n");
    for(let i=startBlock;i<=endBlock;i++) {
        fs.appendFileSync(outputFile, toCairoStoredBlockheader(headers, i, 4)+",\n");
    }
    fs.appendFileSync(outputFile, "];\n");
}

module.exports = {
    exportToCairoFile
};