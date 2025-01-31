const starknet = require("micro-starknet");

function poseidonHashRange(buffer, startIndex, endIndex) {
    const values = [];
    for(let i=startIndex+31;i<endIndex;i+=31) {
        values.push(BigInt("0x"+buffer.subarray(i-31, i).toString("hex")));
    }
    if(endIndex > startIndex + (values.length*31)) values.push(BigInt("0x"+buffer.subarray(startIndex + (values.length*31), endIndex).toString("hex")));
    return starknet.poseidonHashMany(values);
}

module.exports = {
    poseidonHashRange
};
