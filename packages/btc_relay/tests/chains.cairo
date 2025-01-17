use btc_relay::structs::stored_blockheader::StoredBlockHeader;

use crate::utils::contract::{
    deploy, 
    deploy_and_submit_main_headers_assert, 
    deploy_submit_main_and_long_fork_assert, 
    deploy_submit_main_and_short_fork_assert,
    submit_main_and_assert,
    submit_long_fork_and_assert
};

fn malleate_first_blockheader(_stored_blockheaders: Span<StoredBlockHeader>) -> Span<StoredBlockHeader> {
    let mut stored_header = *_stored_blockheaders[0];
    stored_header.chain_work += 0xFFFFFFFF; //Change the blockheader by increasing the chain work

    let mut stored_blockheaders = array![stored_header];
    stored_blockheaders.append_span(_stored_blockheaders.slice(1, _stored_blockheaders.len() - 1));
    stored_blockheaders.span()
}

#[test]
fn main_chain() {
    deploy_and_submit_main_headers_assert(
        crate::data::main_chain::STORED_BLOCKHEADERS.span(),
        crate::data::main_chain::BLOCKHEADERS.span(),
        crate::data::main_chain::TIMESTAMP
    );
}

#[test]
fn main_chain_diff_adjustment() {
    deploy_and_submit_main_headers_assert(
        crate::data::main_chain_diff_adjustment::STORED_BLOCKHEADERS.span(),
        crate::data::main_chain_diff_adjustment::BLOCKHEADERS.span(),
        crate::data::main_chain_diff_adjustment::TIMESTAMP
    );
}

#[test]
fn short_fork_chain() {
    deploy_submit_main_and_short_fork_assert(
        crate::data::fork_chain::main_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain::main_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain::main_chain::TIMESTAMP,
        crate::data::fork_chain::fork_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain::fork_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain::fork_chain::TIMESTAMP
    );
}

#[test]
fn long_fork_chain() {
    deploy_submit_main_and_long_fork_assert(
        crate::data::fork_chain::main_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain::main_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain::main_chain::TIMESTAMP,
        crate::data::fork_chain::fork_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain::fork_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain::fork_chain::TIMESTAMP,
        true
    );
}

#[test]
fn short_fork_chain_chainwork() {
    deploy_submit_main_and_short_fork_assert(
        crate::data::fork_chain_chainwork::main_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain_chainwork::main_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain_chainwork::main_chain::TIMESTAMP,
        crate::data::fork_chain_chainwork::fork_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain_chainwork::fork_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain_chainwork::fork_chain::TIMESTAMP
    );
}

#[test]
fn long_fork_chain_chainwork() {
    deploy_submit_main_and_long_fork_assert(
        crate::data::fork_chain_chainwork::main_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain_chainwork::main_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain_chainwork::main_chain::TIMESTAMP,
        crate::data::fork_chain_chainwork::fork_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain_chainwork::fork_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain_chainwork::fork_chain::TIMESTAMP,
        true
    );
}

#[test]
#[should_panic(expected: 'submit_main: block commitment')]
fn main_chain_stored_header_not_committed() {
    let stored_blockheaders = crate::data::main_chain::STORED_BLOCKHEADERS.span();

    let (contract_address, dispatcher) = deploy(*stored_blockheaders[0]);

    //Now take the main chain from fork_chain/main_chain.cairo, and try to submit those headers,
    // there should be a mismatch between the stored blockheader
    submit_main_and_assert(
        contract_address,
        dispatcher,
        crate::data::fork_chain::main_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain::main_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain::main_chain::TIMESTAMP
    );
}

#[test]
#[should_panic(expected: 'submit_main: block height')]
fn main_chain_stored_header_not_tip() {
    let stored_blockheaders = crate::data::main_chain::STORED_BLOCKHEADERS.span();
    let blockheaders = crate::data::main_chain::BLOCKHEADERS.span();

    let half = blockheaders.len() / 2;

    //Deploy contract & submit first half of the headers
    let (contract_address, dispatcher) = deploy_and_submit_main_headers_assert(
        stored_blockheaders.slice(0, half + 1),
        blockheaders.slice(0, half),
        crate::data::main_chain::TIMESTAMP
    );

    //Try to submit the second half, but don't specify the latest committed blockheader,
    // but second to latest
    submit_main_and_assert(
        contract_address,
        dispatcher,
        blockheaders.slice(half - 1, blockheaders.len() - half + 1),
        stored_blockheaders.slice(half - 1, stored_blockheaders.len() - half + 1),
        crate::data::main_chain::TIMESTAMP
    );
}

