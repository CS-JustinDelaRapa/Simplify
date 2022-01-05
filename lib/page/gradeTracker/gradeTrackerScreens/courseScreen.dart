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
  final _formKey = GlobalKey<FormState>();
  late List<Factor> gradeFactor;
  bool isLoading = false;
  String? factorName;
  String? factorPercentage;
  double totalPercentage = 0.0;
  bool isLongPressed = false;

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
      totalPercentage = 0.0;
    });
    for(int x = 0; x<gradeFactor.length; x++){
      totalPercentage+=gradeFactor[x].factorPercentage;
    }
    print(totalPercentage);
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
                            onTap: isLongPressed?
                            ()async{
                              setState(() {
                                  isLongPressed = false;
                                });
                            }
                            : () async {
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CourseFactorScreen()));
                            },
                           onLongPress: () async {
                              // DatabaseHelper.instance.deleteCourse(courseList[index].id!);
                              if(isLongPressed){
                                setState(() {
                                  isLongPressed = false;
                                });
                              }else{
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
                                    trailing: isLongPressed?
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: (){
                                            showDialogFunction(gradeFactor[index]);
                                          },
                                          icon: Icon(Icons.edit)),
                                        IconButton(
                                          onPressed: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete '+ gradeFactor[index].factorName+ ' from list?'),
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
                                DatabaseHelper.instance.deleteFactor(gradeFactor[index].id!);
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
                                          icon: Icon(Icons.delete)),
                                      ],
                                    )
                                    :Text(
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

showDialogFunction(Factor? fromFactorList) {
if(fromFactorList != null){
  setState(() {
    factorPercentage = fromFactorList.factorPercentage.toString();
  });
}

return showDialog(
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
                fromFactorList == null?
                "Enter your grade factor here"
                :"Edit Grade Factor",
                style: TextStyle(fontSize: 16),
              ),
            ]),
      ),
      titlePadding:
          EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 0.0),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              validator: (value) => value != null && value.isEmpty
              ? 'Required Factor Name'
              : null,
              initialValue: fromFactorList == null?
                  null
                  :fromFactorList.factorName,
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
              // ignore: unnecessary_null_comparison
              validator: (value) => value != null && value.isEmpty
              ? 'Required Percentage'
              : double.parse(factorPercentage!) > (100.0-double.parse(factorPercentage!))?
              'Total Percentage is over 100%, try less than ' + (100.0-totalPercentage).toString() +'%'
              :null,
              initialValue: fromFactorList == null?
              null
              :fromFactorList.factorPercentage.toString(),
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  errorMaxLines: 2,
                  hintText: "Factor percentage"),
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
            onPressed: fromFactorList == null?            
          () async {
          if(_formKey.currentState!.validate()){
          final Factor factorCreate = Factor(
          factorName: factorName!,
          factorPercentage: double.parse(factorPercentage!),
          factorGrade: 0.0,
          fkCourse: widget.courseInfo.id!
          );
          DatabaseHelper.instance.createFactor(factorCreate);
          Navigator.pop(context);
          refreshState();
          }
            }
          :() async {
          if(_formKey.currentState!.validate()){
          final Factor factorUpdate = Factor(
          factorName: factorName!,
          factorPercentage: double.parse(factorPercentage!),
          factorGrade: fromFactorList.factorGrade,
          fkCourse: widget.courseInfo.id!,
          id: fromFactorList.id
          );
          DatabaseHelper.instance.updateFactor(factorUpdate);
          Navigator.pop(context);
          refreshState();
          }
            },
            child: Text('Confirm'))
      ],
    ));
}
}
