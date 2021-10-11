import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BoosterHome extends StatefulWidget {
  const BoosterHome({ Key? key}) : super(key: key);

  @override
  _BoosterHomeState createState() => _BoosterHomeState();
}

class _BoosterHomeState extends State<BoosterHome> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Boosters Community'),
      ),
      body: ElevatedButton(
        child: Text('Sign Out'),
        onPressed: (){
          auth.signOut();
        },
      ),
      
    );
  }
}