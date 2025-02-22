# Claim handler for bitcoin chain txId

## Provided data

Commitment/claim_data: C = poseidon hash of the commitment struct
```
{
    pub reversed_tx_id: [u32; 8],
    pub confirmations: u32,
    pub btc_relay_contract: ContractAddress
}
```

Witness: W = witness struct
```
{
    pub commitment: {
	    pub reversed_tx_id: [u32; 8],
	    pub confirmations: u32,
	    pub btc_relay_contract: ContractAddress
	},
    pub blockheader: StoredBlockHeader,
    pub merkle_proof: Span<[u32; 8]>,
    pub position: u32
}
```

## Logic

Suceeds if:
- the commitment specified in the witness W, correctly hashes to the commitment C, poseidon(W)==C
- stored __blockheader__ is part of the cannonical chain in the __btc_relay_contract__ smart contract and has at least __confirmations__ as specified in the witness struct
- the __reversed_tx_id__ is included in the blockheader as verified with the __merkle_proof__
