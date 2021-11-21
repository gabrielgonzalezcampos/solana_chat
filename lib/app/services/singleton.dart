import 'package:solana/solana.dart';
import 'package:solana_chat/app/models/chat_wrapper.dart';


class Singleton {
  static final Singleton _singleton = Singleton._internal();
  late Wallet _wallet;
  late RPCClient _connection;
  List<ChatWrapper> chatList = [];

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal(){}

  Wallet get wallet => _wallet;

  set wallet(Wallet value) {
    _wallet = value;
  }

  RPCClient get connection => _connection;

  set connection(RPCClient value) {
    _connection = value;
  }

// List<TransactionWrapper> get saved => _saved;

}