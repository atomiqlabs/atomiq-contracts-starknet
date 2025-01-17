use starknet::contract_address::ContractAddress;
use btc_relay::structs::stored_blockheader::{StoredBlockHeader, StoredBlockHeaderPoseidonHash};
use btc_relay::BtcRelay;
use btc_relay::events;

#[generate_trait]
pub impl StoredBlockHeaderToEvent of StoredBlockHeaderToEventTrait {
    
    fn to_event(self: StoredBlockHeader, contract_address: ContractAddress) -> (ContractAddress, BtcRelay::Event) {
        (
            contract_address,
            BtcRelay::Event::StoreHeader(
                events::StoreHeader {
                    commit_hash: self.get_hash(),
                    block_hash_poseidon: self.get_block_hash_poseidon(),
                    header: self
                }
            )
        )
    }

    fn to_fork_event(self: StoredBlockHeader, contract_address: ContractAddress, fork_id: felt252) -> (ContractAddress, BtcRelay::Event) {
        (
            contract_address,
            BtcRelay::Event::StoreForkHeader(
                events::StoreForkHeader {
                    fork_id: fork_id,
                    commit_hash: self.get_hash(),
                    block_hash_poseidon: self.get_block_hash_poseidon(),
                    header: self
                }
            )
        )
    }

}

#[generate_trait]
pub impl StoredBlockHeaderSpanToEvent of StoredBlockHeaderSpanToEventTrait {
    
    fn to_events(self: Span<StoredBlockHeader>, contract_address: ContractAddress, begin: usize, end: usize) -> Array<(ContractAddress, BtcRelay::Event)> {
        let mut events: Array<(ContractAddress, BtcRelay::Event)> = array![];
        let mut index = begin;
        while index < end {
            let stored_header = *self[index];
            events.append(stored_header.to_event(contract_address));
            index += 1;
        };
        events
    }

    fn to_fork_events(self: Span<StoredBlockHeader>, contract_address: ContractAddress, fork_id: felt252, begin: usize, end: usize) -> Array<(ContractAddress, BtcRelay::Event)> {
        let mut events: Array<(ContractAddress, BtcRelay::Event)> = array![];
        let mut index = begin;
        while index < end {
            let stored_header = *self[index];
            events.append(stored_header.to_fork_event(contract_address, fork_id));
            index += 1;
        };
        events
    }

}
