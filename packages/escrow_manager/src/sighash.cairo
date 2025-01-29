use openzeppelin_utils::snip12::OffchainMessageHash;
use core::starknet::ContractAddress;
use core::poseidon::PoseidonTrait;
use core::hash::{HashStateTrait, HashStateExTrait};
use openzeppelin_utils::snip12::{StructHash, SNIP12Metadata};

impl SNIP12MetadataImpl of SNIP12Metadata {
    fn name() -> felt252 { 'atomiq.exchange' }
    fn version() -> felt252 { 1 }
}

const INITIALIZE_STRUCT_TYPE_HASH: felt252 =
    selector!("\"Initialize\"(\"Swap hash\":\"felt\",\"Timeout\":\"timestamp\")");

#[derive(Drop, Copy, Hash)]
struct InitializeStruct {
    escrow_hash: felt252,
    timeout: u64
}

impl InitializeStructHashImpl of StructHash<InitializeStruct> {
    fn hash_struct(self: @InitializeStruct) -> felt252 {
        let hash_state = PoseidonTrait::new();
        hash_state.update_with(INITIALIZE_STRUCT_TYPE_HASH).update_with(*self).finalize()
    }
}

//Computes the init message sighash
pub fn get_init_sighash(escrow_hash: felt252, timeout: u64, signer: ContractAddress) -> felt252 {
    InitializeStruct {
        escrow_hash: escrow_hash,
        timeout: timeout
    }.get_message_hash(signer)
}

const REFUND_STRUCT_TYPE_HASH: felt252 =
    selector!("\"Refund\"(\"Swap hash\":\"felt\",\"Timeout\":\"timestamp\")");

#[derive(Drop, Copy, Hash)]
struct RefundStruct {
    escrow_hash: felt252,
    timeout: u64
}

impl RefundStructHashImpl of StructHash<RefundStruct> {
    fn hash_struct(self: @RefundStruct) -> felt252 {
        let hash_state = PoseidonTrait::new();
        hash_state.update_with(REFUND_STRUCT_TYPE_HASH).update_with(*self).finalize()
    }
}

