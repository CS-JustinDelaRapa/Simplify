import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/screen/home/homeTab/add_post_form.dart';
import 'package:simplify/page/boosterCommunity/screen/home/homeTab/threadItem.dart';

class UserFeed extends StatefulWidget {
  const UserFeed({Key? key}) : super(key: key);

  @override
  _UserFeedState createState() => _UserFeedState();
}

class _UserFeedState extends State<UserFeed> with AutomaticKeepAliveClientMixin{
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  //call the userLikeDocument  

  late String userId;
  late Timer timer;

  bool counting = true;
  bool futureDone = false;

  Map<String, dynamic>? myLikeList;

  @override
  void initState() {
    userId = _auth.currentUser!.uid;
    var likeListRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('myLikeList').doc(userId);
    super.initState(); 
    likeListRef.get().then((value) {
      myLikeList = value.data();
      futureDone = true;
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(futureDone == true){
        setState(() {
          counting = false;
        });
        timer.cancel();
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return counting? Center(child: CircularProgressIndicator(),)
    :Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('thread')
              .orderBy('published-time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            return Stack(
              children: <Widget>[
                snapshot.data!.docs.length > 0
                    ? ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot postInfo) {
                          return ThreadItem(postInfo: postInfo, userId: userId, myLikeList: myLikeList);
                        }).toList(),
                      )
                    : Container(
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.error,
                              color: Colors.grey[700],
                              size: 64,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                'There is no post',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[700]),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )),
                      ),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddPostForm()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.create),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
