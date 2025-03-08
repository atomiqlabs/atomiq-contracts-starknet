
## Tests

#### Open:

- (success) open (event emitted, state saved)
- (success) open previously closed (event emitted, state saved)
- (fail) open already opened

#### Deposit:

- (success) deposit (event emitted, state saved, erc20 transfered)
- (success) deposit multiple (event emitted, state saved, erc20 transfered)
- (fail) deposit not enough funds
- (fail) deposit not enough allowance
- (fail) deposit not opened

#### Front:

- (success) front with exec_hash = 0 (event emitted, state saved, erc20 transfered)
- (success) front with exec_hash != 0 (event emitted, state saved, erc20 transfered)
- (fail) front vault not opened
- (fail) front already fronted
- (fail) front not enough funds
- (fail) front not enough allowance

#### Claim:

- (success) claim with exec_hash = 0, token0 (event emitted, state saved, erc20 transfered)
- (success) claim with exec_hash = 0, token0 & token1 (event emitted, state saved, erc20 transfered)
- (success) claim with exec_hash != 0, token0 (event emitted, state saved, erc20 transfered)
- (success) claim with exec_hash != 0, token0 & token1 (event emitted, state saved, erc20 transfered)
- (success) fronted claim with exec_hash = 0, token0 (event emitted, state saved, erc20 transfered)
- (success) fronted claim with exec_hash = 0, token0 & token1 (event emitted, state saved, erc20 transfered)
- (success) fronted claim with exec_hash != 0, token0 (event emitted, state saved, erc20 transfered)
- (success) fronted claim with exec_hash != 0, token0 & token1 (event emitted, state saved, erc20 transfered)
- (fail) claim closed vault
- (fail) claim btc tx decode (garbage data)
- (fail) claim btc tx incorrect tx input 0
- (fail) claim btc tx invalid merkle proof
- (fail) claim btc tx not enough confirmations
- (close) claim btc tx incorrect format (tx_data: output 1 not found)
- (close) claim btc tx incorrect format (tx_data: output 1 empty script)
- (close) claim btc tx incorrect format (tx_data: output 1 not OP_RETURN)
- (close) claim btc tx incorrect format (tx_data: input 1 not found)
- (close) claim btc tx incorrect format (tx_data: output 1 invalid len)
- (close) claim btc tx incorrect format (tx_data: invalid recipient)
- (close) claim btc tx incorrect format (tx_data: caller fee 0)
- (close) claim btc tx incorrect format (tx_data: fronting fee 0)
- (close) claim btc tx incorrect format (tx_data: execution fee 0)
- (close) claim btc tx incorrect format (tx_data: caller fee 1)
- (close) claim btc tx incorrect format (tx_data: fronting fee 1)
- (close) claim btc tx amounts overflow (get_full_amts: amt0-0)
- (close) claim btc tx amounts overflow (get_full_amts: amt0-1)
- (close) claim btc tx amounts overflow (get_full_amts: amt0-2)
- (close) claim btc tx amounts overflow (get_full_amts: amt1-0)
- (close) claim btc tx amounts overflow (get_full_amts: amt1-1)
- (close) claim withdraw too much (withdraw: amount 0)
- (close) claim withdraw too much (withdraw: amount 1)
- (close) claim btc tx multiplier overflow token0 (parse_and_wthdrw: u256 overflow)
- (close) claim btc tx multiplier overflow token1 (parse_and_wthdrw: u256 overflow)
