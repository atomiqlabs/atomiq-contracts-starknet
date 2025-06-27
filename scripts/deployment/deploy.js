require("dotenv").config();
const { getCompiledCode, getBlockheaderConstructorArguments } = require("./utils");
const { Account, CallData, Contract, RpcProvider, stark } = require("starknet");
const {getBlockchainInfo} = require("../utils/bitcoind_rpc_utils");

const claimHandlers = [
    "hashlock_claim_handler_HashlockClaimHandler",
    "btc_txid_claim_handler_BitcoinTxIdClaimHandler",
    "btc_output_claim_handler_BitcoinOutputClaimHandler",
    "btc_nonced_output_claim_handler_BitcoinNoncedOutputClaimHandler"
];

const refundHandlers = [
    "timelock_refund_handler_TimelockRefundHandler"
];

const provider = new RpcProvider({
    nodeUrl: process.env.RPC_ENDPOINT,
});

console.log("ACCOUNT_ADDRESS=", process.env.DEPLOYER_ADDRESS);
const privateKey0 = process.env.DEPLOYER_PRIVATE_KEY ?? "";
const accountAddress0 = process.env.DEPLOYER_ADDRESS ?? "";
const account0 = new Account(provider, accountAddress0, privateKey0);
console.log("Account connected.\n");

async function declare(filename) {
    const declareResponse = await account0.declareIfNot({
        ...await getCompiledCode(filename)
    });
    console.log("\n--- "+filename);
    console.log("Class hash: "+declareResponse.class_hash);
    return declareResponse.class_hash;
}

async function declareAndDeploy(filename, ctorArgs) {
    const deployResponse = await account0.declareAndDeploy({
        ...await getCompiledCode(filename),
        constructorCalldata: ctorArgs,
        salt: 0n
    });
    console.log("\n--- "+filename);
    console.log("Class hash: "+deployResponse.declare.class_hash);
    console.log("Contract address: "+deployResponse.deploy.contract_address);
    return {
        classHash: deployResponse.declare.class_hash,
        contractAddress: deployResponse.deploy.contract_address
    };
}

/*
Params:
    - RPC_ENDPOINT
    - DEPLOYER_PRIVATE_KEY
    - DEPLOYER_ADDRESS
    - BITCOIND_RPC
    - BITCOIND_USERNAME
    - BITCOIND_PASSWORD
*/

async function main() {
    const blockchainInfo = await getBlockchainInfo();
    const finalizedHeight = Math.max(0, blockchainInfo.headers - 500);

    //Deploy light client btc relay
    console.log("\n- Deploying btc relay light client with height "+finalizedHeight);
    await declareAndDeploy("btc_relay_BtcRelay", await getBlockheaderConstructorArguments(finalizedHeight));

    console.log("\n- Deploying execution contract...");
    //Declare execution proxy
    await declare("execution_contract_ExecutionProxy");
    //Deploy execution contract
    const {contractAddress: executionContract} = await declareAndDeploy("execution_contract_ExecutionContract");

    //Deploy spv vault manager
    console.log("\n- Deploying SPV vault manager...");
    await declareAndDeploy("spv_swap_vault_SpvVaultManager", [executionContract]);

    //Deploy escrow manager
    console.log("\n- Deploying escrow manager...");
    await declareAndDeploy("escrow_manager_EscrowManager", [executionContract]);

    //Deploy claim handlers
    console.log("\n- Deploying claim handlers...");
    for(let claimHandler of claimHandlers) {
        await declareAndDeploy(claimHandler);
    }

    //Deploy refund handlers
    console.log("\n- Deploying refund handlers...");
    for(let refundHandler of refundHandlers) {
        await declareAndDeploy(refundHandler);
    }
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });