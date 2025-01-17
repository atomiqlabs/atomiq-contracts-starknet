const {exportToCairoFile} = require("./utils/cairo_structs");

async function getBlockhash(blockNumber) {
    console.log("getBlockhash("+blockNumber+")");

    const resp = await fetch("https://bitcoin-mainnet.public.blastapi.io", {
        method: "POST",
        body: JSON.stringify({
            "jsonrpc":"1.0",
            "id":0,
            "method":"getblockhash",
            "params":[blockNumber]
        })
    });

    if(!resp.ok) {
        return;
    }

    return (await resp.json()).result;
}

async function getBlockheader(blockhash) {
    console.log("getBlockheader("+blockhash+")");

    const resp = await fetch("https://bitcoin-mainnet.public.blastapi.io", {
        method: "POST",
        body: JSON.stringify({
            "jsonrpc":"1.0",
            "id":0,
            "method":"getblockheader",
            "params":[blockhash, true]
        })
    });

    if(!resp.ok) {
        return;
    }

    return (await resp.json()).result;
}

const OUTPUT_FILE = "../packages/btc_relay/tests/data/block_headers.cairo";

async function main(startBlock, endBlock) {
    const blockHash = await getBlockhash(startBlock);
    
    const data = {};

    data[startBlock] = await getBlockheader(blockHash);

    //Get first block in the epoch
    const epochFirstBlockheight = Math.floor(startBlock/2016) * 2016;
    data[epochFirstBlockheight] = await getBlockheader(await getBlockhash(epochFirstBlockheight));

    console.log(toCairoBlockheader(data[startBlock]));

    //Get past blocks for timestamps
    let lastBlock = data[startBlock];
    for(let i=startBlock-1;i>=startBlock-10;i--) {
        data[i] = lastBlock = await getBlockheader(lastBlock.previousblockhash);
        await new Promise(resolve => setTimeout(resolve, 500));
    }

    console.log(toCairoStoredBlockheader(data, startBlock));

    lastBlock = data[startBlock];
    for(let i=startBlock+1;i<=endBlock;i++) {
        data[i] = lastBlock = await getBlockheader(lastBlock.nextblockhash);
        await new Promise(resolve => setTimeout(resolve, 500));
    }

    exportToCairoFile(data, startBlock, endBlock, Math.floor(Date.now()/1000), OUTPUT_FILE);
}

main(878970, 879000);