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

async function getBlockWithTransactions(height) {
    const blockhash = await getBlockhash(height);
    return (await (await fetch(bitcoindRpc, {method: "POST", body: JSON.stringify({
        "jsonrpc":"1.0","id":0,"method":"getblock","params":[blockhash, 1]
    })})).json()).result;
}

async function getTransaction(txId) {
    return (await (await fetch(bitcoindRpc, {method: "POST", body: JSON.stringify({
        "jsonrpc":"1.0","id":0,"method":"getrawtransaction","params":[txId, true]
    })})).json()).result;
}

module.exports = {
    getBlockhash,
    getBlockWithTransactions,
    getBlockheader,
    getTransaction
};