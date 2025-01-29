use core::starknet::storage_access::StorePacking;
use core::num::traits::SaturatingAdd;

#[derive(Drop, Serde, PartialEq, Debug, Copy)]
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_packing() {
        let reputation = Reputation {amount: 0, count: 0};
        assert_eq!(ReputationStorePacking::unpack(ReputationStorePacking::pack(reputation)), reputation);

        let reputation = Reputation {amount: 0, count: 0xffffffffffffffffffffffffffffffff};
        assert_eq!(ReputationStorePacking::unpack(ReputationStorePacking::pack(reputation)), reputation);
        
        let reputation = Reputation {amount: 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, count: 0};
        assert_eq!(ReputationStorePacking::unpack(ReputationStorePacking::pack(reputation)), reputation);

        let reputation = Reputation {amount: 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, count: 0xffffffffffffffffffffffffffffffff};
        assert_eq!(ReputationStorePacking::unpack(ReputationStorePacking::pack(reputation)), reputation);

        let reputation = Reputation {amount: 0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20, count: 0x2122232425262728292a2b2c2d2e2f30};
        assert_eq!(ReputationStorePacking::unpack(ReputationStorePacking::pack(reputation)), reputation);
    }

    #[test]
    fn test_updates() {
        let mut reputation = Reputation {amount: 0, count: 0};
        reputation.update(8847182778182);
        assert_eq!(
            ReputationStorePacking::unpack(ReputationStorePacking::pack(reputation)),
            Reputation {amount: 8847182778182, count: 1}
        );

        let mut reputation = Reputation {amount: 0, count: 0};
        reputation.update(0);
        assert_eq!(
            ReputationStorePacking::unpack(ReputationStorePacking::pack(reputation)),
            Reputation {amount: 0, count: 1}
        );

        let mut reputation = Reputation {amount: 0, count: 0};
        reputation.update(845132);
        reputation.update(1221000);
        reputation.update(411100);
        reputation.update(984431);
        assert_eq!(
            ReputationStorePacking::unpack(ReputationStorePacking::pack(reputation)),
            Reputation {amount: 845132+1221000+411100+984431, count: 4}
        );

        let mut reputation = Reputation {amount: 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, count: 0xffffffffffffffffffffffffffffffff};
        reputation.update(3912387842);
        assert_eq!(
            ReputationStorePacking::unpack(ReputationStorePacking::pack(reputation)),
            Reputation {amount: 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, count: 0xffffffffffffffffffffffffffffffff}
        );

        let mut reputation = Reputation {amount: 0, count: 0};
        reputation.update(0x8fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        reputation.update(0x8fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        assert_eq!(
            ReputationStorePacking::unpack(ReputationStorePacking::pack(reputation)),
            Reputation {amount: 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, count: 2}
        );

        let mut reputation = Reputation {amount: 0, count: 0xfffffffffffffffffffffffffffffffe};
        reputation.update(84315451232);
        reputation.update(8948318684331);
        assert_eq!(
            ReputationStorePacking::unpack(ReputationStorePacking::pack(reputation)),
            Reputation {amount: 84315451232+8948318684331, count: 0xffffffffffffffffffffffffffffffff}
        );
    }

}
