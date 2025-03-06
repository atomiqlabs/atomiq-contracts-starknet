use starknet::contract_address::ContractAddress;
use core::starknet::storage_access::StorePacking;

use crate::utils;

//On-chain saved reputation state
#[derive(Drop, Serde, PartialEq, Debug, Copy)]
pub struct Execution {
    //erc20 token address locked
    pub token: ContractAddress,
    //Hash of the calls to be executed
    pub execution_hash: felt252,

    //Total amount of tokens locked
    pub amount: u256,

    //After the expiry anyone can refund and claim the execution fee
    pub expiry: u64,

    //Execution fee paid to the caller
    pub execution_fee_share: u16
}

#[generate_trait]
pub impl ExecutionImpl of ExecutionImplTrait {
    //The reason for clear_all flag is to save on data storage gas, if the post & execute/refund_expired/refund is executed in a single
    // transaction clear_all should be set to true, such that all the data is cleared resulting in no state diff, when calling the
    // execute/refund_expired/refund later, clear_all should be set to false, such that the state diff is only a single felt
    fn clear(ref self: Execution, all: bool) {
        self.execution_hash = 0;
        if all {
            self.token = 0.try_into().unwrap();
            self.amount = 0;
            self.expiry = 0;
            self.execution_fee_share = 0;
        }
    }

    fn get_execution_fee(self: Execution) -> u256 {
        utils::fee_amount(self.amount, self.execution_fee_share)
    }
}

const TWO_POW_248: u256 = 0x100000000000000000000000000000000000000000000000000000000000000;
const MASK_248: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

pub impl SpvVaultStateStorePacking of StorePacking<Execution, [felt252; 4]> {
    fn pack(value: Execution) -> [felt252; 4] {
        let val_0: felt252 = value.token.into();
        let val_1: felt252 = value.execution_hash;
        let val_2: felt252 = (value.amount & MASK_248).try_into().unwrap();
        let val_3: felt252 = (value.amount / TWO_POW_248).try_into().unwrap() +
            value.expiry.into() * 0x100 +
            value.execution_fee_share.into() * 0x1000000000000000000;
        
        [val_0, val_1, val_2, val_3]
    }

    fn unpack(value: [felt252; 4]) -> Execution {
        let span = value.span();

        let token: ContractAddress = (*span[0]).try_into().unwrap();
        let execution_hash: felt252 = *span[1];

        let additional_data: u256 = (*span[3]).into();
        
        let amount: u256 = (*span[2]).into() + (additional_data & 0xFF) * 0x100000000000000000000000000000000000000000000000000000000000000;

        let expiry: u64 = ((additional_data.low / 0x100) & 0xFFFFFFFFFFFFFFFF).try_into().unwrap();
        let execution_fee_share: u16 = ((additional_data.low / 0x1000000000000000000) & 0xFFFF).try_into().unwrap();

        Execution {
            token: token,
            execution_hash: execution_hash,
            amount: amount,
            expiry: expiry,
            execution_fee_share: execution_fee_share
        }
    }
}