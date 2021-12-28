import 'package:flutter/material.dart';
import 'package:simplify/db_helper/database_helper.dart';
import 'package:simplify/model/grade_tracker/course.dart';
import 'package:simplify/model/grade_tracker/gradeFactor.dart';
import 'package:simplify/page/gradeTracker/gradeTrackerScreens/courseFactorScreen.dart';

class CourseScreenPage extends StatefulWidget {
  final Course courseInfo;
  const CourseScreenPage({Key? key, required this.courseInfo})
      : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreenPage> {
  late List<Factor> gradeFactor;
  bool isLoading = false;
  String? factorName;
  double? factorPercentage;

  @override
  void initState() {
    refreshState();
    super.initState();
  }

  Future refreshState() async {
    setState(() {
      isLoading = true;
    });
    gradeFactor =
    await DatabaseHelper.instance.readCourse(widget.courseInfo.id!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.courseInfo.courseName,
                                          style: TextStyle(fontSize: 24)),
                                      Text(
                                        "Enter your grade factor here",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ]),
                              ),
                              titlePadding:
                                  EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 0.0),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextFormField(
                                    autofocus: true,
                                    decoration: InputDecoration(
                                        hintText: "Factor name"),
                                    onChanged: (value) {
                                      setState(() {
                                        factorName = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    autofocus: true,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText: "Factor percentage"),
                                    onChanged: (value) {
                                      setState(() {
                                        factorPercentage = double.parse(value);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      final Factor factorCreate = Factor(
                                  factorName: factorName!,
                                  factorGrade: 0.0,
                                  factorPercentage: factorPercentage!,
                                  fkCourse: widget.courseInfo.id!
                                );
                                DatabaseHelper.instance.createFactor(factorCreate);
                                print(factorCreate.factorName);
                                print(factorCreate.factorPercentage);
                                print(factorCreate.factorGrade);
                                print(factorCreate.fkCourse);
                                Navigator.pop(context);
                                refreshState();
                                    },
                                    child: Text('Confirm'))
                              ],
                            ));
                  },
                  child: Text('Add Category'))
            ],
            backgroundColor: Colors.indigo.shade800,
            elevation: 0.0,
            title: Text(widget.courseInfo.courseName)),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: gradeFactor.isEmpty
                    ? Center(
                        child: Text(
                          'No Grade Factors',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : ListView.builder(
                        itemCount: gradeFactor.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CourseFactorScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2,
                                        offset: Offset(0, 4)),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ListTile(
                                    title: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            gradeFactor[index].factorName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                      gradeFactor[index].factorPercentage.toString()+'%',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        })),
      ),
    );
  }
}
