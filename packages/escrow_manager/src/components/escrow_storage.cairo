use crate::state::escrow::EscrowState;
use crate::structs::escrow::EscrowData;

#[starknet::interface]
pub trait IEscrowStorage<TContractState> {
    //Read the current state of the escrow
    fn get_state(self: @TContractState, escrow: EscrowData) -> EscrowState;
    //Read the current state of the escrow, based on its hash
    fn get_hash_state(self: @TContractState, escrow_hash: felt252) -> EscrowState;
}

#[starknet::component]
pub mod escrow_storage {
    use super::IEscrowStorage;
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use core::starknet::get_block_number;
    use crate::structs::escrow::{EscrowData, EscrowDataImpl};
    use crate::state::escrow::{
        EscrowState, EscrowStateStorePacking, STATE_NOT_COMMITTED, 
        STATE_COMMITTED, STATE_CLAIMED, STATE_REFUNDED
    };

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {}

    #[storage]
    pub struct Storage {
        escrow_state: Map<felt252, EscrowState>,
    }

    #[embeddable_as(EscrowStorage)]
    pub impl EscrowStorageImpl<
        TContractState, +HasComponent<TContractState>,
    > of super::IEscrowStorage<ComponentState<TContractState>> {

        fn get_state(self: @ComponentState<TContractState>, escrow: EscrowData) -> EscrowState {
            let hash = escrow.get_struct_hash();
            self.get_hash_state(hash)
        }
        
        fn get_hash_state(self: @ComponentState<TContractState>, escrow_hash: felt252) -> EscrowState {
            let escrow_state = self.escrow_state.entry(escrow_hash).read();
            escrow_state
        }

    }

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>,
    > of InternalTrait<TContractState> {

        //Commits/saves the escrow to the on-chain storage with COMMITTED state, fails if 
        // escrow is/was already initialized
        fn _commit(ref self: ComponentState<TContractState>, escrow: EscrowData) -> felt252 {
            //Check if already committed
            let escrow_hash = escrow.get_struct_hash();
            let escrow_state = self.escrow_state.entry(escrow_hash).read();
            assert(escrow_state.state==STATE_NOT_COMMITTED, '_commit: Already committed');

            //Commit
            self.escrow_state.entry(escrow_hash).write(EscrowState {
                state: STATE_COMMITTED,
                init_blockheight: get_block_number(),
                finish_blockheight: 0
            });

            escrow_hash
        }

        //Finalizes the escrow state on-chain, fails if escrow is not initialized/committed
        fn _finalize(ref self: ComponentState<TContractState>, escrow: EscrowData, success: bool) -> felt252 {
            //Check committed
            let escrow_hash = escrow.get_struct_hash();
            let escrow_ptr = self.escrow_state.entry(escrow_hash);
            let mut escrow_state = escrow_ptr.read();
            assert(escrow_state.state==STATE_COMMITTED, '_finalize: Not committed');

            //Set state to claimed
            escrow_state.finish_blockheight = get_block_number();
            escrow_state.state = if success { STATE_CLAIMED } else { STATE_REFUNDED };
            escrow_ptr.write(escrow_state);

            escrow_hash
        }

    }

}
