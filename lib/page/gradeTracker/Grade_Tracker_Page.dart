import 'package:flutter/material.dart';
import 'package:simplify/page/gradeTracker/gpa_calc.dart';

class GradeTrackerPage extends StatefulWidget {
  GradeTrackerPage({Key? key}) : super(key: key);

  @override
  _GradeTrackerPage createState() => _GradeTrackerPage();
}

class _GradeTrackerPage extends State<GradeTrackerPage> {
  String subject = "";
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
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Number of Subjects ',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  subject = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: Text('Continue'),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.teal,
                onSurface: Colors.grey,
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontStyle: FontStyle.italic),
              ),
              onPressed: () {
                if (subject != "") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              gpacalc(subject: int.parse(subject))));
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("You need to Input a Number"),
                            actions: [
                              ElevatedButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ));
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}
