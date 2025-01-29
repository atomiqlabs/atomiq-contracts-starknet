use starknet::ContractAddress;

#[derive(Drop, starknet::Event)]
pub struct Initialize {
    #[key]
    pub offerer: ContractAddress,
    #[key]
    pub claimer: ContractAddress,
    #[key]
    pub claim_data: felt252,
    #[key]
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
    #[key]
    pub escrow_hash: felt252,

    //Witness result as returned by the claim handler
    pub witness_result: Span<felt252>
}

#[derive(Drop, starknet::Event)]
pub struct Refund {
    #[key]
    pub offerer: ContractAddress,
    #[key]
    pub claimer: ContractAddress,
    #[key]
    pub claim_data: felt252,
    #[key]
    pub escrow_hash: felt252,

    //Witness result as returned by the refund handler
    pub witness_result: Span<felt252>
}
