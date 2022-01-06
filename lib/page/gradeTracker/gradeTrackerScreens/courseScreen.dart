import 'package:flutter/material.dart';
import 'package:simplify/db_helper/database_helper.dart';
import 'package:simplify/model/grade_tracker/course.dart';
import 'package:simplify/model/grade_tracker/factorContent.dart';
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
  bool isLoading = false;
  String? factorName;
  String? factorPercentage;
  String? ContentName;
  double totalPercentage = 0.0;
  bool isLongPressed = false;

  late List<Factor> gradeFactor;
  late List<Item> contentList;

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
      print(gradeFactor[x].id);
    }
    print(totalPercentage);

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
                        : buildListPanel()
                      // : ListView.builder(
                      //     itemCount: gradeFactor.length,
                      //     itemBuilder: (context, index) {
                      //       return GestureDetector(
                      //         onTap: isLongPressed?
                      //         ()async{
                      //           setState(() {
                      //               isLongPressed = false;
                      //             });
                      //         }
                      //         : () async {
                      //           await Navigator.of(context).push(
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       CourseFactorScreen()));
                      //         },
                      //        onLongPress: () async {
                      //           // DatabaseHelper.instance.deleteCourse(courseList[index].id!);
                      //           if(isLongPressed){
                      //             setState(() {
                      //               isLongPressed = false;
                      //             });
                      //           }else{
                      //             setState(() {
                      //               isLongPressed = true;
                      //             });                                
                      //           }
                      //           refreshState();
                      //         },
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8),
                      //           child: Container(
                      //             height: 70,
                      //             decoration: BoxDecoration(
                      //               color: Colors.amber.shade300,
                      //               borderRadius: BorderRadius.circular(15),
                      //               boxShadow: [
                      //                 BoxShadow(
                      //                     color: Colors.black26,
                      //                     blurRadius: 2,
                      //                     offset: Offset(0, 4)),
                      //               ],
                      //             ),
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(8),
                      //               child: SingleChildScrollView(
                      //                 child: buildListPanel())
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     })),
              ),
            )
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


//from gradeFactor => contentList add isExpandedParameter

List<Item> generateContent(int factorLength){
Item defaultItem = Item(factorGrade: 0.0, factorName: 'default', factorPercentage: 0.0, fkCourse: 0, isExpanded: false, id: 0);
List<Item> contentList = List.generate(factorLength, (index) => defaultItem);

  for(int x = 0; x < factorLength; x++){
    contentList[x] = Item(
      isExpanded: false,
      id: gradeFactor[x].id,
      factorGrade: gradeFactor[x].factorGrade,
      factorPercentage: gradeFactor[x].factorPercentage,
      factorName: gradeFactor[x].factorName,
      fkCourse: gradeFactor[x].fkCourse
      );
    print(contentList[x].id);
  }
  return contentList;
}

Widget buildListPanel(){
  List<Content>? factorContent;
  bool isLoading = false;
  return ExpansionPanelList(
      expansionCallback: (int index1, bool isExpanded) async {
            setState(() {
              isLoading = true;
            });
            factorContent = await DatabaseHelper.instance.readContent(2);
            setState(() {
              isLoading = false;
              contentList[index1].isExpanded = !isExpanded;
            });
          },
          children: contentList.map((Item item) => 
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded){
              return ListTile(
                title: Text(item.factorName),
              );
            },
            body: !item.isExpanded? 
            Text('No Content')
            :isLoading?
            Center(child: CircularProgressIndicator())
            :factorContent == null?
            Column(
              children: [
                Text('No '+ item.factorName+ ' Content'),
                TextButton(onPressed: (){
                  showDialogContent();
                }, 
                child: Text('Add Content'))
              ],
            )
            :Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                            itemCount: factorContent!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text('Content '+index.toString())
                              );
                            }),
                TextButton(onPressed: (){
                  showDialogContent();
                }, 
                child: Text('Add Content'))
              ],
            ),
            isExpanded: item.isExpanded
          )).toList()
        );
}
//add content
showDialogContent(){
  showDialog(
    context: context,
    builder: (BuildContext context) => Container(
          child: AlertDialog(
              title: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text("Factor name",
                          style: TextStyle(fontSize: 24)),
                      Text(
                        "Enter your grades here",
                        style: TextStyle(fontSize: 16),
                      ),
                    ]),
              ),
              titlePadding: EdgeInsets.all(8.0),
              actions: [
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: "Factor Title"),
                    onChanged: (value) {
                      setState(() {
                        ContentName = value;
                      });
                    },
                  ),
                ),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Score ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Text('30 out of 30'),
                ]),
                ElevatedButton(
                    onPressed: () async {
                      final Content content = Content(
                        contentName: ContentName!,
                        contentDate: DateTime.now(),
                        contentTotal: 50,
                        contentScore: 50,
                        fkContent: 2
                      );
                      DatabaseHelper.instance.createContent(content);
                      Navigator.pop(context);
                      refreshState();
                    },
                    child: Text('Confirm'))
              ]),
        ));
}

}
class Item extends Factor{
 bool isExpanded;
 
 Item({required this.isExpanded,
 required id,
 required factorName,
 required factorGrade,
 required factorPercentage,
 required fkCourse
 }):
 super(
   id: id,
   factorName: factorName,
   factorPercentage: factorPercentage,
   factorGrade: factorGrade,
   fkCourse: fkCourse);
}