import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solana_chat/app/models/messge_wrapper.dart';
import 'package:solana_chat/app/providers/chat_list_provider.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({Key? key, required this.chatPubK}) : super(key: key);
  final String chatPubK;

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.clear();
    return Container(
      child: Center(
        child: Row(
          children: [
            Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Message'
                  ),
                ),
            ),
            TextButton(onPressed: () => _submit(), child: Text("Send"))
          ],
        ),
      ),
    );
  }

  void _submit(){
    if (_controller.text != ''){
      //TODO send message

      MessageWrapper newMessage = MessageWrapper(Random().nextBool(), _controller.text);
      Provider.of<ChatListProvider>(context, listen: false).addMessage(newMessage, widget.chatPubK);
      _controller.clear();
    }
  }
}
