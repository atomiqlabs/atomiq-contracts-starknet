use btc_utils::bitcoin_tx::{BitcoinTransaction, BitcoinTransactionImpl};
use btc_utils::byte_array::ByteArrayReader;

pub fn get_btc_tx(utxo: (u256, u32), inputs: Array<u32>, outputs: Array<ByteArray>, locktime: u32) -> (ByteArray, BitcoinTransaction) {
    let mut tx: ByteArray = "";
    tx.append_word_rev(0x00000000, 4); //Version
    tx.append_word_rev(inputs.len().into(), 1); //Input count

    let (tx_hash, vout) = utxo;
    let tx_hash_u256: u256 = tx_hash.into();

    for input in inputs.span() {
        tx.append_word((tx_hash_u256 / 0x100).try_into().unwrap(), 31); tx.append_word((tx_hash_u256 & 0xFF).try_into().unwrap(), 1); //Input utxo txId
        tx.append_word_rev(vout.into(), 4); //Input utxo vout
        tx.append_word_rev(0x00, 1); //Input script length
        tx.append_word_rev((*input).into(), 4); //Input nSequence
    };

    tx.append_word_rev(outputs.len().into(), 1); //Output count

    for output in outputs.span() {
        tx.append_word_rev(0x0000000000000000, 8); //Output 1 value
        tx.append_word_rev(output.len().into(), 1); //Output 1 script length
        tx = ByteArrayTrait::concat(@tx, output);
    };

    tx.append_word_rev(locktime.into(), 4); //Locktime

    (tx, BitcoinTransactionImpl::from_byte_array(@tx))
}

pub fn get_valid_tx(
    utxo: (u256, u32), recipient: felt252, amount_0: u64, amount_1: Option<u64>, execution_hash: Option<felt252>,
    caller_fee_u20: u32, fronting_fee_u20: u32, execution_fee_u20: u32,
    execution_expiry: u32
) -> (ByteArray, BitcoinTransaction) {
    let mut output_1_script: ByteArray = "\x6a"; //OP_RETURN
    let mut length: u32 = 40;
    if amount_1.is_some() {
        length += 8
    }
    if execution_hash.is_some() {
        length += 32
    }

    if length <= 75 {
        output_1_script.append_word(length.into(), 1); //PUSH_<length>
    } else {
        output_1_script.append_word(0x4c, 1); //PUSH_DATA_1
        output_1_script.append_word(length.into(), 1); //<80>
    }
    
    let recipient_u256: u256 = recipient.into();
    output_1_script.append_word((recipient_u256 / 0x100).try_into().unwrap(), 31); //<recipient>
    output_1_script.append_word((recipient_u256 & 0xFF).try_into().unwrap(), 1); //<recipient>

    output_1_script.append_word_rev(amount_0.into(), 8); //<amount 0>

    if amount_1.is_some() {
        output_1_script.append_word_rev(amount_1.unwrap().into(), 8); //<amount 1>
    }
    if execution_hash.is_some() {
        let execution_hash_u256: u256 = execution_hash.unwrap().into();
        output_1_script.append_word((execution_hash_u256 / 0x100).try_into().unwrap(), 31); //<execution hash>
        output_1_script.append_word((execution_hash_u256 & 0xFF).try_into().unwrap(), 1); //<execution hash>
    }

    let n_sequence_0 = ((fronting_fee_u20 / 0b100_0000_0000) & 0b11_1111_1111) * 0b1_0000_0000_0000_0000_0000 + caller_fee_u20;
    let n_sequence_1 = (fronting_fee_u20 & 0b11_1111_1111) * 0b1_0000_0000_0000_0000_0000 + execution_fee_u20;

    get_btc_tx(utxo, array![n_sequence_0, n_sequence_1], array!["", output_1_script], execution_expiry - 1_000_000_000)
}
