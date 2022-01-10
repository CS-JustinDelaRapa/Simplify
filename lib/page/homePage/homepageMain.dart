import 'package:flutter/material.dart';
import 'package:simplify/page/NavBar.dart';
import 'package:simplify/page/homePage/Home_Page.dart';
import 'package:simplify/page/homePage/unfinished.dart';

class HomeMain extends StatefulWidget {

  final Stream<bool> stream;
  final Stream<bool> streamUnfinished;
  const HomeMain({Key? key, required this.stream, required this.streamUnfinished}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain>
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
          title: Row(
            children: [
             Icon(Icons.home_rounded),
              SizedBox(
                width: 5,
              ),
              Text(
                'Home',
                style: TextStyle(color: Colors.white, fontSize: 23),
              ),
            ],
          ),
          bottom: TabBar(
            indicatorWeight: 3.0,
            tabs: <Tab>[
              Tab(text: 'Today'),
              Tab(text: 'Unfinished'),
            ],
            controller: _tabController,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            QuotesPage(stream: widget.stream),
            UnfinishedPage(streamUnfinished: widget.streamUnfinished,),
          ],
        ),
      ),
    );
  }
}