use core::hash::{HashStateTrait, HashStateExTrait, Hash};

pub impl OptionHashImpl<HashState, +HashStateTrait<HashState>, +Drop<HashState>, T, +Hash<T, HashState>, +Drop<T>> of Hash<Option<T>, HashState> {
    fn update_state(state: HashState, value: Option<T>) -> HashState {
        if value.is_some() {
            state.update_with(value.unwrap())
        } else {
            state
        }
    }
}
