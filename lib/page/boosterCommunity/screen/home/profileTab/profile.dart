import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/screen/home/changeUserIcon/changeUserIcon.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';
// import 'package:simplify/page/boosterCommunity/model/myuser.dart';
// import 'package:simplify/page/boosterCommunity/screen/home/changeUserIcon/changeUserIcon.dart';
// import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin{
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;

  @override
  void initState() {
    userId = _auth.currentUser!.uid.toString();
    super.initState();
  }

  Future refreshState() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
              future: userCollection.doc(userId).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 2)),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                GestureDetector(
                                  child: Container(
                                        height: 60,
                                        width: 60,
                                        child: Image.asset(
                                            'assets/images/${data['userIcon']}')),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => ChangeUserIcon(uid: data['uid'], userIcon: data['userIcon']) ,
                                          barrierDismissible: true,
                                        ).then((value) => refreshState()) ;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${data['first-name']} ${data['last-name']}',
                                    textAlign: TextAlign.left,
                                  ),
                                  Text('${data['school']}'),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              }),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ElevatedButton(
              onPressed: (){
                AuthService().signOut();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
