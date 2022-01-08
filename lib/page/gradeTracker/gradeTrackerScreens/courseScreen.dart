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

Future refreshState() async {
setState(() {
isLoading = true;
});
gradeFactor = await DatabaseHelper.instance.readCourse(widget.courseInfo.id!);
setState(() {
isLoading = false;
totalPercentage = 0.0;
});
for (int x = 0; x < gradeFactor.length; x++) {
totalPercentage += gradeFactor[x].factorPercentage;
}
contentList = generateContent(gradeFactor.length);
}

Future refreshGrade() async {
setState(() {
isLoading = true;
});
gradeFactor =
await DatabaseHelper.instance.readCourse(widget.courseInfo.id!);
setState(() {
isLoading = false;
totalPercentage = 0.0;
});
for (int x = 0; x < gradeFactor.length; x++) {
totalPercentage += gradeFactor[x].factorPercentage;
print(gradeFactor[x].id);
}
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
  showDialogFunction(null);
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
: SingleChildScrollView(
child: Container(
  child: contentList.isEmpty
      ? Center(
          child: Text(
            'No Grade Factors',
            style: TextStyle(fontSize: 20),
          ),
        )
      : buildListPanel()),
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
      ? 'Required Factor Name'
      : null,
  initialValue: fromFactorList == null
      ? null
      : fromFactorList.factorName,
  autofocus: true,
  decoration: InputDecoration(hintText: "Factor name"),
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
              (100.0 - double.parse(factorPercentage!))
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
      errorMaxLines: 2, hintText: "Factor percentage"),
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
          DatabaseHelper.instance.updateFactor(factorUpdate);
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
// if (currentIndex != null) {
// setState(() {
// contentList[currentIndex!] = Item(
// isExpanded: true,
// id: gradeFactor[currentIndex!].id,
// factorGrade: gradeFactor[currentIndex!].factorGrade,
// factorPercentage: gradeFactor[currentIndex!].factorPercentage,
// factorName: gradeFactor[currentIndex!].factorName,
// fkCourse: gradeFactor[currentIndex!].fkCourse);      
// });
// }
return contentList;
}

Widget buildListPanel() {
bool isLoading = false;
return ExpansionPanelList(
expansionCallback: (int index1, bool isExpanded) async {
setState(() {
isLoading = true;
sumTotal = 0.0;
sumScore = 0.0;
});
factorContent = await DatabaseHelper.instance .readContent(contentList[index1].id!);
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
                    showDialogFunction(
                        gradeFactor.firstWhere((element) =>
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
                                        rootNavigator: true)
                                    .pop();
                              },
                            ),
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                DatabaseHelper.instance
                                    .deleteFactor(item.id!);
                                Navigator.of(context,
                                        rootNavigator: true)
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
        : Text(item.factorPercentage.toStringAsFixed(0)+'%'),
  ),
),
);
},
body: !item.isExpanded
? Container()
: isLoading
    ? Center(child: CircularProgressIndicator())
    : factorContent == null
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
                    print(contentName);
                    showDialogContent(item, null);
                  },
                  child: Text('Add Content'))
            ],
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: (){}, child: Text(item.factorGrade.toStringAsFixed(2))),
                  ElevatedButton(onPressed: (){}, child: Text('B'))
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
                                      .toString() +
                                  '/' +
                                  factorContent![index]
                                      .contentTotal
                                      .toString())
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
                                                    child: Text(
                                                        "Cancel"),
                                                    onPressed:
                                                        () {
                                                      Navigator.of(context, rootNavigator: true)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                        "OK"),
                                                    onPressed:
                                                        () {
                                                      DatabaseHelper.instance.deleteContent(factorContent![index].id!);
                                                      setState(() {
                                                        factorContent!.remove(factorContent![index]);
                                                      });
                                                      // ignore: unnecessary_null_comparison
                                                      if(factorContent!.length != null){
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
                print('factorrrrr'+factorGradeUpdate.toString());
                if(factorGradeUpdate.isNaN){
                  factorGradeUpdate = 0.0;
                }
                final factorUpdate = Factor(
                  factorGrade: factorGradeUpdate,
                  factorName: item.factorName,
                  factorPercentage: item.factorPercentage,
                  fkCourse: item.fkCourse,
                  id: item.id
                );
                DatabaseHelper.instance.updateFactor(factorUpdate);
                                                      }
                refreshState();
                                                      Navigator.of(context, rootNavigator: true)
                                                          .pop();
                                                      setState(
                                                          () {
                                                        isLongPressedFactor =
                                                            false;
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
                          title: Text(factorContent![index]
                              .contentName)),
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
                  child: Text('Add Content'))
            ],
          ),
isExpanded: item.isExpanded))
.toList());
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
              style: TextStyle(fontSize: 20),
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
                    contentTotal:double.parse(contentTotal),
                    contentScore:double.parse(contentScore),
                    fkContent: fromFactorList.id!,
                    id: editContent.id);
                DatabaseHelper.instance.updateContent(contentUpdate);

                for (int x = 0; x < factorContent!.length; x++) {
                  if(factorContent![x].id != editContent.id!){
                  sumTotal +=factorContent![x].contentTotal;
                  sumScore += factorContent![x].contentScore;
                  }
                }
                sumTotal+=double.parse(contentTotal);
                sumScore+=double.parse(contentScore);

                double factorGradeUpdate = (sumScore / sumTotal) * 100;
                final factorUpdate = fromFactorList.returnID(
                factorGrade: factorGradeUpdate);
                DatabaseHelper.instance.updateFactor(factorUpdate);
                refreshState();
                Navigator.pop(context);
              }
            },
      child: Text('Confirm'))
]),
),
));
}
}
