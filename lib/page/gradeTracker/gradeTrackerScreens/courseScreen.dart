import 'package:flutter/material.dart';
import 'package:simplify/db_helper/database_helper.dart';
import 'package:simplify/model/grade_tracker/course.dart';
import 'package:simplify/model/grade_tracker/factorContent.dart';
import 'package:simplify/model/grade_tracker/gradeFactor.dart';
import 'package:simplify/model/grade_tracker/item.dart';

class CourseScreenPage extends StatefulWidget {
  final Course courseInfo;
  const CourseScreenPage({Key? key, required this.courseInfo})
      : super(key: key);
  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreenPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyContent = GlobalKey<FormState>();
  bool isLoading = false;

//GradeFactor
  double sumAllGrade = 0;
  String? factorName;
  String? factorPercentage;

//FactorContent
  String? contentName;
  String contentTotal = '0';
  String contentScore = '0';

  double sumTotal = 0.0;
  double sumScore = 0.0;

  double totalPercentage = 0.0;
  bool isLongPressedFactor = false;
  bool isLongPressedContent = false;

  static late List<Factor> gradeFactor;
  late List<Item> contentList;
  List<Content>? factorContent;

  int? currentIndex;

  @override
  void initState() {
    refreshState();
    super.initState();
  }

  Future sumFactorGrade() async {
    sumAllGrade = 0;
    for (int x = 0; x < gradeFactor.length; x++) {
      sumAllGrade += (gradeFactor[x].factorGrade *
          (gradeFactor[x].factorPercentage / 100));
    }
    final Course updateCourseGrade = Course(
        id: widget.courseInfo.id,
        courseName: widget.courseInfo.courseName,
        courseGrade: sumAllGrade);
    await DatabaseHelper.instance.updateCourse(updateCourseGrade);
  }

  Future refreshState() async {
    setState(() {
      isLoading = true;
    });
    gradeFactor =
        await DatabaseHelper.instance.readCourse(widget.courseInfo.id!);
    sumFactorGrade();
    setState(() {
      isLoading = false;
      totalPercentage = 0.0;
    });
    for (int x = 0; x < gradeFactor.length; x++) {
      totalPercentage += gradeFactor[x].factorPercentage;
    }
    contentList = generateContent(gradeFactor.length);
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
              actions: [buildRemarksLegend()],
              backgroundColor: Colors.indigo.shade800,
              elevation: 0.0,
              title: Text(widget.courseInfo.courseName)),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    child: contentList.isEmpty
                        ? Column(
                            children: [
                              // Center(
                              //     child: Text(
                              //       'No Grade Factors',
                              //       style: TextStyle(fontSize: 20),
                              //     ),
                              //   ),
                              GestureDetector(
                                onTap: () {
                                  showDialogFunction(null);
                                },
                                child: Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: ListTile(
                                      title: Center(
                                          child: Text('Add Elements',
                                              style: TextStyle(
                                                  color: Colors.blue)))),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 10,
                                    offset: Offset(0, 4)),
                              ],
                            ),
                            child: Column(
                              children: [
                                buildListPanel(),
                                SizedBox(height: 1),
                                GestureDetector(
                                  onTap: () {
                                    showDialogFunction(null);
                                  },
                                  child: Container(
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: ListTile(
                                        title: Center(
                                            child: Text('Add elements',
                                                style: TextStyle(
                                                    color: Colors.blue)))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                )),
    );
  }

  showDialogFunction(Factor? fromFactorList) {
    if (fromFactorList != null) {
      setState(() {
        factorPercentage = fromFactorList.factorPercentage.toString();
      });
    }
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Padding(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.courseInfo.courseName,
                          style: TextStyle(fontSize: 24)),
                      Text(
                        fromFactorList == null
                            ? "Enter your grade factor here"
                            : "Edit Grade Factor",
                        style: TextStyle(fontSize: 16),
                      ),
                    ]),
              ),
              titlePadding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 0.0),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      validator: (value) => value != null && value.isEmpty
                          ? 'Required Factor element'
                          : null,
                      initialValue: fromFactorList == null
                          ? null
                          : fromFactorList.factorName,
                      autofocus: true,
                      decoration: InputDecoration(hintText: "Element name"),
                      onChanged: (value) {
                        setState(() {
                          factorName = value;
                        });
                      },
                    ),
                    TextFormField(
                      // ignore: unnecessary_null_comparison
                      validator: (value) => value != null && value.isEmpty
                          ? 'Required Percentage'
                          : double.parse(factorPercentage!) >
                                  (100.0 - totalPercentage)
                              ? 'Total Percentage is over 100%, try less than ' +
                                  (100.0 - totalPercentage).toString() +
                                  '%'
                              : null,
                      initialValue: fromFactorList == null
                          ? null
                          : fromFactorList.factorPercentage.toString(),
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          errorMaxLines: 2, hintText: "Element percentage"),
                      onChanged: (value) {
                        setState(() {
                          factorPercentage = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: fromFactorList == null
                        ? () async {
                            if (_formKey.currentState!.validate()) {
                              final Factor factorCreate = Factor(
                                  factorName: factorName!,
                                  factorPercentage:
                                      double.parse(factorPercentage!),
                                  factorGrade: 0.0,
                                  fkCourse: widget.courseInfo.id!);
                              DatabaseHelper.instance
                                  .createFactor(factorCreate);
                              Navigator.pop(context);
                              refreshState();
                            }
                          }
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final Factor factorUpdate = Factor(
                                  factorName: factorName!,
                                  factorPercentage:
                                      double.parse(factorPercentage!),
                                  factorGrade: fromFactorList.factorGrade,
                                  fkCourse: widget.courseInfo.id!,
                                  id: fromFactorList.id);
                              DatabaseHelper.instance
                                  .updateFactor(factorUpdate);
                              Navigator.pop(context);
                              refreshState();
                            }
                          },
                    child: Text('Confirm'))
              ],
            ));
  }
