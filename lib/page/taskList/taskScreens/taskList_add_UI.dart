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

//creating KeyboardVisibility instance
// var keyboardVisibilityController = KeyboardVisibilityController();

// @override
// void initState() {
//   super.initState();
//   //detect if Keyboard is active or not
//   // keyboardVisibilityController.onChange.listen((bool visible) {
//   //   setState(() {
//   //     isVisible = visible;
//   //   });
//   });
// }
  var time = TimeOfDay.fromDateTime(DateTime.now());
  DateTime date = DateTime.now();
  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) return '0$value';

    return value.toString();
  }

  //Time
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        time = picked;
      });
    }
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
        print(date.toString());
      });
    }
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

  Widget buildTimeSched() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 3,
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: const Icon(Icons.alarm),
                    iconSize: 40,
                    onPressed: () {
                      selectTime(context);
                      print(time);
                    }),
                Text(
                  "Time: ${_addLeadingZeroIfNeeded(time.hourOfPeriod)}:${_addLeadingZeroIfNeeded(time.minute)}",
                  style: const TextStyle(fontSize: 25),
                ),
                Column(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          selectDatePicker(context);
                        }),
                    Text(
                      "Date: ${_addLeadingZeroIfNeeded(date.month)}:${_addLeadingZeroIfNeeded(date.day)}:${_addLeadingZeroIfNeeded(date.year)}",
                      style: const TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ],
            ),

            // child: Row(
            //   children: [
            //     Icon(
            //       Icons.alarm,
            //       size: 30,
            //     ),
            //     TextButton(
            //         onPressed: () {
            //           FocusScope.of(context).unfocus();
            //           DatePicker.showDateTimePicker(
            //               context,
            //               currentTime: widget.dateSched,
            //               onConfirm: widget.onChangeDateSched,
            //               locale: LocaleType.en);
            //         },
            //         child: Container(
            //           child: Padding(
            //               padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
            //               child: dateTimeShow()),
            //         )),
            //   ],
            // ),
          ),
          Flexible(
            flex: 2,
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
      );

//ButtonText Text child formatted display text
  Widget dateTimeShow() => RichText(
        text: new TextSpan(
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
          children: [
            new TextSpan(
              text: DateFormat('h:mm a').format(widget.dateSched!),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            WidgetSpan(
              child: Icon(
                Icons.arrow_drop_down,
                color: Colors.grey[800],
              ),
            ),
            new TextSpan(
                text: '\n' + DateFormat('d MMM y').format(widget.dateSched!),
                style: TextStyle(fontSize: 15, color: Colors.grey[700])),
          ],
        ),
      );
}
