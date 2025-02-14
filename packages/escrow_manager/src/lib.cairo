pub mod sighash;
pub mod utils;
pub mod events;
pub mod state;
pub mod structs;
pub mod components;
pub mod execution_proxy;

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
    use starknet::syscalls::deploy_syscall;
    use crate::structs::escrow::{EscrowData, EscrowDataImpl};
    use crate::sighash;
    use crate::utils::snip6;
    use crate::utils::erc20;
    use crate::events;
    use common::handlers::claim::{IClaimHandlerDispatcher, IClaimHandlerDispatcherTrait};
    use common::handlers::refund::{IRefundHandlerDispatcher, IRefundHandlerDispatcherTrait};
    use crate::components::lp_vault::lp_vault;
    use crate::components::reputation::reputation;
    use crate::components::escrow_storage::escrow_storage;
    use crate::execution_proxy::{IExecutionProxySafeDispatcher, IExecutionProxySafeDispatcherTrait};
    use crate::structs::contract_call::ContractCall;
    use core::starknet::storage::{StoragePointerWriteAccess, StoragePointerReadAccess};
    
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

        execution_proxy: ContractAddress
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
        Refund: events::Refund,
        SuccessActionExecuteError: events::SuccessActionExecuteError
    }

    //Initialize execution proxy
    #[constructor]
    fn constructor(ref self: ContractState) {
        let (execution_proxy_address, _) = deploy_syscall(
            0x6a0346eb010f4db93ebd29a62b82bab22176e457d55efb9d449fb1d3655b30f.try_into().unwrap(),
            0,
            array![].span(),
            false
        ).unwrap();
        self.execution_proxy.write(execution_proxy_address);
    }

    #[abi(embed_v0)]
    impl EscrowManagerImpl of super::IEscrowManager<ContractState> {
        fn initialize(ref self: ContractState, escrow: EscrowData, signature: Array<felt252>, timeout: u64, extra_data: Span<felt252>) {
            //Check expiry
            let execution_info = get_execution_info();
            assert(execution_info.block_info.block_timestamp < timeout, 'init: Authorization expired');
            
            //Check committed
            let escrow_hash = self.escrow_storage._commit(escrow);

            //Verify signature
            let caller = execution_info.caller_address;
            let signer = if caller == escrow.offerer {
                escrow.claimer
            } else if caller == escrow.claimer {
                escrow.offerer
            } else {
                panic(array!['init: caller_address'])
            };

            let sighash = sighash::get_init_sighash(escrow_hash, timeout, signer);
            snip6::verify_signature(signer, sighash, signature);

            //Transfer deposit
            let deposit_amount = escrow.get_total_deposit();
            if deposit_amount!=0 { erc20::transfer_in(escrow.fee_token, caller, deposit_amount) };

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
                erc20::transfer_out(escrow.fee_token, caller, escrow.claimer_bounty);
            }
            let security_deposit = escrow.security_deposit.saturating_sub(escrow.claimer_bounty);
            if security_deposit != 0 {
                erc20::transfer_out(escrow.fee_token, escrow.claimer, security_deposit);
            }

            if escrow.success_action.len()==0 {
                //Pay out funds
                self._pay_out(escrow.claimer, escrow.token, escrow.amount, escrow.is_pay_out());
            } else {
                //Execute success action
                self._execute_and_pay_out(escrow.claimer, escrow.token, escrow.amount, escrow.success_action, escrow.is_pay_out())
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
                erc20::transfer_out(escrow.fee_token, escrow.offerer, escrow.security_deposit);
            }
            let claimer_bounty = escrow.claimer_bounty.saturating_sub(escrow.security_deposit);
            if claimer_bounty != 0 {
                erc20::transfer_out(escrow.fee_token, escrow.claimer, claimer_bounty);
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
            erc20::transfer_out(escrow.fee_token, escrow.claimer, deposit_amount);

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
                erc20::transfer_out(token, dst, amount);
            } else {
                self.lp_vault._transfer_out(token, dst, amount);
            }
        }

        //Takes the funds from from an external account, or from the LP vault depending on the pay_in param
        fn _pay_in(ref self: ContractState, src: ContractAddress, token: ContractAddress, amount: u256, pay_in: bool) {
            if pay_in {
                erc20::transfer_in(token, src, amount);
            } else {
                self.lp_vault._transfer_in(token, src, amount);
            }
        }

        fn _execute_and_pay_out(ref self: ContractState, dst: ContractAddress, token: ContractAddress, amount: u256, success_action: Span<ContractCall>, pay_out: bool) {
            let execution_proxy_address = self.execution_proxy.read();
            //Transfer funds to execution proxy
            erc20::transfer_out(token, execution_proxy_address, amount);
            
            //Try to execute actions
            let execution_proxy = IExecutionProxySafeDispatcher{contract_address: execution_proxy_address};
            let call_result = execution_proxy.execute(success_action);

            //Emit event on failure
            if call_result.is_err() {
                let error = call_result.unwrap_err();
                self.emit(events::SuccessActionExecuteError { error: error.span() });
            }

            //Make sure the execution proxy is left with 0 balance, if not withdraw the balance back to us and pay it out regularly,
            // this also handles the case when the execution fails
            let leaves_balance = erc20::balance_of(token, execution_proxy_address);
            if leaves_balance!=0 {
                //Reclaim funds from execution proxy
                execution_proxy.reclaim_erc20(token, leaves_balance).unwrap();
                //Pay out as regular
                self._pay_out(dst, token, leaves_balance, pay_out);
            }
        }
    }

}
