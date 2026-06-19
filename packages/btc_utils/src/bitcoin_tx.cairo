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

        // Transaction ID: 2660eb3945638496f1bd630fc9153acc58e3f6d2c426e6e186941d4589cf3bec
        let mut serialized_byte_array = array![0x2, 0x0100000001d501f1facba8f90f110a1ff4cfc30cd1573bfbba5855494e28ce, 0xe2d57cb04e570000000000ffffffff01828b5f00000000001976a9148233b8, 0x9d4d59b7d485f1edc68d60d55da21fb5f988ac00000000, 0x17].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xec3bcf89, 0x451d9486, 0xe1e626c4, 0xd2f6e358, 0xcc3a15c9, 0xf63bdf1, 0x96846345, 0x39eb6026]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xd501f1facba8f90f110a1ff4cfc30cd1573bfbba5855494e28cee2d57cb04e57, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 6261634);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x55d6df45f38d861fa2640c40cddd5569c0c85d60974128ad44bc25ed1228a27);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 6427d5c347964064812ffc272a8a45b3fe1069b39d15defc173293fcf5581408
        let mut serialized_byte_array = array![0x6, 0x0100000001fc21e4372795b101deb15da88ea5646edcb7c09a5f1e85abafb6, 0xb1525aafc14a000000006b483045022100871899f9a45533ced2df8ede8546, 0x34aae1bf0bebeebf45e6d9ae70f65e3a1e9602203a89a3c95261ffb14163b5, 0xc5fdc532df3fb331fa7864e2bfb5c3b31d34f8ab46012102889fea24ac9593, 0x7eb6a75995ca65f0b978508fa81577ba8427fb2e62ef8a9174ffffffff013a, 0x0606000000000017a914ece9ab2e4b6286e630af3cbc944664e2f60a896787, 0x00000000, 0x4].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x81458f5, 0xfc933217, 0xfcde159d, 0xb36910fe, 0xb3458a2a, 0x27fc2f81, 0x64409647, 0xc3d52764]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xfc21e4372795b101deb15da88ea5646edcb7c09a5f1e85abafb6b1525aafc14a, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x30a698fff82c1e55e66c7c8e329af1445196a52ea7e99f9e39d5e33cbd6f62d);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 394810);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x4e238c473e4bf6debc9a0717ccb46ac1e9fbc085c9f922586bcd6cd0578ff6a);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 0de2a9b6251dd9731f5fadaa04dbd1e3ca358e5488b57d0ee2d23536ceaf82fd
        let mut serialized_byte_array = array![0x5, 0x01000000028fabd0e41cba01a534a47b789edc6b3db430e8635364bab5487b, 0x17918b9383d30100000000fdffffff92cd9cc438d421a03706f3a324b59d99, 0xa8e01d7dfe2819b7473938471114c58e0100000000fdffffff02bc0a000000, 0x0000002251206b0edbd054679bedd53b8103564b4e895af4b634b9df5960cc, 0xb1230d0c0ebe316109000000000000225120ff5e673464439084d9f01e52f3, 0x699bc288734debbe36c03aa990167ddaceb22000000000, 0x17].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xfd82afce, 0x3635d2e2, 0xe7db588, 0x548e35ca, 0xe3d1db04, 0xaaad5f1f, 0x73d91d25, 0xb6a9e20d]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x8fabd0e41cba01a534a47b789edc6b3db430e8635364bab5487b17918b9383d3, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xfffffffd);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x92cd9cc438d421a03706f3a324b59d99a8e01d7dfe2819b7473938471114c58e, 1));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xfffffffd);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 2748);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x48ac2c2d35ea62be270cd6913431146f9e6a65ad389d0f492a749cec29ae356);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 2401);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x2d3acc0c0392f1e5955b08685ad1a3db150685aad2bd160be821f8667fb1843);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: d0d66959cdd5d86645ccf902696327c52379f17a4690ff5359f61d43004ff6b3
        let mut serialized_byte_array = array![0x4, 0x0100000001facc3e9417293c5112fb492939cfa3054c105d6502cc70dbc6b8, 0xd5d37a4c4e8b0100000023220020106b91d42533783388d2f4003672e52010, 0xa0e5d5ee6a80e11bd1642c2ffb8497ffffffff02049d2700000000001976a9, 0x143d4d0be2adf7cd3b5f7b5905f3e85f3211d5eeef88ac9bf9cb0600000000, 0x17a914c78878c6ff55f22ea1f8ae564d3203c8015e1b2387e75f0900, 0x1c].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 614375);
        assert_eq!(result.get_hash(), [0xb3f64f00, 0x431df659, 0x53ff9046, 0x7af17923, 0xc5276369, 0x2f9cc45, 0x66d8d5cd, 0x5969d6d0]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xfacc3e9417293c5112fb492939cfa3054c105d6502cc70dbc6b8d5d37a4c4e8b, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x535129ad3183f3a12f4b2ac118e8c882125578d05e59ad90353eb7364689524);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 2596100);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x360b68a305d05970ee9ac4ccbdc0280c437453f3a1923063aed3d884481ad9e);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 114031003);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x2a64e5e1c83418913f4c205cf82561db80d92bdca10a25b2b3198f26c826315);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 8b4dc9db0bf26cebcdbbdc8f4c62cf2e5c9a1f09d61995aab57cd0ed6e60a686
        let mut serialized_byte_array = array![0x7, 0x01000000015f9c6442ea17e6d624ebbc2f75bcbee13f145584e20323710c06, 0x936372e77148000000008a47304402207f9cbeb3ca9fdba9c119e3d7c9d242, 0xbdeaa95756e4ce9e78228e5e9c31727d5302207a488fcff3f90a41eb14f185, 0x9b4d048f456ea4452c20f2a49b7ef50cd7efa2e9014104dec5736663b99956, 0x45c4ea01ad337fd3703d6b25f6c4aad95771d069147e946dcf1fc7daf7bc35, 0x80263816b1c2b551978d61f065f4efa3d933aec2e1779c0b65ffffffff0140, 0x420f00000000001976a9148b90f095d932e4de0e7453b488ad8b0cb0738368, 0x88ac00000000, 0x6].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x86a6606e, 0xedd07cb5, 0xaa9519d6, 0x91f9a5c, 0x2ecf624c, 0x8fdcbbcd, 0xeb6cf20b, 0xdbc94d8b]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x5f9c6442ea17e6d624ebbc2f75bcbee13f145584e20323710c06936372e77148, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x2bf73d9f224fe30603e685e326c85a4a80f7e9838699bb8bb0791c2e9e7b217);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1000000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x2579dab4595c21def982b88516d29a64beb258568ab5c0e999ba2eed771c94c);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 3cfd637b3c61f34abffb1e87b67109073db049d216122690cc92139e098c67e7
        let mut serialized_byte_array = array![0x6, 0x0100000001ef702c69a16052a96556f94a0ee4ac1eb129b9ffe57e166e88f0, 0x9c21fbdf56550c0000006a473044022055a4d6847d5ba7ea048a595073f08b, 0xef67700c2e75baa82de971e79035fe871802204bebb53efb2aa4f319a49917, 0xd9df605d7d108305294c9404bcea8a8701ffe47c012102c815c9932d4e8ad1, 0x5bcb42dd09c5a1d5e1a02e6684ac0e67cc00107cc6f5a7d4ffffffff01f0b2, 0x2901000000001976a914baf3022152233f4d6f17ac2e6673ddc6850b28ba88, 0xac00000000, 0x5].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xe7678c09, 0x9e1392cc, 0x90261216, 0xd249b03d, 0x70971b6, 0x871efbbf, 0x4af3613c, 0x7b63fd3c]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xef702c69a16052a96556f94a0ee4ac1eb129b9ffe57e166e88f09c21fbdf5655, 12));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x69a69c22ab2ccb83be9e52a3b364ce915f3bef0ad22068b0c1854871f7969c8);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 19510000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x7c67064533036fc2aa0b994c9c6d4278ded2702086a10f1d1965c5d649c6b4);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: ecb818057df2b8be173d1cb039589c3a7ec3a28c0a924c435143ef1de2ee326b
        let mut serialized_byte_array = array![0x8, 0x01000000014dbbbfa74cd0844c55fa8073a1469fb8abbd603bd9d3ee855025, 0x442f1547e58a050000008b4830450220486213914f1f63a4263558144b0c87, 0x27381d88a9329db1bcbbf6c742eb5ad41302210093ba5f28ddcf9a37472cae, 0xea1f52cfadaf66fdbe089fab0654776fd63bb5d0d0014104eee31f6aaefa45, 0x0ddf2f1ded330524895f2f254035db9c6ab64c49220b0e2bf294f4283cb3dc, 0x803e2237978e1eeafe7e30543a8ac84e855b1313799f7752b63affffffff02, 0x3d080400000000001976a9144a6ecaa50b1221c4ee4466ffd7946584ebeb11, 0xfd88ac80c8b308000000001976a914cbac0e723831cf816fb51a7be9a07d22, 0x597f9fe888ac00000000, 0xa].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x6b32eee2, 0x1def4351, 0x434c920a, 0x8ca2c37e, 0x3a9c5839, 0xb01c3d17, 0xbeb8f27d, 0x518b8ec]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x4dbbbfa74cd0844c55fa8073a1469fb8abbd603bd9d3ee855025442f1547e58a, 5));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x6481c5a3d846354781f2dbf35f7d02c214e08798e93572ba555e7f79348e8f0);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 264253);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x39f3a9007aadb830f97d31929b1f01aecefaf26f47c5365be0d6c9126ff5f7e);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 146000000);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x2a6858b3ff5ecb29e7262f8a8c1e71f210797822bed7ec585d8d41f16e7fccf);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 04c8d5b90bfffedf93cf87ee9f0887cccb53fcb4efbad2503e39af28cc61c492
        let mut serialized_byte_array = array![0x8, 0x010000000140db5246a3dadd9dc65af5b75284ebea14e232381c809c008734, 0x2c487758b458010000008c493046022100f1bd3ff7507aea4488c383e5f453, 0xde475edf7d73fb45325f64fc786ef9804019022100b782c066b910ff09c539, 0x9aca128a275bea8a2322712f34b2974ee4ce94c851e6014104d63921791a54, 0x30e659e2de127c8cb6025fb628a82ca2551f3b123935d2b9057a5b709ed26c, 0xd70c6db366d5a15fe5e6910be15d3a35b60673f7f1a18907c79f61ffffffff, 0x02628c6600000000001976a914f49757c333758f9f1784098594b1796670d2, 0x65da88ac05720000000000001976a914a4dfc6f41b29aced9d5f5b7bd76e38, 0x9cf152930188ac00000000, 0xb].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x92c461cc, 0x28af393e, 0x50d2baef, 0xb4fc53cb, 0xcc87089f, 0xee87cf93, 0xdffeff0b, 0xb9d5c804]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x40db5246a3dadd9dc65af5b75284ebea14e232381c809c0087342c487758b458, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x55582106ca158d24f04b5990343192666184569465fbaf9bf15b7cef04177aa);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 6720610);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x21a6dcdbdaea01cdd239514bed273156d7a61c9eee8a947c5cab87c6f54e352);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 29189);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x3c4732ea1127142c21fcc1ad95f0e150317e8a5f2e8317f462c9c9c6b29f7ec);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 63392f036a320d778385bea2eaaf2b3b787dd10ce41178ea3c708e825e0f8f79
        let mut serialized_byte_array = array![0x2, 0x020000000118c0442d4b63eed0b4837cd8df4e8102878ea2d3abe30980c6d3, 0x9c29572df1cfff00000000fdffffff014a010000000000001600142fd0aea0, 0x7d7f3d87dfcb4ba12edcb59bece9a4e500000000, 0x14].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 2);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x798f0f5e, 0x828e703c, 0xea7811e4, 0xcd17d78, 0x3b2bafea, 0xa2be8583, 0x770d326a, 0x32f3963]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x18c0442d4b63eed0b4837cd8df4e8102878ea2d3abe30980c6d39c29572df1cf, 255));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xfffffffd);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 330);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0xe2e5823deac0ae4c2e15503613fd77c6c655362d11f8170001cfbf8f547606);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 2ae76bea47cd703161187dcedd95fe113f0cfe20288526871492c79a24335c53
        let mut serialized_byte_array = array![0x3, 0x01000000010000000000000000000000000000000000000000000000000000, 0x000000000000ffffffff27037e44061a4b6e434d696e6572422d5031efde43, 0x486549963e572eafd60181b50600009b6c7200ffffffff0100f90295000000, 0x001976a914e463d09f315714f70f88bcb5523623b87a92730c88ac00000000, 0x1f].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x535c3324, 0x9ac79214, 0x87268528, 0x20fe0c3f, 0x11fe95dd, 0xce7d1861, 0x3170cd47, 0xea6be72a]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x0000000000000000000000000000000000000000000000000000000000000000, 0xFFFFFFFF));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x4767e1ffa72cd6b9fab0c9d57ebc825261cb159c75272eba8c0656afc5b0015);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 2500000000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x1d1aa39c6b9f7e8429172c119212e41aa25c8e569e2bedfc0c6d7d8ac73be8b);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 32ffbfa736bfa81aadb7cdaa122fa575c30a527f0fd1fce4d40e3a0f14da62bc
        let mut serialized_byte_array = array![0xe, 0x0100000002bc031a75bbb205447b04bbea2b06a2eeeb22a7cf3a62f113c938, 0x66fbef289a38000000008b4830450221008f91ba2762c842e5ceb0e97025b0, 0xbbc7255f26e0c4c8110f3a843bf6998a373202205d9659413bb58f362e49bb, 0x12dba12bf981041c32c17a477d9b3602de45fa70c701410468ff50f176ae29, 0xaa8935fa2015784eea19ea7ab2538b64d1c6b3553e937e22dc8bfce95b703d, 0x74de3ebbbae381284fd091536e1d96f5aacc5c2ef54b347e2747ffffffff8b, 0xbb1404212362a49b2672c75064379dadb21a31d395bb512f43e309c478ad66, 0x020000008b48304502203ede2d0ed3f2b10000a02fee11e2e2adbe5fc80a55, 0xad99b3d0251f13e32859d1022100f25ecf5ea941bf0593e50ddb9c64dc2610, 0x7267706580d425fb9933ee9173224a014104b864110adf6c0adfb86e85bf33, 0x6c312bd8b29d0374273bb5939670acd7296c1f7bb98b0140cd263ea92f3bd1, 0xadaf42e6fc81c98752d122330342fddbc4ca635bffffffff0200321b080000, 0x00001976a914cdcfba3d307b9bee3a8d9048517fac27d5801ebf88ac0ca615, 0x00000000001976a914cea51025089553c9efdb2cc02f6dc20e3ed5d63f88ac, 0x00000000, 0x4].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xbc62da14, 0xf3a0ed4, 0xe4fcd10f, 0x7f520ac3, 0x75a52f12, 0xaacdb7ad, 0x1aa8bf36, 0xa7bfff32]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xbc031a75bbb205447b04bbea2b06a2eeeb22a7cf3a62f113c93866fbef289a38, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x8cf50ad1971f4db60fde85866deca6d69400fe6d4a22a68a0a33d4b8f70c42);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x8bbb1404212362a49b2672c75064379dadb21a31d395bb512f43e309c478ad66, 2));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x4f59eff2320a62cce3e8b9ee6c795fb6503a2082e1b080f85c2ba8253f15b32);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 136000000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x7424167b33ec475f30bb62ec70c37238930b4b3e8436e669e09772aaf7ed050);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 1418764);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x565dee2bb5318691a6b1ddcd298ce0a99cdabb60ec00b697e2ed3c39e5fb918);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: dc7e0069ef3f9b877f55525c172809d4ddd3ccdf835543996eb6b81d8dda1c8b
        let mut serialized_byte_array = array![0x8, 0x01000000019dac649924830700834e1224bb212f8641822d8e567a7f772c25, 0x2e626c22ed2a040000008c493046022100ea7ac4770aeaa74030f6868ca8ca, 0xd9cc03547239c07c3b3cf5a5fb70ca2789de022100f19a6c4804a33c22b83f, 0xb71626d91fc6c1f85adee9cf41226490c24f8d63355b014104fd0d0fd73df5, 0x8531a02b1f0f2d33adf5e57315456f463fc30bd72d9c4bc26402c00d59d36a, 0x324110374ed956591a85f0e5856d8be1ae370ca3bf5f582a41293affffffff, 0x02df194300000000001976a9149bb26b3559686270d0aa2a125d9965a968a3, 0x56bf88ac902b5100000000001976a9149431f4d8aaafb16caa625468510228, 0xe0cbb2933288ac00000000, 0xb].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x8b1cda8d, 0x1db8b66e, 0x99435583, 0xdfccd3dd, 0xd4092817, 0x5c52557f, 0x879b3fef, 0x69007edc]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x9dac649924830700834e1224bb212f8641822d8e567a7f772c252e626c22ed2a, 4));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x5201e543a0cd53ed9ab585effb994e10aebe1df2967915c2e4bf394e7561833);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 4397535);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x55a0c4f867c1b264aaaf727f163ee59f324e15ef0046727a776ccd97addcf79);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 5319568);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x692ae711746a5b1f601ed89a9847fcd1557e0d862d0a598a37458cdbe52661b);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 61ee14f2ee9cae659e0744e6ed66ea7e52d65af33b4656729a06773df4fa0282
        let mut serialized_byte_array = array![0x5, 0x0100000002fc09db1b7274fcbc4a5043e6ed7f863c336d5e7121afab203535, 0xfb9737c06db700000000171600145193b02143f073741e0848ff4e23ca92b0, 0x16fb97f0ffffffc77e6d2e0da4f4ba66a0b3b651aecd7fdc17d5cd81ac4e94, 0xc231b929aff5a8941400000017160014421a852034591ec7c7b090b4250a79, 0x0f4fa40a83f0ffffff01824b00000000000017a914423877331b30a905240c, 0x7e1f2adee4ebaa47c5f68700000000, 0xf].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x8202faf4, 0x3d77069a, 0x7256463b, 0xf35ad652, 0x7eea66ed, 0xe644079e, 0x65ae9cee, 0xf214ee61]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xfc09db1b7274fcbc4a5043e6ed7f863c336d5e7121afab203535fb9737c06db7, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x4ad2ea53d7255a0fc6f333ca51a5595412ede2144002df07c3f05dec98fc1f4);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xfffffff0);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xc77e6d2e0da4f4ba66a0b3b651aecd7fdc17d5cd81ac4e94c231b929aff5a894, 20));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x2371b58a0e20ba34c68b03c85c8316fe296835880ccf363f87ed97302aff613);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xfffffff0);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 19330);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x60057095454b7cc040c122a3f28e1dc5c3ef83028161fbd039da471766c4f5f);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 4b6d7e73cd6a0f9ff58cf0f2bcbed7f36f16b40e612133b0b4f84f00b41f83cc
        let mut serialized_byte_array = array![0x7, 0x010000000135cfd2e4139e23e8f011943e147be94d36c021c2b2cb0bb40c00, 0x2645da7cfbe0010000006b483045022100f51426976b9ea1f6be76df7689da, 0xed5b6c7f452efa5bd79ac30e15420276a87e02203a273baf75dc300fe2718c, 0x53fd062b6bcab6de37a627e33dcdc45096b07d2d5a012103eea87ab7bc195b, 0x64ac88165689fd9d9215b3ceddc9e76eed2f4fd864124853f0ffffffff0243, 0x795400000000001976a914aff854ee4bbb0bdd08f2b94457373f2aceb7fe56, 0x88acea48515a000000001976a914e9774104fd92b813979d13fbecd270219f, 0x8af2eb88ac00000000, 0x9].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xcc831fb4, 0x4ff8b4, 0xb0332161, 0xeb4166f, 0xf3d7bebc, 0xf2f08cf5, 0x9f0f6acd, 0x737e6d4b]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x35cfd2e4139e23e8f011943e147be94d36c021c2b2cb0bb40c002645da7cfbe0, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x4a6cdfa20514a8b7c2baf3eed3546c3098bc7a626a73b203b722cddda795695);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 5536067);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x63a1e7921138214abe88c2da1df64c616a54a61e0449180d3fded2d1a9565ce);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 1515276522);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x476c2794b68c7afe81b35f31011c8a4eea60014944d7e3fa981bd5e73401972);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 4b8ecf647aa2588e758f759929a945b2b266c6c01d756eaae022123eb9b5415d
        let mut serialized_byte_array = array![0x8, 0x01000000016fb2ab8e93f8df511dd0d51f314aa7952682f9478329029d7a93, 0x186b557bfa9d010000008c493046022100b4f38a5fc191047f56706545d52c, 0xc0b217bc556f0cc11b759f296df86789fce4022100e63c490232cf39b51007, 0x28b367d89535689b8e403141d82eb7fd31aff9ed62cd014104d22b04320342, 0xb9271dfca8f38d88d8578c8b5a8caa39eda2b8af76428f725d05ab776eb30d, 0x807d39c39002778281a96e9d7ea0f7f91140c05a88293cce6b5174ffffffff, 0x02808d5b00000000001976a9145b7f2b2aaeead1c438cc39d0468a51727334, 0x7b6388ac60974770000000001976a91449cd69cee784a16ea8d51a0a41b025, 0xbd011d64a288ac00000000, 0xb].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x5d41b5b9, 0x3e1222e0, 0xaa6e751d, 0xc0c666b2, 0xb245a929, 0x99758f75, 0x8e58a27a, 0x64cf8e4b]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x6fb2ab8e93f8df511dd0d51f314aa7952682f9478329029d7a93186b557bfa9d, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x5f34b91133a1903f96fa0ce76d44a4e46c0adb1b78fb50fe165216daed0353f);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 6000000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x78188215d50299ace27615ba3b64d5a3ce496ed27d6a3e20e8200c67d907363);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 1883740000);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x705d55ae13e7b30cbbb51c956d4248b081cbb3fea2dddea0eb7bbbd879dc63e);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: d262014fea8c25655ad6f061c872f919cbd695cd3ab30a9dc8bde4dccd10679b
        let mut serialized_byte_array = array![0xb, 0x01000000025eedaf9c234a95167b763fbfba8af1258e07a65c71eb1cf568a9, 0x8e26735c0f51010000006b483045022100eae698915e93f08941518f8aced5, 0xbb2b09d25796bb7de864b716675a1581ab1e022029a8cf72d02f58c1104561, 0x3ee24de377e9d5e824c0bf822c9931271ad5a412040121027567e91e52c8a6, 0xaa07e55704d96d9930f06f6c9439df73330d1d531c63337d8affffffffdd9f, 0xc8d152507bcaadb39b7c3f58b6a6aabbc10582882f7cb67ceea590eec3c101, 0x0000006a47304402205eb081b9d4e06262cec1012c30fece8a9076a2b534df, 0x617efb81983b7c9cba0202204e3e3de6f78ec90b86cb70a38df558d9fdd7d2, 0xfaf311086f6835214ffb12b38c01210351183422828a6375a4e9dc17b4db94, 0x8984de0557d8442b9e3d80361ccf261c27ffffffff02357b13000000000019, 0x76a914b1aaafd95f394b277638e4a47de6335884cf935d88ac78e677010000, 0x000017a914bdf596c3ff9eae43e6ccd74e0cef2f6b12cc8b6d8700000000, 0x1e].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x9b6710cd, 0xdce4bdc8, 0x9d0ab33a, 0xcd95d6cb, 0x19f972c8, 0x61f0d65a, 0x65258cea, 0x4f0162d2]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x5eedaf9c234a95167b763fbfba8af1258e07a65c71eb1cf568a98e26735c0f51, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x1c3bbe1c9227dbc1f22de0661202108f1827ba39f0d8822fbda336af44812d1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xdd9fc8d152507bcaadb39b7c3f58b6a6aabbc10582882f7cb67ceea590eec3c1, 1));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x34bd71d7268f4ef3a7173ac8e9ef676b853afbae5d41301983d684e9b7219f);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1276725);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x1554bbf6ec61d07cdc71da4a083a03a73d69cf484b72cbcb019ae427018f0fb);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 24635000);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x28563bbc7144ab5c25b037c91c94c320fd1760fefea442ba72468541a890634);
        assert_eq!(result.get_out(2).is_none(), true);

        // Transaction ID: 47c03918820d76420bd010370a33d4423c9eea6b2ada9ec3907eda3613006d30
        let mut serialized_byte_array = array![0x4, 0x01000000010000000000000000000000000000000000000000000000000000, 0x000000000000ffffffff0804ffff001d02bf02ffffffff0100f2052a010000, 0x0043410476ee5e6ae615bf976be16e165146a3512e8a0bb528260145706d3e, 0x133064241d224b1d6796633b66c320511ca8caf943d7f2daae72b5ca4b51d5, 0xc1d987a364baac00000000, 0xb].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x306d0013, 0x36da7e90, 0xc39eda2a, 0x6bea9e3c, 0x42d4330a, 0x3710d00b, 0x42760d82, 0x1839c047]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x0000000000000000000000000000000000000000000000000000000000000000, 0xFFFFFFFF));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x47672f02eab5391f1394f55414e1e23ee8538126d827f2c0261ae4240187fde);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 5000000000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x18e24203892a8415af23a5dd6dea542c4430c23b14c07da9bc8482ae267fbbc);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: be5ef02f3af4d16f2f0891de6a4de4cfaa419ea38f5ee0fed129a6797cb5d3ae
        let mut serialized_byte_array = array![0x2f, 0x01000000080220b2047dbba385186cfeb4ba9324a344d7931c5e2e3c35530e, 0x9f826ff497efb40000008b48304502210091e5810f329766aeef5397db99ab, 0x986d557c87115b2ede96ef72f04eea269e63022012a2732af79181d5504900, 0x42e3f53502cb245bafa425e88f1e4fc1c6633e54860141045f4d3b60c8726c, 0xd434825bda31b66b9019bbca3688cd8ef4029cad8f550fd08b7185764a418a, 0x52b05905f3ba28e27713a00b415e11f505d0360eeabc5d675ff3ffffffff3f, 0x0f6a1783fa6f70fe618257deadd2779a8e02e364ebd9298df0a476a7724558, 0x0d0000008b483045022100db95fabaeb6e672f16dc94d00bb0c8cbd700d212, 0xef9efbcf02fa281ccc70c4a4022069bf97acf532b5c08771d6333e2fc9626e, 0x04d3484ac927e11729b544f80c8739014104619410e8a35e9d471a77cc928c, 0xaacaaf11389f95c558863a398edeba6c995a893b06720d9eaaa1a9060406c9, 0x780b411f0c1fb104f2e817ed4a184bca8d34f21affffffff40e77af91ab43c, 0x7a0777584b0195c37fba6deb4dc0cbf3a2ffebd7e86c5ac94f090000008b48, 0x3045022100a73788f1cfb718b8488c5e63c309bc9f723fcbeec434cefe3a24, 0xa704be2075ae022044ccbacae66d4ac036fae67326b9405eebbad757990fef, 0x3bb5e42b7d939c8bbd0141041ab31a4ff7d06d988fae588e76ee7a619c5353, 0x96396721be80db8943d0f29bb0ee24fe1e6ccfe9de0fba8934338a3b1cab96, 0xb8db763e65b053a898f7c08fa666ffffffff1d1b8a2670be8148ba7e728a49, 0x5bc1cfbc043e47c270c2ce91124dd2d69ec5180e0000008a473044022024fa, 0x10c43b5842c78ab2eacdf3212fc72dbaa83e22ee1d2f7c887d6b1108aedf02, 0x206c5a3ca73883cee34b6cfa7872602703682c785e43879faf25458c8079da, 0xa8a70141041ab31a4ff7d06d988fae588e76ee7a619c535396396721be80db, 0x8943d0f29bb0ee24fe1e6ccfe9de0fba8934338a3b1cab96b8db763e65b053, 0xa898f7c08fa666ffffffff65a00a5f20f2e7b37e2c2cdf54536b999c9970f7, 0xc6ac289a2d0be20c13127bd14e0000008a473044022007c9be858c31e5c800, 0x0e7a37c39c7d5e45a9f7fc28f926e38999a8f44f44e8b802203e9a871df178, 0xa721f2f861502cc7f1ec9dfb85d8a7df90079b50984e5539ca66014104415a, 0xb99ed3104c362854c9dec35983ea29b2c1e156021c52f1a920d9fc8c4532b5, 0x3343629085c8fa6e1d14dbc2261cafdd8fd7912d830700e4a685798bb9299c, 0xffffffffc4a350e892575548a5601df27402305700e9e4552518198457b6c4, 0x090eec490c6a0000008b48304502201e187c24ef9b3d6e9fdf6bb500844862, 0x725dfab24ffbb5dd633d32008698647f022100c51c18401e522891e3f9d1fe, 0x64f6b8d005a9ba57113191795910a2a8038e02a5014104415ab99ed3104c36, 0x2854c9dec35983ea29b2c1e156021c52f1a920d9fc8c4532b53343629085c8, 0xfa6e1d14dbc2261cafdd8fd7912d830700e4a685798bb9299cfffffffff049, 0x4c7e1584994f941878f7747cd575ec04eeeb0e1acd0b226a70706a3005b50c, 0x0000008b483045022100bdb1ccc6e0dd036dca3a9cddb91e43a97fee5de877, 0xb5b9fa25311dd9026ea80102201bd0012b15a40bb01f8c40080c6ad58eb29e, 0xb6e4ef9643942cff6171607729140141041ab31a4ff7d06d988fae588e76ee, 0x7a619c535396396721be80db8943d0f29bb0ee24fe1e6ccfe9de0fba893433, 0x8a3b1cab96b8db763e65b053a898f7c08fa666ffffffffda2300043eef6d39, 0xc1976cccfe7cb3f55512e5976a7218124807a371c8b66f4c0c0000008a4730, 0x4402203a8ebe146ec5726d23aed733f8eb67a5ceca8f70323f7ef3537f0b0c, 0x80ff7a6002207c4fbdf7e4aa444f0e455232cef5ed7e3abf592e04a70090ad, 0x34ad4287dee8530141041ab31a4ff7d06d988fae588e76ee7a619c53539639, 0x6721be80db8943d0f29bb0ee24fe1e6ccfe9de0fba8934338a3b1cab96b8db, 0x763e65b053a898f7c08fa666ffffffff01a4060400000000001976a9144644, 0xf8563adddcd867a70e1b335d1f38e44f731e88ac00000000, 0x18].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xaed3b57c, 0x79a629d1, 0xfee05e8f, 0xa39e41aa, 0xcfe44d6a, 0xde91082f, 0x6fd1f43a, 0x2ff05ebe]);
        assert_eq!(result.count_ins(), 8);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x0220b2047dbba385186cfeb4ba9324a344d7931c5e2e3c35530e9f826ff497ef, 180));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x6f8f294bbb693ac90d499a74c0ff9a67222fecc377d5a42f29ec93d8a0dd211);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x3f0f6a1783fa6f70fe618257deadd2779a8e02e364ebd9298df0a476a7724558, 13));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x1da2e0a7c8f476c14f32e777c05987268e8cd43e3b61f744fdaf66868d56bc9);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0x40e77af91ab43c7a0777584b0195c37fba6deb4dc0cbf3a2ffebd7e86c5ac94f, 9));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x16f0c292f4f8c5dd5f1604bf7d17b09bbac422f98e84a163c316a286bc7d171);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(3).unwrap().unbox().get_utxo(), (0x1d1b8a2670be8148ba7e728a495bc1cfbc043e47c270c2ce91124dd2d69ec518, 14));
        assert_eq!(result.get_in(3).unwrap().unbox().get_script_hash(), 0x26c62039e01082fffd80cf14b0547d2742abae3f69b45ba12611f0171e45ed5);
        assert_eq!(result.get_in(3).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(4).unwrap().unbox().get_utxo(), (0x65a00a5f20f2e7b37e2c2cdf54536b999c9970f7c6ac289a2d0be20c13127bd1, 78));
        assert_eq!(result.get_in(4).unwrap().unbox().get_script_hash(), 0x672acd49ecfc4d903f491942d75a0d9be010c8a6b4989d5e08246f085480c70);
        assert_eq!(result.get_in(4).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(5).unwrap().unbox().get_utxo(), (0xc4a350e892575548a5601df27402305700e9e4552518198457b6c4090eec490c, 106));
        assert_eq!(result.get_in(5).unwrap().unbox().get_script_hash(), 0x4b6cea6a3418717e6b7636f89983674db95f1ba4f1375012a35b93cd3119485);
        assert_eq!(result.get_in(5).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(6).unwrap().unbox().get_utxo(), (0xf0494c7e1584994f941878f7747cd575ec04eeeb0e1acd0b226a70706a3005b5, 12));
        assert_eq!(result.get_in(6).unwrap().unbox().get_script_hash(), 0xe6776e845dbea9897491f5eebf32283c2457ceaa987f8f4fee01517307e738);
        assert_eq!(result.get_in(6).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(7).unwrap().unbox().get_utxo(), (0xda2300043eef6d39c1976cccfe7cb3f55512e5976a7218124807a371c8b66f4c, 12));
        assert_eq!(result.get_in(7).unwrap().unbox().get_script_hash(), 0x54a6f9033098395dfbf37842f702192dc196b35ff0ff1796f2b81a1759cc5b3);
        assert_eq!(result.get_in(7).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(8).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 263844);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x748bc6e6c78f7b05e761dac4095cd401d216453bb5936711dc019bbe2afe0a6);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 4851579aceb348470109a3cd1af1940f4c8475e5c6441c3abb71e04d0820d80d
        let mut serialized_byte_array = array![0x2, 0x0100000001839adf70a1f5189cfbbd4cf94c38303bb29e715d34ccf27747ec, 0xfcf0253bbcc2010000000080e3ffff014ece00000000000016001438eb9621, 0x952548d214c782d8d82318c44f279bc800000000, 0x14].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0xdd82008, 0x4de071bb, 0x3a1c44c6, 0xe575844c, 0xf94f11a, 0xcda30901, 0x4748b3ce, 0x9a575148]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x839adf70a1f5189cfbbd4cf94c38303bb29e715d34ccf27747ecfcf0253bbcc2, 1));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffe380);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 52814);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x7d8072f3aad24a09d58029b6bf423d5165cff4cf09d9a55ef36cb95934eb98f);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: a668d8291966fda4edcaaaa96f68b02a1d77f10f82a9df8516a9591f42d48b09
        let mut serialized_byte_array = array![0x10, 0x0100000003b8a3d9452e670abf95fe701346e10ac870d3c7d47cf05abeeecb, 0xe139118af739000000006b483045022100ac238449e25637675322bc6456ef, 0x282f68446f82f8a7a5572e3c040393315c67022076fe67229475b0f0f53768, 0x4e0aeaaeac0055133334b6afa01235b81dcef407aa012103afd34045d7080e, 0x5f3d8fc0efab187951caed4b06571c7cc617d01d9abe8b36b5ffffffff1375, 0x467adef0e430bf89820fc171e1ff293287e159e815f5f3ce009e53f78a1700, 0x0000006b483045022100832e2ed8e8f77c02c1723d84ed0513bcaadc4a26d7, 0x744f5ba68b21857f6e9c2c0220340c11ec8d7653acf03e93b2437b590570ba, 0x23020dd28a90728d00a9a5f46814012103f53c59c6119fc8584763dc3ae50e, 0x10c0dc71573cde9a4c80497d037592241e17ffffffffb611af0ea8823fbe9a, 0x21963bcbc9921deae51b8eee1dcdabf918e6fa242ab11d000000006b483045, 0x022100fb620731629a9f4fbee57e7264db44dccf055c94cec8fe120152e647, 0xf5978d5402207ebb2d63d10060fc8bf6eded0bcfa5efed098ac934bfa0449b, 0x2684eeffd65029012102192c62062f08ebbf621a1dd691e70ea2404759abc1, 0xd0192a33b35a39bbeca87affffffff0278ce0400000000001976a914732466, 0x063d4c511272443863045059c74105c6e188ac80b92a00000000001976a914, 0x2506b48887f593fa5a9b7afc1a822077526ef99b88ac00000000, 0x1a].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1);
        assert_eq!(result.get_locktime(), 0);
        assert_eq!(result.get_hash(), [0x98bd442, 0x1f59a916, 0x85dfa982, 0xff1771d, 0x2ab0686f, 0xa9aacaed, 0xa4fd6619, 0x29d868a6]);
        assert_eq!(result.count_ins(), 3);
        assert_eq!(result.count_outs(), 2);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xb8a3d9452e670abf95fe701346e10ac870d3c7d47cf05abeeecbe139118af739, 0));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x76a818d8f268d151663780e76ebf0e0bb95085b8e630f23b7f06d9604fb9b24);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x1375467adef0e430bf89820fc171e1ff293287e159e815f5f3ce009e53f78a17, 0));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x61d04a75ca36eea96e081bc485527b10c0117619c8a68184d20b5fe32fc270e);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0xb611af0ea8823fbe9a21963bcbc9921deae51b8eee1dcdabf918e6fa242ab11d, 0));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x18ec3ae6ab9768c57a759a737cb3b2c9faff6d781e63ed6874c5414f60e00ad);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0xffffffff);
        assert_eq!(result.get_in(3).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 315000);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x8dee5cd5fe279558073109afcbbcf1b0f8762f8107498987bb3d800e57dda0);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 2800000);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x2e7cf23f1f319de30ee7cf1a47bb3fa5061e1c826b1b97b8d273aa6a53e0279);
        assert_eq!(result.get_out(2).is_none(), true);
    }

    //Test parsing of ranomly generated transactions
    #[test]
    fn test_random_txs() {
        // Randomly generated transactions 

        // Transaction ID: 9e2435b261da09f3ae77c4fe6c8ebb52188c62c4a201ac17c5b8f8bf263ae694
        let mut serialized_byte_array = array![0x10, 0xbe9cb22301387b14a3d1dd1cd13c401c4c40bc75d821b92ee9639501c49404, 0x1dceb5d88764c08b2981fd24018ec202449cdefb165a856ba7be4b6cc40956, 0xd4eac57db05ed092126b44093c1bce1f65c50bcb7f274d8765ef6ecb3afddd, 0xa4dafa1d8f0461f992e585bd2bfb7bb8a03faa628f5e68193d038362ec086b, 0xa48151dc274601b3d29317fb5fc99253e451bed86c7817f4d6432c90f8118e, 0x82901619df79ad9a38be1728eaa9a355bd47416adf6095f0d86ba08bf8185e, 0x8b341b2a999eff2f9991ab900cc3f148225701a2b35ead448512be234f465e, 0xbea3b2bbf0989d6bde1f70bfca3a96c682e60fb2a50d03ca754a2a77106b01, 0x894f3127091519a94500103ec0f150743eae985eb8f7a709e73d43bd27e13f, 0x8e0a112f6eb78718ef58105624d2ab0c9a3cb162dbaa449d67a3bcf1e4e0e2, 0x753d2d5c654fd40531c753c5ad6347a68ad27d64c9742b533d926364bb9605, 0x1366d73328ce01001dda47a14f0a11cc5391490a94e13a5e7b86678edf1b9e, 0xbed047861bfc45b66ebe3c04fa060034987f84300235cab230c6d00b68f3c7, 0x282465bab8c93f9d6235d016f867c7240e5963138f2d7b6053430dbb890826, 0x1cc7e82a3ede578600c9b00204001c10d746fbda195b363935a604d7aeb82e, 0x5da8ebe4d9cf2f62ff15ebb18809319579bf00000128595dc4c737dc05000c, 0x121b9e80d631ea1ae1aa8c6bc5ad68e3, 0x10].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 598908094);
        assert_eq!(result.get_locktime(), 3815288261);
        assert_eq!(result.get_hash(), [0x94e63a26, 0xbff8b8c5, 0x17ac01a2, 0xc4628c18, 0x52bb8e6c, 0xfec477ae, 0xf309da61, 0xb235249e]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 5);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x387b14a3d1dd1cd13c401c4c40bc75d821b92ee9639501c494041dceb5d88764, 2166983616));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x3353b1ed8581c9645206129350b06ebebdf63a99c3373692aaae0ccf13cfc2f);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x96bb6463);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 508147040478739);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x3f3d57ff0e025b0b2bf244bb350399fc2e30acd82e4ceaa1fd464b358e36bf4);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 1963745966190262);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x713a50535e394effa573893be75a3b2dd0abe1ff5dc49fd3a85c059ed822dd5);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 1128858216597079);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x47972f1461221805291d97c12a33b20457cf9bd43084bfe6faea3b2f50c42f);
        assert_eq!(result.get_out(3).unwrap().unbox().get_value(), 210528914966920);
        assert_eq!(result.get_out(3).unwrap().unbox().get_script_hash(), 0x69d7d9746444addb2578db54257fee5b2ace7773be2545b58c69455b9b92e65);
        assert_eq!(result.get_out(4).unwrap().unbox().get_value(), 1649507016400217);
        assert_eq!(result.get_out(4).unwrap().unbox().get_script_hash(), 0x75a4ec3f74a00dc068072f2030dfa7f257ff23a3b612436f38b4d7b75f932b8);
        assert_eq!(result.get_out(5).is_none(), true);

        // Transaction ID: e3d446616ec8a62fe6af67ed744073c278b60777bbf883241143af8a4cf80fed
        let mut serialized_byte_array = array![0x24, 0x665bb628032b9675e9a2a11f9215885e4f5425df6fe1c6ae663f48f5b07b4d, 0x40985be9c6eac02fb8c24fd8c55c880f08548d77e549cc24c3e04e31ef5f7d, 0x85a650e7743199520a8aadd4822b17776c906635dc604a172d9b39c0055b0e, 0x3cb5e0e04924fe7f47bdcaf9632ad3cb62fd832e427d238dd9244a7136d33b, 0x2ab805029430acb6f31a7b7e400834899633280f6d595dfb023403edd5ddc0, 0xc94f97c06246fddf01bd709b8f872c56825badc6c4e1d8cef4462ac7c0a14a, 0x7c267eb071aa0f3a937ed5a0bb90b656073f41aa9cdf906a66ab0f0302c9e6, 0x89ecab289ff90ebccff1bbebbd791bb53dd7921edd4101c47ee6ef5b12d442, 0x55544a9c3225264d295c5e3117ef8197ba43b233d0b4268a5366d21eb8f046, 0x198d52af145add847eb85767ba16108f7dee1623a3ce8fa9f015c733d312e6, 0x561c8f7e235e6a669031a7dceea82c8db41bb365429fb99ef738c9813a5f39, 0x2922897e5fcbf49593e4fbcbcb5f72749d0bc3dcc2b0f256ba84d9ae7289c7, 0x18338c80507b98a9f20ba54162441f372fd025e9d33457f7e712f3f83d19f9, 0x3ab78b0c24266f6e054cf1b71b8548c9ed213ae18e1e0363bf71a63251e681, 0x052a62f9683fdc481a863f299a0fdc29e99312cfa0934f037240d7fd4ae2f8, 0x1fe51ab86cd5d736fac9ba5349e1a5d6204a7fc141887d75beff099010d0a8, 0xdf7c4a66f59b8151f885b4e7906e55bda8231d6c06f95e0b256f3eee5295db, 0xa0ef9a0247a71ee54d42dfeb454eb4d598a8b98e745bd396c19328fccc8c71, 0x57c807a8f5d9cae203f6e5de4adb8ba7a078de67b1a1f5d235f9b125573cd5, 0xaae9c1c40ce5b3fb8352ec8e6d3655f2a2f2a7058bf051c8c13dc8231be248, 0x8a0c7bcb8f1f1f519092d777c02c3343ecacf251bf96197837e0dd7d44e8e5, 0x1fa2daa750d618fbccf9745057af649762de66ff82ac258f8ea651ce09dff8, 0xb6fd7c016e0e5f16c85ffec9442d63f38f26d1c7a0f4a6e9d36d8440816716, 0x9b84b6918e4b5c0987f260a99da00865ef988dbeafebe704657b62c4aa6684, 0x833e79e112308699351fe101d522a41145a871c7074a2535175c1019530335, 0x7677aa4cb598f66be639bc4a193beb13d6f6018381b80c620fac18ea01b0cc, 0xc5735b46374a81b579a088bd27a700dabf22a662565894eb5260389c26aee7, 0x62ead7dd908526841cb6c7773d7abfa60ef9dbcaf154f01c927eddce75b319, 0x7c1fc73529e0b4f289133aff7e9fa7a7aff92a0709f77d4e29e215eb3f3922, 0xb517e1cdce63ca4b9b3ac5e6980befa6ba0371b9577018690da2941870d26e, 0xeb77baf2c8142e42023a39ec78e934088ce503f6c46c4475a19ec17c7abebb, 0xe84f05d2abaa43de24d26144ae76cf946892bbbd7dc32bb3ad877a24e0bb5d, 0xa9b4d87d98b0c0cfb403a1fd27266d32325734ea4473ded8c8b04fb8b453c7, 0x0c280de4f0b094b6c2c6cc0897d5689273089cb9d62b4819c048560acc9ccf, 0x9bd15cd47c361ace43e25ee2dbd992b40184b1eef4fc1a0200245c8acf885a, 0xdbe85fb8bf5f1aaa9d61420a3468ac4fbca6b4f724cd0b950f3f5d769b7bc4, 0x0c067dfe, 0x4].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 683039590);
        assert_eq!(result.get_locktime(), 4269606412);
        assert_eq!(result.get_hash(), [0xed0ff84c, 0x8aaf4311, 0x2483f8bb, 0x7707b678, 0xc2734074, 0xed67afe6, 0x2fa6c86e, 0x6146d4e3]);
        assert_eq!(result.count_ins(), 3);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x2b9675e9a2a11f9215885e4f5425df6fe1c6ae663f48f5b07b4d40985be9c6ea, 3266850752));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x386739483cb8dea6c0b90eaf7084c7faef43f4021cb309f625cd36b12924b15);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x2a3bd336);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xb805029430acb6f31a7b7e400834899633280f6d595dfb023403edd5ddc0c94f, 1180876951));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x5cfb1f61490685b354dbdd59fdadaf2803ba368b2189e260a1ea65681f0f93f);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xdde03778);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0x7d44e8e51fa2daa750d618fbccf9745057af649762de66ff82ac258f8ea651ce, 3069763337));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x7392d24c5955afb071543579ca7a9c2cac18ce9a59cb4bec75b4b8a456f5ed9);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0xb492d9db);
        assert_eq!(result.get_in(3).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 592623696785796);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x478f6b2b90f47ad92c8768125f5073b58e46f063150132624ab8979d6c99e9b);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 8760b6677e941dddf28c8eefcc22c4be8d5b830db05aee9b104c32ab0c23c108
        let mut serialized_byte_array = array![0x40, 0x2c013856051184371a95f81b5c844656c9e231efaaffcce5248e71078ff347, 0xd9894f57d45e0e2195c4fd4601132816c43b80fdbf28c4d0594566737f9069, 0x7fb0a3ba10a1d313fd3f85b2b192a71425f349ca7e40c25649f433f817e4e6, 0x9f7faff245971687d3cb7298ffe568065b6fb1a4409a74f22e63d342017cfb, 0x111c5d70e16fa980b493dff25cf9e0fa40f35d754d3862e7aaae7a31f40acb, 0x592e25dc971935c487ef8ba584afa0678dc1a1dc27bb124e1ff514479f7c37, 0xbbd92c67f37504702b7e44184322ab73626a813c4ba87191b6229c75da7663, 0xc015b46cdf11f0a901ad2a764be49d4e617877c2f9ad9cc2f9f66b5acd8ac2, 0x94843f1340c9169d611c91e2c31162012981f18c2fcf871478c9c5f38dca73, 0x9a88087001ec26bfb59fb0f15077c0ea48991c62dd7130d122f2ecd67f0dea, 0xc2b28a753c1ba7973cd9128bec8b8edbada65d8243dabe9513ed4a054fc4e9, 0xd7a552995b86fb610142db8c89a0982dfb8c5347859a9fe195ace95e8c9045, 0x12e3d6382db0b1cd3df8785ec479960ac6b434f9b3484d3404fae5efcb88c8, 0x375f3a11b68248fda40158ab716b55e10fee574f6466b54e0b83a55b2feca6, 0x3d158db5f99be5e12911f803756567d15c7a9aa7a075bf875590554fe00ed0, 0xbbb30e9e002c9546c41cdd3c459c5c0556c1b4cfb29a9addc0d18fcad560ba, 0x71eeb5954283d7d62e5849285614ea6abf628fc35adc6e3bd6e5e298415bb9, 0x276a7ea68de2dd25113e18fa35aca5a4cdb2d8c93c28ff36f466fb97e5378a, 0x4c55b4131a3d34c3540e143001fd61ea684a78cf91d966f095d7fecb6e7947, 0x27e837f86ca2be727ac607d988d23b0376445b637c8b496b5e859448ae8584, 0x4351b8158259e9b734d88d464db55c2bd5b57681b94c18fe5e4294dcb3fc22, 0x5bf5b1035d092187a6e658f9ec8cbd77ddb04ea640af1c7cb877599fbdeaaa, 0xfcbc400ae9afa7783795c3904b9c8a30fabc0b3e98b114f4521f8afca06a9e, 0x1cfc647d5331017643301058a912e1f65fdb5069a7a22ec6c9c6cb45e8243c, 0xbdaa0cd0dfd6ae5667811b1b46af0f43740cce959258d97b08910923ec3d6b, 0x7c42a47c6aef1fdd0e8ed411aed75955baadf5a9cf40a62221cdc7c74cb995, 0x20183838efdebfa981de0b855bef897ebac3e3403ec34aa4f162017d9636d5, 0xf036dba31f2a029d64e5c514bba4c450c6c74561f859e11656c184a6cc27d3, 0xa77858403bfd9601926833fea003aab75716aaadae4bea5969f79dcbe406bb, 0x245b0badb9afc19b6549061eb7def99ce012653061191ebece9e9366ce74d8, 0x10acc270a00b4903ac1865473e280c7e3f833a2a8f86e2caaea0252f27a188, 0x3d3e3d109b211140f91bfc1239a0cd0016551af2e14a3b8b9b1d9f4828de7c, 0x6216e83d7e0419d40a95c75467a3c7cb1a1e74bf18203c6553af255994b651, 0xa60b48220ef099700543ac613a157e3e6d3aa63ecdf40c181435903e857ec0, 0x298a77503a756b0c056b590b0ad58e8a326f36cdf206bd5ca678e4356f7ae4, 0x9ca298793f86daf740566ec0d40d07737468336da7e7b6dbe3ec3080680c5c, 0xdc88319e21f6e17a64054030e793b416ae5c806e18af285002c9cf2f0272be, 0x85260d0627f4c04b9ec4ad28414e2e925ddef71c03b1edcb3fda86fdbea08b, 0xb2d6ea560bbcd20bb82f429e025d5fe4caaec874c68ccd0bea988c2dae2c1a, 0x216fc7d18a027fabbd3ed0185fbba64ec15925c69f4cd90ec8da720484192c, 0xfdf516bf041a86ab63ca312272cd175da25238bad222e5392296cce5ad0248, 0x09d87a1ca768e0cf26810f84471e2b1d4f9e11373e977da37bda2f7bb58e80, 0xb51d263d88d9ced76eaa82fced619245586a59ccfde201a1e39711bf699028, 0x43ac90bfcedd76283d917581c2394d14f8f56994925d0cabd1da16dc1b8e5d, 0x39d0caac2ba05bf1c11f3fc64207c588c20e7ad1058940473cae0ff2db2465, 0x858d64880e9139c8d958bb4c939cde508b897fd3c2140b1dfdf3c11b295443, 0x9365ac46adb688cd3915ba7ea000d39484c5b6f78007dcfad6112fc11baf62, 0x02f674fc56e8256035f8308c4b84c60139a4db7c30fc5c42333b9ae2513550, 0xa92ee0656517dbd7458e3b9a69712edf9f5c2d8c00b712d87bfba105e756db, 0xb15245b4300d9369b4006e644051bcd085c5a40779d03c38da66cb11bef6bd, 0x8beef46eb706247fc64c0805541fe0d31a4bf09df97215d1f6a9bfccd0c3fe, 0x6daeaefaaaaeee6e1ddab6e769adec2af36cf7c3a9aa5341f678349eb86d68, 0xaf09a336e813cda5af94eaa9e2bc3fb191ae952eef751d171e3f5a589253b3, 0x0990b140f86d4fc5e1dd7c6a9d108c25e4ec3af88da808dc340475b55ec773, 0xe1c1da278a648ae571c187a1ce2cf9fab8191f93054a4c61f592d795414981, 0x002090a6d7ab3a7c7be2cbb94e6c547cb0d0dec8194d03c7436b73ab487868, 0xd825c8120495c80c16f65349b45085e6daaf329428c6c96d40760f98497c34, 0x23e11c2a4ceb5c4cc8078f0ffba2138d084a2d30a6c5de6c6b3e392494e13a, 0x6a7669fae1a39a4cc99794824cb20531ce5e18d930ff3ee5ab19e5dc04c497, 0x110976d680dae1af8ed070ba810d878f7d7e6c12d3395acc422e34e33b93a6, 0xb5fc80b24c2e693c2b621ab13ae1554fbd4c3a8f7aa166c60f4a949a671335, 0x128572220f1379902835282b2c871b22c1df31ffabaad792bc7a7e1a766aad, 0x049907cad36aece5aee112936174f6225814e5dab57c0aca84ad44daf6eea3, 0xb29c10c994deeb01eeb5704b68bf04001fc01d8c00d8a25f3c568243d5b5ca, 0x199bb663c68c1ee22521739e1c55c3f90622d87dc8, 0x15].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1446510892);
        assert_eq!(result.get_locktime(), 3363690530);
        assert_eq!(result.get_hash(), [0x8c1230c, 0xab324c10, 0x9bee5ab0, 0xd835b8d, 0xbec422cc, 0xef8e8cf2, 0xdd1d947e, 0x67b66087]);
        assert_eq!(result.count_ins(), 5);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x1184371a95f81b5c844656c9e231efaaffcce5248e71078ff347d9894f57d45e, 3298107662));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x4ee0d6ca49caebc4bd0e3d1230054ab9b4c7711c0b3a9a17d3988864816372f);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xe3124590);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xd6382db0b1cd3df8785ec479960ac6b434f9b3484d3404fae5efcb88c8375f3a, 1216525841));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x14bc90c5969de961738b929a3018927e9dfb4620e1433da7d552a5ada9bf1e4);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xd536967d);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0xf036dba31f2a029d64e5c514bba4c450c6c74561f859e11656c184a6cc27d3a7, 994072696));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x55f49acd5faf451589834a31aaaa96e9754a0205ca74a9d88f84b024e7513ac);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0x2b1e4784);
        assert_eq!(result.get_in(3).unwrap().unbox().get_utxo(), (0x1d4f9e11373e977da37bda2f7bb58e80b51d263d88d9ced76eaa82fced619245, 3428411992));
        assert_eq!(result.get_in(3).unwrap().unbox().get_script_hash(), 0x6cbcfc66b05a46764aa243a2df19a7bd1c5d46ec77b5e56ee51948a7a9b48b7);
        assert_eq!(result.get_in(3).unwrap().unbox().get_n_sequence(), 0x4c829497);
        assert_eq!(result.get_in(4).unwrap().unbox().get_utxo(), (0xb20531ce5e18d930ff3ee5ab19e5dc04c497110976d680dae1af8ed070ba810d, 2122157959));
        assert_eq!(result.get_in(4).unwrap().unbox().get_script_hash(), 0x30a2f5d43f1c6bca20c3ae7252b5f52a78fc13681effca977db9f8f641ef62f);
        assert_eq!(result.get_in(4).unwrap().unbox().get_n_sequence(), 0xebde94c9);
        assert_eq!(result.get_in(5).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1336354570024430);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x68f951c4dd8a7b6b44ed3a0aa2b5ff69a1cada47f62cff38828891940d92515);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 92789c2f6314ddead2f26b5b40a6e469567b3c83c929d8d361029c6f8f435dd4
        let mut serialized_byte_array = array![0x11, 0xec96e31f04231dd0674b006fdba4d69737c566266baf9df2e982c60745fa45, 0x8e72a84b45c60a16c19b108abd5a5749755967722e24f6e387ef5d894156fe, 0x06114429a39a83a676861ab260ab96826396363f47ccd8735162fc2d682ece, 0xf9f415700cac215343131090db5a31975bf96e5f6e3cfb6719b50d9c335466, 0x1d37c4308c157ff82eb998e1fcfc43fb399f7937d1ee27a2ca2def5f47bd34, 0xd90926b508e18e13f40242e31bcca267a1753208258f3670d350db090f3893, 0x30bc3cde05e09b5f95cfd75c2711a443228f6489391e6ee15214b1079bd433, 0x43a455c2cabef20d17458aac0934cbc41cd8891f077e3f32a83690b7e5b535, 0x761438f184671443d37a10cd231e2b5c031adeb53aa9d7b5dc805e575d2066, 0x74e63446f1fd4db100ea25a6071485e00f2b0f1c3758d23df6d8961c18c2b5, 0x045b0280c1d21b43bbb8783429b5b868452f72462033fc8638234ec1a2e96b, 0x2e80e166261efba2aeebab4a0b5ea7cae9eb3878346e30dd76212af0c01fee, 0xa1a2e9966559e85b9a6f3def8f57030f871017c035a15ba8ac4637943821db, 0xc12071321c7166587530384f1f408ec28aeabac28db889910ac067b8bdfa35, 0xbb0b38f576c2aa70cb28b57cbc5fedcd4f192d2f607e422442b80c4d617702, 0x58ea7f48a04e794ee35ac63b6fa483b3040f09515d414e01477f7f9b233f04, 0x001d995a2df1841f860a55fc23e1922fa4c5211abd45b95d488c791688282e, 0x5d4b6471, 0x4].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 535009004);
        assert_eq!(result.get_locktime(), 1902398301);
        assert_eq!(result.get_hash(), [0xd45d438f, 0x6f9c0261, 0xd3d829c9, 0x833c7b56, 0x69e4a640, 0x5b6bf2d2, 0xeadd1463, 0x2f9c7892]);
        assert_eq!(result.count_ins(), 4);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x231dd0674b006fdba4d69737c566266baf9df2e982c60745fa458e72a84b45c6, 2613122570));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x6691237336a4c658c9f92310efe6cd32dea324e2e9a5770193a046e6ceb18b8);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0xfe564189);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x06114429a39a83a676861ab260ab96826396363f47ccd8735162fc2d682ecef9, 208672244));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x7024406f979d0949ece676ed2717f2984fbc6aaadf97aac5bd75db8d8b029cd);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0x5e80dcb5);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0x575d206674e63446f1fd4db100ea25a6071485e00f2b0f1c3758d23df6d8961c, 79020568));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x786b57774e9dfdae28e47f9f0d4a2fbeec9a8f81f54e7bfd67fadc219d6135f);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0x327120c1);
        assert_eq!(result.get_in(3).unwrap().unbox().get_utxo(), (0x1c7166587530384f1f408ec28aeabac28db889910ac067b8bdfa35bb0b38f576, 3413158594));
        assert_eq!(result.get_in(3).unwrap().unbox().get_script_hash(), 0x15a17ed767b9e86c0775c152bb72fee341516e2f0980eaf675f3986a71d53fe);
        assert_eq!(result.get_in(3).unwrap().unbox().get_n_sequence(), 0x4e415d51);
        assert_eq!(result.get_in(4).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1195322072072007);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x2c98d2b388da5ed8bf0d9dbf58d94b52733c8ebdd536aa4f2b20eade3dacad4);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 9017f22600b5071ea918656900cc9c9518b21ae824479c95cb534e15f35c8ae8
        let mut serialized_byte_array = array![0x19, 0xe968944d0342a7a5509d9349fa5cadabcc78df4f1314da7df5d45101b106dd, 0xf75f5ebee9b8b0dfe2c37bec892b072107e883e53927031ae26f505d422ae8, 0x5c610bb0cfd58218291d8c56fcca5f5dcfc69b3ecca8b50cde396936440410, 0x7faea997ce631c4a5cb552fc99356ee9764872fe2474eb7443751c9ace16a1, 0x026931c1029d30a26a842f2ca4981dd40bab8a061ec7f9a665fa040c727e52, 0xe218ab5bdc9173ac14798d8da8850e50b421140a71401e47a5c75fdf78ddb6, 0xc968fd5b3e17e5d8a2b47ceda41a890183e938fd2e01948c913c3ff4463c67, 0x662ad93f2fecd458638f91b9e791cfa295920118351081e5a856a01e5474f4, 0x52d44d08d2f4bf21ba4be4ee5647ade6acae8eadb9e6655fb97fe5e6521b4e, 0x5c800b8e769778f35dec35873a9597830e3c28f3b4c7ea4eb3133e858b01d5, 0xb06c9578606f5922e41809b49dafb612d207193804e39018b31bde6e2fd3ae, 0x4f1a63c7967a73f70c3f9664b52e3f1716b06c062b293cb9c7d6ba74a9d634, 0xbc176692fdd37f4f7d416cd771b08fa3c3959060ca1d5bbb962e65c7a7f7d7, 0x830c8f4853ee489ed7666ea222ac190c55ed3b29c514b4e1333a5f362cd674, 0x70c3d448802a772212d722a2e5dd269f6b4d76ffe5787c8c4d6362c3143da8, 0x7473693c290eaaea89bcedefba1d6ef962253b1bc5d8a13ae3761159060aac, 0x5b95a4c3f04dc6092fa614f3d31bc2174de444d8ec180d038ffb0fb5aae705, 0xa2937dbcbc7c29aec236f3e7196ce8fb812593440a5351ad73c51915c4751b, 0xb6f4e4ac6a3cb1afdc3331920fc8853492cfede08f32a4d42f6683153989f6, 0x4274616cdcb6ab6030d485b333df8f09e91a3eff8ccc433bbe8e4c215d7a31, 0xf335cd383ffcf6c9cc0a738d1b02dca67fed04f29b34ba1f3ffaf66aeffd59, 0x4e74d39b8246c925aabcfd75108574f89ae13750e1f3e04d26daca3049a13e, 0x1ef68a0ab57372717f2bc8119fa0d53e5002d8da6f7fa54c30eb393eba1d45, 0xf1b5eee019dbdb14c110bdc81e0aa203ca42efd7dac904000ac3fa97812a43, 0x649f601cc3ab2992a04f0400000a58897d5f0301000c2abacc1b30e3aa77a7, 0x840a440ace1de3, 0x7].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1301571817);
        assert_eq!(result.get_locktime(), 3810381322);
        assert_eq!(result.get_hash(), [0xe88a5cf3, 0x154e53cb, 0x959c4724, 0xe81ab218, 0x959ccc00, 0x696518a9, 0x1e07b500, 0x26f21790]);
        assert_eq!(result.count_ins(), 3);
        assert_eq!(result.count_outs(), 3);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x42a7a5509d9349fa5cadabcc78df4f1314da7df5d45101b106ddf75f5ebee9b8, 3286425520));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x3deac831663fe5d2194099dc2ec432004414ef012e3a3994408cae50bb0503d);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x85a88d8d);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x0e50b421140a71401e47a5c75fdf78ddb6c968fd5b3e17e5d8a2b47ceda41a89, 954827521));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x5d9470644f5830a93b1e86b082402a0fb46db822c3ce815b034877188dea603);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xe44d17c2);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0x44d8ec180d038ffb0fb5aae705a2937dbcbc7c29aec236f3e7196ce8fb812593, 1364396612));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x76dab7790ce7f197423bd6ca483cd5070adff17f50ea08ebed248e1952524c);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0xa20a1ec8);
        assert_eq!(result.get_in(3).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1347841669677770);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x749e34d016bb1903f5fe7093caa72e091feefc997842d27b70b3e243e988e47);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 1213450972408771);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x545d6f7d28a8a398e543948be5a026af60c4dea482867a6eeb2525b35d1e1e1);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 285183639640074);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x1892122b70ddae2a6bdde8687708fc933fd1d1473e87fca6ee34223cd7bd48d);
        assert_eq!(result.get_out(3).is_none(), true);

        // Transaction ID: 1f94f7fd1ea1744b6f3577e2fe032d257c0080fb6f74d84454018f7dcdaa24a7
        let mut serialized_byte_array = array![0x21, 0xc732d51d02e3fa9ed37683d6fbf4dc7244ae5732630d213c48e9b22872a46d, 0xe558533a84060b13f6f3fddd011c7cd658bd343cfb02cee381f6300c001c42, 0x78d5f7de19020ffe61f594406b615ac95494f2fca9edef3337bd87c9574b55, 0xf926e2f551d21bf15386d5ef675163fef36b2d343939981eca759f6436055a, 0xd1d9d542f4adb8a5b501cfa016bcfdfdd0ca73af683af691d8f6d7bf96a35b, 0x9f7e133cfc6a09b69edd22565e8d8f274591bfa825042f50ae13666a023feb, 0xc83f9f83778a4b7bb8a5df680e8a4f9e4467ebc2d5b83d3f680563c18685e7, 0x49a8fd3eecb6de12144a34ed32cc7964bbba49300ba60e6062e914abd5fd23, 0x478c1404f02aab361f43a7fe720ac8d0540972eda202893e77aa58c6b14c23, 0xd5b7546c4b600e882f153f140fc563f0cef45d1c8002161c367f6d23148dce, 0x79c9c21bc34912f6606f2536bfc675dbe333d224b1adf239817259266398ca, 0x07d967bc9531a28844bce108beadad26315cf550d0fc934ad254c71253a211, 0xcccac22a2c3c051150c07f0389025a0f980ce9e9bf66988c5256c5e79df58c, 0x9b53108603e86d21952d1d1e4807c1140e0ea519a90eddd71035194a5b4a10, 0x33b85456a4119f61e00cc41c0a28661b1f98f9bf27ae1ed85aa3a32c2e4cda, 0x732a8af06213f6f8b5aae3e86d99d8c12fc94b8248a74d4cbde6bc70f7511b, 0x856bfa696d7a9e91d352ffa5b9a0205ece9f7cf839773c080d6878168ae986, 0x541be208efa735769afabce57a64add4ba30eb0010ea5de3a890c85381ff3c, 0x74a37afdc801825cea3967f4e0bd5c27bdcfb8cef928c33f22f4acb4a8adb9, 0x1bffda4f6436e67bdbc2ccb5e885a9a62027f7fa427ece4e8ede6c8ea129b7, 0xd92a9b12bd3e9875090a7e9e4184c859f60d0a7ae65955aebb4ff2d0fd9f6d, 0x654a77b9b3986e7f5c94912d67a50c2e48ce855aa3d6cd315f42b9e6de32df, 0x77d868da28e4fd26ca197a5b055b80e8d2261868c3417944ed5e9e72be7335, 0x484e5c4500ecc89d5cd6f64f21105bd44116a354a5e9f12cf041dbda94bd8e, 0x804d849fbb4dcb70ca80def57d9d2baa1be5d54606a96b41add17ceab39c99, 0x81b77d8822cd6fbedbc1dc51668667a7b7834b96eb471aff64169a385a99ab, 0xfa20f2ddf9cdfac7c892833bc4e3096e1731a040bd2bfb5befdc316bd01de4, 0xcffa71a06eb1972acb6e5c3882c5f63f96693269b8449e4f1ecaad16f14e68, 0xa3dd0975a5bb980e999e85e28599aa3e7b619915bcb37a5b5370ce26e627c8, 0xde1d1ee5ad0649dbf942a0d34da5f09f908ae5b0835c4b4fe235f53a16db56, 0x00789b62706b36e2f2390cac3ce3969dce70267e0e51df87cf916b6fd30178, 0x0d38fe1cd1220d582d8af612851f2118bfcd42464fbfaa2cef9fcb11fb8b5c, 0x2b407957641ca5ffd2a135c9da6080579d07c23e1009dff6d043b306c97b9d, 0x70013e33e11bf8e105000dae9639e160a1fcd4de4d9cfbd299856fde, 0x1c].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 500511431);
        assert_eq!(result.get_locktime(), 3731850649);
        assert_eq!(result.get_hash(), [0xa724aacd, 0x7d8f0154, 0x44d8746f, 0xfb80007c, 0x252d03fe, 0xe277356f, 0x4b74a11e, 0xfdf7941f]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xe3fa9ed37683d6fbf4dc7244ae5732630d213c48e9b22872a46de558533a8406, 4092990219));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x4724ef3a171c5d64507df3b45b7f5b82823bb0f357bdd608628066cef9b87fc);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x8a167868);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xe986541be208efa735769afabce57a64add4ba30eb0010ea5de3a890c85381ff, 2057532476));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x3ac6681137155afaf29f8a78fe55d12842b3b69d9c0bee3e605e3b0196513d2);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0x709d7bc9);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 1655830619435838);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x7398533ee60be512c73f91530f03c5e2dedfc46fd531c2880e442bbb48de23a);
        assert_eq!(result.get_out(1).is_none(), true);

        // Transaction ID: 1a6bbb3f38fa43ac948c659e81eec9805337f5f1ab5cd4a923c83173d32a4408
        let mut serialized_byte_array = array![0x1c, 0x05387428047d654993a9405a2246f8f380cff973136ead57459596a4eebe59, 0x3fa559d29d8b08d99968a995a57114bd60b3ba0c3690916f0fa43bf2cd20dc, 0xef5464618a3b6e678ff4cd126bd07f2f84e930d0fd2dcf5a8a742ea27d0e36, 0x3ba7d6d13e5835dfe6a3dbf80a8ee8f2e70c8d33671dbf4fe2c60bc9ce7909, 0x1a8cc09afc7cef461a18dc613d3e9759f3d9d62c14c9dcc452abdf7b573a63, 0x615c5b176d530ceefb48f595ea93d03ebed7096670039212598c0e85c1dcd9, 0x0bf93fa74e8575143702dfc78abdcc91d20eae067dc459dc81255d4946748b, 0xedad10c43b461afac84ebf99c1c586f01be50460a011047bc5cdaea5e39728, 0xcddd863d564e893f629872d2990d023547d72768efdd7204d0c68d9b4582fa, 0x46cb62b878741a39d47a959294b892ee521963f3827c12241ea0770be2f48c, 0x221eccaef40a85a9655858bdb981557a048ca9693814efba19e3acd11e5477, 0xf06dc11b30ce723edbe57176d7ca8f4f112439a708c122dc8e384692b4a984, 0xc328d6e954a406fe5ef0a23b8fbeb9be6c1e56871fc37a8f0c9d9c78d762fd, 0x213ce5d061fac1e60b222ba518c954be267cfeec35b9711bededfa36e40572, 0x035934612eff0bc36b37e60f799576daf2b5d0e5486405e4a83dbec99bca22, 0x68dc6be38bfe81cafe8633d3c5662e1f88814baa6262793ec6b9965ff0678b, 0x6bdd28fa26c4353f2ffeeb1290c8d440056f25b89966a461a4c003e39b4f11, 0x711c7dc97d3ed1cd9ec7fccd0147e19eceb3901e053dc1e0c2bdcd07b48b13, 0x6a64d133cdf3aa67e1d77c70d6b05049140054f2845d13677e4c943ff392c4, 0xc28f4a42def57e7bdb8aefdd269746b8cbeda1de7bdb2360eeb08ec7bb29cb, 0x77bf98f1fdf39727c5b07ef935da7b82c0b73cfc56194fd94a4a5ebe850510, 0xe70bb12afba0887d7ffe1f9038b960805778b1c8d53a4b422a075f4d29ffdb, 0x2e39f5c0154e867771313ca1401f61074f3470ee2f87c8788a5706b4985ec3, 0x12309ea2f6e81e8f6b3c67259cca8f08e6e82578ffe289ca04358e32e8f358, 0x03001f8daeee34561c2ea5ac5c5ccc439d7394e79487397eb3a94084fcd47b, 0x29ba97f9f4cdeecde9000017ccdb83d40f7cbc905732cece5e36adaadf17c3, 0xf1daacfcba5c9e4dbae5060006ae3412989d61d69a20876472040021f48b1b, 0x754e997c5445cf862eb1b4450e93ee1f9b60fc9464bcea6e9b9ba83a5e48c2, 0x7e3c9c, 0x3].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 678705157);
        assert_eq!(result.get_locktime(), 2621210306);
        assert_eq!(result.get_hash(), [0x8442ad3, 0x7331c823, 0xa9d45cab, 0xf1f53753, 0x80c9ee81, 0x9e658c94, 0xac43fa38, 0x3fbb6b1a]);
        assert_eq!(result.count_ins(), 4);
        assert_eq!(result.count_outs(), 4);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x7d654993a9405a2246f8f380cff973136ead57459596a4eebe593fa559d29d8b, 1754913032));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x5d81b4424290f7d848d5d48418ed778352026a9a5501f63e901f672ed27110d);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x46495d25);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x748bedad10c43b461afac84ebf99c1c586f01be50460a011047bc5cdaea5e397, 2262682920));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x17eeea32fb25b65f9b5774b2a94c6edb88623379746cbb64d8c005a279b0356);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0x850af4ae);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0xa9655858bdb981557a048ca9693814efba19e3acd11e5477f06dc11b30ce723e, 1987175899));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0xb47a9c7e6d04a7ed77f140087a6d213259a4b4bccc802c846f905ea0b4311d);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0x50b0d670);
        assert_eq!(result.get_in(3).unwrap().unbox().get_utxo(), (0x49140054f2845d13677e4c943ff392c4c28f4a42def57e7bdb8aefdd269746b8, 3735154123));
        assert_eq!(result.get_in(3).unwrap().unbox().get_script_hash(), 0x967fb644fb97e682d8a4f3f215ec633b74fc648325b80d26fd8a3499e559c7);
        assert_eq!(result.get_in(3).unwrap().unbox().get_n_sequence(), 0xca89e2ff);
        assert_eq!(result.get_in(4).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 942229526056501);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x1a0eb25e3cbc66b7430586851b5abf81d8f91e48e6f30d79de26aad3144aeab);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 257070684042489);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x1377cb9e6a2824229eb78a3f6b08f3183dad14e763667b12cf3d815e98031a);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 1941438189165754);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x1c14de5cef196039e1514fcc1ba56c546c5b26746f38fa7e3d57bc0e6bd22b0);
        assert_eq!(result.get_out(3).unwrap().unbox().get_value(), 1251675996199638);
        assert_eq!(result.get_out(3).unwrap().unbox().get_script_hash(), 0x541fad90973e9297da3121347c216f0b18171d8a186400df673718bbdce5e7b);
        assert_eq!(result.get_out(4).is_none(), true);

        // Transaction ID: ac8cd31a1f2c971e72fbc90bd0f80d0a37af46b596dfd8b22837b442f521126b
        let mut serialized_byte_array = array![0x1d, 0x990f0c0d02a8441f7d4dfbc751bf14233f39a2ab7f88177a298f22d6b5bc73, 0xd580cee183f38c005259d342cf919b089ec7419400d31965c25aa1e33c1611, 0x4fcef589f38dfd0210be5cf6f09ceeda9e7eb5bc83589577e83a716e748d72, 0x6f735249b37807f90dc6d06b159ee17417f4ec0848e35f572cb9e89fab0bb7, 0x358af82e6d856fa9e53a3e4ba6ffa371761ac61dab8c55d7650d1e47848640, 0xc7084edea7e427afe52557d42400470ae416e61de83dce7fb7bf56b998b53a, 0x501984b7a3967be5da4cccff100a1e9d6b5b470c0bb9456951e9af01df52ab, 0x8f8c36f72120a0ebbd5be7f45e5ee9bf1359247fe73a1dbf8087ee119ffa56, 0x12c53f4f57a02a1b3f63d236388e007b994bc4c46ea1a34e1e6b21281ea97e, 0x50d5350f164f0b69df20757920ecfda00135db69924f1320b10e3aa4c1c881, 0xb74efc9d8423fcf88ead316978f1bb11ce4906e548ad1497b88c9b02936578, 0x34fc79e2d4c7592fb832b0687922b275ca8b3c2582714491332a19530257fc, 0x26973c683ffeda04775b194f0cf04f2e9d159006b3838b185b428b112c7b5b, 0xfdfc5e46c9bc27513929b68403802253acce2c946a99dfc738eccb4e1705b3, 0x0b8783f36654e61b26cbc7df1eeefd33400f5fd10ed6588266bc8109233f89, 0x136c2917c66e79fefc90369eea6d5bbff3b2ace350109e6d61d441ea66147b, 0x01f47e73e5575d46663b67002ab917b4f02680bb5440252ab37656e609bd2b, 0x91fb95ef32692cb8ada64ccbf11e5d1bbe978531783474031db2dbebc7be0a, 0xf8f20b434bd59a5eec026dd6db14c9f0b9ed6a479151342da446b20d64d5dd, 0xd5c6d5411a8a4cc6cbaaba5155658ff47d04132b7607dc4d81f6cbf340ee8f, 0x63b297ec0d4535816f2313cff0fa255538a7c4b98cf5384a20be528f44dedc, 0x6308082db2853ea4b42847845d2d380e52254c55080b736bd19d2a7ba27f80, 0x5d31258e455b83d73156b75640c77bf1e215d2866c5715657b303b6df816e6, 0x3891f6040ac53d6c917e01002ece7498ad2effe0edc2c1f4d7ef06620468f8, 0x0c3bdb5d955d5467486e503174d39c67841b1819fc3667ac848de6c09cad2d, 0x9ce89202003679b63074b4c1a6b73a42d0183ade4417c57aadb547f7563eb1, 0x516a7303f42a52d03e1dd08175e2223d4078bdd3ec04d8c6adc7ac22cd9c39, 0x6b16f9ef0400015166117ed4ef2b020030b5dc207bfa5baa39ef2330ae884e, 0x6b0f1d31f3c338404a4eaea70cdeaca199c0cb089a3d3ae0aaa67c992f29a8, 0x6df1120f52e21b, 0x7].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 218894233);
        assert_eq!(result.get_locktime(), 467816975);
        assert_eq!(result.get_hash(), [0x6b1221f5, 0x42b43728, 0xb2d8df96, 0xb546af37, 0xa0df8d0, 0xbc9fb72, 0x1e972c1f, 0x1ad38cac]);
        assert_eq!(result.count_ins(), 2);
        assert_eq!(result.count_outs(), 4);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0xa8441f7d4dfbc751bf14233f39a2ab7f88177a298f22d6b5bc73d580cee183f3, 1498546316));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x5ae15a2d10a1efb5d632145db5e9c8d62ffd5fa48facddb792985487e4c2b09);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x3f1b2aa0);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0x63d236388e007b994bc4c46ea1a34e1e6b21281ea97e50d5350f164f0b69df20, 3961551221));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x728260c93bf6fb8641dbb3c674eb1f9dc0750d684d92caef668d32e2010da6e);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0xf69138e6);
        assert_eq!(result.get_in(2).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 420638028055818);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x573c91349a89c2682e21b8e0888e022684b8998f99bd7186b11b767b9768c52);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 724477703728540);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x45c8a07de3818030abb63a1eba6c0720db2ab73140d6254d00f00acfad772aa);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 1389753008863644);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x7062da419ff1232f30bc6b40f154384afaefaaafe89baa9ef543d6048ffa2f2);
        assert_eq!(result.get_out(3).unwrap().unbox().get_value(), 611259015631206);
        assert_eq!(result.get_out(3).unwrap().unbox().get_script_hash(), 0x2084fd5cb71197b81851a86f8287405d02e79589a07f39a4bcf27ef8b2ae7ef);
        assert_eq!(result.get_out(4).is_none(), true);

        // Transaction ID: 16ca7ae70d0c8665f13cda8f8d8223c129c501197e208c3276a4c8f4410cb4d3
        let mut serialized_byte_array = array![0x2a, 0xe0ac776b058ba6c0e84285c94dd671ea5658354a64d677edf3c680ff83a1ac, 0x26f512bda205b49e48525d9639a60df3dbb571dad72439387e1175d9453694, 0xce7bb17612a73deb13ccb2b858d449b0bb2f045c4aab2a6245662454d298d8, 0xc921f2f01afc0d221d0a0992f5e5e6191137de16f7526cb1e6052c0de4cd28, 0x4dbdd84385b506881995fecaa3a469abe0f3c9114dbae38d9cc908168c97b9, 0x4e0e15d91073223a20703cdc858d46abb95c971b5e25f246555f057a64c249, 0xaab29fe7ffec03044eca756ea6c74f40f4667380dab20ac2076f2b1b81904a, 0xc889778acf39c6d1d80574b03be3fdd738ee3a5a46a7f05260debe05750a7c, 0x67880ed731ac9bbba1337022baae60f99f908589a295aab20b60c81dc68acd, 0x097c04d588830c69b30e0ce8e32a6ac6de5ac4058f6849fe3a661ae9deb03b, 0x993b9b161e57e120883d98071cd465850bca21b02214e86c262b34d6a4bfe9, 0x115baebf49b2bbf07b92161629f4430186f69bf4c19e13e0f62bab250e2e36, 0xb8142beb406afde46b685d3be67966a7e81fe6058dede841805d94cf310cd6, 0x5fda5fba6d4689c7123c086fa99a62a3c8b479b59b823d075df5235abc3a4b, 0x2078c0c7bef21d9f39515b28f6a7fb214ce777f8139e9a7109cdc9776d041e, 0xe6ff1b9806aca3e275f6c4739eaf276c4c541bb902c47618d5632688ed782e, 0x8600367ad6e51fbcfda30191a5950c4ee669196ea6461471929fd19ad469ae, 0x51186c490a58b100581729e6e5396d9439537e90b42d0f0906be3f88bed62f, 0x05a547d5c2c670e3b9dc411db638a567965cba4192644c7ccfb9678e31cf19, 0x1d124ba66b525d9064d283de08022fd08b463fd6c5ce5856a7baebab94defa, 0x0a54d9f0180c45810c1b2a44781e1af36cd0243db2307c044f6fb0ee313a84, 0x00ff682fbaa7c97e6d6b86f544a90f0ea3555ea843ca43b2da8c34653f0cf1, 0xd5faa35c4df96dbb07a0973ff8c3a3681727cb4956df08eaec39feecc2b406, 0xf0f336b35b69b712fed3356362d3c5d107b831be8e7f4f7ca7e7def6896a10, 0xcc2302080d755393331e7223818f82e3e812a69e11059b5d0a6a7bfccb9893, 0x3c864e3332c8a5460ee887feeebbe2769e9761d5daba4046e70cf7c157c2a9, 0xca00b9b2dc4d52e5dd9a415ff203298b8a277f9b29e2fff334c8f487cdeabe, 0x359ebc19e808b7f21eb28d62612aec787637c4e85881f91029eff9d6df1735, 0x96521c6da6a487a63ba578bf84ae7e35eec89c51a121b77488a06eec3db8fa, 0xe6481cf711f1bb00b270af733e32e147b69768cd7db1b25d92a20fd1a51e18, 0xac1c666f29bb6d8b262d90631429b1969d31cbdcecc86f496c2b7a1355e8fe, 0x67c38b1128bf311317bbb54ffeda9991eb327e90089ff9ae44286ebfe78416, 0xf0ac72faf3746625a2b41e0e5e3777fdcf97954a5f4d5d519947fc7f3c225b, 0x8c2e9a963d1c86056cbc42d52aa52876e49b6cfc498c5cd623716c89f9e365, 0x7880010460b3aa9dc03424ec4be1b37911ff6f51b413dde2c131ea653d031a, 0xcb7c11ef3342bf32fdbc7c64367207012787c24e4143235c1a0e775159fa37, 0x15169f21d07b0cbfefb54c48c36465b7255af92d2000aea9afc73eebc9d7a5, 0x7ad836868fbc7a5a082a9a0830c7fd05e0dafbf685740100061e9938382681, 0x566e3b797a3f0100115259d378a57c9da71bf08e6d803451361fcab2518ac9, 0x0b0000237e16ab92a10c9c616336c8f725d27ef83f429aeb24c9bcb74e72f3, 0x20f29d34b392c1b3602463d9b4a504002da4db511b22bacfc271357eb790b2, 0x4ff7bdc1e91bc4e5fb6ce16b934845e5c6af8bdba6c7913c06d23bec2afeed, 0xfb8fee05af870200016eeb9d627c, 0xe].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 1803005152);
        assert_eq!(result.get_locktime(), 2086837739);
        assert_eq!(result.get_hash(), [0xd3b40c41, 0xf4c8a476, 0x328c207e, 0x1901c529, 0xc123828d, 0x8fda3cf1, 0x65860c0d, 0xe77aca16]);
        assert_eq!(result.count_ins(), 5);
        assert_eq!(result.count_outs(), 5);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x8ba6c0e84285c94dd671ea5658354a64d677edf3c680ff83a1ac26f512bda205, 1380490932));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x64d2094dd049f2cbe8ec11a6827469d63efcb230b00caf2a1ffd7b235a37a55);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x69a4a3ca);
        assert_eq!(result.get_in(1).unwrap().unbox().get_utxo(), (0xabe0f3c9114dbae38d9cc908168c97b94e0e15d91073223a20703cdc858d46ab, 462904505));
        assert_eq!(result.get_in(1).unwrap().unbox().get_script_hash(), 0x3f169c98ee9e927fa31608058c492072b5d6f4b4932b5c7522dda1ba4d4a7e1);
        assert_eq!(result.get_in(1).unwrap().unbox().get_n_sequence(), 0x600bb2aa);
        assert_eq!(result.get_in(2).unwrap().unbox().get_utxo(), (0xc81dc68acd097c04d588830c69b30e0ce8e32a6ac6de5ac4058f6849fe3a661a, 1001447145));
        assert_eq!(result.get_in(2).unwrap().unbox().get_script_hash(), 0x1e8fae7bacc17b6f1bd0f598d3bdb198320db2c68ccffca97bc92818bbe1e4);
        assert_eq!(result.get_in(2).unwrap().unbox().get_n_sequence(), 0x1bffe61e);
        assert_eq!(result.get_in(3).unwrap().unbox().get_utxo(), (0x9806aca3e275f6c4739eaf276c4c541bb902c47618d5632688ed782e8600367a, 3156207062));
        assert_eq!(result.get_in(3).unwrap().unbox().get_script_hash(), 0x1deafe7957d14d681a2647f8078f3c24851142786166847aef36f5d747283c2);
        assert_eq!(result.get_in(3).unwrap().unbox().get_n_sequence(), 0x181ea5d1);
        assert_eq!(result.get_in(4).unwrap().unbox().get_utxo(), (0xac1c666f29bb6d8b262d90631429b1969d31cbdcecc86f496c2b7a1355e8fe67, 672238531));
        assert_eq!(result.get_in(4).unwrap().unbox().get_script_hash(), 0x6d687d96e4bd0f2c8df9cd2f2abe7566d6603f0755fed46968f1a8a43376f59);
        assert_eq!(result.get_in(4).unwrap().unbox().get_n_sequence(), 0xfdc73008);
        assert_eq!(result.get_in(5).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 409593699883744);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x68c6d75e470ebe1766618c7434e2f0dc6ba9926d41ce577127d82cfab9960ad);
        assert_eq!(result.get_out(1).unwrap().unbox().get_value(), 351270229208662);
        assert_eq!(result.get_out(1).unwrap().unbox().get_script_hash(), 0x667d32c5246396e8d7c208ca7cbfe83e24c214eebd08ed47e981a3f00cd3d);
        assert_eq!(result.get_out(2).unwrap().unbox().get_value(), 12960236942026);
        assert_eq!(result.get_out(2).unwrap().unbox().get_script_hash(), 0x3f77ac5d1a4d4fbdd8235c0bbc1de93a36df3cda4aba3e250acd8486bc1cd6d);
        assert_eq!(result.get_out(3).unwrap().unbox().get_value(), 1308096066692192);
        assert_eq!(result.get_out(3).unwrap().unbox().get_script_hash(), 0x2f77dc32cbedcce3802eb282270d5378bcba919a70a77589f9ef556a60e4dff);
        assert_eq!(result.get_out(4).unwrap().unbox().get_value(), 712135741968379);
        assert_eq!(result.get_out(4).unwrap().unbox().get_script_hash(), 0x65f0d778a0d45d7ef9382efb0194da5c4ae5d24cfb8827b8d8cc7de82cc7c0);
        assert_eq!(result.get_out(5).is_none(), true);

        // Transaction ID: d4f48cbfabbc8dfd0b274c4cb3faa61cc474487b5610586ef3bf55c0abbf5120
        let mut serialized_byte_array = array![0x8, 0x4798b5350131f5d50dc50ea58f74ddbc2a591f7625cc2a0a28be71780381cc, 0x41b0f7664c42c39ff3a3ad7de66a2ff7d012f5f488dd521b48ddd5093796b2, 0xe9c011aa804ff1d7f35b3758e39ad30e4cb9b658e86fa6c44804c3005ac507, 0x6ad4b05f6dfd0b6c56cd679b5c02af25f72f9436aaac108f3956a35fd6619b, 0x4f97816e5642db031ecbf0ffcd4712df0babff13ba84bbed7300ab1a5b3fe9, 0x255ab878003efd02c6d7da7d5f6b921096b4e70a78c57500f535e58239b1bf, 0x5743c4ff1781bb776f6f1112df34107837005de63e4445576ce11c616787e9, 0x5e490157559661ab4207001b4b906d2295781b6c27d6d6efb494672b6b3d69, 0x65ae49e04da55eb8515acd7a, 0xc].span();
        let byte_array = Serde::<ByteArray>::deserialize(ref serialized_byte_array).unwrap();
        let result = BitcoinTransactionImpl::from_byte_array(@byte_array);
        assert_eq!(result.get_version(), 901093447);
        assert_eq!(result.get_locktime(), 2060278353);
        assert_eq!(result.get_hash(), [0x2051bfab, 0xc055bff3, 0x6e581056, 0x7b4874c4, 0x1ca6fab3, 0x4c4c270b, 0xfd8dbcab, 0xbf8cf4d4]);
        assert_eq!(result.count_ins(), 1);
        assert_eq!(result.count_outs(), 1);
        assert_eq!(result.get_in(0).unwrap().unbox().get_utxo(), (0x31f5d50dc50ea58f74ddbc2a591f7625cc2a0a28be71780381cc41b0f7664c42, 2750652355));
        assert_eq!(result.get_in(0).unwrap().unbox().get_script_hash(), 0x6e11948ffa64a11d5792564cadf8a4e56832249e5541f772cf5b35d46c33967);
        assert_eq!(result.get_in(0).unwrap().unbox().get_n_sequence(), 0x495ee987);
        assert_eq!(result.get_in(1).is_none(), true);
        assert_eq!(result.get_out(0).unwrap().unbox().get_value(), 2043628681057623);
        assert_eq!(result.get_out(0).unwrap().unbox().get_script_hash(), 0x67d1c6440dcd3b7d55daca86e20537ee16bd431b6dfb63a0877067d860a7d13);
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