pub mod sighash;
pub mod utils;
pub mod events;
pub mod state;
pub mod structs;
pub mod components;

use crate::structs::escrow::EscrowData;

#[starknet::interface]
pub trait IEscrowManager<TContractState> {
    fn initialize(ref self: TContractState, escrow: EscrowData, signature: Array<felt252>, timeout: u64, extra_data: ByteArray);
    fn claim(ref self: TContractState, escrow: EscrowData, witness: Array<felt252>);
    fn refund(ref self: TContractState, escrow: EscrowData, witness: Array<felt252>);
    fn cooperative_refund(ref self: TContractState, escrow: EscrowData, signature: Array<felt252>, timeout: u64);
}

#[starknet::contract]
mod EscrowManager {
    use core::num::traits::SaturatingSub;
    use starknet::event::EventEmitter;
    use core::starknet::{get_execution_info, get_caller_address};
    use crate::structs::escrow::{EscrowData, EscrowDataStructHash};
    use crate::sighash;
    use crate::utils::snip6;
    use crate::utils::erc20;
    use crate::events;
    use common::handlers::claim::{IClaimHandlerDispatcher, IClaimHandlerDispatcherTrait};
    use common::handlers::refund::{IRefundHandlerDispatcher, IRefundHandlerDispatcherTrait};
    use crate::components::lp_vault::lp_vault;
    use crate::components::reputation::reputation;
    use crate::components::escrow_storage::escrow_storage;

    const FLAG_PAY_OUT: u128 = 0x01;
    const FLAG_PAY_IN: u128 = 0x02;
    const FLAG_REPUTATION: u128 = 0x04;
    
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
        escrow_storage: escrow_storage::Storage,
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
        fn initialize(ref self: ContractState, escrow: EscrowData, signature: Array<felt252>, timeout: u64, extra_data: ByteArray) {
            //Check expiry
            let execution_info = get_execution_info();
            assert(execution_info.block_info.block_timestamp > timeout, 'init: Authorization expired');
            
            //Check committed
            let escrow_hash = self.escrow_storage._commit(escrow);

            //Verify signature
            let caller = execution_info.caller_address;
            let signer = if caller == escrow.offerer {
                escrow.claimer
            } else if caller == escrow.claimer {
                escrow.offerer
            } else {
                panic(array!['init: caller_address']);
                return;
            };

            let sighash = sighash::get_init_sighash(escrow_hash, timeout, signer);
            snip6::verify_signature(signer, sighash, signature);

            //Transfer deposit
            let deposit_amount = if escrow.security_deposit > escrow.claimer_bounty { escrow.security_deposit } else { escrow.claimer_bounty };
            erc20::transfer_in(escrow.fee_token, caller, deposit_amount);

            //Transfer funds
            self.lp_vault._pay_in(escrow.offerer, escrow.token, escrow.amount, escrow.flags & FLAG_PAY_IN == FLAG_PAY_IN);

            //Emit event
            self.emit(events::Initialize {
                offerer: escrow.offerer,
                claimer: escrow.claimer,
                claim_data: escrow.claim_data,
                escrow_hash: escrow_hash
            });
        }

