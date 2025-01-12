use core::starknet::storage_access::StorePacking;

#[derive(Drop, Serde)]
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
