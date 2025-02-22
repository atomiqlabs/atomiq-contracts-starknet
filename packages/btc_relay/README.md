# Bitcoin SPV starknet contract

This project is heavily inspired by:
- https://github.com/crossclaim/btcrelay-sol
- https://github.com/ethereum/btcrelay

Bitcoin relay is an on-chain program used to verify and store bitcoin blockheaders. This program is completely permissionless and trustless, anyone can write blockheaders as their validity is verified on-chain.

## Verification
Program checks bitcoin blockheader consensus rules:
- correct PoW difficulty target
- possible difficulty adjustments
- previous block hash
- blockhash is lower than target (block's PoW)
- timestamp is > median of last 11 blocks
- timestamp is < current time + 4 hours (this is usually 2 hours in bitcoind, but extended to 4 hours to allow for some timestamp skew on-chain)

## Storage
To save on storage costs, the blockheader data is emitted as an Event from the program, and only poseidon hash fingerprint of that blockheader data is stored on-chain in a mapping.

## Transaction verification
As merkle roots of the bitcoin blocks from blockheaders are known, they can be used to verify that any transaction was included in a block by its transaction id and merkle proof. The transaction verification is not in scope for this package and is handled by claim handlers separately.

## Forks
Should a fork on the bitcoin main chain occur, the program provides a way for anyone to submit fork blockheaders, and they automatically become the main chain when their chain work is greater than that of a current main chain in the bitcoin relay program.
This can be done in 2 ways, because of Starknet's transaction calldata size limits:
- smaller forks of <~25 blocks can be submitted in a single transaction
- larger forks of >=25 blocks must be submitted in multiple transactions by storing the blockheaders in a temporary mapping on-chain and then copying it to the main chain state when the fork's chainwork exceeds the main chain's chainwork.

## Possible attack vectors

### Fake block headers
A party might start submitting valid bitcoin blockheaders to the bitcoin relay and not on the bitcoin main chain. However as those blockheaders must be valid a non-trivial amount of resources must be expedited on PoW. Cost of such an attack depends on whether there is at least 1 honest party submitting blockheaders to the relay:
- if there are no honest parties, the cost of faking 1 blockheader can be expressed as value of lost bitcoin block reward incurred due to not submitting the blockheader to the main chain, which is currently 3.125 BTC ~ 300k usd
- if there is at least 1 honest party, submitting valid blockheaders from the mainchain, the adversary party needs to capture at least 51% of the bitcoin hashing power to overrun the honest chain submitted by honest party

## Tests

There are nodejs scripts that generate blockheaders for the integration tests of the contract located in the repo root's `scripts/` directory. These are automatically ran when testing the workspace with `scarb test`.

List of tests:
- Positive (should succeed)
    - Submit main chain blockheaders
    - Submit main chain blockheaders with difficulty adjustment
    - (short fork) Fork off from main chain
    - (short fork) Fork off from main chain with shorter fork, but with higher total chainwork
    - (long fork) Fork off from main chain
    - (long fork) Fork off from main chain with shorter fork, but with higher total chainwork
- Negative (should fail)
    - Submit main chain but StoredBlockHeader not committed
    - Submit main chain but StoredBlockHeader is not the tip
    - (short fork) Fork off but StoredBlockHeader not committed
    - (long fork) Fork off but initial StoredBlockHeader not committed
    - (long fork) Use StoredBlockHeader that is not committed in the already created long fork
    - (short fork) Try to fork off, but fork doesn't have more chainwork than canonical chain
    - (short fork) Try to fork off, but fork doesn't have more chainwork than canonical chain, even though it is longer
    - Invalid block PoW (hash not lower than target)
    - Invalid block nbits (wrong target calculated)
    - Invalid block nbits during difficulty adjustment
    - Invalid previous blockhash
    - Block timestamp is not higher than median of last 11 blocks
    - Block timestamp is from the future
- Noop (shouldn't modify the cannonical chain)
    - (long fork) Try to fork off, but fork doesn't have more chainwork than canonical chain
    - (long fork) Try to fork off, but fork doesn't have more chainwork than canonical chain, even though it is longer
