//Bitcoin constants
pub const DIFF_ADJUSTMENT_INTERVAL: u32 = 2016;
pub const TARGET_TIMESPAN_u32: u32 = 14 * 24 * 60 * 60; // 2 weeks
pub const TARGET_TIMESPAN: u256 = 14 * 24 * 60 * 60; // 2 weeks

//Lowest possible mining difficulty - highest possible target
pub const UNROUNDED_MAX_TARGET: u256 = 0x00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

//Maximum positive difference between bitcoin block's timestamp and Starknet's on-chain clock
//Nodes in bitcoin network generally reject any block with timestamp more than 2 hours in the future
//As we are dealing with another blockchain here,
// with the possibility of the Starknet's on-chain clock being skewed, we chose double the value - 4 hours
pub const MAX_FUTURE_BLOCKTIME: u32 = 4 * 60 * 60;
