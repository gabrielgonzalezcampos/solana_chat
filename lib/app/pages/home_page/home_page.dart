import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solana/solana.dart';
import 'package:solana_chat/app/helpers/common.dart';
import 'package:solana_chat/app/helpers/wallet.dart';
import 'package:solana_chat/app/pages/add_page/add_page.dart';
import 'package:solana_chat/app/pages/chat_page/chat_page.dart';
import 'package:solana_chat/app/providers/chat_list_provider.dart';
import 'package:solana_chat/app/providers/wallet_provider.dart';
import 'package:solana_chat/app/widgets/chat/chat.dart';
import 'package:solana_chat/app/widgets/sidebar/navbar.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key/*, required this.title*/}) : super(key: key);
  String selected = '';

  // final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Widget> childrenWidgets = [AddPage()];
  int index = 0;
  bool _initWallet = false;
  bool _createdWallet = false;
  bool _createdAccount = false;

  //final Singleton singleton = Singleton();


  @override
  Widget build(BuildContext context) {
    //WidgetsBinding.instance!.addPostFrameCallback((_) => _afterBuild(context));
    Provider.of<WalletProvider>(context, listen: false).context = context;
    Provider.of<ChatListProvider>(context, listen: false).context = context;

    return Consumer<WalletProvider>(
        builder: (context, walletProvider, child) {

          print("Init: $_initWallet, created: $_createdWallet, res: ${!_createdWallet && walletProvider.wallet != null}");
          if (!_initWallet && walletProvider.wallet == null) {
            WidgetsBinding.instance!.addPostFrameCallback((_) => _afterBuild(context));
            _initWallet = true;
          } else if (!_createdWallet && walletProvider.wallet != null) {
            WidgetsBinding.instance!.addPostFrameCallback((_) => _afterBuild(context));
            _initWallet = true;
            _createdWallet = true;
          }
          if(walletProvider.account != "") {
            _createdAccount = true;
          }

          if (child != null) {
            return child;
          } else {
            return childrenWidgets[index];
          }
        },
        child: Consumer<ChatListProvider>(
          builder: (context, chatlistProvider, child) {
            String selected = chatlistProvider.selectedChat;
            if (child != null && selected == widget.selected){
              return child;
            }
            if (selected==''){
              widget.selected = "";
              return const AddPage();
            }
            widget.selected = selected;
            return Chat(chatPubK: selected);
          }
        )
    );
  }

  void _afterBuild(BuildContext context){
    print("After Build ============================================");
    if (_initWallet && !_createdWallet) {
      showToast(context, "Initializing wallet...");
    } else if (_createdWallet) {
      showToast(context, "Wallet created");
      _createdWallet = true;
    }
  }
}