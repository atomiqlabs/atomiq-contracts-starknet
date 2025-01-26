use snforge_std::{
    cheat_caller_address, CheatSpan, generate_random_felt
};
use snforge_std::signature::stark_curve::{StarkCurveKeyPairImpl, StarkCurveSignerImpl};

use escrow_manager::structs::escrow::{EscrowDataImpl, EscrowDataImplTrait};

use crate::utils::contract::get_context;
use crate::utils::result::{assert_result, assert_result_error};
use crate::utils::escrow::{
    create_escrow_data, init_escrow_and_assert, _init_escrow_and_assert,
    ESCROW_SECURITY_DEPOSIT, ESCROW_CLAIMER_BOUNTY, ESCROW_INIT_AMOUNT,
    ESCROW_GAS_MINT_AMOUNT, ESCROW_GAS_MINT_NOT_ENOUGH_AMOUNT,
    ESCROW_INIT_MINT_AMOUNT, ESCROW_INIT_MINT_NOT_ENOUGH_AMOUNT
};

use openzeppelin_token::erc20::ERC20ABIDispatcherTrait;

#[test]
fn valid_initialize() {
    let context = get_context();
    for i in 0..64_u8 {
        let (sender, escrow, signer, _, _) = create_escrow_data(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            ESCROW_INIT_MINT_AMOUNT,
            ESCROW_INIT_AMOUNT,
            ESCROW_GAS_MINT_AMOUNT,
            if i & 0x10 == 0x10 { ESCROW_SECURITY_DEPOSIT } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_CLAIMER_BOUNTY } else { 0 }
        );
        assert_result(init_escrow_and_assert(context, sender, escrow, signer, 100, 0), escrow);
    }
}

#[test]
fn invalid_initialize_not_enough_balance() {
    let context = get_context();
    for i in 0..64_u8 {
        let (sender, escrow, signer, _, _) = create_escrow_data(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            ESCROW_INIT_MINT_NOT_ENOUGH_AMOUNT,
            ESCROW_INIT_AMOUNT,
            ESCROW_GAS_MINT_AMOUNT,
            if i & 0x10 == 0x10 { ESCROW_SECURITY_DEPOSIT } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_CLAIMER_BOUNTY } else { 0 }
        );
        assert_result_error(
            init_escrow_and_assert(context, sender, escrow, signer, 100, 0),
            if escrow.is_pay_in() { 'ERC20: insufficient balance' } else { '_pay_in: not enough balance' },
            escrow
        );
    }
}

#[test]
fn invalid_initialize_not_enough_allowance() {
    let context = get_context();
    for i in 0..32_u8 {
        let (sender, escrow, signer, _, _) = create_escrow_data(context, 
            i & 0x1 == 0x1, 
            true,
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            ESCROW_INIT_MINT_AMOUNT,
            ESCROW_INIT_AMOUNT,
            ESCROW_GAS_MINT_AMOUNT,
            if i & 0x08 == 0x08 { ESCROW_SECURITY_DEPOSIT } else { 0 },
            if i & 0x10 == 0x10 { ESCROW_CLAIMER_BOUNTY } else { 0 }
        );

        //Set approval to 0
        cheat_caller_address(context.token.contract_address, escrow.offerer, CheatSpan::TargetCalls(1));
        context.token.approve(context.contract_address, 0);

        assert_result_error(
            init_escrow_and_assert(context, sender, escrow, signer, 100, 0),
            'ERC20: insufficient allowance',
            escrow
        );
    }
}

#[test]
fn invalid_initialize_not_enough_gas_balance() {
    let context = get_context();
    for i in 0..48_u8 {
        let (sender, escrow, signer, _, _) = create_escrow_data(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            ESCROW_INIT_MINT_AMOUNT,
            ESCROW_INIT_AMOUNT,
            ESCROW_GAS_MINT_NOT_ENOUGH_AMOUNT,
            if i & 0x10 == 0 { ESCROW_SECURITY_DEPOSIT } else { 0 },
            if i & 0x20 == 0 { ESCROW_CLAIMER_BOUNTY } else { 0 }
        );

        assert_result_error(
            init_escrow_and_assert(context, sender, escrow, signer, 100, 0),
            'ERC20: insufficient balance',
            escrow
        );
    }
}

#[test]
fn invalid_initialize_not_enough_gas_allowance() {
    let context = get_context();
    for i in 0..48_u8 {
        let (sender, escrow, signer, _, _) = create_escrow_data(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            ESCROW_INIT_MINT_AMOUNT,
            ESCROW_INIT_AMOUNT,
            ESCROW_GAS_MINT_AMOUNT,
            if i & 0x10 == 0 { ESCROW_SECURITY_DEPOSIT } else { 0 },
            if i & 0x20 == 0 { ESCROW_CLAIMER_BOUNTY } else { 0 }
        );

        //Set approval to 0
        cheat_caller_address(context.gas_token.contract_address, sender, CheatSpan::TargetCalls(1));
        context.gas_token.approve(context.contract_address, 0);

        assert_result_error(
            init_escrow_and_assert(context, sender, escrow, signer, 100, 0),
            'ERC20: insufficient allowance',
            escrow
        );
    }
}

