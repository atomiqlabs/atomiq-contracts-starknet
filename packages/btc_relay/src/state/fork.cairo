use core::starknet::storage::Map;

#[starknet::storage_node]
pub struct Fork {
    pub chain: Map<felt252, felt252>,
    pub start_height: felt252
}
