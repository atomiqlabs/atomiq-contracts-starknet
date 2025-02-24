use btc_utils::bitcoin_tx::{BitcoinTransaction, BitcoinTransactionImpl, BitcoinTransactionTrait};
use btc_utils::byte_array::ByteArrayReader;

use starknet::ContractAddress;

pub fn extract_tx_data(
    result: BitcoinTransaction, token_0_multiplier: felt252, token_1_multiplier: felt252
) -> Result<(ContractAddress, u256, u256, u16), felt252> {
    //Extract data from the OP_RETURN, which should be output with index 1
    let output_1_option = result.get_out(1);
    if output_1_option.is_none() {
        return Result::Err('tx_data: output 1 not found');
    }
    let output_1 = output_1_option.unwrap().unbox();
    let output_1_data = *output_1.data;
    
    //Make sure output has correct format: OP_RETURN PUSH_41/48 <data>
    let opcode_option = output_1_data.at(*output_1.script_offset);
    if opcode_option.is_none() {
        return Result::Err('tx_data: output 1 empty script');
    }
    if opcode_option.unwrap() != 0x6a {
        return Result::Err('tx_data: output 1 not OP_RETURN');
    }
    
    //Make sure output has correct length
    let (recipient_felt252, caller_fee_u16, amount_0_u56, amount_1_u56) = if *output_1.script_length == 43 {
        (
            (*output_1.data).read_felt252(*output_1.script_offset+2),
            (*output_1.data).read_u16_le(*output_1.script_offset+34),
            (*output_1.data).read_u56_le(*output_1.script_offset+36),
            0
        )
    } else if *output_1.script_length == 50 {
        (
            (*output_1.data).read_felt252(*output_1.script_offset+2),
            (*output_1.data).read_u16_le(*output_1.script_offset+34),
            (*output_1.data).read_u56_le(*output_1.script_offset+36),
            (*output_1.data).read_u56_le(*output_1.script_offset+43),
        )
    } else {
        return Result::Err('tx_data: output 1 invalid len');
    };

    let recipient: ContractAddress = recipient_felt252.try_into().unwrap();
    let amount_0: u256 = amount_0_u56.into() * token_0_multiplier.into();
    let amount_1: u256 = amount_1_u56.into() * token_1_multiplier.into();

    return Result::Ok((recipient, amount_0, amount_1, caller_fee_u16));
}

#[generate_trait]
pub impl U32ArrayToU256Parser of U32ArrayToU256ParserTrait {
    //Parse u256 from a a fixed-length u32 array (an output of the sha256 hash function)
    fn to_u256(self: [u32; 8]) -> u256 {
        let span = self.span();

        let high: felt252 = (*span[0]).into() * 0x1000000000000000000000000
            + (*span[1]).into() * 0x10000000000000000
            + (*span[2]).into() * 0x100000000
            + (*span[3]).into();

            let low: felt252 = (*span[4]).into() * 0x1000000000000000000000000
            + (*span[5]).into() * 0x10000000000000000
            + (*span[6]).into() * 0x100000000
            + (*span[7]).into();

        u256 {
            low: low.try_into().unwrap(),
            high: high.try_into().unwrap()
        }
    }
}
