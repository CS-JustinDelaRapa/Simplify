import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplify/page/boosterCommunity/screen/verifyBackEnd.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({ Key? key }) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;

  late User user;

  @override
  void initState() {
  user = auth.currentUser!;
  user.sendEmailVerification();
    super.initState();
    print(user.emailVerified.toString() +'||'+ user.email.toString() +'||' + user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      // ignore: non_constant_identifier_names
      catchError: (User, user) => null,
      initialData: null,
      value: auth.userChanges(),
      child: MaterialApp(
        home: VerifyBackEnd(),
      ),
    );
  }
}