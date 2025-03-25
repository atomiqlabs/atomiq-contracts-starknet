use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait, spy_events,
    EventSpyAssertionsTrait, // Add for assertions on the EventSpy
    cheat_block_timestamp, cheat_caller_address, CheatSpan, load,
    map_entry_address
};
use starknet::contract_address::{ContractAddress, contract_address_const};

use btc_relay::{
    IBtcRelayDispatcher, IBtcRelayDispatcherTrait, BtcRelay,
    IBtcRelayReadOnlyDispatcher, IBtcRelayReadOnlyDispatcherTrait
};
use btc_relay::structs::blockheader::BlockHeader;
use btc_relay::structs::stored_blockheader::{StoredBlockHeader, StoredBlockHeaderPoseidonHashTrait};
use btc_relay::events;

use crate::utils::events::{StoredBlockHeaderToEventTrait, StoredBlockHeaderSpanToEventTrait};

pub fn deploy(initial_block: StoredBlockHeader) -> (ContractAddress, IBtcRelayDispatcher) {
    // First declare and deploy a contract
    let contract = declare("BtcRelay").unwrap().contract_class();

    // Alternatively we could use `deploy_syscall` here
    let mut constructor_arguments = array![];
    initial_block.serialize(ref constructor_arguments);

    let mut spy = spy_events();
    let (contract_address, _) = contract.deploy(@constructor_arguments).unwrap();
    spy.assert_emitted(
        @array![initial_block.to_event(contract_address)]
    );
    
    // Create a Dispatcher object that will allow interacting with the deployed contract
    let dispatcher = IBtcRelayDispatcher { contract_address };

    (contract_address, dispatcher)
}


pub fn submit_main_and_assert(
    contract_address: ContractAddress, 
    dispatcher: IBtcRelayDispatcher, 
    blockheaders: Span<BlockHeader>,
    stored_blockheaders: Span<StoredBlockHeader>,
    cheat_timestamp: u64
) {
    cheat_block_timestamp(contract_address, cheat_timestamp, CheatSpan::Indefinite);
    let mut spy = spy_events();
    dispatcher.submit_main_blockheaders(blockheaders, *stored_blockheaders[0]);
    spy.assert_emitted(
        @stored_blockheaders.to_events(contract_address, 1, stored_blockheaders.len())
    );

    let read_dispatcher = IBtcRelayReadOnlyDispatcher{contract_address: dispatcher.contract_address};
    for stored_blockheader in stored_blockheaders {
        read_dispatcher.verify_blockheader(*stored_blockheader);
        let block_commitment = (*stored_blockheader).get_hash();
        assert_eq!(load_main_chain_commitment(contract_address, *stored_blockheader.block_height), block_commitment);
        assert_eq!(read_dispatcher.get_commit_hash(*stored_blockheader.block_height), block_commitment);
    };

    assert!(read_dispatcher.get_chainwork() == (*stored_blockheaders[stored_blockheaders.len() - 1]).chain_work);
    assert!(read_dispatcher.get_blockheight() == (*stored_blockheaders[stored_blockheaders.len() - 1]).block_height);
    assert!(read_dispatcher.get_tip_commit_hash() == (*stored_blockheaders[stored_blockheaders.len() - 1]).get_hash());
}

pub fn submit_short_fork_and_assert(
    contract_address: ContractAddress, 
    dispatcher: IBtcRelayDispatcher, 
    fork_blockheaders: Span<BlockHeader>,
    fork_stored_blockheaders: Span<StoredBlockHeader>,
    cheat_timestamp: u64
) {
    let fork_submitter = contract_address_const::<'short fork submitter'>();
    cheat_caller_address(contract_address, fork_submitter, CheatSpan::Indefinite);

    cheat_block_timestamp(contract_address, cheat_timestamp, CheatSpan::Indefinite);
    let mut spy = spy_events();
    dispatcher.submit_short_fork_blockheaders(fork_blockheaders, *fork_stored_blockheaders[0]);
    spy.assert_emitted(
        @fork_stored_blockheaders.to_events(contract_address, 1, fork_stored_blockheaders.len())
    );
    spy.assert_emitted(
        @array![(
            contract_address,
            BtcRelay::Event::ChainReorg(
                events::ChainReorg {
                    fork_submitter: fork_submitter,
                    fork_id: 0,
                    tip_block_hash_poseidon: (*fork_stored_blockheaders[fork_stored_blockheaders.len()-1]).get_block_hash_poseidon(),
                    tip_commit_hash: (*fork_stored_blockheaders[fork_stored_blockheaders.len()-1]).get_hash(),
                    start_height: (*fork_stored_blockheaders[0]).block_height.into() + 1
                }
            )
        )]
    );

    let read_dispatcher = IBtcRelayReadOnlyDispatcher{contract_address: dispatcher.contract_address};
    for stored_blockheader in fork_stored_blockheaders {
        read_dispatcher.verify_blockheader(*stored_blockheader);
        let block_commitment = (*stored_blockheader).get_hash();
        assert_eq!(load_main_chain_commitment(contract_address, *stored_blockheader.block_height), block_commitment);
        assert_eq!(read_dispatcher.get_commit_hash(*stored_blockheader.block_height), block_commitment);
    };

    assert!(read_dispatcher.get_chainwork() == (*fork_stored_blockheaders[fork_stored_blockheaders.len() - 1]).chain_work);
    assert!(read_dispatcher.get_blockheight() == (*fork_stored_blockheaders[fork_stored_blockheaders.len() - 1]).block_height);
    assert!(read_dispatcher.get_tip_commit_hash() == (*fork_stored_blockheaders[fork_stored_blockheaders.len() - 1]).get_hash());
}

