import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'boosterCommunity/Booster_Community_Page.dart';
import 'diary/Diary_Page.dart';
import 'gradeTracker/Grade_Tracker_Page.dart';
import 'calendarView/Calendar_View_Page.dart';
import 'homePage/Home_Page.dart';
import 'taskList/List_View_Page.dart';
import 'package:simplify/db_helper/database_helper.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();
  List<Widget> _screens = [
    QuotesPage(),
    ListViewPage(),
    CalendarViewPage(),
    GradeTrackerPage(),
    DiaryPage(),
    BoosterCommunityPage()
  ];

  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemsTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  void dispose() {
    DatabaseHelper.instance.closeConnection();
    super.dispose();
  }

//bottom curve nav bar
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.grey[250],
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          color: Color(0xFF57A0D3),
          backgroundColor: Colors.blue.shade200,
          onTap: _onItemsTapped,
          items: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Icon(Icons.home_rounded,
                      color:
                          _selectedIndex == 0 ? Colors.white : Colors.white70,
                      size: 30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                  child: Icon(Icons.checklist_rtl_rounded,
                      color:
                          _selectedIndex == 1 ? Colors.white : Colors.white70,
                      size: 30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                  child: Icon(MdiIcons.calendar,
                      color:
                          _selectedIndex == 2 ? Colors.white : Colors.white70,
                      size: 30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Icon(Icons.calculate_rounded,
                      color:
                          _selectedIndex == 3 ? Colors.white : Colors.white70,
                      size: 30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Icon(Icons.menu_book_rounded,
                      color:
                          _selectedIndex == 4 ? Colors.white : Colors.white70,
                      size: 30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Icon(Icons.connect_without_contact_rounded,
                      color:
                          _selectedIndex == 5 ? Colors.white : Colors.white70,
                      size: 35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
