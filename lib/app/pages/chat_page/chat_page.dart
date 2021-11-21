import 'package:flutter/material.dart';
import 'package:solana_chat/app/widgets/chat/chat.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chat(chatPubK: 'test',);
  }
}
