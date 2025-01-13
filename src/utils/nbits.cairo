fn one_shift_left_bytes_u256(n_bytes: usize) -> u256 {
    match n_bytes {
        0 => 0x1,
        1 => 0x100,
        2 => 0x10000,
        3 => 0x1000000,
        4 => 0x100000000,
        5 => 0x10000000000,
        6 => 0x1000000000000,
        7 => 0x100000000000000,
        8 => 0x10000000000000000,
        9 => 0x1000000000000000000,
        10 => 0x100000000000000000000,
        11 => 0x10000000000000000000000,
        12 => 0x1000000000000000000000000,
        13 => 0x100000000000000000000000000,
        14 => 0x10000000000000000000000000000,
        15 => 0x1000000000000000000000000000000,
        16 => 0x100000000000000000000000000000000,
        17 => 0x10000000000000000000000000000000000,
        18 => 0x1000000000000000000000000000000000000,
        19 => 0x100000000000000000000000000000000000000,
        20 => 0x10000000000000000000000000000000000000000,
        21 => 0x1000000000000000000000000000000000000000000,
        22 => 0x100000000000000000000000000000000000000000000,
        23 => 0x10000000000000000000000000000000000000000000000,
        24 => 0x1000000000000000000000000000000000000000000000000,
        25 => 0x100000000000000000000000000000000000000000000000000,
        26 => 0x10000000000000000000000000000000000000000000000000000,
        27 => 0x1000000000000000000000000000000000000000000000000000000,
        28 => 0x100000000000000000000000000000000000000000000000000000000,
        29 => 0x10000000000000000000000000000000000000000000000000000000000,
        30 => 0x1000000000000000000000000000000000000000000000000000000000000,
        31 => 0x100000000000000000000000000000000000000000000000000000000000000,
        _ => panic(array!['n_bytes too large']),
    }
}

fn get_leading_zeroes_u128(num: u128) -> u32 {
    if num & 0xFF000000000000000000000000000000 != 0 {
        0
    } else if num & 0xFF0000000000000000000000000000 != 0 {
        1
    } else if num & 0xFF00000000000000000000000000 != 0 {
        2
    } else if num & 0xFF000000000000000000000000 != 0 {
        3
    } else if num & 0xFF0000000000000000000000 != 0 {
        4
    } else if num & 0xFF00000000000000000000 != 0 {
        5
    } else if num & 0xFF000000000000000000 != 0 {
        6
    } else if num & 0xFF0000000000000000 != 0 {
        7
    } else if num & 0xFF00000000000000 != 0 {
        8
    } else if num & 0xFF000000000000 != 0 {
        9
    } else if num & 0xFF0000000000 != 0 {
        10
    } else if num & 0xFF00000000 != 0 {
        11
    } else if num & 0xFF000000 != 0 {   
        12
    } else if num & 0xFF0000 != 0 {
        13
    } else if num & 0xFF00 != 0 {
        14
    } else if num & 0xFF != 0 {
        15
    } else {
        16
    }
}

//Calculates difficulty target from nBits
//Description: https://btcinformation.org/en/developer-reference#target-nbits
pub fn nbits_to_target(nbits: u32) -> u256 {
    let n_size = nbits & 0xFF;

    // let n_word: u32 = ((nbits / 0x100) & 0xFF) * 0x10000 +
    //     ((nbits / 0x10000) & 0xFF) * 0x100 +
    //     ((nbits / 0x1000000) & 0x7F);
    let n_word: u32 = (nbits & 0x7F00) * 0x100 +
        ((nbits / 0x100) & 0xFF00) +
        ((nbits / 0x1000000) & 0xFF);

    n_word.into() * one_shift_left_bytes_u256(n_size - 3)
}

//Compresses difficulty target to nBits
//Description: https://btcinformation.org/en/developer-reference#target-nbits
pub fn target_to_nbits(target: u256) -> u32 {
    let mut n_size: u32 = if target.high == 0 {
        //Only low
        16 - get_leading_zeroes_u128(target.low)
    } else {
        //Only high
        32 - get_leading_zeroes_u128(target.high)
    };

    let mut result: u32 = (target / one_shift_left_bytes_u256(n_size - 3)).low.try_into().unwrap();

    if (result & 0x00800000) == 0x00800000 {
        result /= 0x100;
        n_size += 1;
    }
    
    // (result & 0xFF) * 0x1000000 + ((result / 0x100) & 0xFF) * 0x10000 + ((result / 0x10000) & 0xFF) * 0x100 + n_size
    (result & 0xFF) * 0x1000000 + (result & 0xFF00) * 0x100 + ((result / 0x100) & 0xFF00) + n_size
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_nbits_to_target() {
        assert!(nbits_to_target(0x618c0217) == 0x028c610000000000000000000000000000000000000000);
    }

    #[test]
    fn test_target_to_nbits() {
        assert!(target_to_nbits(0x028c610000000000000000000000000000000000000000) == 0x618c0217);
    }

}