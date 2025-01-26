use snforge_std::signature::SignerTrait;
use snforge_std::{
    cheat_caller_address, cheat_block_timestamp, CheatSpan
};
use snforge_std::signature::stark_curve::{StarkCurveKeyPairImpl, StarkCurveSignerImpl};
use snforge_std::signature::KeyPair;
use starknet::contract_address::{ContractAddress, contract_address_const};

use escrow_manager::components::lp_vault::{ILPVaultDispatcher, ILPVaultDispatcherTrait};
use escrow_manager::components::escrow_storage::{IEscrowStorageDispatcher, IEscrowStorageDispatcherTrait};
use escrow_manager::{IEscrowManagerDispatcher, IEscrowManagerDispatcherTrait};
use escrow_manager::structs::escrow::{EscrowDataImpl, EscrowDataImplTrait};
use escrow_manager::structs::escrow;

use crate::utils::contract::{deploy, deploy_account, deploy_refund_handler, deploy_claim_handler};
use crate::utils::erc20;
use crate::utils::lp_vault;

use openzeppelin_token::erc20::{ERC20ABIDispatcher, ERC20ABIDispatcherTrait};

const ESCROW_INIT_MINT_AMOUNT: u256 = 2000;
const ESCROW_INIT_AMOUNT: u256 = 1000;
const ESCROW_SECURITY_DEPOSIT: u256 = 100;
const ESCROW_CLAIMER_BOUNTY: u256 = 150;

#[derive(Copy, Drop)]
struct Context {
    contract_address: ContractAddress,
    token: ERC20ABIDispatcher,
    gas_token: ERC20ABIDispatcher,
    refund_handler: ContractAddress,
    claim_handler: ContractAddress
}

fn get_context() -> Context {
    Context {
        contract_address: deploy(),
        token: erc20::deploy(),
        gas_token: erc20::deploy(),
        refund_handler: deploy_refund_handler(),
        claim_handler: deploy_claim_handler()
    }
}

fn create_escrow_data(
    context: Context,
    sender_claimer: bool, pay_in: bool, pay_out: bool, reputation: bool,
    mint_amount: u256, escrow_amount: u256,
    gas_mint_amount: u256, security_deposit: u256, claimer_bounty: u256
) -> (ContractAddress, escrow::EscrowData, KeyPair<felt252, felt252>) {
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

    let flags: u128 = if pay_in { escrow::FLAG_PAY_IN } else { 0 } +
        if pay_out { escrow::FLAG_PAY_OUT } else { 0 } +
        if reputation { escrow::FLAG_REPUTATION } else { 0 };

    let escrow = escrow::EscrowData {
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
        claimer_bounty
    };

    (sender, escrow, signer)
}

fn init_escrow_and_assert(
    context: Context,
    sender: ContractAddress, escrow: escrow::EscrowData, signer: KeyPair<felt252, felt252>,
    timeout: u64, current_time: u64
) {
    let balance_erc20 = context.token.balance_of(escrow.offerer);
    let balance_contract = *ILPVaultDispatcher{contract_address: context.contract_address}.get_balance(array![(escrow.offerer, context.token.contract_address)].span()).span()[0];
    let balance_erc20_contract = context.token.balance_of(context.contract_address);

    let balance_gas_erc20 = context.gas_token.balance_of(sender);
    let balance_gas_erc20_contract = context.gas_token.balance_of(context.contract_address);

    let (r, s) = signer.sign(escrow.get_struct_hash()).expect('Failed to sign');

    //Increase allowance for token
    //Increase allowance for gas token

    cheat_caller_address(context.contract_address, sender, CheatSpan::TargetCalls(1));
    cheat_block_timestamp(context.contract_address, current_time, CheatSpan::TargetCalls(1));
    IEscrowManagerDispatcher{contract_address: context.contract_address}.initialize(escrow, array![r, s], timeout, "");
    
    //Assert event emitted

    //Assert escrow state saved

    if escrow.is_pay_in() {
        assert_eq!(context.token.balance_of(escrow.offerer), balance_erc20-escrow.amount);
        assert_eq!(context.token.balance_of(context.contract_address), balance_erc20_contract+escrow.amount);
    } else {
        assert_eq!(ILPVaultDispatcher{contract_address: context.contract_address}.get_balance(array![(escrow.offerer, context.token.contract_address)].span()), array![balance_contract-escrow.amount]);
    }

    if escrow.security_deposit != 0 || escrow.claimer_bounty != 0 {
        let max = if escrow.security_deposit > escrow.claimer_bounty { escrow.security_deposit } else { escrow.claimer_bounty };
        assert_eq!(context.gas_token.balance_of(sender), balance_gas_erc20-max);
        assert_eq!(context.gas_token.balance_of(context.contract_address), balance_gas_erc20_contract+max);
    }

}

#[test]
fn valid_initialize() {
    let context = get_context();
    let (sender, escrow, signature) = create_escrow_data(context)
}