fn long_fork_assert_start_height(
    contract_address: ContractAddress,
    fork_submitter: ContractAddress,
    fork_id: felt252,
    fork_start_height: u32
) {
    let loaded_start_height = load(
        contract_address,
        map_entry_address(
            map_entry_address(
                selector!("forks"),
                array![
                    fork_submitter.into(),
                    fork_id
                ].span(),
            ),
            array![
                selector!("start_height")
            ].span(),
        ),
        1
    );
    assert!(*loaded_start_height[0] == fork_start_height.into());
}

fn load_main_chain_commitment(
    contract_address: ContractAddress,
    block_height: u32
) -> felt252 {
    *load(
        contract_address,
        map_entry_address(
            selector!("main_chain"),
            array![
                block_height.into()
            ].span(),
        ),
        1
    )[0]
}

fn load_fork_chain_commitment(
    contract_address: ContractAddress,
    fork_submitter: ContractAddress,
    fork_id: felt252,
    block_height: u32
) -> felt252 {
    *load(
        contract_address,
        map_entry_address(
            map_entry_address(
                selector!("forks"),
                array![
                    fork_submitter.into(),
                    fork_id
                ].span(),
            ),
            array![
                selector!("chain"),
                block_height.into()
            ].span(),
        ),
        1
    )[0]
}

fn assert_fork_blockheader_commitment(
    contract_address: ContractAddress,
    fork_submitter: ContractAddress,
    fork_id: felt252,
    stored_blockheader: StoredBlockHeader
) {
    let fork_header_commitment = load_fork_chain_commitment(
        contract_address,
        fork_submitter, 
        fork_id, 
        stored_blockheader.block_height
    );
    assert!(fork_header_commitment == stored_blockheader.get_hash());
}

fn assert_fork_copied_to_main_chain(
    contract_address: ContractAddress,
    fork_submitter: ContractAddress,
    fork_id: felt252,
    start_height: u32,
    end_height: u32
) {
    let mut height = start_height;
    while(height != end_height + 1) {
        assert_eq!(
            load_main_chain_commitment(contract_address, height),
            load_fork_chain_commitment(contract_address, fork_submitter, fork_id, height)
        );
        height += 1;
    }
}

