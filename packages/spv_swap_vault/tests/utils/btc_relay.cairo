use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait
};
use starknet::contract_address::{ContractAddress};

use btc_relay::structs::stored_blockheader::StoredBlockHeader;
use btc_relay::structs::blockheader::BlockHeader;

use core::sha256::{compute_sha256_u32_array};

//Hashes left and right leaf of the merkle tree
fn hash(left: [u32; 8], right: [u32; 8]) -> [u32; 8] {
    let left_span = left.span();
    let right_span = right.span();
    let result = compute_sha256_u32_array(array![
        *left_span[0], *left_span[1], *left_span[2], *left_span[3], *left_span[4], *left_span[5], *left_span[6], *left_span[7],
        *right_span[0], *right_span[1], *right_span[2], *right_span[3], *right_span[4], *right_span[5], *right_span[6], *right_span[7],
    ], 0, 0).span();
    compute_sha256_u32_array(array![
        *result[0], *result[1], *result[2], *result[3], *result[4], *result[5], *result[6], *result[7]
    ], 0, 0)
}

pub fn deploy_btc_relay(stored_header: StoredBlockHeader, block_height: u32) -> ContractAddress {
    // First declare and deploy a contract
    let contract = declare("MockBtcRelay").unwrap().contract_class();

    let mut arr: Array<felt252> = array![];
    stored_header.serialize(ref arr);
    block_height.serialize(ref arr);
    let (contract_address, _) = contract.deploy(@arr).unwrap();
    
    contract_address
}

pub fn get_btc_relay_with_merkle_root(merkle_root: [u32; 8], confirmations: u32) -> (StoredBlockHeader, ContractAddress) {
    let blockheader = StoredBlockHeader {
        blockheader: BlockHeader {
            reversed_version: 0x00000000, 
            previous_blockhash: [0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0], 
            merkle_root: merkle_root, 
            reversed_timestamp: 0xaf105d6a, 
            nbits: 0xffff7f1f, 
            nonce: 0x000001e2
        }, 
        block_hash: [0x195f8af3, 0xaf2eae19, 0x38c8813, 0xc7f5397b, 0x49dd8667, 0x2dcba9c7, 0xc18034e0, 0x484e2700], 
        chain_work: 0x0000000000000000000000000000000000000000000000000000000000000200, 
        block_height: 0, 
        last_diff_adjustment: 0x0, 
        prev_block_timestamps: [0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0]
    };
    let height = confirmations - 1;

    (blockheader, deploy_btc_relay(blockheader, height))
}

pub fn get_btc_relay_with_txs(tx_hashes: Span<[u32; 8]>, confirmations: u32) -> (StoredBlockHeader, ContractAddress) {
    assert(tx_hashes.len() < 3, 'only supports up to 2 txs');
    
    let merkle_root = if tx_hashes.len() == 2 {
        hash(*tx_hashes.at(0), *tx_hashes.at(1))
    } else if tx_hashes.len() == 1 {
        *tx_hashes.at(0)
    } else {
        [0, 0, 0, 0, 0, 0, 0, 0]
    };

    get_btc_relay_with_merkle_root(merkle_root, confirmations)
}
