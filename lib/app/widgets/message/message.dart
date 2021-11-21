import 'dart:math';

import 'package:flutter/material.dart';
import 'package:solana_chat/app/models/messge_wrapper.dart';

class MessageWidget extends StatelessWidget {
  MessageWidget({Key? key, required this.message}) : super(key: key);

  final MessageWrapper message;
  late FractionalOffset alignment;
  late Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    _checkEmitter();

    return Align(
      alignment: alignment,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                  color: Colors.white24,
                  width: 0.5
              ),
              borderRadius: BorderRadius.circular(8.0)
            ),
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(message.message)
            ),
          ),
          const SizedBox(height: 4)
      ]),
    );
  }

  _checkEmitter() {
    if (message.mine){
      alignment = FractionalOffset.centerRight;
      backgroundColor = Colors.lightGreenAccent[100]!;
    } else{
      alignment = FractionalOffset.centerLeft;
      backgroundColor = Colors.white;
    }
  }
}
