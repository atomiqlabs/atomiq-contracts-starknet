use starknet::ContractAddress;

use crate::utils::SpanHashImpl;

#[derive(Drop, Hash, Copy, Serde, Debug)]
pub struct ContractCall {
    pub address: ContractAddress,
    pub entrypoint: felt252,
    pub calldata: Span<felt252>
}
