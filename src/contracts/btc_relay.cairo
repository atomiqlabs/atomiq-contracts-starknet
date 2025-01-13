use crate::structs::btc_relay::{StoredBlockHeader, BlockHeader, BlockHeaderSha256Hash};
use crate::utils::nbits;
use crate::utils::endianness::ReverseEndiannessTrait;
use crate::utils::u256_utils::U32LEArrayToU256ParserTrait;

#[starknet::interface]
pub trait IBtcRelay<TContractState> {
    fn submit_main_blockheaders(ref self: TContractState, block_headers: Span<BlockHeader>, stored_header: StoredBlockHeader);
    fn submit_short_fork_blockheaders(ref self: TContractState, block_headers: Span<BlockHeader>, stored_header: StoredBlockHeader);
    fn submit_fork_blockheaders(ref self: TContractState, fork_id: felt252, block_headers: Span<BlockHeader>, stored_header: StoredBlockHeader);
}

const UNROUNDED_MAX_TARGET: u256 = 0x00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
const MAX_TARGET_NBITS: u32 = 0xffff001d;

//Bitcoin constants
const DIFF_ADJUSTMENT_INTERVAL: u32 = 2016;
const TARGET_TIMESPAN: u256 = 14 * 24 * 60 * 60; // 2 weeks

//Pre-calculated multiples for target timespan
const TARGET_TIMESPAN_DIV_4: u32 = (14 * 24 * 60 * 60) / 4;
const TARGET_TIMESPAN_MUL_4: u32 = (14 * 24 * 60 * 60) * 4;

//Maximum positive difference between bitcoin block's timestamp and Starknet's on-chain clock
//Nodes in bitcoin network generally reject any block with timestamp more than 2 hours in the future
//As we are dealing with another blockchain here,
// with the possibility of the Starknet's on-chain clock being skewed, we chose double the value - 4 hours
const MAX_FUTURE_BLOCKTIME: u32 = 4 * 60 * 60;

//Difficulty retargetting algorithm
//https://minerdaily.com/2021/how-are-bitcoins-difficulty-and-hash-rate-calculated/#Difficulty_Adjustments
// new_difficulty_target = prev_difficulty_target * (timespan / target_timespan)
fn compute_new_nbits(prev_time: u32, start_time: u32, prev_target: u256) -> u32 {
    let mut time_span = prev_time - start_time;

    //Difficulty increase/decrease multiples are clamped between 0.25 (-75%) and 4 (+300%)
    if time_span < TARGET_TIMESPAN_DIV_4 {
        time_span = TARGET_TIMESPAN_DIV_4;
    }
    if time_span > TARGET_TIMESPAN_MUL_4 {
        time_span = TARGET_TIMESPAN_MUL_4;
    }

    let new_target = prev_target * time_span.into() / TARGET_TIMESPAN;

    //Check if the target isn't past maximum allowed target (lowest possible mining difficulty)
    //https://en.bitcoin.it/wiki/Target#What_is_the_maximum_target.3F
    if new_target > UNROUNDED_MAX_TARGET {
        return 0xffff001d;
    }

    nbits::target_to_nbits(prev_target)
}

