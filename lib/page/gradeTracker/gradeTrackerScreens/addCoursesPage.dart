import 'package:flutter/material.dart';

class AddCoursesPage extends StatefulWidget {
  const AddCoursesPage({Key? key}) : super(key: key);
  @override
  _AddCoursesPageState createState() => _AddCoursesPageState();
}

class _AddCoursesPageState extends State<AddCoursesPage> {
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
          centerTitle: true,
          backgroundColor: Colors.indigo.shade800,
          elevation: 0.0,
          title: Text('Add Courses',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.blueGrey[900],
          child: Icon(
            Icons.add,
            size: 30.0,
          ),
          onPressed: () async {},
        ),
      ),
    );
  }
}
