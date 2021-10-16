import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

class Profile extends StatefulWidget {

  const Profile({ Key? key }) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
final FirebaseAuth _auth = FirebaseAuth.instance;
late String userId;

//comment

@override
  void initState() {
    userId = _auth.currentUser!.uid.toString();
    print('CEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEB ' + userId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: userCollection.doc(userId).get(),
        builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }          
        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }          
          if(snapshot.connectionState == ConnectionState.done){     
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              //user info
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
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 80,
                          width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Icon(Icons.person, size: 35)
                          )
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('${data['first-name']} ${data['last-name']}', textAlign: TextAlign.left,),
                          Text('${data['school']}'),                          
                        ],
                      )
                    ],
                  ),
                ),
              ),
              //signout button
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                      child: Text('Sign Out'),
                      onPressed: () {
                        AuthService().signOut();
                      },
                                ),
                    ),
                  ),
                ],
              ),
            ],
          );
                    }else{
                      return Center(child: CircularProgressIndicator());
                    }
        }
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}