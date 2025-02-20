# Escrow manager

Smart contract managing escrows (initialization, claiming, refunding and cooperative refunding), LP vaults & tracks reputation of LPs.

The provided functionalities are self-contained inside their own components ([`/src/components`](/src/components)).

## Execution proxy

Since escrows enable the possibility to execute an arbitrary contract call on claim (a claim hook) we need to make sure that the call is not executed on the main escrow manager contract (which might lead to draining of LP vault & escrow funds). To accomplish this we deploy a separate execution proxy ([`/src/execution_proxy.cairo`](/src/execution_proxy.cairo)) contract, fund it with escrow funds first, and then execute the claim action (a claim hook) from that contract using safe dispatcher. Regardless of the hook success/panic we reclaim the balance that was left in the execution proxy and pay it back to claimer as usual.