        fn claim(ref self: ContractState, escrow: EscrowData, witness: Array<felt252>) {
            //Check committed
            let escrow_hash = self.escrow_storage._uncommit(escrow, true);

            //Check claim data
            let claim_dispatcher = IClaimHandlerDispatcher { contract_address: escrow.claim_handler };
            let claim_result = claim_dispatcher.claim(escrow.claim_data, witness);

            //Update reputation
            if escrow.flags & FLAG_REPUTATION == FLAG_REPUTATION {
                self.reputation._update_reputation(reputation::REPUTATION_SUCCESS, escrow.claimer, escrow.token, escrow.claim_handler, escrow.amount);
            }

            //Pay out claimer bounty
            if escrow.claimer_bounty != 0 {
                let caller = get_caller_address();
                erc20::transfer_out(escrow.fee_token, caller, escrow.claimer_bounty);
            }
            let security_deposit = escrow.security_deposit.saturating_sub(escrow.claimer_bounty);
            if security_deposit != 0 {
                erc20::transfer_out(escrow.fee_token, escrow.claimer, security_deposit);
            }

            //Pay out funds or execute success actions
            if escrow.success_action.len() == 0 {
                self.lp_vault._pay_out(escrow.claimer, escrow.token, escrow.amount, escrow.flags & FLAG_PAY_OUT == FLAG_PAY_OUT);
            } else {
                
            }

            //Emit event
            self.emit(events::Claim {
                offerer: escrow.offerer,
                claimer: escrow.claimer,
                claim_data: escrow.claim_data,
                escrow_hash: escrow_hash,
                witness_result: claim_result
            });
        }

        fn refund(ref self: ContractState, escrow: EscrowData, witness: Array<felt252>) {
            //Check committed
            let escrow_hash = self.escrow_storage._uncommit(escrow, false);

            //Check refund data
            let refund_dispatcher = IRefundHandlerDispatcher { contract_address: escrow.refund_handler };
            let refund_result = refund_dispatcher.refund(escrow.refund_data, witness);

            //Update reputation
            if escrow.flags & FLAG_REPUTATION == FLAG_REPUTATION {
                self.reputation._update_reputation(reputation::REPUTATION_FAILED, escrow.claimer, escrow.token, escrow.claim_handler, escrow.amount);
            }

            //Pay out claimer bounty
            if escrow.security_deposit != 0 {
                erc20::transfer_out(escrow.fee_token, escrow.offerer, escrow.security_deposit);
            }
            let claimer_bounty = escrow.claimer_bounty.saturating_sub(escrow.security_deposit);
            if claimer_bounty != 0 {
                erc20::transfer_out(escrow.fee_token, escrow.claimer, claimer_bounty);
            }

            //Refund funds
            self.lp_vault._pay_out(escrow.offerer, escrow.token, escrow.amount, escrow.flags & FLAG_PAY_IN == FLAG_PAY_IN);

            //Emit event
            self.emit(events::Refund {
                offerer: escrow.offerer,
                claimer: escrow.claimer,
                claim_data: escrow.claim_data,
                escrow_hash: escrow_hash,
                witness_result: refund_result
            });
        }

        fn cooperative_refund(ref self: ContractState, escrow: EscrowData, signature: Array<felt252>, timeout: u64) {
            //Check expiry
            let execution_info = get_execution_info();
            assert(execution_info.block_info.block_timestamp > timeout, 'coop_refund: Auth expired');
            
            //Check committed
            let escrow_hash = self.escrow_storage._uncommit(escrow, false);

            //Check refund signature
            let sighash = sighash::get_refund_sighash(escrow_hash, timeout, escrow.claimer);
            snip6::verify_signature(escrow.claimer, sighash, signature);

            //Update reputation
            if escrow.flags & FLAG_REPUTATION == FLAG_REPUTATION {
                self.reputation._update_reputation(reputation::REPUTATION_COOP_REFUND, escrow.claimer, escrow.token, escrow.claim_handler, escrow.amount);
            }

            //Pay out claimer bounty
            let deposit_amount = if escrow.security_deposit > escrow.claimer_bounty { escrow.security_deposit } else { escrow.claimer_bounty };
            erc20::transfer_out(escrow.fee_token, escrow.claimer, deposit_amount);

            //Refund funds
            self.lp_vault._pay_out(escrow.offerer, escrow.token, escrow.amount, escrow.flags & FLAG_PAY_IN == FLAG_PAY_IN);

            //Emit event
            self.emit(events::Refund {
                offerer: escrow.offerer,
                claimer: escrow.claimer,
                claim_data: escrow.claim_data,
                escrow_hash: escrow_hash,
                witness_result: array![].span()
            });
        }
    }
}
