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


#[cfg(test)]
mod tests {
    use super::*;

    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::poseidon::PoseidonTrait;

    #[test]
    fn span_hash() {
        let hash = PoseidonTrait::new().update_with(array![0, 1, 2, 3, 4, 5, 6, 7].span()).finalize();
        assert_eq!(hash, 0x4f5c3b7e3c8019d970747c33fd9318efc139b091115bad66c70a19e0ff430d3);
        assert!(hash != PoseidonTrait::new().update_with(array![0, 1, 2, 3, 4, 5, 6, 6].span()).finalize());

        let hash = PoseidonTrait::new().update_with(array![0, 0, 0, 0, 0, 0, 0, 0].span()).finalize();
        assert_eq!(hash, 0x693df69325f0dd414a3d3af06b5839221d1de6574f95cdde7582b21d83708e5);
        assert!(hash != PoseidonTrait::new().update_with(array![0, 0, 0, 0, 0, 0, 0, 1].span()).finalize());
    }

}
