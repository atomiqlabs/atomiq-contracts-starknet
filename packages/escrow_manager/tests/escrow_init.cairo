use snforge_std::{
    cheat_caller_address, CheatSpan, generate_random_felt
};
use snforge_std::signature::stark_curve::{StarkCurveKeyPairImpl, StarkCurveSignerImpl};

use escrow_manager::structs::escrow::{EscrowDataImpl, EscrowDataImplTrait};

use crate::utils::contract::get_context;
use crate::utils::result::{assert_result, assert_result_error};
use crate::utils::escrow::{
    create_escrow_data, init_escrow_and_assert, _init_escrow_and_assert,
    ESCROW_DEPOSIT_SMALL, ESCROW_DEPOSIT_LARGE, ESCROW_INIT_AMOUNT,
    ESCROW_GAS_MINT_AMOUNT, ESCROW_GAS_MINT_NOT_ENOUGH_AMOUNT,
    ESCROW_INIT_MINT_AMOUNT, ESCROW_INIT_MINT_NOT_ENOUGH_AMOUNT
};

use openzeppelin_token::erc20::ERC20ABIDispatcherTrait;

//Valid initialization of the escrow
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
            if i & 0x10 == 0x10 { ESCROW_DEPOSIT_SMALL } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_DEPOSIT_LARGE } else { 0 }
        );
        assert_result(init_escrow_and_assert(context, sender, escrow, signer, 100, 0), escrow);
    }
}

//Invalid initialization of the escrow due to offerer not having enough balance
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
            if i & 0x10 == 0x10 { ESCROW_DEPOSIT_SMALL } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_DEPOSIT_LARGE } else { 0 }
        );
        assert_result_error(
            init_escrow_and_assert(context, sender, escrow, signer, 100, 0),
            if escrow.is_pay_in() { 'ERC20: insufficient balance' } else { '_xfer_in: not enough balance' },
            escrow
        );
    }
}

//Invalid initialization of the escrow due to offerer not having enough erc20 allowance (only pay_in = true)
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
            if i & 0x08 == 0x08 { ESCROW_DEPOSIT_SMALL } else { 0 },
            if i & 0x10 == 0x10 { ESCROW_DEPOSIT_LARGE } else { 0 }
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

//Invalid initialization of the escrow due to sender not having enough gas token erc20 balance
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
            if i & 0x10 == 0 { ESCROW_DEPOSIT_SMALL } else { 0 },
            if i & 0x20 == 0 { ESCROW_DEPOSIT_LARGE } else { 0 }
        );

        assert_result_error(
            init_escrow_and_assert(context, sender, escrow, signer, 100, 0),
            'ERC20: insufficient balance',
            escrow
        );
    }
}

//Invalid initialization of the escrow due to sender not having enough gas token erc20 allowance
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
            if i & 0x10 == 0 { ESCROW_DEPOSIT_SMALL } else { 0 },
            if i & 0x20 == 0 { ESCROW_DEPOSIT_LARGE } else { 0 }
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

//Invalid initialization of the escrow due to the init message being signed by a different signer
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
            if i & 0x10 == 0x10 { ESCROW_DEPOSIT_SMALL } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_DEPOSIT_LARGE } else { 0 }
        );
        let result = init_escrow_and_assert(context, sender, escrow, StarkCurveKeyPairImpl::generate(), 100, 0);
        if sender==escrow.offerer && !escrow.is_tracking_reputation() {
            assert_result(
                result,
                escrow
            ); //This should succeed, because the signature of the target is not checked
        } else {
            assert_result_error(
                result,
                'verify_sig: Invalid response',
                escrow
            );
        }
    }
}

//Invalid initialization of the escrow due to random message being signed, instead of a valid init msg 
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
            if i & 0x10 == 0x10 { ESCROW_DEPOSIT_SMALL } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_DEPOSIT_LARGE } else { 0 }
        );
        let result = _init_escrow_and_assert(context, sender, escrow, signer, 100, 0, true, false);
        if sender==escrow.offerer && !escrow.is_tracking_reputation() {
            assert_result(
                result,
                escrow
            ); //This should succeed, because the signature of the target is not checked
        } else {
            assert_result_error(
                result,
                'verify_sig: Invalid response',
                escrow
            );
        }
    }
}

//Initialize transaction sent by a third party sender
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
            if i & 0x10 == 0x10 { ESCROW_DEPOSIT_SMALL } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_DEPOSIT_LARGE } else { 0 }
        );
        assert_result_error(
            init_escrow_and_assert(context, generate_random_felt().try_into().unwrap(), escrow, signer, 100, 0),
            'init: caller_address',
            escrow
        );
    }
}

//Initialize with already expired signed init message
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
            if i & 0x10 == 0x10 { ESCROW_DEPOSIT_SMALL } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_DEPOSIT_LARGE } else { 0 }
        );
        assert_result_error(
            init_escrow_and_assert(context, sender, escrow, signer, 50, 100),
            'init: Authorization expired',
            escrow
        );
    }
}

//Try to malleate timeout, without changing the signature
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
            if i & 0x10 == 0x10 { ESCROW_DEPOSIT_SMALL } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_DEPOSIT_LARGE } else { 0 }
        );
        let result = _init_escrow_and_assert(context, sender, escrow, signer, 0xFFFFFFFFFFFFFFFE, 100, false, true);
        if sender==escrow.offerer && !escrow.is_tracking_reputation() {
            assert_result(
                result,
                escrow
            ); //This should succeed, because the signature of the target is not checked
        } else {
            assert_result_error(
                result,
                'verify_sig: Invalid response',
                escrow
            );
        }
    }
}

//Try to commit the same escrow twice
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
            if i & 0x10 == 0x10 { ESCROW_DEPOSIT_SMALL } else { 0 },
            if i & 0x20 == 0x20 { ESCROW_DEPOSIT_LARGE } else { 0 }
        );
        assert_result(init_escrow_and_assert(context, sender, escrow, signer, 100, 0), escrow);
        assert_result_error(
            init_escrow_and_assert(context, sender, escrow, signer, 100, 0),
            '_commit: Already committed',
            escrow
        );
    }
}
