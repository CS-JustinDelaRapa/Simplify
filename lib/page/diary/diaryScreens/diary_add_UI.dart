import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiaryFormWidget extends StatefulWidget {
  //pwede walang laman
  final String? title;
  final String? description;
  final DateTime? dateCreated;
  final int? color;

  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final ValueChanged<int> onChangeColor;
  const DiaryFormWidget({
    Key? key,
    this.dateCreated,
    this.title,
    this.description,
    this.color,
    required this.onChangedTitle,
    required this.onChangedDescription,
    required this.onChangeColor,
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
            child: Container(
              padding: EdgeInsets.all(20),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  FittedBox(
                    child: Row(
                      children: [
                        buildDate(),
                        SizedBox(width: 10),                      
                        buildColor(),
                      ],
                    ),
                  ),
                  buildTitle(),
                  SizedBox(height: 8),
                  buildDescription(),
                ],
              ),
            ),
          ),
        ),
      );
  Widget buildDate() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
          DateFormat.d().format(widget.dateCreated!),
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500,)),
          RichText(
            text: new TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
              children: <TextSpan>[
                new TextSpan(
                    text:
                        DateFormat.MMM().format(widget.dateCreated!) +
                        '. \n',
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
          fontSize: 20,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
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
                            focusedBorder: InputBorder.none,
                border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              hintText: 'Tell us what you feel',
              hintStyle: TextStyle(color: Colors.black54)),
          validator: (description) => description != null && description.isEmpty
              ? "I'm here to listen. Don't hesitate to open up when you're ready"
              : null,
          onChanged: widget.onChangedDescription,
        ),
      );
  Widget buildColor() => Row(
    children: [
      //amber
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: widget.color == Colors.amber.value? 
            Border.all(
              color: Colors.blue,
              width: 3,
            ):null,
          ),
          child: GestureDetector(
            onTap: (){
              widget.onChangeColor(Colors.amber.value);
              setState(() {
                widget.onChangeColor(Colors.amber.value);
              });
            },
            child: Container(
              height: 25,
              width: 25,
              color: Colors.amber,
              child: widget.color == Colors.amber.value?
              Icon(Icons.check)
              :null,
            ),
          ),
        ),
      ),
      //blue
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: widget.color == Colors.blue.shade500.value? 
            Border.all(
              color: Colors.blue,
              width: 3,
            ):null,
          ),
          child: GestureDetector(
            onTap: (){
              widget.onChangeColor(Colors.blue.shade500.value);
              setState(() {
                widget.onChangeColor(Colors.blue.shade500.value);
              });
            },
            child: Container(
              height: 25,
              width: 25,
              color: Colors.blue.shade500,
              child: widget.color == Colors.blue.shade500.value?
              Icon(Icons.check)
              :null,
            ),
          ),
        ),
      ), 
      //green
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: widget.color == Colors.green.shade500.value? 
            Border.all(
              color: Colors.blue,
              width: 3,
            ):null,
          ),
          child: GestureDetector(
            onTap: (){
                widget.onChangeColor(Colors.green.shade500.value);
              setState(() {
                widget.onChangeColor(Colors.green.shade500.value);
              });
            },
            child: Container(
              height: 25,
              width: 25,
              color: Colors.green.shade500,
              child: widget.color == Colors.green.shade500.value?
              Icon(Icons.check)
              :null,
            ),
          ),
        ),
      ),
      //pink
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: widget.color == Colors.pink.shade500.value? 
            Border.all(
              color: Colors.blue,
              width: 3,
            ):null,
          ),
          child: GestureDetector(
            onTap: (){
                widget.onChangeColor(Colors.pink.shade500.value);
              setState(() {
                widget.onChangeColor(Colors.pink.shade500.value);
              });
            },
            child: Container(
              height: 25,
              width: 25,
              color: Colors.pink.shade500,
              child: widget.color == Colors.pink.shade500.value?
              Icon(Icons.check)
              :null,
            ),
          ),
        ),
      ),
      //red
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: widget.color == Colors.red.shade500.value? 
            Border.all(
              color: Colors.blue,
              width: 3,
            ):null,
          ),
          child: GestureDetector(
            onTap: (){
              widget.onChangeColor(Colors.red.shade500.value);
              setState(() {
                widget.onChangeColor(Colors.red.shade500.value);
              });
            },
            child: Container(
              height: 25,
              width: 25,
              color: Colors.red.shade500,
              child: widget.color == Colors.red.shade500.value?
              Icon(Icons.check)
              :null,
            ),
          ),
        ),
      ),      

   ],
  );

}
