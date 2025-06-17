pub mod sighash;
pub mod utils;
pub mod events;
pub mod state;
pub mod structs;
pub mod components;

use crate::structs::escrow::EscrowData;

#[starknet::interface]
pub trait IEscrowManager<TContractState> {
    //Initializes the escrow
    fn initialize(ref self: TContractState, escrow: EscrowData, signature: Array<felt252>, timeout: u64, extra_data: Span<felt252>);
    //Claims the escrow by providing a witness to the claim handler
    fn claim(ref self: TContractState, escrow: EscrowData, witness: Array<felt252>);
    //Refunds the escrow by providing a witness to the refund handler
    fn refund(ref self: TContractState, escrow: EscrowData, witness: Array<felt252>);
    //Cooperatively refunds the escrow with a valid signature from claimer
    fn cooperative_refund(ref self: TContractState, escrow: EscrowData, signature: Array<felt252>, timeout: u64);
}

#[starknet::contract]
pub mod EscrowManager {
    use core::num::traits::SaturatingSub;
    use starknet::event::EventEmitter;
    use core::starknet::{get_execution_info, get_caller_address};
    use starknet::contract_address::ContractAddress;
    use crate::structs::escrow::{EscrowExecution, EscrowData, EscrowDataImpl, EscrowDataImplTrait};
    use crate::sighash;
    use crate::utils::snip6;
    use crate::events;
    use common::handlers::claim::{IClaimHandlerDispatcher, IClaimHandlerDispatcherTrait};
    use common::handlers::refund::{IRefundHandlerDispatcher, IRefundHandlerDispatcherTrait};
    use crate::components::lp_vault::lp_vault;
    use crate::components::reputation::reputation;
    use crate::components::escrow_storage::escrow_storage;
    use execution_contract::{IExecutionContractDispatcher, IExecutionContractDispatcherTrait};
    
    component!(path: lp_vault, storage: lp_vault, event: LPVaultEvent);
    component!(path: reputation, storage: reputation, event: ReputationTrackerEvent);
    component!(path: escrow_storage, storage: escrow_storage, event: EscrowStorageEvent);

    #[storage]
    struct Storage {
        #[substorage(v0)]
        lp_vault: lp_vault::Storage,
        #[substorage(v0)]
        reputation: reputation::Storage,
        #[substorage(v0)]
        escrow_storage: escrow_storage::Storage
    }

    #[abi(embed_v0)]
    impl LPVaultImpl = lp_vault::LPVault<ContractState>;
    impl LPVaultInternalImpl = lp_vault::InternalImpl<ContractState>;
    
    #[abi(embed_v0)]
    impl ReputationTrackerImpl = reputation::ReputationTracker<ContractState>;
    impl ReputationTrackerInternalImpl = reputation::InternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl EscrowStorageImpl = escrow_storage::EscrowStorage<ContractState>;
    impl EscrowStorageInternalImpl = escrow_storage::InternalImpl<ContractState>;

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        LPVaultEvent: lp_vault::Event,
        ReputationTrackerEvent: reputation::Event,
        EscrowStorageEvent: escrow_storage::Event,

