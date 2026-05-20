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
