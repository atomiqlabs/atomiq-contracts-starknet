use super::utils::U32ArrayToU256ParserTrait;
use core::starknet::storage_access::StorePacking;
use core::starknet::contract_address::ContractAddress;
use crate::utils::U32ArrayToU256Parser;

//State of the specific vault
#[derive(Drop, Serde, PartialEq, Debug, Copy)]
pub struct SpvVaultState {
    pub relay_contract: ContractAddress,
    pub token_0: ContractAddress,
    pub token_1: ContractAddress,

    pub utxo: (u256, u32),
    pub confirmations: u8,

    pub token_0_amount: u256,
    pub token_1_amount: u256,

    //Since space in bitcoin is limited, we only use 7 bytes to express the amount,
    // this is then multiplied by the provided multipliers
    pub token_0_multiplier: felt252,
    pub token_1_multiplier: felt252
}

const TWO_POW_248: u256 = 0x100000000000000000000000000000000000000000000000000000000000000;
const MASK_248: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

#[generate_trait]
pub impl SpvVaultImpl of SpvVaultImplTrait {
    //Returns whether an spv vault is opened or closed
    fn is_opened(self: SpvVaultState) -> bool {
        self.utxo != (0, 0)
    }

    //Closes the spv vault, returning the amount of tokens left in the vault, before it was closed
    fn close(ref self: SpvVaultState) -> (u256, u256) {
        let token_0_amount = self.token_0_amount;
        let token_1_amount = self.token_1_amount;

        self.utxo = (0, 0);
        self.token_0_amount = 0;
        self.token_1_amount = 0;
        
        (token_0_amount, token_1_amount)
    }

    //Sets the new UTXO
    fn set_utxo(ref self: SpvVaultState, tx_id: [u32; 8], vout: u32) {
        self.utxo = (tx_id.to_u256(), vout);
    }
}

pub impl SpvVaultStateStorePacking of StorePacking<SpvVaultState, [felt252; 9]> {
    fn pack(value: SpvVaultState) -> [felt252; 9] {
        let val_0: felt252 = value.relay_contract.into();
        let val_1: felt252 = value.token_0.into();
        let val_2: felt252 = value.token_1.into();
        let (tx_id, vout) = value.utxo;
        let val_3: felt252 = (tx_id & MASK_248).try_into().unwrap();
        let val_4: felt252 = (value.token_0_amount & MASK_248).try_into().unwrap();
        let val_5: felt252 = (value.token_1_amount & MASK_248).try_into().unwrap();
        let val_6: felt252 = vout.into() + 
            (tx_id / TWO_POW_248).try_into().unwrap() * 0x100000000 + 
            (value.token_0_amount / TWO_POW_248).try_into().unwrap() * 0x10000000000 + 
            (value.token_1_amount / TWO_POW_248).try_into().unwrap() * 0x1000000000000 +
            value.confirmations.into() * 0x100000000000000;
        
        [val_0, val_1, val_2, val_3, val_4, val_5, val_6, value.token_0_multiplier, value.token_1_multiplier]
    }

    fn unpack(value: [felt252; 9]) -> SpvVaultState {
        let span = value.span();

        let relay_contract: ContractAddress = (*span[0]).try_into().unwrap();
        let token_0: ContractAddress = (*span[1]).try_into().unwrap();
        let token_1: ContractAddress = (*span[2]).try_into().unwrap();

        let additional_data: u256 = (*span[6]).into();

        let tx_id: u256 = (*span[3]).into() + (additional_data & 0xFF00000000) * 0x1000000000000000000000000000000000000000000000000000000;
        let vout: u32 = (additional_data.low & 0xFFFFFFFF).try_into().unwrap();
        let token_0_amount: u256 = (*span[4]).into() + (additional_data & 0xFF0000000000) * 0x10000000000000000000000000000000000000000000000000000;
        let token_1_amount: u256 = (*span[5]).into() + (additional_data & 0xFF000000000000) * 0x100000000000000000000000000000000000000000000000000;
        let confrimations: u8 = ((additional_data.low & 0xFF00000000000000) / 0x100000000000000).try_into().unwrap();

        SpvVaultState {
            relay_contract: relay_contract,
            token_0: token_0,
            token_1: token_1,
            utxo: (tx_id, vout),
            confirmations: confrimations,
            token_0_amount: token_0_amount,
            token_1_amount: token_1_amount,
            token_0_multiplier: *span[7],
            token_1_multiplier: *span[8]
        }
    }
}