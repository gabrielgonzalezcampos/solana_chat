import 'package:solana/solana.dart';
import 'package:solana_chat/app/models/chat_wrapper.dart';


class Singleton {
  static final Singleton _singleton = Singleton._internal();
  late Wallet _wallet;
  late SolanaClient _connection;
  List<ChatWrapper> chatList = [];

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal(){}

  Wallet get wallet => _wallet;

  set wallet(Wallet value) {
    _wallet = value;
  }

  SolanaClient get connection => _connection;

  set connection(SolanaClient value) {
    _connection = value;
  }

// List<TransactionWrapper> get saved => _saved;

}