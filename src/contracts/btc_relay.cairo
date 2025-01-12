use crate::structs::btc_relay::{StoredBlockHeader, BlockHeader};

#[starknet::interface]
pub trait IBtcRelay<TContractState> {
    fn submit_main_blockheaders(ref self: TContractState, block_headers: Span<BlockHeader>, stored_header: StoredBlockHeader);
}

#[starknet::contract]
mod BtcRelay {
    use core::hash::HashStateTrait;
use core::hash::HashStateExTrait;
use core::num::traits::SaturatingSub;
    use starknet::event::EventEmitter;
    use core::starknet::{get_execution_info, get_caller_address, ContractAddress};
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use crate::structs::btc_relay::{StoredBlockHeader, BlockHeader};
    use core::poseidon::PoseidonTrait;

    #[storage]
    struct Storage {
        main_chain: Map<felt252, felt252>,
        main_chainwork: felt252,
        main_blockheight: felt252,

        forks: Map<ContractAddress, Map<felt252, Map<felt252, felt252>>>,
        forks_start_height: Map<ContractAddress, Map<felt252, felt252>>
    }

    #[constructor]
    fn constructor(ref self: ContractState, stored_header: StoredBlockHeader) {
        let header_commitment = PoseidonTrait::new().update_with(stored_header).finalize();
        self.main_chain.entry(stored_header.block_height.into()).write(header_commitment);
        self.main_chainwork.write(stored_header.chain_work.try_into().unwrap());
        self.main_blockheight.write(stored_header.block_height.into());
        
        //Emit event
        
    }

    #[abi(embed_v0)]
    impl BtcRelayImpl of super::IBtcRelay<ContractState> {
        fn submit_main_blockheaders(ref self: ContractState, block_headers: Span<BlockHeader>, stored_header: StoredBlockHeader) {
            
        }
    }
}
