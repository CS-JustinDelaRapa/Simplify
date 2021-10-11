import 'package:flutter/material.dart';

class GradeTrackerPage extends StatefulWidget {
  GradeTrackerPage({Key? key}) : super(key: key);

  @override
  _GradeTrackerPage createState() => _GradeTrackerPage();
}

class _GradeTrackerPage extends State<GradeTrackerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Grade Tracker',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF57A0D3),
        elevation: 0.0,
      ),
    );
  }
}
