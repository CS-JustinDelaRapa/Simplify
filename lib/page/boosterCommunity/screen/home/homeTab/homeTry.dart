import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/model/myuser.dart';
import 'package:simplify/page/boosterCommunity/screen/home/homeTab/add_post_form.dart';
import 'package:simplify/page/boosterCommunity/screen/home/reportPost/reportPost.dart';
import 'package:simplify/page/boosterCommunity/service/convertTimeStamp.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';
import 'package:rxdart/rxdart.dart';

class UserFeed extends StatefulWidget {
  const UserFeed({ Key? key }) : super(key: key);

  @override
  _UserFeedState createState() => _UserFeedState();
}

class _UserFeedState extends State<UserFeed> {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String firstName = '', lastName= '', school= '', userIcon= '';

  late String userId;

  @override
  void initState() {
    userId = _auth.currentUser!.uid;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('thread').orderBy('published-time', descending: true).snapshots(),
        builder: (context,snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return Stack(
            children:<Widget>[
              snapshot.data!.docs.length > 0 ?
              ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot postInfo){
                  // var publisherInfo = AuthService(publisherId: postInfo.get('publisher-Id')).publisherInfo;
                  // FirebaseFirestore.instance.collection('users').doc(postInfo['publisher-Id']).get().then((value) 
                  // {
                  //   // print(value.get('first-name'));
                  //   setState(() {
                  //   firstName = value.get('firstName');
                  //   lastName = value.get('last-name');
                  //   school = value.get('school');
                  //   userIcon = value.get('userIcon');                                                                                 
                  //   });
                  //   // print(firstName); 
                  // });
                  // print(publisherInfo);
                  return ThreadItem(postInfo: postInfo, firstName: firstName, lastName: lastName, school: school, userIcon: userIcon);
                }).toList(),
              ) 
              : Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.error,color: Colors.grey[700],
                        size: 64,),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text('There is no post',
                          style: TextStyle(fontSize: 16,color: Colors.grey[700]),
                          textAlign: TextAlign.center,),
                      ),
                    ],
                  )
                ),
              ),
              // Center(child: CircularProgressIndicator() ,)
            ],
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPostForm()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.create),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

//get firebase
// Future<void> getName(String publisherUid) async {
//   DocumentSnapshot ds = await FirebaseFirestore.instance.collection('users').doc(publisherUid).get();
//   setState(() {
//   firstName = ds.get('first-name');
//   lastName = ds.get('lastt-name');
//   school = ds.get('school');
//   userIcon = ds.get('userIcon');
//    });
// }

}


//thread Item
class ThreadItem extends StatefulWidget {
  final DocumentSnapshot postInfo;
  final String firstName, lastName, school, userIcon;
  const ThreadItem({ Key? key, required this.postInfo, required this.firstName, required this.lastName, required this.school, required this.userIcon}) : super(key: key);

  @override
  _ThreadItemState createState() => _ThreadItemState();
}

class _ThreadItemState extends State<ThreadItem> with AutomaticKeepAliveClientMixin{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // late var singleCall;

  bool loading = false;

  late String userId;

  // late String publisherFullName;
  // late String publisherSchool;
  // late String publisherUserIcon;

  String publisherFullName = 'Rasta Man';
  String publisherSchool = 'DHVSU';
  String publisherUserIcon = '001-panda.png';
  // late DocumentSnapshot publisherSnapshot;

    @override
  void initState() {
    userId = _auth.currentUser!.uid;
    // publisherFullName = widget.firstName + ' ' + widget.lastName;
    // publisherSchool = widget.school;
    // publisherUserIcon = widget.userIcon;
    //working single call DO NOT DELETE
    //---------------
    //FirebaseFirestore.instance.collection('users').doc(widget.postInfo['publisher-Id']).get().then((value) =>  print(value.get('first-name')!));
    //---------------
    getName(widget.postInfo['publisher-Id']);
    super.initState();
  }

