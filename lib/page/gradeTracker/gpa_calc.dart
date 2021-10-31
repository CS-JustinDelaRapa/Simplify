// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import 'Grade_Tracker_Page.dart';

class gpacalc extends StatefulWidget {
  final int subject;
  const gpacalc({Key? key, required this.subject}) : super(key: key);
  @override
  _gpacalc createState() => _gpacalc();
}

final calculateKey = GlobalKey<FormState>();
double total = 0;
double average = 0;
String remarks = "";

class _gpacalc extends State<gpacalc> with AutomaticKeepAliveClientMixin {
  late List<String> subjectGrade;
  @override
  void initState() {
    subjectGrade = List.generate(widget.subject, (index) => "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(title: Text("GPA Calculator")),
        body: Column(
          children: [
            Expanded(
              child: Form(
                key: calculateKey,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.subject,
                  itemBuilder: (context, index) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            subjectGrade[index] = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Subject # ${index + 1} :',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.lightBlueAccent, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.lightBlueAccent, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
                        validator: (value) => value != null && value.isEmpty
                            ? 'Required A Number'
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
                  if (calculateKey.currentState!.validate()) {
                    for (int x = 0; x < subjectGrade.length; x++) {
                      total += double.parse(subjectGrade[x]);
                    }
                    average = total / widget.subject;
                    if (average < 65 || average > 100) {
                      remarks = "Wrong Input";
                      average = 0;
                    } else if (average == 65) {
                      remarks = "Let’s raise this grade! ";
                    } else if (average < 75) {
                      remarks = "Let’s bring this up.";
                    } else if (average == 75 || average <= 79) {
                      remarks = "Perhaps try to do still better? ";
                    } else if (average >= 80 || average <= 89) {
                      remarks = "Good work. Keep at it. ";
                    } else {
                      remarks = "Excellent! Keep it up.";
                    }
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text("Average: " + average.toString()),
                              content: Text("Remarks: " + remarks),
                              actions: [
                                ElevatedButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      total = 0;
                                      average = 0;
                                    });
                                  },
                                )
                              ],
                            ));
                  }
                }),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
