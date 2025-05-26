use escrow_manager::structs;

pub fn assert_result(result: Result<(), felt252>, escrow: structs::escrow::EscrowData) {
    if result.is_err() {
        let mut byte_buffer: ByteArray = "";
        byte_buffer.append_word(result.unwrap_err(), 31);
        panic!("{} {:?}", byte_buffer, escrow);
    }
}

pub fn assert_result_error(result: Result<(), felt252>, expected: felt252, escrow: structs::escrow::EscrowData) {
    if result.is_err() {
        if result.unwrap_err() != expected {
            let mut byte_buffer: ByteArray = "";
            byte_buffer.append_word(result.unwrap_err(), 31);
            panic!("Unexpected error {} {:?}", byte_buffer, escrow);
        }
    } else {
        let mut byte_buffer: ByteArray = "";
        byte_buffer.append_word(expected, 31);
        panic!("Error not thrown, expected: {} {:?}", byte_buffer, escrow);
    }
}