# Claim handler for bitcoin chain nonced output

## Nonce

A nonce in this context is derived from the the transaction's timelock & input nSequences:
- nonce n is computed as n = ((locktime - 500,000,000) << 24) | (nSequence & 0x00FFFFFF)
- the last 3 bytes of the nSequence need to be the same for every input in the transaction
- first 4 bits of the nSequence need to be set for every input (ensuring nSequence has no consensus meaning)

## Provided data

Commitment/claim_data: C = poseidon hash of the commitment struct
```
{
    pub txo_hash: felt252, //Hash of poseidon([nonce, output_amount, poseidon(to_bytes31_array(output_script))])
    pub confirmations: u32,
    pub btc_relay_contract: ContractAddress
}
```

Witness: W = witness struct
```
{
    pub commitment: {
        pub txo_hash: felt252, //Hash of poseidon([nonce, output_amount, poseidon(to_bytes31_array(output_script))])
        pub confirmations: u32,
        pub btc_relay_contract: ContractAddress
    },
    pub blockheader: StoredBlockHeader,
    pub merkle_proof: Span<[u32; 8]>,
    pub position: u32,
    pub transaction: ByteArray,
    pub vout: u32
}
```

## Logic

Suceeds if:
- the commitment specified in the witness W, correctly hashes to the commitment C, poseidon(W)==C
- stored __blockheader__ is part of the cannonical chain in the __btc_relay_contract__ smart contract and has at least __confirmations__ as specified in the witness struct
- the provided __transaction__'s transaction ID is included in the blockheader as verified with the __merkle_proof__
- the __transaction__ contains valid output at the specified __vout__ index and a valid nonce, such that poseidon([nonce, output_amount, poseidon(to_bytes31_array(output_script))])==__txo_hash__
