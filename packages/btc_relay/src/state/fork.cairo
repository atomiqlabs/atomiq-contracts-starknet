use core::starknet::storage::Map;

//Storing data about persisted long forks
#[starknet::storage_node]
pub struct Fork {
    pub chain: Map<felt252, felt252>,
    pub start_height: felt252,
    pub tip_height: felt252
}