        Initialize: events::Initialize,
        Claim: events::Claim,
        Refund: events::Refund
    }

    #[abi(embed_v0)]
    impl EscrowManagerImpl of super::IEscrowManager<ContractState> {
        //extra_data parameter is used for data-availability/propagation of escrow-specific extraneous data on-chain
        // and is therefore unused in the function itself
        fn initialize(ref self: ContractState, escrow: EscrowData, signature: Array<felt252>, timeout: u64, extra_data: Span<felt252>) {
            //Check expiry
            let execution_info = get_execution_info();
            assert(execution_info.block_info.block_timestamp < timeout, 'init: Authorization expired');
            
            //Check committed
            let escrow_hash = self.escrow_storage._commit(escrow);

            //Verify signature
            let caller = execution_info.caller_address;
            if caller == escrow.offerer {
                //Here we only require signature in case the reputation tracking flag is set,
                // otherwise there is no harm done to the claimer even if he were to be spammed
                // with many escrows
                if escrow.is_tracking_reputation() {
                    snip6::verify_signature(escrow.claimer, sighash::get_init_sighash(escrow, escrow_hash, timeout, escrow.claimer), signature);
                }
            } else if caller == escrow.claimer {
                //In this case we always require signature because we are taking funds from the offerer
                snip6::verify_signature(escrow.offerer, sighash::get_init_sighash(escrow, escrow_hash, timeout, escrow.offerer), signature);
            } else {
                panic(array!['init: caller_address'])
            };

            //Transfer deposit
            let deposit_amount = escrow.get_total_deposit();
            if deposit_amount!=0 { erc20_utils::transfer_in(escrow.fee_token, caller, deposit_amount) };

            //Transfer funds
            self._pay_in(escrow.offerer, escrow.token, escrow.amount, escrow.is_pay_in());

            //Emit event
            self.emit(events::Initialize {
                offerer: escrow.offerer,
                claimer: escrow.claimer,
                claim_data: escrow.claim_data,
                escrow_hash: escrow_hash,

                claim_handler: escrow.claim_handler,
                refund_handler: escrow.refund_handler
            });
        }

        fn claim(ref self: ContractState, escrow: EscrowData, witness: Array<felt252>) {
            //Check committed
            let escrow_hash = self.escrow_storage._finalize(escrow, true);

            //Check claim data
            let claim_dispatcher = IClaimHandlerDispatcher { contract_address: escrow.claim_handler };
            let claim_result = claim_dispatcher.claim(escrow.claim_data, witness);

            //Update reputation
            if escrow.is_tracking_reputation() {
                self.reputation._update_reputation(reputation::REPUTATION_SUCCESS, escrow.claimer, escrow.token, escrow.claim_handler, escrow.amount);
            }

            //Pay out claimer bounty
            if escrow.claimer_bounty != 0 {
                let caller = get_caller_address();
                erc20_utils::transfer_out(escrow.fee_token, caller, escrow.claimer_bounty);
            }
            let security_deposit = escrow.security_deposit.saturating_sub(escrow.claimer_bounty);
            if security_deposit != 0 {
                erc20_utils::transfer_out(escrow.fee_token, escrow.claimer, security_deposit);
            }

            if escrow.success_action.is_some() {
                //Transfer funds to execution contract in case success action was defined
                self._to_execution_contract(escrow.claimer, escrow.token, escrow.amount, escrow.is_pay_out(), escrow.success_action.unwrap(), escrow_hash);
            } else {
                //Pay out directly to the claimer
                self._pay_out(escrow.claimer, escrow.token, escrow.amount, escrow.is_pay_out());
            }

            //Emit event
            self.emit(events::Claim {
                offerer: escrow.offerer,
                claimer: escrow.claimer,
                claim_data: escrow.claim_data,
                escrow_hash: escrow_hash,
                witness_result: claim_result,
                claim_handler: escrow.claim_handler
            });
        }

        fn refund(ref self: ContractState, escrow: EscrowData, witness: Array<felt252>) {
            //Check committed
            let escrow_hash = self.escrow_storage._finalize(escrow, false);

            //Check refund data
            let refund_dispatcher = IRefundHandlerDispatcher { contract_address: escrow.refund_handler };
            let refund_result = refund_dispatcher.refund(escrow.refund_data, witness);

            //Update reputation
            if escrow.is_tracking_reputation() {
                self.reputation._update_reputation(reputation::REPUTATION_FAILED, escrow.claimer, escrow.token, escrow.claim_handler, escrow.amount);
            }

            //Pay out security deposit
            if escrow.security_deposit != 0 {
                erc20_utils::transfer_out(escrow.fee_token, escrow.offerer, escrow.security_deposit);
            }
            let claimer_bounty = escrow.claimer_bounty.saturating_sub(escrow.security_deposit);
            if claimer_bounty != 0 {
                erc20_utils::transfer_out(escrow.fee_token, escrow.claimer, claimer_bounty);
            }

            //Refund funds
            self._pay_out(escrow.offerer, escrow.token, escrow.amount, escrow.is_pay_in());

            //Emit event
            self.emit(events::Refund {
                offerer: escrow.offerer,
                claimer: escrow.claimer,
                claim_data: escrow.claim_data,
                escrow_hash: escrow_hash,
                witness_result: refund_result,
                refund_handler: escrow.refund_handler
            });
        }

        fn cooperative_refund(ref self: ContractState, escrow: EscrowData, signature: Array<felt252>, timeout: u64) {
            //Check expiry
            let execution_info = get_execution_info();
            assert(execution_info.block_info.block_timestamp < timeout, 'coop_refund: Auth expired');
            
            //Check committed
            let escrow_hash = self.escrow_storage._finalize(escrow, false);

            //Check refund signature
            let sighash = sighash::get_refund_sighash(escrow_hash, timeout, escrow.claimer);
            snip6::verify_signature(escrow.claimer, sighash, signature);

            //Update reputation
            if escrow.is_tracking_reputation() {
                self.reputation._update_reputation(reputation::REPUTATION_COOP_REFUND, escrow.claimer, escrow.token, escrow.claim_handler, escrow.amount);
            }

            //Pay out the whole deposit
            let deposit_amount = if escrow.security_deposit > escrow.claimer_bounty { escrow.security_deposit } else { escrow.claimer_bounty };
            erc20_utils::transfer_out(escrow.fee_token, escrow.claimer, deposit_amount);

            //Refund funds
            self._pay_out(escrow.offerer, escrow.token, escrow.amount, escrow.is_pay_in());

            //Emit event
            self.emit(events::Refund {
                offerer: escrow.offerer,
                claimer: escrow.claimer,
                claim_data: escrow.claim_data,
                escrow_hash: escrow_hash,
                witness_result: array![].span(),
                refund_handler: 0.try_into().unwrap()
            });
        }
    }

    #[generate_trait]
    impl EscrowManagerPrivate of EscrowManagerPrivateTrait {
        //Pays the funds out either to an external account, or to the LP vault depending on the pay_out param
        fn _pay_out(ref self: ContractState, dst: ContractAddress, token: ContractAddress, amount: u256, pay_out: bool) {
            if pay_out {
                erc20_utils::transfer_out(token, dst, amount);
            } else {
                self.lp_vault._transfer_out(token, dst, amount);
            }
        }

        //Takes the funds from from an external account, or from the LP vault depending on the pay_in param
        fn _pay_in(ref self: ContractState, src: ContractAddress, token: ContractAddress, amount: u256, pay_in: bool) {
            if pay_in {
                erc20_utils::transfer_in(token, src, amount);
            } else {
                self.lp_vault._transfer_in(token, src, amount);
            }
        }

        //Create the execution in execution contract
        fn _to_execution_contract(ref self: ContractState, dst: ContractAddress, token: ContractAddress, amount: u256, pay_out: bool, escrow_execution: EscrowExecution, escrow_hash: felt252) {
            if amount < escrow_execution.fee {
                //Fee is larger than the full amount, just pay out as a fallback
                self._pay_out(dst, token, amount, pay_out);
                return;
            }
            
            let execution_contract = IExecutionContractDispatcher{contract_address: escrow_execution.contract};

            erc20_utils::approve(token, execution_contract.contract_address, amount);
            execution_contract.create(dst, escrow_hash, token, amount - escrow_execution.fee, escrow_execution.fee, escrow_execution.hash, escrow_execution.expiry);
        }
    }

}