pub fn submit_long_fork_and_assert(
    contract_address: ContractAddress, 
    dispatcher: IBtcRelayDispatcher,
    fork_id: felt252,
    fork_blockheaders: Span<BlockHeader>,
    fork_stored_blockheaders: Span<StoredBlockHeader>,
    fork_start_height: u32,
    cheat_timestamp: u64,
    should_reorg: bool
) {
    let fork_submitter = contract_address_const::<'long fork submitter'>();
    cheat_caller_address(contract_address, fork_submitter, CheatSpan::Indefinite);

    cheat_block_timestamp(contract_address, cheat_timestamp, CheatSpan::Indefinite);
    let mut spy = spy_events();
    dispatcher.submit_fork_blockheaders(fork_id, fork_blockheaders, *fork_stored_blockheaders[0]);
    spy.assert_emitted(
        @fork_stored_blockheaders.to_fork_events(contract_address, fork_id, 1, fork_stored_blockheaders.len())
    );
    long_fork_assert_start_height(contract_address, fork_submitter, fork_id, fork_start_height);

    for stored_blockheader in fork_stored_blockheaders {
        assert_fork_blockheader_commitment(contract_address, fork_submitter, fork_id, *stored_blockheader);
    };

    if should_reorg {
        spy.assert_emitted(
            @array![(
                contract_address,
                BtcRelay::Event::ChainReorg(
                    events::ChainReorg {
                        fork_submitter: fork_submitter,
                        fork_id: fork_id,
                        tip_block_hash_poseidon: (*fork_stored_blockheaders[fork_stored_blockheaders.len()-1]).get_block_hash_poseidon(),
                        tip_commit_hash: (*fork_stored_blockheaders[fork_stored_blockheaders.len()-1]).get_hash(),
                        start_height: fork_start_height.into()
                    }
                )
            )]
        );

        let last_stored_blockheader = *fork_stored_blockheaders[fork_stored_blockheaders.len() - 1];

        assert_fork_copied_to_main_chain(contract_address, fork_submitter, fork_id, fork_start_height, last_stored_blockheader.block_height);

        let read_dispatcher = IBtcRelayReadOnlyDispatcher{contract_address: dispatcher.contract_address};
        assert!(read_dispatcher.get_chainwork() == last_stored_blockheader.chain_work);
        assert!(read_dispatcher.get_blockheight() == last_stored_blockheader.block_height);
        assert!(read_dispatcher.get_tip_commit_hash() == (*fork_stored_blockheaders[fork_stored_blockheaders.len() - 1]).get_hash());
    } else {
        spy.assert_not_emitted(
            @array![(
                contract_address,
                BtcRelay::Event::ChainReorg(
                    events::ChainReorg {
                        fork_submitter: fork_submitter,
                        fork_id: fork_id,
                        tip_block_hash_poseidon: (*fork_stored_blockheaders[fork_stored_blockheaders.len()-1]).get_block_hash_poseidon(),
                        tip_commit_hash: (*fork_stored_blockheaders[fork_stored_blockheaders.len()-1]).get_hash(),
                        start_height: fork_start_height.into()
                    }
                )
            )]
        );        
    }
}

pub fn deploy_and_submit_main_headers_assert(
    stored_blockheaders: Span<StoredBlockHeader>,
    blockheaders: Span<BlockHeader>,
    cheat_timestamp: u64
) -> (ContractAddress, IBtcRelayDispatcher) {
    let (contract_address, dispatcher) = deploy(*stored_blockheaders[0]);

    submit_main_and_assert(
        contract_address,
        dispatcher,
        blockheaders,
        stored_blockheaders,
        cheat_timestamp
    );

    (contract_address, dispatcher)
}

pub fn deploy_submit_main_and_short_fork_assert(
    stored_blockheaders: Span<StoredBlockHeader>,
    blockheaders: Span<BlockHeader>,
    cheat_timestamp: u64,
    fork_stored_blockheaders: Span<StoredBlockHeader>,
    fork_blockheaders: Span<BlockHeader>,
    fork_cheat_timestamp: u64
) -> (ContractAddress, IBtcRelayDispatcher) {
    let (contract_address, dispatcher) = deploy_and_submit_main_headers_assert(
        stored_blockheaders,
        blockheaders,
        cheat_timestamp
    );

    submit_short_fork_and_assert(
        contract_address,
        dispatcher,
        fork_blockheaders,
        fork_stored_blockheaders,
        fork_cheat_timestamp
    );

    (contract_address, dispatcher)
}

pub fn deploy_submit_main_and_long_fork_assert(
    stored_blockheaders: Span<StoredBlockHeader>,
    blockheaders: Span<BlockHeader>,
    cheat_timestamp: u64,
    fork_stored_blockheaders: Span<StoredBlockHeader>,
    fork_blockheaders: Span<BlockHeader>,
    fork_cheat_timestamp: u64,
    should_reorg: bool
) -> (ContractAddress, IBtcRelayDispatcher) {
    let (contract_address, dispatcher) = deploy_and_submit_main_headers_assert(
        stored_blockheaders,
        blockheaders,
        cheat_timestamp
    );

    let headers_half = fork_blockheaders.len() / 2;
    let fork_id = 1;

    submit_long_fork_and_assert(
        contract_address, 
        dispatcher,
        fork_id,
        fork_blockheaders.slice(0, headers_half),
        fork_stored_blockheaders.slice(0, headers_half+1),
        (*fork_stored_blockheaders[0]).block_height + 1,
        fork_cheat_timestamp,
        false
    );

    submit_long_fork_and_assert(
        contract_address, 
        dispatcher,
        fork_id,
        fork_blockheaders.slice(headers_half, fork_blockheaders.len() - headers_half),
        fork_stored_blockheaders.slice(headers_half, fork_stored_blockheaders.len() - headers_half),
        (*fork_stored_blockheaders[0]).block_height + 1,
        fork_cheat_timestamp,
        should_reorg
    );

    (contract_address, dispatcher)
}
