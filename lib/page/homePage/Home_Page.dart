import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplify/algo/stringComparisonRanking.dart';
import 'package:simplify/db_helper/database_helper.dart';
import 'package:simplify/main.dart';
import 'package:simplify/model/task.dart';
import 'package:simplify/page/homePage/unfinished.dart';
import 'package:simplify/page/taskList/List_View_Page.dart';
import 'package:simplify/page/taskList/taskScreens/taskList_add_backend.dart';
import 'package:timer_builder/timer_builder.dart';

class QuotesPage extends StatefulWidget {
  final Stream<bool> stream;
  QuotesPage({Key? key, required this.stream}) : super(key: key);

  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage>
    with AutomaticKeepAliveClientMixin {
  //default task
  final Task defaultTask = Task(
      dateSched: DateTime.now(),
      isDone: true,
      description: '',
      isSmartAlert: false,
      title: 'Welcome To Simplify!');
  late List<Task> priorityTask;
  late List<Color> priorityColor;
  var now = DateTime.now();
  bool isLoading = false;
  bool isDone = false;
  bool isUnfinished = false;

  @override
  void initState() {
    super.initState();
    widget.stream.listen((isRefresh) {
      if (isRefresh) {
        refreshState();
      }
    });
    refreshState();
  }

  Future refreshState() async {
    setState(() => isLoading = true);
    priorityTask = await DatabaseHelper.instance.readAllTaskToday();

    if (priorityTask.isEmpty) {
      priorityTask = [defaultTask];
      priorityColor = [Colors.white];
    } else {
      priorityColor =
          List.generate(priorityTask.length, (index) => Colors.white);
      print(priorityTask[0].dateSched);
      for (int x = 0; x < priorityTask.length; x++) {
        var diff = priorityTask[x].dateSched.difference(now);
        now = DateTime.now();
        //if task is due within 3hrs
        if (diff.inMicroseconds <= 0) {
          priorityColor[x] = Colors.red.shade400;
        } else if (diff.inHours < 3 && diff.inMicroseconds > 0) {
          priorityColor[x] = Colors.orange.shade400;
        } else if (diff.inHours > 3 && diff.inDays < 1) {
          priorityColor[x] = Colors.amber.shade300;
        } else {
          priorityColor[x] = Colors.lightGreen.shade400;
        }
      }
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
          // appBar: AppBar(
          //   title: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Icon(Icons.home_rounded),
          //       Text(
          //         ' Home',
          //         style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          //       ),
          //     ],
          //   ),
          //   // centerTitle: true,
          //   backgroundColor: Colors.transparent,
          //   elevation: 0.0,
          //   actions:[
          //     Container(
          //       decoration: BoxDecoration(
          //         color:
          //         Colors.blueGrey.shade900,
          //         borderRadius: BorderRadius.circular(5)
          //       ),
          //       child: TextButton(
          //       onPressed: () {
          //         if(isUnfinished == false){
          //           setState(() {
          //             isUnfinished = true;
          //           });
          //         }else{
          //           setState(() {
          //             isUnfinished = false;
          //           });
          //         }
          //       },
          //       child: isUnfinished?
          //       Text('Tasks Today', style: TextStyle(color: Colors.white) )
          //       :Text('Unfinished Tasks', style: TextStyle(color: Colors.white)),
          //       ),
          //     )]
          // ),
          body: isUnfinished
              ? Container()
              // UnfinishedPage(streamUnfinished: widget.streamUnfinished)
              : isLoading
                  ? Center(child: CircularProgressIndicator())
                  : TimerBuilder.scheduled([priorityTask[0].dateSched],
                      builder: (context) {
                      return Swiper(
                        itemWidth: MediaQuery.of(context).size.width - 2,
                        pagination: SwiperPagination(),
                        itemCount: priorityTask.length,
                        itemBuilder: (context, index) {
                          return Stack(children: [buildPriorityTask(index)]);
                        },
                      );
                    })),
    );
  }

  Widget buildPriorityTask(int index) {
    now = DateTime.now();
    var diff = priorityTask[index].dateSched.difference(now);

    if (diff.inHours <= -24) {
      priorityColor[index] = Colors.red.shade400;
    } else if (diff.inMicroseconds <= 0 && diff.inDays >= -1) {
      priorityColor[index] = Colors.amber.shade300;
    } else if (diff.inDays < 1) {
      priorityColor[index] = Colors.pink.shade200;
    } else {
      priorityColor[index] = Colors.lightGreen.shade400;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            priorityTask[index].title == 'Welcome To Simplify!'
                                ? Colors.white70
                                : priorityColor[index],
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
                          leading: priorityTask[index].title ==
                                  'Welcome To Simplify!'
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    updateIsDone(index);
                                    listController.add(true);
                                    calendarController.add(true);
                                    unfinishedController.add(true);
                                    mainController.add(true);
                                  },
                                  icon: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        left: 1.0,
                                        top: 2.0,
                                        child: Icon(
                                            Icons.check_box_outline_blank,
                                            color: Colors.black12,
                                            size: 30),
                                      ),
                                      Icon(Icons.check_box_outline_blank,
                                          size: 30),
                                    ],
                                  ),
                                ),
                          title: GestureDetector(
                            child: Text(
                              priorityTask[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: priorityTask[index].title ==
                                    'Welcome To Simplify!'
                                ? null
                                : () async {
                                    await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddEditTaskPage(
                                                    taskContent:
                                                        priorityTask[index])));
                                    refreshState();
                                  },
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat.yMMMd()
                                    .format(priorityTask[index].dateSched),
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
                        image: DecorationImage(
                            image: AssetImage("assets/testing/today.png"),
                            fit: BoxFit.cover,
                            opacity: 0.5),
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
                            // 'sample quote',
                            getQuote(priorityTask[index].title,
                                priorityTask[index].description),
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
          ),
        ),
        Flexible(
            child: SizedBox(
          height: 8,
        ))
      ],
    );
  }

  Future updateIsDone(int index) async {
    final task = Task(
        id: priorityTask[index].id,
        title: priorityTask[index].title,
        description: priorityTask[index].description,
        dateSched: priorityTask[index].dateSched,
        isSmartAlert: priorityTask[index].isSmartAlert,
        isDone: true);
    await DatabaseHelper.instance.updateTask(task);
    notificationPluginList.cancel(priorityTask[index].id!);
    if (priorityTask[index].isSmartAlert) {
      String importantId = priorityTask[index].dateSched.year.toString() +
          priorityTask[index].id.toString();
      notificationPluginList.cancel(int.parse(importantId));
    }
    refreshState();
  }

  @override
  bool get wantKeepAlive => true;
}
