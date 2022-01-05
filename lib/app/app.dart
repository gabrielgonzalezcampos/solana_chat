import 'package:flutter/material.dart';
import 'package:solana/solana.dart';
import 'package:solana_chat/app/pages/home_page/home_page.dart';
import 'package:solana_chat/app/services/singleton.dart';
import 'package:solana_chat/app/widgets/sidebar/navbar.dart';
import 'package:solana_chat/config/config.dart';

import 'helpers/common.dart';
import 'helpers/wallet.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.title}) : super(key: key);

  late Wallet wallet;
  late RPCClient connection;
  final String title;

  final bool random = false;
  Singleton singleton = Singleton();

  final List<int> seed = seed1;//8bNjUHdtJXHYsabG7cfQbHKJDb9VPpccXYLUW3pbR7Td

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Solana Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
        title: Text(title),
        ),
        drawer: NavBar(),
        body: MyHomePage(),
      ),
    );
  }
}