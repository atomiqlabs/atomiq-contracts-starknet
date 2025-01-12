use starknet::ContractAddress;
use crate::state::reputation::{Reputation, ReputationStorePacking};

#[starknet::interface]
pub trait IReputationTracker<TContractState> {
    fn get_reputation(self: @TContractState, owners: Span<ContractAddress>, tokens: Span<ContractAddress>, claim_handlers: Span<ContractAddress>) -> Array<Array<Array<[Reputation; 3]>>>;
}

#[starknet::component]
pub mod reputation {
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use core::starknet::ContractAddress;
    use core::num::traits::SaturatingAdd;
    use crate::state::reputation::{Reputation, ReputationStorePacking};

    pub const REPUTATION_SUCCESS: felt252 = 0;
    pub const REPUTATION_COOP_REFUND: felt252 = 1;
    pub const REPUTATION_FAILED: felt252 = 2;

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {}

    #[storage]
    pub struct Storage {
        reputation: Map<ContractAddress, Map<ContractAddress, Map<ContractAddress, Map<felt252, Reputation>>>>,
    }

    #[embeddable_as(ReputationTracker)]
    pub impl ReputationTrackerImpl<
        TContractState, +HasComponent<TContractState>,
    > of super::IReputationTracker<ComponentState<TContractState>> {
        fn get_reputation(self: @ComponentState<TContractState>, owners: Span<ContractAddress>, tokens: Span<ContractAddress>, claim_handlers: Span<ContractAddress>) -> Array<Array<Array<[Reputation; 3]>>> {
            let mut _owners: Array<Array<Array<[Reputation; 3]>>> = array![];
            for owner in owners {
                let mut _tokens: Array<Array<[Reputation; 3]>> = array![];
                for token in tokens {
                    let mut _claim_handlers: Array<[Reputation; 3]> = array![];
                    for claim_handler in claim_handlers {
                        let ptr = self.reputation.entry(*owner).entry(*token).entry(*claim_handler);
                        _claim_handlers.append([
                            ptr.entry(REPUTATION_SUCCESS).read(), ptr.entry(REPUTATION_COOP_REFUND).read(), ptr.entry(REPUTATION_FAILED).read()
                        ]);
                    };
                    _tokens.append(_claim_handlers);
                };
                _owners.append(_tokens);
            };
            _owners
        }
    }

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>,
    > of InternalTrait<TContractState> {
        fn _update_reputation(
            ref self: ComponentState<TContractState>, 
            reputation_type: felt252, 
            claimer: ContractAddress, 
            token: ContractAddress, 
            claim_handler: ContractAddress, 
            amount: u256
        ) {
            let reputation_ptr = self.reputation.entry(claimer).entry(token).entry(claim_handler).entry(reputation_type);
            let mut reputation = reputation_ptr.read();
            reputation.amount = reputation.amount.saturating_add(amount);
            reputation.count = reputation.count.saturating_add(1);
            reputation_ptr.write(reputation);
        }
    }

}
