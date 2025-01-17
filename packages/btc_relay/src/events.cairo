use crate::structs::stored_blockheader::StoredBlockHeader;
use starknet::ContractAddress;

#[derive(Drop, starknet::Event)]
pub struct StoreHeader {
    #[key]
    pub commit_hash: felt252,
    #[key]
    pub block_hash_poseidon: felt252, //Blockhash hashed with Poseidon

    pub header: StoredBlockHeader
}

#[derive(Drop, starknet::Event)]
pub struct StoreForkHeader {
    #[key]
    pub fork_id: felt252,
    #[key]
    pub commit_hash: felt252,
    #[key]
    pub block_hash_poseidon: felt252, //Blockhash hashed with Poseidon

    pub header: StoredBlockHeader
}

#[derive(Drop, starknet::Event)]
pub struct ChainReorg {
    #[key]
    pub fork_submitter: ContractAddress,
    #[key]
    pub fork_id: felt252,
    #[key]
    pub tip_block_hash_poseidon: felt252,
    #[key]
    pub tip_commit_hash: felt252,

    pub start_height: felt252
}
