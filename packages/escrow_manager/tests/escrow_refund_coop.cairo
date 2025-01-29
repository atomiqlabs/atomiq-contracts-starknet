use snforge_std::{
    cheat_caller_address, CheatSpan, generate_random_felt, spy_events, EventSpyAssertionsTrait, cheat_block_number, cheat_block_timestamp
};
use snforge_std::signature::stark_curve::{StarkCurveKeyPairImpl, StarkCurveSignerImpl};
use snforge_std::signature::KeyPair;
use core::num::traits::SaturatingAdd;

use starknet::contract_address::{ContractAddress};

use escrow_manager::{EscrowManager, IEscrowManagerSafeDispatcher, IEscrowManagerSafeDispatcherTrait};
use escrow_manager::components::lp_vault::{ILPVaultDispatcher, ILPVaultDispatcherTrait};
use escrow_manager::components::escrow_storage::{IEscrowStorageDispatcher, IEscrowStorageDispatcherTrait};
use escrow_manager::components::reputation::{IReputationTrackerDispatcher, IReputationTrackerDispatcherTrait};
use escrow_manager::structs::escrow::{EscrowDataImpl, EscrowDataImplTrait};
use escrow_manager::structs;
use escrow_manager::state;
use escrow_manager::events;
use escrow_manager::sighash;

use crate::utils::contract::{get_context, Context};
use crate::utils::result::{assert_result, assert_result_error};
use crate::utils::escrow::get_initialized_escrow;

use openzeppelin_token::erc20::ERC20ABIDispatcherTrait;

const COOP_REFUND_BLOCK_NUMBER: u64 = 3876732256;

fn coop_refund_escrow(
    context: Context,
    escrow: structs::escrow::EscrowData,
    claimer_keypair: KeyPair<felt252, felt252>,
    timeout: u64, current_timestamp: u64,
    sign_random_message: bool, sign_different_timeout: bool
) -> Result<(), felt252> {
    let balance_erc20 = context.token.balance_of(escrow.offerer);
    let balance_contract = *ILPVaultDispatcher{contract_address: context.contract_address}.get_balance(array![(escrow.offerer, context.token.contract_address)].span()).span()[0];
    let balance_erc20_contract = context.token.balance_of(context.contract_address);

    let external_refunder: ContractAddress = generate_random_felt().try_into().unwrap();

    let balance_gas_erc20_claimer = context.gas_token.balance_of(escrow.claimer);
    let balance_gas_erc20_contract = context.gas_token.balance_of(context.contract_address);

    let [_, initial_coop_refund_reputation, _] = IReputationTrackerDispatcher{contract_address: context.contract_address}.get_reputation(array![(escrow.claimer, escrow.token, escrow.claim_handler)].span()).span()[0];

    let escrow_hash = escrow.get_struct_hash();
    let init_blockheight = IEscrowStorageDispatcher{contract_address: context.contract_address}.get_state(escrow).init_blockheight;

    let sighash = if sign_random_message { 
        generate_random_felt()
    } else {
        sighash::get_refund_sighash(escrow_hash, if sign_different_timeout { 0 } else { timeout }, escrow.claimer)
    };
    let (r, s) = claimer_keypair.sign(sighash).expect('Failed to sign');

    let mut spy = spy_events();

    cheat_caller_address(context.contract_address, external_refunder, CheatSpan::TargetCalls(1));
    cheat_block_timestamp(context.contract_address, current_timestamp, CheatSpan::TargetCalls(1));
    cheat_block_number(context.contract_address, COOP_REFUND_BLOCK_NUMBER, CheatSpan::TargetCalls(1));
    let result = IEscrowManagerSafeDispatcher{contract_address: context.contract_address}.cooperative_refund(escrow, array![r, s], timeout);
    if result.is_err() {
        return Result::Err(*result.unwrap_err().span()[0]);
    }

    //Assert event emitted
    spy.assert_emitted(
        @array![(context.contract_address, EscrowManager::Event::Refund(events::Refund {
            offerer: escrow.offerer,
            claimer: escrow.claimer,
            claim_data: escrow.claim_data,
            escrow_hash,
            witness_result: array![].span()
        }))]
    );

    //Assert escrow state saved
    if (IEscrowStorageDispatcher{contract_address: context.contract_address}.get_state(escrow) != state::escrow::EscrowState {
        init_blockheight,
        finish_blockheight: COOP_REFUND_BLOCK_NUMBER,
        state: state::escrow::STATE_REFUNDED
    }) { return Result::Err('test: state'); };

    if escrow.is_tracking_reputation() {
        let [_, coop_refund_reputation, _] = IReputationTrackerDispatcher{contract_address: context.contract_address}.get_reputation(array![(escrow.claimer, escrow.token, escrow.claim_handler)].span()).span()[0];
        if *coop_refund_reputation.amount != (*initial_coop_refund_reputation.amount).saturating_add(escrow.amount) {
            return Result::Err('test: reputation amount');
        }
        if *coop_refund_reputation.count != (*initial_coop_refund_reputation.count).saturating_add(1) {
            return Result::Err('test: reputation count');
        }
    }

    if escrow.is_pay_in() {
        if (context.token.balance_of(escrow.offerer) != balance_erc20+escrow.amount) ||
            (context.token.balance_of(context.contract_address) != balance_erc20_contract-escrow.amount) {
            return Result::Err('test: erc20 balance');
        }
    } else {
        if (ILPVaultDispatcher{contract_address: context.contract_address}.get_balance(array![(escrow.offerer, context.token.contract_address)].span()) != array![balance_contract+escrow.amount]) {
            return Result::Err('test: vault balance');
        }
    }

    let total_deposit = escrow.get_total_deposit();
    if total_deposit != 0 {
        if (context.gas_token.balance_of(escrow.claimer) != balance_gas_erc20_claimer + total_deposit) {
            return Result::Err('test: gas offerer balance');
        }
        if (context.gas_token.balance_of(context.contract_address) != balance_gas_erc20_contract - total_deposit) {
            return Result::Err('test: gas contract balance');
        }
    }

    Result::Ok(())
}

