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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/testing/testing.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Email Verification'),
          backgroundColor: Colors.transparent,
        ),
        body: !sendEmail
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ElevatedButton(
                    onPressed: () {
                      user.sendEmailVerification();
                      setState(() {
                        sendEmail = true;
                      });
                    },
                    child: Text('Send Verification')),
                ElevatedButton(
                    onPressed: () {
                      auth.signOut();
                    },
                    child: Text('Use Another Email')),
              ]),
            )
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SpinKitThreeInOut(
                            color: Colors.blue,
                            size: 50.0,
                          ),
                          SizedBox(height: 15),
                          Center(
                              child:
                                  Text('Please Check your email for verification'))
                        ]),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                      onPressed: () {
                        user.sendEmailVerification();
                        setState(() {
                          sendEmail = true;
                        });
                      },
                      child: Text('Send Verification again')),
                      ElevatedButton(
                    onPressed: () {
                      auth.signOut();
                    },
                    child: Text('Use Another Email')),
              ],
            ),
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
