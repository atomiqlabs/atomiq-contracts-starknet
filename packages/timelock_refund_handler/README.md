# Refund handler for timestamp based timelocks

## Provided data

Commitment/claim_data: C = u64 expiry timestamp encoded as felt252
Witness: W = empty

## Logic

Suceeds when the current block's timestamp is larger than the u64 expiry timestamp specified in commitment C.

