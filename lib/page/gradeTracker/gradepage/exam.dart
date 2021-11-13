// ignore_for_file: camel_case_types

import 'dart:math';

import 'package:flutter/material.dart';

import '../Grade_Tracker_Page.dart';

class exam extends StatefulWidget {
  final int exampercent;
  final int totalExam;
  const exam({Key? key, required this.exampercent, required this.totalExam})
      : super(key: key);
  @override
  _exam createState() => _exam();
}

final calculateKey = GlobalKey<FormState>();
double total = 0;
double items = 0;
double average = 0;
String remarks = "";
double examTotalPercentage = 0;
String? examPercentage;

class _exam extends State<exam> with AutomaticKeepAliveClientMixin {
  late List<String> totalScore;
  late List<String> totalItems;
  @override
  void initState() {
    totalScore = List.generate(widget.totalExam, (index) => "");
    totalItems = List.generate(widget.totalExam, (index) => "");
    super.initState();
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
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
            title: Text("Exam Grade Calculator"),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Center(
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: calculateKey,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.totalExam,
                      itemBuilder: (context, index) => Center(
                        child: Column(
                          children: [
                            Text('Exam ${index + 1} :',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SizedBox(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          setState(() {
                                            totalScore[index] = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white70,
                                          errorStyle: TextStyle(height: 0),
                                          hintText: 'Score',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lightBlueAccent,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lightBlueAccent,
                                                width: 2.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                          ),
                                        ),
                                        validator: (value) =>
                                            value != null && value.isEmpty
                                                ? ''
                                                : null,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SizedBox(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          setState(() {
                                            totalItems[index] = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white70,
                                          errorStyle: TextStyle(height: 0),
                                          hintText: 'Total Items',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 2.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                          ),
                                        ),
                                        validator: (value) =>
                                            value != null && value.isEmpty
                                                ? ''
                                                : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                      child: Text('Calculate'),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.teal,
                        onSurface: Colors.grey,
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () async {
                        if (calculateKey.currentState!.validate()) {
                          for (int x = 0; x < totalScore.length; x++) {
                            total += double.parse(totalScore[x]);
                            items += double.parse(totalItems[x]);
                          }
                          double temp = items / 2;
                          examTotalPercentage =
                              roundDouble((total / items) * 100, 2);
                          average = roundDouble(
                              examTotalPercentage * (widget.exampercent / 100),
                              2);

                          if (total >= temp) {
                            remarks = "Great job, keep going!";
                          } else {
                            remarks = "You are failing, better luck next time!";
                          }

                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Average: " +
                                        average.toStringAsFixed(2)),
                                    content: Text(remarks),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              setState(() {
                                                examPercentage =
                                                    average.toString();
                                              });
                                              Navigator.pop(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GradeTrackerPage(
                                                    totalExam1: double.parse(
                                                        examPercentage!),
                                                  ),
                                                ),
                                              );
                                              setState(() {
                                                examTotalPercentage = 0;
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
                ),
              ],
            ),
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
