import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solana_chat/app/providers/chat_list_provider.dart';
import 'package:solana_chat/app/providers/wallet_provider.dart';

import 'app/app.dart';
import 'app/providers/message_provider.dart';
import 'app/widgets/sidebar/navbar.dart';

void main() {
  String title = 'Solana Chat';

  //WalletProvider walletProvider = WalletProvider();
  MessageProvider messageProvider = MessageProvider();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => messageProvider),
        ChangeNotifierProvider(create: (context) => ChatListProvider()),
        ChangeNotifierProvider(create: (context) => WalletProvider(context))
      ],
    child: MyApp(title: title),
  )
  );
}