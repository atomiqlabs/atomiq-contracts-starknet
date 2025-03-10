use starknet::ContractAddress;

use btc_utils::bitcoin_tx::{BitcoinTransaction, BitcoinTransactionImpl, BitcoinTransactionTrait, BitcoinTxInputTrait};
use btc_utils::byte_array::ByteArrayReader;

use core::hash::{HashStateTrait, HashStateExTrait};
use core::poseidon::PoseidonTrait;

use core::num::traits::{CheckedAdd};

use crate::utils;

#[derive(Hash, Copy, Drop, Serde)]
pub struct BitcoinVaultTransactionData {
    pub recipient: ContractAddress,

    pub amount: (u64, u64),

    pub caller_fee: (u64, u64),
    pub fronting_fee: (u64, u64),

    pub execution_handler_fee_amount_0: u64,

    pub execution_hash: felt252,
    pub execution_expiry: u32
}

#[generate_trait]
pub impl BitcoinVaultTransactionDataImpl of BitcoinVaultTransactionDataTrait {

    fn from_tx(btc_tx: @BitcoinTransaction) -> Result<BitcoinVaultTransactionData, felt252> {
        //Extract data from the OP_RETURN, which should be output with index 1
        let output_1_option = btc_tx.get_out(1);
        if output_1_option.is_none() { return Result::Err('tx_data: output 1 not found'); }
        let output_1 = output_1_option.unwrap().unbox();
        let output_1_data = *output_1.data;
        
        //Make sure output has correct format: OP_RETURN PUSH_41/48 <data>
        let opcode_option = output_1_data.at(*output_1.script_offset);
        if *output_1.script_length==0 || opcode_option.is_none() { return Result::Err('tx_data: output 1 empty script'); }
        if opcode_option.unwrap() != 0x6a { return Result::Err('tx_data: output 1 not OP_RETURN'); }
        
        //Use input 0 & 1 nSequences to determine fees: caller fee, fronting fee, execution handler fee
        // input 0 nsequence: <ignored> <b0 fronting fee> <b0 caller fee> <b1 caller fee>
        // input 1 nsequence: <ignored> <b1 fronting fee> <b0 execution fee> <b1 execution fee>
        let input_0_option = btc_tx.get_in(0);
        if input_0_option.is_none() { return Result::Err('tx_data: input 0 not found'); }
        let input_0_nsequence = input_0_option.unwrap().unbox().get_n_sequence();
        
        let input_1_option = btc_tx.get_in(1);
        if input_1_option.is_none() { return Result::Err('tx_data: input 1 not found'); }
        let input_1_nsequence = input_1_option.unwrap().unbox().get_n_sequence();

        //nSequence0: 10xx xxxx xxxx yyyy yyyy yyyy yyyy yyyy
        //nSequence1: 10xx xxxx xxxx zzzz zzzz zzzz zzzz zzzz
        let caller_fee_u20: u32 = (input_0_nsequence & 0b1111_1111_1111_1111_1111).try_into().unwrap();
        let execution_handler_fee_u20: u32 = (input_1_nsequence & 0b1111_1111_1111_1111_1111).try_into().unwrap();
        let fronting_fee_u20: u32 = (((input_0_nsequence / 0b100_0000_0000) & 0b1111_1111_1100_0000_0000) + ((input_1_nsequence / 0b1_0000_0000_0000_0000_0000) & 0b11_1111_1111)).try_into().unwrap();

        //Use locktime to determine timeout of the execution handler
        let execution_expiry = btc_tx.get_locktime() + 1_000_000_000;

        //Make sure output has correct length
        let (recipient_felt252, amount_0_u64, amount_1_u64, execution_hash) = if *output_1.script_length == 42 {
            //OP_RETURN OP_PUSH_40 <32 byte recipient || 8 byte amount0>
            (
                (*output_1.data).read_felt252(*output_1.script_offset+2),
                (*output_1.data).read_u64_le(*output_1.script_offset+34),
                0,
                0
            )
        } else if *output_1.script_length == 50 {
            //OP_RETURN OP_PUSH_48 <32 byte recipient || 8 byte amount0 || 8 byte amount1>
            (
                (*output_1.data).read_felt252(*output_1.script_offset+2),
                (*output_1.data).read_u64_le(*output_1.script_offset+34),
                (*output_1.data).read_u64_le(*output_1.script_offset+42),
                0
            )
        } else if *output_1.script_length == 74 {
            //OP_RETURN OP_PUSH_72 <32 byte recipient || 8 byte amount0 || 32 byte execution hash>
            (
                (*output_1.data).read_felt252(*output_1.script_offset+2),
                (*output_1.data).read_u64_le(*output_1.script_offset+34),
                0,
                (*output_1.data).read_felt252(*output_1.script_offset+42)
            )
        } else if *output_1.script_length == 83 {
            //OP_RETURN OP_PUSHDATA1 <80> <32 byte recipient || 8 byte amount0 || 8 byte amount1 || 32 byte execution hash>
            (
                (*output_1.data).read_felt252(*output_1.script_offset+3),
                (*output_1.data).read_u64_le(*output_1.script_offset+35),
                (*output_1.data).read_u64_le(*output_1.script_offset+43),
                (*output_1.data).read_felt252(*output_1.script_offset+51)
            )
        } else {
            return Result::Err('tx_data: output 1 invalid len');
        };

        let recipient: Option<ContractAddress> = recipient_felt252.try_into();
        if recipient.is_none() { return Result::Err('tx_data: invalid recipient'); };

        let caller_fee_amount_0: Option<u64> = utils::fee_amount(amount_0_u64, caller_fee_u20);
        if caller_fee_amount_0.is_none() { return Result::Err('tx_data: caller fee 0'); };

        let fronting_fee_amount_0: Option<u64> = utils::fee_amount(amount_0_u64, fronting_fee_u20);
        if fronting_fee_amount_0.is_none() { return Result::Err('tx_data: fronting fee 0'); };

        let execution_handler_fee_amount_0: Option<u64> = utils::fee_amount(amount_0_u64, execution_handler_fee_u20);
        if execution_handler_fee_amount_0.is_none() { return Result::Err('tx_data: execution fee 0'); };

        let caller_fee_amount_1: Option<u64> = utils::fee_amount(amount_1_u64, caller_fee_u20);
        if caller_fee_amount_1.is_none() { return Result::Err('tx_data: caller fee 1'); };

        let fronting_fee_amount_1: Option<u64> = utils::fee_amount(amount_1_u64, fronting_fee_u20);
        if fronting_fee_amount_1.is_none() { return Result::Err('tx_data: fronting fee 1'); };

        return Result::Ok(BitcoinVaultTransactionData {
            recipient: recipient.unwrap(),

            amount: (amount_0_u64, amount_1_u64),

            caller_fee: (caller_fee_amount_0.unwrap(), caller_fee_amount_1.unwrap()),
            fronting_fee: (fronting_fee_amount_0.unwrap(), fronting_fee_amount_1.unwrap()),
            execution_handler_fee_amount_0: execution_handler_fee_amount_0.unwrap(),

            execution_hash: execution_hash,
            execution_expiry: execution_expiry
        });
    }

