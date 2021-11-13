import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:simplify/db_helper/database_helper.dart';
import 'package:simplify/model/task.dart';
import 'package:simplify/page/taskList/taskScreens/taskList_add_backend.dart';
import 'package:timer_builder/timer_builder.dart';

FlutterLocalNotificationsPlugin notificationPluginList =
    FlutterLocalNotificationsPlugin();

class ListViewPage extends StatefulWidget {
  ListViewPage({Key? key}) : super(key: key);

  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage>
    with AutomaticKeepAliveClientMixin {
  late List<Task> taskContent;
  late DateTime priorityTime;
  List<Task> deleteList = [];

  bool allSelected = false;
  bool onLongPress = false;
  bool isLoading = false;
  bool onChangeIsDone = false;

  @override
  void initState() {
    super.initState();
    initializeSetting();
    refreshState();
  }

  Future refreshState() async {
    setState(() => isLoading = true);
    this.taskContent = await DatabaseHelper.instance.readAllTask();
    if(this.taskContent.length == 0){
      priorityTime = DateTime.now();
    } else {
      priorityTime = this.taskContent[0].dateSched;
    }
    print('To-Do List: '+priorityTime.toString());
    setState(() => isLoading = false);

    print(priorityTime);
  }

  //Main UI diary
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
          leading: onLongPress
              ? IconButton(onPressed: cancelState, icon: Icon(Icons.cancel))
              : null,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: onLongPress
              ? Text(
                  deleteList.length == 1
                      ? deleteList.length.toString() + ' Selected Item'
                      : deleteList.length == 0
                          ? 'Select an Item'
                          : deleteList.length.toString() + ' Selected Items',
                  style: TextStyle(color: Colors.white, fontSize: 23),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.checklist_rtl_rounded),
                    Text(
                      ' To-Do List',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
          actions: <Widget>[
            onLongPress
                ? trailingAppbar()
                : Row(
                    children: [
                      buildTimeLegend(),
                      buildRefreshButton(),
                    ],
                  ),
          ],
        ),
        body: Container(
          child: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : taskContent.isEmpty
                    ? Text(
                        'No Task Content',
                        style: TextStyle(fontSize: 20),
                      )
                    : TimerBuilder.scheduled(
                      [priorityTime],
                      builder: (context) {
                        return buildList();
                      }
                    ),
          ),
        ),
        floatingActionButton: onLongPress
            ? Container()
            : FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.blueGrey[900],
                child: Icon(
                  Icons.add,
                  size: 30.0,
                ),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddEditTaskPage()),
                  );
                  refreshState();
                },
              ),
      ),
    );
  }

