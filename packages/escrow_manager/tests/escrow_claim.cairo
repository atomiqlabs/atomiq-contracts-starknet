use snforge_std::{
    cheat_caller_address, CheatSpan, generate_random_felt, spy_events, cheat_block_number
};
use snforge_std::signature::stark_curve::{StarkCurveKeyPairImpl, StarkCurveSignerImpl};

use starknet::contract_address::{ContractAddress};

use escrow_manager::{IEscrowManagerSafeDispatcher, IEscrowManagerSafeDispatcherTrait};
use escrow_manager::components::lp_vault::{ILPVaultDispatcher, ILPVaultDispatcherTrait};
use escrow_manager::structs::escrow::{EscrowDataImpl, EscrowDataImplTrait};
use escrow_manager::structs;

use crate::utils::contract::{get_context, Context};
use crate::utils::result::{assert_result, assert_result_error};
use crate::utils::escrow::{create_escrow_data, init_escrow_and_assert, _init_escrow_and_assert};

use openzeppelin_token::erc20::ERC20ABIDispatcherTrait;

const CLAIM_BLOCK_NUMBER: u64 = 92348243;

fn claim_escrow(
    context: Context,
    escrow: structs::escrow::EscrowData,
    witness: Span<felt252>
) -> Result<(), felt252> {
    let balance_erc20 = context.token.balance_of(escrow.claimer);
    let balance_contract = *ILPVaultDispatcher{contract_address: context.contract_address}.get_balance(array![(escrow.offerer, context.token.contract_address)].span()).span()[0];
    let balance_erc20_contract = context.token.balance_of(context.contract_address);

    let external_claimer: ContractAddress = generate_random_felt().try_into().unwrap();
    let balance_gas_erc20_claimer = context.gas_token.balance_of(escrow.claimer);
    let balance_gas_erc20_ext_claimer = context.gas_token.balance_of(external_claimer);
    let balance_gas_erc20_contract = context.gas_token.balance_of(context.contract_address);

    let mut spy = spy_events();

    cheat_caller_address(context.contract_address, external_claimer, CheatSpan::TargetCalls(1));
    cheat_block_number(context.contract_address, CLAIM_BLOCK_NUMBER, CheatSpan::TargetCalls(1));
    let result = IEscrowManagerSafeDispatcher{contract_address: context.contract_address}.initialize(escrow, array![r, s], timeout, "");
    if result.is_err() {
        return Result::Err(*result.unwrap_err().span()[0]);
    }

    //Assert event emitted
    spy.assert_emitted(
        @array![(context.contract_address, EscrowManager::Event::Initialize(events::Initialize {
            offerer: escrow.offerer,
            claimer: escrow.claimer,
            claim_data: escrow.claim_data,
            escrow_hash
        }))]
    );

    //Assert escrow state saved
    if (IEscrowStorageDispatcher{contract_address: context.contract_address}.get_state(escrow) != state::escrow::EscrowState {
        init_blockheight: INIT_BLOCK_NUMBER,
        finish_blockheight: 0,
        state: state::escrow::STATE_COMMITTED
    }) { return Result::Err('test: state'); };

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