#[test]
fn valid_coop_refund() {
    let context = get_context();
    for i in 0..64_u8 {
        let (escrow, _, claimer_keypair) = get_initialized_escrow(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            i & 0x10 == 0x10,
            i & 0x20 == 0x20,
            false,
            true
        );
        assert_result(coop_refund_escrow(context, escrow, claimer_keypair, 100, 0, false, false), escrow);
    }
}

#[test]
fn invalid_coop_refund_uninitialized() {
    let context = get_context();
    for i in 0..64_u8 {
        let (escrow, _, claimer_keypair) = get_initialized_escrow(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            i & 0x10 == 0x10,
            i & 0x20 == 0x20,
            false,
            false
        );
        assert_result_error(
            coop_refund_escrow(context, escrow, claimer_keypair, 100, 0, false, false),
            '_finalize: Not committed',
            escrow
        );
    }
}

#[test]
fn invalid_refund_double() {
    let context = get_context();
    for i in 0..64_u8 {
        let (escrow, _, claimer_keypair) = get_initialized_escrow(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            i & 0x10 == 0x10,
            i & 0x20 == 0x20,
            false,
            true
        );
        assert_result(coop_refund_escrow(context, escrow, claimer_keypair, 100, 0, false, false), escrow);
        assert_result_error(
            coop_refund_escrow(context, escrow, claimer_keypair, 100, 0, false, false),
            '_finalize: Not committed',
            escrow
        );
    }
}

#[test]
fn invalid_coop_refund_timed_out() {
    let context = get_context();
    for i in 0..64_u8 {
        let (escrow, _, claimer_keypair) = get_initialized_escrow(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            i & 0x10 == 0x10,
            i & 0x20 == 0x20,
            false,
            true
        );
        assert_result_error(
            coop_refund_escrow(context, escrow, claimer_keypair, 100, 200, false, false),
            'coop_refund: Auth expired',
            escrow
        );
    }
}

#[test]
fn invalid_coop_refund_sign_diff_timeout() {
    let context = get_context();
    for i in 0..64_u8 {
        let (escrow, _, claimer_keypair) = get_initialized_escrow(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            i & 0x10 == 0x10,
            i & 0x20 == 0x20,
            false,
            true
        );
        assert_result_error(
            coop_refund_escrow(context, escrow, claimer_keypair, 0xFFFFFFFFFFFFFFFE, 200, false, true),
            'verify_sig: Invalid response',
            escrow
        );
    }
}

#[test]
fn invalid_coop_refund_sign_random_msg() {
    let context = get_context();
    for i in 0..64_u8 {
        let (escrow, _, claimer_keypair) = get_initialized_escrow(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            i & 0x10 == 0x10,
            i & 0x20 == 0x20,
            false,
            true
        );
        assert_result_error(
            coop_refund_escrow(context, escrow, claimer_keypair, 100, 0, true, false),
            'verify_sig: Invalid response',
            escrow
        );
    }
}

#[test]
fn invalid_coop_refund_wrong_signer() {
    let context = get_context();
    for i in 0..64_u8 {
        let (escrow, _, _) = get_initialized_escrow(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            i & 0x10 == 0x10,
            i & 0x20 == 0x20,
            false,
            true
        );
        assert_result_error(
            coop_refund_escrow(context, escrow, StarkCurveKeyPairImpl::generate(), 100, 0, false, false),
            'verify_sig: Invalid response',
            escrow
        );
    }
}
