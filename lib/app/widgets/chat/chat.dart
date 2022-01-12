import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solana_chat/app/models/messge_wrapper.dart';
import 'package:solana_chat/app/providers/chat_list_provider.dart';
import 'package:solana_chat/app/providers/message_provider.dart';
import 'package:solana_chat/app/providers/wallet_provider.dart';
import 'package:solana_chat/app/widgets/message_list/message_list.dart';
import 'package:solana_chat/app/widgets/send_message/send_message.dart';

class Chat extends StatelessWidget {
  const Chat({Key? key, required this.chatPubK}) : super(key: key);

  final String chatPubK;

  @override
  Widget build(BuildContext context) {



    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
                color: Colors.indigo,
                width: 2.0
            )
        ),
        child: Column(
          children: [
            Expanded(child: MessageList( chatPubK: chatPubK)),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: SendMessage(chatPubK: chatPubK),
            )
          ],
        ),
      ),
    );
  }
}

