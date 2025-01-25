const fs = require('fs');

function poseidonHashRange(buffer, startIndex, endIndex) {
    const values = [];
    for(let i=startIndex+31;i<endIndex;i+=31) {
        values.push(BigInt("0x"+buffer.subarray(i-31, i).toString("hex")));
    }
    if(endIndex > startIndex + (values.length*31)) values.push(BigInt("0x"+buffer.subarray(startIndex + (values.length*31), endIndex).toString("hex")));
    return starknet.poseidonHashMany(values);
}

function hex256bitReverseToU32Arr(str) {
    const reversed = Buffer.from(str, "hex").reverse().toString("hex")
    const resultArr = [];
    for(let i=0;i<64;i+=8) {
        resultArr.push("0x"+reversed.substring(i, i+8));
    }
    return "["+resultArr.join(", ")+"]"
}

function buffer256bitToU32Arr(buffer) {
    const resultArr = [];
    for(let i=0;i<32;i+=4) {
        resultArr.push("0x"+buffer.subarray(i, i+4).toString("hex"));
    }
    return "["+resultArr.join(", ")+"]";
}

function toCairoSerializedByteArray(buffer) {
    const data = [];
    for(let i=31;i<buffer.length;i+=31) {
        data.push(buffer.slice(i-31, i));
    }
    const pendingWordLength = buffer.length - (data.length*31);
    const pendingWord = pendingWordLength==0 ? Buffer.alloc(1) : buffer.slice(data.length*31);
    const arr = ["0x"+data.length.toString(16), ...data.map(e => "0x"+e.toString("hex")), "0x"+pendingWord.toString("hex"), "0x"+pendingWordLength.toString(16)];
    return "array!["+arr.join(", ")+"]";
}

function toCairoTuple(root, txId, proof, position, spaces = 0) {
    const prefix = " ".repeat(spaces);
    return prefix+"(\n"+
        prefix+"    "+hex256bitReverseToU32Arr(root)+",\n"+
        prefix+"    "+hex256bitReverseToU32Arr(txId)+",\n"+
        prefix+"    array![\n"+
        proof.map(e => prefix+"        "+hex256bitReverseToU32Arr(e)).join(",\n") + "\n" +
        prefix+"    ].span(),\n"+
        prefix+"    0x"+position.toString(16)+"\n"+
        prefix+")";
}

function exportToCairoFile(merkleProofs, outputFile) {
    fs.writeFileSync(outputFile,"\n");

    fs.appendFileSync(outputFile, "pub const TEST_DATA: [([u32; 8], [u32; 8], Span<[u32; 8]>, u32); "+merkleProofs.len()+"] = [\n");
    for(let e of merkleProofs) {
        fs.appendFileSync(outputFile, toCairoTuple(e[0], e[1], e[2], e[3])+",\n");
    }
    fs.appendFileSync(outputFile, "];\n");
}

module.exports = {
    exportToCairoFile,
    toCairoTuple,
    toCairoSerializedByteArray,
    buffer256bitToU32Arr,
    poseidonHashRange
};