  Future<void> getName(String publisherUid) async {
  DocumentSnapshot publisherSnapshot = await FirebaseFirestore.instance.collection('users').doc(publisherUid).get();
  print(publisherSnapshot.data());
}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return loading? Center(child: CircularProgressIndicator())  
    :Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 4,
                                                offset: Offset(2, 2)),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 5),
                                            ListTile(
                                              leading: Container(
                                                  height: 40,
                                                  width: 40,
                                                  child: Image.asset(
                                                      'assets/images/'+publisherUserIcon)),
                                              title: Text(publisherFullName,
                                                  style:
                                                      TextStyle(fontSize: 14)),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(publisherSchool ,style: TextStyle(fontSize: 12)),
                                                  Text(TimeManage.readTimestamp(widget.postInfo['published-time']) + ' ago' ,style: TextStyle(fontSize: 12))
                                                ],
                                              ),
                                              trailing: userId == widget.postInfo['publisher-Id']?
                                              PopupMenuButton<int>(
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    value: 1,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8.0,
                                                                  left: 8.0),
                                                          child: Icon(
                                                              Icons.edit),
                                                        ),
                                                        Text("Edit"),
                                                      ],
                                                    ),
                                                    
                                                  ),
                                                  PopupMenuItem(
                                                    value: 2,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8.0,
                                                                  left: 8.0),
                                                          child: Icon(
                                                              Icons.delete_forever),
                                                        ),
                                                        Text("Delete"),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                                onSelected: (value) {
                                                  if(value == 2){
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) => 
                                                      AlertDialog(
                                                        title: Text('Delete Post?'),
                                                        content: Text("By continuing this post will be deleted permanently." ),
                                                        actions: [
                                                          TextButton(onPressed: (){
                                                            Navigator.of(context).pop();
                                                          }, 
                                                          child: Text('Cancel')),
                                                          TextButton(onPressed: (){
                                                            AuthService().deletePost(widget.postInfo.id, context);
                                                          }, 
                                                          child: Text('Continue'))                                                          
                                                        ],
                                                      )
                                                      );
                                                  } else if (value == 1){
                                                    Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (context) => AddPostForm(
                                                    title: widget.postInfo['title'], description: widget.postInfo['description'], postUid: widget.postInfo.id, contextFromPopUp: context,)));
                                                  }
                                                },
                                              )

                                              //when post is not from the current user
                                              :PopupMenuButton<int>(
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    value: 1,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8.0,
                                                                  left: 8.0),
                                                          child: Icon(
                                                              Icons.report),
                                                        ),
                                                        Text("Report"),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                                onSelected: (value) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          ReportPost(
                                                              userFirstName:
                                                              publisherFullName,
                                                              userLastName:
                                                              publisherFullName,
                                                              publisherUID:
                                                                  widget.postInfo[
                                                                      'publisher-Id'], //publisher id
                                                              postID: widget.postInfo
                                                                  .id, //post id
                                                              postTitle: widget.postInfo[
                                                                  'title'], //post title
                                                              postContent: widget.postInfo[
                                                                  'description'], //post content
                                                              reporterUID:
                                                                  userId //current user id
                                                              ));
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 0, 8.0, 0),
                                              child: Divider(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          12, 8, 12, 0),
                                                  child: Text(
                                                      widget.postInfo.get('title'),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Text(widget.postInfo
                                                      .get('description')),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                                padding: EdgeInsets.all(12),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Wrap(
                                                      children: [
                                                    //upvote
                                                    Icon(Icons.upload),
                                                    Text(' ${widget.postInfo['up-votes']}'),
                                                    SizedBox(width: 5),

                                                    //downVote
                                                    Icon(Icons.download),
                                                    Text(' ${widget.postInfo['down-votes']}'),
                                                    ],),
                        
                                                    Wrap(
                                                      children: [
                                                    Icon(Icons.comment_outlined),
                                                    SizedBox(width: 5),                                                  
                                                    Text('0'),
                                                      ],),

                                                  ],
                                                  ),
                                              ),
                                          ]
                                        )
          )
    );
  }

  @override
  bool get wantKeepAlive => true;
}