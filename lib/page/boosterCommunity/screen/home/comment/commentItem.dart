import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplify/page/boosterCommunity/screen/home/reports/reportComment.dart';
import 'package:simplify/page/boosterCommunity/service/convertTimeStamp.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';
import '../../../../../algo/globals.dart' as globals;

// ignore: must_be_immutable
class CommentItem extends StatefulWidget {
  final DocumentSnapshot commentInfo;
  final String userId;
  final String postId;
  Map<String, dynamic>? myLikeList;
  // Map<String, dynamic>? myLikeList;
  CommentItem(
      {Key? key,
      required this.commentInfo,
      required this.userId,
      required this.postId,
      this.myLikeList})
      : super(key: key);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool loading = false;
  bool isEditingText = false;
  String editedText = '';

  @override
  void initState() {
    // print(widget.myLikeList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Container(
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //userIcon and like count
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 2),
                Container(
                    height: 35,
                    width: 35,
                    child: Image.asset('assets/images/' +
                        widget.commentInfo.get('commenter-icon'))),
                Transform.translate(
                  offset: Offset(0, -8),
                  child: IconButton(
                    onPressed: () {
                      handleUpVote();
                    },
                    icon: Icon(Icons.school_rounded,
                        size: 25,
                        color: widget.myLikeList != null &&
                                widget.myLikeList!
                                    .containsKey(widget.commentInfo.id) &&
                                widget.myLikeList!.containsValue(true)
                            ? Colors.blue
                            : Colors.black54),
                  ),
                ),
                Transform.translate(
                    offset: Offset(0, -15),
                    child:
                        Text(widget.commentInfo.get('like-count').toString()))
              ],
            ),
            Padding(padding: EdgeInsets.only(left: 10.0)),
            //comment info card box, commenter fullname, content, timestamp, popo up button
            Expanded(
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
                child: isEditingText
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextFormField(
                                autofocus: true,
                                initialValue:
                                    widget.commentInfo.get('commentContent'),
                                onChanged: (value) {
                                  editedText = value;
                                },
                              ),
                              Wrap(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          isEditingText = false;
                                          globals.isEditing = false;
                                        });
                                      },
                                      child: Text('Cancel')),
                                  TextButton(
                                      onPressed: () {
                                        try {
                                          //update comment
                                          FirebaseFirestore.instance
                                              .collection('comment')
                                              .doc(widget.commentInfo.id)
                                              .update({
                                            'commentContent': editedText
                                          });
                                          setState(() {
                                            isEditingText = false;
                                            globals.isEditing = false;
                                          });
                                        } on FirebaseException catch (error) {
                                          Fluttertoast.showToast(
                                              msg: error.message.toString());
                                        }
                                      },
                                      child: Text('Save'))
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //commenter full name and popUp button
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    //fullname
                                    TextSpan(
                                      text: widget.commentInfo
                                              .get('commenter-firstName') +
                                          ' ' +
                                          widget.commentInfo
                                              .get('commenter-lastName') +
                                          '\n',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    //school
                                    TextSpan(
                                      text: widget.commentInfo
                                              .get('commenter-school') +
                                          '\n',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    //timeStamp
                                    TextSpan(
                                      text: TimeManage.readTimestamp(widget
                                          .commentInfo
                                          .get('published-time')),
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                )),
                                Spacer(),
                                Container(
                                    child: widget.userId ==
                                            widget.commentInfo
                                                .get('commenter-id')
                                        ? Transform.translate(
                                            offset: Offset(15, -8),
                                            child: PopupMenuButton<int>(
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
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0,
                                                                left: 8.0),
                                                        child: Icon(Icons
                                                            .delete_forever),
                                                      ),
                                                      Text("Delete"),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              onSelected: (value) {
                                                if (value == 2) {
                                                  // delete function
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                title: Text(
                                                                    'Delete Comment?'),
                                                                content: Text(
                                                                    "By continuing this post will be deleted permanently."),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: Text(
                                                                          'Cancel')),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        print(
                                                                            'comment dleted');
                                                                        AuthService().deleteComment(
                                                                            widget.commentInfo.id,
                                                                            widget.postId,
                                                                            context);
                                                                      },
                                                                      child: Text(
                                                                          'Continue'))
                                                                ],
                                                              ));
                                                } else if (value == 1) {
                                                  setState(() {
                                                    isEditingText = true;
                                                    globals.isEditing = true;
                                                    print(globals.isEditing);
                                                  });
                                                }
                                              },
                                            ),
                                          )
                                        //when post is not from the current user
                                        : Transform.translate(
                                            offset: Offset(15, -8),
                                            child: PopupMenuButton<int>(
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
                                                        child:
                                                            Icon(Icons.report),
                                                      ),
                                                      Text("Report"),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              onSelected: (value) {
                                                showDialog(
                                                    //report comment
                                                    context: context,
                                                    builder: (BuildContext context) =>
                                                        ReportComment(
                                                            commenterFirstName:
                                                                widget.commentInfo.get(
                                                                    'commenter-firstName'),
                                                            commenterLastName: widget
                                                                .commentInfo
                                                                .get(
                                                                    'commenter-lastName'),
                                                            commenterUID: widget
                                                                    .commentInfo[
                                                                'commenter-id'], //commenter id
                                                            commentId: widget
                                                                .commentInfo
                                                                .id, //comment
                                                            commentContent: widget
                                                                    .commentInfo[
                                                                'commentContent'], //comment
                                                            reporterUID: widget
                                                                .userId //current user id
                                                            ));
                                              },
                                            ),
                                          ))
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(widget.commentInfo.get('commentContent')),
                          ],
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  handleUpVote() async{
    if(widget.myLikeList == null){
      setState(() {
          widget.myLikeList = {widget.commentInfo.id: true};
        });
        try {
           FirebaseFirestore.instance
          .collection("thread")
          .doc(widget.postId)
          .collection('comment')
          .doc(widget.commentInfo.id)
          .update({"like-count": FieldValue.increment(1)}); 
          
            FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection('myLikeList')
          .doc(widget.userId)
          .set({widget.commentInfo.id: true});
          } on FirebaseException catch (e) {
            Fluttertoast.showToast(msg: e.message.toString());
          }
    }
    else if (!widget.myLikeList!.containsKey(widget.commentInfo.id)) {
     print('else if 1');
        setState(() {
          widget.myLikeList!
              .addEntries([MapEntry(widget.commentInfo.id, true)]);
        });  
          try {
          await FirebaseFirestore.instance
          .collection("comment")
          .doc(widget.commentInfo.id)
          .update({"like-count": FieldValue.increment(1)}); 
          
            FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection('myLikeList')
          .doc(widget.userId)
          .update({widget.commentInfo.id: true});
          } on FirebaseException catch (e) {
            Fluttertoast.showToast(msg: e.message.toString());
          }
    } else if ( widget.myLikeList!.containsKey(widget.commentInfo.id)) {
                setState(() {
        widget.myLikeList!.remove(widget.commentInfo.id);
      });
          try {
          await FirebaseFirestore.instance
          .collection("comment")
          .doc(widget.commentInfo.id)
          .update({"like-count": FieldValue.increment(-1)}); 

            FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection('myLikeList')
          .doc(widget.userId)
          .update({widget.commentInfo.id: FieldValue.delete()});
          } on FirebaseException catch (e) {
            Fluttertoast.showToast(msg: e.message.toString());
          }

    }
  }
}
