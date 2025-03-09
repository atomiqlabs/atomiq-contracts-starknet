# Execution contract

Starknet contract that allows scheduling external calls to be executed on behalf of a user for a reward. Any party can come and execute the actions on behalf of the owners and earn the posted fee for it.

## Scheduling executions

Users/contracts can schedule executions on behalf of other users (owners) by calling the create() function, this will transfer the required erc20 tokens + specified execution fee to the smart contract (from the caller - not from the specified owner). The action to be executed is intended to be transfered out of bound, with only the hash (execution_hash) stored on-chain.

## Executing

Any party can execute any scheduled execution and claim the fee for doing so.

## Refunding

It might happen that the specified action cannot be executed (i.e. costs infinite gas), or the specified execution fee is too little to cover the gas cost, such that no economically rational 3rd party executes it.

The owner can therefore refund at anytime, reclaiming the tokens + execution fee back to himself.

It is also possible to specify an expiry of the scheduled execution, once it passes anyone can refund the funds back to the owner, still however claiming the execution fee.
