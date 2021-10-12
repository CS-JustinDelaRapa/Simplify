import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

class BoosterHome extends StatefulWidget {
  const BoosterHome({ Key? key}) : super(key: key);

  @override
  _BoosterHomeState createState() => _BoosterHomeState();
}

class _BoosterHomeState extends State<BoosterHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Boosters Community'),
      ),
      body: ElevatedButton(
        child: Text('Sign Out'),
        onPressed: () {
          AuthService().signOut();
        },
      ),
    );
  }
}