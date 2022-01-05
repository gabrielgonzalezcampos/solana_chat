import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solana_chat/app/models/chat_wrapper.dart';
import 'package:solana_chat/app/providers/chat_list_provider.dart';
import 'package:solana_chat/app/providers/wallet_provider.dart';
import 'package:solana_chat/app/services/singleton.dart';
import 'package:solana_chat/app/widgets/sidebar/sidebar_user_info.dart';

class NavBar extends StatelessWidget {
  NavBar({Key? key}) : super(key: key);

  final Singleton singleton = Singleton();

  @override
  Widget build(BuildContext context) {

    UnmodifiableMapView<String, ChatWrapper> chatList = Provider.of<ChatListProvider>(context, listen: false).chatMap;

    return Drawer(
      child: Column(
        children: [
          Consumer<WalletProvider>(
            builder: (context, walletProvider, child) {
              if (child != null) return child;
              return _buildUserInfo(walletProvider);
            }
          ),
          Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add Chat'),
                    onTap: () => _setSelectedChat("", context),
                  ),
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: chatList.length,
                      itemBuilder: (context, i) {
                        return _buildRow(chatList.values.elementAt(i), context);
                      }
                  )
                ],
              )
          )
        ],
      )
    );
  }

  Widget _buildRow(ChatWrapper chat, BuildContext context){
    return ListTile(
      leading: Icon(Icons.message),
      title: Text(chat.address),
      onTap: () => _setSelectedChat(chat.address, context),
    );
  }

  _setSelectedChat(String chatPubK, BuildContext context){
    Provider.of<ChatListProvider>(context, listen: false).setSelectedChat(chatPubK);
    Navigator.pop(context);
  }

  UserInfo _buildUserInfo(walletProvider){
    if (walletProvider.wallet == null) {
      return const UserInfo(
          address: 'Initializing wallet...',
          mail: 'chat@solana.com',
          image: 'http://images.hdqwalls.com/wallpapers/flutter-logo-4k-qn.jpg'
      );
    }
    return UserInfo(
        address: walletProvider.wallet!.address,
        mail: walletProvider.account,
        image: 'http://images.hdqwalls.com/wallpapers/flutter-logo-4k-qn.jpg'
    );
  }
}


/*Widget build(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(singleton.wallet.address,
            style: TextStyle(
                fontSize: 10.0
            ),),
          accountEmail: Text('example@gmail.com'),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.black,
            child: ClipOval(
              child: Icon(Icons.person, size: 50.0),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage('http://images.hdqwalls.com/wallpapers/flutter-logo-4k-qn.jpg')
            ),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: 15,
            itemBuilder: (context, i) {

              return _buildRow();
            }
        )
      ],
    ),
  );
}*/
