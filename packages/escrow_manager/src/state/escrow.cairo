use core::starknet::storage_access::StorePacking;

pub const STATE_NOT_COMMITTED: u8 = 0;
pub const STATE_COMMITTED: u8 = 1;
pub const STATE_CLAIMED: u8 = 2;
pub const STATE_REFUNDED: u8 = 3;

#[derive(Drop, Serde, Debug, PartialEq, Copy)]
pub struct EscrowState {
    pub init_blockheight: u64,
    pub finish_blockheight: u64,
    pub state: u8
}

const TWO_POW_8: felt252 = 0x100;
const TWO_POW_72: felt252 = 0x1000000000000000000;

const MASK_8: felt252 = 0xff;
const MASK_64: felt252 = 0xffffffffffffffff;

pub impl EscrowStateStorePacking of StorePacking<EscrowState, felt252> {
    fn pack(value: EscrowState) -> felt252 {
        value.state.into() + (value.init_blockheight.into() * TWO_POW_8) + (value.finish_blockheight.into() * TWO_POW_72)
    }

    fn unpack(value: felt252) -> EscrowState {
        let _value: u256 = value.into();
        let state = _value & MASK_8.into();
        let init_blockheight = (_value / TWO_POW_8.into()) & MASK_64.into();
        let finish_blockheight = (_value / TWO_POW_72.into());

        EscrowState {
            state: state.try_into().unwrap(),
            init_blockheight: init_blockheight.try_into().unwrap(),
            finish_blockheight: finish_blockheight.try_into().unwrap(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_packing() {
        let reputation = EscrowState {init_blockheight: 0, finish_blockheight: 0, state: 0};
        assert_eq!(EscrowStateStorePacking::unpack(EscrowStateStorePacking::pack(reputation)), reputation);

        let reputation = EscrowState {init_blockheight: 0xffffffffffffffff, finish_blockheight: 0, state: 0};
        assert_eq!(EscrowStateStorePacking::unpack(EscrowStateStorePacking::pack(reputation)), reputation);

        let reputation = EscrowState {init_blockheight: 0, finish_blockheight: 0xffffffffffffffff, state: 0};
        assert_eq!(EscrowStateStorePacking::unpack(EscrowStateStorePacking::pack(reputation)), reputation);

        let reputation = EscrowState {init_blockheight: 0xffffffffffffffff, finish_blockheight: 0xffffffffffffffff, state: 0};
        assert_eq!(EscrowStateStorePacking::unpack(EscrowStateStorePacking::pack(reputation)), reputation);

        let reputation = EscrowState {init_blockheight: 0, finish_blockheight: 0, state: 0xff};
        assert_eq!(EscrowStateStorePacking::unpack(EscrowStateStorePacking::pack(reputation)), reputation);

        let reputation = EscrowState {init_blockheight: 0xffffffffffffffff, finish_blockheight: 0, state: 0xff};
        assert_eq!(EscrowStateStorePacking::unpack(EscrowStateStorePacking::pack(reputation)), reputation);

        let reputation = EscrowState {init_blockheight: 0, finish_blockheight: 0xffffffffffffffff, state: 0xff};
        assert_eq!(EscrowStateStorePacking::unpack(EscrowStateStorePacking::pack(reputation)), reputation);

        let reputation = EscrowState {init_blockheight: 0xffffffffffffffff, finish_blockheight: 0xffffffffffffffff, state: 0xff};
        assert_eq!(EscrowStateStorePacking::unpack(EscrowStateStorePacking::pack(reputation)), reputation);

        let reputation = EscrowState {init_blockheight: 0x0102040506070809, finish_blockheight: 0x1112131415161718, state: 0x21};
        assert_eq!(EscrowStateStorePacking::unpack(EscrowStateStorePacking::pack(reputation)), reputation);
    }
}