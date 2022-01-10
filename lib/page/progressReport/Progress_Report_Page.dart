import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simplify/db_helper/database_helper.dart';
import 'package:simplify/model/task.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:confetti/confetti.dart';

class ProgressReportPage extends StatefulWidget {
  ProgressReportPage({
    Key? key,
  }) : super(key: key);

  @override
  _ProgressReportPageState createState() => _ProgressReportPageState();
}

//coment
class _ProgressReportPageState extends State<ProgressReportPage> {
  late ConfettiController _controllerCenter;
  late List<Task> taskContent;
  bool isLoading = false;
  double doneTask = 0;
  double totalTask = 0;
  double unfinishedPercentage = 0;
  double finishedPercentage = 0;

  int green = 0;
  int purple = 0;
  int pink = 0;
  int yellow = 0;
  int red = 0;
  int gray = 0;

  @override
  void initState() {
    super.initState();
    refreshState();
  }

  Future refreshState() async {
    setState(() => isLoading = true);
    doneTask = 0;
    totalTask = 0;
    this.taskContent = await DatabaseHelper.instance.readAllTask();
    totalTask = double.parse(taskContent.length.toString());
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 3));
    _controllerCenter.play();
    if (taskContent.isNotEmpty) {
      countColors();
    }
    getDoneTask();
    setState(() => isLoading = false);
  }

  Future getDoneTask() async {
    for (var i = 0; i < taskContent.length; i++) {
      if (taskContent[i].isDone == true) {
        setState(() {
          doneTask++;
        });
      }
    }
    finishedPercentage = doneTask / totalTask * 100;
    unfinishedPercentage = 100 - finishedPercentage;
  }

  countColors() {
    for (int x = 0; x < taskContent.length; x++) {
      var now = DateTime.now();
      var diff = taskContent[x].dateSched.difference(now);
      if (taskContent[x].isDone == true) {
        gray++;
      } else if (diff.inHours <= -24) {
        red++;
      } else if (diff.inMicroseconds <= 0 && diff.inDays >= -1) {
        yellow++;
      } else if (diff.inHours >= 3 && diff.inDays <= 1) {
        purple++;
      } else if (diff.inHours < 3 && diff.inMicroseconds > 0) {
        pink++;
      } else {
        green++;
      }
    }
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
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.task_alt_rounded),
              Text(
                ' Progress Report',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 3.5,
                            margin: EdgeInsets.fromLTRB(10, 10, 5, 5),
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  //green
                                  Container(
                                      // padding: EdgeInsets.fromLTRB(70, 10, 10, 10),
                                      child: LinearPercentIndicator(
                                    leading: Text(
                                      green.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //leaner progress bar
                                    //width for progress bar
                                    animation:
                                        true, //animation to show progress at first
                                    animationDuration: 1000,
                                    addAutomaticKeepAlive: false,
                                    lineHeight: 10.0, //height of progress bar
                                    percent: taskContent.isEmpty? 
                                    0/1
                                    :green /
                                        taskContent
                                            .length, // 30/100 = 0.3//make round cap at start and end both
                                    progressColor: Colors.lightGreen
                                        .shade400, //percentage progress bar color
                                    backgroundColor: Colors.lightGreen
                                        .shade200, //background progressbar color
                                  )),
                                  //purple
                                  Container(
                                      // padding: EdgeInsets.fromLTRB(70, 10, 10, 10),
                                      child: LinearPercentIndicator(
                                    leading: Text(
                                      purple.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //leaner progress bar
                                    //width for progress bar
                                    animation:
                                        true, //animation to show progress at first
                                    animationDuration: 1000,
                                    addAutomaticKeepAlive: false,
                                    lineHeight: 10.0, //height of progress bar
                                    percent: taskContent.isEmpty? 
                                    0/1
                                    :purple /
                                        taskContent
                                            .length, // 30/100 = 0.3//make round cap at start and end both
                                    progressColor: Colors.purple
                                        .shade300, //percentage progress bar color
                                    backgroundColor: Colors.purple
                                        .shade100, //background progressbar color
                                  )),
                                  Container(
                                      // padding: EdgeInsets.fromLTRB(70, 10, 10, 10),
                                      child: LinearPercentIndicator(
                                    leading: Text(
                                      pink.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //leaner progress bar
                                    //width for progress bar
                                    animation:
                                        true, //animation to show progress at first
                                    animationDuration: 1000,
                                    addAutomaticKeepAlive: false,
                                    lineHeight: 10.0, //height of progress bar
                                    percent: taskContent.isEmpty? 
                                    0/1
                                    :pink /
                                        taskContent
                                            .length, // 30/100 = 0.3//make round cap at start and end both
                                    progressColor: Colors.pink
                                        .shade200, //percentage progress bar color
                                    backgroundColor: Colors.pink
                                        .shade100, //background progressbar color
                                  )),
                                  Container(
                                      // padding: EdgeInsets.fromLTRB(70, 10, 10, 10),
                                      child: LinearPercentIndicator(
                                    leading: Text(
                                      yellow.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //leaner progress bar
                                    //width for progress bar
                                    animation:
                                        true, //animation to show progress at first
                                    animationDuration: 1000,
                                    addAutomaticKeepAlive: false,
                                    lineHeight: 10.0, //height of progress bar
                                    percent: 
                                    taskContent.isEmpty? 
                                    0/1
                                    :yellow /
                                        taskContent
                                            .length, // 30/100 = 0.3//make round cap at start and end both
                                    progressColor: Colors.amber
                                        .shade300, //percentage progress bar color
                                    backgroundColor: Colors.amber
                                        .shade100, //background progressbar color
                                  )),
                                  Container(
                                      // padding: EdgeInsets.fromLTRB(70, 10, 10, 10),
                                      child: LinearPercentIndicator(
                                    leading: Text(
                                      red.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //leaner progress bar
                                    //width for progress bar
                                    animation:
                                        true, //animation to show progress at first
                                    animationDuration: 1000,
                                    addAutomaticKeepAlive: false,
                                    lineHeight: 10.0, //height of progress bar
                                    percent: taskContent.isEmpty? 
                                    0/1
                                    :red /
                                        taskContent
                                            .length, // 30/100 = 0.3//make round cap at start and end both
                                    progressColor: Colors.red
                                        .shade400, //percentage progress bar color
                                    backgroundColor: Colors.red
                                        .shade100, //background progressbar color
                                  )),
                                  Container(
                                      // padding: EdgeInsets.fromLTRB(70, 10, 10, 10),
                                      child: LinearPercentIndicator(
                                    leading: Text(
                                      gray.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //leaner progress bar
                                    //width for progress bar
                                    animation:
                                        true, //animation to show progress at first
                                    animationDuration: 1000,
                                    addAutomaticKeepAlive: false,
                                    lineHeight: 10.0, //height of progress bar
                                    percent:taskContent.isEmpty? 
                                    0/1
                                    : gray /
                                        taskContent
                                            .length, // 30/100 = 0.3//make round cap at start and end both
                                    progressColor: Colors.grey
                                        .shade500, //percentage progress bar color
                                    backgroundColor: Colors.grey
                                        .shade300, //background progressbar color
                                  )),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.blue[50],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 3.5,
                            margin: EdgeInsets.fromLTRB(5, 10, 10, 5),
                            padding: EdgeInsets.all(10),
                            child: this.taskContent.isEmpty
                                ? Center(
                                    child: Text(
                                      "No Task",
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(doneTask.toStringAsFixed(0),
                                                style: TextStyle(
                                                    fontSize: 50,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                      color:
                                                          Colors.indigo[400]),
                                                  child: Text(
                                                    '|',
                                                    style: TextStyle(
                                                        fontSize: 50,
                                                        color:
                                                            Colors.indigo[400],
                                                        fontWeight:
                                                            FontWeight.w100),
                                                    textAlign: TextAlign.center,
                                                  )),
                                            ),
                                            Text(
                                              taskContent.length.toString(),
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        Text(
                                            doneTask.toStringAsFixed(0) +
                                                ' out of ' +
                                                taskContent.length.toString() +
                                                ' tasks are done',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            textAlign: TextAlign.center)
                                      ],
                                    ),
                                    // child: RichText(
                                    //   text: new TextSpan(
                                    //     style: TextStyle(
                                    //       color: Colors.black,
                                    //       fontWeight: FontWeight.bold),
                                    //     children: [
                                    //       TextSpan(
                                    //       text: '8 ',
                                    //       style: TextStyle(fontSize: 40)),
                                    //       TextSpan(
                                    //       text: 'out of',
                                    //       style: TextStyle(fontSize: 20)),
                                    //     ]
                                    //   ),
                                    // )
                                  ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.blue[50],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            finishedPercentage == 100.00
                                ? ConfettiWidget(
                                    confettiController: _controllerCenter,
                                    blastDirectionality:
                                        BlastDirectionality.explosive,
                                    particleDrag: 0.05,
                                    emissionFrequency: 0.05,
                                    numberOfParticles: 50,
                                    gravity: 0.05,
                                    shouldLoop: false,
                                    colors: const [
                                      Colors.green,
                                      Colors.blue,
                                      Colors.pink,
                                      Colors.orange,
                                      Colors.purple
                                    ], // manually specify the colors to be used
                                  )
                                : Container(),
                            Container(
                                // padding: EdgeInsets.fromLTRB(70, 10, 10, 10),
                                child: CircularPercentIndicator(
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text(
                                finishedPercentage.isNaN
                                    ? "0%"
                                    : finishedPercentage.toStringAsFixed(2) +
                                        "%",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              radius: 180,
                              lineWidth: 15.0,
                              //leaner progress bar
                              //width for progress bar
                              animation:
                                  true, //animation to show progress at first
                              animationDuration: 1000,
                              addAutomaticKeepAlive: false,
                              // lineHeight: 15.0, //height of progress bar
                              percent: finishedPercentage.isNaN
                                  ? 0
                                  : finishedPercentage /
                                      100, // 30/100 = 0.3//make round cap at start and end both
                              progressColor: Colors
                                  .indigo[400], //percentage progress bar color
                              backgroundColor: Colors
                                  .grey[400], //background progressbar color
                            )),
                            SizedBox(height: 20),
                            Text(
                              finishedPercentage == 100
                                  ? 'Great Job! All Task Are Finished!'
                                  : finishedPercentage.isNaN
                                      ? "No Task"
                                      : finishedPercentage.toStringAsFixed(0) +
                                          " Percent of Task is Completed",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.blue[50],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
