const {CallData} = require("starknet");
const { getBlockheaderConstructorArguments } = require("./utils");

async function main() {
    const height = 883853;
    const arr = getBlockheaderConstructorArguments(height);
    console.log(CallData.toHex(arr).join(" "));
}

main();
