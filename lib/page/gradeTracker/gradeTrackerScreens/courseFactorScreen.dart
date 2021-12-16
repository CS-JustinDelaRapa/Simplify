import 'package:flutter/material.dart';

class CourseFactorScreen extends StatefulWidget {
  const CourseFactorScreen({Key? key}) : super(key: key);

  @override
  _CourseFactorScreenState createState() => _CourseFactorScreenState();
}

class _CourseFactorScreenState extends State<CourseFactorScreen> {
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
                      builder: (BuildContext context) => Container(
                            width: 1000,
                            height: 1000,
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
                                        setState(() {});
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

                                    // TextFormField(
                                    //   autofocus: true,
                                    //   decoration: InputDecoration(
                                    //       hintText: "Factor Title"),
                                    //   onChanged: (value) {
                                    //     setState(() {});
                                    //   },
                                    // )
                                  ]),
                                  ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Confirm'))
                                ]),
                          ));
                },
                child: Text('Add'))
          ],
          backgroundColor: Colors.indigo.shade800,
          elevation: 0.0,
          title: Text('Category name',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
        ),
        body: Container(),
      ),
    );
  }
}