    //Returns hash of this vault data, salted by the transaction id, used as fronting ID
    fn get_hash(self: BitcoinVaultTransactionData, btc_tx_id: u256) -> felt252 {
        PoseidonTrait::new().update_with(btc_tx_id).update_with(self).finalize()
    }

    //Returns full token amounts to be withdrawn from vault, this implicits that there is no overflow
    // when adding all the fees together!
    fn get_full_amounts(self: BitcoinVaultTransactionData) -> Result<(u64, u64), felt252> {
        let (caller_fee_amount_0, caller_fee_amount_1) = self.caller_fee;
        let (fronting_fee_amount_0, fronting_fee_amount_1) = self.fronting_fee;
        let (amount_0, amount_1) = self.amount;

        let amount_0: Option<u64> = amount_0.checked_add(caller_fee_amount_0);
        if amount_0.is_none() { return Result::Err('get_full_amts: amt0-0'); }
        let amount_0: Option<u64> = amount_0.unwrap().checked_add(fronting_fee_amount_0);
        if amount_0.is_none() { return Result::Err('get_full_amts: amt0-1'); }
        let amount_0: Option<u64> = amount_0.unwrap().checked_add(self.execution_handler_fee_amount_0);
        if amount_0.is_none() { return Result::Err('get_full_amts: amt0-2'); }

        let amount_1: Option<u64> = amount_1.checked_add(caller_fee_amount_1);
        if amount_1.is_none() { return Result::Err('get_full_amts: amt1-0'); }
        let amount_1: Option<u64> = amount_1.unwrap().checked_add(fronting_fee_amount_1);
        if amount_1.is_none() { return Result::Err('get_full_amts: amt1-1'); }

        Result::Ok((amount_0.unwrap(), amount_1.unwrap()))
    }

}

