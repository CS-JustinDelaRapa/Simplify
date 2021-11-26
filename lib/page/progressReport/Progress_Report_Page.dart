import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simplify/db_helper/database_helper.dart';
import 'package:simplify/model/task.dart';
import 'package:simplify/page/progressReport/progressReportScreens/indicators.dart';
import 'package:simplify/page/progressReport/progressReportScreens/progressReportSections.dart';

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
  late int doneTask;

  @override
  void initState() {
    super.initState();
    refreshState();
    // getDoneTask();
  }

  Future refreshState() async {
    setState(() => isLoading = true);
    this.taskContent = await DatabaseHelper.instance.readAllTask();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    int touchedIndex;
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
                Icon(Icons.circle_notifications),
                Text(
                  ' Progress Report',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: [],
          ),
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0,
                            centerSpaceRadius: 0,
                            sections: getSections(100),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: IndicatorsWidget(),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
    );
  }

  // Future getDoneTask() async {
  //   for (var i = 0; i < taskContent.length; i++) {
  //     if (taskContent[i].isDone == true) {
  //       setState(() {
  //         doneTask++;
  //       });
  //     }
  //   }
  //   return null;
  // }

  @override
  bool get wantKeepAlive => true;
}
