use core::hash::{HashStateTrait, HashStateExTrait, Hash};

pub impl SpanHashImpl<HashState, +HashStateTrait<HashState>, +Drop<HashState>, T, +Hash<T, HashState>, +Copy<T>> of Hash<Span<T>, HashState> {
    fn update_state(state: HashState, value: Span<T>) -> HashState {
        let mut result = state;
        for element in value {
            result = result.update_with(*element);
        };
        result
    }
}