#[cfg(test)]
mod tests {
    use super::*;

    fn get_btc_tx(inputs: Array<u32>, outputs: Array<ByteArray>, locktime: u32) -> BitcoinTransaction {
        let mut tx: ByteArray = "";
        tx.append_word_rev(0x00000000, 4); //Version
        tx.append_word_rev(inputs.len().into(), 1); //Input count

        for input in inputs.span() {
            tx.append_word(0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA, 31); tx.append_word(0xAA, 1); //Input utxo txId
            tx.append_word(0xBBBBBBBB, 4); //Input utxo vout
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

        BitcoinTransactionImpl::from_byte_array(@tx)
    }

    fn get_valid_tx(
        recipient: felt252, amount_0: u64, amount_1: Option<u64>, execution_hash: Option<felt252>,
        caller_fee_u20: u32, fronting_fee_u20: u32, execution_fee_u20: u32,
        execution_expiry: u32
    ) -> BitcoinTransaction {
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

        get_btc_tx(array![n_sequence_0, n_sequence_1], array!["", output_1_script], execution_expiry - 1_000_000_000)
    }

    fn parse_and_assert(
        recipient: ContractAddress,
        amount_0: u64,
        amount_1: Option<u64>,
        execution_hash: Option<felt252>,
        caller_fee: u32,
        fronting_fee: u32,
        execution_fee: u32,
        execution_expiry: u32
    ) {
        let btc_tx = get_valid_tx(recipient.into(), amount_0, amount_1, execution_hash, caller_fee, fronting_fee, execution_fee, execution_expiry);
        let parsed = BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap();

        assert_eq!(parsed.recipient, recipient.try_into().unwrap());
        assert_eq!(parsed.amount, (amount_0, amount_1.unwrap_or(0)));
        assert_eq!(parsed.execution_hash, execution_hash.unwrap_or(0));
        assert_eq!(parsed.execution_expiry, execution_expiry);
        assert_eq!(parsed.caller_fee, (utils::fee_amount(amount_0, caller_fee).unwrap(), utils::fee_amount(amount_1.unwrap_or(0), caller_fee).unwrap()));
        assert_eq!(parsed.fronting_fee, (utils::fee_amount(amount_0, fronting_fee).unwrap(), utils::fee_amount(amount_1.unwrap_or(0), fronting_fee).unwrap()));
        assert_eq!(parsed.execution_handler_fee_amount_0, utils::fee_amount(amount_0, execution_fee).unwrap());
    }

    #[test]
    fn parse_valid() {
        parse_and_assert(
            0x0700000000000000000000000000000000000000000000000000000000000011.try_into().unwrap(),
            439123123,
            Option::Some(1535515),
            Option::Some(0x85684656468644861352168416841573469846546846878189434846846844),
            2131,
            4213,
            5424,
            1546864423
        );

        parse_and_assert(
            0x4b84c4d9841ad181c984e84d1a18811b8e1d89.try_into().unwrap(),
            844633151,
            Option::None,
            Option::Some(0x5165786478644866869884686486866849889),
            74861,
            535302,
            56531,
            1648684862
        );

        parse_and_assert(
            0x488644b8dc78ea61d8981b81e8f161681d8ac84ed1a68.try_into().unwrap(),
            74869864156,
            Option::Some(4484384357),
            Option::None,
            56446,
            531156,
            85614,
            1564564592
        );
        
        parse_and_assert(
            0x47b87c77d448d8a6d48ef6684da8681d88c68ad48e8.try_into().unwrap(),
            564651565,
            Option::None,
            Option::None,
            478456,
            784864,
            12215,
            1897411442
        );
    }

    #[test]
    fn parse_single_output() {
        let btc_tx = get_btc_tx(array![0xCCCCCCCC], array![""], 0x00000000);

        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: output 1 not found'
        );
    }

