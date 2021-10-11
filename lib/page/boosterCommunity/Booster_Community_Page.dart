// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/screen/signIn-Register/boosterSignIn.dart';

//sas
class BoosterCommunityPage extends StatefulWidget {
  BoosterCommunityPage({Key? key}): super (key: key);

  @override
  _BoosterCommunityPageState createState() => _BoosterCommunityPageState();
}

class _BoosterCommunityPageState extends State<BoosterCommunityPage>{

  @override
  Widget build(BuildContext context) {
    return BoosterSignIn();
  }
}