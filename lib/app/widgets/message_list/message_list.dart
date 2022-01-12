import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solana_chat/app/models/chat_wrapper.dart';
import 'package:solana_chat/app/models/messge_wrapper.dart';
import 'package:solana_chat/app/providers/chat_list_provider.dart';
import 'package:solana_chat/app/widgets/message/message.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key, required this.chatPubK}) : super(key: key);

  final String chatPubK;



  @override
  MessageListState createState() => MessageListState();
}

class MessageListState extends State<MessageList> {

  int _prevLength = 0;

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          color: Colors.blue[50]
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ChatListProvider>(
          builder: (context, chatListProvider, child) {
            ChatWrapper? chat = chatListProvider.getChat(widget.chatPubK);
            if (chat == null) {
              chatListProvider.setSelectedChat("");
            } else {
              if (child != null && _prevLength == chat.messages.length){
                return child;
              }
              return _buildList(chat.messages);
            }
            return const Text("ERROR");
          }
        ),
      ),
    );
  }

  ListView _buildList( List<MessageWrapper> messages){
    ListView listView = ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, i) {
          return _buildRow(messages[i]);
        }
    );
    _prevLength = messages.length;
    return listView;
  }

  Widget _buildRow(MessageWrapper message) {
    return MessageWidget(message: message);
  }

}
