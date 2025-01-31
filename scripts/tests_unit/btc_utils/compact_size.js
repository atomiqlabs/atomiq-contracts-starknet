const {toCairoSerializedByteArray, toCairoTuple} = require("../../utils/cairo_structs");
const BN = require("bn.js");
const crypto = require("crypto");

function toCompactSize(value) {
    if(value.lte(new BN(0xFC))) {
        return value.toBuffer("le", 1);
    } else if(value.lte(new BN(0xFFFF))) {
        return Buffer.concat([Buffer.from([0xFD]), value.toBuffer("le", 2)]);
    } else if(value.lte(new BN(0xFFFFFFFF))) {
        return Buffer.concat([Buffer.from([0xFE]), value.toBuffer("le", 4)]);
    } else if(value.lte(new BN("FFFFFFFFFFFFFFFF", "hex"))) {
        return Buffer.concat([Buffer.from([0xFF]), value.toBuffer("le", 8)]);
    }
    throw new Error("Value too large");
}

function getCompactSizeTest(value, position = 0, bufferSize) {
    const compactBuffer = toCompactSize(value);
    const buffer = crypto.randomBytes(bufferSize ?? position+varintBuffer.length);
    compactBuffer.copy(buffer, position);
    return "let mut serialized_byte_array = "+toCairoSerializedByteArray(buffer)+";\n"+
        "assert_eq!(Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap().read_compact("+position+"), "+toCairoTuple([value, compactBuffer.length])+");\n";
}

function getRandomAccessCompactSizeTest() {
    const value = new BN(crypto.randomBytes(8)).shrn(Math.floor(Math.random() * 64));
    const bufferSize = 9 + Math.floor(Math.random() * 128);
    const position = Math.floor(Math.random() * (bufferSize-9));
    return getCompactSizeTest(value, position, bufferSize);
}

const numTests = 20;
for(let i=0;i<numTests;i++) {
    console.log(getRandomAccessCompactSizeTest());
}
