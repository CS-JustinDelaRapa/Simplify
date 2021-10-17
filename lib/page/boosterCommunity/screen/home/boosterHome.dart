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
    return Scaffold(
      appBar: AppBar(
        title: Text('Support Cummunity'),
        bottom: TabBar(
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
           HomeTab(),
           Profile(),
          ],
        ),
      );
  }
  }
