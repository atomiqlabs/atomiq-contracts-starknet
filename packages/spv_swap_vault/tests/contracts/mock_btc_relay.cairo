
#[starknet::contract]
pub mod MockBtcRelay {
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use btc_relay::structs::blockheader::{BlockHeaderSha256Hash};
    use btc_relay::structs::stored_blockheader::{StoredBlockHeader, StoredBlockHeaderPoseidonHashTrait, StoredBlockHeaderUpdate};

    #[storage]
    struct Storage {
        main_chain: Map<felt252, felt252>,
        main_chainwork: felt252,
        main_blockheight: felt252
    }

    //Initialize the btc relay with the provided stored_header
    #[constructor]
    fn constructor(ref self: ContractState, stored_header: StoredBlockHeader, block_height: u32) {
        let commit_hash = stored_header.get_hash();

        //Save the initial stored header
        self.main_chain.entry(stored_header.block_height.into()).write(commit_hash);
        self.main_chainwork.write(stored_header.chain_work.try_into().unwrap());
        self.main_blockheight.write(block_height.into());
    }

    #[abi(embed_v0)]
    impl BtcRelayReadOnlyImpl of btc_relay::IBtcRelayReadOnly<ContractState> {
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
