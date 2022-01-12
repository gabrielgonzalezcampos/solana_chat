import 'dart:typed_data';
import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:borsh/borsh.dart';
import 'package:solana/solana.dart';
import 'package:solana_chat/app/models/chat_message.dart';
import 'package:solana_chat/app/providers/message_provider.dart';
import 'package:solana_chat/config/config.dart';

part 'chat_message_schema.g.dart';

const CHAT_MESSAGE_ELEMENTS_COUNT = 20;

@Struct()
class ChatMessageSchema extends BorshStruct{

  const ChatMessageSchema({
    required this.messages
  });

  factory ChatMessageSchema.fromBorsh(List<int> bytes) => _ChatMessageSchemaFromBorsh(bytes);

  @override
  List<int> toBorsh() => _ChatMessageSchemaToBorsh(this);

  @Array.dynamic(Borsh.string/*, length: MessageProvider.chatMessageElementsCount*/)
  final List<String> messages;

  List<ChatMessage> chatMessageList() {
    List<ChatMessage> chatMessageList= [];
    for (int i = 0; i < messages.length; i += 2) {
      if (messages[i] == dummyMessage) {
        break;
      }
      chatMessageList.add(ChatMessage(message: _trimMessage(messages[i]), createdOn: messages[i+1]));
    }
    return chatMessageList;
  }

  String _trimMessage(String message){
    return message.replaceAll(RegExp(r'^[0]{1,}'),'');
  }
}