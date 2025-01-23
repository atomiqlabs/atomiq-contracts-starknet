const fs = require('fs');

function toU32Array(buffer) {
    const arr = [];
    for(let i=0;i<8;i++) {
        arr.push(BigInt(buffer.readUInt32BE(i*4)));
    }
    return arr;
}

function toCairoTuple(hash, secret, spaces) {
    const prefix = " ".repeat(spaces);
    return prefix+"(0x"+hash.toString(16)+", ["+toU32Array(secret).map(e => "0x"+e.toString(16)).join(", ")+"])";
}

function exportToCairoFile(test_array, outputFile) {
    fs.writeFileSync(outputFile,"\n");

    fs.appendFileSync(outputFile, "pub const TEST_DATA: [(felt252, [u32; 8]); "+test_array.length+"] = [\n");
    for(let element of test_array) {
        fs.appendFileSync(outputFile, toCairoTuple(element[0], element[1], 4)+",\n");
    }
    fs.appendFileSync(outputFile, "];\n");
}

module.exports = {
    exportToCairoFile,
    toCairoTuple,
    toU32Array
};