#[test]
#[should_panic(expected: 'verify: block commitment')]
fn short_fork_stored_header_not_committed() {
    let mut _fork_stored_blockheaders = crate::data::fork_chain::fork_chain::STORED_BLOCKHEADERS.span();
    
    let mut fork_stored_header = *_fork_stored_blockheaders[0];
    fork_stored_header.chain_work += 0xFFFFFFFF; //Change the blockheader by increasing the chain work

    let mut fork_stored_blockheaders = array![fork_stored_header];
    fork_stored_blockheaders.append_span(_fork_stored_blockheaders.slice(1, _fork_stored_blockheaders.len() - 1));

    deploy_submit_main_and_short_fork_assert(
        crate::data::fork_chain::main_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain::main_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain::main_chain::TIMESTAMP,
        fork_stored_blockheaders.span(),
        crate::data::fork_chain::fork_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain::fork_chain::TIMESTAMP
    );
}

#[test]
#[should_panic(expected: 'verify: block commitment')]
fn long_fork_stored_header_not_committed() {
    deploy_submit_main_and_long_fork_assert(
        crate::data::fork_chain::main_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain::main_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain::main_chain::TIMESTAMP,
        malleate_first_blockheader(crate::data::fork_chain::fork_chain::STORED_BLOCKHEADERS.span()),
        crate::data::fork_chain::fork_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain::fork_chain::TIMESTAMP,
        true
    );
}

#[test]
#[should_panic(expected: 'fork: fork block commitment')]
fn long_fork_stored_header_not_committed_in_fork_data() {
    let (contract_address, dispatcher) = deploy_and_submit_main_headers_assert(
        crate::data::fork_chain::main_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain::main_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain::main_chain::TIMESTAMP
    );

    let fork_stored_blockheaders = crate::data::fork_chain::fork_chain::STORED_BLOCKHEADERS.span();
    let fork_blockheaders = crate::data::fork_chain::fork_chain::BLOCKHEADERS.span();

    let headers_half = fork_blockheaders.len() / 2;
    let fork_id = 1;

    submit_long_fork_and_assert(
        contract_address, 
        dispatcher,
        fork_id,
        fork_blockheaders.slice(0, headers_half),
        fork_stored_blockheaders.slice(0, headers_half+1),
        (*fork_stored_blockheaders[0]).block_height + 1,
        crate::data::fork_chain::fork_chain::TIMESTAMP,
        false
    );

    submit_long_fork_and_assert(
        contract_address, 
        dispatcher,
        fork_id,
        fork_blockheaders.slice(headers_half, fork_blockheaders.len() - headers_half),
        malleate_first_blockheader(
            fork_stored_blockheaders.slice(headers_half, fork_stored_blockheaders.len() - headers_half)
        ),
        (*fork_stored_blockheaders[0]).block_height + 1,
        crate::data::fork_chain::fork_chain::TIMESTAMP,
        true
    );
}

#[test]
#[should_panic(expected: 'short_fork: not enough work')]
fn short_fork_not_enough_length() {
    deploy_submit_main_and_short_fork_assert(
        crate::data::fork_chain_not_enough_length::main_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_length::main_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_length::main_chain::TIMESTAMP,
        crate::data::fork_chain_not_enough_length::fork_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_length::fork_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_length::fork_chain::TIMESTAMP
    );
}

#[test]
fn long_fork_not_enough_length() {
    deploy_submit_main_and_long_fork_assert(
        crate::data::fork_chain_not_enough_length::main_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_length::main_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_length::main_chain::TIMESTAMP,
        crate::data::fork_chain_not_enough_length::fork_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_length::fork_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_length::fork_chain::TIMESTAMP,
        false
    );
}

#[test]
#[should_panic(expected: 'short_fork: not enough work')]
fn short_fork_not_enough_chainwork() {
    deploy_submit_main_and_short_fork_assert(
        crate::data::fork_chain_not_enough_chainwork::main_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_chainwork::main_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_chainwork::main_chain::TIMESTAMP,
        crate::data::fork_chain_not_enough_chainwork::fork_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_chainwork::fork_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_chainwork::fork_chain::TIMESTAMP
    );
}

#[test]
fn long_fork_not_enough_chainwork() {
    deploy_submit_main_and_long_fork_assert(
        crate::data::fork_chain_not_enough_chainwork::main_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_chainwork::main_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_chainwork::main_chain::TIMESTAMP,
        crate::data::fork_chain_not_enough_chainwork::fork_chain::STORED_BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_chainwork::fork_chain::BLOCKHEADERS.span(),
        crate::data::fork_chain_not_enough_chainwork::fork_chain::TIMESTAMP,
        false
    );
}
