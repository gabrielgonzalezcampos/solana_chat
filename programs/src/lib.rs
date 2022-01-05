use borsh::{ BorshDeserialize, BorshSerialize };
use solana_program::{
    log::sol_log_compute_units,
    account_info::{ next_account_info, AccountInfo },
    entrypoint,
    entrypoint::ProgramResult,
    msg,
    program_error::ProgramError,
    pubkey::Pubkey,
};
use std::io::ErrorKind::InvalidData;

#[derive(BorshSerialize, BorshDeserialize, Debug)]
pub struct ChatMessage {
    pub message: String,
    pub createdOn: String
}


const DUMMY_TX_ID: &str = "0000000000000000000000000000000000000000000";
const DUMMY_CREATED_ON: &str = "0000000000000000"; // milliseconds, 16 digits
const MESSAGE_NUMBER: i32 = 20; // milliseconds, 16 digits
pub fn get_init_chat_message() -> ChatMessage {
    ChatMessage{ message: String::from(DUMMY_TX_ID), created_on: String::from(DUMMY_CREATED_ON) }
}
pub fn get_init_chat_messages() -> Vec<ChatMessage> {
    let mut messages = Vec::new();
    for _ in 0..MESSAGE_NUMBER {
        messages.push(get_init_chat_message());
    }
    return messages;
}


entrypoint!(process_instruction);

pub fn process_instruction(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    instruction_data: &[u8]
) -> ProgramResult {
    let accounts_iter = &mut accounts.iter();
    let account = next_account_info(accounts_iter)?;
    if account.owner != program_id {
        msg!("This account {} is not owned by this program {} and cannot be updated!", account.key, program_id);
    }

    sol_log_compute_units();

    let instruction_data_message = ChatMessage::try_from_slice(instruction_data).map_err(|err| {
        msg!("Attempt to deserialize instruction data has failed. {:?}", err);
        ProgramError::InvalidInstructionData
    })?;
    msg!("Instruction_data message object {:?}", instruction_data_message);

    let mut existing_data_messages = match <Vec<ChatMessage>>::try_from_slice(&account.data.borrow_mut()) {
        Ok(data) => data,
        Err(err) => {
            if err.kind() == InvalidData {
                msg!("InvalidData so initializing account data");
                get_init_chat_messages()
            } else {
                panic!("Unknown error decoding account data {:?}", err)
            }
        }
    };
    let index = existing_data_messages.iter().position(|p| p.message == String::from(DUMMY_TX_ID)).unwrap(); // find first dummy data entry
    msg!("Found index {}", index);
    existing_data_messages[index] = instruction_data_message; // set dummy data to new entry
    let updated_data = existing_data_messages.try_to_vec().expect("Failed to encode data."); // set messages object back to vector data
    msg!("Final existing_data_messages[index] {:?}", existing_data_messages[index]);

    // data algorithm for storing data into account and then archiving into Arweave
    // 1. Each ChatMessage object will be prepopulated for txt field having 43 characters (length of a arweave tx).
    // Each ChatMessageContainer will be prepopulated with 10 ChatMessage objects with dummy data.
    // 2. Client will submit an arweave tx for each message; get back the tx id; and submit it to our program.
    // 3. This tx id will be saved to the Solana program and be used for querying back to arweave to get actual data.
    let data = &mut &mut account.data.borrow_mut();
    msg!("Attempting save data.");
    msg!("Account data length: {:?}", data.len());
    msg!("Updated data length: {:?}", updated_data.len());
    msg!("Updated data slice: {:?}", updated_data);
    data[..updated_data.len()].copy_from_slice(&updated_data);
    let saved_data = <Vec<ChatMessage>>::try_from_slice(data)?;
    msg!("ChatMessage has been saved to account data. {:?}", saved_data[index]);
    sol_log_compute_units();

    msg!("End program.");
    Ok(())
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        let result = 2 + 2;
        assert_eq!(result, 4);
    }
}
