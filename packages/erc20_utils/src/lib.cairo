use core::starknet::{get_contract_address, ContractAddress};
use openzeppelin_token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait, IERC20CamelDispatcher, IERC20CamelDispatcherTrait};

//Transfer ERC20 tokens to the current contract using transfer_from function
pub fn transfer_in(token: ContractAddress, is_legacy: bool, src: ContractAddress, amount: u256) {
    if is_legacy {
        let erc20_dispatcher = IERC20CamelDispatcher { contract_address: token };
        assert(erc20_dispatcher.transferFrom(src, get_contract_address(), amount), 'transfer_in: transfer_from');
    } else {
        let erc20_dispatcher = IERC20Dispatcher { contract_address: token };
        assert(erc20_dispatcher.transfer_from(src, get_contract_address(), amount), 'transfer_in: transfer_from');
    }
}

//Sends out ERC20 token from the current contract
pub fn transfer_out(token: ContractAddress, dst: ContractAddress, amount: u256) {
    let erc20_dispatcher = IERC20Dispatcher { contract_address: token };
    assert(erc20_dispatcher.transfer(dst, amount), 'transfer_out: transfer');
}

//Approves the spender to spend up to <amount> from this contract
pub fn approve(token: ContractAddress, spender: ContractAddress, amount: u256) {
    let erc20_dispatcher = IERC20Dispatcher { contract_address: token };
    assert(erc20_dispatcher.approve(spender, amount), 'approve: approve');
}

//Gets the balance of the specific owner
pub fn balance_of(token: ContractAddress, is_legacy: bool, owner: ContractAddress) -> u256 {
    if is_legacy {
        let erc20_dispatcher = IERC20CamelDispatcher { contract_address: token };
        erc20_dispatcher.balanceOf(owner)
    } else {
        let erc20_dispatcher = IERC20Dispatcher { contract_address: token };
        erc20_dispatcher.balance_of(owner)
    }
}