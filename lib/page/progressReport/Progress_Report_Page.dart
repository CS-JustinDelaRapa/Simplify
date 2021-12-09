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
          actions: [refreshButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  width: 380,
                  height: 380,
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
                        Text(
                          finishedPercentage.toStringAsFixed(2) + "%",
                          style: TextStyle(
                              fontSize: 70,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Task completed",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(70, 10, 10, 10),
                            child: LinearPercentIndicator(
                              //leaner progress bar
                              width: 210, //width for progress bar
                              animation:
                                  true, //animation to show progress at first
                              animationDuration: 1000,
                              lineHeight: 25.0, //height of progress bar
                              percent: finishedPercentage /
                                  100, // 30/100 = 0.3//make round cap at start and end both
                              progressColor:
                                  Colors.black, //percentage progress bar color
                              backgroundColor:
                                  Colors.grey, //background progressbar color
                            )),
                        // MaterialButton(
                        //   onPressed: () {
                        //     //do whatever you want
                        //   },
                        //   child: Text("Mark Attendance"),
                        // ),
                        // MaterialButton(
                        //   onPressed: () {
                        //     //do whatever you want
                        //   },
                        //   child: Text("Mark Attendance"),
                        // ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(200),
                    ),
                    color: Colors.yellow[800],
                  ),
                ),
              ),
        // Container(
        //     child: Column(
        //       children: <Widget>[
        //         Expanded(
        //           flex: 4,
        //           child: PieChart(
        //             PieChartData(
        //               sectionsSpace: 0,
        //               centerSpaceRadius: 0,
        //               sections: <PieChartSectionData>[
        //                 PieChartSectionData(
        //                     color: Colors.black,
        //                     value: doneTask,
        //                     title: finishedPercentage.toStringAsFixed(2) +
        //                         "%",
        //                     radius: 150,
        //                     titleStyle: TextStyle(
        //                       fontSize: 24,
        //                       fontWeight: FontWeight.bold,
        //                       color: Colors.white,
        //                     )),
        //                 PieChartSectionData(
        //                     color: Colors.white,
        //                     value: totalTask - doneTask,
        //                     title:
        //                         unfinishedPercentage.toStringAsFixed(2) +
        //                             "%",
        //                     radius: 150,
        //                     titleStyle: TextStyle(
        //                       fontSize: 24,
        //                       fontWeight: FontWeight.bold,
        //                       color: Colors.black,
        //                     )),
        //               ],
        //             ),
        //           ),
        //         ),
        //         Expanded(
        //           flex: 2,
        //           child: Padding(
        //             padding: const EdgeInsets.all(16.0),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Column(
        //                   children: <Widget>[
        //                     Row(
        //                       children: [
        //                         Container(
        //                           width: 16,
        //                           height: 16,
        //                           decoration: BoxDecoration(
        //                             shape: BoxShape.circle,
        //                             color: Colors.black,
        //                           ),
        //                         ),
        //                         SizedBox(
        //                           width: 10,
        //                         ),
        //                         Text('Finished task',
        //                             style: TextStyle(
        //                                 fontSize: 16,
        //                                 fontWeight: FontWeight.bold,
        //                                 color: Colors.black87)),
        //                       ],
        //                     ),
        //                     Row(
        //                       children: [
        //                         Container(
        //                           width: 16,
        //                           height: 16,
        //                           decoration: BoxDecoration(
        //                             shape: BoxShape.circle,
        //                             color: Colors.white,
        //                           ),
        //                         ),
        //                         SizedBox(
        //                           width: 10,
        //                         ),
        //                         Text('Unfinished task',
        //                             style: TextStyle(
        //                                 fontSize: 16,
        //                                 fontWeight: FontWeight.bold,
        //                                 color: Colors.black87)),
        //                       ],
        //                     )
        //                   ],
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   )
      ),
    );
  }

  Widget refreshButton() =>
      IconButton(onPressed: refreshState, icon: Icon(Icons.refresh_rounded));
}
