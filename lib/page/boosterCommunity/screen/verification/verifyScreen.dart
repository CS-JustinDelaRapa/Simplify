import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
import 'package:simplify/page/boosterCommunity/screen/home/boosterHome.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;

  bool sendEmail = false;

  late User user;
  late Timer timer;

  @override
  void initState() {
    user = auth.currentUser!;
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !sendEmail
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('The Provided Email is not yet validated'),
                SizedBox(height: 10,),                
                ElevatedButton(
                    onPressed: () {
                      user.sendEmailVerification();
                      setState(() {
                        sendEmail = true;
                      });
                    },
                    child: Text('Send Verification')),
              Row(children: <Widget>[
                Expanded(child: Divider(color: Colors.blueGrey)),
                Text("OR"),
                Expanded(child: Divider(color: Colors.blueGrey)),
              
              ]
              ),                    
                ElevatedButton(
                    onPressed: () {
                      auth.signOut();
                    },
                    child: Text('Use another Email')),
              ]),
            )
          : Center(
              child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SpinKitThreeInOut(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                    SizedBox(height: 15),
                    Center(
                        child: Text('Please Check your email for verification'))
                  ]),
            ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BoosterHome()));
    }
  }
}