    #[test]
    fn parse_output_empty_script() {
        let btc_tx = get_btc_tx(array![0xCCCCCCCC], array!["", ""], 0x00000000);

        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: output 1 empty script'
        );
    }

    #[test]
    fn parse_output_not_opreturn() {
        let btc_tx = get_btc_tx(array![0xCCCCCCCC], array!["", "\x10"], 0x00000000);

        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: output 1 not OP_RETURN'
        );
    }

    #[test]
    fn parse_no_inputs() {
        let btc_tx = get_btc_tx(array![], array!["", "\x6a"], 0x00000000);

        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: input 0 not found'
        );
    }

    #[test]
    fn parse_single_input() {
        let btc_tx = get_btc_tx(array![0xCCCCCCCC], array!["", "\x6a"], 0x00000000);

        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: input 1 not found'
        );
    }

    #[test]
    fn parse_output_invalid_len() {
        let btc_tx = get_btc_tx(array![0xCCCCCCCC, 0xCCCCCCCC], array!["", "\x6a"], 0x00000000);

        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: output 1 invalid len'
        );
    }

    #[test]
    fn parse_invalid_recipient() {
        let btc_tx = get_valid_tx(0x0800000000000000000000000000000000000000000000000000000000000011, 0, Option::None, Option::None, 0, 0, 0, 1_000_000_000);
        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: invalid recipient'
        );
        
        let btc_tx = get_valid_tx(0x0800000000000000000000000000000000000000000000000000000000000011, 0, Option::Some(0), Option::None, 0, 0, 0, 1_000_000_000);
        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: invalid recipient'
        );

        let btc_tx = get_valid_tx(0x0800000000000000000000000000000000000000000000000000000000000011, 0, Option::None, Option::Some(0), 0, 0, 0, 1_000_000_000);
        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: invalid recipient'
        );

        let btc_tx = get_valid_tx(0x0800000000000000000000000000000000000000000000000000000000000011, 0, Option::Some(0), Option::Some(0), 0, 0, 0, 1_000_000_000);
        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: invalid recipient'
        );
    }

    #[test]
    fn parse_caller_fee_0_overflow() {
        let btc_tx = get_valid_tx(0x0700000000000000000000000000000000000000000000000000000000000011, 0xFFFFFFFFFFFFFFFF, Option::None, Option::None, 0xFFFFF, 0, 0, 1_000_000_000);
        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: caller fee 0'
        );
    }

    #[test]
    fn parse_fronting_fee_0_overflow() {
        let btc_tx = get_valid_tx(0x0700000000000000000000000000000000000000000000000000000000000011, 0xFFFFFFFFFFFFFFFF, Option::None, Option::None, 0, 0xFFFFF, 0, 1_000_000_000);
        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: fronting fee 0'
        );
    }

    #[test]
    fn parse_execution_fee_0_overflow() {
        let btc_tx = get_valid_tx(0x0700000000000000000000000000000000000000000000000000000000000011, 0xFFFFFFFFFFFFFFFF, Option::None, Option::None, 0, 0, 0xFFFFF, 1_000_000_000);
        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: execution fee 0'
        );
    }

    #[test]
    fn parse_caller_fee_1_overflow() {
        let btc_tx = get_valid_tx(0x0700000000000000000000000000000000000000000000000000000000000011, 5451, Option::Some(0xFFFFFFFFFFFFFFFF), Option::None, 0xFFFFF, 0, 0, 1_000_000_000);
        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: caller fee 1'
        );
    }

    #[test]
    fn parse_fronting_fee_1_overflow() {
        let btc_tx = get_valid_tx(0x0700000000000000000000000000000000000000000000000000000000000011, 5451, Option::Some(0xFFFFFFFFFFFFFFFF), Option::None, 0, 0xFFFFF, 0, 1_000_000_000);
        assert_eq!(
            BitcoinVaultTransactionDataImpl::from_tx(@btc_tx).unwrap_err(),
            'tx_data: fronting fee 1'
        );
    }

    #[test]
    fn get_full_amounts() {
        let data = BitcoinVaultTransactionData {
            recipient: 0.try_into().unwrap(),
            amount: (544545, 84162),
            caller_fee: (84315, 21215),
            fronting_fee: (8985413, 564386),
            execution_handler_fee_amount_0: 54551,
            execution_hash: 0,
            execution_expiry: 0
        };

        assert_eq!(data.get_full_amounts().unwrap(), (544545 + 84315 + 8985413 + 54551, 84162 + 21215 + 564386));
    }

    #[test]
    fn get_full_amounts_overflow_0_0() {
        let data = BitcoinVaultTransactionData {
            recipient: 0.try_into().unwrap(),
            amount: (0xFFFFFFFFFFFFFFFF, 84162),
            caller_fee: (84315, 21215),
            fronting_fee: (8985413, 564386),
            execution_handler_fee_amount_0: 54551,
            execution_hash: 0,
            execution_expiry: 0
        };

        assert_eq!(data.get_full_amounts().unwrap_err(), 'get_full_amts: amt0-0');
    }

    #[test]
    fn get_full_amounts_overflow_0_1() {
        let data = BitcoinVaultTransactionData {
            recipient: 0.try_into().unwrap(),
            amount: (0xFFFFFFFFFFFFF000, 84162),
            caller_fee: (1, 21215),
            fronting_fee: (0xFFFFFFFF, 564386),
            execution_handler_fee_amount_0: 54551,
            execution_hash: 0,
            execution_expiry: 0
        };

        assert_eq!(data.get_full_amounts().unwrap_err(), 'get_full_amts: amt0-1');
    }

    #[test]
    fn get_full_amounts_overflow_0_2() {
        let data = BitcoinVaultTransactionData {
            recipient: 0.try_into().unwrap(),
            amount: (0xFFFFFFFFFFFFF000, 84162),
            caller_fee: (1, 21215),
            fronting_fee: (1, 564386),
            execution_handler_fee_amount_0: 0xFFFFFFF,
            execution_hash: 0,
            execution_expiry: 0
        };

        assert_eq!(data.get_full_amounts().unwrap_err(), 'get_full_amts: amt0-2');
    }

    #[test]
    fn get_full_amounts_overflow_1_0() {
        let data = BitcoinVaultTransactionData {
            recipient: 0.try_into().unwrap(),
            amount: (486463, 0xFFFFFFFFFFFFFFFF),
            caller_fee: (6956, 21215),
            fronting_fee: (5669, 564386),
            execution_handler_fee_amount_0: 4878466,
            execution_hash: 0,
            execution_expiry: 0
        };

        assert_eq!(data.get_full_amounts().unwrap_err(), 'get_full_amts: amt1-0');
    }

    #[test]
    fn get_full_amounts_overflow_1_1() {
        let data = BitcoinVaultTransactionData {
            recipient: 0.try_into().unwrap(),
            amount: (486463, 0xFFFFFFFFFFFFF000),
            caller_fee: (6956, 1),
            fronting_fee: (5669, 0xFFFFFFF),
            execution_handler_fee_amount_0: 4878466,
            execution_hash: 0,
            execution_expiry: 0
        };

        assert_eq!(data.get_full_amounts().unwrap_err(), 'get_full_amts: amt1-1');
    }

    #[test]
    fn get_hash() {
        let data = BitcoinVaultTransactionData {
            recipient: 0.try_into().unwrap(),
            amount: (0, 0),
            caller_fee: (0, 0),
            fronting_fee: (0, 0),
            execution_handler_fee_amount_0: 0,
            execution_hash: 0,
            execution_expiry: 0
        };
        let hash = data.get_hash(0);
        assert_eq!(hash, 0x33b76445f352ca1c37da8e0a192c5d399f062e1832b399ac3728a608bc41d78);
        assert!(hash != data.get_hash(1));

        let data = BitcoinVaultTransactionData {
            recipient: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF.try_into().unwrap(),
            amount: (0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF),
            caller_fee: (0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF),
            fronting_fee: (0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF),
            execution_handler_fee_amount_0: 0xFFFFFFFFFFFFFFFF,
            execution_hash: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            execution_expiry: 0xFFFFFFFF
        };
        let hash = data.get_hash(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        assert_eq!(hash, 0x2656dcd1b6027a1626ea6b3f367d12180cd730686d6264a120d09853ce72370);
        assert!(hash != data.get_hash(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE));

        let data = BitcoinVaultTransactionData {
            recipient: 0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e.try_into().unwrap(),
            amount: (0x1f20212223242526, 0x2728292a2b2c2d2e),
            caller_fee: (0x2f30313233343536, 0x3738393a3b3c3d3e),
            fronting_fee: (0x3f40414243444546, 0x4748494a4b4c4d4e),
            execution_handler_fee_amount_0: 0x4f50515253545556,
            execution_hash: 0x5758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475,
            execution_expiry: 0x76777879
        };
        let hash = data.get_hash(0x7a7b7c7d7e7f808182838485868788898a8b8c8d8e8f90919293949596979899);
        assert_eq!(hash, 0xe9267edd14b8bc48ef5329e97c01e45645c063c7307cdf5403f7e31a6abce7);
        assert!(hash != data.get_hash(0x7a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798a0));
    }

}