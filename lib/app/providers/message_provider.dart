import 'package:flutter/cupertino.dart';
import 'package:solana/solana.dart';
import 'package:solana_chat/app/models/chat_message.dart';
import 'package:solana_chat/app/models/chat_message_schema.dart';
import 'package:solana_chat/config/config.dart';

class MessageProvider extends ChangeNotifier{

  static const String programId = addMessageProgramID;//"DG22HUiwjJgwj7a3wviiNB2pDT55tnxch2eTansJZnVz";//"DG22HUiwjJgwj7a3wviiNB2pDT55tnxch2eTansJZnVz";//"DG22HUiwjJgwj7a3wviiNB2pDT55tnxch2eTansJZnVz";
  int chatMessagesSize = 0;
  static const int chatMessageElementsCount = messageElementsCount;

  setChatMessagesDataSize() {
    List<ChatMessage> sampleChatMessages = _getDefaultChatMessages();

    int length = 0;
    for (int i = 0; i < sampleChatMessages.length; i++) {
      length += sampleChatMessages[i].toBorsh().length;
    }
    chatMessagesSize = length + 4; // plus 4 due to some data diffs between client and program
  }

  MessageProvider(){
    setChatMessagesDataSize();
  }

  List<ChatMessage> _getDefaultChatMessages() {
    List<ChatMessage> chatMessages = [];
    for (int i = 0; i < chatMessageElementsCount; i++) {
      chatMessages.add(ChatMessage());
    }

    return chatMessages;
  }

  Future<List<ChatMessage>> getAccountMessageHistory(
    SolanaClient connection,
    String pubKeyStr
  ) async {
    //const sentPubkey = new PublicKey(pubKeyStr);
    Account? sentAccount = await connection.rpcClient.getAccountInfo(pubKeyStr, encoding: Encoding.base64);
    // get and deserialize solana account data and receive txid
    // go to arweave and query using these txid
    // parse json and return ChatMessages
    if (sentAccount == null) {
      throw Exception('Account $pubKeyStr does not exist');
    }
    //TODO deserialize data
    BinaryAccountData dataBuffer = sentAccount.data as BinaryAccountData;
    //List<int> dataBuffer = Buffer.fromBase58(sentAccount.data as BinaryAccountData).toList();
    ChatMessageSchema chat = ChatMessageSchema.fromBorsh(dataBuffer.data);
    return chat.chatMessageList();
  }

  Future<List<ChatMessage>> getMessageSentHistory(
    SolanaClient connection,
    String sentChatPubkeyStr
  ) async {
    List<ChatMessage> messages = await getAccountMessageHistory( connection, sentChatPubkeyStr);
    print("getMessageSentHistory ${messages.toString()}");
    return messages;
  }

  Future<List<ChatMessage>> getMessageReceivedHistory(
      SolanaClient connection,
      String walletChatPubkeyStr
      ) async {
    List<ChatMessage> messages = await getAccountMessageHistory( connection, walletChatPubkeyStr);
    print("getMessageReceivedHistory ${messages.toString()}");
    return messages;
  }


  Future<String> sendMessage(
    SolanaClient connection,
    Wallet wallet,
    String destPubkeyStr,
    String message
  ) async {
    print("start sendMessage");

    ChatMessage messageObj = ChatMessage();
    messageObj.message = _getMessage(message);
    messageObj.createdOn = _getCreatedOn();
    Instruction messageInstruction = Instruction(
      programId: programId,
      accounts: [
        AccountMeta.writeable(pubKey: destPubkeyStr, isSigner: false)
      ],
      data: messageObj.toBorsh()
    );
    Message messageTransaction = Message(instructions: [messageInstruction]);

    String signature = await connection.rpcClient.signAndSendTransaction(messageTransaction, [wallet]);
    await connection.waitForSignatureStatus(signature, status: ConfirmationStatus.finalized);
    TransactionDetails? result = await connection.rpcClient.getTransaction(signature, commitment: Commitment.finalized);

    //print("end sendMessage ${result?.transaction.message?.instructions.toString()}");
    if (result == null) {
      return "OK: Message saved Successfully";
    }
    return result.toString();
  }

  String _getMessage(String message){
    if (message.length > dummyMessage.length) {
      throw Exception("Message too long");
    }
    int total = dummyMessage.length;
    int diff = total - message.length;
    String prefix = "";
    for(int i = 0; i < diff; i++){
      prefix += "0";
    }
    String newMessage = prefix + message;
    print("newMessage: $newMessage");
    return newMessage;
  }

  String _getCreatedOn(){
    String now = DateTime.now().millisecond.toString();
    int total = dummyCreatedOn.length;
    int diff = total - now.length;
    String prefix = "";
    for(int i = 0; i < diff; i++){
      prefix += "0";
    }
    String createdOn = prefix + now;
    print("createdOn: $createdOn");
    return createdOn;
  }

}
