use crate::byte_array::{ByteArrayReader, ByteArrayReaderTrait};
use crate::compact_size::{ByteArrayCompactSizeReader, ByteArrayCompactSizeReaderTrait};

//Struct representing the position of the output in the data
#[derive(Drop)]
pub struct BitcoinTxOutput {
    data: @ByteArray,
    value_offset: usize,
    script_offset: usize,
    script_length: usize
}

#[generate_trait]
pub impl BitcoinTxOutputImpl of BitcoinTxOutputTrait {
    //Get the value of the output
    fn get_value(self: @BitcoinTxOutput) -> u64 {
        (*self.data).read_u64_le(*self.value_offset)
    }

    //Get the poseidon hash of the output script
    fn get_script_hash(self: @BitcoinTxOutput) -> felt252 {
        let script_offset = *self.script_offset;
        (*self.data).hash_poseidon_range(script_offset, script_offset + *self.script_length)
    }

    //Parses the bitcoin output from a specific offset in the data
    fn from_byte_array(data: @ByteArray, ref offset: usize) -> BitcoinTxOutput {
        //value: u32
        let value_offset = offset;
        offset += 8;
        
        let (_script_length, bytes_read) = data.read_compact(offset);
        let script_length: usize = _script_length.try_into().unwrap();
        offset += bytes_read;
        //output_script_length: CompactSize
        //output script: [u8; script_length]
        let result = BitcoinTxOutput {
            data: data,
            value_offset: value_offset,
            script_offset: offset,
            script_length: script_length
        };
        offset += script_length;
    
        result
    }
}

//Struct representing the position of the input in the data
#[derive(Drop)]
pub struct BitcoinTxInput {
    data: @ByteArray,
    initial_offset: usize,
    script_offset: usize,
    script_length: usize
}

#[generate_trait]
pub impl BitcoinTxInputImpl of BitcoinTxInputTrait {
    //Get the UTXO of the input with the format: (txId, vout)
    fn get_utxo(self: @BitcoinTxInput) -> (u256, u32) {
        ((*self.data).read_u256(*self.initial_offset), (*self.data).read_u32_le(*self.initial_offset+32))
    }
    
    //Returns a poseidon hash of the input script
    fn get_script_hash(self: @BitcoinTxInput) -> felt252 {
        let script_offset = *self.script_offset;
        (*self.data).hash_poseidon_range(script_offset, script_offset + *self.script_length)
    }

    //Returns the nSequence of the input
    fn get_n_sequence(self: @BitcoinTxInput) -> u32 {
        (*self.data).read_u32_le(*self.script_offset+*self.script_length)
    }

    //Parses the bitcoin input from the data at the specified offset
    fn from_byte_array(data: @ByteArray, ref offset: usize) -> BitcoinTxInput {
        //Previous output:
        //hash: [u8; 32]
        //vout: u32
        let initial_offset = offset;
        offset += 36;
        
        let (_script_length, bytes_read) = data.read_compact(offset);
        let script_length: usize = _script_length.try_into().unwrap();
        offset += bytes_read;
        //input_script_length: CompactSize
        //input script: [u8; script_length]
        let result = BitcoinTxInput {
            data: data,
            initial_offset: initial_offset,
            script_offset: offset,
            script_length: script_length
        };
        offset += script_length;
    
        //nSequence: u32
        offset += 4;
    
        result
    }
}

//Parsed bitcoin transaction struct
#[derive(Drop)]
pub struct BitcoinTransaction {
    data: @ByteArray,
    ins: Span<BitcoinTxInput>,
    outs: Span<BitcoinTxOutput>
}

#[generate_trait]
pub impl BitcoinTransactionImpl of BitcoinTransactionTrait {
    //Returns the version of the bitcoin transaction
    fn get_version(self: @BitcoinTransaction) -> u32 {
        (*self.data).read_u32_le(0)
    }
    
    //Returns the locktime of the bitcoin transaction
    fn get_locktime(self: @BitcoinTransaction) -> u32 {
        let data = *self.data;
        data.read_u32_le(data.len() - 4)
    }

    //The number of transaction inputs
    fn count_ins(self: @BitcoinTransaction) -> usize {
        (*self.ins).len()
    }

    //The number of transaction outputs
    fn count_outs(self: @BitcoinTransaction) -> usize {
        (*self.outs).len()
    }

    //Returns the transaction input with the provided index
    fn get_in(self: @BitcoinTransaction, index: usize) -> Option<Box<@BitcoinTxInput>> {
        (*self.ins).get(index)
    }

    //Returns the transaction output with the provided index
    fn get_out(self: @BitcoinTransaction, index: usize) -> Option<Box<@BitcoinTxOutput>> {
        (*self.outs).get(index)
    }

    //Returns the transaction hash, the transaction data is double sha256 hashed
    fn get_hash(self: @BitcoinTransaction) -> [u32; 8] {
        (*self.data).hash_dbl_sha256()
    }

    //Parses a bitcoin transaction from the given data
    //NOTE: doesn't support transaction with witness data, therefore witness data should be stripped
    // before passing the transaction data here
    fn from_byte_array(data: @ByteArray) -> BitcoinTransaction {
        //Security against spoofing bitcoin txs as merkle tree nodes
        // https://blog.rsk.co/ru/noticia/the-design-of-bitcoin-merkle-trees-reduces-the-security-of-spv-clients/
        assert(data.len() != 64, 'bitcointx: length 64');

        //version: u32

        let (input_count, bytes_read) = data.read_compact(4);
        //input_count: CompactSize

        //Check that segwit flag is not set (we only accept non-segwit transactions, or transactions with segwit data stripped)
        if input_count==0 && bytes_read==1 && data.at(5).unwrap()==0x01 {
            panic(array!['bitcointx: witness not stripped']);
        }
    
        let mut offset = 4 + bytes_read;
    
        //Read inputs
        let mut ins: Array<BitcoinTxInput> = array![];
        for _ in 0..input_count {
            ins.append(BitcoinTxInputImpl::from_byte_array(data, ref offset));
        };
    
        let (output_count, bytes_read) = data.read_compact(offset);
        //output_count: CompactSize
        offset += bytes_read;
    
        //Read outputs
        let mut outs: Array<BitcoinTxOutput> = array![];
        for _ in 0..output_count {
            outs.append(BitcoinTxOutputImpl::from_byte_array(data, ref offset));
        };

        //locktime: u32
        offset += 4;
    
        //Ensure there is no more data in the data buffer
        assert(offset==data.len(), 'bitcointx: more data');
    
        BitcoinTransaction {
            ins: ins.span(),
            outs: outs.span(),
            data
        }
    }
}


//Tests generated by scripts/tests_unit/bitcoin_tx.js
#[cfg(test)]
mod tests {
    use super::*;

