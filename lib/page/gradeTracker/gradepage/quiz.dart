// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import '../Grade_Tracker_Page.dart';

class quiz extends StatefulWidget {
  final int totalQuiz;
  final int quizpercent;
  const quiz({
    Key? key,
    required this.totalQuiz,
    required this.quizpercent,
  }) : super(key: key);
  @override
  _quiz createState() => _quiz();
}

final calculateKey = GlobalKey<FormState>();
double total = 0;
double items = 0;
double average = 0;
String remarks = "";
double quizTotalPercentage = 0;
String? quizPercentage;

class _quiz extends State<quiz> with AutomaticKeepAliveClientMixin {
  late List<String> totalScore;
  late List<String> totalItems;
  @override
  void initState() {
    totalScore = List.generate(widget.totalQuiz, (index) => "");
    totalItems = List.generate(widget.totalQuiz, (index) => "");
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
            title: Text("Quiz Grade Calculator"),
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
                    itemCount: widget.totalQuiz,
                    itemBuilder: (context, index) => Center(
                      child: Column(
                        children: [
                          Text('Quiz ${index + 1} :',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
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
                                              color: Colors.transparent,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0))),
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
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
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

                        quizTotalPercentage = (total / items) * 100;
                        average =
                            quizTotalPercentage * (widget.quizpercent / 100);
                        // change remark
                        if (total >= temp) {
                          remarks = "Great job, keep going!";
                        } else {
                          remarks = "You are failing, better luck next time!";
                        }
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Average: " + average.toString()),
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
                                              quizPercentage =
                                                  average.toString();
                                            });
                                            Navigator.pop(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    GradeTrackerPage(
                                                  totalQuiz1: double.parse(
                                                      quizPercentage!),
                                                ),
                                              ),
                                            );
                                            setState(() {
                                              quizTotalPercentage = 0;
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
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
