import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplify/page/gradeTracker/gpa_calc.dart';
import 'package:simplify/page/gradeTracker/quiz.dart';

class GradeTrackerPage extends StatefulWidget {
  GradeTrackerPage({Key? key, required this.totalQuiz1}) : super(key: key);
  double totalQuiz1;
  @override
  _GradeTrackerPage createState() => _GradeTrackerPage();
}

class _GradeTrackerPage extends State<GradeTrackerPage> {
  String subject = "";
  String totalQuiz = "";
  String percent = "";
  String? quizGrade;

  @override
  void initState() {
    super.initState();
    refreshState();
  }

  Future refreshState() async {
    setState(() {
      quizGrade = widget.totalQuiz1.toString();
    });
  }

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
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.teal),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.teal)))),
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
                                Row(
                                  children: [
                                    ElevatedButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => quiz(
                                              totalQuiz: int.parse(totalQuiz),
                                              percent:
                                                  int.tryParse(percent) ?? -1,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.38,
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
              child: TextField(
                  onChanged: (value) {
                    setState(() {
                      percent = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                  maxLengthEnforced: true,
                  maxLength: 2,
                  decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(),
                    hintText: '%',
                  )),
            ),
            SizedBox(width: 5),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                height: 45,
                child: TextButton(
                  child: Text('$quizGrade'),
                  onPressed: () {
                    print(totalQuiz1);
                    quizGrade = totalQuiz1.toString();
                  },
                )),
          ],
        ),
      ),
    );
  }
}

// TextFormField(
//                   enabled: false,
//                   onChanged: (value) {
//                     setState(() {
//                       widget.totalQuiz1 = double.parse(value);
//                       quizGrade = widget.totalQuiz1.toString();
//                       print(quizGrade);
//                     });
//                   },
//                   initialValue: '$quizGrade',
//                   maxLength: 2,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                   )),
        //  Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: TextButton(
        //         child: Text('Continue'),
        //         style: TextButton.styleFrom(
        //           primary: Colors.white,
        //           backgroundColor: Colors.teal,
        //           onSurface: Colors.grey,
        //           textStyle: TextStyle(
        //               color: Colors.black,
        //               fontSize: 20,
        //               fontStyle: FontStyle.italic),
        //         ),
        //         onPressed: () {
        //           if (subject != "") {
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) =>
        //                         gpacalc(subject: int.parse(subject))));
        //           } else {
        //             showDialog(
        //                 context: context,
        //                 builder: (BuildContext context) => AlertDialog(
        //                       title: Text("You need to Input a Number"),
        //                       actions: [
        //                         ElevatedButton(
        //                           child: Text("OK"),
        //                           onPressed: () {
        //                             Navigator.of(context).pop();
        //                           },
        //                         )
        //                       ],
        //                     ));
        //           }
        //         },
        //       ),
        //     ),
        // ]
        // ),
