import 'dart:typed_data';
import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:borsh/borsh.dart';
import 'package:solana_chat/app/widgets/chat/chat.dart';
import 'package:solana_chat/config/config.dart';

part 'chat_message.g.dart';


const _dummyMessage = dummyMessage;
const _dummyCreatedOn = dummyCreatedOn;

@Struct()
class ChatMessage extends BorshStruct{

  /*
  String message = dummyMessage;
  String createdOn = dummyCreatedOn; // max milliseconds in date
   */

  ChatMessage( {String? message, String? createdOn} ) {
    if (message != null && createdOn != null) {
      this.message = message;
      this.createdOn = createdOn;
    }
  }

  /*const ChatMessage({
    required this.message,
    required this.createdOn
  });*/

  factory ChatMessage.fromBorsh(List<int> bytes) => _ChatMessageFromBorsh(bytes);

  @override
  List<int> toBorsh() => _ChatMessageToBorsh(this);

  @string
  String message = _dummyMessage;

  @string
  String createdOn = _dummyCreatedOn;

}