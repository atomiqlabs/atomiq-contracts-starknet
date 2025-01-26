use starknet::ContractAddress;
use crate::state::reputation::{Reputation, ReputationStorePacking};

#[starknet::interface]
pub trait IReputationTracker<TContractState> {
    fn get_reputation(self: @TContractState, data: Span<(ContractAddress, ContractAddress, ContractAddress)>) -> Array<[Reputation; 3]>;
}

#[starknet::component]
pub mod reputation {
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use core::starknet::ContractAddress;
    use crate::state::reputation::{Reputation, ReputationStorePacking, ReputationUpdateTrait, ReputationUpdate};

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
        fn get_reputation(self: @ComponentState<TContractState>, data: Span<(ContractAddress, ContractAddress, ContractAddress)>) -> Array<[Reputation; 3]> {
            let mut result: Array<[Reputation; 3]> = array![];
            for (owner, token, claim_handler) in data {
                let ptr = self.reputation.entry(*owner).entry(*token).entry(*claim_handler);
                result.append([
                    ptr.entry(REPUTATION_SUCCESS).read(), ptr.entry(REPUTATION_COOP_REFUND).read(), ptr.entry(REPUTATION_FAILED).read()
                ]);
            };
            result
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
            reputation.update(amount);
            reputation_ptr.write(reputation);
        }
    }

}
