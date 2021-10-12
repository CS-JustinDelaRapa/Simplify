import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplify/page/boosterCommunity/model/myuser.dart';
import 'package:simplify/page/boosterCommunity/screen/home/boosterHome.dart';
import 'package:simplify/page/boosterCommunity/screen/signIn-Register/boosterSignIn.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    //return either home or authenticate widget
    if (user == null) {
      return BoosterSignIn();
    } else {
      return BoosterHome();
    }
  }
}
