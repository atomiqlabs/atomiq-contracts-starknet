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

    fn from_tx(btc_tx: BitcoinTransaction) -> Result<BitcoinVaultTransactionData, felt252> {
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
        let (fronting_fee_amount_0, fronting_fee_amount_1) = self.caller_fee;
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
