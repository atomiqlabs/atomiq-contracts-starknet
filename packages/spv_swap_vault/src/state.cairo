use core::num::traits::{CheckedMul, CheckedSub};

use core::starknet::storage_access::StorePacking;
use core::starknet::contract_address::ContractAddress;

use btc_utils::bitcoin_tx::{BitcoinTransactionImpl, BitcoinTransaction};

use crate::structs::{BitcoinVaultTransactionData, BitcoinVaultTransactionDataImpl};
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

#[generate_trait]
impl SpvVaultPrivateImpl of SpvVaultPrivateImplTrait {
    //Updates the state with withdrawal
    fn withdraw(ref self: SpvVaultState, btc_tx_hash_u256: u256, vout: u32, raw_amount_0: u64, raw_amount_1: u64) -> Result<(), felt252> {
        //Make sure subtraction doesn't overflow
        let new_token_0_amount = self.token_0_amount.checked_sub(raw_amount_0);
        if new_token_0_amount.is_none() { return Result::Err('withdraw: amount 0'); }
        let new_token_1_amount = self.token_1_amount.checked_sub(raw_amount_1);
        if new_token_1_amount.is_none() { return Result::Err('withdraw: amount 1'); }
        
        //Update the state
        self.token_0_amount = new_token_0_amount.unwrap();
        self.token_1_amount = new_token_1_amount.unwrap();
        self.utxo = (btc_tx_hash_u256, vout);
        self.withdraw_count += 1;

        Result::Ok(())
    }
}

#[generate_trait]
pub impl SpvVaultImpl of SpvVaultImplTrait {
    fn from_raw_token0(self: SpvVaultState, amount_0_raw: u64) -> Option<u256> {
        let amount_0_u256: u256 = amount_0_raw.into();
        amount_0_u256.into().checked_mul(self.token_0_multiplier.into())
    }

    fn from_raw_token1(self: SpvVaultState, amount_1_raw: u64) -> Option<u256> {
        let amount_1_u256: u256 = amount_1_raw.into();
        amount_1_u256.into().checked_mul(self.token_1_multiplier.into())
    }

    //Calculates real token amounts, according to the multipliers set in the data
    fn from_raw(self: SpvVaultState, amounts_raw: (u64, u64)) -> Option<(u256, u256)> {
        let (amount_0_raw, amount_1_raw) = amounts_raw;

        Option::Some((self.from_raw_token0(amount_0_raw)?, self.from_raw_token1(amount_1_raw)?))
    }

    //Returns whether an spv vault is opened or closed
    fn is_opened(self: SpvVaultState) -> bool {
        self.utxo != (0, 0)
    }

    //Closes the spv vault, returning the amount of tokens left in the vault, before it was closed, returns scaled token amounts
    fn close(ref self: SpvVaultState) {
        self.utxo = (0, 0);
        self.token_0_amount = 0;
        self.token_1_amount = 0;
    }

    //Updates the state with deposit, returns scaled token amounts
    fn deposit(ref self: SpvVaultState, raw_amount_0: u64, raw_amount_1: u64) {
        //Update the state
        self.token_0_amount += raw_amount_0;
        self.token_1_amount += raw_amount_1;
    }

    //Extracts the withdrawal bitcoin transaction data and updates the state with withdrawn token amounts
    //NOTE: Also verifies that full amounts are in bounds of u256 integer
    fn parse_and_withdraw(ref self: SpvVaultState, btc_tx_hash_u256: u256, btc_tx: BitcoinTransaction) -> Result<BitcoinVaultTransactionData, felt252> {
        let tx_data = BitcoinVaultTransactionDataImpl::from_tx(btc_tx)?;
        let (amount_0, amount_1) = tx_data.get_full_amounts()?;
        self.withdraw(btc_tx_hash_u256, 0, amount_0, amount_1)?;

        //Make sure that the full amount is in the bounds of u256 integer
        if self.from_raw((amount_0, amount_1)).is_none() {
            return Result::Err('parse_and_wthdrw: u256 overflow');
        }

        Result::Ok(tx_data)
    }
}

const TWO_POW_248: u256 = 0x100000000000000000000000000000000000000000000000000000000000000;
const MASK_248: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

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


#[cfg(test)]
mod tests {
    use super::*;

    //Test consistency of the packing/unpacking functions
    #[test]
    fn test_packing() {
        let spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 0,
            token_1_multiplier: 0,
            utxo: (0, 0),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 0,
            token_1_amount: 0
        };
        assert_eq!(SpvVaultStateStorePacking::unpack(SpvVaultStateStorePacking::pack(spv_vault_state)), spv_vault_state);

