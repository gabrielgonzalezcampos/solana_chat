
import 'package:flutter/cupertino.dart';
import 'package:solana_chat/app/providers/chat_list_provider.dart';
import 'package:solana_chat/app/providers/wallet_provider.dart';

class AppProvider extends ChangeNotifier {

  final WalletProvider walletProvider = WalletProvider();
  final ChatListProvider chatListProvider = ChatListProvider();

}