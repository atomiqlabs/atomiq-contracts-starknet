
const mempoolApiUrl = "https://mempool.space/api";

async function getMerkleProof(txId) {
    return (await (await fetch(mempoolApiUrl+"/tx/"+txId+"/merkle-proof")).json());
}

module.exports = {
    getMerkleProof
};
