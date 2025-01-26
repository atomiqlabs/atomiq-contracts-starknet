use openzeppelin_utils::snip12::OffchainMessageHash;
use core::starknet::ContractAddress;
use core::poseidon::PoseidonTrait;
use core::hash::{HashStateTrait, HashStateExTrait};
use openzeppelin_utils::snip12::{StructHash, SNIP12Metadata};

impl SNIP12MetadataImpl of SNIP12Metadata {
    fn name() -> felt252 { 'atomiq.exchange' }
    fn version() -> felt252 { '1' }
}

const INITIALIZE_STRUCT_TYPE_HASH: felt252 =
    selector!("\"Initialize\"(\"Swap hash\":\"felt\",\"Timeout\":\"timestamp\")");

#[derive(Drop, Copy, Hash)]
struct InitializeStruct {
    escrow_hash: felt252,
    timeout: u64
}

impl InitializeStructHashImpl of StructHash<InitializeStruct> {
    fn hash_struct(self: @InitializeStruct) -> felt252 {
        let hash_state = PoseidonTrait::new();
        hash_state.update_with(INITIALIZE_STRUCT_TYPE_HASH).update_with(*self).finalize()
    }
}

pub fn get_init_sighash(escrow_hash: felt252, timeout: u64, signer: ContractAddress) -> felt252 {
    InitializeStruct {
        escrow_hash: escrow_hash,
        timeout: timeout
    }.get_message_hash(signer)
}

const REFUND_STRUCT_TYPE_HASH: felt252 =
    selector!("\"Refund\"(\"Swap hash\":\"felt\",\"Timeout\":\"timestamp\")");

#[derive(Drop, Copy, Hash)]
struct RefundStruct {
    escrow_hash: felt252,
    timeout: u64
}

impl RefundStructHashImpl of StructHash<RefundStruct> {
    fn hash_struct(self: @RefundStruct) -> felt252 {
        let hash_state = PoseidonTrait::new();
        hash_state.update_with(REFUND_STRUCT_TYPE_HASH).update_with(*self).finalize()
    }
}

pub fn get_refund_sighash(escrow_hash: felt252, timeout: u64, signer: ContractAddress) -> felt252 {
    RefundStruct {
        escrow_hash: escrow_hash,
        timeout: timeout
    }.get_message_hash(signer)
}

//TODO: Add unit tests for sighashes
