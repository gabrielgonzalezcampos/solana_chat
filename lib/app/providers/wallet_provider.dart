
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:solana/solana.dart';
import 'package:solana_chat/app/helpers/wallet.dart';
import 'package:solana_chat/app/providers/message_provider.dart';
import 'package:solana_chat/app/services/solana/accounts.dart';
import 'package:solana_chat/config/config.dart';
import 'package:tuple/tuple.dart';

class WalletProvider extends ChangeNotifier{

  bool _random = false;
  final programID = addMessageProgramID;
  List<int> _seed = seed1;
  String account = "";

  get random => _random;

  set random(value) {
    _random = value;
  }

  Wallet? _wallet;
  SolanaClient? _connection;
  BuildContext _context;

  set context(BuildContext value) {
    _context = value;
  }

  WalletProvider(this._context) {
    print("init wallet provider");
    initializeWallet();
  }

  Wallet? get wallet => _wallet;

  set wallet(Wallet? value) {
    _wallet = value;
  }

  SolanaClient? get connection => _connection;

  set connection(SolanaClient? value) {
    _connection = value;
  }



  void initializeWallet({int size = 300}) async {
    Tuple2<SolanaClient, Wallet> tuple;
    if (_random){
      tuple = await initWallet();
    } else {
      tuple = await initWalletFromSeed(_seed, size: size);
    }
    _setWalletAndConnection(tuple.item2, tuple.item1);
    _setAccount();
    notifyListeners();
  }

  void _setWalletAndConnection(Wallet w, SolanaClient c){
    wallet = w;
    connection = c;
    print('Wallet PK: ${wallet!.address}');
    notifyListeners();
  }

  void _setAccount() async {
    int size = Provider.of<MessageProvider>(_context, listen: false).chatMessagesSize;
    account = await getChatMessageAccountPubKey(_connection!, _wallet!, size);
  }

  List<int> get seed => _seed;

  set seed(List<int> value) {
    _seed = value;
  }
}