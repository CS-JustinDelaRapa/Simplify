import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:simplify/db_helper/database_helper.dart';
import 'package:simplify/model/grade_tracker/course.dart';
import 'package:simplify/page/gradeTracker/gradeTrackerScreens/courseScreen.dart';

class GradeTrackerPage extends StatefulWidget {
  const GradeTrackerPage({Key? key}) : super(key: key);

  @override
  _GradeTrackerPageState createState() => _GradeTrackerPageState();
}

class _GradeTrackerPageState extends State<GradeTrackerPage>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  late List<Course> courseList;
  Color pickedColor = Colors.red;
  bool isLoading = false;
  String? courseName;
  bool isLongPressed = false;
  double averageGrade = 0;

  @override
  void initState() {
    refreshState();
    super.initState();
  }

  void changeColor(Color color) => setState(() {
        pickedColor = color;
      });

  Future refreshState() async {
    setState(() {
      isLoading = true;
    });
    courseList = await DatabaseHelper.instance.readAllCourse();
    sumAverageGrade();
    setState(() {
      isLoading = false;
    });
    courseName = '';
  }

  sumAverageGrade() {
    for (int x = 0; x < courseList.length; x++) {
      averageGrade += courseList[x].courseGrade;
    }
    averageGrade = averageGrade / courseList.length;
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
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Row(children: [
            Icon(Icons.menu_book_rounded),
            SizedBox(
              width: 10,
            ),
            Text('Grade Tracker',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500))
          ]),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: courseList.isEmpty
                    ? Center(
                        child: Text(
                          'No Courses',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(generateRemarksWord(100),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: FittedBox(
                                    fit: BoxFit.none,
                                    child: Text("100",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 90,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: FittedBox(
                                    fit: BoxFit.none,
                                    child: Text(
                                      generateRemarks(averageGrade),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Center(
                              child: Text('Average Grade',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.only(top: 22),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30)),
                                color: Colors.blue[50],
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: courseList.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: isLongPressed
                                                ? () async {
                                                    setState(() {
                                                      isLongPressed = false;
                                                    });
                                                  }
                                                : () async {
                                                    await Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                CourseScreenPage(
                                                                    courseInfo:
                                                                        courseList[
                                                                            index])));
                                                  },
                                            onLongPress: () async {
                                              if (isLongPressed) {
                                                setState(() {
                                                  isLongPressed = false;
                                                });
                                              } else {
                                                setState(() {
                                                  isLongPressed = true;
                                                });
                                              }
                                              refreshState();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Container(
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.amber.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 2,
                                                        offset: Offset(0, 4)),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: ListTile(
                                                    leading: null,
                                                    title: Text(
                                                      courseList[index]
                                                          .courseName,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    trailing: isLongPressed
                                                        ? Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    showDialogFunction(
                                                                        courseList[
                                                                            index]);
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .edit)),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title: Text('Delete ' +
                                                                                courseList[index].courseName +
                                                                                ' from list?'),
                                                                            actions: [
                                                                              TextButton(
                                                                                child: Text("Cancel"),
                                                                                onPressed: () {
                                                                                  Navigator.of(context, rootNavigator: true).pop();
                                                                                },
                                                                              ),
                                                                              TextButton(
                                                                                child: Text("OK"),
                                                                                onPressed: () {
                                                                                  DatabaseHelper.instance.deleteCourse(courseList[index].id!);
                                                                                  Navigator.of(context, rootNavigator: true).pop();
                                                                                  setState(() {
                                                                                    isLongPressed = false;
                                                                                  });
                                                                                  refreshState();
                                                                                },
                                                                              )
                                                                            ],
                                                                          );
                                                                        });
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .delete)),
                                                            ],
                                                          )
                                                        : Text(
                                                            courseList[index]
                                                                .courseGrade
                                                                .toString(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                    GestureDetector(
                                      onTap: () async {
                                        showDialogFunction(null);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Container(
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey[300],
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                                              leading: null,
                                              title: Center(
                                                child: Text(
                                                  'ADD COURSE',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
      ),
    );
  }

  generateRemarks(double grade) {
    late String remarks;
    if (grade >= 90) {
      remarks = "A";
    } else if (grade >= 85 && grade < 95) {
      remarks = "B";
    } else if (grade >= 80 && grade < 85) {
      remarks = "C";
    } else if (grade >= 75 && grade < 80) {
      remarks = "D";
    } else if (grade < 75 && grade > 0) {
      remarks = "F";
    } else if (grade == 0.0) {
      remarks = "N/A";
    }
    return remarks;
  }

  generateRemarksWord(double grade) {
    late String remarks;
    if (grade >= 90) {
      remarks = "Excellent";
    } else if (grade >= 80 && grade < 90) {
      remarks = "Good";
    } else if (grade >= 75 && grade < 80) {
      remarks = "Fair";
    } else if (grade < 75 && grade > 0) {
      remarks = "Failed";
    } else if (grade == 0.0) {
      remarks = "INC";
    }
    return remarks;
  }

  showDialogFunction(Course? fromCourseList) {
    return showDialog(
        context: this.context,
        builder: (BuildContext context) => Form(
            key: _formKey,
            child: AlertDialog(
                scrollable: true,
                title: fromCourseList == null
                    ? Text("Add course name")
                    : Text("Edit course name"),
                content: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: TextFormField(
                        validator: (value) => value != null && value.isEmpty
                            ? 'Required Subject Name'
                            : null,
                        initialValue: fromCourseList == null
                            ? null
                            : fromCourseList.courseName,
                        autofocus: true,
                        decoration: InputDecoration(hintText: "Course name"),
                        onChanged: (value) {
                          setState(() {
                            courseName = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                      onPressed: fromCourseList == null
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                final Course create = Course(
                                  courseName: courseName!,
                                  courseGrade: 0.0,
                                );
                                DatabaseHelper.instance.createCourse(create);
                                Navigator.pop(context);
                                setState(() {
                                  isLongPressed = false;
                                });
                                refreshState();
                              }
                            }
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final Course edit = Course(
                                    courseName: courseName!,
                                    courseGrade: fromCourseList.courseGrade,
                                    id: fromCourseList.id);
                                DatabaseHelper.instance.updateCourse(edit);
                                Navigator.pop(context);
                                setState(() {
                                  isLongPressed = false;
                                });
                                refreshState();
                              }
                            },
                      child: Text('Confirm'))
                ])));
  }

  @override
  bool get wantKeepAlive => true;
}
