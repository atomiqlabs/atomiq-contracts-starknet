const {toCairoSerializedByteArray, toU32Array, toCairoArray} = require("../../utils/cairo_structs");
const {poseidonHashRange} = require("../../utils/poseidon");
const crypto = require("crypto");

const assertionTable = [
    [2, (buffer, index_le, noValue) => [ "buffer.read_u16_le("+index_le+")", noValue ? null : "0x"+buffer.readUInt16LE(index_le).toString(16) ], "u16_le"],
    // [2, (buffer, index_be, noValue) => [ "buffer.read_u16_be("+index_be+")", noValue ? null : "0x"+buffer.readUInt16BE(index_be).toString(16) ], "u16_be"],
    [4, (buffer, index_le, noValue) => [ "buffer.read_u32_le("+index_le+")", noValue ? null : "0x"+buffer.readUInt32LE(index_le).toString(16) ], "u32_le"],
    // [4, (buffer, index_be, noValue) => [ "buffer.read_u32_be("+index_be+")", noValue ? null : "0x"+buffer.readUInt32BE(index_be).toString(16) ], "u32_be"],
    [8, (buffer, index_le, noValue) => [ "buffer.read_u64_le("+index_le+")", noValue ? null : "0x"+buffer.readBigUInt64LE(index_le).toString(16) ], "u64_le"],
    // [8, (buffer, index_be, noValue) => [ "buffer.read_u64_be("+index_be+")", noValue ? null : "0x"+buffer.readBigUInt64BE(index_be).toString(16) ], "u64_be"],
    // [16, (buffer, index_le, noValue) => [ "buffer.read_u128_le("+index_le+")", noValue ? null : "0x"+Buffer.from([...buffer.subarray(index_le, index_le+16)]).reverse().toString("hex") ], "u128_le"],
    // [16, (buffer, index_be, noValue) => [ "buffer.read_u128_be("+index_be+")", noValue ? null : "0x"+buffer.subarray(index_be, index_be+16).toString("hex") ], "u128_be"],
    // [32, (buffer, index_le, noValue) => [ "buffer.read_u256_le("+index_le+")", noValue ? null : "0x"+Buffer.from([...buffer.subarray(index_le, index_le+32)]).reverse().toString("hex") ], "u256_le"],
    [32, (buffer, index_be, noValue) => [ "buffer.read_u256("+index_be+")", noValue ? null : "0x"+buffer.subarray(index_be, index_be+32).toString("hex") ], "u256"],
    [31, (buffer, index, noValue) => [ "buffer.read_felt252("+index+")", noValue ? null : "0x"+buffer.subarray(index, index+31).toString("hex") ], "felt252"],
];
for(let i=1;i<=31;i++) {
    assertionTable.push([i, (buffer, index, noValue) => ["buffer.read_partial_felt252("+index+", "+i+")", noValue ? null : "0x"+buffer.subarray(index, index+i).toString("hex")], "felt252_"+i+"b"]);
}

function assertRandomAccess(buffer, type) {
    const length = buffer.length;
    const getRandomIndex = (typeLength) => Math.floor(Math.random() * (length-typeLength));
    const [typeLength, assertionFn] = assertionTable[type];
    if(length<typeLength) return null;
    return "assert_eq!("+assertionFn(buffer, getRandomIndex(typeLength)).join(", ")+");";
}

function getRandomAccessPanicTest(type) {
    const [typeLength, assertionFn, name] = assertionTable[type];
    const length = (typeLength-1)+Math.floor(Math.random() * 32);
    const buffer = crypto.randomBytes(length);
    const getRandomIndex = (typeLength) => length - Math.floor(Math.random() * typeLength);
    const [readCall] = assertionFn(buffer, getRandomIndex(typeLength), true);
    return "#[test]\n" +
        "#[should_panic(expected: 'Array index out of bounds')]\n" +
        "fn test_invalid_"+name+"() {\n" +
        "    let mut serialized_byte_array = "+toCairoSerializedByteArray(buffer)+";\n"+
        "    let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();\n"+
        "    "+readCall+";\n" +
        "}\n";
}

function getRandomByteArrayTest() {
    const length = 2+Math.floor(Math.random() * 128);
    const buffer = crypto.randomBytes(length);
    const def = "let mut serialized_byte_array = "+toCairoSerializedByteArray(buffer)+";\n"+
        "let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();\n";
    
    const assertions = [];
    for(let i=0;i<assertionTable.length;i++) {
        const assertion = assertRandomAccess(buffer, i);
        if(assertion!=null) assertions.push(assertion);
    }
    assertions.push("assert_eq!(buffer.hash_sha256(), "+toCairoArray(toU32Array(crypto.createHash("sha256").update(buffer).digest()))+");");
    assertions.push("assert_eq!(buffer.hash_dbl_sha256(), "+toCairoArray(toU32Array(crypto.createHash("sha256").update(crypto.createHash("sha256").update(buffer).digest()).digest()))+");");
    for(let i=0;i<5;i++) {
        const startIndex = Math.floor(Math.random() * length);
        const endIndex = startIndex + Math.floor(Math.random() * (length-startIndex));
        assertions.push("assert_eq!(buffer.hash_poseidon_range("+startIndex+", "+endIndex+"), 0x"+poseidonHashRange(buffer, startIndex, endIndex).toString(16)+");");
    }
    return def+assertions.join("\n")+"\n";
}

function getRandomAccessByteArrayTest(numAssertions) {
    const length = 2+Math.floor(Math.random() * 128);
    const buffer = crypto.randomBytes(length);
    const def = "let mut serialized_byte_array = "+toCairoSerializedByteArray(buffer)+";\n"+
        "let buffer = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();\n";
    
    const assertions = [];
    for(let i=0;i<numAssertions;i++) {
        const assertionType = Math.floor(Math.random() * (assertionTable.length+1)) - 1;
        if(assertionType===-1) {
            const startIndex = Math.floor(Math.random() * length);
            const endIndex = startIndex + Math.floor(Math.random() * (length-startIndex));
            assertions.push("assert_eq!(buffer.hash_poseidon_range("+startIndex+", "+endIndex+"), 0x"+poseidonHashRange(buffer, startIndex, endIndex).toString(16)+");");
            continue;
        }
        const assertion = assertRandomAccess(buffer, assertionType);
        if(assertion!=null) assertions.push(assertion);
    }
    return def+assertions.join("\n")+"\n";
}

let numTests = 10;
console.log("\n// Random test cases testing all the functionality\n");
for(let i=0;i<numTests;i++) {
    console.log(getRandomByteArrayTest());
}

console.log("\n// Random access test cases testing random reads\n");
for(let i=0;i<numTests;i++) {
    console.log(getRandomAccessByteArrayTest(10));
}

console.log("\n// Random access out of bounds reads\n");
for(let i=0;i<assertionTable.length;i++) {
    console.log(getRandomAccessPanicTest(i));
}
