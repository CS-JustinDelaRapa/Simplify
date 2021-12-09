import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class TaskFormWidget extends StatefulWidget {
  //pwede walang laman
  final bool? switchValue;

  final String? title;
  final String? description;
  final DateTime? dateSched;

  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final ValueChanged<DateTime> onChangeDateSched;
  final ValueChanged<bool> onChangedSwitch;

  TaskFormWidget({
    Key? key,
    this.dateSched,
    this.title,
    this.description,
    this.switchValue,
    required this.onChangedSwitch,
    required this.onChangedTitle,
    required this.onChangedDescription,
    required this.onChangeDateSched,
  }) : super(key: key);

  @override
  _TaskFormWidgetState createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
//conditional variable for build tags
  bool isVisible = false;

  var time = TimeOfDay.fromDateTime(DateTime.now());
  DateTime date = DateTime.now();

  //Time
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(widget.dateSched!));
    if (picked != null) {
      setState(() {
        time = picked;
      });
    }
    DateTime newTime =
        new DateTime(date.year, date.month, date.day, time.hour, time.minute);
    widget.onChangeDateSched(newTime);
  }

//Date
  Future<void> selectDatePicker(BuildContext context1) async {
    final DateTime? pickedd = await showDatePicker(
        context: context1,
        initialDate: date,
        firstDate: DateTime(1940),
        lastDate: DateTime(2030));
    if (pickedd != null && pickedd != date) {
      setState(() {
        date = pickedd;
      });
    }
    DateTime newTime =
        new DateTime(date.year, date.month, date.day, time.hour, time.minute);
    widget.onChangeDateSched(newTime);
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/testing/testing.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(0, 4)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildTimeSched(),
                    // SizedBox(height: 8),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildTitle(),
                    ),
                    buildDescription(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: widget.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          hintText: 'Task Title',
          hintStyle: TextStyle(color: Colors.black54),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'Please add a title' : null,
        onChanged: widget.onChangedTitle,
      );

  Widget buildDescription() => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            maxLines: null,
            initialValue: widget.description,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: 'Task Description',
                hintStyle: TextStyle(color: Colors.black54)),
            validator: (description) =>
                description != null && description.isEmpty
                    ? "Plase add a description"
                    : null,
            onChanged: widget.onChangedDescription,
          ),
        ),
      );

  Widget buildTimeSched() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 7,
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.alarm),
                        iconSize: 25,
                        onPressed: () {
                          selectTime(context);
                        }),
                    Text(
                      "${DateFormat('hh: mm a').format(widget.dateSched!)}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: Text(
                  'Smart Alert',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Switch(
                value: widget.switchValue!,
                onChanged: widget.onChangedSwitch,
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          iconSize: 25,
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () {
                            selectDatePicker(context);
                          }),
                      Text(
                        "${DateFormat('M/d/y, EEE').format(widget.dateSched!)}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  )
                ],
              ),
            ],
          )
        ],
      );
}
