use core::hash::{HashStateTrait, HashStateExTrait, Hash};

pub impl SpanHashImpl<HashState, +HashStateTrait<HashState>, +Drop<HashState>, T, +Hash<T, HashState>, +Copy<T>> of Hash<Span<T>, HashState> {
    fn update_state(state: HashState, value: Span<T>) -> HashState {
        //Always prefix with the span length, such that we have a proper delimeter
        // whenever we hash multiple spans after each other
        let mut result = state.update(value.len().into());
        for element in value {
            result = result.update_with(*element);
        };
        result
    }
}
