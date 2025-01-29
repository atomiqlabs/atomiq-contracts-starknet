use starknet::ContractAddress;
use openzeppelin_account::interface::{ISRC6Dispatcher, ISRC6DispatcherTrait};

//Verifies signatures as per SNIP6: https://github.com/starknet-io/SNIPs/blob/main/SNIPS/snip-6.md
pub fn verify_signature(signer: ContractAddress, hash: felt252, signature: Array<felt252>) {
    let dispatcher = ISRC6Dispatcher { contract_address: signer };
    let result = dispatcher.is_valid_signature(hash, signature);
    assert(result=='VALID' || result==1, 'verify_sig: Invalid response');
}