    //Test parsing of real on-chain transactions
    #[test]
    fn test_real_txs() {
        // Real on-chain transactions 

        // Transaction ID: c7e0d73022eb40bc0a907430d4daa1491fa17b804acc239953ff4e9295969d3a
        let mut serialized_byte_array = array![0xa, 0x0100000002de5864460366c8215f6bcb1353254815bb364dc223a060ba1ed4, 0x6fbe3bd46d5e020000006a47304402202f875cd8878f4b1ae557ec97855168, 0xb3be5678d828e8250ab449e766726078d4022053baa4b4d4ed78e62c5959f3, 0x5198dda391c7e0aaff7fdc187ee33177b70a1bac012103bb53398467ba53ff, 0xd7bbcbf7fe7f1ccf8db00474a88b01312760daa407937401ffffffffd8196c, 0x77fe4228b22927933c286a7560fe404ea64193413ee62d1e3969362bc50000, 0x00006b483045022100b6818c534bcbfad382df102f07f96420d958cf634010, 0x9adbf246d21bd329378d02202c43c756e62b692e366e765bf22d5463c65c5e, 0x4075684f8ab1da2b257fc14e34012102e19ba5a96136acaa60ce449fc38702, 0xb412c56ee3451cd640a8565a11ba7ec71effffffff016a2206000000000019, 0x76a9143a2affdc007b67052cdd1025d99ec337c3818c6688ac00000000, 0x1d].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x3a9d9695, 0x924eff53, 0x9923cc4a, 0x807ba11f, 0x49a1dad4, 0x3074900a, 0xbc40eb22, 0x30d7e0c7]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xde5864460366c8215f6bcb1353254815bb364dc223a060ba1ed46fbe3bd46d5e, 2));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x711167ba84a418624b9a7ac4dd5b34eac88dd19b2bf0af3d3540a9d445e8961);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xd8196c77fe4228b22927933c286a7560fe404ea64193413ee62d1e3969362bc5, 0));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x100ed9c3118203cb1dab2b8017ba5760f82f32d2696b664813ee3ab26ae468);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 402026);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x15fbeb4c5e04888e90d312761088f610e840cd9401433465537a06a3b769fe6);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 37fd47be1e39f0e7e534c312173f70fa2716fcc14fabdd2bbacd52ea40894ce5
        let mut serialized_byte_array = array![0xa, 0x0100000001b7b902f12e34776bfd607c2c5e5e958cd1a85e735eb15aa92e9a, 0x564669de684f01000000da00483045022100d8ef441bf4410a251408c0eeb1, 0xa0dd21f36ea168ca6a687270f9f9ffcdadd3dc02202ec1b385b00bb8ceff12, 0x02d9144b5d06748b1f167188cc771dee9a02d943d6140147304402206d7a0a, 0x96a933d1ac3c21a6edbb96b8c7b54510d978af5e843c44cc056e7b92f00220, 0x5d2c96135281129cbdf7499e81a35c570899eea8bff3f9be3aa58a44dacec5, 0x0401475221029ef4f8e664cc9dd773dc5850b7868b68624312bbf3f071763d, 0xc07a32dabc282c21032af98149e8c12251ea18eabeb415746ca783fe88f27b, 0x7ece7e1105210a5507c252aeffffffff02e8800000000000001976a9149436, 0x380fc9d27df468fbf79b2d543d3dd1253c9688ac703f00000000000017a914, 0xa3059bef9f36e2ce9668aececf5222ad20a744878700000000, 0x19].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xe54c8940, 0xea52cdba, 0x2bddab4f, 0xc1fc1627, 0xfa703f17, 0x12c334e5, 0xe7f0391e, 0xbe47fd37]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xb7b902f12e34776bfd607c2c5e5e958cd1a85e735eb15aa92e9a564669de684f, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0xf2e2c9dbf65e7caf7a6d70d3b35cea59e8d13436324cc74e3ddd698d7812);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 33000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x444d721f316fdb1fb2820f87c719907077188f5302793ec59a5cc85322f750a);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 16240);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x35827338414903be3c945812347aaa70d231d0478d65f3ee77619d4a4ef9aa);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 7698a2ea83e05a7517c39942a27a9466c37e0285f3357572cc894a64a3fea34c
        let mut serialized_byte_array = array![0x7, 0x010000000170628c8d8e6d10d7b10294fcd970e4e19ef376397571f031704d, 0x45a0bd4574a2010000006a47304402205c1e90845f45edb7268ffea82066ac, 0xc251abf4d7070b2f4812a68a711faba6320220081072fc6b72f9e26ded2c7c, 0x2ca6c847149e18f35465022acd62c68208c128e3012102f2e84652c8f1ee3e, 0xcb915784bd797e354357ce292998b71a857edf70db0550d9feffffff02d277, 0x970b000000001976a9141ef0aab2b24f3c28564a6ef1c805c4ea9218295588, 0xac77c64316000000001976a914a56a6c30e9c5a60f33d509160e895cfbd151, 0x305f88ac8a140600, 0x8].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 398474);
        assert_eq!(result.get_hash(), [0x4ca3fea3, 0x644a89cc, 0x727535f3, 0x85027ec3, 0x66947aa2, 0x4299c317, 0x755ae083, 0xeaa29876]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x70628c8d8e6d10d7b10294fcd970e4e19ef376397571f031704d45a0bd4574a2, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x529a0f8ffae473b67e1e7e08a28ef6c68064cd7c1619b037b35bcdc3fd45196);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xfffffffe);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 194475986);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x70e72781695a4ba4e90542890a868ab74463beb000e429e60bb10f0dbe54db5);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 373540471);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x310af827e0d3d33c094e2f23e678aed29ea6c5a724a4ce9982c635a02383e24);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: b9a9371a8937158b337ae7e43be28e21aa7a480cca26367e09df00bd1245b1e5
        let mut serialized_byte_array = array![0x16, 0x020000000415c6ae5c53b34d12dfa28a30fce2ba8803d0f6e6912b922512cd, 0x5b4b34f40483020000006b4830450221009e63ee87d9faa4e7e01b419357bf, 0x749de7d58cc105f4f7b550b72084f71b525502201456a6b83ae91c7ab76acb, 0x16319c01c01691099c2aa144425c74e98f8c714554012102484fdfa0e0638d, 0xc5bba71893d12d81c4a3aa3e406a5939180123175586bbbef2feffffff5d44, 0x9b009980e59f85f0a2fa214cad0287aa1ae48de170ac3ba8b493a317035101, 0x0000006b483045022100b5ebf8149f1fbf86841253436ebbe0f36bffdd4c2b, 0x12b7aed552626614bd4b5c02204f8d02a63c01cd6208dc2d2dfc6bf2981352, 0x0265b9d89f9eb085451a6caa6c6a012103a851a5b3778fdbde0648bb4f0661, 0x77e06c18699124fc36b224bfc3f9eb09b97dfeffffffbee2859516d0531b56, 0x477ab3ff6532e01e0572d22156ffb1bbabe5240ce3d1a6030000006b483045, 0x0221009d3da1839676520df5a717356184a0468aab21d79c5f335c4df7603b, 0x8f32cb88022046fba9afc6eef57f29abf3fa58fd0cb71909006fc4181829ce, 0x192cf2324cc8b1012103b61553e2bec09792f4c0170d2cbe036eb5fc9141dc, 0x4b5d27065ca2dd6f52869afeffffffdeb2cce8ca5c6a1b9251906847ceed8a, 0x63cadc3b8b6ff52fe82ddf1134863dbe010000006a47304402200f4eb8bdac, 0xf93edd6522a5e81ce2124a3aacaf1fe9a45f0d3e8085965bf59387022021d1, 0x5b4749a321c89e3802d377dd39b54aecd295a8c193aca1e018cf6d64e1ea01, 0x2102b1759a2022782bed4840c6dea3a9f71be90625c55ded07f4e28f86839d, 0x4601fefeffffff032c401500000000001976a9145b480707ada4473714d559, 0x0c2e6ae45aa5554e9e88ac99340f00000000001976a914c887cd623e306846, 0x5d8ff1199bfcfb2e2a94990388acc60b14000000000017a9140ecb6201ad22, 0x5ad35df5b84779d09ccb541695a38788ee0700, 0x13].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 2);
        assert_eq!(result.get_locktime(), 519816);
        assert_eq!(result.get_hash(), [0xe5b14512, 0xbd00df09, 0x7e3626ca, 0x0c487aaa, 0x218ee23b, 0xe4e77a33, 0x8b153789, 0x1a37a9b9]);
        assert_eq!(result.count_ins(), 4);
        assert_eq!(result.count_outs(), 3);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x15c6ae5c53b34d12dfa28a30fce2ba8803d0f6e6912b922512cd5b4b34f40483, 2));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x16b81ef31b57ede1e21f7b7ee4a4dab99a834d2bf8a7336faa5d017eee551a2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xfffffffe);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x5d449b009980e59f85f0a2fa214cad0287aa1ae48de170ac3ba8b493a3170351, 1));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x35d20e2fd929aa77e7ad223939b80a7f85ce34d3a84c3a4ed8b1496e19ca7eb);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xfffffffe);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0xbee2859516d0531b56477ab3ff6532e01e0572d22156ffb1bbabe5240ce3d1a6, 3));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x1d48d691293d2bc6ce2fbfbb0ae61afcf43c6836bdc1e1ec5b9a9fade218b7f);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0xfffffffe);
        assert_eq!(result.get_in(3).unwrap().unbox().get_utxo(), (0xdeb2cce8ca5c6a1b9251906847ceed8a63cadc3b8b6ff52fe82ddf1134863dbe, 1));
        assert_eq!(result.get_in(3).unwrap().unbox().get_script_hash(), 0x149d86ce8abd5bd39ab1bf00d27167896ead731b3f15926569584489598fc5);
        assert_eq!(result.get_in(3).unwrap().unbox().get_n_sequence(), 0xfffffffe);
        assert_eq!(result.get_in(4).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1392684);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x7a10c82dd66a58fc0d0213cabea353be9dfe06d4d26983221b42dc59a6abae6);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 996505);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x2bdf68027fcb2e8a891795597bb8ce5fbea173b61c3f5364680fd93041ebe09);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 1313734);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x6db9e60abc8fa1a363518b6c66ce7080b44d4cf50986ee49071d931f759a7f2);
        assert_eq!(result.get_out(3).is_none(), true);

        // Transaction ID: 5f324a3cf8f2e71689b1e81ada87cf5c2b2feb512a7232c8bd820bc0877fe6bf
        let mut serialized_byte_array = array![0x7, 0x020000000163eacf0763c79a980fb04283e1463839bab84c62311f4f96859d, 0xf7b527eacfa8010000006b483045022100d91863b50cbb83367dff883c89a2, 0x1d8ad4e72b35010eb7589b3edef9dd7fe5e9022044f4da6277aadf4aeac52f, 0x419cc4deab931fedce6d20e46a165b0452dd86041801210228724879b75c50, 0xf2d04dbd4121eed6e97ed812c0e9173b136aaf2be8349dac55fdffffff02bb, 0xdf0400000000001976a914b2702e2ff0f7773d8175c8eb99507336634b9fbd, 0x88acf98d0900000000001976a9140e37518715864ea94b56b1168553743a46, 0x51b98f88acc0670900, 0x9].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 2);
        assert_eq!(result.get_locktime(), 616384);
        assert_eq!(result.get_hash(), [0xbfe67f87, 0xc00b82bd, 0xc832722a, 0x51eb2f2b, 0x5ccf87da, 0x1ae8b189, 0x16e7f2f8, 0x3c4a325f]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x63eacf0763c79a980fb04283e1463839bab84c62311f4f96859df7b527eacfa8, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x71d518eb48631049473f87de21b9b1a2b145b74c9505e5e49791c8bd2b0e5bf);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xfffffffd);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 319419);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x496976658536f0519f8f2d370d736768f7d24fedf3bf3d44254e5c9e33fb1cd);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 626169);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x7f20e0efc6ba50e5ea9b71a64d99963516625d42ecc43ad1eb045ddae44fefc);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: a83008a4774cbec0b4d09b9d0ff88ebf0b33bc0d25c97e5774ae983ce6f85e1d
        let mut serialized_byte_array = array![0x6, 0x010000000147048f2693c1bc585af9b13b52fd344e56ddd0410d4d92e4361b, 0x6bdaddf20184000000006b483045022100fb7cb443b05c8ef61fc2fb1f7a53, 0x3f904ac3d2d869b70ebcd8a4473db7a60a52022003a5dd4100c01d7bc3bd98, 0x61617945d515b093332d78d62782ed879843e9df9b0121037da9b0fced674c, 0xa703394bc26cf059ef2596847a8aa59ff40e748607cecba136ffffffff01f0, 0x772400000000001976a9147aa984617873f4d4078f4f579162eebb1e2e4aa6, 0x88ac00000000, 0x6].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x1d5ef8e6, 0x3c98ae74, 0x577ec925, 0x0dbc330b, 0xbf8ef80f, 0x9d9bd0b4, 0xc0be4c77, 0xa40830a8]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x47048f2693c1bc585af9b13b52fd344e56ddd0410d4d92e4361b6bdaddf20184, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x225c84d038dc013ecd6b79ac9ff390cc9f7d45504ca3146877456eec5d6198f);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 2390000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x3c05fa429be868a4c1f9a2f5d94b362b9d7a54065bc8ab8efaae9b14473ffe4);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 74f7b7e8d5bd4e8c6a7387237907e9456b2c8d143cc75d43940c089f871fc60d
        let mut serialized_byte_array = array![0x3, 0x0100000001af9b4d3741d7f6234936d0fd365a8e077928ca3bc868fcf96006, 0xfb0bcfd40c1c0100000000ffffffff0288bc0000000000001600141bb2892e, 0x9095b4134db1e5e726bfd77e692381956d990b00000000001600146aefe812, 0x6b8c4242bc3dd69248cc41dbca54a62600000000, 0x14].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x0dc61f87, 0x9f080c94, 0x435dc73c, 0x148d2c6b, 0x45e90779, 0x2387736a, 0x8c4ebdd5, 0xe8b7f774]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xaf9b4d3741d7f6234936d0fd365a8e077928ca3bc868fcf96006fb0bcfd40c1c, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 48264);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x628cbde75023a941fd88734b38444a4f8d9f830631cb7ccf5d85303e2871432);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 760173);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x77b048389602332c6eb4b2edb8a5ff8089b226e48582a0b51df707855bd9d08);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 3ecfa3ea6e284c1c021079a616297fa2e469259db5ac40cd1418426f9a392556
        let mut serialized_byte_array = array![0x7, 0x0100000001b814c3e62f882c95dedba5de117f3a96e6be1b2ee8790ed18425, 0x0c356ca10ef9090000006a47304402203bd976bba1bf68ebb5e39c232329fd, 0xff782721b642f7e8c89c3e93130f0b43bf022049d429af513e18a538e115b0, 0x5a2266eef186b5313d70545537e348c2df6e8cd901210345ecf3bc49e9b577, 0xda0466e2282065179cf29b17735008d0e629b19d24be9fe3ffffffff027a0d, 0x0900000000001976a914179935eb112341f9f561fdf00a932d641330192d88, 0xacc0f35e01000000001976a91406a60fe6dfe90a51a162d90a0246d6837fd3, 0x152d88ac00000000, 0x8].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x5625399a, 0x6f421814, 0xcd40acb5, 0x9d2569e4, 0xa27f2916, 0xa6791002, 0x1c4c286e, 0xeaa3cf3e]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xb814c3e62f882c95dedba5de117f3a96e6be1b2ee8790ed184250c356ca10ef9, 9));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x12709984d09bc431d49b88323981361959fb5f3d299d7e218826021695899dc);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 593274);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x3895ea0e42cc5e3a4d1bf6569cc8d59ed94375a91a15a00741b8278879c2eea);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 23000000);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x31b058602ed41c28a68fba37b90f6ab93e064faba8ae1a1d2777544dda18122);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: e29e1856a3faff882e149c00c1c776c932d5800a8f8d1683897d45eb60022581
        let mut serialized_byte_array = array![0x5, 0x01000000010000000000000000000000000000000000000000000000000000, 0x000000000000ffffffff57031c0205e4b883e5bda9e7a59ee4bb99e9b1bcfa, 0xbe6d6d6f3d5a22e3205d3a03ba157964240b3089fec9a9ef2249fa3f2051e2, 0xe85177391000000000000000c1604db6dc5200004d696e6564206279206865, 0x7969313638ffffffff016bf81895000000001976a914c825a1ecf2a6830c44, 0x01620c3a16f1995057c2ab88ac00000000, 0x11].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x81250260, 0xeb457d89, 0x83168d8f, 0x0a80d532, 0xc976c7c1, 0x009c142e, 0x88fffaa3, 0x56189ee2]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x0000000000000000000000000000000000000000000000000000000000000000, 0xFFFFFFFF));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0xaf72e56712c0fd72db0843b66d025238bc268c445004c15f9a7d944fe36912);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 2501441643);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x7aaef0a248d417149bf0fccad02b3cc89d2bfd125bcb6c1c56b6ee658cde0b6);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: d006401979a0cbacec814ecdb35377595c4c7eed37d65b1babe7d9c38a53ffdc
        let mut serialized_byte_array = array![0x6, 0x01000000012dee045c06f7a63e0cebe2f4b60479c2a819c51add17518fa064, 0x844fa5e49a9e010000006a47304402203b6f702ea9972b0b0b776b69eafc26, 0x97eba3cd5a9a32175e4617d7469c16564602201bbd3b4b07a2bbbc76323322, 0x128707499e57ff348cfcddceed84099f003fb52301210284503a42db828b9e, 0x0c95cdfaa13d015d8bb200b780e9343a8fd37ad17dd39cdbffffffff01a56d, 0x6700000000001976a91454c4c9d7ddad587d8343eb20ccd14b079d4f18a588, 0xac00000000, 0x5].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xdcff538a, 0xc3d9e7ab, 0x1b5bd637, 0xed7e4c5c, 0x597753b3, 0xcd4e81ec, 0xaccba079, 0x194006d0]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x2dee045c06f7a63e0cebe2f4b60479c2a819c51add17518fa064844fa5e49a9e, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x469976c4d5b911f43f88b33cf8a295cca26a2f86868fe77965b683f75db968f);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 6778277);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x5304375f2bf862c6fc79ec497bda19200ac6b55a3a0d25edda883774aaf5400);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 71c7bf90fb2393a292afe4a491867c2b4c5f941bad37a0447f30f194a24afc32
        let mut serialized_byte_array = array![0x2, 0x020000000163453fe543f18c1c4f3cceab8e42ae1c94af6c07f92d781a1f89, 0x9d47821334c00300000000fdffffff012202000000000000160014a2cf3e08, 0xe9172029346bd792c87e2ca5a9bc7d9000000000, 0x14].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 2);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x32fc4aa2, 0x94f1307f, 0x44a037ad, 0x1b945f4c, 0x2b7c8691, 0xa4e4af92, 0xa29323fb, 0x90bfc771]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x63453fe543f18c1c4f3cceab8e42ae1c94af6c07f92d781a1f899d47821334c0, 3));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xfffffffd);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 546);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x256a6a13a61cfc9802503587fa7bf5c47cf9d0c5a9730c541e9a84a5a3dad4f);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: e55d0c6bd13b2891df51048488be62fe31a41a26f35577fbed8f5c6ac7e5e814
        let mut serialized_byte_array = array![0x6, 0x010000000109d5e2fe20df67cfe8346a40002021c7bd07d8f10ecae37a109e, 0x799327d87ac6080000006a4730440220177aa99d6de75c503b0cc6181fc8de, 0xbb16d71bc97ce2c67c2f9e57d6c90427f3022052062808d925fa4a01de9347, 0x113f3745007d7a5eeefe1b1c1349b00f0f971de40121024536aebc6f29fdda, 0xc1b424040300ded7a4b3d7dc229df221313072a273046061ffffffff01585e, 0xb007000000001976a914e86087fd37ae8658daaa05317974e602f7f28a9c88, 0xac00000000, 0x5].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x14e8e5c7, 0x6a5c8fed, 0xfb7755f3, 0x261aa431, 0xfe62be88, 0x840451df, 0x91283bd1, 0x6b0c5de5]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x09d5e2fe20df67cfe8346a40002021c7bd07d8f10ecae37a109e799327d87ac6, 8));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x7f066033611708dbe541ac405dbf83003aba5dba1be1aa1cbb74f90befeaefe);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 128999000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x29a82284624fadad1fa4dbd727c783ef32ea2db3eb7658d9f66334cb0187b69);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: b301d1618b2d9b28eccf52d08af9ecdab073fa3c31df71ffcc6db70dcf91c336
        let mut serialized_byte_array = array![0x4, 0x01000000010000000000000000000000000000000000000000000000000000, 0x000000000000ffffffff0804ffff001d02ba00ffffffff0100f2052a010000, 0x004341047abd99b3cec0d8c1e502f59f418093b743de18a18d567ae54e5c09, 0xeb97b5305b0f41d4cfb6b2c1e1270c9cda119918f7ca08832c87c477e68454, 0x8d50f4d9d924ac00000000, 0xb].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x36c391cf, 0x0db76dcc, 0xff71df31, 0x3cfa73b0, 0xdaecf98a, 0xd052cfec, 0x289b2d8b, 0x61d101b3]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x0000000000000000000000000000000000000000000000000000000000000000, 0xFFFFFFFF));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x23780e5df8ca5e9614ee6bf105674999521922a2d7df1d8f8997681bb3c51ee);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 5000000000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x65adf8ee0b6dd0b0f3c2b9c17e3de89bf68a8323bde51393aef454f9ef80914);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: ca61c23c37bdd61725c872b46bdc12599389070917a096c4662edb850752a91e
        let mut serialized_byte_array = array![0x2, 0x0200000001ee68a8d6f98f1ed66d66d7ef89a25c12abcbb8bfd4debfb4adf6, 0xad2302d946337901000000fffffffd01260100000000000016001428c031d7, 0x7e037650d5b46fd9696d2f78009ac35f00000000, 0x14].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 2);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x1ea95207, 0x85db2e66, 0xc496a017, 0x09078993, 0x5912dc6b, 0xb472c825, 0x17d6bd37, 0x3cc261ca]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xee68a8d6f98f1ed66d66d7ef89a25c12abcbb8bfd4debfb4adf6ad2302d94633, 377));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x2272be0f580fd156823304800919530eaa97430e972d7213ee13f4fbf7a5dbc);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xfdffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 294);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x51e9e09fbe9857595a8d1871d58b4be5b30300c874ca21af13547e54d9ea203);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 935e5017d8ebb6cf44436f3fcf61a0b6e7109dd209c938feea40d5c35273eb35
        let mut serialized_byte_array = array![0x8, 0x0100000001385464acef64eabbb89e1379cce0d9d2d85f62d0268b2ef9a442, 0x77400e703bab010000008a47304402205b02f2b5af041da36b167cf93a9da8, 0x2a27049f14809be8652233152721468477022061a6691ab8708d874e30fc90, 0xaca9e6421d461d935a29702d744fca4276d6f5c0014104e4ab0468748bb4c6, 0xad984b87f1d7f2b4f6d076021a1ff6e6f215752fe149cb458472100adf6b3c, 0xb1a80d5104c7abbc8e524731c608de391fb6d2aed6bbdb4461ffffffff0240, 0x4b4c00000000001976a914d2ac4baabf35d7c868391164194c0f6c25397c1d, 0x88ac90e87601000000001976a91443c6e40e429bd19cff45007b9e61b5892a, 0x3e184188ac00000000, 0x9].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x35eb7352, 0xc3d540ea, 0xfe38c909, 0xd29d10e7, 0xb6a061cf, 0x3f6f4344, 0xcfb6ebd8, 0x17505e93]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x385464acef64eabbb89e1379cce0d9d2d85f62d0268b2ef9a44277400e703bab, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x1509691e524d87012ac9e5eaf8ead24b0665f5f014d08637f35bbdc6d094531);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 5000000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x68991caae53a3a89aec66839c04b84db03017af3e31f74bebf30f19a6a675f);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 24570000);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x774a6b8e947057940af7427cd52e9283f6e35defaf4cdf90560e5ad3cc75a4b);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 265384a0608aa243f2c04b764eaf4d7ec60404e8d9ede240ada92aeb31348ab3
        let mut serialized_byte_array = array![0x9, 0x0100000001fb50113fa7086540144d920c301984ef7c19429e2be52d537ef4, 0xb0538a36adf3000000006a47304402207aef115cc45d9294652f39df277230, 0xe38a4170e4b4e02adfdbc483cce4139bb102207680ae427723f30997321c65, 0xa651409329c84214bc1b00d562c45e2130ed7b4a0121029b69e8ef7a2a4349, 0x563858b86391a8930d7f0bc8b5812dc47e9acd255f198a43ffffffff020000, 0x000000000000536a4c500006a5af0001b2f3050c9a070bbb561ea16bc827a0, 0xd3268e3630544bb96725cb25971ca73efb86e651f117d39206e79f7670b26a, 0x5c6aac4806647262bbf01180011197571bae24167c8022f1b0c7f1706b2803, 0x00000000001976a914a7a180c8eea131f892da389fce3811abf1f9d0eb88ac, 0x00000000, 0x4].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xb38a3431, 0xeb2aa9ad, 0x40e2edd9, 0xe80404c6, 0x7e4daf4e, 0x764bc0f2, 0x43a28a60, 0xa0845326]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xfb50113fa7086540144d920c301984ef7c19429e2be52d537ef4b0538a36adf3, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x3881f681cb02b442fb498f4d18ca9cae00cc45ffb2ba2890886bea20a1e5ab7);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 0);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x13cef4c79665e756ec74326e423f0ad47d9cd54217748ba353a646eb0c047fe);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 206955);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x60a3e9b0f382cce5dc359fdd1a93ec4b16d5021232487aaca430ff580be173);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 52d798f08621c11e325917c57e727a9a867eb49e5e75f29a4d07c0370a2d1a5b
        let mut serialized_byte_array = array![0x7, 0x0100000001790c9a6b28bf4b2e1de9ecf30cb2a212dd6b1e2c9692ea769524, 0xf007f26617c4000000006b48304502210096636f7055dce832a4abe02cad9e, 0x97d1d3d025b860298b501f9647b34626d992022063e86971f9cf566560ee71, 0xc61baa9a235d5856bf3eff044f837bd15b834cff82012102a64797f01115bf, 0xd84f420402ad9e4b964c7325d5491bf12c514bc6785a58e090feffffff020e, 0xf4e701000000001976a9149a7ba0ef4c1c25caf84bc86d0dc1dd070b5e8015, 0x88ac26b70d5f000000001976a9148aaedd5025eab42b8b5ed734f566886403, 0x037e3d88acac850600, 0x9].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 427436);
        assert_eq!(result.get_hash(), [0x5b1a2d0a, 0x37c0074d, 0x9af2755e, 0x9eb47e86, 0x9a7a727e, 0xc5175932, 0x1ec12186, 0xf098d752]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x790c9a6b28bf4b2e1de9ecf30cb2a212dd6b1e2c9692ea769524f007f26617c4, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x436d6433d7b71e7d9d1c3c82b5628ff9376d3924ec11a9b11f38a57c103725f);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xfffffffe);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 31978510);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x89c509045681aff3420e5bc7c18852633c561440a94d15ef6ab4a75ac4345f);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 1594734374);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x38455172bbda0421847373e39f52d295ba8ee677aa6e3bfdd8daccf7e31544c);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 292562d2cef3486ed0ee852f8584f736ce343b72043d1518d4cd1913e36d1a7c
        let mut serialized_byte_array = array![0xb, 0x0100000002e92c4bfbe79ae705a0240f2b12a7e9938bee8e6264676d416453, 0xe26d96169b07000000006a47304402206b05d6c8792e7d67b1990ac126beb5, 0x8d5e8e4d00f3b7429b254f57c7c334f556022020401479b4caddf0e9f768e6, 0xb189da77f33d64237989d956d1fd7bfa7069a762012102704c22e1d86185d2, 0x8c4252223bd2e64c720bea83b5a1eb4c56d0300be58e9cdcffffffff2af1d0, 0xe572638c1d2a1c62e3e6bdb822e049b0d1c5dacba1700b053778f459820000, 0x00006a4730440220692e2ba5b0e7fdeafaf12a563117936b77d06af1742219, 0x6ff22f86110b68e31202200e21c723641b7650fcb67150f1c2c9f9729fa217, 0x8a8ee48179e389c507db1731012102b9c96edd9ebc52ed1f1af3fe8fd488a6, 0xba3ad602638caaa08ca07131d6a491edffffffff021b4a0600000000001976, 0xa914a6fb50f4e56bde11ebccb164fa72c46fba39d24488ac44c93d00000000, 0x001976a914dbe8a62476490557b95c3e42abaf49c56fd62b9488ac00000000, 0x1f].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x7c1a6de3, 0x1319cdd4, 0x18153d04, 0x723b34ce, 0x36f78485, 0x2f85eed0, 0x6e48f3ce, 0xd2622529]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xe92c4bfbe79ae705a0240f2b12a7e9938bee8e6264676d416453e26d96169b07, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x68e305c8a5a3d5ff370ac7257f2fca6bb66b378753f47153384dc102b22d25);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x2af1d0e572638c1d2a1c62e3e6bdb822e049b0d1c5dacba1700b053778f45982, 0));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x1446db314426b8255e5806e2e51452ff0512bff09af2425c66b137befdcd668);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 412187);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x54cd0e189e2d9e88826372601ab4f19be39e31e0528ab4f7ab8d5373a5bffb6);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 4049220);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x221d56f2823dde09157490174c7c7eb65ea39550374aa640db2301c39e985ac);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 1dddaf96fa5d2fb79343adf830db067f09a3bab6bf12b1a0c0dcce57b10adec2
        let mut serialized_byte_array = array![0x5, 0x0100000001310b5765c15b46829ef062f63d475f180a2602d25c478621a722, 0x79b0f6d2203d000000004948304502210088c25fc9aa6cd11e025a2f238796, 0xfc8d350727d541d32fae1c298d67889938d902201ede8366f8deb5a3d8306b, 0x778bdec4bb3acccc22be5065fd32c397976dd0b09301ffffffff0100f2052a, 0x010000001976a91428b4a69ff958801b1289f6888671eba670dcf51d88ac00, 0x000000, 0x3].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xc2de0ab1, 0x57cedcc0, 0xa0b112bf, 0xb6baa309, 0x7f06db30, 0xf8ad4393, 0xb72f5dfa, 0x96afdd1d]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x310b5765c15b46829ef062f63d475f180a2602d25c478621a72279b0f6d2203d, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x4ecd88ac3fdc95dabeeaec0f697e3f7ccbf91a3e5a168fb35a288470678e5b7);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 5000000000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x1e37ae9ba98bbe9812fbde110fcdbb386f097d0bc7747f7aac1cf06c380e4ce);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: ae5533f4c3e5f1ea6044d7bb5b8d9aabae5d09c8fc5dc56062aefd435cc2d722
        let mut serialized_byte_array = array![0xa, 0x01000000022ee9dfd29519415c4090c5eed45d02d563430eb117fa800e22d0, 0x88a03a9a6a38000000006a473044022005e6f2097d5a50f703e377e35e569c, 0x37069d7233c534602e45f831832f2b227802205c1a481c40f6e96d63c4b0e7, 0x88f46d9ea76356b8c52f55f70ad76f272296375b01210271d32a56be71d579, 0xb27da958c056b5e4bc3236ee825be5e973ad65d320128de1ffffffff90feaf, 0xd87235bf35344b28636e437f58c19846fc3aff1fdd5c3ea918f79f94e70100, 0x00006b483045022100d7a0349a09e2770e241b0686e02ae087acd3964cca65, 0x8a2b043788e5a33b03d1022071836a39035ade02831e196ec15a8e0cc97ef0, 0x09223a17bde452f1b0b0c2625001210271d32a56be71d579b27da958c056b5, 0xe4bc3236ee825be5e973ad65d320128de1ffffffff01603871000000000019, 0x76a914f9e6e90cca69438fe8629e40bb598b9e57d010e288ac00000000, 0x1d].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x22d7c25c, 0x43fdae62, 0x60c55dfc, 0xc8095dae, 0xab9a8d5b, 0xbbd74460, 0xeaf1e5c3, 0xf43355ae]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x2ee9dfd29519415c4090c5eed45d02d563430eb117fa800e22d088a03a9a6a38, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x66c0c51a53720b09eb71ef750ae1ad580910b3404aaee06a5991fdb28b49041);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x90feafd87235bf35344b28636e437f58c19846fc3aff1fdd5c3ea918f79f94e7, 1));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x371356eb98bc2cd32c7a0a9b818bcb4d9b7bfc078a44e3a6c251b85a6a38108);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 7420000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x6e7c2f83ba08431fcd0713a3a263370437887afa5e110a6eb137b09321e74c1);
        assert_eq!(result.get_out(1).is_none(), true);
    }

    //Test parsing of ranomly generated transactions
    #[test]
    fn test_random_txs() {
        // Randomly generated transactions 

        // Transaction ID: 1489294ad37ca17aceb1e43940a7b56ae2c3489afcd70f03637cd6fb34b4eca6
        let mut serialized_byte_array = array![0x16, 0x0d9d7b1701635a91879d8c57225f4bc2fb765e98ca8feee397f0a3804cfec1, 0x38cc31bbe9f3d0566665fdac01f6c14989b94dbb0dbfe1aea78d12f86e424c, 0x9bcba008c08ec3b044b2dfbf04cbf9c7f4ccba292c8eb6e2690f2bf852356e, 0xcde04dbbb6d1f75e44af83fb3794953ca5d38827af2ff8061f60f1ada9c560, 0xdee43b95a729a48501f5413e2472986b4e0422c716088d887daf4b455e0754, 0x1eeb32ab9ca7a665c68d52fbbe59d4745dc04fa076aa06bab3c0c65bf1e72b, 0x2f9f6d16748cc0675368ccec137c7c573e2556b3e77f8dde270b21b4fcc224, 0xa63e6b1525defac2925b22d19636da897d9a1dd19ea1dad1c77269da1ecb57, 0xba57e82deb6ff34bad27ee0b5318bc189f49591444b8a989897676d6523fbe, 0x08e68b7bd23616d75666c178504511ff74df7d7d71d3dc6ccaf514fe3771b7, 0x145455313ceff5879188c2b08fc8617ae813aec1f628501123661e1b1ddd1f, 0xab8a63e1539db74066e4b212fd3e62231c53ecfd4a6d60c35d23334faa1224, 0x1cc7e32429546dd14eca59b81757a0e7e07432fbb97b2c1637786de578b7c4, 0x82ae5f0275f9713427ea9ae35f28fb76c69da37b9f5cdde4db3e022d46514b, 0x91b947c7fbd366f5d1bf5a7716c822819822075f95b7af4ee2d8267914b533, 0x1f086ff99f296d0ed2cd410545b88a83054400003e99178dd1eac9641e610e, 0x79fddf77f6837c23cce96b5ea8b38d76bbb82db517f745cf9baea1a5be419b, 0x45f92f52c02465bda3a66a4f254d0bb7fcc9c402c663f8c2045a63050034fc, 0x62948ce10b25f3bb073b23cbb33fb342c7b3e074e1f10c8e5e8abe9fad1b28, 0xd149ebe9acf2f5410eadddd3742c6e9310a8c9aef294062d70fc0400013ba7, 0x01e00b606c01000feb3ef5e6e74420831c700a7150ccde1a8d866760350400, 0x24efdc89b23fa2e0318fe311e10c27b4c6e20f682bb3fe3b13ab8283766cbc, 0xc83fc1179f58190bedfa, 0xa].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 393977101);
        assert_eq!(result.get_locktime(), 4209838873);
        assert_eq!(result.get_hash(), [0xa6ecb434, 0xfbd67c63, 0x030fd7fc, 0x9a48c3e2, 0x6ab5a740, 0x39e4b1ce, 0x7aa17cd3, 0x4a298914]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 5);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x635a91879d8c57225f4bc2fb765e98ca8feee397f0a3804cfec138cc31bbe9f3, 1701205712));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x631958b02579fcab68797c3d5308c58dbab37941f73d8521e5edf07eed467ab);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x41cdd20e);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 74790472431685);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x7334c67a1dd3069f23b9af3e13f6a552833741d1afb95e45d771a2c0ed26b8);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 1516613161646179);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x24c52cf9e2e1eb2b381053749216a1e8dc77ebcca5d65cb942e8bc8c7d7774c);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 1403458628785394);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x3cafcae4736d5b9180ff639ef4f01a04ee2bbe040a4abdc3fa8f2f90c3de18e);
        assert_eq!(result.get_out(3).unwrap().unbox().get_value(), 400634748600743);
        assert_eq!(result.get_out(3).unwrap().unbox().get_script_hash(), 0x6f5afe5289dbff681dee9c41a30a39ee18c13312ecc47998bc9a508315bb3fe);
        assert_eq!(result.get_out(4).unwrap().unbox().get_value(), 1184588076846362);
        assert_eq!(result.get_out(4).unwrap().unbox().get_script_hash(), 0x8fcc90320ec67421fec08d2ca43b64dce80b833e55845e0abcbca3fc202684);
        assert_eq!(result.get_out(5).is_none(), true);

        // Transaction ID: ee124627ddcf81816ccc3f6882261d908d97de32a2b9ea64f080d72d1a1cc0db
        let mut serialized_byte_array = array![0x25, 0xe7e1b061046c37b836d5a8511cde315420738210124e28a5f8ea53015bd094, 0x38622de116f0b6a938d40fdae18e3ef467edc01cee76a4235e5b68ec1e2c8b, 0x178774c3bc984f9e0c6354eb47bcf0f03e651dee47b6630e5e991cdc1b0459, 0xa324477a0fa44f5b317098e3600d262003ca75689049afb58fb0b285419be4, 0xfa471e84c45383d63c2ce8003bec04e1c30294c59d6b826f8f5e150f1dfdc8, 0x0101755a1373efdc11835cc01ff1a8bcb06f95766e78ba54a86728e1bf8533, 0xad9e9bb3cae2089c447c92252656715386a9015c85763b9a72cbfd73b45649, 0xef3ef6746b5e91c8c0c748809576369a2ea043213c8d8145e815aac50951df, 0xb0ce86765c54fd6c7ec95d7d5efd78cad9c685d46fcac3ee36e893bea3ddde, 0x534fd9690b8ae3ce4c26a970f6e8afb7989cc6959f92a92e05181f702f01fb, 0x721354f4e272e0c13a137f729f7144f49d0f5c52d40a62fed5aae96912cec5, 0x369bc497242f51880871c050c3940ddfb95304785d8f84a987ce56d675320b, 0xdd55d747928d8be3f689d48af087fe8cd3dd6251638635a94ac26ae56ba19b, 0x206917060de49761cd5ce91ce4e573beabe778149042945c1bd45239155406, 0x4a402931fcbdf80e0e02d3b9c4854df5ed224911f514e626b12f5cd38a4793, 0xdf94cdf452c2caec3f98c1b4b56557e4b632ad7090b4fb4783a68684f4551b, 0xbd01499d00bd1dd86dd7431fe6fd7888fbad9581fc1554492d753af7454629, 0x3c86e2d7f7738c7b714abb3c7c4359d728dceb2ca60ea2d0f6ee86e33021b1, 0x306a938f6d31979a9ddd18b1bf15f450b3f53204f09180771ee6a642ef85e7, 0x404586bfaaf339a1139af78486ab266b27a4df51854f35ea83edefbd486166, 0x21cf37a68b16ea851b75762e9f54d56e48dd82d8a5d88532c72bfef2dbbc24, 0x66fdd401c5507c70e21ffe4e7bdad9d52ce4aadc05e005302fdf60bf07405f, 0x37964b52e24598df7a12fbba5f1049f6d601d76c361be4dd474f3ca3083c84, 0xb93134bfd3ad311296c01b6ea301ed0bc622bb9665a0c0003de4ca74a148d3, 0x1f9cc292fcc8c747e3a3da656d39c94f63ac23be1ee21bb30a698bc2555d8a, 0x3e183da79fe77534e4e1de4bfe275d92b28898cf7b056e24200ea512a37667, 0x9d21ca37217df32171b5020e310cfc8b2d2a068215b06cc23fbc1d4d39f628, 0xd2222cecc11f862f37e607033a784f733872725633beb72b1ba20708f2703e, 0xd360289ac94d49226ff59d96f19b401dfc91e13dce799fbf737135e3819f01, 0x5eec348d9108721c274e215b0e2d53186feff69f754537e958fb32f88cd675, 0x166a91feb424372d64e698501cac539f1bd9be6aa344804493fdabf54cc034, 0x104845e03b7a8b2ce76d5f423bab95969af263117459185b4af98d41668b68, 0x7cb655d4df3eda82199eb97028834d9f74f8714d6a59902532d5f35cd23728, 0x0a623bc3c2dad0f4fd9eebc6239151318a20a5d13f00bdf64ce355a22b3378, 0x30bca9c0cb131f619e233b8fb96ef0aa1598460079d98be93a51efc8115126, 0x655e51f674036e1ff6e9b1e7666a91b2a4ed0d3ba672cba4f1b0b0ee3b02f5, 0x377cd26f9f0df59932fcce01ddf90d527860020016fcacf557d554cd4712e7, 0x483c8db6e59cfe30f72d5d2c6d5fcbb4, 0x10].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1638982119);
        assert_eq!(result.get_locktime(), 3033227117);
        assert_eq!(result.get_hash(), [0xdbc01c1a, 0x2dd780f0, 0x64eab9a2, 0x32de978d, 0x901d2682, 0x683fcc6c, 0x8181cfdd, 0x274612ee]);
        assert_eq!(result.count_ins(), 4);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x6c37b836d5a8511cde315420738210124e28a5f8ea53015bd09438622de116f0, 3560483254));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x359aa11f0f0e82811913877fcff2e985157ec64ab57059f383a7e12cbb72984);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x2c1eec68);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x8b178774c3bc984f9e0c6354eb47bcf0f03e651dee47b6630e5e991cdc1b0459, 2051482787));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x57849cde4413b1ee04f2b10099c48b80bb7338d728bfb581771ec1d75d1a11d);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xb5af4990);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0x8fb0b285419be4fa471e84c45383d63c2ce8003bec04e1c30294c59d6b826f8f, 487527774));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x5d015cb28975cd26e6fd095cd5cbdaf707acc4ce08d7da512278f61ba123d2f);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0xefed83ea);
        assert_eq!(result.get_in(3).unwrap().unbox().get_utxo(), (0xbd48616621cf37a68b16ea851b75762e9f54d56e48dd82d8a5d88532c72bfef2, 1713683675));
        assert_eq!(result.get_in(3).unwrap().unbox().get_script_hash(), 0x6c6932f92fb7584a4adaa7d0005e5d3f96583f9befdbc80046da67a71f627d1);
        assert_eq!(result.get_in(3).unwrap().unbox().get_n_sequence(), 0xcefc3299);
        assert_eq!(result.get_in(4).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 669019842410973);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x7191d9a4d788a6e794221d6abc62b4052a5a5144ea0532a5c7d0ded144bfb2d);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 2c568febd8c613afecc643d579d4f3fc2f5fd3649f3555e7ae7230cfec6426ad
        let mut serialized_byte_array = array![0x10, 0xb37bc60802855d4334240a6db820432bb220667f69dae27ff6428297f61eae, 0x9f20c863d5c090125d0ad46571446cefa971eeece693afe958b47a9ae97f47, 0xb76a1d98370880103b115e9d509fbcf785ff6e27208888df4940b1ca29eb00, 0xc1ba5b25cd8f3b911805dc908194fd40b7a0b07696d1b867f0203ace300fba, 0x564193270246f8ba2ed5da573dd50785c4def4e4628efebf5a61bf4700a042, 0x1ebc163d7fbd16bb4c8df22c56b74a9156097a55dd905da63f3c23ad67f0a8, 0x4358a46e69a93d913af27ae339a55b6647a33b4004b88f92c1d5c903c6cec0, 0xbfb28fa83aa0d4f43d863d75889e2672ef484597e5db622e6dc1a29517eee6, 0x5712988d889af2e8be2075f381b97f2a1290e3b716baf81f5bfb261a1d0262, 0x76f3272260e3fe4bf1ee77e19c603a5332a7bb0f88a61d6afd1db33ee51610, 0xa3e4215a9e5bc4ae337769a928f5f4dd969878b2537c3bb39255ecbfb18384, 0x4755bd8275e8da6f94bec21f25cd78955cf8418e566553770c0d2431ddad30, 0x23dd74550878ed22f22602dfb13dd0deb7030035b83a349cf802a01af9e653, 0x054c7907020d1ba8849c0e6a4fc88456284f553faa1551dc2975d9a1523030, 0x46ae7ffe5dd8361e5d6fa123e1c02bb62605002a9c6059b61bd54a049a81e0, 0x8a5f6846e778c565454a31732d03efa1ecd0523a2f16609b1a662f9ccb3cdc, 0xf7d3ecf3, 0x4].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 147225523);
        assert_eq!(result.get_locktime(), 4092384247);
        assert_eq!(result.get_hash(), [0xad2664ec, 0xcf3072ae, 0xe755359f, 0x64d35f2f, 0xfcf3d479, 0xd543c6ec, 0xaf13c6d8, 0xeb8f562c]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x855d4334240a6db820432bb220667f69dae27ff6428297f61eae9f20c863d5c0, 173871760));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x47bd1f07539de8593d8721735c66de070c6aed7d22e4c757c778cf7675742c8);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x20bee8f2);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x75f381b97f2a1290e3b716baf81f5bfb261a1d026276f3272260e3fe4bf1ee77, 979410145));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x2c68676e897df1e6093a04a8cd433286c137a33a0eced7f0229413dfa09080d);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0x26f222ed);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1046592534458847);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x4bd8fce59ca7120b0f2c5eda9c0d9e4e3aa3a6bba82681d6dad0624fff8dff5);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 1449938743517475);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x540c2f7e0a460b3b8f802afff1cf6ae61ffbbfda070fb744eb0506d633fc7cc);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 79f2ea6964590b25c1ef00e413fc3adde7d2723a6c862bdd299ddea950304d92
        let mut serialized_byte_array = array![0x26, 0x16333c3903e8e70839d69bf87904e54f07d96b9b52d6eac1bb5560bb3da197, 0x1190b0652275679b3645fd1e01427f7f916ab5211b831f86d6b8160d706b76, 0xc3d4e45d6f44d330df818bfee84654a281cf3c5b35a534de0e906401de8149, 0xe7788eac7fa8160160b5dac33013431e30ab3501e4015e8ed573954cbe0804, 0xb08545ba437f50ecd8a8f64f3b3a2056efa46d7582344e688a18bb7cc9c585, 0x27d2ee6b3660edcac3970c25c2e382e074a52b38636cee7a9b43b14ba4a6ba, 0x11df813951d7ab66b91ad3b02f7d8fda709b623e2ee151db200f837c9fc590, 0xba1b13b7e7c1b2902c2a9f46568e3a5de3d5b5fa6d64a622108c94b8b75815, 0xa8d49dbb884f66b28efccc713dd5d60c61036441df52567484a4242c0d7e8b, 0x57cf138ea5abd35d59e01465ff1ea546915518fc98329ba1a180b54916ea3c, 0xfc00bfd4d3fd6d839f82371b8b1fccbc6283a1ccdc63872fabb8ad29c740c1, 0xbc3a5dbe9941588c7212cf12990306fc491b613ca86beda6a5252e66b2806d, 0xaa5e147353eb42e74cba77fca4a7ac41f096182144ed368d36d952c76e5e1d, 0x0a46293146f8f38a4521abe6d25e285ec658369ec69697468f8013851c28cf, 0x1e603589aee51c78444344af5f6428a358d34d52033eed72d154ea9caf2417, 0x166bf5da7c4390ffec5c62ec244a13104e26fc273448e13e074823984e2e7e, 0x88d729a4b947efdc9fb8149b91aa16b9024aa5effda1036df7cdc6ac7759f1, 0x962016bd5ca67dbaccc276c9fdc00166577f2909e99d24842d3ac8c692a9b4, 0xce873df52a01f33fa840163aff0acaf39e24d53b055a221acf720ac6ed1195, 0x5d6f6e03ac26236828412fae4d790a8cadcdbb400e7d6e6ed53ce7c5e166a7, 0xdd56a380cf9633827f08603615a55ecb16b5bdf8fe607a4434bf53ab01fb74, 0x29fbd4ea1571fe3820ed3ef8c11ce06ae37664a646638597b9af4b297e4ed6, 0x38118cc40dcdc109d1e3d4c244814cb6f7daf164a16336b278ac54a0291a83, 0x2ea10ddf41ef2ae5a97f004a70c49ab41a5a6fb7326ed846d0dc33395e4f4b, 0x12af2017b27c8d12d38feb1c3580d0e3a65569772588768e067065ff4913f4, 0xb143c9bd6ed698223e794ed9301583baa5aec3a41bcde970e87a20959c7ba7, 0x6d4829e477f01cd0ca684794fae8f51d1b9d894f2313dc75b485d02fa9ade4, 0x64b7700da8493174bf1fb3e65a98aea1dbdd0e9ab242aea751ba8409bc7c4f, 0xe1c1361840eccba01f761108da50520706262ab0c9f1d67093af5184556407, 0xcc7883c34e66be4faa9a2b6be5691257f7b223ade73851f5e3dc961c64a055, 0x8983de59ba5553fdbf14aaa3f73b976543e4bd008c5195d0b58ef8505378cb, 0x6f62eeaf1582ef8598fd31c4df2ec8103822b2e723ecd4ec18a8bc5a29428c, 0x5da8052927508a8f1d0300118497781f0473bde3cb61732efa3d220562a392, 0x756fae330000215564bd34e0f6adb9838b789ea37c295b04c641c87c500521, 0x68a862c980d0139924d8c12c454d2207002ef254ea493fbf4a4740f173ea56, 0x0f398c893a639058166e9cf88cf9221f14cfedf06e7a34be8e33b713b11001, 0xd648f2161ae441b9060018eba9b553eee1c9580d30e23af3376fbf505fa383, 0x7774d61ce6f71f5fca360000234572178c50b755a02603be2ed5e16f6a7830, 0x8fb30adef43a0313a5a1f0f0485e7e2f8e9afd39d4, 0x15].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 960246550);
        assert_eq!(result.get_locktime(), 3560570266);
        assert_eq!(result.get_hash(), [0x924d3050, 0xa9de9d29, 0xdd2b866c, 0x3a72d2e7, 0xdd3afc13, 0xe400efc1, 0x250b5964, 0x69eaf279]);
        assert_eq!(result.count_ins(), 3);
        assert_eq!(result.count_outs(), 5);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xe8e70839d69bf87904e54f07d96b9b52d6eac1bb5560bb3da1971190b0652275, 1161206631));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x6d783c0d3656d79adf3015ab227ed5cfb9900732343432c096667509b920785);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x2f8763dc);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xabb8ad29c740c1bc3a5dbe9941588c7212cf12990306fc491b613ca86beda6a5, 2993040933));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x52267d0ce06b95157562f8c988275b7a342729e4ee45e5c5bdf1312abad13ce);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xef47b9a4);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0xdc9fb8149b91aa16b9024aa5effda1036df7cdc6ac7759f1962016bd5ca67dba, 3380003532));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x3c2ab62798d7b67494e855f7d7374370ea3e33c90b8f6ea16a8c374cfa9219a);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0xa85d8c42);
        assert_eq!(result.get_in(3).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 876927268169513);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x39f0c3d8b9a07fb58246d959c15157e7e4de3383fe6c1390b40fc04bba6d8f9);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 56824287302307);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x199e1fc7585c422d8a0bed9d86b463d0a58326f1b745351d24eb6c5264fd245);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 2008040105361880);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x40fa073ae08f58cfa683ec4c6be42a43a42b6050c766c8a25d3dd508a66364e);
        assert_eq!(result.get_out(3).unwrap().unbox().get_value(), 1892542511191794);
        assert_eq!(result.get_out(3).unwrap().unbox().get_script_hash(), 0x6cfce3d25a078db28dcb9328788eca5b1c9e37e6df35c70ab4d8740511272b1);
        assert_eq!(result.get_out(4).unwrap().unbox().get_value(), 60242807224294);
        assert_eq!(result.get_out(4).unwrap().unbox().get_script_hash(), 0x71ea36e30051f4359117e54a717a304f57f2660151731ef42c15d87c1766565);
        assert_eq!(result.get_out(5).is_none(), true);

        // Transaction ID: bc314248ccbfa7023b7fdbab9d206a507e1918ec8eb704eb3bf833d5406d1326
        let mut serialized_byte_array = array![0x2b, 0x6e5b9168035a33bd428bba1ac0db0a5e8cf0bfd14cd47cf4281d1b9f883009, 0xb2e4677d8387fa44b0cafddc01638ee474bde483cd9ade21d429eafec33884, 0x263dc9df5c34180904aa7cf3753fb38ced3de0b4d0c86e0ebe08c194ccd5bf, 0xd493a93a8f3ec8ae77f708c1e0877cbf1032004e01c136255b9a0d534eb7c3, 0xe2d76acc75306aa7af87485963a57cc3c23faba8b396ad58abb6625c3fbd91, 0xf3d8b38e1de98b03b51a262f6619d60ebe28587126cf09a936a438da7d79b5, 0x3a7f08767efc0f7249d31e297a9fa3dc7e85d2f77b9417a8c1826840c02a19, 0x3d03b23450b189eb3b5f60c80ae2cfd702bb6297f557ba5b7bd83e4bb90be0, 0xe8181bb6d8fa198fec83efa3e2517d17c02ba88fe66811b21756640de622bc, 0x50104f7d92dcdf28b28bca2da68bfd59172d0ad02ca4ff63f8c68b8e1b6a3b, 0x943b9a96e681dd650e3199cc78254bfa1d3841c68bca4c0f8edb10b7d98749, 0xcf690f2788f6ae846378091c01709c3c3b544b9fad244552e7eaaf0dbe65cf, 0x0895c3c9e6dd7640b51a4b2238593fc201b85e2c4cb66ef1a585c62ef21add, 0xc35a798e3ea63af249e64055404e65d2c95acff51c3ba40bb04b65585caac2, 0x89725bbb63f0d1340ad04b34be4215571922d34c6909667501cb716e7cca06, 0xac68fc6a32d991366a43abaeb268e3a1f941c55f357077c1f91edfaef29631, 0xb6a6a9f9fd8561876325662c638f1457a3397267721fc20dd86533409f33d2, 0x08f970c395de6de250f5af785c058fed5c0f1056b3c277b8d99a760408ac46, 0x06f8fd1801804accd780b286dcf9dc89318a81ccdfb7a351f331b9dcf4d723, 0x082b89ec00810bed4285b2177c7784333111563c68f729d6672f3af60546d3, 0xbd11d222e2cd8cedceaf17bf57222dd783bab3911d7788d4716c88c7354c3f, 0xa727e140fb8fa54f5495379079bc795d7d7f8b238187dcc6c693ebf89d2aba, 0xc841362bed16760792ccedd525ef2d09534e6a60b95801ba99db9686082a4f, 0x49a3f76d8468af09d20fd1388c50f3bdee61c03c54fb30e417b547e65bdc3a, 0xde835d1935d15bd5646c7c9b8aa9fbe60520463d447815af711fe2e0be4a5c, 0x41b685a7e6bb01a4648924138aa0ae0866696d764a8ce52c44b4b38fa1409f, 0x3c8a95efbfa9d162091625a70877ec4f21fc368b72379f7ca707791e3e249a, 0x7b3319a867f61381dc9fb1ecaa761f2e3badbd637d15c03c36f4b08d64f368, 0x13b9349c82948a5a3971fbc3f14ff2fd3e01b3f9cc5632630a99137dc8fc7b, 0x6dc56e60f96a5440123503789e96fb1edad75330c04d24ede9250e82aa394c, 0x3add73e868d7d65161ec3a8adec49e50cb55ba0de15d030ed6e33afc000e3f, 0xa56333834994842712b399d212dbc844ed07accfd1ef7754492d3585dc2053, 0xfb3504ca6a6f6669a7045acaec6224bec28a2fb20981933c5477128e39f8f5, 0xb54b868b6302988150a76946a6c8fb47e988c8aae74daf0a3a6cc83e21a185, 0xdc67f775d9ede51021045f6145e8a7ed12790d442794e26fd6c624ccbce22b, 0xe94e547d35ce4c463637b50b54de64cff52bbb08b75c5b0b6bbd39befc7251, 0x5e90f5bf93096460635f9b37bd6246b508cef1de20369c0aef59f397572790, 0x37cab08ec97901798b2ce4c69ac95a55454fa140cf2ef41842cee88f67e370, 0xd330c7eb3154a1e6730b93929adcccedcc394f84f82646796584eefe650903, 0xe1a0ad8c624c06001e6f2a6d09bd0b3cdb790bddd44556302b382c5aa2e184, 0xd41e45ebcce0df9b855e13603a3a0300218bb2f190f62cb02103afe8730533, 0x431310631b85b58fa17b0fe2d505b63aab6611c01939ea965403003904f23b, 0x54ccba1cc54cc9c82c5bd5b1331c898d8f5872f21747f3ec633d1e6c4e400e, 0xfc2b535b26b9379ef9b318d427324397959392e21b4af1676c6fb8, 0x1b].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1754356590);
        assert_eq!(result.get_locktime(), 3094309991);
        assert_eq!(result.get_hash(), [0x26136d40, 0xd533f83b, 0xeb04b78e, 0xec18197e, 0x506a209d, 0xabdb7f3b, 0x02a7bfcc, 0x484231bc]);
        assert_eq!(result.count_ins(), 3);
        assert_eq!(result.count_outs(), 3);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x5a33bd428bba1ac0db0a5e8cf0bfd14cd47cf4281d1b9f883009b2e4677d8387, 3400549626));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x2ca032a523b360d58f48ddf239cb348c3954d692ee779d0f5782d8f7f42f1ef);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x403365d8);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x9f33d208f970c395de6de250f5af785c058fed5c0f1056b3c277b8d99a760408, 4161160876));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0xebf13c8aaf4ec096ee36e5d706145b12911e2b69b76a2e8e9a1dacc7a0c000);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0x9fdc8113);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0xb1ecaa761f2e3badbd637d15c03c36f4b08d64f36813b9349c82948a5a3971fb, 4065325507));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0xc2c6ffbb3d9a69a0318bffe30f954c72ea402d6c309adc2e361ef1ca465713);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0x965feee);
        assert_eq!(result.get_in(3).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1772836010959073);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x48ec67195c8a24d07f4c3a71b0d1046082e53b5f64474ee076e3b8878c395e8);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 908447324528261);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x6c027f069e30cac3172ca8c5b26c11bc87bcfb14e4f1abfadbda88d1a2b5fcd);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 937432081570240);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x477281a9356059624bb2950257f9eddaead72216b275d54b85641c1ee975906);
        assert_eq!(result.get_out(3).is_none(), true);

        // Transaction ID: 5b5100eeb82a6e90811a25b30e3c637d48c2ba8941b05b1c8fa2e4d2f21c84f7
        let mut serialized_byte_array = array![0xc, 0x2f7d50040280ec7bbcc920109467f126f3889bad3b20310a0f2bc4778cd3a5, 0xd4332c1abe0061d197f9fd0001492584b2608457aed82a8b03b93b2f2dba4a, 0xa2962d93c55622983e9afdee658cff23a8a76baa0b1ba34f399ad5b82afa4b, 0x52e7fd3ff99c67089dea650a811282967042bb00f4756342e1d6d2c9295b7a, 0xc7aa754ae0a79c9c134911175a3e74ae702f86354cee28fcb0f10b6dd53105, 0x9ce149b52b3cc250164026c0bb564f8f254f5219181402060b5e8b7ff43adf, 0xe7b1c379618200dff63ccf6484beea3d794a47e2ef1831a2da480fba0df73c, 0x5012e71687f009fd341c3f42ed01ee91fc66845a3af6aae904fd638fe1fa0b, 0xeefa0ce43adc8fd03206db442aae94bbb83457234e4e7b850d041375c2829d, 0x22ad55fe765322661a7d6846a556d38d3b643a8dc099dfca74501323c53858, 0x1bd7e9511663b00def806348e13dbc0a9e37a03e8c81643f0c4486a3ed370b, 0xe99835146b4afd447292d209c5103301261978351fc603000d672157290f3f, 0x842f240e54e48d83b1f355, 0xb].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 72383791);
        assert_eq!(result.get_locktime(), 1442034051);
        assert_eq!(result.get_hash(), [0xf7841cf2, 0xd2e4a28f, 0x1c5bb041, 0x89bac248, 0x7d633c0e, 0xb3251a81, 0x906e2ab8, 0xee00515b]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x80ec7bbcc920109467f126f3889bad3b20310a0f2bc4778cd3a5d4332c1abe00, 4187476321));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x2527c7a9f32d4ea4b62aab725085085e05d003fcdf68536df3793557796ed49);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x74cadf99);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x501323c538581bd7e9511663b00def806348e13dbc0a9e37a03e8c81643f0c44, 938320774));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x18d051cc5e6c4ae0924481ccd023a38ed0b85467ef22c17908040eb3e1118c2);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0x3310c509);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1062262273480998);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x310b18ff8a6577d59079e87752ba78e3862bd9931ac782ed729ed1e82d450a1);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: a634b6524deffcbb660cc3a4eaddc2f05988a2469fd5eed10e8c6cb6d1543876
        let mut serialized_byte_array = array![0x7, 0xa5f3c24b023626d9d3830664a8a525aec742943bc583f1efc996364c3b27e7, 0xf08f9c53a2ae826991121df3ddf9d826455a25033cfebc76fc932cfdfbd7bb, 0x19fb4f0f952afe357ad409fbbc086df59162dd6324e98d0f205459f3e48712, 0xb73d4f551a2e31fc01656c3580e4f2b015cb0c0f6042f6db57310c4088314f, 0xad8b0213039edf9762804c010022e4a36fc05d00ff083523e639161186c109, 0x5de40107a34089e68891d05fefedac222b079e497248ed00001a17939642f2, 0x236420828a7726dd331b474c182dd792cd0488db007e9e50f23c0900001015, 0x1a38d2fac1d1f4b62d8af224fd32630f2acfb3, 0x13].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1271067557);
        assert_eq!(result.get_locktime(), 3016698383);
        assert_eq!(result.get_hash(), [0x763854d1, 0xb66c8c0e, 0xd1eed59f, 0x46a28859, 0xf0c2ddea, 0xa4c30c66, 0xbbfcef4d, 0x52b634a6]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 3);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x3626d9d3830664a8a525aec742943bc583f1efc996364c3b27e7f08f9c53a2ae, 311519618));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x4f404505057dd425358cf3058f54d1909fbdb6d186617154d346756ff4628c1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xbcfb09d4);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x086df59162dd6324e98d0f205459f3e48712b73d4f551a2e31fc01656c3580e4, 3407196402));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x3fed1e5d11427f2e78f86a20b1155d5b7d848d18c95a8c368aaddb22c8c755e);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0x13028bad);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 365589270355870);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x990450071396ce1be701198de5377414512608c794960de76c2deb7794e484);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 260895410855431);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x5f1f05b9c07500a8bb3d9b97661d55543f0ec9aa41409382e6c4fd998d1982e);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 10157368057470);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x51957c3e07dcb19fea9413e8ba24fb7a397d276935811b9749d7651472976ac);
        assert_eq!(result.get_out(3).is_none(), true);

        // Transaction ID: d11ae7c688303d7117db1c6a23ae234378f0442e4c3ff93089d7c744ba3f256c
        let mut serialized_byte_array = array![0x2d, 0x2d1c456803d3cad7f46b403276dfae73348dfe1b7a30063e8829850b6f0583, 0x737ae8c127e117dd58dafd11010de6f5ff1bfcabab83381dfe00fb8b131440, 0xd6d63ea25cd4648fe457a37d739fe7068f5758f6374696c6915b1c23773286, 0x76b96bc0d07d496d866edd91fb942e1b68b53d85f651abfeb9f4cb2eff8d7e, 0x3502887cf643a77a24c85841dd2619d7f097aea97ad68c6d342c613049d536, 0xbd96a66e21dab82ac2055005958ca4b36f4858e9024304e3889b409c5617ef, 0x2d385dcf8eed6fc4f3e2994113904f9c0974775df013cbc471848ba2197f1f, 0x329ed0ce60612d8a02de17ce14836616ec1fb9f76c7956c11e6964f00af436, 0x8bb3afefe34507245d31d51da7b1d57d48ba4b30789176e16328dcd639192b, 0x20b6a1dbf0e36f676ee82a7524a3ea9f63b1ab3c099b2117c90167e9aeee90, 0xaf6d1c5166db9db8573a878e0a9f33c050c36711ea7ebcd169face92a21357, 0x689feb04d3bed5815a491a9f431e6d2efdb301101a42a007ec83476fab6b15, 0xb73c9e1a1254bb280ecb4ad923cd2f26aa0e1d0ed1901bdd9900e6af20d1c8, 0x11583b4946dbda196a700dc80222f869b7ab53687f592651ee357c899b2448, 0x5744e4139e63bae4e3fedcbc40435eff632d601128450b98c3f250bb3adb44, 0xe4502cb1be23dd5618650f0b7934116b7d3354bf796b4a4327e6bca6907dba, 0x1714b25782e72c566fd5eb7b1ed71e538a8afae7d0de9c4895ed926aa5dff6, 0x1a03cbb7854a62d7697a1e46580cf4d5ab4d893e9aeb5678234f85080f88be, 0xcb8ed2fe3183bd8f910d5d5d73a7c95120afae0bd6f567d5a8c26dce6ed012, 0x8c88cb8e67108e154d61ce2fb9c5eb0f8985e5450e15828d74481d65b7ed93, 0x91a86657374072dd6f8e87d5f57515649727d0d1ff563a566b5cb4801c4e0c, 0x43a669b399ed7ed5a1a29e8377d2d0e846fd9bc88744a33b3c612a06e12420, 0xf80f6a38352ba21d75cdc0e886f8a837020011ebb90b4545651048ef9f06c9, 0x23ee4c2e2c56d52f7911ef71d68c321636af9b714872bbca7363c8a406f5ea, 0xdef9e9159a92acef9e94d4f6da8e56a2e72f8303e093c758bcf878b7a14d95, 0xd2da19ead8f4b345e312fbc6f8addba92743483b12ecdcaf4f9b5d121d79b3, 0x1c538dbd51c7724e59e42e6bc8f5cd4053cab8096ec379f65dc1c7d915fdb2, 0x01b4e196dcc8a1344b9fb555ce6dd978b7992ba48ce7b24b69a2b651843f11, 0xb2e0388995613c837496366ba35df083849dca5984786a659aee1824c8b871, 0x16f5131359aeb554b443e74b0c443b2eae338e38447db8dd07c428afcb8381, 0x52b54489e8b5af73d6f754640a3bc6d3905d85bd5b886c62e2c1d5f4219ab1, 0x7eef45c29d62fb748d61a5a055a6272f73011377453923d0d157718ae3f0ac, 0xc140069ece8512b616dc1e48fcc5a05353a00a4a3c714c55ac1c85cb790758, 0xde5ae81834e62f015ca87422a3615ca12342f6a8ece8820a01b69db139723f, 0x355e8d0a116ad3d0e1e88b95d73ee7c4d2e737757f28792d12f0a1f0b4116b, 0x927013258257aafe4d98bc187b036c0beb123564508a24a4a91fd148ef3a86, 0xd40f7978b08f2abdeb57d11dfc6e6517bc10ef4889d7474dc05aeaecac2c07, 0x8100a7bb54e9ecb19f986f99026793f93316647c12385bc0561c9018f21678, 0x1237d4650df039b912f1415b5dc683e8a93e668351d8a79cbbd186db425972, 0xeaa44a59bba39b4d052df27985e02457a9cc4081af866d8832ce4fdea9241d, 0xd8a96b23194525bdd78601fc5230088179297465e9e2d52dc11afa9fa31912, 0x0c3124ea320494606e15a30f0500078e73a8c12babf192fda74c2f6f050019, 0x63c434d56423c00c399b7c83363559e5208c7f71c9b2219116de2887a2c4d8, 0x0000385e639307dbd5cbfb8bf29b0dd504428ea632874829bb61c79f9b9e45, 0x3b04fefb0375bf9c638ad2f33314d330a1a3c7de2117b4d5dd706bb253ec03, 0x500dc803000b83d9bdc699cf302a84b1d17a3938fc, 0x15].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1749359661);
        assert_eq!(result.get_locktime(), 4231543162);
        assert_eq!(result.get_hash(), [0x6c253fba, 0x44c7d789, 0x30f93f4c, 0x2e44f078, 0x4323ae23, 0x6a1cdb17, 0x713d3088, 0xc6e71ad1]);
        assert_eq!(result.count_ins(), 3);
        assert_eq!(result.count_outs(), 4);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xd3cad7f46b403276dfae73348dfe1b7a30063e8829850b6f0583737ae8c127e1, 3663256855));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x4f68b8461f4c21bb202ebc137df3db1316d8d5b0ba794f2774a43b105f581f2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x873a57b8);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x8e0a9f33c050c36711ea7ebcd169face92a21357689feb04d3bed5815a491a9f, 778903107));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x47524898d15fa6b3d30c8891c31e6b986ca305181c9a917aa984b159bbf4701);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xafdcec12);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0x4f9b5d121d79b31c538dbd51c7724e59e42e6bc8f5cd4053cab8096ec379f65d, 366593985));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x3bd248f3f25ab0a48f465176cd2479fd48978247a3413d7624d76146f51da6);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0x32ea2431);
        assert_eq!(result.get_in(3).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1424567997194388);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x7020484c3278aaed596447174eb49d0d574c3f00a8a4aa29a1ddc3aeb20168a);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 1529623823777170);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x54dbd4b89e264121006fcf7956d77fc2444b3adbcfcf9da9562bee2cdba03dd);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 238339051956446);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x4264d6263f0771ddff5358dc4e784aa416b73925381e6289f5a18bb5d9289ca);
        assert_eq!(result.get_out(3).unwrap().unbox().get_value(), 1064384432696403);
        assert_eq!(result.get_out(3).unwrap().unbox().get_script_hash(), 0x7c9b80e962ab2abeefe982f16197e4eb149c5b3aa301f699b74acd8300fe15c);
        assert_eq!(result.get_out(4).is_none(), true);

        // Transaction ID: 727f735c4b61e988679f499136d2567903455349a950ad7df3f7e26d173945d1
        let mut serialized_byte_array = array![0x14, 0x9d027d2902c32e161ae311335b2aebdb8fc52700b3588873c0fd05ca495950, 0x0d85ba71dd2d79e21327fdd70153dbb2f37681bbf77d4135ebcbd88d1f255f, 0xc9c55b05560768eb7f5939008d86ea978b85b9c62f3e9415212be7e2f8dd02, 0x553249dd229e0615b069f7233ca09a828043874640dde76d78322fd5480510, 0x3a80ab7470e7f5fa359a933be8922abace01536e03fdd41ccfe0016938c72c, 0x6ba45a02a4864d745e24e3d180af6574a9256881fd6fb2fc324d42783aba71, 0xb7e965cf6a28d3376dda1f1978d6c57621b7999a49db9d95fb7cbcd4b51a39, 0xb6fd3ba76f2d7335c3fcbb8ba3a55a27655422493081c25907d1f1133ffaf2, 0x48de2c336656902b766dd3dbc3fd34b0abfe564aec356f77c9cd4bb241932c, 0x0d72e6daa7e0279ba0e9880f7865a091913d6db20a17b8bb4a273462ffea8c, 0xe9e0215cf116b35e95c38d793785ba2e89fed17d726934470fe304ca5b0d38, 0x4c7c02ef8f136771d45aea416dea7a93dc8c1f441ce85c7e3f132cebeb2703, 0xfb42fa5ce40468d27a52a365ad0eb233da5d57a57ca350dc0ac23cf623aef9, 0xebafb1e4c61fa6eb1f7983d7614fefa2a6468cea32b502676b88e8637a1a4c, 0x28bda15ed90e5454617eee574b125fd793c70ac74c8bf234700fe6b566563b, 0x26326bf4540b0d7afd7b053f0b749fc60defb649a7c1deb17fb8a6e3abe97e, 0x783393f3259f653645a4beac6d657b95040a3f503932c6c7a3a26c9cea63ae, 0xa90cc813f9484639ee11d6d708c848a0f607557160081376a6feba7e2c5a8c, 0x699dbc159ae5d3af1f5dd1faac843164edf23068328d22ab4d0e00358994b2, 0x7968720182a25da292c855b097374d0155bcf4908cbc050008c29f3b22f2e0, 0x60cac311114e, 0x6].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 696058525);
        assert_eq!(result.get_locktime(), 1309741507);
        assert_eq!(result.get_hash(), [0xd1453917, 0x6de2f7f3, 0x7dad50a9, 0x49534503, 0x7956d236, 0x91499f67, 0x88e9614b, 0x5c737f72]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xc32e161ae311335b2aebdb8fc52700b3588873c0fd05ca4959500d85ba71dd2d, 655614585));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x7aaf30dd6a2865484c07c7aa37e3ad3a94b7ebfc35ab9d2f15217eda81689ba);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xc6323950);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xc7a3a26c9cea63aea90cc813f9484639ee11d6d708c848a0f607557160081376, 2126184102));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x5470925aae21072d08b132b471c928aa8dc235565b4224f6a25b87c50b972f8);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0x4d3797b0);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1614686796954709);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x1b32a590bbf1c3c99113021b90ad19856d050262daec5abed4c09e15bb6f9bd);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 67f7a9caa832d466dd869cfeb1306c823964fdfde9f439fd70762fb1fce83f02
        let mut serialized_byte_array = array![0x27, 0x6a53c85d05eff6517e0ef1ca0eba46ad9959f3d3ec40ea327b3b5886f5cf2e, 0x352460ecd3deceae36369f7edf68d22e4db6cf2046cc8ce37ba4cfebea2f3f, 0xccd3736a412e4c0b47d6fad69ce575949ba9a2533270cd727b5ec7792d1b33, 0xe78a5fff34a5e993a5fc5b4ed8d19a2545af3c8dad646be5dac9a3600ba203, 0x5549d0c84606b7db0dbc4630339923729eef88f74a2c6f9312232abdf492ac, 0xea1f974c84f681d43ab68f9b9b29b41acbfa1a52a879e37415eeba835d2471, 0xce3afc6e0e8f378d1049c92025e9ccbcb1c00210dbcc2b1db12dace79db31f, 0x4ceb1231850f56dab8539d0008c5494a81d5f542a91def99fd5501dc06b4fb, 0x3d780a5a4b993b87fa60e9cb33c3bc25537d28826d57f239a03265de439522, 0xe50cde73f83d9c4b951956e91115d63615d7795d921356d1cd27af1d97785e, 0xf0184e15b90f748710fcfb39c780d31c840d305175d6fb3bbb23d2bb06cc86, 0xcdfea3a252505a323bc6913f26f1822fd0121bda51e9f97320ad3c08c36c29, 0xa894d7ca37e0d729aca56daa97264ee45a2b356aa5919a68e0221e6c68f14f, 0x41143d9fcfb0db21c537bdb8c485d6ec85a1b4d7c17ce6bae1011de1d6fbe3, 0x82a61d2f7411cc5ef118c1383e04ee278b453dc0eacbab6b8ee08358e9301c, 0x9c1843fec3aa90f181efb8337992965d7c160d8b1542a3d24d1300df741e15, 0x82aa53c0882aeaa021d9e53d6a79c8683f1466a62a373d321cefd9885d1e3e, 0x2c6df4395560e869d22be34e2d1ee6042341c8b2f6030320e4c6c92025561a, 0x4e12510e1ed7c9aeb3b06b862206076121b79b01304bd799e04df6b8475f0a, 0x0893dba16c0b3cacfca883029b70cfcfeda5f6ea7dd23a9131cee740e9bca3, 0xeb38eda03c21c33e3870ed3cd679f2a9a6f2f33d494a03e5d4ff2e73894b8e, 0xbb8a2d105cc7623efb309deba6b96bd8d2cc0588cec5f9fa33b74f0555b656, 0x02db6f91b3cc6143015c8170694f83c75c31d923688b975f07e758fa4a176d, 0x971abf70acfb0f9119c7f1b463d289cb755f60441b31dd83c2b3d2f3b3c14a, 0xe6cf5063a82b329559454e1ec4097ee1628773b33897b05a75166ebb8e2095, 0x2b732f000f32336dc0887a0562fcfd61016feeade41e5f95a825fd85884e01, 0x6da64b6aa5a73c6f198c95cf4ffe914b65155da3255c8b0051d4884b727840, 0xee2c59c71f2144a96795462020e2a4feaaa05d0966a111fe314484d1fe03a5, 0x92f1336d1ae1c03a0d50c8688327226cec136b62b72013eba46379a2db0bcf, 0xeb07c7319dbb123aa6571bcfba958763a426d878a0f08f9f92f98cc8b5f20a, 0x7d7883f6515ce573059ecd85dbe738ca3f8d30f0c548ba0571de3a77650617, 0x37858bae067cb61089af081c5d630556b2a4d3bb5b0039b1952d344d1d458c, 0x652b7ccb39bfbff240f274f37a530f6264064c491371a90df24bdd92abe4a6, 0xc65f0867adefe91e27347324104946eb282099511b52be8c321b355b40a8ce, 0xadc717e43cc0f4c834da6434e006ab376e0da5f7ef223c7976fdeab86414e7, 0x7cbf039e58453ce0c802b423a3395ed3cca1eb9724397c636f3da641a897af, 0xf08f1e98c73f37ad81fe91c70d5e6218531ff8840a008f7a35c9864e88cbec, 0x0881023cfb7e878f06030034e9eb05c71e4a1d97cc7609eed4f07e46bf044e, 0x8e3dd76cf5db2d7071ef98af627ebf96cb1bbd33d2d6d430ccff844cc6bdac, 0x91ad3444b9d7bbe1010001e0e0035315, 0x10].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1573409642);
        assert_eq!(result.get_locktime(), 357762016);
        assert_eq!(result.get_hash(), [0x023fe8fc, 0xb12f7670, 0xfd39f4e9, 0xfdfd6439, 0x826c30b1, 0xfe9c86dd, 0x66d432a8, 0xcaa9f767]);
        assert_eq!(result.count_ins(), 5);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xeff6517e0ef1ca0eba46ad9959f3d3ec40ea327b3b5886f5cf2e352460ecd3de, 909553358));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x4459bca9db175f5c37f201604be2fa848619f4caa2be481a58c041b4f171a1c);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x2c0b1bc);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x10dbcc2b1db12dace79db31f4ceb1231850f56dab8539d0008c5494a81d5f542, 2582584745));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x4541e74c7528bd2ae2e7aeceff3a4e72f3aef6ac86c614119e68ee4b1d72499);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xa5f47b8);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0x0893dba16c0b3cacfca883029b70cfcfeda5f6ea7dd23a9131cee740e9bca3eb, 1017179448));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x47b3f281d247b04d8845ff7a80fb594253627f06b54c762892fd56c11722262);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0xeb9d30fb);
        assert_eq!(result.get_in(3).unwrap().unbox().get_utxo(), (0xa6b96bd8d2cc0588cec5f9fa33b74f0555b65602db6f91b3cc6143015c817069, 1556579151));
        assert_eq!(result.get_in(3).unwrap().unbox().get_script_hash(), 0x34abbe4dfb37010d0cd1e8e087a4021715eb9b80354cdb8e60c4bdcc02479ef);
        assert_eq!(result.get_in(3).unwrap().unbox().get_n_sequence(), 0x5995322b);
        assert_eq!(result.get_in(4).unwrap().unbox().get_utxo(), (0x454e1ec4097ee1628773b33897b05a75166ebb8e20952b732f000f32336dc088, 4234282362));
        assert_eq!(result.get_in(4).unwrap().unbox().get_script_hash(), 0x288556888b4dbbc303d6215c673d363b78dd5d5448d3a63e28cd122dfa16d75);
        assert_eq!(result.get_in(4).unwrap().unbox().get_n_sequence(), 0x8108eccb);
        assert_eq!(result.get_in(5).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 851638453467964);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x42303c0dc01f2187ec4c36d35811accf317fe5e1eadc2e3f7cb8d33d6fb1c24);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 529671871087668);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x780dde3f276357756213827f61e01feb5dd0e085886a9f836e2fe1fc7ea0cf3);
        assert_eq!(result.get_out(2).is_none(), true);
    }

    //Test parsing transactions with witness data, should fail
    #[test]
    #[should_panic(expected: 'bitcointx: witness not stripped')]
    fn test_invalid_witness_not_stripped() {
        // Transaction ID: ce3a49a4bd21f09fd8bf04399434e0bc4b311f254ce2cdc1ae4a41cd80e05566
        let mut serialized_byte_array = array![0x13, 0x0100000000010323dbaf4cad232fca1bfdb75e34443314c4462f9bd3968e17, 0x119e452b2432eae3010000001716001496de4122da32c2d428e70b44f8d07f, 0x2b26334b6ff0ffffff23013203bac75f77e1879673eb099a6c071f5a17d016, 0xf806df6c88f2a63a76b2000000001716001496de4122da32c2d428e70b44f8, 0xd07f2b26334b6ff0ffffff25e42ea855e2493db548a762fb5c24a18abd8cc6, 0x0f9dfad4cddaf712a2d1b44f010000001716001496de4122da32c2d428e70b, 0x44f8d07f2b26334b6ff0ffffff02137c6f01000000001976a9147d07fc05b8, 0xda6db8e06b97922daa76d9026b195288ac0e3707000000000017a914424f29, 0xa8a84fa867814ff9ded43379c9dc9a6814870247304402202ab100ce04848e, 0x293de2cc2cac99554fcf2656b8461be64ab96e5922d8c66b060220793db90e, 0x557423c92748a3fc1670891ca06d0907a3cf7d8b3790f05176a7f1e1012102, 0x550e8b9eaa471d31c4a544a6aad1d8a3b6e4c4b127ddfdd629e85a888d3f8d, 0xd602473044022004ef97f07043a7b5b206966a1c68215a770e95da41fa431d, 0xf5e2a0d6229aad5602200e07703c9b383e00963b6ed9fee4bb9b302df8cb8c, 0x1a26d0f5e51d2f04ff4b1a012102550e8b9eaa471d31c4a544a6aad1d8a3b6, 0xe4c4b127ddfdd629e85a888d3f8dd60247304402207abb8b67ff69f355e5f2, 0x93ef6ec984c5293c91c689352c0d275c1624852fd19002206b0757f59850c9, 0x0954e95ac6fc970b6b95bafd2244633c602b89ec703aabd55d012102550e8b, 0x9eaa471d31c4a544a6aad1d8a3b6e4c4b127ddfdd629e85a888d3f8dd60000, 0x0000, 0x2].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        BitcoinTransactionImpl::from_byte_array(@byte_array);
    }

    //Try to append more data to the end of the transaction, should fail
    #[test]
    #[should_panic(expected: 'bitcointx: more data')]
    fn test_invalid_data_extended() {
        // Transaction ID: 55ea46d824d26c9716eb6640e16136c940fe008a4a93282773d748433b4c8c46
        let mut serialized_byte_array = array![0x20, 0x06e8cb16035adee22388896511115133cb153f92fe591fcc0fdd1d385f80fc, 0x1db16d2b0165240c8cb39fc9ecf3161f22758d7071e2567cd5e8a11597c648, 0x44961d34f94184ccab9be75f9728d1524c7b15170fabad61a72142c94a727c, 0x732360809297affeb9ca50c98bd1a0359f8f83eb5949fd952d5e174ba3e2aa, 0x58216c3fb82cd95925d4d13e3e965c7d732a4fe144971163ac11a9a6d73040, 0xedf10f6c99d4e68024b73cb25d7525b1ea7672cbd16e5ef08a16f6945e56ef, 0xaddef905a8e4829a6e5ae1d02b802b380aeb23d8822cf13f97ce151fd2abb5, 0xaa9f5904161b3f30546c63726f4bc772f071a42c63b8ef5dfd130116951713, 0xb74f539e30f6e40a2b0302fce45f34d64b02569b0755b97d38f7d44a707b22, 0x1d1f14a4e7c4417cee4e2de64f350f730cc5484f4aea5d024fd373a81cb000, 0xc1ea2c4e6c29ce89df89c7a4c690bfbb23ad03bf020c1f4f03595aaf10babd, 0x47b61a4add58278e08a4a8bdd9d37a54d14bda833d81aa2cf71fcac6bfaf41, 0x8821a949c7c43b822824a3fb319392b9c511cf55e2bef62d2a6397b17b1a15, 0x118c3d831ead5c69208941b9764427cebb3d28716cdeeff46e2b375730e1a3, 0x04f18b3f8c72b060bfe848286515994c1a7f6f5bf4415968823d5e12c4b39c, 0x253f78f25024178bef6b2d1201b6e792660e8a3b6a4b10ba4a090a708b8df9, 0xc40b2f3468389a0c96ed701ba3da14c030d02dcd44616f8509cdd01bb7fc0c, 0xd8cfb65b5316b65a43a55800fa41bedfddac65a83355391c4eb288e769b5b1, 0xedfd3101e191e95a1f3bf31450776c3bd0946d63320c5e6b8e35032b96e71b, 0x07ca1eab788d4a2ceff4030b4bd084c1e5f86bde0531412f16d6489d00f70f, 0xf498f59c23f22dc3093d1c56db877f544ae3f36ec00cfbb76892580a4daa29, 0x2fbf4c9ce59c375305771241de22bcae09d9a33851836236feb25b8b054a09, 0x6ee3356a2317e62f5a1153a33e112c03d44bd5162923e783be6d646b59de7e, 0x44787326b61abc22c39fbb4cf7a3d81c483c0e0ed95bc81398d2626546ef9b, 0x1025d84b221f488471a1e9e57909fd9189733bdff38ad62575ef9275b2586e, 0xe5c2b5c76c42abbed1df5983df4d65315778433a42a4f09c5bfab41aa234c2, 0xc0e2a124731e6197c54a6e84cbbb8071a7102ebb23ed3bc735771d9147ddfe, 0x789edb9a9e971921fa2762f85a8a282d6d282fae5c98a417077176ca1f762e, 0x3d0bf3036f27354127a6060018da26ff94e6d5bfcd7d9e4e9b824d1ea8d206, 0xe593034d2953801a4f40c87e04002a6f9e40cd14f09a47851fa458e53dd070, 0x8b248e10137351c20edc01e0b2aee3c18f23cb8699061d045b5bb0038bff27, 0x8906000c8515bde0b18430d2b6e2ae833cf485fa8f695b7ae86bfcd8e17529, 0x0614199254df1646751a9ddbbb3e6a2963c3ace271857f3624b57cc8c482, 0x1e].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        BitcoinTransactionImpl::from_byte_array(@byte_array);
    }

    //Try to submit transaction with length of 64 bytes, should fail
    #[test]
    #[should_panic(expected: 'bitcointx: length 64')]
    fn test_invalid_tx_length_64() {
        let mut serialized_byte_array = array![0x2, 0x0100000000010323dbaf4cad232fca1bfdb75e34443314c4462f9bd3968e17, 0x119e452b2432eae3010000001716001496de4122da32c2d428e70b44f8d07f, 0xa1bc, 2].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        BitcoinTransactionImpl::from_byte_array(@byte_array);
    }

}