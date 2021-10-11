import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplify/page/boosterCommunity/loading/loadingVerify.dart';
import 'package:simplify/page/boosterCommunity/screen/home/boosterHome.dart';

class VerifyBackEnd extends StatelessWidget {
  const VerifyBackEnd({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if(user!.emailVerified){
      return BoosterHome();
    } else {
      return LoadingVerify();
    }
  }
}