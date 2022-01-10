import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:simplify/page/NavBar.dart';
import 'package:simplify/page/homePage/Home_Page.dart';
import 'package:simplify/page/homePage/unfinished.dart';

class HomeMain extends StatefulWidget {

  final Stream<bool> stream;
  final Stream<bool> streamUnfinished;
  final Stream<bool> streamMain;
  const HomeMain({Key? key, required this.stream, required this.streamUnfinished, required this.streamMain}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool isLoading = false;
  int unfinishedNumber = 2;

  @override
  void initState() {
    super.initState();
        widget.streamMain.listen((isRefresh) {
      if (isRefresh) {
        refreshState();
      }
    });
    _tabController = TabController(length: 2, vsync: this);
  }

  refreshState(){
    setState(() {
      isLoading = true;
      unfinishedNumber+=1;
    });
print('unfinishedddd'+unfinishedNumber.toString());
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
            tabs: [
              Tab(text: 'Today'),
              Container(
                child: unfinishedNumber == 0?
                Text('Unfinished') 
                :Badge(
                  badgeColor: Colors.pink.shade400,
                  padding: EdgeInsets.all(4),
                  badgeContent: Text(unfinishedNumber.toString(), style: TextStyle(color: Colors.white)),
                  child: Tab(
                    text: 'Unfinished')),
              ),
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