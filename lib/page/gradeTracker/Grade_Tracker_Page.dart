import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplify/page/gradeTracker/gradepage/quiz.dart';

import 'gradepage/activity.dart';
import 'gradepage/attendance.dart';
import 'gradepage/exam.dart';

class GradeTrackerPage extends StatefulWidget {
  double? totalQuiz1;
  double? totalActivity1;
  double? totalAttendance1;
  double? totalExam1;
  GradeTrackerPage(
      {Key? key,
      this.totalQuiz1,
      this.totalActivity1,
      this.totalAttendance1,
      this.totalExam1})
      : super(key: key);
  @override
  _GradeTrackerPage createState() => _GradeTrackerPage();
}

class _GradeTrackerPage extends State<GradeTrackerPage> {
  final calculateKey = GlobalKey<FormState>();
  int totalpercent = 0;
  double totalGrade = 0;
  String remarks = "";
  String subject = "";
  String totalQuiz = "";
  String totalActivity = "";
  String totalAttendance = "";
  String totalExam = "";
  String quizpercent = "";
  String? quizGrade;
  String? activityGrade;
  String activitypercent = "";
  String? attendanceGrade;
  String attendancepercent = "";
  String? examGrade;
  String exampercent = "";
  @override
  void initState() {
    super.initState();
    refreshState();
  }

