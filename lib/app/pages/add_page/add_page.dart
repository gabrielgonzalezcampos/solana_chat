import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solana_chat/app/helpers/common.dart';
import 'package:solana_chat/app/models/chat_wrapper.dart';
import 'package:solana_chat/app/providers/chat_list_provider.dart';
import 'package:solana_chat/app/services/singleton.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  late TextEditingController _controller;
  Singleton _singleton = Singleton();

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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter PubK to send messages'
                ),
              ),
              ElevatedButton(onPressed: () => _addChat(), child: Text('ADD CHAT'))
            ],
          ),
        ),
    );
  }

  void _addChat(){
    if (_controller.text != ''){
      Provider.of<ChatListProvider>(context, listen: false).add(ChatWrapper(_controller.text));
      showToast(context, "Chat added");
    }
  }
}

