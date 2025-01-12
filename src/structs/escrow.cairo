use starknet::ContractAddress;
use core::hash::{Hash, HashStateTrait, HashStateExTrait};
use core::poseidon::PoseidonTrait;

impl Felt252SpanImpl<HashState, +HashStateTrait<HashState>, +Drop<HashState>> of Hash<Span<felt252>, HashState> {
    fn update_state(state: HashState, value: Span<felt252>) -> HashState {
        let mut result = state;
        for element in value {
            result = result.update(*element);
        };
        result
    }
}

impl ContractCallSpanImpl<HashState, +HashStateTrait<HashState>, +Drop<HashState>> of Hash<Span<ContractCall>, HashState> {
    fn update_state(state: HashState, value: Span<ContractCall>) -> HashState {
        let mut result = state;
        for element in value {
            result = result.update_with(*element);
        };
        result
    }
}

#[derive(Drop, Hash, Copy, Serde)]
pub struct ContractCall {
    pub address: ContractAddress,
    pub selector: felt252,
    pub calldata: Span<felt252>
}

#[derive(Drop, Hash, Copy, Serde)]
pub struct EscrowData {
    pub offerer: ContractAddress,
    pub claimer: ContractAddress,
    pub token: ContractAddress,
    pub refund_handler: ContractAddress,
    pub claim_handler: ContractAddress,

    pub flags: u128,

    pub claim_data: felt252,
    pub refund_data: felt252,

    pub amount: u256,

    pub fee_token: ContractAddress,
    pub security_deposit: u256,
    pub claimer_bounty: u256,

    pub success_action: Span<ContractCall>
}

#[generate_trait]
pub impl EscrowDataStructHash of EscrowDataStructHashTrait {
    fn get_struct_hash(self: EscrowData) -> felt252 {
        PoseidonTrait::new().update_with(self).finalize()
    }
}
