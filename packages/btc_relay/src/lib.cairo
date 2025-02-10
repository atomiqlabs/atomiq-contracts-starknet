pub mod structs;
pub mod utils;
pub mod constants;
pub mod events;
pub mod state;

use crate::structs::blockheader::{BlockHeader, BlockHeaderSha256Hash};
use crate::structs::stored_blockheader::StoredBlockHeader;
use crate::utils::difficulty;

#[starknet::interface]
pub trait IBtcRelay<TContractState> {
    //Submits blockheaders to the main/canonical chain, stored_header must be the current tip
    fn submit_main_blockheaders(ref self: TContractState, block_headers: Span<BlockHeader>, stored_header: StoredBlockHeader);
    //Submits a short fork, all the block_headers need to fit in a single transaction
    fn submit_short_fork_blockheaders(ref self: TContractState, block_headers: Span<BlockHeader>, stored_header: StoredBlockHeader);
    //Starts/continues submitting a long fork (in case all the fork headers don't fit a in a single starknet transaction),
    // the fork becomes canonical as soon as it accumulates more chainwork than main chain
    fn submit_fork_blockheaders(ref self: TContractState, fork_id: felt252, block_headers: Span<BlockHeader>, stored_header: StoredBlockHeader);
}

#[starknet::interface]
pub trait IBtcRelayReadOnly<TContractState> {
    //Returns the current chainwork of the main/canonical chain
    fn get_chainwork(self: @TContractState) -> u256;
    //Return the main chain tip blockheight
    fn get_blockheight(self: @TContractState) -> u32;
    //Verifies if a provided stored header is part of the main chain
    fn verify_blockheader(self: @TContractState, stored_header: StoredBlockHeader) -> u32;
    //Returns the main/canonical chain commitment hash at a given blockheight
    fn get_commit_hash(self: @TContractState, height: u32) -> felt252;
    //Returns the main/canonical chain commitment hash at the blockchain tip
    fn get_tip_commit_hash(self: @TContractState) -> felt252;
}

