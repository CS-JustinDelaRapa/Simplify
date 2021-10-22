import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:simplify/page/boosterCommunity/model/myuser.dart';
import 'package:simplify/page/boosterCommunity/screen/home/homeTab/homeTab.dart';
import 'package:simplify/page/boosterCommunity/screen/home/homeTab/homeTry.dart';
import 'package:simplify/page/boosterCommunity/screen/signIn-Register/boosterSignIn.dart';
import 'package:simplify/page/boosterCommunity/screen/verification/verifyScreen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context, listen: true);

    //return either home or authenticate widget
    if (user == null) {
      return BoosterSignIn();
    } else if (user.verified == false) {
      return VerifyScreen();
    } else {
      return UserFeed();
    }
  }
}