//Computes the refund message sighash
pub fn get_refund_sighash(escrow_hash: felt252, timeout: u64, signer: ContractAddress) -> felt252 {
    RefundStruct {
        escrow_hash: escrow_hash,
        timeout: timeout
    }.get_message_hash(signer)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn random_init_sighash() {
        assert_eq!(get_init_sighash(0x0c1a3af46a3bd651a91e6310b1e222d91168966ed57d36f2a58ac6aa43ad5f, 0x2657d84403ec9cca, 0x1ccf977ee810746f1ba8ed96fe490e0e38bd9bde9cad06f647815719214870e.try_into().unwrap()), 0x2687a946d4489460531be8e4e0bec4d12fed4f60822cbaf749bbcca4fae27a7);

        assert_eq!(get_init_sighash(0xa321154e34ba1f731957b70b501d4d15196f032ae58b8131ce2f82d9f07351, 0x3f0dad2434a8c70d, 0x67326c86e73596ed7f581b58072ff2142526c0160e50a958a0ed751e9bf31cf.try_into().unwrap()), 0x7119978f9a152b2558c3c28081fce21034bb40f5b14d78da8247224fd529ba9);
        
        assert_eq!(get_init_sighash(0x04a42bd624d44b6c7570b2e8d10bae4b731b811d45ca8e059a6cbf27563635, 0xd2991505bdc13e99, 0x2b3161372076bd095fc4d53bebe44af404a73926b844f5c8e5a8ca4045bd6ce.try_into().unwrap()), 0x2cfa76f93c5f9a287e1832ef8bf4cc407e21a34e5fddc779e0827d735cfd187);
        
        assert_eq!(get_init_sighash(0x89e944e8e836fda3eaa7a21adf874092b65ed3c953e6206227a0a511532727, 0x055e335673aee03c, 0x2c3ae125aaa51b04f944ce089e152cf3c7310e2d30d7b136299ad17d8de3bef.try_into().unwrap()), 0x5e81c25f97670dd77365ef1154c68b5e4bde2b54e3d423f113a338931d7d9e);
        
        assert_eq!(get_init_sighash(0xcab567c57b37437ed9702000a1deaaeab8058c5761798c923800804c9d63bc, 0x68a1b60d8cee5940, 0x1e93791c2fc9f1250e67efee4036be569e1d3a6f963aa0ecf6137c722f1d7e.try_into().unwrap()), 0xa6fe890cccec79c2debbdc77a0ac20b6d45245f478e9ca1f9c685069d0e7ee);
        
        assert_eq!(get_init_sighash(0x5486771d505cf9fc37811e41241e9b19bda501eeaa387ab44995c5add3c25f, 0x7fbd81d3ffd4d3af, 0x4881991573307f2b3af98fe93894efae5625c0d1904553e9b7bba69aeef70ac.try_into().unwrap()), 0x51d2652d4d70779d67e58ed93a2cafec512c40a93e885e57f8986ddbe971b20);
        
        assert_eq!(get_init_sighash(0xbff069eb47a202d7a18985d96029371de6402336ef271762218c16e029a0b6, 0x96bb180d20f8f518, 0x711bced6b0e6c74423c630851774c6a483b305788445bbc10becbce12455a46.try_into().unwrap()), 0x22ba5e82e92f742b7c7fab004b9faef5cba004b7a6d4f8178e4268d892410d4);
        
        assert_eq!(get_init_sighash(0xa67683836e4c34aa8480214afeca692970f77969291a3d58a69ca19fdd859b, 0xc5ea8d34e6e3ac63, 0x1ecef29acd95d6764e4db2d1d8e5fee91d987ef8004da36e998b2ae4bbb2459.try_into().unwrap()), 0x33042e47b3ede2c52e036cd01ec2b8f40108507fd259bbad1a11372a7a546d);
        
        assert_eq!(get_init_sighash(0x69b597a8e30ab5ccdbc138794cd9ebfdb4c525ccf1d992dd98985e288516a9, 0x7fc04783ac3a6e81, 0x4477831dcb6690694173c00f61182bb557953a826e9d12b49e1887b54a98f79.try_into().unwrap()), 0x2fed1457bcac894df92f64bf17fde76434ffc60d400025de379deb00746474e);
        
        assert_eq!(get_init_sighash(0x4b22370e48087b8013cda4037543af94be83cc44093747d2ce8195eae2b280, 0x20e63a2125c1fa64, 0x3bde760e7597add7336cb2a40b13ece2379513d63b29dd519a66237254698c4.try_into().unwrap()), 0x3679fe7f301fe5fc154b82593282bb962cc655b2731aa714ae1c425a8108df4);
    }

    #[test]
    fn random_refund_sighash() {
        assert_eq!(get_refund_sighash(0x852a3b8b3b47b59b667bfd3da6858b06f01f6a59bbb8ca1f38c9436796e13f, 0xa153864f3b2fad8b, 0x4f2a98641be380e78b167a0ccd81da9f31e4ca8638a9b5623ad3701c77723ae.try_into().unwrap()), 0x25cea43ab2dd83ff1a2656806374d514cd4a45d3e0c61a47ebacbf50bc7beec);

        assert_eq!(get_refund_sighash(0xc6ceb22b8a29c80b5b981c39cc5363aab6bb5cc03acbe297a952445cbba5e5, 0x4dc3ec78f32361e6, 0x4810abab3576f212a629128ce03114a73c4025a33facedbe6307ae8b9a21ac3.try_into().unwrap()), 0x4caa4b3c8941efba88c43ce8dc05a2d10f325609067355be5690fc8e00c2edb);

        assert_eq!(get_refund_sighash(0x7f78a1f440dc21574f72261fc593760be7e84b0050b6dbf7a4815775380a5c, 0x5a7e2b2b8b4b62df, 0x20dde7c18650bb22de3f30cf982a8a43e210cc4bfe6f194d54c0dd5b8666328.try_into().unwrap()), 0x2dc64fc9eeb261d00c78a5d031aa5169a1c90717c4057cc43067b612218f2e);

        assert_eq!(get_refund_sighash(0x2b61ca286ef46127ea04c3b2339c41c47baa81b3b4e111ba8781fa62313a39, 0x7e80747d9880a826, 0x261994b269672b16cafd3ac60ea4c61a24cd496827b720b3cfe3e5b6d98b566.try_into().unwrap()), 0x302cacc44c86398c0791878de74bfd6f4532c0590a36f33a301cefbb78421d8);

        assert_eq!(get_refund_sighash(0x35daf34366d7991ad874ccdd508def90efe726135e6b8fb71230fd4b09774c, 0x8968aa83cfbb5cbd, 0xa727377df66612df45bc7a3c20372ea3e6303eeb8dcd49edb79a2194942cd1.try_into().unwrap()), 0x3295d7968272be7c4d707ec8050a9dea4f5921b810b22f32d99121c5a348062);

        assert_eq!(get_refund_sighash(0x5f43b3623990bd1fb295280918f90e648a7b8ce0ee2cab692e6d49dd9765b6, 0x6acb99eb64378551, 0x4493754678ce75acbfd99f7fa805324fb5d954afe9ea61cbb63d51190932274.try_into().unwrap()), 0x7c07d6fe7f0fbd68ed7a1aa0d843c1b52f64eab6d5cab9d929c9ee95e5169f6);

        assert_eq!(get_refund_sighash(0xc597b501c46b55041c7cda2548dd581a97cce5738b9e6a19337a77ebaf971b, 0x83d472777629015f, 0xebc88c10f8f6f503f900c9c80c9f1fd15e93ed73b261dd977e596ed52cd689.try_into().unwrap()), 0x6c2fe66d5773ccef6eb05a80b04d846f3b1b1511e1106b5172de121066a6bff);

        assert_eq!(get_refund_sighash(0x437df73b7e1fb4f7b4dc7fbbf391917a9fbdfc2b6f4385d6c2a6f05336b0e5, 0xc68c2a2a92d58c70, 0x735405e307e9f6f7b456f9f68ab530cc938164f7ba7f1ddb495317b01c4fca2.try_into().unwrap()), 0x3ba814c3275c42fac0ad4ff3ac4182ca239d2f2113a6780b940d96a1b6366c5);

        assert_eq!(get_refund_sighash(0x6b3c0ddd69b77686d89156bebfcac97f74266b95b188f512264f982960565e, 0x41a5856cfe04a190, 0xfac4f979f56ae50c54b37caaef2524e556006be6153f8c9157576860b12382.try_into().unwrap()), 0x308fd4d1206e8f844adfd5ad6a62c682a89ae267fa2b828f299ac31aaa60009);

        assert_eq!(get_refund_sighash(0x11562e41a2a8a4b7f76a651b4de71a80510fadc04936e60bc23d20c706493b, 0xb2b56a9166aa0902, 0x3ee6deede25ce8080cbf4809916b6a40b70609917321729a67855f2b7e8e850.try_into().unwrap()), 0x16f25173bf94a5b484f370d5fca75e68479c7a0ba88183aeb337ac1a1e6e3dd);
    }

}