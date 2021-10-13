// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplify/page/boosterCommunity/model/myuser.dart';
// import 'package:simplify/page/boosterCommunity/screen/signIn-Register/boosterSignIn.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';
import 'package:simplify/page/boosterCommunity/service/wrapper.dart';

//sas
class BoosterCommunityPage extends StatefulWidget {
  BoosterCommunityPage({Key? key}) : super(key: key);

  @override
  _BoosterCommunityPageState createState() => _BoosterCommunityPageState();
}

class _BoosterCommunityPageState extends State<BoosterCommunityPage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      // ignore: non_constant_identifier_names
      catchError: (User, MyUser) => null,
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
