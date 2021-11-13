import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplify/db_helper/database_helper.dart';
import 'package:simplify/model/task.dart';
import 'package:simplify/page/taskList/taskScreens/taskList_add_UI.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

FlutterLocalNotificationsPlugin notificationPlugin =
    FlutterLocalNotificationsPlugin();

class AddEditTaskPage extends StatefulWidget {
  final Task? taskContent;
  final DateTime? calendarDate;
  const AddEditTaskPage({Key? key, this.taskContent, this.calendarDate}) : super(key: key);

  @override
  _AddEditTaskPageState createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final key = new GlobalKey();

  //forms
  late String title;
  late String description;
  late DateTime dateSched;
  late bool isSmartAlert;
  late bool isDone;

//conditional
  late bool _btnEnabled = false;

//initialize date picker minimum date
  late String time;

  @override
  void initState() {
    super.initState();

    //for local notification
    initializeSetting();

    tz.initializeTimeZones();

    //declaring initial values of form fields
    isSmartAlert = widget.taskContent?.isSmartAlert ?? false;
    title = widget.taskContent?.title ?? '';
    description = widget.taskContent?.description ?? '';
    if (widget.calendarDate == null){
      dateSched = widget.taskContent?.dateSched ?? DateTime.now();
    } else {
      dateSched = widget.calendarDate!;
    }
    isDone = widget.taskContent?.isDone ?? false;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
        final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade800,
        title: Text('Create Task'),
        elevation: 0.0,
        actions: [buildButton(_btnEnabled)],
      ),
      body: Form(
        key: _formKey,
        child: Container(
        height: size.height,
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/testing/testing.png"),
        fit: BoxFit.cover,
      ),
    ),
          child: TaskFormWidget(
            title: title,
            description: description,
            dateSched: dateSched,
            switchValue: isSmartAlert,
            onChangedTitle: (titleChanged) {
              validateFields();
              return setState(() => this.title = titleChanged);
            },
            onChangedDescription: (descriptionChanged) {
              validateFields();
              return setState(() => this.description = descriptionChanged);
            },
            onChangeDateSched: (dateChange) {
              validateFields();
              return setState(() {
                this.dateSched = dateChange;
              });
            },
            onChangedSwitch: (smartChange) {
              validateFields();
              return setState(() {
                if (this
                    .dateSched
                    .subtract(Duration(minutes: 30))
                    .isBefore(DateTime.now())) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Task shouldn't be within 30 minutes!"),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                } else {
                  this.isSmartAlert = smartChange;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  void validateFields() {
    if (title.isNotEmpty && description.isNotEmpty) {
      _btnEnabled = true;
    }
    buildButton(_btnEnabled);
  }

  Widget buildButton(bool valid) {
    if (valid) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey[900],
          ),
          onPressed: () {
            var ans = dateSched.difference(DateTime.now());
            print(ans);
            if (ans.inMinutes < 1) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    actionsAlignment: MainAxisAlignment.center,
                    title: Text('Task is too soon!'),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      )
                    ],
                  );
                },
              );
            } else {
              addOrUpdateTask();
            }
          },
          child: Text(
            'Save',
            style: TextStyle(fontSize: 15),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void addOrUpdateTask() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final isUpdating = widget.taskContent != null;
      if (isUpdating) {
        await updateTask();
      } else {
        await addTask();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateTask() async {
    final task = widget.taskContent!.returnID(
        title: title,
        description: description,
        isSmartAlert: isSmartAlert,
        dateSched: dateSched);
    await DatabaseHelper.instance.updateTask(task);
    displayNotification(task.id!, task);
    if (task.isSmartAlert == true) {
      String importantId = task.dateSched.year.toString() + task.id!.toString();
      isImportantNotification(int.parse(importantId), task);
    } else {
      String importantId = task.dateSched.year.toString() + task.id!.toString();
      notificationPlugin.cancel(int.parse(importantId));
    }
  }

  Future addTask() async {
    final task = Task(
        title: title,
        description: description,
        dateSched: dateSched,
        isSmartAlert: isSmartAlert,
        isDone: isDone);
    final idAdd = await DatabaseHelper.instance.createTask(task);
    if (task.isSmartAlert == true) {
      String importantId = task.dateSched.year.toString() + idAdd.toString();
      isImportantNotification(int.parse(importantId), task);
    }
    displayNotification(idAdd, task);
  }

  Future<void> displayNotification(int id, Task task) async {
    notificationPlugin.zonedSchedule(
        id,
        task.title,
        "Task should be done now",
        tz.TZDateTime.from(task.dateSched, tz.local),
        NotificationDetails(
            android: AndroidNotificationDetails(
          "Channel7",
          "GMA",
          "Kapuso",
          importance: Importance.high,
          enableVibration: true,
          vibrationPattern: Int64List(40),
          playSound: true,
          sound: RawResourceAndroidNotificationSound('cantina_band'),
        )),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  Future<void> isImportantNotification(int id, Task task) async {
    DateTime newDate = task.dateSched.subtract(Duration(minutes: 30));
    notificationPlugin.zonedSchedule(
        id,
        "Incoming task within 30 minutes (" + task.title + ")",
        "",
        tz.TZDateTime.from(newDate, tz.local),
        NotificationDetails(
            android: AndroidNotificationDetails(
          "Chanel5",
          "TV5",
          "Kabarkada",
          importance: Importance.high,
          enableVibration: true,
          vibrationPattern: Int64List(40)
        )),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}

void initializeSetting() async {
  var initializeAndroid = AndroidInitializationSettings('sample_logo');
  var initializeSetting = InitializationSettings(android: initializeAndroid);
  notificationPlugin.initialize(initializeSetting);
}