#[test]
fn invalid_initialize_wrong_signer() {
    let context = get_context();
    for i in 0..64_u8 {
        let (sender, escrow, _, _, _) = create_escrow_data(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            ESCROW_INIT_MINT_AMOUNT,
            ESCROW_INIT_AMOUNT,
            ESCROW_GAS_MINT_AMOUNT,
            if i & 0x10 == 0x10 { ESCROW_SECURITY_DEPOSIT } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_CLAIMER_BOUNTY } else { 0 }
        );
        assert_result_error(
            init_escrow_and_assert(context, sender, escrow, StarkCurveKeyPairImpl::generate(), 100, 0),
            'verify_sig: Invalid response',
            escrow
        );
    }
}

#[test]
fn invalid_initialize_wrong_sign_message() {
    let context = get_context();
    for i in 0..64_u8 {
        let (sender, escrow, signer, _, _) = create_escrow_data(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            ESCROW_INIT_MINT_AMOUNT,
            ESCROW_INIT_AMOUNT,
            ESCROW_GAS_MINT_AMOUNT,
            if i & 0x10 == 0x10 { ESCROW_SECURITY_DEPOSIT } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_CLAIMER_BOUNTY } else { 0 }
        );
        assert_result_error(
            _init_escrow_and_assert(context, sender, escrow, signer, 100, 0, true, false),
            'verify_sig: Invalid response',
            escrow
        );
    }
}

#[test]
fn invalid_initialize_wrong_sender() {
    let context = get_context();
    for i in 0..64_u8 {
        let (_, escrow, signer, _, _) = create_escrow_data(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            ESCROW_INIT_MINT_AMOUNT,
            ESCROW_INIT_AMOUNT,
            ESCROW_GAS_MINT_AMOUNT,
            if i & 0x10 == 0x10 { ESCROW_SECURITY_DEPOSIT } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_CLAIMER_BOUNTY } else { 0 }
        );
        assert_result_error(
            init_escrow_and_assert(context, generate_random_felt().try_into().unwrap(), escrow, signer, 100, 0),
            'init: caller_address',
            escrow
        );
    }
}

#[test]
fn invalid_initialize_expired() {
    let context = get_context();
    for i in 0..64_u8 {
        let (sender, escrow, signer, _, _) = create_escrow_data(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            ESCROW_INIT_MINT_AMOUNT,
            ESCROW_INIT_AMOUNT,
            ESCROW_GAS_MINT_AMOUNT,
            if i & 0x10 == 0x10 { ESCROW_SECURITY_DEPOSIT } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_CLAIMER_BOUNTY } else { 0 }
        );
        assert_result_error(
            init_escrow_and_assert(context, sender, escrow, signer, 50, 100),
            'init: Authorization expired',
            escrow
        );
    }
}

#[test]
fn invalid_initialize_sign_different_timeout() {
    let context = get_context();
    for i in 0..64_u8 {
        let (sender, escrow, signer, _, _) = create_escrow_data(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            ESCROW_INIT_MINT_AMOUNT,
            ESCROW_INIT_AMOUNT,
            ESCROW_GAS_MINT_AMOUNT,
            if i & 0x10 == 0x10 { ESCROW_SECURITY_DEPOSIT } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_CLAIMER_BOUNTY } else { 0 }
        );
        assert_result_error(
            _init_escrow_and_assert(context, sender, escrow, signer, 0xFFFFFFFFFFFFFFFE, 100, false, true),
            'verify_sig: Invalid response',
            escrow
        );
    }
}

#[test]
fn invalid_initialize_commit_twice() {
    let context = get_context();
    for i in 0..64_u8 {
        let (sender, escrow, signer, _, _) = create_escrow_data(context, 
            i & 0x1 == 0x1, 
            i & 0x2 == 0x2,
            i & 0x4 == 0x4,
            i & 0x8 == 0x8,
            ESCROW_INIT_MINT_AMOUNT,
            ESCROW_INIT_AMOUNT,
            ESCROW_GAS_MINT_AMOUNT,
            if i & 0x10 == 0x10 { ESCROW_SECURITY_DEPOSIT } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_CLAIMER_BOUNTY } else { 0 }
        );
        assert_result(init_escrow_and_assert(context, sender, escrow, signer, 100, 0), escrow);
        assert_result_error(
            init_escrow_and_assert(context, sender, escrow, signer, 100, 0),
            '_commit: Already committed',
            escrow
        );
    }
}
