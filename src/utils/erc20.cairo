use core::starknet::{get_contract_address, ContractAddress};
use openzeppelin_token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

pub fn transfer_in(token: ContractAddress, src: ContractAddress, amount: u256) {
    let erc20_dispatcher = IERC20Dispatcher { contract_address: token };
    assert(erc20_dispatcher.transfer_from(src, get_contract_address(), amount), 'transfer_in: transfer_from');
}

pub fn transfer_out(token: ContractAddress, dst: ContractAddress, amount: u256) {
    let erc20_dispatcher = IERC20Dispatcher { contract_address: token };
    assert(erc20_dispatcher.transfer(dst, amount), 'transfer_out: transfer');
}