fn process_blockheader(mut _stored_header: StoredBlockHeader, block_header: BlockHeader, starknet_timestamp: u32) {
    //Previous blockhash matches
    assert(_stored_header.block_hash == block_header.previous_blockhash, 'process: prev blockhash');

    let prev_block_timestamp = _stored_header.blockheader.reversed_timestamp.rev_endianness();
    let curr_block_timestamp = block_header.reversed_timestamp.rev_endianness();

    //Check correct nbits
    _stored_header.block_height += 1;
    if _stored_header.block_height % DIFF_ADJUSTMENT_INTERVAL == 0 {
        //Compute new nbits, bitcoin uses the timestamp of the last block in the epoch to re-target PoW difficulty
        // https://github.com/bitcoin/bitcoin/blob/78dae8caccd82cfbfd76557f1fb7d7557c7b5edb/src/pow.cpp#L49
        let computed_nbits = compute_new_nbits(
            prev_block_timestamp, 
            _stored_header.last_diff_adjustment,
            nbits::nbits_to_target(_stored_header.blockheader.nbits)
        );
        assert(block_header.nbits == computed_nbits, 'process: new nbits');
        //Even though timestamp of the last block in epoch is used to re-target PoW difficulty, the first
        // block in a new epoch is used as last_diff_adjustment, the time it takes to mine the first block
        // in every epoch is therefore not taken into consideration when retargetting PoW - one of many
        // bitcoin's quirks
        _stored_header.last_diff_adjustment = curr_block_timestamp;
    } else {
        //nbits must be same as last block
        assert(block_header.nbits == _stored_header.blockheader.nbits, 'process: nbits');
    }

    //Check PoW
    let target: u256 = nbits::nbits_to_target(block_header.nbits);
    let block_hash: [u32; 8] = block_header.dbl_sha256_hash();
    assert(block_hash.from_le_to_u256() < target, 'process: invalid PoW');

    //Verify timestamp is larger than median of last 11 block timestamps
    let mut count: u8 = 0;
    for timestamp in _stored_header.prev_block_timestamps.span() {
        if curr_block_timestamp > *timestamp {
            count += 1;
        };
    };
    if curr_block_timestamp > prev_block_timestamp {
        count += 1
    };
    assert(count > 5, 'process: timestamp median');

    //Verify timestamp is no more than MAX_FUTURE_BLOCKTIME in the future
    assert(curr_block_timestamp < starknet_timestamp + MAX_FUTURE_BLOCKTIME, 'process: timestamp future');

    //Set _stored_header variables
    _stored_header.block_hash = block_hash;
    _stored_header.blockheader = block_header;
    let prev_block_timestamps = _stored_header.prev_block_timestamps.span();
    _stored_header.prev_block_timestamps = [
        *prev_block_timestamps[1],
        *prev_block_timestamps[2],
        *prev_block_timestamps[3],
        *prev_block_timestamps[4],
        *prev_block_timestamps[5],
        *prev_block_timestamps[6],
        *prev_block_timestamps[7],
        *prev_block_timestamps[8],
        *prev_block_timestamps[9],
        prev_block_timestamp
    ];

    //Compute chainwork according to bitcoin core implementation
    // https://github.com/bitcoin/bitcoin/blob/master/src/chain.cpp#L131
    let difficulty = (~target / (target + 1)) + 1;
    _stored_header.chain_work += difficulty;
}

#[starknet::contract]
mod BtcRelay {
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::starknet::{get_caller_address, get_block_timestamp, ContractAddress};
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use crate::structs::btc_relay::{StoredBlockHeader, BlockHeader, StoredBlockHeaderPoseidonHashTrait, BlockHeaderSha256Hash};
    use core::poseidon::PoseidonTrait;
    use super::*;

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
                process_blockheader(_stored_header, *block_header, starknet_timestamp);

                //Write header commitment
                self.main_chain.entry(_stored_header.block_height.into()).write(_stored_header.get_hash());

