import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplify/page/boosterCommunity/screen/home/comment/comment.dart';
import 'package:simplify/page/boosterCommunity/screen/home/homeTab/add_post_form.dart';
import 'package:simplify/page/boosterCommunity/screen/home/reportPost/reportPost.dart';
import 'package:simplify/page/boosterCommunity/service/convertTimeStamp.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

//thread Item
// ignore: must_be_immutable
class ThreadItem extends StatefulWidget {
  final DocumentSnapshot postInfo;
  final String userId;
  Map<String, dynamic>? myLikeList;
  ThreadItem({Key? key, this.myLikeList, required this.postInfo, required this.userId})
      : super(key: key);

  @override
  _ThreadItemState createState() => _ThreadItemState();
}

class _ThreadItemState extends State<ThreadItem> {
  
  bool loading = false;

  @override
  void initState() {
    print(widget.myLikeList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        try{
        FirebaseFirestore.instance.collection('threads').doc(widget.postInfo.id).update({"view-count": FieldValue.increment(1)});
        Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CommentSection(
                                    postInfo: widget.postInfo,
                                    postId: widget.postInfo.id,
                                    userId: widget.userId,
                                      )));
        } on FirebaseException catch (error) {
        Fluttertoast.showToast(msg: error.message.toString());
        }
      },
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
                ],
              ),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: 5),
                ListTile(
                  leading: Container(
                      height: 40,
                      width: 40,
                      child: Image.asset('assets/images/' +
                          widget.postInfo.get('publisher-UserIcon'))),
                  title: Text(
                      widget.postInfo.get('publisher-FirstName') +
                          ' ' +
                          widget.postInfo.get('publisher-LastName'),
                      style: TextStyle(fontSize: 14)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.postInfo.get('publisher-School'),
                          style: TextStyle(fontSize: 12)),
                      Text(
                          TimeManage.readTimestamp(
                              widget.postInfo.get('published-time')),
                          style: TextStyle(fontSize: 12))
                    ],
                  ),
                  trailing: widget.userId == widget.postInfo.get('publisher-Id')
                      ? PopupMenuButton<int>(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, left: 8.0),
                                    child: Icon(Icons.edit),
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
                                    padding: const EdgeInsets.only(
                                        right: 8.0, left: 8.0),
                                    child: Icon(Icons.delete_forever),
                                  ),
                                  Text("Delete"),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 2) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                        title: Text('Delete Post?'),
                                        content: Text(
                                            "By continuing this post will be deleted permanently."),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel')),
                                          TextButton(
                                              onPressed: () {
                                                AuthService().deletePost(
                                                    widget.postInfo.id, context);
                                              },
                                              child: Text('Continue'))
                                        ],
                                      ));
                            } else if (value == 1) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddPostForm(
                                        title: widget.postInfo['title'],
                                        description:
                                            widget.postInfo['description'],
                                        postUid: widget.postInfo.id,
                                        contextFromPopUp: context,
                                      )));
                            }
                          },
                        )
                      //when post is not from the current user
                      : PopupMenuButton<int>(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, left: 8.0),
                                    child: Icon(Icons.report),
                                  ),
                                  Text("Report"),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => ReportPost(
                                    userFirstName:
                                        widget.postInfo.get('publisher-FirstName'),
                                    userLastName:
                                        widget.postInfo.get('publisher-LastName'),
                                    publisherUID: widget
                                        .postInfo['publisher-Id'], //publisher id
                                    postID: widget.postInfo.id, //post id
                                    postTitle:
                                        widget.postInfo['title'], //post title
                                    postContent: widget
                                        .postInfo['description'], //post content
                                    reporterUID: widget.userId //current user id
                                    ));
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                      child: Text(widget.postInfo.get('title'),
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(widget.postInfo.get('description')),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //like button
                      // Row(
                      //   children: [
                      //     // upvote
                      //     GestureDetector(
                      //       onTap: (){
                      //         handleUpVote();
                      //       },
                      //       child: Wrap(
                      //         children: [
                      //         Icon(Icons.upload, color: 
                      //           widget.myLikeList != null && widget.myLikeList!.containsKey(widget.postInfo.id)
                      //           && widget.myLikeList!.containsValue(true)?
                      //         Colors.blue
                      //         : Colors.black 
                      //        ),
                      //       Text(' ${widget.postInfo['up-votes']}'),                              
                      //         ],
                      //       ),
                      //     ),
                      //     SizedBox(width: 5),
                      //   ],
                      // ),
                    Wrap(
                      children: [
                        Icon(Icons.remove_red_eye),                        
                        SizedBox(width: 5),          
                        Text(' ${widget.postInfo['comment-count']}'),              
                      ],
                    ),     
                      

                      //comment section
                      Wrap(
                      children: [
                        Text(' ${widget.postInfo['comment-count']}'),
                        SizedBox(width: 5),                        
                        Icon(Icons.comment_outlined),
                      ],
                    ),                     
                    ],
                  ),
                ),
              ]))),
    );
  }

//update UpVote
handleUpVote(){
      if (widget.myLikeList == null || !widget.myLikeList!.containsKey(widget.postInfo.id)){
      FirebaseFirestore.instance.collection("thread").doc(widget.postInfo.id).update({"up-votes": FieldValue.increment(1)});
      FirebaseFirestore.instance.collection("users").doc(widget.userId).collection('myLikeList').doc(widget.userId).update({widget.postInfo.id: true});     
      if(widget.myLikeList == null){
    setState(() {
      widget.myLikeList = {widget.postInfo.id:true};
    });
      } else{
      setState(() {
        widget.myLikeList!.addEntries([
        MapEntry(widget.postInfo.id,true)
      ]);
      });
      }
      } else if (widget.myLikeList != null || widget.myLikeList!.containsKey(widget.postInfo.id)){
      FirebaseFirestore.instance.collection("thread").doc(widget.postInfo.id).update({"up-votes": FieldValue.increment(-1)});
      FirebaseFirestore.instance.collection("users").doc(widget.userId).collection('myLikeList').doc(widget.userId).update({widget.postInfo.id: FieldValue.delete()});
      setState(() {
        widget.myLikeList!.remove(widget.postInfo.id);
      });
      }                     
}
}
