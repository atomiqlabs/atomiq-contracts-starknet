use starknet::contract_address::ContractAddress;
use core::starknet::storage_access::StorePacking;

//On-chain saved reputation state
#[derive(Drop, Serde, PartialEq, Debug, Copy)]
pub struct Execution {
    //erc20 token address locked
    pub token: ContractAddress,
    //Hash of the calls to be executed
    pub execution_hash: felt252,

    //Total amount of tokens locked
    pub amount: u256,

    //Execution fee paid to the caller
    pub execution_fee: u256,

    //After the expiry anyone can refund and claim the execution fee
    pub expiry: u64
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
            self.execution_fee = 0;
        }
    }
}

const TWO_POW_248: u256 = 0x100000000000000000000000000000000000000000000000000000000000000;
const MASK_248: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

pub impl ExecutionStorePacking of StorePacking<Execution, [felt252; 5]> {
    fn pack(value: Execution) -> [felt252; 5] {
        let val_0: felt252 = value.token.into();
        let val_1: felt252 = value.execution_hash;
        let val_2: felt252 = (value.amount & MASK_248).try_into().unwrap();
        let val_3: felt252 = (value.execution_fee & MASK_248).try_into().unwrap();
        let val_4: felt252 = (value.amount / TWO_POW_248).try_into().unwrap() +
            (value.execution_fee / TWO_POW_248).try_into().unwrap() * 0x100 +
            value.expiry.into() * 0x10000;
        
        [val_0, val_1, val_2, val_3, val_4]
    }

    fn unpack(value: [felt252; 5]) -> Execution {
        let span = value.span();

        let token: ContractAddress = (*span[0]).try_into().unwrap();
        let execution_hash: felt252 = *span[1];

        let additional_data: u256 = (*span[4]).into();
        
        let amount: u256 = (*span[2]).into() + (additional_data & 0xFF) * 0x100000000000000000000000000000000000000000000000000000000000000;
        let execution_fee: u256 = (*span[3]).into() + (additional_data & 0xFF00) * 0x1000000000000000000000000000000000000000000000000000000000000;

        let expiry: u64 = ((additional_data.low / 0x10000) & 0xFFFFFFFFFFFFFFFF).try_into().unwrap();

        Execution {
            token: token,
            execution_hash: execution_hash,
            amount: amount,
            execution_fee: execution_fee,
            expiry: expiry
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;

    //Test consistency of the packing/unpacking functions
    #[test]
    fn test_packing() {
        let execution = Execution {
            token: 0.try_into().unwrap(),
            execution_hash: 0,
            amount: 0,
            execution_fee: 0,
            expiry: 0
        };
        assert_eq!(ExecutionStorePacking::unpack(ExecutionStorePacking::pack(execution)), execution);

        let execution = Execution {
            token: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF.try_into().unwrap(),
            execution_hash: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            amount: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            execution_fee: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            expiry: 0xFFFFFFFFFFFFFFFF
        };
        assert_eq!(ExecutionStorePacking::unpack(ExecutionStorePacking::pack(execution)), execution);

        let execution = Execution {
            token: 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF.try_into().unwrap(),
            execution_hash: 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF,
            amount: 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00,
            execution_fee: 0x00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF,
            expiry: 0x00FF00FF00FF00FF
        };
        assert_eq!(ExecutionStorePacking::unpack(ExecutionStorePacking::pack(execution)), execution);

        let execution = Execution {
            token: 0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f.try_into().unwrap(),
            execution_hash: 0x202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e,
            amount: 0x3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e,
            execution_fee: 0x5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e,
            expiry: 0x7f80818283848586
        };
        assert_eq!(ExecutionStorePacking::unpack(ExecutionStorePacking::pack(execution)), execution);
    }
    
    #[test]
    fn clear() {
        let mut execution = Execution {
            token: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF.try_into().unwrap(),
            execution_hash: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            amount: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            execution_fee: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            expiry: 0xFFFFFFFFFFFFFFFF
        };
        execution.clear(false);
        assert_eq!(execution.token, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF.try_into().unwrap());
        assert_eq!(execution.execution_hash, 0);
        assert_eq!(execution.amount, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        assert_eq!(execution.execution_fee, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        assert_eq!(execution.expiry, 0xFFFFFFFFFFFFFFFF);
    }

    #[test]
    fn clear_all() {
        let mut execution = Execution {
            token: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF.try_into().unwrap(),
            execution_hash: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            amount: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            execution_fee: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            expiry: 0xFFFFFFFFFFFFFFFF
        };
        execution.clear(true);
        assert_eq!(execution.token, 0.try_into().unwrap());
        assert_eq!(execution.execution_hash, 0);
        assert_eq!(execution.amount, 0);
        assert_eq!(execution.execution_fee, 0);
        assert_eq!(execution.expiry, 0);
    }

}