        let spv_vault_state = SpvVaultState {
            relay_contract: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF.try_into().unwrap(),
            token_0: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF.try_into().unwrap(),
            token_1: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF.try_into().unwrap(),
            token_0_multiplier: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            token_1_multiplier: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            utxo: (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 0xFFFFFFFF),
            confirmations: 0xFF,
            withdraw_count: 0xFFFFFFFF,
            token_0_amount: 0xFFFFFFFFFFFFFFFF,
            token_1_amount: 0xFFFFFFFFFFFFFFFF
        };
        assert_eq!(SpvVaultStateStorePacking::unpack(SpvVaultStateStorePacking::pack(spv_vault_state)), spv_vault_state);

        let spv_vault_state = SpvVaultState {
            relay_contract: 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF.try_into().unwrap(),
            token_0: 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF.try_into().unwrap(),
            token_1: 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF.try_into().unwrap(),
            token_0_multiplier: 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF,
            token_1_multiplier: 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF,
            utxo: (0x00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF, 0x00FF00FF),
            confirmations: 0x0F,
            withdraw_count: 0x00FF00FF,
            token_0_amount: 0xFF00FF00FF00FF00,
            token_1_amount: 0x00FF00FF00FF00FF
        };
        assert_eq!(SpvVaultStateStorePacking::unpack(SpvVaultStateStorePacking::pack(spv_vault_state)), spv_vault_state);

        let spv_vault_state = SpvVaultState {
            relay_contract: 0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f.try_into().unwrap(),
            token_0: 0x202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e.try_into().unwrap(),
            token_1: 0x3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d.try_into().unwrap(),
            token_0_multiplier: 0x5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c,
            token_1_multiplier: 0x7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b,
            utxo: (0x9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babc, 0xbdbebfc0),
            confirmations: 0xc1,
            withdraw_count: 0xc2c3c4c5,
            token_0_amount: 0xc6c7c8c9cacbcccd,
            token_1_amount: 0xcecfd0d1d2d3d4d5
        };
        assert_eq!(SpvVaultStateStorePacking::unpack(SpvVaultStateStorePacking::pack(spv_vault_state)), spv_vault_state);

