
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:solana_chat/app/models/chat_wrapper.dart';
import 'package:solana_chat/app/models/messge_wrapper.dart';

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

  void addMessage(MessageWrapper message, String foreingAddress){
    ChatWrapper chat = _chatMap.putIfAbsent(foreingAddress, () => ChatWrapper(foreingAddress));
    chat.messages.add(message);
    notifyListeners();
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