//from gradeFactor => contentList add isExpandedParameter

  List<Item> generateContent(int factorLength) {
    Item defaultItem = Item(
        factorGrade: 0.0,
        factorName: 'default',
        factorPercentage: 0.0,
        fkCourse: 0,
        isExpanded: false,
        id: 0);
    List<Item> contentList =
        List.generate(factorLength, (index) => defaultItem);

    for (int x = 0; x < factorLength; x++) {
      contentList[x] = Item(
          isExpanded: false,
          id: gradeFactor[x].id,
          factorGrade: gradeFactor[x].factorGrade,
          factorPercentage: gradeFactor[x].factorPercentage,
          factorName: gradeFactor[x].factorName,
          fkCourse: gradeFactor[x].fkCourse);
      print(contentList[x].id);
    }
    return contentList;
  }

  Widget buildListPanel() {
    bool isLoading = false;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black45, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: ExpansionPanelList(
          elevation: 0.0,
          dividerColor: Colors.black54,
          expansionCallback: (int index1, bool isExpanded) async {
            setState(() {
              isLoading = true;
              sumTotal = 0.0;
              sumScore = 0.0;
            });
            factorContent = await DatabaseHelper.instance
                .readContent(contentList[index1].id!);
            for (int x = 0; x < contentList.length; x++) {
              contentList[x].isExpanded = false;
            }
            setState(() {
              currentIndex = index1;
              isLoading = false;
              isLongPressedContent = false;
              contentList[index1].isExpanded = !isExpanded;
            });
          },
          children: contentList
              .map((Item item) => new ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          isLongPressedFactor = false;
                        });
                      },
                      onLongPress: () {
                        if (isLongPressedFactor) {
                          setState(() {
                            isLongPressedFactor = false;
                          });
                        } else {
                          setState(() {
                            isLongPressedFactor = true;
                          });
                        }
                      },
                      child: Container(
                        child: ListTile(
                          title: Text(item.factorName),
                          leading: isLongPressedFactor
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          showDialogFunction(gradeFactor
                                              .firstWhere((element) =>
                                                  element.id == item.id));
                                        },
                                        icon: Icon(Icons.edit)),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Delete ' +
                                                    item.factorName +
                                                    ' from list?'),
                                                actions: [
                                                  TextButton(
                                                    child: Text("Cancel"),
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text("OK"),
                                                    onPressed: () {
                                                      DatabaseHelper.instance
                                                          .deleteFactor(
                                                              item.id!);
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                      setState(() {
                                                        isLongPressedFactor =
                                                            false;
                                                      });
                                                      refreshState();
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      icon: Icon(Icons.delete),
                                    )
                                  ],
                                )
                              : Text(item.factorPercentage.toStringAsFixed(0) +
                                  '%'),
                        ),
                      ),
                    );
                  },
                  body: !item.isExpanded
                      ? Container()
                      : isLoading
                          ? Center(child: CircularProgressIndicator())
                          : factorContent!.isEmpty
                              ? Column(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            contentName = item.factorName +
                                                ' ' +
                                                (factorContent!.length + 1)
                                                    .toString();
                                          });

                                          showDialogContent(item, null);
                                        },
                                        child: Text('Add ' + item.factorName))
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "Overall Grade",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                                height: 40,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    color: Colors.blue[800]),
                                                child: Center(
                                                  child: Text(
                                                    (item.factorGrade
                                                            .toStringAsFixed(
                                                                2) +
                                                        "%"),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              item.factorName + " Grade",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                                height: 40,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    color: Colors.blue[800]),
                                                child: Center(
                                                  child: Text(
                                                    ((item.factorGrade *
                                                                (item.factorPercentage /
                                                                    100))
                                                            .toStringAsFixed(
                                                                2) +
                                                        "%"),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "Remarks",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                                height: 40,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    color: Colors.blue[800]),
                                                child: Center(
                                                  child: Text(
                                                    generateRemarks(
                                                        item.factorGrade),
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: factorContent!.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isLongPressedContent = false;
                                              });
                                            },
                                            onLongPress: () {
                                              if (isLongPressedContent) {
                                                setState(() {
                                                  isLongPressedContent = false;
                                                });
                                              } else {
                                                setState(() {
                                                  isLongPressedContent = true;
                                                });
                                              }
                                            },
                                            child: ListTile(
                                                trailing: !isLongPressedContent
                                                    ? Text(factorContent![index]
                                                            .contentScore
                                                            .toStringAsFixed(
                                                                0) +
                                                        '/' +
                                                        factorContent![index]
                                                            .contentTotal
                                                            .toStringAsFixed(0))
                                                    : Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                showDialogContent(
                                                                    item,
                                                                    factorContent![
                                                                        index]);
                                                              },
                                                              icon: Icon(
                                                                  Icons.edit)),
                                                          IconButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: Text('Delete ' +
                                                                          factorContent![index]
                                                                              .contentName +
                                                                          ' from list?'),
                                                                      actions: [
                                                                        TextButton(
                                                                          child:
                                                                              Text("Cancel"),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context, rootNavigator: true).pop();
                                                                          },
                                                                        ),
                                                                        TextButton(
                                                                          child:
                                                                              Text("OK"),
                                                                          onPressed:
                                                                              () {
                                                                            DatabaseHelper.instance.deleteContent(factorContent![index].id!);
                                                                            setState(() {
                                                                              factorContent!.remove(factorContent![index]);
                                                                            });
                                                                            // ignore: unnecessary_null_comparison
                                                                            if (factorContent!.length !=
                                                                                null) {
                                                                              for (int x = 0; x < factorContent!.length; x++) {
                                                                                sumTotal += factorContent![x].contentTotal;
                                                                                sumScore += factorContent![x].contentScore;
                                                                              }
                                                                              double factorGradeUpdate = (sumScore / sumTotal) * 100;
                                                                              print('factorrrrr' + factorGradeUpdate.toString());
                                                                              if (factorGradeUpdate.isNaN) {
                                                                                factorGradeUpdate = 0.0;
                                                                              }
                                                                              final factorUpdate = Factor(factorGrade: factorGradeUpdate, factorName: item.factorName, factorPercentage: item.factorPercentage, fkCourse: item.fkCourse, id: item.id);
                                                                              DatabaseHelper.instance.updateFactor(factorUpdate);
                                                                            }
                                                                            refreshState();
                                                                            Navigator.of(context, rootNavigator: true).pop();
                                                                            setState(() {
                                                                              isLongPressedFactor = false;
                                                                            });
                                                                          },
                                                                        )
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            icon: Icon(
                                                                Icons.delete),
                                                          )
                                                        ],
                                                      ),
                                                title: Row(
                                                  children: [
                                                    Icon(Icons
                                                        .library_books_outlined),
                                                    Text(" " +
                                                        factorContent![index]
                                                            .contentName),
                                                  ],
                                                )),
                                          );
                                        }),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            contentName = item.factorName +
                                                ' ' +
                                                (factorContent!.length + 1)
                                                    .toString();
                                          });
                                          showDialogContent(item, null);
                                        },
                                        child: Text('Add ' + item.factorName))
                                  ],
                                ),
                  isExpanded: item.isExpanded))
              .toList()),
    );
  }

