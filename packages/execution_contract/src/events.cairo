use starknet::ContractAddress;

#[derive(Drop, starknet::Event)]
pub struct ExecutionCreated {
    #[key]
    pub owner: ContractAddress,
    #[key]
    pub salt: felt252,
    #[key]
    pub execution_hash: felt252,

    pub token: ContractAddress,
    pub amount: u256,
    pub expiry: u64,
    pub execution_fee_share: u16
}

#[derive(Drop, starknet::Event)]
pub struct ExecutionProcessed {
    #[key]
    pub owner: ContractAddress,
    #[key]
    pub salt: felt252,
    #[key]
    pub execution_hash: felt252,

    pub error: Span<felt252>,
    pub success: bool
}
