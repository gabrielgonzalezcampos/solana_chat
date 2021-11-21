
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:solana/solana.dart';
import 'package:solana_chat/app/helpers/wallet.dart';
import 'package:tuple/tuple.dart';

class WalletProvider extends ChangeNotifier{

  final _random = false;
  final List<int> _seed = [25329, 53596, 44472, 42839, 11091, 41866, 18078, 47681, 2545, 28638, 3474, 60464, 14461, 48272, 38968, 38224, 33849, 17078, 4765, 29883, 14977, 46468, 14029, 23655, 19495];

  Wallet? _wallet;
  RPCClient? _connection;

  WalletProvider() {
    print("init wallet provider");
    _initializeWallet();
    notifyListeners();
  }

  Wallet? get wallet => _wallet;

  set wallet(Wallet? value) {
    _wallet = value;
  }

  RPCClient? get connection => _connection;

  set connection(RPCClient? value) {
    _connection = value;
  }



  void _initializeWallet() async {
    Tuple2<RPCClient, Wallet> tuple;
    if (_random){
      tuple = await initWallet();
    } else {
      tuple = await initWalletFromSeed(_seed);
    }
    _setWalletAndConnection(tuple.item2, tuple.item1);
  }

  void _setWalletAndConnection(Wallet w, RPCClient c){
    wallet = w;
    connection = c;
    print('Wallet PK: ${wallet!.address}');
    notifyListeners();
  }


}