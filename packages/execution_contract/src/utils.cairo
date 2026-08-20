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


#[cfg(test)]
mod tests {
    use super::*;

    use core::poseidon::PoseidonTrait;

    #[test]
    fn span_hash() {
        let hash = PoseidonTrait::new().update_with(array![0, 1, 2, 3, 4, 5, 6, 7].span()).finalize();
        assert!(hash != PoseidonTrait::new().update_with(array![0, 1, 2, 3, 4, 5, 6, 6].span()).finalize());

        let hash = PoseidonTrait::new().update_with(array![0, 0, 0, 0, 0, 0, 0, 0].span()).finalize();
        assert!(hash != PoseidonTrait::new().update_with(array![0, 0, 0, 0, 0, 0, 0, 1].span()).finalize());
    }

    #[test]
    fn properly_delimetered_spans() {
        let hash = PoseidonTrait::new()
            .update_with(array![0, 1, 2, 3].span())
            .update_with(array![4, 5, 6, 7].span())
            .finalize();
        assert!(hash != PoseidonTrait::new().update_with(array![0, 1, 2, 3, 4, 5, 6, 7].span()).finalize());
    }

}
