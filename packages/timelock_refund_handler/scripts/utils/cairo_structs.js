const fs = require('fs');

function toCairoTuple(expiry, currentTimestamp, spaces) {
    const prefix = " ".repeat(spaces);
    return prefix+"(0x"+expiry.toString(16)+", 0x"+currentTimestamp.toString(16)+")";
}

function exportToCairoFile(test_array, outputFile) {
    fs.writeFileSync(outputFile,"\n");

    fs.appendFileSync(outputFile, "pub const TEST_DATA: [(felt252, u64); "+test_array.length+"] = [\n");
    for(let element of test_array) {
        fs.appendFileSync(outputFile, toCairoTuple(element[0], element[1], 4)+",\n");
    }
    fs.appendFileSync(outputFile, "];\n");
}

module.exports = {
    exportToCairoFile,
    toCairoTuple
};
