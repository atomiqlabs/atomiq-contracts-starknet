use crate::byte_array::{ByteArrayReader, ByteArrayReaderTrait};
use crate::compact_size::{ByteArrayCompactSizeReader, ByteArrayCompactSizeReaderTrait};

//Struct representing the position of the output in the data
#[derive(Drop)]
pub struct BitcoinTxOutput {
    pub data: @ByteArray,
    pub value_offset: usize,
    pub script_offset: usize,
    pub script_length: usize
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

        // Transaction ID: 2fe39ba079784c05d9d30f9f0d82e47e20e83522cad48d261255862f9bfc1292
        let mut serialized_byte_array = array![0x1f, 0x0100000005b33d69c90c094ce2840fb3a50b1158bd613d202f348a7de10164, 0x09ffbfe89daf010000008a4730440220102c21971b3ae4929edd063f400ef6, 0x6473181882ab2a0b0a4b2cfd1bfc90327d02202abe0d8c1cfc090aa08f13a4, 0x9189b06e8bc38f927befdd4cd7418aed713f8f3301410431994ede3b50a28d, 0x1aaeb3be3ab1187d97ec458bf8323b6b52a3a40d674b100061d1b9f0ebd636, 0xd104cc1f57ab575e5e9ecbf8f3094276eaf72d6206db871ae5fffffffff676, 0x02b4e12c8c91dcf8159854078e2c5b960542fbfe1dee2e80afe5a2197ecd01, 0x0000008c493046022100abb287a3c3857647fc58ba7d92c77ad0e581d38cc1, 0x366481afaa9575fd4d555b022100a33dbc74b3502d6f4e09205a8193420154, 0xe795aa8f8cd939b3da489e1a6dfd9f014104bacea8a906c99d2e2f77efa532, 0x118af940e9f4ee36ede470d9486552dd22a88728003f93ddbe0ead4c290bd1, 0x06b44c12a335df01f8f5088eb1995a39faeb0f47ffffffff6cb67dcd7f366c, 0x557581ebeba7de37383c24927b9dabb5fd54f07713edad487c000000008c49, 0x3046022100a1f343defcd2c7c72e27104d75a8baad4a48a38644926dc908bc, 0x05749b091404022100faf0db711cc764abdffc3b68ce89923366db83a4d7e8, 0x8f08618cf891256ca46d0141049849c3142ae700a6b69e87c1e5c68400dff1, 0xe57f3bbbc44c2f8422a38250d355dd8d88761f8d1b04a43239d483816705a9, 0xe1669379621ac4971c842db9c102cbffffffffa5ef44394be4cf29471d6278, 0xa4b870401ad6fb8135dde115e52c558c02fe3ecf000000008c493046022100, 0xe7103257ff6e2b0eec5a47085e0dd3a78714a48350c0628d42f8b0ba653959, 0x1d022100df6f70d5b161dbecead133defa0c022448484fde2a4bd214544a53, 0x489bd8963701410429653d331654d2f74cb805d9b0e1d9cc77d2b38a10c3f2, 0x1c3cf00b8f7c4236db5838764935423b1f0de2117764bf2217cf3a17779f7f, 0xbcf378341b76248119a6ffffffff510ea1fc74f28a47c1472fb5a4214f187c, 0x7a2139600c9d9c7d0dd2a6b91089a8000000008b48304502204ca1b9059d06, 0x0ca9c53ffdce766680a9243fd33f7b4a35b1a313cd44c3bd4a58022100b398, 0xdee02012183d805dd871a2b02856d84bcd42b6675b03ddeb1c3e75f5f37f01, 0x41044178c5b3c05b83c35339e70253ea3dcc14db5c24ed69e108df98f28f31, 0x9f6dccb056218b78d5dae1a37d6a9a0fbfe7a0531c8ea085422641c47b6b63, 0x29617bacffffffff02e0b2e914000000001976a9146e787869c1481e64533d, 0xe1d626921a91de07c01e88acffc60f00000000001976a914acf5b537234b0a, 0xa1539ea0850da05ba2153f479088ac00000000, 0x13].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x9212fc9b, 0x2f865512, 0x268dd4ca, 0x2235e820, 0x7ee4820d, 0x9f0fd3d9, 0x54c7879, 0xa09be32f]);
        assert_eq!(result.count_ins(), 5);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xb33d69c90c094ce2840fb3a50b1158bd613d202f348a7de1016409ffbfe89daf, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x7415309b9db3a9768000ca4c2587b9fe7d8dde8f3b8d5dbe87844a37e34d9a9);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xf67602b4e12c8c91dcf8159854078e2c5b960542fbfe1dee2e80afe5a2197ecd, 1));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x7790685f2c0a7155c860f95dee510dbb78cca05e0b067b4c7a6a379aa5f1dc8);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0x6cb67dcd7f366c557581ebeba7de37383c24927b9dabb5fd54f07713edad487c, 0));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x326b0448bc143d12ec0f8c02cb3137bbc354a59069621bd024c70f39f134a67);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(3).unwrap().unbox().get_utxo(), (0xa5ef44394be4cf29471d6278a4b870401ad6fb8135dde115e52c558c02fe3ecf, 0));
        assert_eq!(result.get_in(3).unwrap().unbox().get_script_hash(), 0x41ba4fbd8c7a05d6b711c6d6f093dc20b412a04792c22ce961b87c352744c39);
        assert_eq!(result.get_in(3).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(4).unwrap().unbox().get_utxo(), (0x510ea1fc74f28a47c1472fb5a4214f187c7a2139600c9d9c7d0dd2a6b91089a8, 0));
        assert_eq!(result.get_in(4).unwrap().unbox().get_script_hash(), 0x4a262fd47194b45b08dcc871905d4eb46e5448ec8d9663d2bbef9a909fdd9e7);
        assert_eq!(result.get_in(4).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(5).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 350860000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x6bb6f61b9eef190ea71838d3632e3340b5ce8d5a5b9920e2f356b43fb11b79e);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 1033983);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x1a6d4ba6284f6f172868eb4743de022a054b92a6b7acc9fb8d16d94a0725f6d);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: b6e5da7351aba6ed0b35d03c013be1824e07bd9601bd2125c70bbd16a57c1c24
        let mut serialized_byte_array = array![0x4, 0x01000000010000000000000000000000000000000000000000000000000000, 0x000000000000ffffffff0b0431dc001b051433c74501ffffffff014034152a, 0x01000000434104ed9ba7a2654d346a29afd4b92a2469f493301a56f969dffc, 0x0b5a7a0a8bc79acc6e799e8e9240b533ce136d21b52d4a8a98aeb29045ec76, 0xd9e81b22b448398a56ac00000000, 0xe].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x241c7ca5, 0x16bd0bc7, 0x2521bd01, 0x96bd074e, 0x82e13b01, 0x3cd0350b, 0xeda6ab51, 0x73dae5b6]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x0000000000000000000000000000000000000000000000000000000000000000, 0xFFFFFFFF));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0xd5ad63c3f3cb65e16d173e9b9eea0873f151b2f078780f00942898c26fedf2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 5001000000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x19ee1ba1ca4e27eef92c470d86c5e003f63a9a562b5e1503b9f666cc4029776);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: a55de6291e9509e139320c5365192f55138ad194731e0bf0ebacd1f0f255c9cd
        let mut serialized_byte_array = array![0x6, 0x0100000001dcdc7e79a7ae8201078b30a1e0e239b259db8f8e0007501c11ab, 0xbe874505bc6b000000006b4830450221009dda34aa0283c51573744eb0c50e, 0xee503d3382be92b47765d86645ac33e9ef18022045b47c9a56ea8d10081ed9, 0x0876b95438bdcadf05b4959e9e8e1d6e3166ea8c5f0121029a16102625c714, 0xf2c278e8cfdd6629bd96a7a68ecb587a31599c520f60896b42ffffffff01b7, 0x3b3800000000001976a91422e669d08360198141a5a47370b6b9f908607cb0, 0x88ac00000000, 0x6].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xcdc955f2, 0xf0d1aceb, 0xf00b1e73, 0x94d18a13, 0x552f1965, 0x530c3239, 0xe109951e, 0x29e65da5]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xdcdc7e79a7ae8201078b30a1e0e239b259db8f8e0007501c11abbe874505bc6b, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x3aaf0456d6660620fe56e3f9c30e0d3551875876e50f03c06bf3f8e6ea23699);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 3685303);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x27736ff19f4e34d543096c62c7258b42002624435f2fcefb6b499a3ca483031);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 29c9d915be7e8a8f850a65d37f2d366ae1ff556a78667de9bba2b23e17df4fa7
        let mut serialized_byte_array = array![0x7, 0x010000000138994651af4660903486a041e4316ea608e72d786f96640b3d47, 0xbe45adac12ea040000006a47304402205ca8e503cbff6accb362e27147bd70, 0xe4d2f830a7225a65ec80f9e393081a8463022038aa50eb42341af94413c52b, 0xa7812675c928889b55b7ac1b4cf9e11ea63489eb012102108050ab9a735236, 0x01df7d727098de002b38179ceddbe9788127d38157ce8992ffffffff028c73, 0xb001000000001976a9145ea0533f501053de78184126d60592bc3432e5fe88, 0xac20145d00000000001976a9143e09fe98cbcfb885c02de168513a0fcbea46, 0xdbf088ac00000000, 0x8].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xa74fdf17, 0x3eb2a2bb, 0xe97d6678, 0x6a55ffe1, 0x6a362d7f, 0xd3650a85, 0x8f8a7ebe, 0x15d9c929]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x38994651af4660903486a041e4316ea608e72d786f96640b3d47be45adac12ea, 4));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x22cea656a8404c419f51dcc1ed6fed9449ec64e007f156fae02cf3d1849459);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 28341132);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x53752dd39dbd98720706178a3aea9434e45f2ad60c1c3058816225f51676b05);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 6100000);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x674ad579b58ac7baf0836e6438edb7ae40c2764fd39a2c73122b8040770a5ec);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: b74cf579df55f01ef1ab57047497114b5f66e221f9b8b421170d6b270eb82e7c
        let mut serialized_byte_array = array![0x6, 0x0100000001539a7541c9baeda010bdd29668d128e096a5d7faf150d3925ba1, 0xa9d9fd775c40000000006b48304502210082a23a52032d06820a21fadfdbc2, 0x5f48e67b0e82257e1d2eb169cce42b0df63c0220510e35322e0756c90c33ec, 0x6090a74a158b5306433e479e63a088e9f2cf42b06d012102f8a6acd6c49e31, 0x98b3d9cb22330bd6a3cc825c45fce6b85d3e36c20de505c00effffffff01f0, 0xb9f505000000001976a9148c8f1049d53cbb0f18fab197d0512d6022fdf9f1, 0x88ac00000000, 0x6].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x7c2eb80e, 0x276b0d17, 0x21b4b8f9, 0x21e2665f, 0x4b119774, 0x457abf1, 0x1ef055df, 0x79f54cb7]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x539a7541c9baeda010bdd29668d128e096a5d7faf150d3925ba1a9d9fd775c40, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x4aa0b7e95dd14fb1c2abcfc4c996788dc2e6f847659aad51be3c49e98ddadbf);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 99990000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x26d4df4da079ed37209aedcfde373d92a104b3ba0e642c1ee7e40d9b53d5569);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: e35f1903e12e5b4d017c80f020e063b5f82486d9f8fd4f4473bb13193ef4955f
        let mut serialized_byte_array = array![0x7, 0x01000000013ab3df29546f0770a11aa8f4e64c8efc43165246633f95d996af, 0x002b243b2830010000006b483045022100a33d0102a2cd3ae59d0133389c3a, 0xbdb7760e52e88aa8cda0760b74156a4f307b022046ee41c638f088ed6a6857, 0xd1b6b9b0c8374fe79449c2ce0b15e71180d75e6a700121033cff4c2d61c9b6, 0x3580d7068d4c1d858b28feb44f0c0c67a44036bdea54a3b251ffffffff021c, 0xff0000000000001976a914c8e516d59c7d0a27641749016a99c793c7723362, 0x88ac96660700000000001976a91484d4e80b65baf59c1d6352b34a2983a16b, 0x7ff63c88ac00000000, 0x9].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x5f95f43e, 0x1913bb73, 0x444ffdf8, 0xd98624f8, 0xb563e020, 0xf0807c01, 0x4d5b2ee1, 0x3195fe3]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x3ab3df29546f0770a11aa8f4e64c8efc43165246633f95d996af002b243b2830, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x5d8c385c94520768606edca5b4555b7976b1d01fca8f5fae8339722bf7b7c49);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 65308);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x33739bc1bad9d3b89ff6fd3e6da26f90bba7d148f9c37f494c2a13d0caaef31);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 485014);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x590d13a098e2a1bbb185253a3d61a79c557e59509341bb2235f4796ec0cde52);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 107039a864881a0d02f5f8fbbbcac3090573b2510afd7e0a7d81d6c97c07ad8e
        let mut serialized_byte_array = array![0x7, 0x01000000016a4c47277b3fea94f1b64ca4eee20a793ec4fb2846dd45341f29, 0x4b70afbef082000000006b483045022100c617544ce25b0d83fbfae759edc9, 0xd8701f8f0a4c606b3e24728957fefd02891702202197733d3b1dfed3b81252, 0xbf05e8ae5c4e9bb2014b3dcaae9035e1dbec95b4d20121021555f8a50ff63e, 0xa6ea81f44470d674feca3be1ee818723e97548d53573a54888ffffffff02d8, 0xdb1400000000001976a91498674e013189e21a827f740c77dd643bcfc53e18, 0x88ace0150000000000001976a914f1430a3a11f5cb54755f364caab369e3ba, 0xcca9f288ac00000000, 0x9].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x8ead077c, 0xc9d6817d, 0xa7efd0a, 0x51b27305, 0x9c3cabb, 0xfbf8f502, 0xd1a8864, 0xa8397010]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x6a4c47277b3fea94f1b64ca4eee20a793ec4fb2846dd45341f294b70afbef082, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x51af8e32c3d41887c1e951c7bf7568ef26378141d49bc82d23f6c42f66a21ae);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1367000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x3c68a4c7e15fe5624044bb964a81adf467257f0a5e51a138b2785830a8a2b15);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 5600);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x3c77d47f5a331bb879f74d1f41a739b7845ed7d3ae6e9629883d0085480d55f);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 4685a3a08a737d0471067720133df578cddf1605bed2b06450c9b1e47861aea0
        let mut serialized_byte_array = array![0x2, 0x020000000133180629011bfa83f2afd05d4b314e89c416757a7565e7e9bf37, 0x775e1da97b580100000000ffffffff0181420100000000001600146e925059, 0xafdb7d92a9af859f98e466f22315b52f00000000, 0x14].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 2);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xa0ae6178, 0xe4b1c950, 0x64b0d2be, 0x516dfcd, 0x78f53d13, 0x20770671, 0x47d738a, 0xa0a38546]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x33180629011bfa83f2afd05d4b314e89c416757a7565e7e9bf37775e1da97b58, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 82561);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x673b5d0f5099a15ef9d66aa537f25701743e5873f1f72fa8b329a47c7d9457f);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 6f805ccb42d1c1ae474cbf7faf2cbb0df676b2f970390b5ff3ed3cdcb5ce3f63
        let mut serialized_byte_array = array![0x6, 0x0100000001798766c147b042c061f94e706466b3ec0ba175308ec8a4342502, 0xb5f525839faf060000006a473044022028cc0978b933e5781713400f990736, 0x05112471ad6e41c947949746e506265ebb022063a862599d38673044257595, 0x1c2db696c8817d8b00d439f9a44c88f04498d6ce0121032b2f083b56b54ef3, 0x611553669f52c035479a07d2da16b71b7c2cdd15dde354e4ffffffff017c12, 0x07000000000017a9148c47c49cc2bfa51917777eb898c7b4edf88dc71e8700, 0x000000, 0x3].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x633fceb5, 0xdc3cedf3, 0x5f0b3970, 0xf9b276f6, 0xdbb2caf, 0x7fbf4c47, 0xaec1d142, 0xcb5c806f]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x798766c147b042c061f94e706466b3ec0ba175308ec8a4342502b5f525839faf, 6));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x5a018724c66c976255b1fef2a94818324b3d342d0c10a6daa3ee621c58020ee);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 463484);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x44a844f764b82646e3c2c16056294fc91bafa6abccbd6acfb3a3a91c80d295);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: dcc0d68b1d5622493b9398b46e2fed2d38a445f63b1855846ea87967f502e082
        let mut serialized_byte_array = array![0x5, 0x0100000001f75a1fd7028c20fbdf12175cf05648f703ac35f67472a5d79053, 0x6fbf57c2d01b0000000000ffffffff024c790100000000001600142767eee4, 0xcc509e2e255e8b3bb5df7ba464cba16e0000000000000000536a4c50000caa, 0xb8000218eb47e58de4db3ec5d02a2f9660cfd665b9c5a996316329512c1f6e, 0x1165e361a59c5d551e12a0ef905b7c1d611e5e2c12c10701d9103135c05603, 0x2bd571504526035ab1e48b5b5dd22900000000, 0x13].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x82e002f5, 0x6779a86e, 0x8455183b, 0xf645a438, 0x2ded2f6e, 0xb498933b, 0x4922561d, 0x8bd6c0dc]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xf75a1fd7028c20fbdf12175cf05648f703ac35f67472a5d790536fbf57c2d01b, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 96588);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x1671aaad8cce0c35562df96b43068120ea51baddce2e74282fe63c7958a1e43);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 0);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x1c9805a1ca6203acfce04dce2a880490b99e922cb543f21280f056161de1ad3);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 336b444d1f861cb02ff55b053aec02e5a94105d86cd28ef2fb78df3dea5f9b3e
        let mut serialized_byte_array = array![0x7, 0x01000000014d6d0e24b42e83c2f77ae9fcde70f17f776dfdf928dd02070b6d, 0x4d24999a8344030000006b483045022100b2c2dd2e707f9b1ffb91003bb0b7, 0x44a330f80d4e7517cfe230a06ad2477c05790220742e2c89bc5158b27edf6e, 0x3efe810660f0238b5cfc64ae219a0d10cf6907b4290121036012a9f2b55070, 0x0932a2b36a7dda21ef9d9c0b1580abf9e8115a3beddbdb482efeffffff02d0, 0x070000000000001976a91493702f0f3ef9db13d554383813054e56ef1011cd, 0x88ac05a23200000000001976a914fd19f11c808a524e959fcc39df3f94152a, 0x82d70588acf7510800, 0x9].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 545271);
        assert_eq!(result.get_hash(), [0x3e9b5fea, 0x3ddf78fb, 0xf28ed26c, 0xd80541a9, 0xe502ec3a, 0x55bf52f, 0xb01c861f, 0x4d446b33]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x4d6d0e24b42e83c2f77ae9fcde70f17f776dfdf928dd02070b6d4d24999a8344, 3));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x3840dce450bbeb61187d638c9b81e62ebffa2a212a9dbc4ad2dd0a99b998394);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xfffffffe);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 2000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x17b323274178b6984083e52350f41905f50e228118a36dfa2ae2e0e2f8415f1);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 3318277);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x2e893f457a13c4aefc54ed91636380a15d648731d4dcdf2d14e4ece31ca40f8);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: fc316cda5150f2c8b1ee2598d65a14cb4b653d41cfc478344ccfe82b80681e02
        let mut serialized_byte_array = array![0x7, 0x010000000123439c8791a85b5519bb80c4efc8d32779cb1c4286c77449b291, 0xaf31078edc25010000006b483045022100b839a592a188c304a898a97a3aa1, 0x76a563ec2bd820174966248ea18e26b2c3f0022012e6f5760a96462cbf05b0, 0x413c3f00ee08ea76b421f37d2bed7a70de54346313012102cde499924ed8a8, 0x56cece5f4ff82ffc376889b394afffa77fdede73ce5f19a7ceffffffff0226, 0x122101000000001976a9141e6eee16db04f2877f779c351ed82e08cb2a03f6, 0x88ac9166d030000000001976a9149728ac7faa3ade4913b924491e50a9324f, 0xb814a388ac00000000, 0x9].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x21e6880, 0x2be8cf4c, 0x3478c4cf, 0x413d654b, 0xcb145ad6, 0x9825eeb1, 0xc8f25051, 0xda6c31fc]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x23439c8791a85b5519bb80c4efc8d32779cb1c4286c77449b291af31078edc25, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x156177afaed6646ee4abe65081cf260dca895c09412a4a79b39cd25fb8fbf60);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 18944550);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x9a2d55ee219a1108eb68260f6cb83bec1c2879c149f976536432205a2a981c);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 818964113);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x5e102134a631daeaf104c5334b42a254a525d9cd770d2ed533aca4ba7c33e4c);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: ef1cc26af348b552229833899282d951a9d84a0d71c33ce775eba36097e3ac31
        let mut serialized_byte_array = array![0x7, 0x01000000019d30b6d7e8fe52a95bb96f5e22a8e9da0001c793a9d53084b432, 0xec77148f186c000000008a473044022020959c2bbd69f849ddd0a1b3994294, 0x849bdcb90d6a078b85b6f5e65a8dff2b040220415e4dce2186be8b08c84cf3, 0x55e4555c67f4e44f4a0ddcdaa2c082c65d1a4b5d0141040f68f9f1041191b0, 0xda3640e03d9cc56c6a20984fca0f8a32345c7df84e6edde6768d9c7c94f857, 0xb2c594c50c2f7199cc27157bd57fc6f270e548ea6a040c6ba5ffffffff0140, 0x420f00000000001976a9148ed0dcff2d3d8f6f6edc244885eeae895469d7bb, 0x88ac00000000, 0x6].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x31ace397, 0x60a3eb75, 0xe73cc371, 0xd4ad8a9, 0x51d98292, 0x89339822, 0x52b548f3, 0x6ac21cef]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x9d30b6d7e8fe52a95bb96f5e22a8e9da0001c793a9d53084b432ec77148f186c, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x48a705a30aa58ae97957c25827366a48db74d4dc6b3fa1aa1ec782894c02272);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1000000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x62363876873265e92c7c836abd8072a01e8a3c5d35b77fad0dbf332023a3a06);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 5a71d39c469eda7199f164710057e5336f7efc14a5727cc0e62e7d81727541b2
        let mut serialized_byte_array = array![0x8, 0x0100000001a5b84f1d07f739505a74564f6b1d01f67f676c22cf53d66822fb, 0x1f475a827d8c000000006a47304402202fedb2088113277728cd2b2f39e16d, 0x3e3a6586112475b51b413979a7fdb27b5602203c300a33564ff4efb3674fa8, 0x2154f81947c8b0e677984651725f8759ac20f537012103da5bac7b36d5aa38, 0xf531c6b9601e21bb598a4b6716ebed38b009a55dabde9440feffffff030000, 0x000000000000166a146f6d6e69000000000000001f00000da45ca33f002202, 0x0000000000001976a914d57c15bbfc8e04c864661c37872934dcd6b276f588, 0xac55d42700000000001976a914a25dec4d0011064ef106a983c39c7a540699, 0xf22088ac9cfc0700, 0x8].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 523420);
        assert_eq!(result.get_hash(), [0xb2417572, 0x817d2ee6, 0xc07c72a5, 0x14fc7e6f, 0x33e55700, 0x7164f199, 0x71da9e46, 0x9cd3715a]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 3);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xa5b84f1d07f739505a74564f6b1d01f67f676c22cf53d66822fb1f475a827d8c, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x5d7cf3b1235913bc8d837d8355087a69b66d7439a992a7487b6715a2519486);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xfffffffe);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 0);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x1a863ac65b433f07517b041f747bedd012970d43030e007e613f9189009a4f5);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 546);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x66c4bf0748c03d1ce76460e182d3210e0e019f3a5686de5cc63d464156868e0);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 2610261);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x662c7ff19c2ccb238ff4deabbf237f50251411768b8b9efb935dabd2da707e6);
        assert_eq!(result.get_out(3).is_none(), true);

        // Transaction ID: d3bf305dbee904e5aa31a4b2da3cdfb4ed49a349d24373f9198704115b8a0b56
        let mut serialized_byte_array = array![0x4, 0x0100000001df0b25a52c39549fd7400a2292e632989dfcb7e93337172216c3, 0x8c7e86357a35000000002322002038b5aeb8c65c6b5be7fe55088e28a77d69, 0x082fb364143f965648cd14daade304ffffffff0252a056000000000017a914, 0x139c3f25d2a28ebe959e4e31add59ecc570b0fd487fb67c3000000000017a9, 0x14de043f56b171a1c1ae42a4fd62e5be2b8da57d3b8782c20900, 0x1a].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 639618);
        assert_eq!(result.get_hash(), [0x560b8a5b, 0x11048719, 0xf97343d2, 0x49a349ed, 0xb4df3cda, 0xb2a431aa, 0xe504e9be, 0x5d30bfd3]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xdf0b25a52c39549fd7400a2292e632989dfcb7e93337172216c38c7e86357a35, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x7351b88a7f20d04b00b502f0eb3d1788f2e1875086e332e066d49b73d287399);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 5677138);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x470420529853bfbc8af782ea82bb62d96e041f77144f18ddee8e7c118e8f81);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 12806139);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x34c9120925cf9e9b19ba4aed856f4ce22a5f05745eb718d975f846d1e60abe9);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: cadb1dcefb339fc9cd70791cbc00c5a83137522a363b130ff2898e2865ca9917
        let mut serialized_byte_array = array![0x4, 0x01000000010000000000000000000000000000000000000000000000000000, 0x000000000000ffffffff080442310d1c026802ffffffff0100f2052a010000, 0x00434104485e1626b802bc07bffa9359aee4813507101abafbe679ca044b40, 0x05bd0f1d29e20f2bd659c8b10d776265ea52c68600d8a815dd793db210e7b3, 0xe43a042aee37ac00000000, 0xb].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x1799ca65, 0x288e89f2, 0xf133b36, 0x2a523731, 0xa8c500bc, 0x1c7970cd, 0xc99f33fb, 0xce1ddbca]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x0000000000000000000000000000000000000000000000000000000000000000, 0xFFFFFFFF));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x2d578fa85c080fa2d81fca5f46eeade310d46c673f523b32c6c64bd999a3a9f);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 5000000000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x31dfa9e9e6f4d2a83e30069ee6e55d978e14c256022635ef52d42ebbe87b8d0);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 46eb484804642b8efb8f2950ef41ce8444f6aa23696e5df543e8265bff68d8e5
        let mut serialized_byte_array = array![0x7, 0x0100000001195aba285a29dbb64cf2b5616285622bbb9706b4eac1852f5203, 0x3dbd8b6070fc010000006b483045022100e9084b973048658c50bf296c6312, 0x50c9e381efcfd05ae859afef77243e3cbaf90220385adfda58e05448c9c98c, 0x88b9c59c936b80e8856f489bf34021145e777cf9340121036e14b0a557e749, 0x448172d4a42e49ba95a640145fc63c480273dad6ba9d9171e8ffffffff0250, 0xf80c00000000001976a9142b19d6ee7015ffbddcb5b06cf55d9a94f0a9151e, 0x88ac7088fc00000000001976a914d84ab226a752b014636110bca650b8d6d6, 0xf4646d88ac00000000, 0x9].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xe5d868ff, 0x5b26e843, 0xf55d6e69, 0x23aaf644, 0x84ce41ef, 0x50298ffb, 0x8e2b6404, 0x4848eb46]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x195aba285a29dbb64cf2b5616285622bbb9706b4eac1852f52033dbd8b6070fc, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x1277aac4c6b370f08e9fb6c393672331ef445155525b64f6f2e64f70bee748f);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 850000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x69890fd088ea628f8e1b938348db0e2f7354f01c0d34de573c12a285cc1d52b);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 16550000);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x665968c0eac09329bfc768a4cfd0b7273d5f223e08fa4d933395c03b92fb420);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 965fb7864ced798eb148ab393e5a1622d6c1ec1f0e799fb237925d5a8330ff8b
        let mut serialized_byte_array = array![0x7, 0x010000000124197669143aa329e89da773f725a3b6ceca106aa2673b7e6db4, 0xd4dcdbc83f03000000006b483045022100ac93fe11ec0a555be580eb340b24, 0x8f604ee90668c438e7c26339f293b44d2e370220401206ec467129bc4a2ad3, 0xfc31764fe00a21d376c0eaafd5c1fb423aaf017ac5012102d91b6e1e14965e, 0xd56003005c9da20ef35a704f552610e1a344defde7f420659cffffffff029c, 0x520200000000001976a9145c9266c769486cab337980320fb4ed64b212e32e, 0x88acb0a90800000000001976a914b25404a5903e894b1f0298d54fb83094c2, 0x70f55588ac00000000, 0x9].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x8bff3083, 0x5a5d9237, 0xb29f790e, 0x1fecc1d6, 0x22165a3e, 0x39ab48b1, 0x8e79ed4c, 0x86b75f96]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x24197669143aa329e89da773f725a3b6ceca106aa2673b7e6db4d4dcdbc83f03, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x8592f910a8e6251a4933f5c38860df47e4c5b45ba0a903fa54d9c0607f6f0e);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 152220);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x3f16eec132276675b6a88fc6c3c3f72d4c892d61b23e72233caef0a03ca55df);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 567728);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x7027bfb197360e33ee565a02bc885a79b174e6f4217a506060e815c201bed0);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 45b020b02938c6874fd87be04dcbf8cf420483968286426433c3c2357980984d
        let mut serialized_byte_array = array![0x5, 0x02000000011bed65b69b1faac034d8d53a3ca18caff4311447df1f0db162ba, 0xb84c754f826a0100000017160014e80ba42113cda98d8c68bd5422b8ff6d39, 0xeb456cffffffff0322020000000000001976a91434faa62e903d5475a2a029, 0xaaac857073f9b75fbb88ac5cb33a000000000017a914878c39019870c71982, 0xe883384784b7f51c0bc59d870000000000000000166a146f6d6e6900000000, 0x0000001f00000df7dedb57c000000000, 0x10].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 2);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x4d988079, 0x35c2c333, 0x64428682, 0x96830442, 0xcff8cb4d, 0xe07bd84f, 0x87c63829, 0xb020b045]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 3);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x1bed65b69b1faac034d8d53a3ca18caff4311447df1f0db162bab84c754f826a, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x24157efb58c160a4e3b1c7a658352dc98f3adeae3eeebb9d4ec535634abfe8a);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 546);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x4d5179b87e77786728c5926ce7b21522fd9c2eb10cf0b1d99c8b5012637e664);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 3847004);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x4ca734fedc42ffd26a0a23f482f61f83f3343d5cafbb3cccf9c113b8b789a8b);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 0);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x2581de3c3a3c78af60059eb5db247a80e66d66db00d1ac5c1e2b54f5a4db5f5);
        assert_eq!(result.get_out(3).is_none(), true);

        // Transaction ID: d87302405c295ef0bc09119d535fbc60e3e4d8d76e84800b5820d96242c96e7b
        let mut serialized_byte_array = array![0x4, 0x020000000130338cfa3d076c67159adf911c3d46f2c910850cb7f28651fa49, 0xbfc200489c460500000017160014b6443d8a8b915cf9b01d584f6cd33fe32a, 0xe4d64cffffffff02c6664600000000001976a9149327db4bcc75f4b6017d4b, 0x8b419047846050e07b88ac5edc05000000000017a914bbba37f40cb545bcad, 0x4ce84c10733be66d166e048700000000, 0x10].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 2);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x7b6ec942, 0x62d92058, 0xb80846e, 0xd7d8e4e3, 0x60bc5f53, 0x9d1109bc, 0xf05e295c, 0x400273d8]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x30338cfa3d076c67159adf911c3d46f2c910850cb7f28651fa49bfc200489c46, 5));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x235f3053ca9cb1a83ea301c3219c4a30ea5793fbdbd345ef97db4f3171f075f);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 4613830);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x757bf88aeb34127ba4f7c3c6cab439aa8bd762044c23dfb3a168948af7951b0);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 384094);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x778f0156ad46065b30917487202e9934c9e2ccc424e2a7154713d01fe48d650);
        assert_eq!(result.get_out(2).is_none(), true);
    }

    //Test parsing of ranomly generated transactions
    #[test]
    fn test_random_txs() {
        // Randomly generated transactions 

        // Transaction ID: 8e3218dd4031acb5db26e5002b2ef1eda1d9ce87ce6580a64018605e0ff531e1
        let mut serialized_byte_array = array![0x1d, 0x6e763065041fb45b9b2dc95b94162cdf7047ee9e71b8093feab2ac05d87c35, 0xdf9aca61e84fc4fcdd125c85898a4b2e18277f8030fc56561adfe48ef408af, 0xd2f6d7c6ca1109447d260152415288984b722f97bd4ba6bf817425d68112b5, 0x7b450821a17e0db83e661d55d32a1ef2f7a3d2b15f71f44b1c1a8adc86db99, 0x2c12d745947be5c244449b6be065640a87cbbca81889bc28134b24b31078da, 0x92bbe14dfca51aff17101bd9e041a51283a4c2b8284cb4dff55c63916ff68c, 0xadb8707934f558f38bf3b89181534687b232378b24b93b0386afa82fea723c, 0xfe800419fc7b4e5c547cee31b6fe1232e19707093d1a13ba2ce51063d1c64b, 0x03f6290c89dba30922223d990eb47f095b4674cd1727d87a845dcf94dfff61, 0x53e15ed6691d8bdd113e8a8de63e5ccd70e4a33475dd1286d4e4b1ae796cf7, 0x8bbcaf6cdc3794ee62b6d90944ba64eaa3fa4fb2c236351ddbd4a724a40eab, 0xfa7b476d98201b3ecaaafa0c24ee50993d16058d346e52a73f42c9152da3e6, 0xe68a8610986b8c94393c469dbe8c8cd25c18ef3533731afc2760ccfd480179, 0x63480c1c625ba7ba626b84dea8f811e61f607524e7f1260b45397356b6f00a, 0x81790acc9369bef0db7697fd92b707983788b40431f1db82142074056d7663, 0x2676cd531b5f5796a8da5d789a1753974d4aa8db9a83e527264a9172844a5d, 0xb99609b8e56227b3ac2d9c194b310fefb156a6d204f2b1507cb5885d7e32b3, 0xde3f50a976fdb8f0de7fd365c0bb489c360c51e8836bdecfa2243b03ebbf57, 0x86726383f6445c51fa5de02bac6a9b9a35342f7a6126077c3950e74a388cd7, 0xe14f44e02419be438fce5d75d5b5e13efdfe30ff50aa4e51cbbb53312b59ac, 0xb337e8a4d30b74253071607c2417feeae6d70f093ce420b4699cc6fad7d307, 0xeaa63a40591aada2646f4a0eedda1fb0df8c6f0213c877b6e7e94480562194, 0xda74780864aa431e044903a787b70114477a9ce4fda3e8d9ee86acb6defcc7, 0x671f86e1194617826e6a8c1c73f9ae499a6522a8a21963679affa1c7022ef0, 0x93aa1da38718c33cddb841dd4b8ccf5c5388a3349974f76710fd59e02e0c76, 0x4c79f480d126ef94aaaba48b97d929a4e7fbcc962c5a4d7254ed0af28a1c52, 0x5e6bf924c5db3ef7e168e04838d496fa05c8f264f1c6af0a8c5fa7ce4bc804, 0x7e870114f0dc14ca975c01cd6e002b81ddb0487e10d9a2c67b2dba01c7a13d, 0xa79e7501002b44077e61b23cbb7024cddd901b050c841c65d566c89eda12ef, 0x50528d7eb31e98063ed62e212d21d2302d4c644c7142, 0x16].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1697674862);
        assert_eq!(result.get_locktime(), 1114721380);
        assert_eq!(result.get_hash(), [0xe131f50f, 0x5e601840, 0xa68065ce, 0x87ced9a1, 0xedf12e2b, 0xe526db, 0xb5ac3140, 0xdd18328e]);
        assert_eq!(result.count_ins(), 4);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x1fb45b9b2dc95b94162cdf7047ee9e71b8093feab2ac05d87c35df9aca61e84f, 316538052));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x32f9b3dd67fb837e46f6a3610153414c7b8d0e5b5f97c68437c5ea304beaecf);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x65e06b9b);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x640a87cbbca81889bc28134b24b31078da92bbe14dfca51aff17101bd9e041a5, 3265561362));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0xe4a32291b47bb2c3cf135423582bd5b399ffd6049137d7135d407b4f6a3cd1);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0x6e348d05);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0x52a73f42c9152da3e6e68a8610986b8c94393c469dbe8c8cd25c18ef3533731a, 3428853756));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x3150b157d8cee182b4cf0348b3f5803ee77a37ce421aeaafab0e33944a6c1ed);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0xa2a82265);
        assert_eq!(result.get_in(3).unwrap().unbox().get_utxo(), (0x1963679affa1c7022ef093aa1da38718c33cddb841dd4b8ccf5c5388a3349974, 4245710839));
        assert_eq!(result.get_in(3).unwrap().unbox().get_script_hash(), 0x25e6064fef6ed9592af9f27f13328258291b9a48175c3d91306f14ecc97465a);
        assert_eq!(result.get_in(3).unwrap().unbox().get_n_sequence(), 0xba2d7bc6);
        assert_eq!(result.get_in(4).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 410799247827399);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x6f7d22a2c5ee60a0b7ae485f3bf359dec202b2fe93d361d119f4b67c5920bb0);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: ecd04a1028d89e8b084e867d512b858c0f51cdc375569b9e83102b817a642891
        let mut serialized_byte_array = array![0x3c, 0x2480bd65049a7354a343902812e28ced1c4c69702df4eed65e713a4fcf9244, 0x4ab923671adc8b82da2dfddb01469cfd04ecfd2fce8f417870124272b49006, 0x3edeaff563b29b456c32246805a633a62700f54fe3ac054b2417542730bd45, 0x318b86c01670646fb56920f802aa66ad6909896fbc476056cf4d04d2ec261a, 0x7e1294564d22300560cebe70efa7f245ff0ece41e31f8b815e3d15bfe83e66, 0xc511e6e83b8ead45e163bc1b8dc259083c7e47c87a181edb7e8835ae6b74be, 0x7e9039aaa91ad65bfeadf52f121f318b9ec38ebb6ecf4e2fbc2398c0adbd59, 0xc55b05ddedd81d3212d19be91ce02f32a2d81ba0add9333122d7de92ae0ed3, 0x80bb634d52324a92d945853ed3d05ac5fe9af1c0687e7015204d393275b926, 0xadfecda7dce7f91fb773ec78ed84b96be4d8c9d3ecf4478e35f4d4ad40eb57, 0x6f53c91b6062dab624a064197f68fda895e254b802c7f1bafd91e1b1c19971, 0xe5cff08a7baf36c8eeb845c927f967b311adc786d2f4c92f4355e2f434a0f0, 0x82be3da81f15b7eef610be389e0688998887ae5369273e327b033236946a31, 0x1324d7aad7fbe016df2332fe348bec7e13b104f00c77b8b478d98622c293bd, 0xf405f16bd0fa55323470c9ab40a6bb8ff77737b6690a40e1cbc981583c3cbc, 0x24e984fce0cd6cce7f4555d09de38d2bb75008b7874871f74d43b6885eaf14, 0xe2539bab1f042b1dee0975466c300fad281a7a4b22380eb8f3fe52b65ca6b1, 0xe4d3ccfbd9cb545fb0c30801d7604f1246a8d82c30ad2cf2aec8e08afdd7a9, 0x41fdc5018b3e13d9b26dccd86a78f1467bfb9aeac1c2e8284b772e2534f823, 0xcad9f0d07f7cdafab61ad08b93f700891a25f4c978b3581b2efc39a13a8200, 0x323e482fd6f4ceb4b87d0b4a1344cbe78bb9e17a31f9923cfc873b96712033, 0x4c529b0b5265553b35b4128a0159bec37a52b7e43851168f1282a3558854ec, 0xfaca18b3ae4d89d9688aa471058693bd20797426994a22f51cbb08c0707dd8, 0x7e4af2a0f1a5bef3638161be7150e9f90a23faa073a2c6083449025beefda6, 0x1c1012f6bc5dada942d21e6351e4ac50bf1bb980eb9f41fed8e217a304d221, 0x18ecd51964832182149e41dc1ba9d7b91c4b64b0122e53ed7a9bbf6dc02a8a, 0x4d6605a6480d0446c36cb168181328daba3dad19e550030f8cd1bddd7a767d, 0xca06e3f89fcee48d3507d34aefff7803325ba907cfe3d7d8ee642901a66ded, 0x3714835a63b32c2f937402de654b0eb0e9736490442b0a7684df39322b58de, 0x364d073bae794ffa77bbeb6eeb8a445504693a5abdba1f90279c505d64bb3b, 0xdc1fc192b54c9155a3460373b1056f6fa40f7d16e1145cfc7791637cddbc59, 0x0f9be26d97a592c8f729f85fa7c521dfa43f89d33bc5c2d3327bd5a4db6b25, 0x8bd10f6ebd3fb6b7e394912728b515c9f762450484077be3cfa45d1c350739, 0x2a4d098b0602b0ce82d1826dd33a6ac34b3690d6fe9b7fec001870fe24c82f, 0xade11542ecab1ab6b6f340d97fed9f98bc6f50b95860a9e4bae1c0f2288ba5, 0x4f508ddea92e218096bb88ff1a4e9d2fac1beea2b4b4ac4dcabfd0904bcb4f, 0x1939070c8a146de4efd31505ba26261eb926770d718261134a310b27b6b3ad, 0x228850c35e3fb38aef569fd052174db4bf79a174312216895b03be86cccacc, 0xb838f7664edff58db3b0fd13119ba40bf082cb720537e85ca4529b5e70695b, 0x9986a611a179fcdd7e49067f9bd01911f239731556e307db397d49bd0f288b, 0x17af69bd584da2e3c75c8316d4c7845bfdee4f77d7d3887a852ad836a80d04, 0x21bf4a3a1b2376cd7c9670a7bef786d861e9fa119ea17ff3b0d510dab02452, 0x1b07866735034a89c5839c079af40b06ea1184fd6401e884a241783f21cb56, 0xcbb6cab9aa976753cd6fba26ee98765d82e1de56b545132c6bde0528f85428, 0xd71e38e5fed75a091e6af2e609c823ef4a06d1f85ff95e725c7df088e2f9c8, 0x213be24c1421c53c2e4f4fc8d1e9f0c64b937e617daa99e79a9a1a78647321, 0xc3c12212e4bbb10301b653aff842f89db7c9d47f1689d73d15f22bcf2a58e2, 0xee8320d3a1ac171123dbd22424e9b74aae426d4cfb9e57254c947ef1a1a330, 0x0fe15842f7269a2ccb914b78c5a2a1767803fec605c29b07c916a1c59f7f3e, 0x23e9711c4f556db939f6d476a8835f02e37836a09eb509736650cf5573918a, 0xb42c16a80cf3cf5bd551ebde6479a362e9f9d7b60373f57edd2e0f0c72fc6d, 0xc0a2425205dff331a6bb7b1f34819abfba7ede8ed03062faee874a1b1d94ea, 0xa7c5653b0199aca5821c09773c109b9ecced94e3075c59fd0223e3caaa516d, 0x9c1d7d46cb7575476dfaee1d3c7e1e1e42b7db317a1f362a397b30ef9f4f2c, 0x0ae537e20a3fda6c8099050b012ba4397e020027e3049c37ed51ae8d325e5a, 0x33a20f1264ffc8ea727e19273a930236bbebd47a1dde88a5184fe574fc29dc, 0x155ca106001469f2690a35adf739c2d0294aad3c2b2187f7a5da79c920af6f, 0xe7030024a62ac733b24a1ebe1bab3818ccaec22119c1071b9db278972343c2, 0x262c76013600d1b225a5d690ae676b03001c472f9f1fd57a0462b865041b07, 0x98e968d76085c60629b7c8021ec2ae37d23ca1428206000d97108e0d366a59, 0x51057879b9c8821038dd, 0xa].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1706917924);
        assert_eq!(result.get_locktime(), 3711438978);
        assert_eq!(result.get_hash(), [0x9128647a, 0x812b1083, 0x9e9b5675, 0xc3cd510f, 0x8c852b51, 0x7d864e08, 0x8b9ed828, 0x104ad0ec]);
        assert_eq!(result.count_ins(), 4);
        assert_eq!(result.count_outs(), 5);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x9a7354a343902812e28ced1c4c69702df4eed65e713a4fcf92444ab923671adc, 769294987));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x59178a3a43a5f68232717d7f41294ebe63aad8bd51b919f1f37bbb0cf36535c);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x52fef3b8);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xb65ca6b1e4d3ccfbd9cb545fb0c30801d7604f1246a8d82c30ad2cf2aec8e08a, 1101649917));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x14b9583eeb668b990c9fcf29a4484b189915007df8a1c48c4cc233c6ae0bc3e);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0x5da4cfe3);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0x1c3507392a4d098b0602b0ce82d1826dd33a6ac34b3690d6fe9b7fec001870fe, 2905589796));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x4752dc6761d22acee983e963732a81eeda59caf71a11a4e1019487c5a52b85b);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0xf7bea770);
        assert_eq!(result.get_in(3).unwrap().unbox().get_utxo(), (0x86d861e9fa119ea17ff3b0d510dab024521b07866735034a89c5839c079af40b, 2215766534));
        assert_eq!(result.get_in(3).unwrap().unbox().get_script_hash(), 0x457cd6d24f62fbf7c68848cb2876d10f9f3711a8d510d929116e5a510798761);
        assert_eq!(result.get_in(3).unwrap().unbox().get_n_sequence(), 0x99806cda);
        assert_eq!(result.get_in(4).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 701735985938699);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x64673fe8d6b8aa7641dac2ca8c6724b2d3849e7d0b4dad7324a9ee0045953fd);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 1866266736077308);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x53ded7cae3fdac741b070e586ca10685361b8aa60274912eaec084bebfeafba);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 1098891795679609);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x4e547e5d68c7e82e1188c5fa8a490ee7726949d8c560403e3eb610752ae052);
        assert_eq!(result.get_out(3).unwrap().unbox().get_value(), 962517984663205);
        assert_eq!(result.get_out(3).unwrap().unbox().get_script_hash(), 0x171352b6ff7d78011224ad654302873f8af72299798de4364b584f966d36af6);
        assert_eq!(result.get_out(4).unwrap().unbox().get_value(), 1832072544834103);
        assert_eq!(result.get_out(4).unwrap().unbox().get_script_hash(), 0x7c7b4ff1365cf03fb30d56be23fc87343fd33df3e4e076fe3a17a41f531657b);
        assert_eq!(result.get_out(5).is_none(), true);

        // Transaction ID: cdc08c3633eb7b923f9300e918f97b83f63d399bc432ba323dd469b866d07415
        let mut serialized_byte_array = array![0x3f, 0x43810065056a1731391531897dc258e00c2faf3beba84ef80d8a6c6a203ab5, 0xc1b78d72fb59de9ada76fd6001a5d84349d2d5c90fc60a25108cfdbd982305, 0x0295374d03fb2bfa4f5dbbaf24afc186977d8eedb1e7b1526631562b961cf8, 0x895ba21a6c0fc5d19ec18249ab25d5ceffb33729af6d593cc97841b6843560, 0x3c7e1e82cd6c1a975579c934f9f54635d0882c535e1173ed3ba14b2533a4c9, 0x0b8d34cb6c7a5eb04d95463b69622260c930d971bef7c39748a8368e01262e, 0x6b7b53740c561027a5a0b13d2e4f9efd41c2f08b5b6daa718373ddf7f55b53, 0x91cec927dd62bfd717a9825b4720032289d4e2a8a5c9f55bffbc452b819939, 0x8ce44c6f1ff21df91e2743d41445d10c3eeff27c4173b3dc88ef432176e7c6, 0x7caa6e7ff229a7557e73c6d87a974fc0756df1fd715b7153d52b2926734749, 0xa9f9db78b87db75e6ec3a0c3cf73fe6d31c8977951368c11590b1181a746d8, 0x5115f9c3dbb4c9123b0c4fdf67cc43f6fc203c9eaa364dd3dccda927dff287, 0x3209bfbefcadc3a293f712da24419bf61c490c9efdd87dc66e373a126c41d9, 0x0cca8fa69ee4dda8189f990ba9750d6f224d882222d6c80edcb1716df5fed2, 0x23ddfd81014767f6bb876305b66ace1f37ceb877dad899fae3a1d2512e19aa, 0xdd6be8010454409a5dd079ffab3a6b4392f20bc7e29ea88794479137d58a72, 0xe4ad806bb82a0424f77c0492c7988733903fec167f324d2c40f387b1ba713e, 0xd5388f1156e82d6d4097660aa2d4a45912f9884ede69d2b80bf2a3d0a4f2e5, 0x041f7c546b009373d5b9eb68555b5e0a9aa8cd236591e746fe22e33d6f0594, 0x22a6c87eadd215d4e792bb16424aa0f90446ded0d620311ed31cb9ed268fee, 0xd02f6d104ef68282081b83c1852cb3ba93e72e3079ab216bfdaffed39c2228, 0xbfa543feb93a9149678e6edd97aeecdff4e3a9fd3e78777f702cf7bbe83dda, 0x6301ab2e736014ea45d0bac0b9aab7c0c85e38b469518fce9fd831482be6fe, 0x5a2a30b36a2bf92a061df7c1fc3b1e950be65790a2e4598806fe3d12fc995e, 0xae710646c740113f58792945c54e17062f0bf683ab84f14548f39b434271da, 0xc5d3427ad0e160fb5ef3b616638761aac6d4f78bddb86fae9ae60617e28713, 0x6a8847c4e1afafd233cab5e9962144122fdd994fcaa1d46273f3c8edf06d72, 0xa9b56ebab11dc60125e3df6b1e6d28bfb661b8b4ee16b71ecb29ee9e382481, 0x32c9c2842b75874ae5a8d45466f8ee9126ba2e7d2b1a7c14647e4298492741, 0x76e29a3376e632bfa21d5376b64c91ed0b9e5e0d5cece20c8db11c8fe022d3, 0xc829ccbef740bf2200de9dca613d59f717f35d565ad5431cb7c3fd4836ebf7, 0x9539134ee3ae876fb2e4ae52a1f3938ca73b98abe8a20df8ac60935b363d2f, 0xc5692b8acccaffcfbe87a572134e3fdefebd7d7ccac6f23e4edd1a08f0b913, 0x3086c9364a0983f1e12149d3c8482323a4a8494172dfae4c137b02126d69a8, 0x20cdd62434e4a0f00bfd000133446e37429275dc8611985c047e9e79b68664, 0xe7c7d2b7e457e1e2b40cfe0ec1b5a013c35d0b968549d9d95cf90f005c8908, 0xbcff1fdd5c40d23cafc7faab0dce076e7a6f7d2c2550b0531b7c615416c74a, 0x5de595ab04cfb395a7ae31d21efb546eb6f51ba21fdec8d0e82fe7fb152a45, 0xdafe7a5cf63d21068dce58476690217e51762d4f0fde7833caf8f6fe8710fd, 0x04429a1b7eba216f00317c7d2dfaa1bd962ed9c06d6f79e1d6c40d66acd1e4, 0x3a032144dab1feb99d8e26f71ab3ff125d0416439ac59a077d07da577ae5db, 0x839c615c7493a3b917b4e29646b246fdb422fcd7bfc34e795951a3f23d0f0e, 0x28e95d68552229b16149256f5cb9347bd6674af2b3a70f9d1c82a3937fe106, 0x10a703fb313e6e9544cd0f8ef1a4143d453f4e162047f5f605c9c48179fde8, 0x013d0ef8130bba08d9a543ac46647dfa025c6155b9ecd5d1bb859610c2078d, 0x0b5ffa77ae2ddace5ffd8e042807696233d1048ea7ca4e7257b37a1667dc69, 0x95a388302ed27f99b5e14f87cda7d8400156e4994a2b3d5b6f38558e08f274, 0xfbcad386d3286f125368c9676ba228913b505a3244b46e8b168897350c6f18, 0x1d186570fa88030a9e7e0e8d26908f54b8c14b4bc297f95a028501a7b8c075, 0xa26c41730640621bdf8cb0dbda80b2685ac34d1476984cf02e417b7fabb7bb, 0x19bfe8472b1a8df02fff683e171e57203f6a18f577421185411ddac491f72d, 0x1888cb967de5bb73c63f26e5032c8f68f50be61b5a37b239fa05f10ed25a2e, 0x3239b85c9faf6055f62fa24ed8627639191228393b0894977c0057f256d9d1, 0x47b252b32d54a2cf745145cfd99d3143499f3b329fff84a9e7745fdac2da67, 0x3bd2a869615d3714c4a4c3e08d65428379cd7cce399e5aef098e4599a56d9e, 0xf48996da0c0444daf65f362abac13228711e685152f3abe279fee492446498, 0xab6b0853ff4fe551dfe9b574a96518f4eb9248c3b9effe86851173573bd2ac, 0x2c279ee2fd59abedb1dc90cf49d7969c85d91e8baaf77f3f4551a34723c007, 0xae34753447091f0030d05d6568d7ddf25549e9430cde52cef7cd07c0c73835, 0x7c0fa6dd81c6375ac8e1e33e2813938cd07c474a28fa81b6c66afc9a025f6b, 0xfd18d20b07002d7e663ad55311df53917207f281eaabecff7e342cb490a622, 0x3b5074e7ccf9703e2dfbd9333bcfec6f96e4877c58bec67ad1785606002784, 0x4a712c0602d508e20d7080c0c4a5ad6d3a623dbc0dee974270ee78aaa69ddb, 0x7971365089e5217963da56, 0xb].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1694531907);
        assert_eq!(result.get_locktime(), 1457152889);
        assert_eq!(result.get_hash(), [0x1574d066, 0xb869d43d, 0x32ba32c4, 0x9b393df6, 0x837bf918, 0xe900933f, 0x927beb33, 0x368cc0cd]);
        assert_eq!(result.count_ins(), 5);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x6a1731391531897dc258e00c2faf3beba84ef80d8a6c6a203ab5c1b78d72fb59, 1994037982));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x617e2d2042681d11ac44a29c05b136bd51a507ff17ae3653371fac15243420);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x123a376e);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x6c41d90cca8fa69ee4dda8189f990ba9750d6f224d882222d6c80edcb1716df5, 3710112510));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x39a2ff3cbe9ac0def3ef6b4d4da1d5c0413d4eb24607150e694189ad79a2ba6);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xa1ca4f99);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0xd46273f3c8edf06d72a9b56ebab11dc60125e3df6b1e6d28bfb661b8b4ee16b7, 3995716382));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x4214904825e2c5412bda73c0146be6c2be10c6fdc7658f63077b5054922d50);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0x36c98630);
        assert_eq!(result.get_in(3).unwrap().unbox().get_utxo(), (0x4a0983f1e12149d3c8482323a4a8494172dfae4c137b02126d69a820cdd62434, 200319204));
        assert_eq!(result.get_in(3).unwrap().unbox().get_script_hash(), 0x2ed9c5e2cf9f1d4231b67c16796a520358668d7ffbdd39e84a5cfec4b95eb1b);
        assert_eq!(result.get_in(3).unwrap().unbox().get_n_sequence(), 0x9d0fa7b3);
        assert_eq!(result.get_in(4).unwrap().unbox().get_utxo(), (0x1c82a3937fe10610a703fb313e6e9544cd0f8ef1a4143d453f4e162047f5f605, 2038547657));
        assert_eq!(result.get_in(4).unwrap().unbox().get_script_hash(), 0x5a890f609e27b53893fde9eef0f0f01ba5de4b239b654d90fe008b14d2dc5df);
        assert_eq!(result.get_in(4).unwrap().unbox().get_n_sequence(), 0x9afc6ac6);
        assert_eq!(result.get_in(5).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1983321827273567);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x65e012ba4ccc4f00cc8b8d99978287420f8435407030129f6c93925c8816309);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 1783926770812606);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x1f884194182edfae6a03599e8f2c64bc00e9320bb5b194376273e2246835629);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: e873d520c0c298cbfb5ca1f2ecb6ee904106a83e54479d15fa59f7b842288272
        let mut serialized_byte_array = array![0xc, 0xb5307a4e01c7fec79cced0e184788c3ec73cbc06dc5b6aeae2e55264d6234b, 0xa43d6eca5d8476f267b2fd0d01877e9ecd7b8d95c86e6ae0e7f1d230b19cc3, 0x0047198c60bd66d31a61d4fd73beba368a93345243d3bbdb452dbe0e8c9341, 0x5955367ae87d9a80d5eb0236b60e702740e3d87124e07fb72dee2c3ace1dd6, 0x2bb8a165461f4c1bc130c75c9c8b6faa911f0b7ccfcc2003d66ecb2a889913, 0xcc50d64c6e53f316261ff59cd973ed74edbb40ebda4def2f3d44737dac242f, 0xb9e8efce38b025c11d725bb0006714a1da77900e8e7033b2f3716c1341c287, 0xfc45348fe2f522a7b5b1fa3ab076fd6854ce85f76cfc956af3a9753753dc81, 0x0d8a0a8367232e532abd9bbbe73084df2d634d6d7bf93794e5e86162531bd3, 0x6606004061e4f02855db367532e7f4374a8e374cfc668ee1090fb281a0a0ef, 0x4bc5ad66038514010f4f047d4260040034cd49f60eb7444af7765735424ff5, 0x17abb50333ef11355bd87b71378b5d579eef91ff605ea99a0cc43892d137b9, 0xe612784c48fe116b67b2f0, 0xb].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1316630709);
        assert_eq!(result.get_locktime(), 4038223723);
        assert_eq!(result.get_hash(), [0x72822842, 0xb8f759fa, 0x159d4754, 0x3ea80641, 0x90eeb6ec, 0xf2a15cfb, 0xcb98c2c0, 0x20d573e8]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xc7fec79cced0e184788c3ec73cbc06dc5b6aeae2e55264d6234ba43d6eca5d84, 2993156726));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0xaaadaff24e11502c894739ca044adbfd337e1c558244d33bd9d7dc167e99d4);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x14850366);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1231738588385039);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x1e7ebce4b944b31a08d8a4f6445d6810b838b9e4111b133ef57822e681440e4);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: ccf60bdcd1f9ac67097f01428ba1e8429c3238b4550090f8c720ef2e82ccc2f2
        let mut serialized_byte_array = array![0x20, 0x5141a53a02c49a72bd346d44ba8115dc9511e35310f774c0215fdfa83ac02e, 0x59d23e62c7d4429331e8fde00113a64dd943633c67fb4a0f9d06fd65731240, 0x5a20f24fe786d3bf75639a7480e566251200780081f30ca29ea3aa330274fb, 0x8c54d94f3489fe59ff379c5569cbde171418749814edfa5ceb8053385825dc, 0x27b7d1ff0bba182f83dcfb36045af86379e852dcadeca814977f5c78819a39, 0x7beb588bdd97b3ce0275fcb5f98a643369bfb6064047ade6292cae31abd849, 0x7eb22a68fad428d887a61e4ab4e40cfdc6160cb1c470f8f38d12c848993fb4, 0xec399fb8af51c6524e82f5e3c706fe43b5b8f041bdd373ba44afd64ec7dd9c, 0xf60cbd62e1e225fbc2fff1d3e01ba565327c5d9e7f75112ae8379eb2f8e87c, 0xff3982e5a67d95b412ecf1eadff62cab591ff31044cb2e6bb700bccd65de0e, 0xf5c3e77973cc3d23a7e45ca96076cc691101e6a65bf27114f5ef5faae7fa78, 0x63ed265c82bf8be6fb605f6fa3b16bb6eba93454aa06af1bab81cb671f4f37, 0xcc9d5913a5b52b028191b86ae982475e399855abf498de0882d8a5641f66b5, 0x48bb549ded11f5e54c6b4e4c4c15f779c86158adcb35a80246dd90a1519ef9, 0x714b03b9ef81d2afc06f13bfaf4acd7d7589f7c8bb0d9620fb6f5aaf9c9be5, 0xf1d68c6678f8c0bb3af4ed133ea45eae099a16a0479caec75575be2a246bba, 0xd5e34363e46ac946252ef23cb8cf50002801716031e8c8caf49f2c07bf1f84, 0x0b52b557591886157bd5a34fdbe62178df64fe1578944c97096a4a7220575a, 0x2fd72011dc6bfd0301b0396c9def890bd2da6b4f1685ff1b7eebcebc6ed4e1, 0x977e652ab0beab36f9648b847b6191a5e5a5b935269d2aca68ee9a7f18d6c5, 0x5e835f3bd45fbc16a8206c947db28ea589ac9f144ad193fc032da77fc07b16, 0x678d5ff8c74558378525a05abc1d9196fe3bc811722134d686e850bbb03566, 0x4206629041a04606c9fd5e2e12325ea0f3ea6e29eb00c40ba9d2be26767571, 0x965353297f6eda43b5761afebac3deb7f5737b057435a0bdfc1128b741b254, 0x80994efdabe074683e10a7662ad19851847560d6952efef6f1aff033eba8a5, 0xc42f21f3950a129b8f2ec20714386fcdbb97ad480310199e68e4d8210b48a7, 0x637fe93e7dee4db2d41fdbedd48640e98569b2df370a648004cb4992d01727, 0x05002ba545d07e10ce76d76d60ed8e8a65e944085256afe7e7026f03ccd639, 0xb12eadd7f1ecd19159926cace74f758b4301cb152c010038010a68a6552c93, 0xfc5ebbb525818e6ea3b2c5faba7d496a445fc84e0914e95f8bee9ba48e3257, 0xe1d930a14e56ec4458cbceeeb0a650840ec490ddbed4d179060013772eec41, 0x5b41299b4270146b64aeb3c8604634eda4606a3c91050008c60b3cdea55f7a, 0xc5eff354b2, 0x5].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 983908689);
        assert_eq!(result.get_locktime(), 2991911919);
        assert_eq!(result.get_hash(), [0xf2c2cc82, 0x2eef20c7, 0xf8900055, 0xb438329c, 0x42e8a18b, 0x42017f09, 0x67acf9d1, 0xdc0bf6cc]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 4);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xc49a72bd346d44ba8115dc9511e35310f774c0215fdfa83ac02e59d23e62c7d4, 3895563074));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x8c8823d041ebc95b77eb957901e828abef0b5e6b8fb53ce8f1a0bd00a484ed);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xb841fbf);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x52b557591886157bd5a34fdbe62178df64fe1578944c97096a4a7220575a2fd7, 1809584416));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x6751041ac6181d9add4ab58be6e4759a40150246c8a4d4ec960a54aa2830872);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0x80640a37);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1450358120532427);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x622a9b36b7f7b2bcedc9af553ed325ead660a418760702903f1497d1db64c21);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 329947088503691);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x6c858141733f240f57823a33aaaa18d9fdc8f5396008ff2d3cdfa06283ca977);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 1822791984668048);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x21297b7d43fcaaffb3982bccb06ec216ae8f499426cb47a93bea8193f322e59);
        assert_eq!(result.get_out(3).unwrap().unbox().get_value(), 1567063552337133);
        assert_eq!(result.get_out(3).unwrap().unbox().get_script_hash(), 0x8302fd00500551b1ed93db60baa3f7a43a0c7ec56a510f60e23d859ba28a49);
        assert_eq!(result.get_out(4).is_none(), true);

        // Transaction ID: bb900d00f74f9d7293ae48e2b6d3d02e67d9ebc0d70c0584367d982062925bda
        let mut serialized_byte_array = array![0x12, 0x3370312303086db979c941adbdfd23f17a0bb3148bcc060df29d1a48fbe0d0, 0xeb6201b7f1f44a590768193b1d00b2184bd11edc93ee24bd4a6d1a10c05350, 0x53b5a88b1d8da4c4a5ff22cd0729eaacaf1e202439b143f0f1be9f0ad17946, 0x7d17a7f75b7b7716a8f4baad587434ec94331ac6b92040928d78ae3f98a723, 0xd27c2f4c06927be60fc30c54db48b9d9ce16d843948a7280e23c48d085afa9, 0x9092efc1ebb4c5e8a2466e92a581df3569cc5baec5323122e111ec7bab2161, 0x6a7ee590372f08a3e6c77a72ff85fd02014fe02435221962d6a486dd9033d6, 0xf26a0e0deedf19c1fe9413b011c53c1f22f751b64ba30c05669bbf45f6a96f, 0xfa2bd442fecacc8e882a77d817985d19f7fef55bb9a34544eedee406daf2ce, 0x94dbd9fbe3d98c3ff03319dff71f6e361f1ad7cc7728a6def14661058d5879, 0x5ac6280cdca9d2df7f77ddb5c1a2e4a925ca092bfb60d352625b7743cc4a15, 0xf95392e8cae431ca310f7e70a27cc38b82a14df7b8528ecfd74a9c98ecc973, 0xb362b342f82cba7c7d96a0da5f43198fba8dbfd73886cdce9049c78265e97c, 0xde83e6a114cf84f4753dd1a2f360f5bba8529194ab9081ebff96e501aa0d09, 0x10b1cf933a006b6136e805fec154cf7aed614cec9226ba1ced1b58a2f4eece, 0x02542f7ec85c020200398dbd3f7fd39e269810f48abc311c96d1f52a06802e, 0x75c09044656c34aca809325148159f4e82fa63d63972eff90d07d1c59526f5, 0x2960f8da8a625f03f9004502001061a2279bd9e88d7ff2cf6946e7faffb4af, 0xaeafca, 0x3].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 590442547);
        assert_eq!(result.get_locktime(), 3400511151);
        assert_eq!(result.get_hash(), [0xda5b9262, 0x20987d36, 0x84050cd7, 0xc0ebd967, 0x2ed0d3b6, 0xe248ae93, 0x729d4ff7, 0xd90bb]);
        assert_eq!(result.count_ins(), 3);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x086db979c941adbdfd23f17a0bb3148bcc060df29d1a48fbe0d0eb6201b7f1f4, 1745312074));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x4e28a1029c3dcd727d8d34d3f10619b401c1caba51ebbbcf11689bfa87b2cc2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xa5c4a48d);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xff22cd0729eaacaf1e202439b143f0f1be9f0ad179467d17a7f75b7b7716a8f4, 1951968698));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x19ef6587f8b455f3d8e413281a32a110f9367493abd8252c3202c0e9bed1024);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xa2e8c5b4);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0x466e92a581df3569cc5baec5323122e111ec7bab21616a7ee590372f08a3e6c7, 2248110714));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x79334e09e4fdbaa83adbb0bd4827576e21f98aa811df8bd5be35728c412da38);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0xceeef4a2);
        assert_eq!(result.get_in(3).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 565547477380948);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x71fdd40d70ad72ea6be2fdd2b64d281daf65bd4bfcbd9baf816f520c1880ab0);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 638820433485666);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x38bca44e39cae0599a60c1d81e258eac0746500f7e1c9f7c092305ccc214a5f);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 21fa58adf35fb6086413d1ee1b7a3e1cf7b2476e3c227b925914f59183bc1d99
        let mut serialized_byte_array = array![0x22, 0xad3b54320368c2155cabf91ba3b70aeaa3a861b1043a96f2f278308007c3e9, 0xdcbef3b04f2a7166c525fc45e16546111bb594fe7746cc19d40d7e769f2f8e, 0xe250d7180582e638b5111b3a8c816d5d68a74867efbc2995f6ebfdbdeab023, 0x7509cdf38ad4ed4b5ef40f24b2f9c17071591f0bd7243f7f8cb826f0dcafec, 0x47af5697c60e95e409a337eb7a5116679294d3f24ac38755eec5e5d4936a45, 0x8082b3dfe81518e54dc5a800a7632ceead8578c034053b21c242af8a459b63, 0x236d615c0275d548fc2bd16f64801d8bd3cb665dd70d25160889c86d84d822, 0x4cf4c9f52a88fa6ccc431f119ea15686ee277a6aa1c22885ae7f9a3b719d5e, 0x36f720ad376792ece1d62f7f668675009f751c4095473263c0af82ba76cc33, 0xc885ae9242b2a0a2ba46896662163d3f56aa43f7aa293e2ccd2650813961fc, 0xc39dd1cc8f4d531045d4491e6c83a95254046209ffa723c2fde3014fc874ca, 0x30617b6deab9f3003db5f1a1ee01ea94234d82abf2958e4c3b2e71220c3a2e, 0x566cc9b854f5f7210302b674df28378fdb4ba7c5d1d15d44a5146cb3199365, 0x450c4efaaaaf92d9b2b36d816fdee19de70dfed51985a70f2211c35fe55566, 0x127724eb73959672fddf2e817cd878faf5488afb389571a6c4d1837502c6b2, 0x2333474e1f671cccaef425720b8fce1f979bb9527b1209450146333ae4e27a, 0x4fd1c16d239e427d33a2862e6772d759edfe7f50bc5845b24799b79dc2c251, 0x540d9f83ea2b997244a254ca894263800710ad7795beecb99f9e4ee3406e2b, 0x6a4b660d47d532b2e8d69c948849a1acfb8a7e4ca89a15977c0ca860908b46, 0xa595870b4122669a43e236859001159a30328b00e2fc89726c3840b3a934a9, 0xcd33e2d9ade13b951c11bc689e82bef663926604b6aa011caed150b9610437, 0x8cdc26b1d83de0c76a34728c545391ef657b0be314caa4e5d13b1f857711bf, 0x6a16123f4c5e2e5a87ba9e2c53aa928a00c917d1dd2ac48cfed62e853caad6, 0x8b1b505142a5912128f6c314f24bad384e50feb4d4bd0a5c450f7fbf19ec67, 0xa3c218f9eaeba155775ec1a9c4675f504f5f0f6675fe7104f19a962db570b4, 0xce61463e7787baad28039f8c9f1c48818dead7dfb5846fda5001525ab4c5c4, 0x2fd4b0e7ca110027517a05d48797c6c854dfc8146f1e0c6584e9f9db62ec85, 0xde810cdce6357a3ff210d6522a8fbdc0109358e21394df14543bb6ab471f68, 0x7486c14d39812bde56f357e71bce2c3c4905245dc23ce6cf04002fc7231697, 0x9e0d7d123e54e9cc8f6f06a4176f194344898afc5937a32525f53e48df2911, 0x64260c3128fb50e3758d1a6104ff7183d3b90600254f4a7ef9da57b499fc5c, 0xd8c33248423ba81101975925f529ac5ea20775488e88bf9b69f797946caf96, 0x86ee04001b0eb8d0f67f906dd167822c984e3d2be165e1a9d1ef41cc75f78a, 0x9c8ac46374b0290000068d34a7b4e52542264de31a1902000292071261e384, 0x00, 0x0].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 844381101);
        assert_eq!(result.get_locktime(), 2229494034);
        assert_eq!(result.get_hash(), [0x991dbc83, 0x91f51459, 0x927b223c, 0x6e47b2f7, 0x1c3e7a1b, 0xeed11364, 0x8b65ff3, 0xad58fa21]);
        assert_eq!(result.count_ins(), 3);
        assert_eq!(result.count_outs(), 5);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x68c2155cabf91ba3b70aeaa3a861b1043a96f2f278308007c3e9dcbef3b04f2a, 633693809));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x7a004d76387081b5ba92116f2b4478137517c8fbdb2ae0a14c24af97a18215);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x43aa563f);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xf7aa293e2ccd2650813961fcc39dd1cc8f4d531045d4491e6c83a95254046209, 3257116671));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x2d5e73d75682404c11080b725a3858f874a6a5b3606906db2be6509ab747e66);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xdf54c8c6);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0xc8146f1e0c6584e9f9db62ec85de810cdce6357a3ff210d6522a8fbdc0109358, 3751023586));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x4a23b6cae3e04e1ab15ca89aa73c011df05ba768639969fd7cd4e5e6bee138c);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0x493c2cce);
        assert_eq!(result.get_in(3).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1354487675641124);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x622ce920a546df46c79afde20440c9b229f006f73d6d012c89853498e5f658d);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 1893167954788100);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x6251f1ffe120f78324502e83cdec843a01d0f2f68f040e143025d2fccea8b1);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 1388161727949972);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x60abf00d04141b4662060fd36b0e723afd2ffdf3a30b0597ec8c753f548b564);
        assert_eq!(result.get_out(3).unwrap().unbox().get_value(), 45837843678346);
        assert_eq!(result.get_out(3).unwrap().unbox().get_script_hash(), 0x1ec893a51eef474f9276ea72c616dbd8aaa466008f602221c02bf10e5d7be97);
        assert_eq!(result.get_out(4).unwrap().unbox().get_value(), 590553226749506);
        assert_eq!(result.get_out(4).unwrap().unbox().get_script_hash(), 0x5862e5e6eec4ff3723e53b4d807aa48f1d4d05197f15785ea3fd6db90ca9787);
        assert_eq!(result.get_out(5).is_none(), true);

        // Transaction ID: ce6c6fbca950adab90154dcf2bc1f7968dc88e1f930425f9ef7a70898539fb7c
        let mut serialized_byte_array = array![0x1b, 0x0f255936028b0f72821c49b058eceaa9b55026ea2958ad019f162ddacb4311, 0x62878a503dbff7c4a34a2edfe0580939db09c1cfd6d254ddf9668ecdaedc3d, 0x6e35d35572d4ba45b2f28d4c256f48681a144042defa96d89d4601819397b1, 0x68a961a90fb50f06e4b9e73a8a99bc582176efe58d89b8ff3e032be75d1ff2, 0x3b6d0b1dfda6016e7cea4403cafff87c04204b99f3c2a8eed5a02f5739dea1, 0x3bcb7ef7589fb5814e318760b6916553110df7e054517af70a765c76809f83, 0xcd1e5d89c2abd64a3a1c818f41d6fcf3386494a249ab5488b1fcc427f4597c, 0x605ce6ad34eab7b49ff1a4bcc230e195e50505923b3aa30177c2c67c8fd6a7, 0xdae4e5fdf7d882da39ab123257b876d67ba48389b23a819461ead82e590cdb, 0xb1ae2f2399bc3ee93454299a9313e1f192fe24ca8046283e65e19c68db06fa, 0x08f89e844e5728df34c457f2fc4d08d053897a102812d72406324cae467b9c, 0x2f111da2c9ff667b3a881a90e45d2b6b277e3035f39d31994bcb40fcc8493a, 0x4dbc4847ef65c218dcc1dc26d4fb82ffdbfd97e4e56e84a6e63c2aa4e11e1b, 0x07329517591d377539a8f33ebf1b0a4a7404b54d909726b002c8c3c6e56736, 0x4918ddc67e1582a342ad73e559ce924bfbad0c04f84e1e694ee62a7a21b538, 0x3fd6d141e95d539cd3631acdb8af03ed3d51389ba67f93b2499387539c5ed5, 0x0c201730b11b14c09ae824eb7d2d4819a35cfff3ea05422ceed52290397c85, 0x76373774c95dfde13bb6a87a973882311565a96a25806b107a2e44bf76a805, 0x3ddf652deec90400379766af8903b5d29cd3844b44cd265d87f263b707b4a3, 0xc2f96bbcb712ee991df646ff35581a30fa75597cfd5a366e5fe1ba7501fba9, 0x16bb8d2e90077ba50200314d5ca2abb0f893ca0dbd0bfbf1b871882135cf1b, 0xcb702b288d8a84163ecf3a0ff7d853ec21119157e1e739ed09e76ecf812989, 0x9b92ff3b04002c280f4d27c3bcb91ea6157064c7f3fca858981a0bbecc6027, 0xc0186a99c13ae71052f0431ff01669b1e44d5870d0927a1b443203001fa9c2, 0xdb0a9bdfffadd7c9d8050f2d98f2bff5c0c1ee723c6983e8a0bb673ab5e662, 0x24186c4b07003bb3d19f45103b1545791528003b080558749d3b328372f0df, 0x32d29c0cde07884ffc013bcb2a0547b2148b2b7db3b674a71dd9d01263d344, 0x9f7c45bed5b8f824, 0x8].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 911811855);
        assert_eq!(result.get_locktime(), 620280021);
        assert_eq!(result.get_hash(), [0x7cfb3985, 0x89707aef, 0xf9250493, 0x1f8ec88d, 0x96f7c12b, 0xcf4d1590, 0xabad50a9, 0xbc6f6cce]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 5);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x8b0f72821c49b058eceaa9b55026ea2958ad019f162ddacb431162878a503dbf, 1252246775));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x2797518ccbb2e84bfc5c66fd60a0efe76ab132a1dc8ee7b30bee861e2c24c5d);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x97938101);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xb168a961a90fb50f06e4b9e73a8a99bc582176efe58d89b8ff3e032be75d1ff2, 487288123));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x6576d98ae2329f1bd050810ecc72a4d81f74058688f6ba788eabbde7769c81b);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xa876bf44);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1347924707893053);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x7bc16c23f7c1b7f82e9ecd876a5c771101b0081319381cbeecc0486e537b4ee);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 744897779871373);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x65dfa7a28653f96ffcd09768da99e9eefaea84ac2ac3e97945b8f239adb9914);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 1191868769208617);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x299cd896c28805aef9a810f0623b3a9bd536d7a15647467886f547468630166);
        assert_eq!(result.get_out(3).unwrap().unbox().get_value(), 899693030314704);
        assert_eq!(result.get_out(3).unwrap().unbox().get_script_hash(), 0x56d891071432313cdf25320aad198984a7652f180c764eefd7d44e683c9e1df);
        assert_eq!(result.get_out(4).unwrap().unbox().get_value(), 2053252470563558);
        assert_eq!(result.get_out(4).unwrap().unbox().get_script_hash(), 0x1dd36cbb1ccf543a795c9d99c0168747dde867993bd952cc206c74a5e2d56ff);
        assert_eq!(result.get_out(5).is_none(), true);

        // Transaction ID: 5f7ede9ff331040e1b17e1135afd8f5a47f7ad50a5e6bd2d042fa7cbb5446587
        let mut serialized_byte_array = array![0xb, 0x6ea49f31024c44de9b9626a34306993aa5d7890e0a140db654c3f02b9f804b, 0xe2f544aaf04ec16124bf1063bc524d6f35ab56d585ff67f2363b7cec018a75, 0xa7f57e13a15821960b5b6067ec200a3a0f73fe9c099930ff5b0ed482f9011a, 0xab81a85b3da6e8395a125ee7a82c0b9b9e16171e0bbe6e822f3c022ae6a378, 0xf316387c757e66de974b0248f0e4c3be563dec4263c6f6ab5e9dc9776c69eb, 0xaa327c78a6b3474dbda09f6c62e69beaec1255ad86563cc2e70ce2a639d50a, 0x3aca4e3c875320eed3b611b5ef7354c9a6fd4b8d9cc4ec6a0379293f5b22f8, 0x27a5480cad7d272ba485d3805b0bd0cb28cd0a2f08abb12500644c92c1947c, 0x27c7bce09fc8e0042efd19e907a2505455584f5d99041044e9b33e0504000b, 0x2ca158b1ade6ea34a2c5cfd90e664e7bb5040004755e1a795b567e8be34506, 0x00050a86b59238ded5080edde604000e8198f829b2da3eac75369d21ff24c6, 0xd36df7, 0x3].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 832545902);
        assert_eq!(result.get_locktime(), 4151169990);
        assert_eq!(result.get_hash(), [0x876544b5, 0xcba72f04, 0x2dbde6a5, 0x50adf747, 0x5a8ffd5a, 0x13e1171b, 0xe0431f3, 0x9fde7e5f]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 4);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x4c44de9b9626a34306993aa5d7890e0a140db654c3f02b9f804be2f544aaf04e, 3206832577));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x4a780cba3d713bc128f9e1a9ac27982a5a9d58722508084185731dc4960bd6d);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x758a01ec);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xa7f57e13a15821960b5b6067ec200a3a0f73fe9c099930ff5b0ed482f9011aab, 1029417089));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x416d4759f676ee09be780f08df74698be6b34b546f8ba45327f578e4f2b5e30);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0x995d4f58);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1131666771362832);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x4107f8a2cafc329ac1c8bc59c7054e63e69ca4dfe6498738c44b28d52815597);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 1325441107758809);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x4e125c8ccccf44d405d337ce22494a0cd2b01d20cc8471f18db5320c8a7277e);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 1765693460469339);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x9cc6f8a98fe403fac9d9c6caa342b29c44f90867be61d6394195aa177757b8);
        assert_eq!(result.get_out(3).unwrap().unbox().get_value(), 1379737004463582);
        assert_eq!(result.get_out(3).unwrap().unbox().get_script_hash(), 0x4afbcc1f5221a29abbddc2b578e5da202c6fff737fb7180edad57ccfef0dce3);
        assert_eq!(result.get_out(4).is_none(), true);

        // Transaction ID: e6993b925ca4f453e011c93ac6105c22be060d1f3f62fba8cb51490e5b6159ba
        let mut serialized_byte_array = array![0x19, 0xa7ef0c1e029d49587c6fa5b1983ab32697fc0c2982081e239bbe6653313795, 0x70446b48c53e81ebc2c8e2c07d2d09c01aad82aa689d9b7cc8d8a45e1b9237, 0x1c785efb312a90af7c8ec38675e3eb4764f372922e8c7a28617144a42bb1aa, 0xabe5635cd9a615c8f26b7bda12f0683acd3a08eb5504eefbdd9b11b8ce56a4, 0x889255066376bbf97770e772ee26e3fe7421c72aac684ab95781ef1c84f36a, 0xb84a0335923527d5c0c4a279e2e20f2da3d48836fd3d06448ba5eb15655dcb, 0xf91c631b44ed09403bc4cb4fd18225e34435d732b297ff16ed2a992a0ad8a7, 0xcaf15779b25d596e0cec7ccd34dd2ced147dd2adb27f5916e465862123c6f3, 0x8d23e664f403a94eb95b820f678aa63f089fe3d196ebdd373bb70f542cd786, 0x2f0826e22a1f94f0fb36b079a7b9e2332d912a304c5c1751e245d21064fd9a, 0x01c8718950f61d27f2b3adc9d0b10ff2b8cd5d4645eed7f96f51468397a6d7, 0x8a8b2676da90b9bc7750dbcc05a2f7c4c916410de5be8cf049e2258f05a5e4, 0x4437959ab78d56b80eb2125a66474d190431d335159b3509f61e4af8dee0c0, 0x832fc43c9d9ed31e2aef89e7a8c6c74dbef6d5c060360ca2f8fd59cee7813b, 0xbdbb8ac6312121ae5f7fa434c312fbaf49051f2738804c87d5bb04a38f4c85, 0x76fdcc15b159f7ae19a168d4d7d264e540378558931032ac45e2d4eb15b1dd, 0xc078d2a99133e1cca376409b772cd20120c545c91a7da4b65c25c50be04104, 0xca34b96ce878223c4a7fb417d58b2175bd5092181a0e1fd7519993722bc368, 0x4009bcfc3e94e98fbe3b90b3ee3077363d9e7dd0b4c5d6cf34a9f5549822e9, 0x00c52b761a50645559fea392289683d131e68f005c60c08621b463d74cfdf0, 0x25c9ad1ef7816bf1bc19aceb9a8a04433fa0c6b7ccf861024ac376afed59e9, 0x783c9931c81f4f356c3c98d918e0b48d01757b67c6028bf7a3969403af20cc, 0x1aaa76063cfcc2080d6d77d23f369b7e69b39ed3347c90f11c8a94a3c38009, 0xea8def22de051b908afc755001f9b6c3d9457e0100252534493e8eaf0ed20b, 0x3527cb4251fcde1e323df1dfe16602f5d116e84f0c1030a5493147c342cddf, 0x33, 0x1].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 504164263);
        assert_eq!(result.get_locktime(), 870305090);
        assert_eq!(result.get_hash(), [0xba59615b, 0xe4951cb, 0xa8fb623f, 0x1f0d06be, 0x225c10c6, 0x3ac911e0, 0x53f4a45c, 0x923b99e6]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x9d49587c6fa5b1983ab32697fc0c2982081e239bbe665331379570446b48c53e, 3368217473));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x3a050be54fb4213efca25b4978c071e6675edc7ef4bb10d345e6e5ccd645baa);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x37ddeb96);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x3bb70f542cd7862f0826e22a1f94f0fb36b079a7b9e2332d912a304c5c1751e2, 1678824005));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x60ca14595991fba58c2b55b4b096f5c9cf83bc411694e98e0f9e4fc4cdfb96c);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0x5075fc8a);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 420313448036089);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x31f704531266d9cbc37e78a78a64bd793b0a37c8ba05208e180e7b3a51a57e9);
        assert_eq!(result.get_out(1).is_none(), true);
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
