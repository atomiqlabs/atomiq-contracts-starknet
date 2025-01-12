use starknet::ContractAddress;

#[derive(Drop, starknet::Event)]
pub struct Initialize {
    #[key]
    pub offerer: ContractAddress,
    #[key]
    pub claimer: ContractAddress,
    #[key]
    pub claim_data: felt252,
    pub escrow_hash: felt252
}

#[derive(Drop, starknet::Event)]
pub struct Claim {
    #[key]
    pub offerer: ContractAddress,
    #[key]
    pub claimer: ContractAddress,
    #[key]
    pub claim_data: felt252,
    pub escrow_hash: felt252,

    pub witness_result: ByteArray
}

#[derive(Drop, starknet::Event)]
pub struct Refund {
    #[key]
    pub offerer: ContractAddress,
    #[key]
    pub claimer: ContractAddress,
    #[key]
    pub claim_data: felt252,
    pub escrow_hash: felt252,

    pub witness_result: ByteArray
}
