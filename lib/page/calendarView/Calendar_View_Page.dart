import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simplify/db_helper/database_helper.dart';
import 'package:simplify/model/task.dart';
import 'package:simplify/page/taskList/taskScreens/taskList_add_backend.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarViewPage extends StatefulWidget {
  CalendarViewPage({
    Key? key,
  }) : super(key: key);

  @override
  _CalendarViewPageState createState() => _CalendarViewPageState();
}

//coment
class _CalendarViewPageState extends State<CalendarViewPage>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  late List<Task> taskContent;
  String selectedDate = '';
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  //hold all task from db_helper
  Map<DateTime, List<Task>> fromTaskMap = {};
  //hold only the task with dateSched same as focused date
  Map mapToEvent = {};

  @override
  void initState() {
    super.initState();
    refreshState();
  }

  Future refreshState() async {
    setState(() => isLoading = true);
    taskContent = await DatabaseHelper.instance.readAllTask();
    fromTaskMap = {};

    //Key dateSched
    taskContent.forEach((element) {
      fromTaskMap[DateTime(
        element.dateSched.year,
        element.dateSched.month,
        element.dateSched.day,
      )] = fromTaskMap[DateTime(
                element.dateSched.year,
                element.dateSched.month,
                element.dateSched.day,
              )] !=
              null
          ? [
              ...fromTaskMap[DateTime(
                element.dateSched.year,
                element.dateSched.month,
                element.dateSched.day,
              )]!,
              element
            ]
          //value of whole task with the same dateSched as key
          : [element];
    });
    //from map to event
    mapToEvent = LinkedHashMap<DateTime, List<Task>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(fromTaskMap);
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
              Icon(MdiIcons.calendar),
              Text(
                ' Calendar',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [buildRefreshButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 2,
                                    offset: Offset(0, 4)),
                              ],
                              color: Colors.white),
                          child: TableCalendar(
                            calendarStyle: CalendarStyle(
                                markersMaxCount: 1,
                                markerDecoration: BoxDecoration(
                                    color: Colors.purpleAccent.shade400,
                                    shape: BoxShape.circle)),
                            shouldFillViewport: true,
                            firstDay: DateTime.utc(2000),
                            focusedDay: _focusedDay,
                            lastDay: DateTime.utc(2050),
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay =
                                    selectedDay; // update `_focusedDay` here as well
                              });
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                            calendarFormat: _calendarFormat,
                            onFormatChanged: (format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            },
                            eventLoader: (day) {
                              return _getEventsForDay(day);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: _getEventsForDay(_focusedDay).isEmpty
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('You have no task for this day'),
                              SizedBox(height: 5),
                              FloatingActionButton(
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                                heroTag: null,
                                backgroundColor: Colors.indigo.shade500,
                                child: Icon(Icons.add),
                                onPressed: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddEditTaskPage()),
                                  );
                                  refreshState();
                                },
                              ),
                            ],
                          ))
                        : ListView.builder(
                            itemCount: _getEventsForDay(_focusedDay).length,
                            itemBuilder: (context, index) {
                              var now = DateTime.now();
                              var diff = _getEventsForDay(_focusedDay)[index]
                                  .dateSched
                                  .difference(now);
                              late Color priorityColor;

                              if (_getEventsForDay(_focusedDay)[index].isDone ==
                                  true) {
                                priorityColor = Colors.grey.shade500;
                              } else if (diff.inMicroseconds <= 0) {
                                priorityColor = Colors.red.shade400;
                              } else if (diff.inHours < 3 &&
                                  diff.inMicroseconds > 0) {
                                priorityColor = Colors.orange.shade400;
                              } else if (diff.inHours > 3 && diff.inDays < 1) {
                                priorityColor = Colors.amber.shade300;
                              } else {
                                priorityColor = Colors.lightGreen.shade400;
                              }

                              return Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: priorityColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 2,
                                          offset: Offset(0, 4)),
                                    ],
                                  ),
                                  child: ListTile(
                                      title: Text(
                                          _getEventsForDay(_focusedDay)[index]
                                              .title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      subtitle: Text(DateFormat('h:mm a')
                                          .format(_getEventsForDay(
                                                  _focusedDay)[index]
                                              .dateSched)),
                                      onTap: () async {
                                        await Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddEditTaskPage(
                                                        taskContent:
                                                            _getEventsForDay(
                                                                    _focusedDay)[
                                                                index])));
                                        refreshState();
                                      }),
                                ),
                              );
                            }),
                  ),
                ],
              ),
      ),
    );
  }

  List<Task> _getEventsForDay(DateTime day) {
    return mapToEvent[day] ?? [];
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Widget buildRefreshButton() =>
      IconButton(onPressed: refreshState, icon: Icon(Icons.refresh_rounded));

  @override
  bool get wantKeepAlive => true;
}
