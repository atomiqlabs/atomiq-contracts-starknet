use snforge_std::signature::SignerTrait;
use snforge_std::{
    cheat_caller_address, cheat_block_timestamp, cheat_block_number, CheatSpan, spy_events,
    EventSpyAssertionsTrait, generate_random_felt
};
use snforge_std::signature::stark_curve::{StarkCurveKeyPairImpl, StarkCurveSignerImpl};
use snforge_std::signature::KeyPair;
use starknet::contract_address::{ContractAddress};

use escrow_manager::components::lp_vault::{ILPVaultDispatcher, ILPVaultDispatcherTrait};
use escrow_manager::components::escrow_storage::{IEscrowStorageDispatcher, IEscrowStorageDispatcherTrait};
use escrow_manager::{EscrowManager, IEscrowManagerSafeDispatcher, IEscrowManagerSafeDispatcherTrait};
use escrow_manager::structs::escrow::{EscrowDataImpl, EscrowDataImplTrait};
use escrow_manager::structs::contract_call::ContractCall;
use escrow_manager::structs;
use escrow_manager::state;
use escrow_manager::events;
use escrow_manager::sighash;

use crate::utils::contract::{deploy_account, Context};
use crate::utils::erc20;
use crate::utils::lp_vault;
use crate::utils::result::assert_result;

use openzeppelin_token::erc20::ERC20ABIDispatcherTrait;

pub const ESCROW_INIT_MINT_AMOUNT: u256 = 2000;
pub const ESCROW_INIT_MINT_NOT_ENOUGH_AMOUNT: u256 = 500;
pub const ESCROW_INIT_AMOUNT: u256 = 1000;

pub const ESCROW_GAS_MINT_AMOUNT: u256 = 1000;
pub const ESCROW_GAS_MINT_NOT_ENOUGH_AMOUNT: u256 = 50;
pub const ESCROW_DEPOSIT_SMALL: u256 = 100;
pub const ESCROW_DEPOSIT_LARGE: u256 = 150;

pub const INIT_BLOCK_NUMBER: u64 = 8577342;

pub fn create_escrow_data(
    context: Context,
    sender_claimer: bool, pay_in: bool, pay_out: bool, reputation: bool,
    mint_amount: u256, escrow_amount: u256,
    gas_mint_amount: u256, security_deposit: u256, claimer_bounty: u256,
    success_action: Span<ContractCall>
) -> (ContractAddress, structs::escrow::EscrowData, KeyPair<felt252, felt252>, KeyPair<felt252, felt252>, KeyPair<felt252, felt252>) {
    let (offerer, offerer_keypair) = deploy_account();
    let (claimer, claimer_keypair) = deploy_account();

    let sender = if sender_claimer { claimer } else { offerer };
    let signer = if sender_claimer { offerer_keypair } else { claimer_keypair };

    if pay_in {
        erc20::mint(context.token, offerer, mint_amount);
    } else {
        lp_vault::mint_to_lp_vault(context.contract_address, offerer, context.token, mint_amount);
    }

    if claimer_bounty!=0 || security_deposit!=0 {
        erc20::mint(context.gas_token, sender, gas_mint_amount);
    }

    let flags: u128 = if pay_in { structs::escrow::FLAG_PAY_IN } else { 0 } +
        if pay_out { structs::escrow::FLAG_PAY_OUT } else { 0 } +
        if reputation { structs::escrow::FLAG_REPUTATION } else { 0 };

    let escrow = structs::escrow::EscrowData {
        offerer,
        claimer,
        token: context.token.contract_address,
        refund_handler: context.refund_handler,
        claim_handler: context.claim_handler,

        flags,

        claim_data: 0,
        refund_data: 0,
    
        amount: escrow_amount,

        fee_token: context.gas_token.contract_address,
        security_deposit,
        claimer_bounty,

        success_action
    };

    //Increase allowance for token
    if pay_in {
        cheat_caller_address(context.token.contract_address, offerer, CheatSpan::TargetCalls(1));
        context.token.approve(context.contract_address, 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe);
    }

    //Increase allowance for gas token
    let total_deposit = escrow.get_total_deposit();
    if total_deposit != 0 {
        cheat_caller_address(context.gas_token.contract_address, sender, CheatSpan::TargetCalls(1));
        context.gas_token.approve(context.contract_address, 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe);
    }

    (sender, escrow, signer, offerer_keypair, claimer_keypair)
}

pub fn init_escrow_and_assert(
    context: Context,
    sender: ContractAddress, escrow: structs::escrow::EscrowData, signer: KeyPair<felt252, felt252>,
    timeout: u64, current_time: u64
) -> Result<(), felt252> {
    _init_escrow_and_assert(context, sender, escrow, signer, timeout, current_time, false, false)
}

