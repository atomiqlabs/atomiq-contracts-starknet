use openzeppelin_utils::snip12::OffchainMessageHash;
use core::starknet::ContractAddress;
use core::poseidon::PoseidonTrait;
use core::hash::{HashStateTrait, HashStateExTrait};
use openzeppelin_utils::snip12::{StructHash, SNIP12Metadata};
use crate::structs::escrow::{EscrowData, EscrowDataImplTrait, EscrowExecutionImplTrait};

impl SNIP12MetadataImpl of SNIP12Metadata {
    fn name() -> felt252 { 'atomiq.exchange' }
    fn version() -> felt252 { 1 }
}

const INITIALIZE_STRUCT_TYPE_HASH: felt252 =
    selector!("\"Initialize\"(\"Swap hash\":\"felt\",\"Offerer\":\"ContractAddress\",\"Claimer\":\"ContractAddress\",\"Token amount\":\"TokenAmount\",\"Pay in\":\"bool\",\"Pay out\":\"bool\",\"Tracking reputation\":\"bool\",\"Claim handler\":\"ContractAddress\",\"Claim data\":\"felt\",\"Refund handler\":\"ContractAddress\",\"Refund data\":\"felt\",\"Security deposit\":\"TokenAmount\",\"Claimer bounty\":\"TokenAmount\",\"Claim action hash\":\"felt\",\"Deadline\":\"timestamp\")\"TokenAmount\"(\"token_address\":\"ContractAddress\",\"amount\":\"u256\")\"u256\"(\"low\":\"u128\",\"high\":\"u128\")");

const U256_TYPE_HASH: felt252 =
    selector!("\"u256\"(\"low\":\"u128\",\"high\":\"u128\")");

fn u256_tagged_hash(value: u256) -> felt252 {
    PoseidonTrait::new().update(U256_TYPE_HASH).update_with(value).finalize()
}

const TOKEN_AMOUNT_TYPE_HASH: felt252 =
    selector!("\"TokenAmount\"(\"token_address\":\"ContractAddress\",\"amount\":\"u256\")\"u256\"(\"low\":\"u128\",\"high\":\"u128\")");

fn token_amount_tagged_hash(token: ContractAddress, value: u256) -> felt252 {
    PoseidonTrait::new().update(TOKEN_AMOUNT_TYPE_HASH).update_with(token).update(u256_tagged_hash(value)).finalize()
}

#[derive(Drop, Copy)]
struct InitializeStruct {
    escrow: EscrowData, 
    escrow_hash: felt252, 
    timeout: u64
}

impl InitializeStructHashImpl of StructHash<InitializeStruct> {
    fn hash_struct(self: @InitializeStruct) -> felt252 {
        let hash_state = PoseidonTrait::new();
        hash_state.update(INITIALIZE_STRUCT_TYPE_HASH)
            .update(*self.escrow_hash)
            .update_with(*self.escrow.offerer)
            .update_with(*self.escrow.claimer)
            .update(token_amount_tagged_hash(*self.escrow.token, *self.escrow.amount))
            .update_with((*self.escrow).is_pay_in())
            .update_with((*self.escrow).is_pay_out())
            .update_with((*self.escrow).is_tracking_reputation())
            .update_with(*self.escrow.claim_handler)
            .update_with(*self.escrow.claim_data)
            .update_with(*self.escrow.refund_handler)
            .update_with(*self.escrow.refund_data)
            .update(token_amount_tagged_hash(*self.escrow.fee_token, *self.escrow.security_deposit))
            .update(token_amount_tagged_hash(*self.escrow.fee_token, *self.escrow.claimer_bounty))
            .update(if self.escrow.success_action.is_some() {
                (*self.escrow.success_action).unwrap().get_struct_hash()
            } else { 0 })
            .update_with(*self.timeout)
            .finalize()
    }
}

//Computes the init message sighash
pub fn get_init_sighash(escrow: EscrowData, escrow_hash: felt252, timeout: u64, signer: ContractAddress) -> felt252 {
    InitializeStruct {
        escrow,
        escrow_hash,
        timeout: timeout.into()
    }.get_message_hash(signer)
}

const REFUND_STRUCT_TYPE_HASH: felt252 =
    selector!("\"Refund\"(\"Swap hash\":\"felt\",\"Timeout\":\"timestamp\")");

#[derive(Drop, Copy, Hash)]
struct RefundStruct {
    escrow_hash: felt252,
    timeout: u128
}

impl RefundStructHashImpl of StructHash<RefundStruct> {
    fn hash_struct(self: @RefundStruct) -> felt252 {
        let hash_state = PoseidonTrait::new();
        hash_state.update_with(REFUND_STRUCT_TYPE_HASH).update_with(*self).finalize()
    }
}

//Computes the refund message sighash
pub fn get_refund_sighash(escrow_hash: felt252, timeout: u64, signer: ContractAddress) -> felt252 {
    RefundStruct {
        escrow_hash: escrow_hash,
        timeout: timeout.into()
    }.get_message_hash(signer)
}
