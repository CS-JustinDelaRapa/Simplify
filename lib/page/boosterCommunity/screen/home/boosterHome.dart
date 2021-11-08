import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/screen/home/homeTab/homeTab.dart';
import 'package:simplify/page/boosterCommunity/screen/home/profileTab/profile.dart';

class BoosterHome extends StatefulWidget {
  const BoosterHome({Key? key}) : super(key: key);

  @override
  _BoosterHomeState createState() => _BoosterHomeState();
}

class _BoosterHomeState extends State<BoosterHome>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Support Community',
            style: TextStyle(color: Colors.white, fontSize: 23),
          ),
          bottom: TabBar(
            indicatorWeight: 3.0,
            tabs: <Tab>[
              Tab(text: 'Home'),
              Tab(text: 'Profile'),
            ],
            controller: _tabController,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            UserFeed(),
            Profile(),
          ],
        ),
      ),
    );
  }
}
