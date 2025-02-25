use core::sha256::{compute_sha256_u32_array};

//Hashes left and right leaf of the merkle tree
fn hash(left: [u32; 8], right: [u32; 8]) -> [u32; 8] {
    let left_span = left.span();
    let right_span = right.span();
    let result = compute_sha256_u32_array(array![
        *left_span[0], *left_span[1], *left_span[2], *left_span[3], *left_span[4], *left_span[5], *left_span[6], *left_span[7],
        *right_span[0], *right_span[1], *right_span[2], *right_span[3], *right_span[4], *right_span[5], *right_span[6], *right_span[7],
    ], 0, 0).span();
    compute_sha256_u32_array(array![
        *result[0], *result[1], *result[2], *result[3], *result[4], *result[5], *result[6], *result[7]
    ], 0, 0)
}

//Computes the merkle root from the provided leaf, with the proof and _index (position of the leaf in the bottom layer of the tree)
fn get_merkle_root(leaf: [u32; 8], proof: Span<[u32; 8]>, _index: u32) -> [u32; 8] {
    let mut index = _index;
    let mut root_hash = leaf;
    for proof_leaf in proof {
        root_hash = if index & 0x01 == 0x00 {
            hash(root_hash, *proof_leaf)
        } else {
            hash(*proof_leaf, root_hash)
        };
        index /= 2;
    };
    root_hash
}

//Verifies the merkle root inclusion proof
pub fn verify(root: [u32; 8], leaf: [u32; 8], proof: Span<[u32; 8]>, index: u32) {
    assert(root==get_merkle_root(leaf, proof, index), 'merkle_tree: verify failed');
}