//add content
  showDialogContent(Item? fromFactorList, Content? editContent) {
    if (editContent != null) {
      contentName = editContent.contentName;
      contentTotal = editContent.contentTotal.toString();
      contentScore = editContent.contentScore.toString();
    } else {
      contentTotal = '0';
      contentScore = '0';
    }
    showDialog(
        context: context,
        builder: (BuildContext context) => Container(
              child: Form(
                key: _formKeyContent,
                child: AlertDialog(
                    title: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add ' + fromFactorList!.factorName,
                                style: TextStyle(fontSize: 24)),
                            Text(
                              "Enter Score Here",
                              style: TextStyle(fontSize: 16),
                            ),
                          ]),
                    ),
                    titlePadding: EdgeInsets.all(8.0),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: TextFormField(
                          validator: (value) => value != null && value.isEmpty
                              ? 'Required Content Name'
                              : null,
                          initialValue: contentName,
                          autofocus: true,
                          decoration:
                              InputDecoration(hintText: "Content Title"),
                          onChanged: (value) {
                            setState(() {
                              contentName = value;
                            });
                          },
                        ),
                      ),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Score ',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: TextFormField(
                                validator: (value) =>
                                    value != null && value.isEmpty
                                        ? 'Required Score'
                                        : double.parse(contentScore) >
                                                double.parse(contentTotal)
                                            ? 'invalid Score'
                                            : double.parse(contentScore) < 0
                                                ? 'Negative Number'
                                                : null,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                initialValue: contentScore,
                                autofocus: true,
                                decoration: InputDecoration(hintText: "Score"),
                                onChanged: (value) {
                                  setState(() {
                                    contentScore = value;
                                  });
                                },
                              ),
                            ),
                            Flexible(flex: 1, child: Text('/')),
                            Flexible(
                              flex: 4,
                              child: TextFormField(
                                validator: (value) =>
                                    value != null && value.isEmpty
                                        ? 'Required Score'
                                        : double.parse(contentTotal) <
                                                double.parse(contentScore)
                                            ? 'invalid Total'
                                            : double.parse(contentTotal) <= 0
                                                ? 'invalid Total'
                                                : null,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                initialValue: contentTotal,
                                autofocus: true,
                                decoration: InputDecoration(hintText: "Total"),
                                onChanged: (value) {
                                  setState(() {
                                    contentTotal = value;
                                  });
                                },
                              ),
                            ),
                          ]),
                    ]),
                    actions: [
                      ElevatedButton(
                          onPressed: editContent == null
                              ? () async {
                                  if (_formKeyContent.currentState!
                                      .validate()) {
                                    //create content
                                    final Content content = Content(
                                        contentName: contentName!,
                                        contentDate: DateTime.now(),
                                        contentTotal:
                                            double.parse(contentTotal),
                                        contentScore:
                                            double.parse(contentScore),
                                        fkContent: fromFactorList.id!);
                                    DatabaseHelper.instance
                                        .createContent(content);
                                    setState(() {
                                      factorContent!.add(content);
                                    });
                                    for (int x = 0;
                                        x < factorContent!.length;
                                        x++) {
                                      sumTotal +=
                                          factorContent![x].contentTotal;
                                      sumScore +=
                                          factorContent![x].contentScore;
                                    }
                                    double factorGradeUpdate =
                                        (sumScore / sumTotal) * 100;
                                    final factorUpdate =
                                        fromFactorList.returnID(
                                            factorGrade: factorGradeUpdate);
                                    DatabaseHelper.instance
                                        .updateFactor(factorUpdate);
                                    print(factorGradeUpdate);
                                    setState(() {
                                      factorGradeUpdate = 0;
                                    });
                                    refreshState();
                                    Navigator.pop(context);
                                  }
                                }
                              : () async {
                                  if (_formKeyContent.currentState!
                                      .validate()) {
                                    final Content contentUpdate = Content(
                                        contentName: contentName!,
                                        contentDate: DateTime.now(),
                                        contentTotal:
                                            double.parse(contentTotal),
                                        contentScore:
                                            double.parse(contentScore),
                                        fkContent: fromFactorList.id!,
                                        id: editContent.id);
                                    DatabaseHelper.instance
                                        .updateContent(contentUpdate);

                                    for (int x = 0;
                                        x < factorContent!.length;
                                        x++) {
                                      if (factorContent![x].id !=
                                          editContent.id!) {
                                        sumTotal +=
                                            factorContent![x].contentTotal;
                                        sumScore +=
                                            factorContent![x].contentScore;
                                      }
                                    }
                                    sumTotal += double.parse(contentTotal);
                                    sumScore += double.parse(contentScore);

                                    double factorGradeUpdate =
                                        (sumScore / sumTotal) * 100;
                                    final factorUpdate =
                                        fromFactorList.returnID(
                                            factorGrade: factorGradeUpdate);
                                    DatabaseHelper.instance
                                        .updateFactor(factorUpdate);
                                    refreshState();
                                    Navigator.pop(context);
                                  }
                                },
                          child: Text('Confirm'))
                    ]),
              ),
            ));
  }

  Widget buildRemarksLegend() => IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text("Remarks: "),
                    content: Container(
                      height: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                TextSpan(text: "Grade\t\t\t\t\t\t\t\t\t\t"),
                                TextSpan(text: "\t\t\t\t\t\t\t\t\tRemarks")
                              ])),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text("97.00 - 100.00"),
                              SizedBox(width: 63),
                              Text(" A")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("94.00 - 96.99"),
                              SizedBox(width: 70),
                              Text("A-")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("91.00 - 93.99"),
                              SizedBox(width: 75),
                              Text("B+")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("88.00 - 90.99"),
                              SizedBox(width: 72),
                              Text("B")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("85.00 - 87.99"),
                              SizedBox(width: 73),
                              Text("B-")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("82.00 - 84.99"),
                              SizedBox(width: 73),
                              Text("C+")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("80.00 - 81.99"),
                              SizedBox(width: 77),
                              Text("C")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("78.00 - 79.99"),
                              SizedBox(width: 75),
                              Text("C-")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("75.00 - 77.99"),
                              SizedBox(width: 75),
                              Text("D+")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("70.00 - 74.99"),
                              SizedBox(width: 75),
                              Text("D")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("0.00 - 69.99"),
                              SizedBox(width: 82),
                              Text("F")
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(
                                context,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ));
        },
        icon: Icon(Icons.info_outline_rounded, color: Colors.white),
        iconSize: 24,
      );

  generateRemarks(double grade) {
    late String remarks;
    if (grade >= 97) {
      remarks = "A";
    } else if (grade >= 94 && grade < 97) {
      remarks = "A-";
    } else if (grade >= 91 && grade < 94) {
      remarks = "B+";
    } else if (grade >= 88 && grade < 91) {
      remarks = "B";
    } else if (grade >= 85 && grade < 88) {
      remarks = "B-";
    } else if (grade >= 82 && grade < 85) {
      remarks = "C+";
    } else if (grade >= 80 && grade < 82) {
      remarks = "C";
    } else if (grade >= 78 && grade < 80) {
      remarks = "C-";
    } else if (grade >= 75 && grade < 78) {
      remarks = "D+";
    } else if (grade >= 70 && grade < 75) {
      remarks = "D";
    } else if (grade > 0 && grade < 70) {
      remarks = "F";
    } else if (grade == 0.0) {
      remarks = "N/A";
    }
    return remarks;
  }
}
