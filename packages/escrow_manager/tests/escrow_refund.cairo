use snforge_std::{
    cheat_caller_address, CheatSpan, generate_random_felt, spy_events, EventSpyAssertionsTrait, cheat_block_number
};
use snforge_std::signature::stark_curve::{StarkCurveKeyPairImpl, StarkCurveSignerImpl};
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

use crate::utils::contract::{get_context, Context};
use crate::utils::result::{assert_result, assert_result_error};
use crate::utils::escrow::get_initialized_escrow;

use openzeppelin_token::erc20::ERC20ABIDispatcherTrait;

const REFUND_BLOCK_NUMBER: u64 = 836263212;

fn refund_escrow(
    context: Context,
    escrow: structs::escrow::EscrowData,
    witness: Array<felt252>
) -> Result<(), felt252> {
    let balance_erc20 = context.token.balance_of(escrow.offerer);
    let balance_contract = *ILPVaultDispatcher{contract_address: context.contract_address}.get_balance(array![(escrow.offerer, context.token.contract_address)].span()).span()[0];
    let balance_erc20_contract = context.token.balance_of(context.contract_address);

    let external_refunder: ContractAddress = generate_random_felt().try_into().unwrap();

    let balance_gas_erc20_claimer = context.gas_token.balance_of(escrow.claimer);
    let balance_gas_erc20_offerer = context.gas_token.balance_of(escrow.offerer);
    let balance_gas_erc20_contract = context.gas_token.balance_of(context.contract_address);

    let [_, _, initial_refund_reputation] = IReputationTrackerDispatcher{contract_address: context.contract_address}.get_reputation(array![(escrow.claimer, escrow.token, escrow.claim_handler)].span()).span()[0];

    let escrow_hash = escrow.get_struct_hash();
    let init_blockheight = IEscrowStorageDispatcher{contract_address: context.contract_address}.get_state(escrow).init_blockheight;

    let expected_witness = witness.span();

    let mut spy = spy_events();

    cheat_caller_address(context.contract_address, external_refunder, CheatSpan::TargetCalls(1));
    cheat_block_number(context.contract_address, REFUND_BLOCK_NUMBER, CheatSpan::TargetCalls(1));
    let result = IEscrowManagerSafeDispatcher{contract_address: context.contract_address}.refund(escrow, witness);
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
            witness_result: expected_witness
        }))]
    );

    //Assert escrow state saved
    if (IEscrowStorageDispatcher{contract_address: context.contract_address}.get_state(escrow) != state::escrow::EscrowState {
        init_blockheight,
        finish_blockheight: REFUND_BLOCK_NUMBER,
        state: state::escrow::STATE_REFUNDED
    }) { return Result::Err('test: state'); };

    if escrow.is_tracking_reputation() {
        let [_, _, refund_reputation] = IReputationTrackerDispatcher{contract_address: context.contract_address}.get_reputation(array![(escrow.claimer, escrow.token, escrow.claim_handler)].span()).span()[0];
        if *refund_reputation.amount != (*initial_refund_reputation.amount).saturating_add(escrow.amount) {
            return Result::Err('test: reputation amount');
        }
        if *refund_reputation.count != (*initial_refund_reputation.count).saturating_add(1) {
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
    if escrow.security_deposit != 0 {
        if (context.gas_token.balance_of(escrow.offerer) != balance_gas_erc20_offerer + escrow.security_deposit) {
            return Result::Err('test: gas offerer balance');
        }
    }
    let return_to_claimer = total_deposit - escrow.security_deposit;
    if return_to_claimer != 0 {
        if (context.gas_token.balance_of(escrow.claimer) != balance_gas_erc20_claimer + return_to_claimer) {
            return Result::Err('test: gas claimer balance');
        }
    }
    if total_deposit != 0 {
        if (context.gas_token.balance_of(context.contract_address) != balance_gas_erc20_contract - total_deposit) {
            return Result::Err('test: gas contract balance');
        }
    }

    Result::Ok(())
}

#[test]
fn valid_refund() {
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
        assert_result(refund_escrow(context, escrow, array![0xcbad72bc73bce871]), escrow);
    }
}

#[test]
fn valid_refund_invert_deposits() {
    let context = get_context();
    for i in 0..16_u8 {
        let (escrow, _, _) = get_initialized_escrow(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            true,
            true,
            true,
            true
        );
        assert_result(refund_escrow(context, escrow, array![0xcbad72bc73bce871]), escrow);
    }
}

#[test]
fn invalid_refund_handler() {
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
        assert_result_error(refund_escrow(context, escrow, array![]), 'mock_refund: witness len==0', escrow);
    }
}

#[test]
fn invalid_refund_uninitialized() {
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
            false
        );
        assert_result_error(refund_escrow(context, escrow, array![]), '_uncommit: Not committed', escrow);
    }
}

#[test]
fn invalid_refund_double() {
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
        assert_result(refund_escrow(context, escrow, array![0xcbad72bc73bce871]), escrow);
        assert_result_error(refund_escrow(context, escrow, array![0xcbad72bc73bce871]), '_uncommit: Not committed', escrow);
    }
}

