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
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          actions: [buildRefreshButton()],
          centerTitle: true,
          backgroundColor: Color(0xFF57A0D3),
          elevation: 0.0,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      child: SizedBox(
                    height: 8,
                  )),
                  Flexible(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: buildPriorityTask(),
                      ),
                    ),
                  ),
                  Flexible(
                      child: SizedBox(
                    height: 8,
                  ))
                ],
              ));
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
            child: ListTile(
              leading: priorityTask.title == 'Welcome To Simplify'
                  ? null
                  : IconButton(
                      onPressed: () {
                        updateIsDone();
                      },
                      icon: Icon(Icons.check_box_outline_blank, size: 30)),
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
                onTap: priorityTask.title == 'Welcome To Simplify'
                    ? null
                    : () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                AddEditTaskPage(taskContent: priorityTask)));
                        refreshState();
                      },
              ),
              subtitle: Text(
                DateFormat.yMMMd().format(priorityTask.dateSched),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              getQuote(priorityTask.title, priorityTask.description),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
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