  Future refreshState() async {
    setState(() {
      quizGrade = "Show";
      activityGrade = "Show";
      attendanceGrade = "Show";
      examGrade = "Show";
    });
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
          title: Text(
            'Grade Tracker',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo.shade800,
          elevation: 0.0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextButton(
                          child: Text('Quiz'),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(10)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black87),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                          BorderSide(color: Colors.white70)))),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text("How Many Quiz?"),
                                      actions: [
                                        TextField(
                                          keyboardType: TextInputType.number,
                                          maxLength: 2,
                                          decoration: InputDecoration(
                                              counterText: "",
                                              border: OutlineInputBorder(),
                                              hintText: "Quiz"),
                                          onChanged: (value) {
                                            setState(() {
                                              totalQuiz = value;
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              ElevatedButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          quiz(
                                                        totalQuiz: int.parse(
                                                            totalQuiz),
                                                        quizpercent: int.tryParse(
                                                                quizpercent) ??
                                                            -1,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.32,
                                              ),
                                              ElevatedButton(
                                                child: Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ));
                            refreshState();
                          }),
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 45,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            quizpercent = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
                          hintText: '%',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value != null && value.isEmpty
                            ? 'Required A Number'
                            : null,
                      ),
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 45,
                        child: TextButton(
                          child: Text('$quizGrade'),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(10)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black87),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                          BorderSide(color: Colors.white70)))),
                          onPressed: () {
                            setState(() {
                              quizGrade = quizPercentage ?? "Show";
                            });
                          },
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextButton(
                          child: Text('Activity'),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(10)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black87),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                          BorderSide(color: Colors.white70)))),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text("How Many Activity?"),
                                      actions: [
                                        TextField(
                                          keyboardType: TextInputType.number,
                                          maxLength: 2,
                                          decoration: InputDecoration(
                                              counterText: "",
                                              border: OutlineInputBorder(),
                                              hintText: "Activity"),
                                          onChanged: (value) {
                                            setState(() {
                                              totalActivity = value;
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              ElevatedButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          activity(
                                                        totalActivity:
                                                            int.parse(
                                                                totalActivity),
                                                        activitypercent:
                                                            int.tryParse(
                                                                    activitypercent) ??
                                                                -1,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.32,
                                              ),
                                              ElevatedButton(
                                                child: Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ));
                            refreshState();
                          }),
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 45,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            activitypercent = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
                          hintText: '%',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value != null && value.isEmpty
                            ? 'Required A Number'
                            : null,
                      ),
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 45,
                        child: TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(10)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black87),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                          BorderSide(color: Colors.white70)))),
                          child: Text('$activityGrade'),
                          onPressed: () {
                            setState(() {
                              activityGrade = activityPercentage ?? "Show";
                            });
                          },
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextButton(
                          child: Text('Attendance'),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(10)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black87),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                          BorderSide(color: Colors.white70)))),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text("How Many Attendance?"),
                                      actions: [
                                        TextField(
                                          keyboardType: TextInputType.number,
                                          maxLength: 2,
                                          decoration: InputDecoration(
                                              counterText: "",
                                              border: OutlineInputBorder(),
                                              hintText: "Attendance"),
                                          onChanged: (value) {
                                            setState(() {
                                              totalAttendance = value;
                                            });
                                          },
                                        ),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        attendance(
                                                      totalAttendance:
                                                          int.parse(
                                                              totalAttendance),
                                                      attendancepercent:
                                                          int.tryParse(
                                                                  attendancepercent) ??
                                                              -1,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                            ),
                                            ElevatedButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ));
                            refreshState();
                          }),
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 45,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            attendancepercent = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
                          hintText: '%',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value != null && value.isEmpty
                            ? 'Required A Number'
                            : null,
                      ),
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 45,
                        child: TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(10)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black87),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                          BorderSide(color: Colors.white70)))),
                          child: Text('$attendanceGrade'),
                          onPressed: () {
                            setState(() {
                              attendanceGrade = attendancePercentage ?? "Show";
                            });
                          },
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextButton(
                          child: Text('Exam'),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(10)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black87),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                          BorderSide(color: Colors.white70)))),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text("How Many Exam?"),
                                      actions: [
                                        TextField(
                                          keyboardType: TextInputType.number,
                                          maxLength: 2,
                                          decoration: InputDecoration(
                                              counterText: "",
                                              border: OutlineInputBorder(),
                                              hintText: "Exam"),
                                          onChanged: (value) {
                                            setState(() {
                                              totalExam = value;
                                            });
                                          },
                                        ),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => exam(
                                                      totalExam:
                                                          int.parse(totalExam),
                                                      exampercent: int.tryParse(
                                                              exampercent) ??
                                                          -1,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                            ),
                                            ElevatedButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ));
                            refreshState();
                          }),
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 45,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            exampercent = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
                          hintText: '%',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value != null && value.isEmpty
                            ? 'Required A Number'
                            : null,
                      ),
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 45,
                        child: TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(10)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black87),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                          BorderSide(color: Colors.white70)))),
                          child: Text('$examGrade'),
                          onPressed: () {
                            setState(() {
                              examGrade = examPercentage ?? "Show";
                            });
                          },
                        )),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      child: Text('Calculate'),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.teal,
                        onSurface: Colors.grey,
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontStyle: FontStyle.italic),
                      ),
                      onPressed: () async {
                        //    if (calculateKey.currentState!.validate()) {
                        totalpercent = int.parse(exampercent) +
                            int.parse(quizpercent) +
                            int.parse(activitypercent) +
                            int.parse(attendancepercent);
                        if (totalpercent != 100) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text(
                                        "Your Total Percentage Must Be 100%"),
                                    actions: [
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ));
                        }
                        // }
                        else {
                          totalGrade = double.parse(quizGrade!) +
                              double.parse(activityGrade!) +
                              double.parse(attendanceGrade!) +
                              double.parse(examGrade!);
                          if (totalGrade == 65) {
                            remarks = "Let’s raise this grade! ";
                          } else if (totalGrade < 75) {
                            remarks = "Let’s bring this up.";
                          } else if (totalGrade == 75 || totalGrade <= 79) {
                            remarks = "Perhaps try to do still better? ";
                          } else if (totalGrade >= 80 || totalGrade <= 89) {
                            remarks = "Good work. Keep at it. ";
                          } else {
                            remarks = "Excellent! Keep it up.";
                          }
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text(
                                        "Average: " + totalGrade.toString()),
                                    content: Text("Remarks: " + remarks),
                                    actions: [
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                totalGrade = 0;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ));
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        child: Text('Reset'),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.teal,
                          onSurface: Colors.grey,
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontStyle: FontStyle.italic),
                        ),
                        onPressed: () async {
                          setState(() {
                            quizGrade = "0";
                            quizPercentage = "0";
                            activityGrade = "0";
                            activityPercentage = "0";
                            examGrade = "0";
                            examPercentage = "0";
                            attendanceGrade = "0";
                            attendancePercentage = "0";
                          });
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
