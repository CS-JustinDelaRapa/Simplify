import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simplify/db_helper/database_helper.dart';
import 'package:simplify/model/task.dart';

class ProgressReportPage extends StatefulWidget {
  ProgressReportPage({
    Key? key,
  }) : super(key: key);

  @override
  _ProgressReportPageState createState() => _ProgressReportPageState();
}

//coment
class _ProgressReportPageState extends State<ProgressReportPage>
    with AutomaticKeepAliveClientMixin {
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
    super.build(context);
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
              : Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 10,
                            centerSpaceRadius: 30,
                            sections: <PieChartSectionData>[
                              PieChartSectionData(
                                  color: Colors.black,
                                  value: doneTask,
                                  title: finishedPercentage.toStringAsFixed(2) +
                                      "%",
                                  radius: 150,
                                  titleStyle: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )),
                              PieChartSectionData(
                                  color: Colors.white,
                                  value: totalTask - doneTask,
                                  title:
                                      unfinishedPercentage.toStringAsFixed(2) +
                                          "%",
                                  radius: 150,
                                  titleStyle: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Finished task',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Unfinished task',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87)),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

  Widget refreshButton() =>
      IconButton(onPressed: refreshState, icon: Icon(Icons.refresh_rounded));

  @override
  bool get wantKeepAlive => true;
}