pub fn _init_escrow_and_assert(
    context: Context,
    sender: ContractAddress, escrow: structs::escrow::EscrowData, signer: KeyPair<felt252, felt252>,
    timeout: u64, current_time: u64,
    sign_random_message: bool, sign_different_timeout: bool
) -> Result<(), felt252> {
    let balance_erc20 = context.token.balance_of(escrow.offerer);
    let balance_contract = *ILPVaultDispatcher{contract_address: context.contract_address}.get_balance(array![(escrow.offerer, context.token.contract_address)].span()).span()[0];
    let balance_erc20_contract = context.token.balance_of(context.contract_address);

    let balance_gas_erc20 = context.gas_token.balance_of(sender);
    let balance_gas_erc20_contract = context.gas_token.balance_of(context.contract_address);

    let signer_address = if escrow.offerer == sender { escrow.claimer } else { escrow.offerer };
    let escrow_hash = escrow.get_struct_hash();
    let sighash = if sign_random_message { 
        generate_random_felt()
    } else {
        sighash::get_init_sighash(escrow_hash, if sign_different_timeout { 0 } else { timeout }, signer_address)
    };
    let (r, s) = signer.sign(sighash).expect('Failed to sign');

    let mut spy = spy_events();

    cheat_caller_address(context.contract_address, sender, CheatSpan::TargetCalls(1));
    cheat_block_timestamp(context.contract_address, current_time, CheatSpan::TargetCalls(1));
    cheat_block_number(context.contract_address, INIT_BLOCK_NUMBER, CheatSpan::TargetCalls(1));
    let result = IEscrowManagerSafeDispatcher{contract_address: context.contract_address}.initialize(escrow, array![r, s], timeout, array![].span());
    if result.is_err() {
        return Result::Err(*result.unwrap_err().span()[0]);
    }

    //Assert event emitted
    spy.assert_emitted(
        @array![(context.contract_address, EscrowManager::Event::Initialize(events::Initialize {
            offerer: escrow.offerer,
            claimer: escrow.claimer,
            claim_data: escrow.claim_data,
            escrow_hash,
            claim_handler: escrow.claim_handler,
            refund_handler: escrow.refund_handler
        }))]
    );

    //Assert escrow state saved
    let expected_escrow_state = state::escrow::EscrowState {
        init_blockheight: INIT_BLOCK_NUMBER,
        finish_blockheight: 0,
        state: state::escrow::STATE_COMMITTED
    };
    if (IEscrowStorageDispatcher{contract_address: context.contract_address}.get_state(escrow) != expected_escrow_state) { return Result::Err('test: state'); };
    if (IEscrowStorageDispatcher{contract_address: context.contract_address}.get_hash_state(escrow_hash) != expected_escrow_state) { return Result::Err('test: state hash'); };
    if (*(IEscrowStorageDispatcher{contract_address: context.contract_address}.get_hash_state_multiple(array![escrow_hash].span())[0]) != expected_escrow_state) { return Result::Err('test: state hash multiple'); };


    if escrow.is_pay_in() {
        if (context.token.balance_of(escrow.offerer) != balance_erc20-escrow.amount) ||
            (context.token.balance_of(context.contract_address) != balance_erc20_contract+escrow.amount) {
            return Result::Err('test: erc20 balance');
        }
    } else {
        if (ILPVaultDispatcher{contract_address: context.contract_address}.get_balance(array![(escrow.offerer, context.token.contract_address)].span()) != array![balance_contract-escrow.amount]) {
            return Result::Err('test: vault balance');
        }
    }

    let total_deposit = escrow.get_total_deposit();
    if total_deposit != 0 {
        if (context.gas_token.balance_of(sender) != balance_gas_erc20-total_deposit) ||
            (context.gas_token.balance_of(context.contract_address) != balance_gas_erc20_contract+total_deposit) {
            return Result::Err('test: gas token balance');
        }
    }

    Result::Ok(())
}

pub fn get_initialized_escrow(
    context: Context,
    sender_claimer: bool, pay_in: bool, pay_out: bool, reputation: bool, security_deposit: bool, claimer_bounty: bool, deposit_invert: bool, success_action: Span<ContractCall>,
    commit: bool
) -> (structs::escrow::EscrowData, KeyPair<felt252, felt252>, KeyPair<felt252, felt252>) {
    let (sender, escrow, signer, offerer_signer, claimer_signer) = create_escrow_data(context,
        sender_claimer,
        pay_in, 
        pay_out,
        reputation,
        1000,
        500,
        1000,
        if security_deposit { if deposit_invert { ESCROW_DEPOSIT_LARGE } else { ESCROW_DEPOSIT_SMALL } } else { 0 },
        if claimer_bounty { if deposit_invert { ESCROW_DEPOSIT_SMALL } else { ESCROW_DEPOSIT_LARGE } } else { 0 },
        success_action
    );
    if commit { assert_result(init_escrow_and_assert(context, sender, escrow, signer, 100, 0), escrow); };

    (escrow, offerer_signer, claimer_signer)
}
