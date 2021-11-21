
import 'package:solana/solana.dart';
import 'package:solana_chat/app/models/chat_wrapper.dart';

class AppState {
  Wallet wallet;
  RPCClient connection;
  List<ChatWrapper> chatList;

  AppState(this.wallet,
    this.connection,
    this.chatList);
}