//** */**Funtions */**Funtions */**Funtions */**Funtions */**Funtions *///** */**Funtions */**Funtions */**Funtions */**Funtions */**Funtions */
  Widget buildRefreshButton() =>
      IconButton(onPressed: refreshState, icon: Icon(Icons.refresh_rounded));

  Widget buildTimeLegend() => IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text("Task Colors: "),
                    content: Container(
                      height: 270,
                      child: Column(
                        children: <Widget>[
                          Row(
                            //green text
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.lightGreen.shade400,
                                      shape: BoxShape.circle),
                                  child: Text(' ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 8,
                                child: Text('The task is due in 2 days or more',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            //yellow text
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.amber.shade300,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    ' ',
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 8,
                                child: Text(
                                    '\tThe task is due in less than a day',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            //orange text
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.orange.shade400,
                                      shape: BoxShape.circle),
                                  child: Text(' ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 8,
                                child: Text(
                                    '\tThe task is due in less than 3 hours',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.red.shade400,
                                      shape: BoxShape.circle),
                                  child: Text(' ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 8,
                                child: Text('Unfinished task(s)',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            //grey color
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade500,
                                      shape: BoxShape.circle),
                                  child: Text(' ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 8,
                                child: Text('Finished task(s)',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(
                                context,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ));
        },
        icon: Icon(Icons.info_outline_rounded, color: Colors.white),
        iconSize: 24,
      );

//listTiles
  Widget buildList() => ListView.builder(
      itemCount: taskContent.length,
      itemBuilder: (context, index) {
        var now = DateTime.now();
        var diff = taskContent[index].dateSched.difference(now);
        late Color priorityColor;

        if (taskContent[index].isDone == true) {
          priorityColor = Colors.grey.shade500;
        } else if (diff.inMicroseconds <= 0) {
          priorityColor = Colors.red.shade400;
        } else if (diff.inHours < 3 && diff.inMicroseconds > 0) {
          priorityColor = Colors.orange.shade400;
        } else if (diff.inHours > 3 && diff.inDays < 1) {
          priorityColor = Colors.amber.shade300;
        } else {
          priorityColor = Colors.lightGreen.shade400;
        }

        return GestureDetector(
          onTap
              //if
              : onLongPress
                  ? () async {
                      if (deleteList.contains(taskContent[index])) {
                        setState(() {
                          deleteList.remove(taskContent[index]);
                          allSelected = false;
                        });
                      } else {
                        setState(() {
                          deleteList.add(taskContent[index]);
                          if (deleteList.length == taskContent.length) {
                            allSelected = true;
                          }
                        });
                      }
                    }
                  //else
                  : () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddEditTaskPage(
                              taskContent: taskContent[index])));
                      refreshState();
                    },
          onLongPress: () async {
            onLongPress = true;
            setState(() {
              deleteList.add(taskContent[index]);
              if (deleteList.length == taskContent.length) {
                allSelected = true;
              } else {
                allSelected = false;
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(0, 4)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                child: ListTile(
                  leading: onLongPress
                      ? null
                      : IconButton(
                          onPressed: () {
                            updateIsDone(index);
                          },
                          icon: taskContent[index].isDone
                              ? Icon(Icons.check_box_outlined, size: 30)
                              : Icon(Icons.check_box_outline_blank, size: 30)),
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(
                          taskContent[index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 2,
                        child: Text(
                          DateFormat.yMMMd()
                              .format(taskContent[index].dateSched),
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  subtitle: Text(
                    taskContent[index].description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: deleteList.contains(taskContent[index])
                      ? Icon(Icons.check)
                      : null,
                ),
              ),
            ),
          ),
        );
      });

//appBar select all and delete button
  Widget trailingAppbar() {
    return Row(
      children: [
        Container(
            child: allSelected
                ? IconButton(
                    onPressed: unselectAll, icon: Icon(Icons.remove_rounded))
                : IconButton(
                    onPressed: selectAll,
                    icon: Icon(Icons.checklist_rtl_rounded))),
        deleteList.length == 0
            ? SizedBox()
            : IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(deleteList.length == 1
                              ? 'Delete ' +
                                  deleteList.length.toString() +
                                  ' item?'
                              : deleteList.length == 0
                                  ? 'sample'
                                  : 'Delete ' +
                                      deleteList.length.toString() +
                                      ' items?'),
                          actions: [
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                deleteItems();
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            )
                          ],
                        );
                      });
                },
                icon: Icon(Icons.delete))
      ],
    );
  }

//cancleButton
  Future cancelState() async {
    setState(() {
      deleteList.length = 0;
      onLongPress = false;
    });
  }

//deleteButton
  Future deleteItems() async {
    for (int x = 0; x < deleteList.length; x++) {
      int? search = deleteList[x].id;
      await DatabaseHelper.instance.deleteTask(search!);
      notificationPluginList.cancel(deleteList[x].id!);
      if (deleteList[x].isSmartAlert) {
        String importantId = deleteList[x].dateSched.year.toString() +
            deleteList[x].id.toString();
        notificationPluginList.cancel(int.parse(importantId));
      }
    }
    setState(() {
      onLongPress = false;
      deleteList = [];
      //refresh will reload build list
      refreshState();
    });
  }

//selectAll
  Future selectAll() async {
    setState(() {
      allSelected = true;
      deleteList = List.from(taskContent);
    });
  }

//unselectAll
  Future unselectAll() async {
    setState(() {
      deleteList = [];
      allSelected = false;
    });
  }

//update checkBox
  Future updateIsDone(int index) async {
    if (taskContent[index].isDone) {
      onChangeIsDone = false;
    } else {
      onChangeIsDone = true;
    }
    print(onChangeIsDone);
    final task = Task(
        id: taskContent[index].id,
        title: taskContent[index].title,
        description: taskContent[index].description,
        dateSched: taskContent[index].dateSched,
        isSmartAlert: taskContent[index].isSmartAlert,
        isDone: onChangeIsDone);
    await DatabaseHelper.instance.updateTask(task);
    notificationPluginList.cancel(task.id!);
    if (task.isSmartAlert) {
      String importantId = task.dateSched.year.toString() + task.id!.toString();
      notificationPluginList.cancel(int.parse(importantId));
    }
    refreshState();
  }

  //persisting diary
  @override
  bool get wantKeepAlive => true;
}
