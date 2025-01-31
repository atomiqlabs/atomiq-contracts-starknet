const crypto = require("crypto");
const starknet = require("starknet");

const StarknetDomain = [
    { name: 'name', type: 'shortstring' },
    { name: 'version', type: 'shortstring' },
    { name: 'chainId', type: 'shortstring' },
    { name: 'revision', type: 'shortstring' },
];
const Initialize = [
    { name: 'Swap hash', type: 'felt' },
    { name: 'Timeout', type: 'timestamp' }
];
const Refund = [
    { name: 'Swap hash', type: 'felt' },
    { name: 'Timeout', type: 'timestamp' }
];

const domain = {
    name: 'atomiq.exchange', // put the name of your dapp to ensure that the signatures will not be used by other DAPP
    version: '1',
    chainId: 'SN_SEPOLIA', // shortString of 'SN_SEPOLIA' (or 'SN_MAIN'), to be sure that signature can't be used by other network.
    revision: '1'
}

const InitType = {
    types: {
        StarknetDomain,
        Initialize,
    },
    primaryType: 'Initialize',
    domain
};

const RefundType = {
    types: {
        StarknetDomain,
        Refund,
    },
    primaryType: 'Refund',
    domain
};

function getInitHashTest(swapHash, timeout, signer) {
    const data = {"Swap hash": "0x"+swapHash.toString("hex"), "Timeout": "0x"+timeout.toString("hex")};
    // console.log(starknet.typedData.getStructHash({Initialize}, "Initialize", data, '1'));
    
    const hash = starknet.typedData.getMessageHash({...InitType, message: data}, signer);
    return "assert_eq!(get_init_sighash(0x"+swapHash.toString("hex")+", 0x"+timeout.toString("hex")+", "+signer+".try_into().unwrap()), "+hash+");\n";
}

function getRandomInitTest() {
    const signer = starknet.stark.randomAddress();
    const timeout = crypto.randomBytes(8);
    const swapHash = crypto.randomBytes(31);
    
    return getInitHashTest(swapHash, timeout, signer);
}

function getRefundHashTest(swapHash, timeout, signer) {
    const data = {"Swap hash": "0x"+swapHash.toString("hex"), "Timeout": "0x"+timeout.toString("hex")};
    // console.log(starknet.typedData.getStructHash({Initialize}, "Initialize", data, '1'));
    
    const hash = starknet.typedData.getMessageHash({...RefundType, message: data}, signer);
    return "assert_eq!(get_refund_sighash(0x"+swapHash.toString("hex")+", 0x"+timeout.toString("hex")+", "+signer+".try_into().unwrap()), "+hash+");\n";
}

function getRandomRefundTest() {
    const signer = starknet.stark.randomAddress();
    const timeout = crypto.randomBytes(8);
    const swapHash = crypto.randomBytes(31);
    
    return getRefundHashTest(swapHash, timeout, signer);
}

// console.log(starknet.typedData.getTypeHash({StarknetDomain}, "StarknetDomain", '1'));
// console.log(starknet.typedData.getStructHash({StarknetDomain}, "StarknetDomain", domain, '1'));

// console.log(starknet.typedData.getTypeHash({Initialize}, "Initialize", '1'));

const numTests = 10;
for(let i=0;i<numTests;i++) { 
    console.log(getRandomInitTest());
}

for(let i=0;i<numTests;i++) { 
    console.log(getRandomRefundTest());
}
