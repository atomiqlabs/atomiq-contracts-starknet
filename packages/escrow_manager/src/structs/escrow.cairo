use starknet::ContractAddress;
use core::hash::{HashStateTrait, HashStateExTrait};
use core::poseidon::PoseidonTrait;

//////////////////////////////////////////////////////////////////
/// To be used when ISafeDispatcher starts working on starknet ///
//////////////////////////////////////////////////////////////////
// impl Felt252SpanImpl<HashState, +HashStateTrait<HashState>, +Drop<HashState>> of Hash<Span<felt252>, HashState> {
//     fn update_state(state: HashState, value: Span<felt252>) -> HashState {
//         let mut result = state;
//         for element in value {
//             result = result.update(*element);
//         };
//         result
//     }
// }

// impl ContractCallSpanImpl<HashState, +HashStateTrait<HashState>, +Drop<HashState>> of Hash<Span<ContractCall>, HashState> {
//     fn update_state(state: HashState, value: Span<ContractCall>) -> HashState {
//         let mut result = state;
//         for element in value {
//             result = result.update_with(*element);
//         };
//         result
//     }
// }

// #[derive(Drop, Hash, Copy, Serde)]
// pub struct ContractCall {
//     pub address: ContractAddress,
//     pub selector: felt252,
//     pub calldata: Span<felt252>
// }

pub const FLAG_PAY_OUT: u8 = 0x01;
pub const FLAG_PAY_IN: u8 = 0x02;
pub const FLAG_REPUTATION: u8 = 0x04;

//Escrow data, this is hashed and used as a storage key for the escrow state mapping
#[derive(Drop, Hash, Copy, Serde, Debug)]
pub struct EscrowData {
    //Account funding the escrow
    pub offerer: ContractAddress,
    //Account entitled to claim the funds from the escrow
    pub claimer: ContractAddress,
    //Token of the escrow
    pub token: ContractAddress,
    //Address of the IRefundHandler deciding if this escrow is refundable
    pub refund_handler: ContractAddress,
    //Address of the IClaimHandler deciding if this escrow is claimable
    pub claim_handler: ContractAddress,

    //Misc escrow data flags, currently defined: payIn, payOut, reputation
    pub flags: u8,

    //Data provided to the claim handler along with the witness to check claimability
    pub claim_data: felt252,
    //Data provided to the refund handler along with the witness to check for refundability
    pub refund_data: felt252,

    //Amount of tokens in the escrow
    pub amount: u256,

    //Gas/fee token of the swap 
    pub fee_token: ContractAddress,
    //Security deposit taken by the offerer if swap expires without claimer claiming (i.e. options premium)
    pub security_deposit: u256,
    //Claimer bounty that can be claimed by a 3rd party claimer if he were to claim this swap on behalf of claimer
    pub claimer_bounty: u256,

    //TO BE ADDED: Misc contract calls to be executed during claim instead of just paying out the funds to the claimer
    // can support automatic staking/swapping/depositing on claim 
    // pub success_action: Span<ContractCall>
}

#[generate_trait]
pub impl EscrowDataImpl of EscrowDataImplTrait {
    //Returns poseidon hash of the struct, used as a key for mapping storing the escrow state
    fn get_struct_hash(self: EscrowData) -> felt252 {
        PoseidonTrait::new().update_with(self).finalize()
    }

    //Checks if the payIn flag is set
    fn is_pay_in(self: @EscrowData) -> bool {
        (*self.flags) & FLAG_PAY_IN == FLAG_PAY_IN
    }

    //Checks if the payOut flag is set
    fn is_pay_out(self: @EscrowData) -> bool {
        (*self.flags) & FLAG_PAY_OUT == FLAG_PAY_OUT
    }

    //Checks if the reputation flag is set
    fn is_tracking_reputation(self: @EscrowData) -> bool {
        (*self.flags) & FLAG_REPUTATION == FLAG_REPUTATION
    }

