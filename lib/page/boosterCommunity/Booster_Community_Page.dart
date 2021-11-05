import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplify/page/boosterCommunity/model/myuser.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';
import 'package:simplify/page/boosterCommunity/service/wrapper.dart';

class BoosterCommunityPage extends StatefulWidget {
  BoosterCommunityPage({Key? key}) : super(key: key);

  @override
  _BoosterCommunityPageState createState() => _BoosterCommunityPageState();
}

class _BoosterCommunityPageState extends State<BoosterCommunityPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamProvider<MyUser?>.value(
      // ignore: non_constant_identifier_names
      catchError: (User, MyUser) => null,
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
