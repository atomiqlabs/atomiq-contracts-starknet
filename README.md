# atomiq.exchange Starknet contracts

atomiq.exchange enables trustless swaps between smart chains (chains supporting complex smart contracts - Solana, EVM, Starknet, etc.) and Bitcoin (both on-chain - L1 and lightning network - L2). On-chain swaps are based on an escrow system (similar to atomic swaps) and utilize [permissionless bitcoin light clients](/packages/btc_relay) deployed on smart chains to secure swaps. Lightning network swaps use HTLC atomic swaps. Please refer to our [docs](https://docs.atomiq.exchange/) for detailed system overview.

## Contracts structure

### Escrow manager

Manages initialization, claiming & refunds of swap escrows, LP vaults & reputation tracking:
- Escrow - structure holding funds, can be claimed by __claimer__ (the intended recipient of the escrow funds) upon satisfying the conditions as set in the __claim handler__ (external contract) used for the escrow & can be refunded by the __offerer__ (who funded the escrow), upon satisfying the conditions as set in the __refund handler__ (external contract) used in the escrow. Escrow can also be cooperatively closed with the __claimer__'s signature, immediately returning funds to __offerer__ and skipping refund handler verification.
- LP vault - funds deposited into the smart contract by the LPs (intermediary nodes), that can be used for swaps
- Reputation tracking - the contract tracks count & volume of swaps with a specific outcome (success, failed, cooperative_close), enabling users to identify LPs that fail to process swaps often.

### Claim handlers

Set the conditions that need to be satisfied by the __claimer__ before they are able to claim the swap funds. The escrow contains the address of a specific claim handler to be used, along with a commitment to the conditions that need to be satisified. In order to claim the __claimer__ provides a witness that satisfies the conditions set forth by the claim handler.

### Refund handlers

Set the conditions that need to be satisfied by the __offerer__ before they are able to refund the swap funds. The escrow contains the address of a specific refund handler to be used, along with a commitment to the conditions that need to be satisified. In order to refund the __offerer__ provides a witness that satisfies the conditions set forth by the refund handler.

## Contents

### Libraries

- [`/packages/common`](/packages/common) - common (claim & refund handler interfaces)
- [`/packages/btc_utils`](/packages/btc_utils) - bitcoin utilities (bitcoin SPV merkle tree verification & transaction parsing)
- [`/packages/erc20_utils`](/packages/erc20_utils) - erc20 utilities (transfer from, transfer & balance)

### Smart contracts

- [`/packages/btc_relay`](/packages/btc_relay) - bitcoin relay (bitcoin SPV light client)
- [`/packages/escrow_manager`](/packages/escrow_manager) - escrow manager (handling swap escrows, lp vaults & reputation)
- Refund handlers:
    - [`/packages/timelock_refund_handler`](/packages/timelock_refund_handler) - allows refund after a specifed timestamp, used by all current swaps.
- Claim handlers:
    - [`/packages/hashlock_claim_handler`](/packages/hashlock_claim_handler) - claim based on the knowledge of a secret preimage of a sha256 hash, __BTC (lightning) -> SC__ & __SC -> BTC (lightning)__ swaps.
    - [`/packages/btc_txid_claim_handler`](/packages/btc_txid_claim_handler) - claim based on the confirmation of a specific transaction id on the bitcoin chain, as verified through the btc_relay contract, currently not used, future uses include ordinals/runes/rgb/taro swaps.
    - [`/packages/btc_output_claim_handler`](/packages/btc_output_claim_handler) - claim based on the confirmation of a transaction containing a pre-specified output script & amount on the bitcoin chain, as verified through the btc_relay contract, used for __BTC (on-chain) -> SC__ swaps.
    - [`/packages/btc_nonced_output_claim_handler`](/packages/btc_nonced_output_claim_handler) - claim based on the confirmation of a transaction containing a pre-specified output script & amount + pre-specified nonce (a combination of transaction's timelock & input's nSequence) on the bitcoin chain, as verified through the btc_relay contract, used for __SC -> BTC (on-chain)__ swaps.

## Tests

In order to test the contracts simply run `scarb test`, this will first run the scripts to generate the test data and then use snforge to test all the contracts and libraries.
