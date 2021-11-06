import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiaryFormWidget extends StatefulWidget {
  //pwede walang laman
  final String? title;
  final String? description;
  final DateTime? dateCreated;

  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  const DiaryFormWidget({
    Key? key,
    this.dateCreated,
    this.title,
    this.description,
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  _DiaryFormWidgetState createState() => _DiaryFormWidgetState();
}

class _DiaryFormWidgetState extends State<DiaryFormWidget> {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildDate(),
                SizedBox(height: 15),
                buildTitle(),
                SizedBox(height: 8),
                buildDescription(),
              ],
            ),
          ),
        ),
      );
  Widget buildDate() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RichText(
            text: new TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              children: <TextSpan>[
                new TextSpan(
                    text: DateFormat.d().format(widget.dateCreated!),
                    style: TextStyle(fontSize: 30)),
                new TextSpan(
                    text: ' ' +
                        DateFormat.MMM().format(widget.dateCreated!) +
                        '. ',
                    style: TextStyle(fontSize: 15)),
                new TextSpan(
                    text: DateFormat.y().format(widget.dateCreated!),
                    style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      );
  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: widget.title,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 20,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.black54),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'Every chapter in life should have a beautiful title'
            : null,
        onChanged: widget.onChangedTitle,
      );
  Widget buildDescription() => Flexible(
        child: TextFormField(
          maxLines: null,
          initialValue: widget.description,
          style: TextStyle(fontSize: 18),
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              hintText: 'Tell us what you feel',
              hintStyle: TextStyle(color: Colors.black54)),
          validator: (description) => description != null && description.isEmpty
              ? "I'm here to listen. Don't hesitate to open up when you're ready"
              : null,
          onChanged: widget.onChangedDescription,
        ),
      );
}
