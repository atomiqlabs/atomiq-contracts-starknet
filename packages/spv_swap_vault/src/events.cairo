use starknet::ContractAddress;

#[derive(Drop, starknet::Event)]
pub struct Claim {
    #[key]
    pub owner: ContractAddress,
    #[key]
    pub vault_id: ContractAddress,

    #[key]
    pub recipient: felt252,

    pub new_utxo: (u256, u32),

    pub amount_0: u256,
    pub amount_1: u256
}
