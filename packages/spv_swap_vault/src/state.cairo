use core::starknet::storage_access::StorePacking;
use core::starknet::contract_address::ContractAddress;
use crate::utils::U32ArrayToU256Parser;

//State of the specific vault
#[derive(Drop, Serde, PartialEq, Debug, Copy)]
pub struct SpvVaultState {
    //BTC relay contract to be used for transaction SPV verification
    pub relay_contract: ContractAddress,
    //Address of the primary erc20 token
    pub token_0: ContractAddress,
    //Address of the secondary erc20 token (i.e. a gas token - STRK, ETH)
    pub token_1: ContractAddress,

    //Since space in bitcoin is limited, we only use 8 bytes to express the amount,
    // this is then multiplied by the provided multipliers
    pub token_0_multiplier: felt252,
    pub token_1_multiplier: felt252,

    //Current latest UTXO on which the vault state is assigned
    pub utxo: (u256, u32),
    //Required BTC transaction confirmations to advance the state of the vault
    pub confirmations: u8,
    //Count of total withdrawals that happened from the creation of the vault
    pub withdraw_count: u32,

    //Primary erc20 token amount locked in the vault
    pub token_0_amount: u64,
    //Secondary erc20 token amount locked in the vault
    pub token_1_amount: u64
}

const TWO_POW_248: u256 = 0x100000000000000000000000000000000000000000000000000000000000000;
const MASK_248: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

#[generate_trait]
pub impl SpvVaultImpl of SpvVaultImplTrait {
    //Calculates real token amounts, according to the multipliers set in the data
    fn to_token_amounts(self: SpvVaultState, amount_0_u64: u64, amount_1_u64: u64) -> (u256, u256) {
        let amount_0: u256 = amount_0_u64.into() * self.token_0_multiplier.into();
        let amount_1: u256 = amount_1_u64.into() * self.token_1_multiplier.into();

        (amount_0, amount_1)
    }

    //Returns whether an spv vault is opened or closed
    fn is_opened(self: SpvVaultState) -> bool {
        self.utxo != (0, 0)
    }

    //Closes the spv vault, returning the amount of tokens left in the vault, before it was closed, returns scaled token amounts
    fn close(ref self: SpvVaultState) -> (u256, u256) {
        let token_0_amount = self.token_0_amount;
        let token_1_amount = self.token_1_amount;

        self.utxo = (0, 0);
        self.token_0_amount = 0;
        self.token_1_amount = 0;
        
        self.to_token_amounts(token_0_amount, token_1_amount)
    }

    //Updates the state with withdrawal, returns scaled token amounts
    fn withdraw(ref self: SpvVaultState, tx_id: u256, vout: u32, raw_amount_0: u64, raw_amount_1: u64) -> (u256, u256) {
        //Clamp the amount to the maximum that's currently in the vault, to prevent
        // funds from getting frozen
        let amount_0 = if raw_amount_0 > self.token_0_amount {self.token_0_amount} else {raw_amount_0};
        let amount_1 = if raw_amount_1 > self.token_1_amount {self.token_1_amount} else {raw_amount_1};

        //Update the state
        self.token_0_amount -= amount_0;
        self.token_1_amount -= amount_1;
        self.utxo = (tx_id, vout);
        self.withdraw_count += 1;

        self.to_token_amounts(amount_0, amount_1)
    }

    //Updates the state with deposit, returns scaled token amounts
    fn deposit(ref self: SpvVaultState, raw_amount_0: u64, raw_amount_1: u64) -> (u256, u256) {
        //Update the state
        self.token_0_amount += raw_amount_0;
        self.token_1_amount += raw_amount_1;

        self.to_token_amounts(raw_amount_0, raw_amount_1)
    }
}

pub impl SpvVaultStateStorePacking of StorePacking<SpvVaultState, [felt252; 7]> {
    fn pack(value: SpvVaultState) -> [felt252; 7] {
        let val_0: felt252 = value.relay_contract.into();
        let val_1: felt252 = value.token_0.into();
        let val_2: felt252 = value.token_1.into();
        let val_3: felt252 = value.token_0_multiplier;
        let val_4: felt252 = value.token_1_multiplier;
        let (tx_id, vout) = value.utxo;
        let val_5: felt252 = (tx_id & MASK_248).try_into().unwrap();
        let val_6: felt252 = (tx_id / TWO_POW_248).try_into().unwrap() +
            vout.into() * 0x100 +
            value.confirmations.into() * 0x10000000000 +
            value.withdraw_count.into() * 0x1000000000000 +
            value.token_0_amount.into() * 0x100000000000000000000 +
            value.token_1_amount.into() * 0x1000000000000000000000000000000000000;
        
        [val_0, val_1, val_2, val_3, val_4, val_5, val_6]
    }

    fn unpack(value: [felt252; 7]) -> SpvVaultState {
        let span = value.span();

        let relay_contract: ContractAddress = (*span[0]).try_into().unwrap();
        let token_0: ContractAddress = (*span[1]).try_into().unwrap();
        let token_1: ContractAddress = (*span[2]).try_into().unwrap();
        let token_0_multiplier: felt252 = *span[3];
        let token_1_multiplier: felt252 = *span[4];

        let additional_data: u256 = (*span[6]).into();
        
        let tx_id: u256 = (*span[5]).into() + (additional_data & 0xFF) * 0x100000000000000000000000000000000000000000000000000000000000000;

        let vout: u32 = ((additional_data.low / 0x100) & 0xFFFFFFFF).try_into().unwrap();
        let confirmations: u8 = ((additional_data.low / 0x10000000000) & 0xFF).try_into().unwrap();
        let withdraw_count: u32 = ((additional_data.low / 0x1000000000000) & 0xFFFFFFFF).try_into().unwrap();
        let token_0_amount: u64 = ((additional_data / 0x100000000000000000000) & 0xFFFFFFFFFFFFFFFF).try_into().unwrap();
        let token_1_amount: u64 = ((additional_data.high / 0x10000) & 0xFFFFFFFFFFFFFFFF).try_into().unwrap();

        SpvVaultState {
            relay_contract: relay_contract,
            token_0: token_0,
            token_1: token_1,
            token_0_multiplier: token_0_multiplier,
            token_1_multiplier: token_1_multiplier,
            utxo: (tx_id, vout),
            confirmations: confirmations,
            withdraw_count: withdraw_count,
            token_0_amount: token_0_amount,
            token_1_amount: token_1_amount
        }
    }
}