use starknet::ContractAddress;

#[derive(Drop, starknet::Event)]
pub struct Opened {
    #[key]
    pub btc_tx_hash: u256,
    #[key]
    pub owner: ContractAddress,
    #[key]
    pub vault_id: felt252,
    
    #[key]
    pub vout: u32
}

#[derive(Drop, starknet::Event)]
pub struct Deposited {
    #[key]
    pub owner: ContractAddress,
    #[key]
    pub vault_id: felt252,

    pub amounts: (u64, u64),
}

#[derive(Drop, starknet::Event)]
pub struct Claimed {
    #[key]
    pub btc_tx_hash: u256,

    #[key]
    pub owner: ContractAddress,
    #[key]
    pub vault_id: felt252,

    #[key]
    pub recipient: ContractAddress,
    #[key]
    pub execution_hash: felt252,

    #[key]
    pub caller: ContractAddress,

    pub amounts: (u64, u64),

    pub fronting_address: ContractAddress
}

#[derive(Drop, starknet::Event)]
pub struct Closed {
    #[key]
    pub btc_tx_hash: u256,
    
    #[key]
    pub owner: ContractAddress,
    #[key]
    pub vault_id: felt252,

    pub error: felt252,
}

#[derive(Drop, starknet::Event)]
pub struct Fronted {
    #[key]
    pub btc_tx_hash: u256,

    #[key]
    pub owner: ContractAddress,
    #[key]
    pub vault_id: felt252,

    #[key]
    pub recipient: ContractAddress,
    #[key]
    pub execution_hash: felt252,

    #[key]
    pub caller: ContractAddress,

    pub amounts: (u64, u64)
}
