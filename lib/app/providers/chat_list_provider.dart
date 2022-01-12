
import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:solana/solana.dart';
import 'package:solana_chat/app/helpers/common.dart';
import 'package:solana_chat/app/models/chat_message.dart';
import 'package:solana_chat/app/models/chat_wrapper.dart';
import 'package:solana_chat/app/models/messge_wrapper.dart';
import 'package:solana_chat/app/providers/message_provider.dart';
import 'package:solana_chat/app/providers/wallet_provider.dart';

class ChatListProvider extends ChangeNotifier {

  String _selectedChat = "";

  final HashMap<String, ChatWrapper> _chatMap = HashMap();

  BuildContext context;

  ChatListProvider(this.context);

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
    //chat.addMessages([message]);
    //chat.sentAmount++;
    showToast(context, "Sending Message...");
    sendMessage(context, message.message);
    notifyListeners();
  }

  void sendMessage(BuildContext context, String message) async {
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);

    if (walletProvider.wallet != null && walletProvider.connection != null){
      Wallet wallet = walletProvider.wallet!;
      SolanaClient connection = walletProvider.connection!;
      await Provider.of<MessageProvider>(context, listen: false).sendMessage(
          connection,
          wallet,
          _selectedChat,
          message);
      showToast(context, "Message sent");
      refreshMessages();
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

  void refreshMessages() async {
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    MessageProvider messageProvider = Provider.of<MessageProvider>(context, listen: false);

    List<ChatMessage> receivedMessages = await messageProvider.getMessageReceivedHistory(walletProvider.connection!, walletProvider.account);
    List<ChatMessage> sentMessages = await messageProvider.getMessageSentHistory(walletProvider.connection!, _selectedChat);
    List<MessageWrapper> newMessages = [];

    ChatWrapper chat = getChat(_selectedChat)!;

    for (int i = chat.receivedAmount; i<receivedMessages.length; i++ ) {
      newMessages.add(MessageWrapper(false, receivedMessages[i].message, createdOn: int.parse(receivedMessages[i].createdOn)));
    }
    for (int i = chat.sentAmount; i < sentMessages.length; i++ ) {
      newMessages.add(MessageWrapper(true, sentMessages[i].message, createdOn: int.parse(sentMessages[i].createdOn)));
    }

    chat.addMessages(newMessages);
    chat.sentAmount = sentMessages.length;
    chat.receivedAmount = receivedMessages.length;
    notifyListeners();
  }


}