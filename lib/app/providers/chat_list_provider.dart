
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:solana/solana.dart';
import 'package:solana_chat/app/models/chat_wrapper.dart';
import 'package:solana_chat/app/models/messge_wrapper.dart';
import 'package:solana_chat/app/providers/message_provider.dart';
import 'package:solana_chat/app/providers/wallet_provider.dart';

class ChatListProvider extends ChangeNotifier {

  String _selectedChat = "";

  final HashMap<String, ChatWrapper> _chatMap = HashMap();

  UnmodifiableMapView<String, ChatWrapper> get chatMap => UnmodifiableMapView(_chatMap);

  String get selectedChat => _selectedChat;

  void add(ChatWrapper chat) {
    _chatMap.putIfAbsent(chat.address, () => chat);

    notifyListeners();
  }

  void removeAll() {
    _chatMap.clear();
    _selectedChat = '';
    notifyListeners();
  }

  void addMessage(BuildContext context, MessageWrapper message/*, String foreingAddress*/){
    ChatWrapper chat = _chatMap.putIfAbsent(_selectedChat, () => ChatWrapper(_selectedChat));
    chat.messages.add(message);
    sendMessage(context, message.message);
    notifyListeners();
  }

  void sendMessage(BuildContext context, String message){
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);

    if (walletProvider.wallet != null && walletProvider.connection != null){
      Wallet wallet = walletProvider.wallet!;
      RPCClient connection = walletProvider.connection!;
      Provider.of<MessageProvider>(context, listen: false).sendMessage(
          connection,
          wallet,
          _selectedChat,
          message);
    }
  }

  void setSelectedChat(String selectedChatPubK){
    if (!_chatMap.containsKey(selectedChatPubK)) {
      _selectedChat = "";
    } else {
      _selectedChat = selectedChatPubK;
    }
    notifyListeners();
  }

  ChatWrapper? getChat(String selectedChatPubK){
    return _chatMap[selectedChatPubK];
  }

}