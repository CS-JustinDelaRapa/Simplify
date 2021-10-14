import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/screen/home/profile.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

class BoosterHome extends StatefulWidget {
  const BoosterHome({Key? key}) : super(key: key);

  @override
  _BoosterHomeState createState() => _BoosterHomeState();
}

class _BoosterHomeState extends State<BoosterHome> with SingleTickerProviderStateMixin {
 late final TabController _tabController;
 


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('Booster Community'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                tabs: <Tab>[
                  Tab(text: 'Home'),
                  Tab(text: 'Profile'),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Container(
              child: ElevatedButton(
          child: Text('Sign Out'),
          onPressed: () {
            AuthService().signOut();
          },
        ),
            ),
           Profile(),
          ],
        ),
      ),
    );
  }
  }

    // return Scaffold(
    //     appBar: AppBar(
    //       centerTitle: true,
    //       title: Text('Boosters Community'),
    //     ),
    //     body: ElevatedButton(
    //       child: Text('Sign Out'),
    //       onPressed: () {
    //         AuthService().signOut();
    //       },
    //     ),
    //     floatingActionButton: Padding(
    //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
    //       child: FloatingActionButton(
    //         backgroundColor: Colors.blueGrey[900],
    //         child: Icon(
    //           Icons.add,
    //           size: 30.0,
    //         ),
    //         onPressed: () async {
    //           await Navigator.of(context).push(
    //             MaterialPageRoute(builder: (context) => AddPostForm()),
    //           );
    //         },
    //       ),
    //     ));