#[starknet::contract]
pub mod BtcRelay {
    use super::IBtcRelayReadOnly;
use core::starknet::{get_caller_address, get_block_timestamp, ContractAddress};
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use crate::structs::blockheader::{BlockHeader, BlockHeaderSha256Hash};
    use crate::structs::stored_blockheader::{StoredBlockHeader, StoredBlockHeaderPoseidonHashTrait, StoredBlockHeaderUpdate, StoredBlockHeaderUpdateTrait};
    use crate::state::fork::Fork;
    use super::*;

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        //Main header is submitted
        StoreHeader: events::StoreHeader,
        //Fork header is submitted
        StoreForkHeader: events::StoreForkHeader,
        //Chain reorganization has occurred
        ChainReorg: events::ChainReorg
    }

    #[storage]
    struct Storage {
        main_chain: Map<felt252, felt252>,
        main_chainwork: felt252,
        main_blockheight: felt252,

        forks: Map<ContractAddress, Map<felt252, Fork>>
    }

    //Initialize the btc relay with the provided stored_header
    #[constructor]
    fn constructor(ref self: ContractState, stored_header: StoredBlockHeader) {
        let commit_hash = stored_header.get_hash();

        //Save the initial stored header
        self.main_chain.entry(stored_header.block_height.into()).write(commit_hash);
        self.main_chainwork.write(stored_header.chain_work.try_into().unwrap());
        self.main_blockheight.write(stored_header.block_height.into());
        
        //Emit event
        self.emit(events::StoreHeader {
            commit_hash: commit_hash,
            block_hash_poseidon: stored_header.get_block_hash_poseidon(),
            header: stored_header
        });
    }

    #[abi(embed_v0)]
    impl BtcRelayImpl of super::IBtcRelay<ContractState> {

        fn submit_main_blockheaders(ref self: ContractState, block_headers: Span<BlockHeader>, stored_header: StoredBlockHeader) {
            assert(block_headers.len() != 0, 'submit_main: no headers');

            let starknet_timestamp: u32 = get_block_timestamp().try_into().unwrap();

            //Verify stored header is latest committed
            let current_blockheight = self.main_blockheight.read();
            assert(current_blockheight == stored_header.block_height.into(), 'submit_main: block height');
            assert(self.main_chain.entry(current_blockheight).read() == stored_header.get_hash(), 'submit_main: block commitment');

            //Proccess new block headers
            let mut _stored_header = stored_header;
            for block_header in block_headers {
                //Process the blockheader
                _stored_header.update_chain(*block_header, starknet_timestamp);

                //Write header commitment
                let commit_hash = _stored_header.get_hash();
                self.main_chain.entry(_stored_header.block_height.into()).write(commit_hash);

                //Emit event
                self.emit(events::StoreHeader {
                    commit_hash: commit_hash,
                    block_hash_poseidon: _stored_header.get_block_hash_poseidon(),
                    header: _stored_header
                });
            };

            //Update globals
            self.main_chainwork.write(_stored_header.chain_work.try_into().unwrap());
            self.main_blockheight.write(_stored_header.block_height.into());
        }

        fn submit_short_fork_blockheaders(ref self: ContractState, block_headers: Span<BlockHeader>, stored_header: StoredBlockHeader) {
            assert(block_headers.len() != 0, 'short_fork: no headers');

            let starknet_timestamp: u32 = get_block_timestamp().try_into().unwrap();

            //Verify stored header is committed
            self.verify_blockheader(stored_header);

            //Proccess new block headers
            let mut _stored_header = stored_header;
            for block_header in block_headers {
                //Process the blockheader
                _stored_header.update_chain(*block_header, starknet_timestamp);

                //Write header commitment
                let commit_hash = _stored_header.get_hash();
                self.main_chain.entry(_stored_header.block_height.into()).write(commit_hash);

                //Emit event - here we can already emit main chain submission events
                self.emit(events::StoreHeader {
                    commit_hash: commit_hash,
                    block_hash_poseidon: _stored_header.get_block_hash_poseidon(),
                    header: _stored_header
                });
            };

            //Check if this fork's chainwork is higher than main chainwork
            let main_chainwork = self.main_chainwork.read();
            assert(main_chainwork.into() < _stored_header.chain_work, 'short_fork: not enough work');

            //Emit chain re-org event
            self.emit(events::ChainReorg {
                fork_submitter: get_caller_address(),
                fork_id: 0,
                tip_commit_hash: _stored_header.get_hash(),
                tip_block_hash_poseidon: _stored_header.get_block_hash_poseidon(),
                start_height: stored_header.block_height.into() + 1
            });

            //Update globals
            self.main_chainwork.write(_stored_header.chain_work.try_into().unwrap());
            self.main_blockheight.write(_stored_header.block_height.into());
        }

        fn submit_fork_blockheaders(ref self: ContractState, fork_id: felt252, block_headers: Span<BlockHeader>, stored_header: StoredBlockHeader) {
            assert(block_headers.len() != 0, 'short_fork: no headers');
            assert(fork_id != 0, 'short_fork: fork_id 0 reserved');

            let starknet_timestamp: u32 = get_block_timestamp().try_into().unwrap();

            let caller = get_caller_address();
            let fork_ptr = self.forks.entry(caller).entry(fork_id);

            let mut fork_start_blockheight = fork_ptr.start_height.read();

            if fork_start_blockheight == 0 {
                //Verify stored header is committed in the main chain
                self.verify_blockheader(stored_header);
                fork_start_blockheight = stored_header.block_height.into() + 1;
                fork_ptr.start_height.write(fork_start_blockheight);
            } else {
                //Verify stored header is committed in the fork chain
                assert(fork_ptr.chain.entry(stored_header.block_height.into()).read() == stored_header.get_hash(), 'fork: fork block commitment');
            }

            //Proccess new block headers
            let mut _stored_header = stored_header;
            for block_header in block_headers {
                //Process the blockheader
                _stored_header.update_chain(*block_header, starknet_timestamp);

                //Write header commitment
                let commit_hash =_stored_header.get_hash();
                fork_ptr.chain.entry(_stored_header.block_height.into()).write(commit_hash);

                //Emit fork blockheader event
                self.emit(events::StoreForkHeader {
                    fork_id: fork_id,
                    commit_hash: commit_hash,
                    block_hash_poseidon: _stored_header.get_block_hash_poseidon(),
                    header: _stored_header
                });
            };

            //Check if this fork's chainwork is higher than main chainwork
            if self.main_chainwork.read().into() < _stored_header.chain_work {
                //This fork has just overtaken the main chain in chainwork
                //Make this fork main chain
                let mut block_height = fork_start_blockheight;

                while block_height != _stored_header.block_height.into()+1 {
                    self.main_chain.entry(block_height).write(fork_ptr.chain.entry(block_height).read());
                    block_height += 1;
                };
                
                //Emit chain re-org event
                self.emit(events::ChainReorg {
                    fork_submitter: caller,
                    fork_id: fork_id,
                    tip_commit_hash: _stored_header.get_hash(),
                    tip_block_hash_poseidon: _stored_header.get_block_hash_poseidon(),
                    start_height: fork_start_blockheight
                });

                //Update globals
                self.main_chainwork.write(_stored_header.chain_work.try_into().unwrap());
                self.main_blockheight.write(_stored_header.block_height.into());
            }

        }
    }

    #[abi(embed_v0)]
    impl BtcRelayReadOnlyImpl of super::IBtcRelayReadOnly<ContractState> {
        fn get_chainwork(self: @ContractState) -> u256 {
            self.main_chainwork.read().into()
        }

        fn get_blockheight(self: @ContractState) -> u32 {
            self.main_blockheight.read().try_into().unwrap()
        }

        fn verify_blockheader(self: @ContractState, stored_header: StoredBlockHeader) -> u32 {
            let main_blockheight: u32 = self.main_blockheight.read().try_into().unwrap();
            //Check that the block height isn't past the tip, this can happen if there is a reorg, where a shorter
            // chain becomes the cannonical one, this can happen due to the heaviest work rule (and not lonest chain rule)
            assert(stored_header.block_height <= main_blockheight, 'verify: future block');

            assert(
                self.get_commit_hash(stored_header.block_height) == stored_header.get_hash(),
                'verify: block commitment'
            );

            main_blockheight - stored_header.block_height + 1
        }

        fn get_commit_hash(self: @ContractState, height: u32) -> felt252 {
            //Check that the block height isn't past the tip, this can happen if there is a reorg, where a shorter
            // chain becomes the cannonical one, this can happen due to the heaviest work rule (and not lonest chain rule)
            let main_blockheight: u32 = self.main_blockheight.read().try_into().unwrap();
            assert(height <= main_blockheight, 'verify: future block');

            self.main_chain.entry(height.into()).read()
        }

        fn get_tip_commit_hash(self: @ContractState) -> felt252 {
            self.main_chain.entry(self.main_blockheight.read()).read()
        }
    }
}
