# Claim handler for hashlocks

## Provided data

Commitment/claim_data: C = Poseidon hash of [u32; 8] representation of the sha256 hash
Witness: W = [u32, 8] representation of the preimage to the sha256 hash

## Logic

Suceeds when the provided witness W properly hashes to commitment C, such that poseidon(sha256(W))==C
