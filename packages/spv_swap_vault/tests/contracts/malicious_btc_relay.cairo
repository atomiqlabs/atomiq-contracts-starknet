use btc_relay::structs::stored_blockheader::StoredBlockHeader;

#[starknet::interface]
pub trait IMaliciousBtcRelay<TContractState> {
    fn get_chainwork(self: @TContractState) -> u256;
    fn get_blockheight(self: @TContractState) -> u32;
    fn verify_blockheader(ref self: TContractState, stored_header: StoredBlockHeader) -> u32;
    fn get_commit_hash(self: @TContractState, height: u32) -> felt252;
    fn get_tip_commit_hash(self: @TContractState) -> felt252;
}

#[starknet::contract]
pub mod MaliciousBtcRelay {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use starknet::contract_address::ContractAddress;
    use btc_relay::structs::stored_blockheader::StoredBlockHeader;
    use spv_swap_vault::{ISpvVaultManagerDispatcher, ISpvVaultManagerDispatcherTrait};
    use super::IMaliciousBtcRelay;

    #[storage]
    struct Storage {
        spv_vault: ContractAddress,
        owner: ContractAddress,
        vault_id: felt252,
        transaction: ByteArray,
        reentered: bool
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        spv_vault: ContractAddress,
        owner: ContractAddress,
        vault_id: felt252,
        transaction: ByteArray
    ) {
        self.spv_vault.write(spv_vault);
        self.owner.write(owner);
        self.vault_id.write(vault_id);
        self.transaction.write(transaction);
        self.reentered.write(false);
    }

    #[abi(embed_v0)]
    impl MaliciousBtcRelayImpl of IMaliciousBtcRelay<ContractState> {
        fn get_chainwork(self: @ContractState) -> u256 {
            0
        }

        fn get_blockheight(self: @ContractState) -> u32 {
            2
        }

        fn verify_blockheader(ref self: ContractState, stored_header: StoredBlockHeader) -> u32 {
            if !self.reentered.read() {
                self.reentered.write(true);
                ISpvVaultManagerDispatcher { contract_address: self.spv_vault.read() }.claim(
                    self.owner.read(),
                    self.vault_id.read(),
                    self.transaction.read(),
                    stored_header,
                    array![].span(),
                    0
                );
            }

            3
        }

        fn get_commit_hash(self: @ContractState, height: u32) -> felt252 {
            0
        }

        fn get_tip_commit_hash(self: @ContractState) -> felt252 {
            0
        }
    }
}
