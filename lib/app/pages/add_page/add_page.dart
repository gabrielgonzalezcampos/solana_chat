import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solana_chat/app/helpers/common.dart';
import 'package:solana_chat/app/helpers/wallet.dart';
import 'package:solana_chat/app/models/chat_wrapper.dart';
import 'package:solana_chat/app/providers/chat_list_provider.dart';
import 'package:solana_chat/app/providers/message_provider.dart';
import 'package:solana_chat/app/providers/wallet_provider.dart';
import 'package:solana_chat/app/services/singleton.dart';
import 'package:solana_chat/config/config.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  late TextEditingController _controller;
  Singleton _singleton = Singleton();
  bool toggleState = false;

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
              const Text("Change wallet"),
              Switch(
                value: toggleState,
                onChanged: (bool value) {
                  _changeWallet(value);
                  setState(() => {
                    toggleState = value
                  });
                },
              ),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
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

  void _changeWallet(bool selector){
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    if (selector) {
      walletProvider.seed = seed2;
    } else {
      walletProvider.seed = seed1;
    }
    walletProvider.initializeWallet(size: Provider.of<MessageProvider>(context, listen: false).chatMessagesSize + 10);
  }
}

