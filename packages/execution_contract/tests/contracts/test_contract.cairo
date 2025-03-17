#[derive(Drop, starknet::Event)]
pub struct TestEvent {
    pub data: felt252
}

#[starknet::interface]
pub trait ITestContract<TContractState> {
    fn event(ref self: TContractState, data: felt252);
    fn panic(self: @TContractState, err: felt252);
}

#[starknet::contract]
pub mod TestContract {
    use super::*;

    #[storage]
    struct Storage {}

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        TestEvent: TestEvent
    }

    #[abi(embed_v0)]
    pub impl TestContractImpl of ITestContract<ContractState> {
        fn event(ref self: ContractState, data: felt252) {
            self.emit(TestEvent {data: data});
        }

        fn panic(self: @ContractState, err: felt252) {
            panic(array![err]);
        }
    }
}
