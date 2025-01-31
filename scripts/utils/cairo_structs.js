const BN = require('bn.js');
const fs = require('fs');

function toCairoElement(e, spaces = 0) {
    const prefix = " ".repeat(spaces);
    if(Buffer.isBuffer(e)) return prefix+"0x"+e.toString("hex");
    if(typeof(e) === "number" || typeof(e) === "bigint") return prefix+"0x"+e.toString(16);
    if(BN.isBN(e)) return prefix+"0x"+e.toString("hex");
    if(typeof(e) === "string") {
        if(e.substring(0, spaces)===prefix) return e;
        return prefix+e;
    }
    if(Array.isArray(e)) return toCairoArray(e, spaces);
    throw new Error("Unrecognized type");
}

function toU32Array(buffer) {
    const arr = [];
    for(let i=0;i<8;i++) {
        arr.push(BigInt(buffer.readUInt32BE(i*4)));
    }
    return arr;
}

function toCairoSerializedByteArray(buffer, spaces = 0) {
    const data = [];
    for(let i=31;i<buffer.length;i+=31) {
        data.push(buffer.slice(i-31, i));
    }
    const pendingWordLength = buffer.length - (data.length*31);
    const pendingWord = pendingWordLength==0 ? Buffer.alloc(1) : buffer.slice(data.length*31);
    const arr = ["0x"+data.length.toString(16), ...data.map(e => "0x"+e.toString("hex")), "0x"+pendingWord.toString("hex"), "0x"+pendingWordLength.toString(16)];
    return toCairoSpan(arr, spaces);
}

function toCairoArray(arr, spaces = 0, useNewline = false) {
    const newline = useNewline ? "\n" : "";
    const prefix = " ".repeat(spaces);
    const subPrefix = useNewline ? prefix : "";
    return prefix+"["+newline+arr.map(e => toCairoElement(e, useNewline ? spaces+4 : 0)).join(", "+newline)+newline+subPrefix+"]";
}

function toCairoDynamicArray(arr, spaces = 0, useNewline = false) {
    const newline = useNewline ? "\n" : "";
    const prefix = " ".repeat(spaces);
    const subPrefix = useNewline ? prefix : "";
    return prefix+"array!["+newline+arr.map(e => toCairoElement(e, useNewline ? spaces+4 : 0)).join(", "+newline)+newline+subPrefix+"]";
}

function toCairoSpan(arr, spaces = 0, useNewline = false) {
    return toCairoDynamicArray(arr, spaces, useNewline)+".span()";
}

function toCairoTuple(arr, spaces = 0, useNewline = false) {
    const newline = useNewline ? "\n" : "";
    const prefix = " ".repeat(spaces);
    const subPrefix = useNewline ? " ".repeat(spaces) : "";
    return prefix+"("+newline+arr.map(e => toCairoElement(e, useNewline ? spaces+4 : 0)).join(", "+newline)+newline+subPrefix+")";
}

function toCairoStruct(name, values, spaces = 0, useNewline = false) {
    const newline = useNewline ? "\n" : "";
    const prefix = " ".repeat(spaces);
    return name+" {"+newline+Object.keys(values).map(key => prefix+(useNewline ? " ".repeat(4) : "")+key+": "+toCairoElement(values[key])).join(", "+newline)+newline+prefix+"}";
}

/**
 * 
 * @param {{name: string, type: string, value: any}[]} variables 
 * @param {string} outputFile 
 */
function exportToCairoFile(variables, outputFile, imports = []) {
    fs.writeFileSync(outputFile,
        imports.map(i => "use "+i+";").join("\n")+
        "\n\n"
    );

    for(let variable of variables) {
        fs.appendFileSync(outputFile, "pub const "+variable.name+": "+variable.type+" = "+variable.value+";\n\n");
    }
}

module.exports = {
    exportToCairoFile,
    toCairoSerializedByteArray,
    toCairoTuple,
    toCairoDynamicArray,
    toCairoArray,
    toCairoElement,
    toCairoStruct,
    toCairoSpan,
    toU32Array
};
