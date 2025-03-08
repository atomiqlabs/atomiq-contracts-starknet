
## Tests

#### Create

- (success) create valid (event emitted, state saved, erc20 transfered)
- (fail) create execution hash 0
- (fail) create already initiated
- (fail) create not enough funds
- (fail) create not enough allowance

#### Execute

- (success) execution success, clear_all=false
- (success) execution success, clear_all=true
- (success) execution failed, clear_all=false
- (success) execution failed, clear_all=true
- (fail) already processed
- (fail) invalid calls/drain tokens passed

#### Refund expired

- (success) refund valid, clear_all=false
- (success) refund valid, clear_all=true
- (fail) not expired yet
- (fail) already processed

#### Refund
- (success) refund valid, clear_all=false
- (success) refund valid, clear_all=true
- (fail) already processed
