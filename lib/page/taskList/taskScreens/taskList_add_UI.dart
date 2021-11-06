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


  @override
  Widget build(BuildContext context) =>
        Padding(
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
                  SizedBox(height: 8),
                  Flexible(
                    child: Wrap(
                      children: [
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildTitle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildDescription(),
                    ),
                      ],
                    ),
                  ),
                ],
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
        validator: (title) => title != null && title.isEmpty
            ? 'Please add a title'
            : null,
        onChanged: widget.onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
    maxLines: null,
    initialValue: widget.description,
    style: TextStyle(fontSize: 16),
    decoration: InputDecoration(
      focusedBorder: InputBorder.none,
      border: InputBorder.none,
        hintText: 'Task Description',
        hintStyle: TextStyle(color: Colors.black54)),
    validator: (description) => description != null && description.isEmpty
        ? "Plase add a description"
        : null,
    onChanged: widget.onChangedDescription,
  );

  Widget buildTimeSched() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 3,
                    child: Row(
                      children: [
                        Icon(
                        Icons.alarm,
                        size: 30,
                      ),
                        TextButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              DatePicker.showDateTimePicker(context,
                              currentTime: widget.dateSched,
                              onConfirm: widget.onChangeDateSched,
                              locale: LocaleType.en);
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                child: dateTimeShow()
                              ),
                            )
                            ),
                      ],
                    ),
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

  Widget buildTags() =>  ListTile(
                title: Text("sample tag"),
                leading: Radio(
                  value: 1,
                  groupValue: null,
                  onChanged: null,
                ),
              );

//ButtonText Text child formatted display text
  Widget dateTimeShow() => RichText(
            text: new TextSpan(
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
              children:[
                new TextSpan(
                    text: DateFormat('h:mm a').format(widget.dateSched!),
                    style: TextStyle(fontSize: 20, ),
                    ),
                WidgetSpan(
                  child: Icon(Icons.arrow_drop_down, color: Colors.grey[800],),
                ),
                new TextSpan(
                    text: '\n'+DateFormat('d MMM y').format(widget.dateSched!),
                    style: TextStyle(fontSize: 15, color: Colors.grey[700])),
              ],
            ),
          );

}
