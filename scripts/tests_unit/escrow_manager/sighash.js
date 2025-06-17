const crypto = require("crypto");
const starknet = require("starknet");
const { toCairoStruct } = require("../../utils/cairo_structs");

const StarknetDomain = [
    { name: 'name', type: 'shortstring' },
    { name: 'version', type: 'shortstring' },
    { name: 'chainId', type: 'shortstring' },
    { name: 'revision', type: 'shortstring' },
];
const Initialize = [
    { name: 'Swap hash', type: 'felt' },
    { name: 'Offerer', type: 'ContractAddress'},
    { name: 'Claimer', type: 'ContractAddress'},
    { name: 'Token amount', type: 'TokenAmount'},
    { name: 'Pay in', type: 'bool'},
    { name: 'Pay out', type: 'bool'},
    { name: 'Tracking reputation', type: 'bool'},
    { name: 'Claim handler', type: 'ContractAddress'},
    { name: 'Claim data', type: 'felt'},
    { name: 'Refund handler', type: 'ContractAddress'},
    { name: 'Refund data', type: 'felt'},
    { name: 'Security deposit', type: 'TokenAmount'},
    { name: 'Claimer bounty', type: 'TokenAmount'},
    { name: 'Claim action hash', type: 'felt'},
    { name: 'Deadline', type: 'timestamp' }
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

function getInitHashTest(swapEscrow, swapHash, timeout, signer) {
    const data = {
        "Swap hash": "0x"+swapHash.toString("hex"),
        "Offerer": swapEscrow.offerer,
        "Claimer": swapEscrow.claimer,
        "Token amount": {
            token_address: swapEscrow.token,
            amount: starknet.cairo.uint256(swapEscrow.amount)
        },
        "Pay in": (swapEscrow.flags & 0b010n) === 0b010n,
        "Pay out": (swapEscrow.flags & 0b001n) === 0b001n,
        "Tracking reputation": (swapEscrow.flags & 0b100n) === 0b100n,
        "Refund handler": swapEscrow.refund_handler,
        "Claim handler": swapEscrow.claim_handler,
        "Claim data": swapEscrow.claim_data,
        "Refund data": swapEscrow.refund_data,
        "Security deposit": {
            token_address: swapEscrow.fee_token,
            amount: starknet.cairo.uint256(swapEscrow.security_deposit)
        },
        "Claimer bounty": {
            token_address: swapEscrow.fee_token,
            amount: starknet.cairo.uint256(swapEscrow.claimer_bounty)
        },
        "Claim action hash": 0,
        "Deadline": "0x"+timeout.toString("hex")
    };
    // console.log(starknet.typedData.getStructHash({Initialize}, "Initialize", data, '1'));
    // console.log(data);
    // console.log(starknet.typedData.encodeType({Initialize}, "Initialize", '1'));
    // console.log(starknet.typedData.getTypeHash({Initialize}, "Initialize", '1'));
    
    const hash = starknet.typedData.getMessageHash({...InitType, message: data}, signer);
    swapEscrow.offerer += ".try_into().unwrap()";
    swapEscrow.claimer += ".try_into().unwrap()";
    swapEscrow.token += ".try_into().unwrap()";
    swapEscrow.claim_handler += ".try_into().unwrap()";
    swapEscrow.refund_handler += ".try_into().unwrap()";
    swapEscrow.fee_token += ".try_into().unwrap()";
    return "let escrow = "+toCairoStruct("EscrowData", swapEscrow)+";\n"+
        "assert_eq!(get_init_sighash(escrow, 0x"+swapHash.toString("hex")+", 0x"+timeout.toString("hex")+", "+signer+".try_into().unwrap()), "+hash+");\n";
}

function getRandomInitTest() {
    const signer = starknet.stark.randomAddress();
    const timeout = crypto.randomBytes(8);
    const swapHash = crypto.randomBytes(31);

    const escrowData = {
        offerer: starknet.stark.randomAddress(),
        claimer: starknet.stark.randomAddress(),
        token: starknet.stark.randomAddress(),
        refund_handler: starknet.stark.randomAddress(),
        claim_handler: starknet.stark.randomAddress(),
        flags: BigInt("0x"+crypto.randomBytes(16).toString("hex")),
        claim_data: "0x"+crypto.randomBytes(31).toString("hex"),
        refund_data: "0x"+crypto.randomBytes(31).toString("hex"),
        amount: "0x"+crypto.randomBytes(32).toString("hex"),
        fee_token: starknet.stark.randomAddress(),
        security_deposit: "0x"+crypto.randomBytes(32).toString("hex"),
        claimer_bounty: "0x"+crypto.randomBytes(32).toString("hex"),
        success_action: "Option::None"
    };
    
    return getInitHashTest(escrowData, swapHash, timeout, signer);
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
