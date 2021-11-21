import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key, required this.address, required this.mail, required this.image}) : super(key: key);

  final String address;
  final String mail;
  final String image;


  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: Text(address,
        style: TextStyle(
            fontSize: 10.0
        ),),
      accountEmail: Text(mail),
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
            image: NetworkImage(image)
        ),
      ),
    );;
  }
}