                //Emit event

            };

            self.main_chainwork.write(_stored_header.chain_work.try_into().unwrap());
            self.main_blockheight.write(_stored_header.block_height.into());
        }

        fn submit_short_fork_blockheaders(ref self: ContractState, block_headers: Span<BlockHeader>, stored_header: StoredBlockHeader) {
            assert(block_headers.len() != 0, 'short_fork: no headers');

            let starknet_timestamp: u32 = get_block_timestamp().try_into().unwrap();

            //Verify stored header is committed
            assert(self.main_chain.entry(stored_header.block_height.into()).read() == stored_header.get_hash(), 'short_fork: block commitment');

            //Proccess new block headers
            let mut _stored_header = stored_header;
            for block_header in block_headers {
                //Process the blockheader
                process_blockheader(_stored_header, *block_header, starknet_timestamp);

                //Write header commitment
                self.main_chain.entry(_stored_header.block_height.into()).write(_stored_header.get_hash());

                //Emit event - here we can already emit main chain submission events

            };

            //Check if this fork's chainwork is higher than main chainwork
            assert(self.main_chainwork.read().into() < _stored_header.chain_work, 'short_fork: not enough work');

            //Update globals
            self.main_chainwork.write(_stored_header.chain_work.try_into().unwrap());
            self.main_blockheight.write(_stored_header.block_height.into());
        }

        fn submit_fork_blockheaders(ref self: ContractState, fork_id: felt252, block_headers: Span<BlockHeader>, stored_header: StoredBlockHeader) {
            assert(block_headers.len() != 0, 'short_fork: no headers');

            let starknet_timestamp: u32 = get_block_timestamp().try_into().unwrap();

            let caller = get_caller_address();
            let fork_start_blockheight = self.forks_start_height.entry(caller).entry(fork_id).read();

            let fork_ptr = self.forks.entry(caller).entry(fork_id);

            if fork_start_blockheight == 0 {
                //Verify stored header is committed in the main chain
                assert(self.main_chain.entry(stored_header.block_height.into()).read() == stored_header.get_hash(), 'fork: main block commitment');
                self.forks_start_height.entry(caller).entry(fork_id).write(stored_header.block_height.into() + 1);
            } else {
                //Verify stored header is committed in the fork chain
                assert(fork_ptr.entry(stored_header.block_height.into()).read() == stored_header.get_hash(), 'fork: fork block commitment');
            }

            //Proccess new block headers
            let mut _stored_header = stored_header;
            for block_header in block_headers {
                //Process the blockheader
                process_blockheader(_stored_header, *block_header, starknet_timestamp);

                //Write header commitment
                fork_ptr.entry(_stored_header.block_height.into()).write(_stored_header.get_hash());

                //Emit fork blockheader event

            };

            //Check if this fork's chainwork is higher than main chainwork
            if self.main_chainwork.read().into() < _stored_header.chain_work {
                //This fork has just overtaken the main chain in chainwork
                //Make this fork main chain
                let mut block_height = fork_start_blockheight;

                while block_height != _stored_header.block_height.into()+1 {
                    self.main_chain.entry(block_height).write(fork_ptr.entry(block_height).read());
                    block_height += 1;
                };
                
                //Emit chain re-org event

                //Update globals
                self.main_chainwork.write(_stored_header.chain_work.try_into().unwrap());
                self.main_blockheight.write(_stored_header.block_height.into());
            }

        }

    }
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_max_target_nbits() {
        assert!(nbits::nbits_to_target(MAX_TARGET_NBITS) == 0x00000000FFFF0000000000000000000000000000000000000000000000000000);
        assert!(nbits::target_to_nbits(UNROUNDED_MAX_TARGET) == MAX_TARGET_NBITS);
    }

    #[test]
    fn test_single_block() {
        let mut store_blockheader = StoredBlockHeader {
            blockheader: BlockHeader {
                reversed_version: 0x00e00020,
                previous_blockhash: [0x005ad1e5, 0x2105871c, 0x3307f84d, 0x0ec1bbd6, 0xdaf1f165, 0x95730100, 0x00000000, 0x00000000],
                merkle_root: [0x2f7cf817, 0x45228b2b, 0x0c5e0191, 0x418757cb, 0xd85355bc, 0xd0d56f4f, 0x597e9531, 0xc55ffe94],
                reversed_timestamp: 0x2f148567,
                nbits: 0x618c0217,
                nonce: 0xf1d0c106
            },
            block_hash: [0x750d80cd, 0xb13dacc2, 0x88e25f1e, 0x460b9540, 0x1a3f50dc, 0x2ed10100, 0x00000000, 0x00000000],
            chain_work: 0x0000000000000000000000000000000000000000a70ff8c166c99c6b6cd42d58,
            block_height: 879079,
            last_diff_adjustment: 1736712111,
            prev_block_timestamps: [
                1736767006,
                1736767744,
                1736767878,
                1736769034,
                1736769616,
                1736770294,
                1736770311,
                1736771611,
                1736773502,
                1736774360
            ]
        };

        let next_block_header = BlockHeader {
            reversed_version: 0x00e09c2f,
            previous_blockhash: [0x750d80cd, 0xb13dacc2, 0x88e25f1e, 0x460b9540, 0x1a3f50dc, 0x2ed10100, 0x00000000, 0x00000000],
            merkle_root: [0xb59cce24, 0xcc632429, 0x6883cef5, 0x7ed40ef8, 0x622daf7e, 0xce8337b0, 0xa1f91324, 0xaa6fb741],
            reversed_timestamp: 0xb0158567,
            nbits: 0x618c0217,
            nonce: 0xa614233d
        };

        process_blockheader(store_blockheader, next_block_header, 1736777120);
    }

}