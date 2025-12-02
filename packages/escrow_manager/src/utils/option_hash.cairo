use core::hash::{HashStateTrait, HashStateExTrait, Hash};

//NOTE: This is not generally a secure approach for hashing options, the hasher should always
// prefix the state of the option hence, in case of some -> 1 <value>, in case of none -> 0.
// This is kept as is for now as to change how hashes are computed currently in atomiq
//TODO: Update this in next major update
pub impl OptionHashImpl<HashState, +HashStateTrait<HashState>, +Drop<HashState>, T, +Hash<T, HashState>, +Drop<T>> of Hash<Option<T>, HashState> {
    fn update_state(state: HashState, value: Option<T>) -> HashState {
        if value.is_some() {
            state.update_with(value.unwrap())
        } else {
            state
        }
    }
}
