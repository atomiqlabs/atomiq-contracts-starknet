const bitcoindRpc = "https://bitcoin-mainnet.public.blastapi.io";

async function getBlockhash(height) {
    return (await (await fetch(bitcoindRpc, {method: "POST", body: JSON.stringify({
        "jsonrpc":"1.0","id":0,"method":"getblockhash","params":[height]
    })})).json()).result;
}

async function getBlockheader(height) {
    const blockhash = await getBlockhash(height);
    return (await (await fetch(bitcoindRpc, {method: "POST", body: JSON.stringify({
        "jsonrpc":"1.0","id":0,"method":"getblockheader","params":[blockhash]
    })})).json()).result;
}

module.exports = {
    getBlockhash,
    getBlockheader
};