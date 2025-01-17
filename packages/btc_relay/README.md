# Bitcoin SPV starknet contract

## Tests

There are nodejs scripts that generate blockheaders for the integration tests of the contract located in `scripts/` directory. These are automatically ran when testing with `scarb test`.

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
