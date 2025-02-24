use core::starknet::{get_contract_address, ContractAddress};
use openzeppelin_token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

//Transfer ERC20 tokens to the current contract using transfer_from function
pub fn transfer_in(token: ContractAddress, src: ContractAddress, amount: u256) {
    let erc20_dispatcher = IERC20Dispatcher { contract_address: token };
    assert(erc20_dispatcher.transfer_from(src, get_contract_address(), amount), 'transfer_in: transfer_from');
}

//Sends out ERC20 token from the current contract
pub fn transfer_out(token: ContractAddress, dst: ContractAddress, amount: u256) {
    let erc20_dispatcher = IERC20Dispatcher { contract_address: token };
    assert(erc20_dispatcher.transfer(dst, amount), 'transfer_out: transfer');
}

//Gets the balance of the specific owner
pub fn balance_of(token: ContractAddress, owner: ContractAddress) -> u256 {
    let erc20_dispatcher = IERC20Dispatcher { contract_address: token };
    erc20_dispatcher.balance_of(owner)
}
