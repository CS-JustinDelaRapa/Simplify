// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import '../Grade_Tracker_Page.dart';

class attendance extends StatefulWidget {
  final int attendancepercent;
  final int totalAttendance;
  const attendance(
      {Key? key,
      required this.attendancepercent,
      required this.totalAttendance})
      : super(key: key);
  @override
  _attendance createState() => _attendance();
}

final calculateKey = GlobalKey<FormState>();
double total = 0;
double items = 0;
double average = 0;
String remarks = "";
double attendanceTotalPercentage = 0;
String? attendancePercentage;

class _attendance extends State<attendance> with AutomaticKeepAliveClientMixin {
  late List<String> totalScore;
  late List<String> totalItems;
  @override
  void initState() {
    totalScore = List.generate(widget.totalAttendance, (index) => "");
    totalItems = List.generate(widget.totalAttendance, (index) => "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/testing/testing.png"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Attendance Grade Calculator"),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Column(
            children: [
              Expanded(
                child: Form(
                  key: calculateKey,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.totalAttendance,
                    itemBuilder: (context, index) => Center(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    totalScore[index] = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(height: 0),
                                  hintText: 'Attendance # ${index + 1} :',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlueAccent,
                                        width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlueAccent,
                                        width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                  ),
                                ),
                                validator: (value) =>
                                    value != null && value.isEmpty ? '' : null,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    totalItems[index] = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(height: 0),
                                  hintText: 'Total Items',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlueAccent,
                                        width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlueAccent,
                                        width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                  ),
                                ),
                                validator: (value) =>
                                    value != null && value.isEmpty ? '' : null,
                              ),
                            ),
                          ),
                        ],
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
                      for (int x = 0; x < totalScore.length; x++) {
                        total += double.parse(totalScore[x]);
                        items += double.parse(totalItems[x]);
                      }
                      double temp = items / 2;
                      attendanceTotalPercentage = (total / items) * 100;
                      average = attendanceTotalPercentage *
                          (widget.attendancepercent / 100);
                      // change remark
                      if (total >= temp) {
                        remarks = "Let’s raise this grade! ";
                      } else {
                        remarks = "Bagsak Ka";
                      }

                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text("Average: " + average.toString()),
                                content: Text("Remarks: " + remarks),
                                actions: [
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          setState(() {
                                            attendancePercentage =
                                                average.toString();
                                          });
                                          Navigator.pop(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  GradeTrackerPage(
                                                totalAttendance1: double.parse(
                                                    attendancePercentage!),
                                              ),
                                            ),
                                          );
                                          setState(() {
                                            attendanceTotalPercentage = 0;
                                            average = 0;
                                            temp = 0;
                                            total = 0;
                                            items = 0;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                    }
                  }),
            ],
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