    //Returns total deposit, since only one of security_deposit (on claim) & claimer_bounty (on refund) can ever be paid
    // we use maximum of the two as the amount of funds in gas token that needs to be transfered to the escrow
    fn get_total_deposit(self: @EscrowData) -> u256 {
        if (*self.claimer_bounty) > (*self.security_deposit) { *self.claimer_bounty } else { *self.security_deposit }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use starknet::contract_address::{contract_address_const};

    fn get_escrow_data(flags: u8, security_deposit: u256, claimer_bounty: u256) -> EscrowData {
        EscrowData {
            offerer: contract_address_const::<'offerer'>(),
            claimer: contract_address_const::<'claimer'>(),
            token: contract_address_const::<'token'>(),
            refund_handler: contract_address_const::<'refund_handler'>(),
            claim_handler: contract_address_const::<'claim_handler'>(),

            flags,

            claim_data: 0,
            refund_data: 0,

            amount: 0,

            fee_token: contract_address_const::<'fee_token'>(),
            security_deposit,
            claimer_bounty
        }
    }

    //Tests parsing of escrow struct flags
    #[test]
    fn parse_flags() {
        let escrow_data = get_escrow_data(0b000, 0 ,0);
        assert_eq!(escrow_data.is_pay_out(), false);
        assert_eq!(escrow_data.is_pay_in(), false);
        assert_eq!(escrow_data.is_tracking_reputation(), false);
        
        let escrow_data = get_escrow_data(0b001, 0 ,0);
        assert_eq!(escrow_data.is_pay_out(), true);
        assert_eq!(escrow_data.is_pay_in(), false);
        assert_eq!(escrow_data.is_tracking_reputation(), false);
        
        let escrow_data = get_escrow_data(0b010, 0 ,0);
        assert_eq!(escrow_data.is_pay_out(), false);
        assert_eq!(escrow_data.is_pay_in(), true);
        assert_eq!(escrow_data.is_tracking_reputation(), false);
        
        let escrow_data = get_escrow_data(0b011, 0 ,0);
        assert_eq!(escrow_data.is_pay_out(), true);
        assert_eq!(escrow_data.is_pay_in(), true);
        assert_eq!(escrow_data.is_tracking_reputation(), false);
        
        let escrow_data = get_escrow_data(0b100, 0 ,0);
        assert_eq!(escrow_data.is_pay_out(), false);
        assert_eq!(escrow_data.is_pay_in(), false);
        assert_eq!(escrow_data.is_tracking_reputation(), true);
        
        let escrow_data = get_escrow_data(0b101, 0 ,0);
        assert_eq!(escrow_data.is_pay_out(), true);
        assert_eq!(escrow_data.is_pay_in(), false);
        assert_eq!(escrow_data.is_tracking_reputation(), true);
        
        let escrow_data = get_escrow_data(0b110, 0 ,0);
        assert_eq!(escrow_data.is_pay_out(), false);
        assert_eq!(escrow_data.is_pay_in(), true);
        assert_eq!(escrow_data.is_tracking_reputation(), true);
        
        let escrow_data = get_escrow_data(0b111, 0 ,0);
        assert_eq!(escrow_data.is_pay_out(), true);
        assert_eq!(escrow_data.is_pay_in(), true);
        assert_eq!(escrow_data.is_tracking_reputation(), true);
    }

    //Tests total deposit calculation
    #[test]
    fn total_deposit() {
        let escrow_data = get_escrow_data(0, 0 ,0);
        assert_eq!(escrow_data.get_total_deposit(), 0);

        let escrow_data = get_escrow_data(0, 100, 100);
        assert_eq!(escrow_data.get_total_deposit(), 100);

        let escrow_data = get_escrow_data(0, 150, 100);
        assert_eq!(escrow_data.get_total_deposit(), 150);

        let escrow_data = get_escrow_data(0, 100, 150);
        assert_eq!(escrow_data.get_total_deposit(), 150);
    }

}