        let spv_vault_state = SpvVaultState {
            relay_contract: 0x7a103cd2072c5a6ba4660ddbf8ada42385f2de05e2682408ec03b52c8cfc23c.try_into().unwrap(),
            token_0: 0x59dc0fa33367211db9283b55d24b5e4ea240a2faa24d647f6ce2384384956c0.try_into().unwrap(),
            token_1: 0x3e4cd6e9720ff9ddff09b4a051912d1d55ca37b9f413325e83f6d3a3057f37d.try_into().unwrap(),
            token_0_multiplier: 0x4bf678bdec7218aad2f655434906d9aad9ef31f173ab5c05ec0b4e825d27920,
            token_1_multiplier: 0x1b5e41d03bcd89578c225bc7e116924a67fde88419ef9a8701b7efdc49fd4e4,
            utxo: (0x2a522f2a899536253d0c8480f08801f62848761656c1a2dc2e0f5d92f9897c06, 0xcf72180e),
            confirmations: 0xbc,
            withdraw_count: 0xdf35a61b,
            token_0_amount: 0x53f49641f45c57ec,
            token_1_amount: 0x13e3dff4883807ed
        };
        assert_eq!(SpvVaultStateStorePacking::unpack(SpvVaultStateStorePacking::pack(spv_vault_state)), spv_vault_state);
    }

    #[test]
    fn deposit() {
        let mut spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 58615365,
            token_1_multiplier: 15665156156,
            utxo: (0, 0),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 50,
            token_1_amount: 100
        };

        spv_vault_state.deposit(76321, 7472);

        assert_eq!(spv_vault_state.token_0_amount, 50 + 76321);
        assert_eq!(spv_vault_state.token_1_amount, 100 + 7472);
    }

    #[test]
    fn is_opened() {
        let spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 0,
            token_1_multiplier: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            utxo: (0, 0),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 50,
            token_1_amount: 100
        };

        assert_eq!(spv_vault_state.is_opened(), false);

        let spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 0,
            token_1_multiplier: 0,
            utxo: (0xFF, 0),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 50,
            token_1_amount: 100
        };

        assert_eq!(spv_vault_state.is_opened(), true);

        let spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 0,
            token_1_multiplier: 0,
            utxo: (0xFF, 0xFF),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 50,
            token_1_amount: 100
        };

        assert_eq!(spv_vault_state.is_opened(), true);

        let spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 0,
            token_1_multiplier: 0,
            utxo: (0, 0xFF),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 50,
            token_1_amount: 100
        };

        assert_eq!(spv_vault_state.is_opened(), true);
    }

    #[test]
    fn from_raw_token0() {
        let spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 7461236213,
            token_1_multiplier: 0,
            utxo: (0, 0xFF),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 50,
            token_1_amount: 100
        };

        assert_eq!(spv_vault_state.from_raw_token0(9387123).unwrap(), 9387123 * 7461236213);
    }

    #[test]
    fn from_raw_token0_overflow() {
        let spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            token_1_multiplier: 0,
            utxo: (0, 0xFF),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 50,
            token_1_amount: 100
        };

        assert_eq!(spv_vault_state.from_raw_token0(789448615661).is_none(), true);
    }

    #[test]
    fn from_raw_token1() {
        let spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 7461236213,
            token_1_multiplier: 45561313,
            utxo: (0, 0xFF),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 50,
            token_1_amount: 100
        };

        assert_eq!(spv_vault_state.from_raw_token1(1313864).unwrap(), 1313864 * 45561313);
    }

    #[test]
    fn from_raw_token1_overflow() {
        let spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 0,
            token_1_multiplier: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            utxo: (0, 0xFF),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 50,
            token_1_amount: 100
        };

        assert_eq!(spv_vault_state.from_raw_token1(848448666147).is_none(), true);
    }

    #[test]
    fn from_raw() {
        let spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 64489133,
            token_1_multiplier: 45648616,
            utxo: (0, 0xFF),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 50,
            token_1_amount: 100
        };

        assert_eq!(
            spv_vault_state.from_raw((5868468, 8123478)).unwrap(), 
            (5868468 * 64489133, 8123478 * 45648616)
        );
    }

    #[test]
    fn from_raw_overflow_0() {
        let spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            token_1_multiplier: 45648616,
            utxo: (0, 0xFF),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 50,
            token_1_amount: 100
        };

        assert_eq!(
            spv_vault_state.from_raw((5868468, 8123478)).is_none(), 
            true
        );
    }

    #[test]
    fn from_raw_overflow_1() {
        let spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 789448665,
            token_1_multiplier: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            utxo: (0, 0xFF),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 50,
            token_1_amount: 100
        };

        assert_eq!(
            spv_vault_state.from_raw((5868468, 8123478)).is_none(), 
            true
        );
    }

    #[test]
    fn close() {
        let mut spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 58615365,
            token_1_multiplier: 15665156156,
            utxo: (0xFF, 0xFF),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 50,
            token_1_amount: 100
        };

        spv_vault_state.close();

        assert_eq!(spv_vault_state.token_0_amount, 0);
        assert_eq!(spv_vault_state.token_1_amount, 0);
        assert_eq!(spv_vault_state.utxo, (0, 0));
    }

    #[test]
    fn withdraw() {
        let mut spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 58615365,
            token_1_multiplier: 15665156156,
            utxo: (0xFF, 0xFF),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 844864,
            token_1_amount: 3515154
        };

        spv_vault_state.withdraw(0x2313, 0x584, 84948, 48766).unwrap();

        
        assert_eq!(spv_vault_state.token_0_amount, 844864 - 84948);
        assert_eq!(spv_vault_state.token_1_amount, 3515154 - 48766);
        assert_eq!(spv_vault_state.utxo, (0x2313, 0x584));
        assert_eq!(spv_vault_state.withdraw_count, 1);
    }

    #[test]
    fn withdraw_too_much_token0() {
        let mut spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 58615365,
            token_1_multiplier: 15665156156,
            utxo: (0xFF, 0xFF),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 844864,
            token_1_amount: 3515154
        };

        assert_eq!(
            spv_vault_state.withdraw(0x2313, 0x584, 844645665, 48766).unwrap_err(),
            'withdraw: amount 0'
        );
    }

    #[test]
    fn withdraw_too_much_token1() {
        let mut spv_vault_state = SpvVaultState {
            relay_contract: 0.try_into().unwrap(),
            token_0: 0.try_into().unwrap(),
            token_1: 0.try_into().unwrap(),
            token_0_multiplier: 58615365,
            token_1_multiplier: 15665156156,
            utxo: (0xFF, 0xFF),
            confirmations: 0,
            withdraw_count: 0,
            token_0_amount: 844864,
            token_1_amount: 3515154
        };

        assert_eq!(
            spv_vault_state.withdraw(0x2313, 0x584, 874, 846441348423).unwrap_err(),
            'withdraw: amount 1'
        );
    }
}
