import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplify/algo/stringComparisonRanking.dart';
import 'package:simplify/db_helper/database_helper.dart';
import 'package:simplify/model/task.dart';
import 'package:simplify/page/taskList/List_View_Page.dart';
import 'package:simplify/page/taskList/taskScreens/taskList_add_backend.dart';

class QuotesPage extends StatefulWidget {
  QuotesPage({
    Key? key,
  }) : super(key: key);

  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage>
    with AutomaticKeepAliveClientMixin {
  late Task priorityTask;
  late Color priorityColor;
  var now = DateTime.now();
  bool isLoading = false;
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    refreshState();
  }

  Future refreshState() async {
    setState(() => isLoading = true);
    priorityTask = await DatabaseHelper.instance.readPriorityTask();
    var diff = priorityTask.dateSched.difference(now);
    now = DateTime.now();
    //if task is due within 3hrs
    if (diff.inMinutes < 1) {
      setState(() {
        priorityColor = Colors.red.shade400;
      });
    } else if (diff.inHours < 3 && diff.inMinutes > 0) {
      setState(() {
        priorityColor = Colors.orange.shade400;
      });
    } else if (diff.inHours > 3 && diff.inDays < 1) {
      setState(() {
        priorityColor = Colors.amber.shade300;
      });
    } else {
      setState(() {
        priorityColor = Colors.lightGreen.shade400;
      });
    }
    setState(() => isLoading = false);
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
                Icon(Icons.home_rounded),
                Text(
                  ' Home',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            actions: [buildRefreshButton()],
            // centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Container(
                          child: buildPriorityTask(),
                        ),
                      ),
                    ),
                    Flexible(
                        child: SizedBox(
                      height: 8,
                    ))
                  ],
                )),
    );
  }

  Widget buildRefreshButton() {
    return IconButton(onPressed: refreshState, icon: Icon(Icons.refresh));
  }

  Widget buildPriorityTask() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: priorityTask.title == 'Welcome To Simplify!'
                    ? Colors.white70
                    : priorityColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: ListTile(
                  leading: priorityTask.title == 'Welcome To Simplify!'
                      ? null
                      : IconButton(
                          onPressed: () {
                            updateIsDone();
                          },
                          icon: Stack(
                            children: <Widget>[
                              Positioned(
                                left: 1.0,
                                top: 2.0,
                                child: Icon(Icons.check_box_outline_blank,
                                    color: Colors.black12, size: 30),
                              ),
                              Icon(Icons.check_box_outline_blank, size: 30),
                            ],
                          ),
                        ),
                  title: GestureDetector(
                    child: Text(
                      priorityTask.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: priorityTask.title == 'Welcome To Simplify!'
                        ? null
                        : () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddEditTaskPage(
                                    taskContent: priorityTask)));
                            refreshState();
                          },
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMd().format(priorityTask.dateSched),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white70,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    getQuote(priorityTask.title, priorityTask.description),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future updateIsDone() async {
    final task = Task(
        id: priorityTask.id,
        title: priorityTask.title,
        description: priorityTask.description,
        dateSched: priorityTask.dateSched,
        isSmartAlert: priorityTask.isSmartAlert,
        isDone: true);
    await DatabaseHelper.instance.updateTask(task);
    notificationPluginList.cancel(priorityTask.id!);
    if (priorityTask.isSmartAlert) {
      String importantId =
          priorityTask.dateSched.year.toString() + priorityTask.id.toString();
      notificationPluginList.cancel(int.parse(importantId));
    }
    refreshState();
  }

  @override
  bool get wantKeepAlive => true;
}
