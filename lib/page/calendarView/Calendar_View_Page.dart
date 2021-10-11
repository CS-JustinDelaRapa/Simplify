import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
class _CalendarViewPageState extends State<CalendarViewPage> with AutomaticKeepAliveClientMixin {
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
          ? [...fromTaskMap[DateTime(element.dateSched.year,element.dateSched.month,element.dateSched.day,)]!,
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Calendar View',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF57A0D3),
        elevation: 0.0,
        actions: [buildRefreshButton()],
      ),
      body:isLoading? Center(child: CircularProgressIndicator()) 
          :Column(
        children: [
               Expanded(
                 flex: 6,
                 child: Padding(
                   padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                   child: TableCalendar(
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
                        _focusedDay = selectedDay; // update `_focusedDay` here as well
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
            Expanded(
              flex: 4,
              child:_getEventsForDay(_focusedDay).isEmpty?
                    Center(child: Text('You have no task For this day')) 
              :ListView.builder(
                itemCount: _getEventsForDay(_focusedDay).length,
                itemBuilder:(context, index){
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8,0,8,8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0
                        )
                      ),
                      child: ListTile(
                      title: Text(_getEventsForDay(_focusedDay)[index].title),
                      subtitle: Text(
                        DateFormat('h:mm a').format(_getEventsForDay(_focusedDay)[index].dateSched)
                      ),
                      onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddEditTaskPage(
                              taskContent: _getEventsForDay(_focusedDay)[index])));
                      refreshState();
                      }
                      ),
                    ),
                  );
              }
                      ),
            ),
        ],
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