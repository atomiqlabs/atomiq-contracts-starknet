use core::hash::{HashStateTrait, HashStateExTrait, Hash};

pub impl OptionHashImpl<HashState, +HashStateTrait<HashState>, +Drop<HashState>, T, +Hash<T, HashState>, +Drop<T>> of Hash<Option<T>, HashState> {
    fn update_state(state: HashState, value: Option<T>) -> HashState {
        let _state = state.update(if value.is_some() {1} else {0});
        if value.is_some() {
            _state.update_with(value.unwrap())
        } else {
            _state
        }
    }
}
