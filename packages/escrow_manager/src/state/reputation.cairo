use core::starknet::storage_access::StorePacking;
use core::num::traits::SaturatingAdd;

#[derive(Drop, Serde)]
pub struct Reputation {
    pub amount: u256,
    pub count: u128
}

const TWO_POW_248: felt252 = 0x100000000000000000000000000000000000000000000000000000000000000;
const MASK_248: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

const TWO_POW_8: felt252 = 0x100;
const MASK_8: u256 = 0xFF;

pub impl ReputationStorePacking of StorePacking<Reputation, [felt252; 2]> {
    fn pack(value: Reputation) -> [felt252; 2] {
        let first: felt252 = (value.amount & MASK_248).try_into().unwrap();
        let second: felt252 = ((value.amount / TWO_POW_248.into()).try_into().unwrap() + (value.count.into() * TWO_POW_8));
        [first, second]
    }

    fn unpack(value: [felt252; 2]) -> Reputation {
        let span = value.span();
        let first: u256 = (*span[0]).into();
        let second: u256 = (*span[1]).into();

        let amount: u256 = first + (second & MASK_8) * TWO_POW_248.into();
        let count: u256 = second / TWO_POW_8.into();

        Reputation {
            amount: amount,
            count: count.try_into().unwrap()
        }
    }
}

#[generate_trait]
pub impl ReputationUpdate of ReputationUpdateTrait {
    fn update(ref self: Reputation, amount: u256) {
        self.amount = self.amount.saturating_add(amount);
        self.count = self.count.saturating_add(1);
    }
}

//TODO: Add unit tests checking pack/unpack consistency

//TODO: Add unit tests checking update overflow handling
