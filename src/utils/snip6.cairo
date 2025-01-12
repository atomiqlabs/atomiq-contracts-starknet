use starknet::ContractAddress;
use openzeppelin_account::interface::{ISRC6Dispatcher, ISRC6DispatcherTrait};

pub fn verify_signature(signer: ContractAddress, hash: felt252, signature: Array<felt252>) {
    let dispatcher = ISRC6Dispatcher { contract_address: signer };
    let result = dispatcher.is_valid_signature(hash, signature);
    assert(result=='VALID' || result==1, 'verify_sig: Invalid response');
}
