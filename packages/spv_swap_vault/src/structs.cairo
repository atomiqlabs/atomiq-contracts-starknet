use starknet::ContractAddress;

use btc_utils::bitcoin_tx::{BitcoinTransaction, BitcoinTransactionImpl, BitcoinTransactionTrait, BitcoinTxInputTrait};
use btc_utils::byte_array::ByteArrayReader;
use core::hash::{HashStateTrait, HashStateExTrait};
use core::poseidon::PoseidonTrait;

#[derive(Hash, Copy, Drop, Serde)]
pub struct BitcoinVaultTransactionData {
    pub recipient: ContractAddress,

    pub amount_0: u64,
    pub amount_1: u64,

    pub caller_fee: u16,
    pub fronting_fee: u16,

    pub execution_hash: felt252,
    pub execution_handler_fee: u16,
    pub execution_handler_timeout: u32
}

#[generate_trait]
pub impl BitcoinVaultTransactionDataImpl of BitcoinVaultTransactionDataTrait {

    fn from_tx(btc_tx: BitcoinTransaction) -> Result<BitcoinVaultTransactionData, felt252> {
        //Extract data from the OP_RETURN, which should be output with index 1
        let output_1_option = btc_tx.get_out(1);
        if output_1_option.is_none() {
            return Result::Err('tx_data: output 1 not found');
        }
        let output_1 = output_1_option.unwrap().unbox();
        let output_1_data = *output_1.data;
        
        //Make sure output has correct format: OP_RETURN PUSH_41/48 <data>
        let opcode_option = output_1_data.at(*output_1.script_offset);
        if *output_1.script_length==0 || opcode_option.is_none() {
            return Result::Err('tx_data: output 1 empty script');
        }
        if opcode_option.unwrap() != 0x6a {
            return Result::Err('tx_data: output 1 not OP_RETURN');
        }
        
        //Use input 0 & 1 nSequences to determine fees: caller fee, fronting fee, execution handler fee
        // input 0 nsequence: <ignored> <b0 fronting fee> <b0 caller fee> <b1 caller fee>
        // input 1 nsequence: <ignored> <b1 fronting fee> <b0 execution fee> <b1 execution fee>
        let input_0_option = btc_tx.get_in(0);
        if input_0_option.is_none() {
            return Result::Err('tx_data: input 0 not found');
        }
        let input_0_nsequence = input_0_option.unwrap().unbox().get_n_sequence();
        
        let input_1_option = btc_tx.get_in(1);
        if input_1_option.is_none() {
            return Result::Err('tx_data: input 1 not found');
        }
        let input_1_nsequence = input_1_option.unwrap().unbox().get_n_sequence();

        let caller_fee_u16: u16 = (input_0_nsequence & 0xFFFF).try_into().unwrap();
        let execution_handler_fee_u16: u16 = (input_1_nsequence & 0xFFFF).try_into().unwrap();
        let fronting_fee_u16: u16 = (((input_0_nsequence / 0x100) & 0xFF00) + ((input_1_nsequence / 0x10000) & 0xFF)).try_into().unwrap();

        //Use locktime to determine timeout of the execution handler
        let execution_handler_timeout = btc_tx.get_locktime() + 1_000_000_000;

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

        let recipient: ContractAddress = recipient_felt252.try_into().unwrap();

        return Result::Ok(BitcoinVaultTransactionData {
            recipient: recipient,

            amount_0: amount_0_u64,
            amount_1: amount_1_u64,

            caller_fee: caller_fee_u16,
            fronting_fee: fronting_fee_u16,

            execution_hash: execution_hash,
            execution_handler_fee: execution_handler_fee_u16,
            execution_handler_timeout: execution_handler_timeout
        });
    }

    fn get_hash(self: BitcoinVaultTransactionData, btc_tx_id: u256) -> felt252 {
        PoseidonTrait::new().update_with(btc_tx_id).update_with(self).finalize()
    }

}
