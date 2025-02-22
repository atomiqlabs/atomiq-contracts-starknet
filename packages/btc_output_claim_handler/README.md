# Claim handler for bitcoin chain output

## Provided data

Commitment/claim_data: C = poseidon hash of the commitment struct
```
{
    pub txo_hash: felt252, //Hash of poseidon([output_amount, poseidon(to_bytes31_array(output_script))])
    pub confirmations: u32,
    pub btc_relay_contract: ContractAddress
}
```

Witness: W = witness struct
```
{
    pub commitment: {
        pub txo_hash: felt252, //Hash of poseidon([output_amount, poseidon(to_bytes31_array(output_script))])
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
- the __transaction__ contains valid output at the specified __vout__ index, such that poseidon([output_amount, poseidon(to_bytes31_array(output_script))])==__txo_hash__
