import 'package:flutter/material.dart';
import 'package:simplify/page/gradeTracker/gradeTrackerScreens/courseFactorScreen.dart';

class CourseScreenPage extends StatefulWidget {
  const CourseScreenPage({Key? key}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreenPage> {
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
                  onPressed: () async {}, child: Text('Add Category'))
            ],
            backgroundColor: Colors.indigo.shade800,
            elevation: 0.0,
            title: Text('Course #1')),
        body: Container(
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CourseFactorScreen()));
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
                                    'Assignment',
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
                              "Grade: 81%",
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
