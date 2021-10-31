import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simplify/page/boosterCommunity/service/convertTimeStamp.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

// ignore: must_be_immutable
class CommentItem extends StatefulWidget {
  final DocumentSnapshot commentInfo;
  final String userId;
  final String postId;
  Map<String, dynamic>? myLikeList;
  // Map<String, dynamic>? myLikeList;
  CommentItem({Key? key, required this.commentInfo, required this.userId, required this.postId, this.myLikeList})
      : super(key: key);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool loading = false;

  @override
  void initState() {
    // print(widget.myLikeList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5 ),
      child: Container(
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    SizedBox(height: 2),
                    Container(
                      height: 40,
                      width: 40,
                      child: Image.asset('assets/images/' + widget.commentInfo.get('commenter-icon'))),                                           
                    IconButton(
                      onPressed: (){
                        handleUpVote();
                      },
                      icon: Icon(Icons.school_rounded, size: 30, 
                      color: widget.myLikeList != null && widget.myLikeList!.containsKey(widget.commentInfo.id)
                                  && widget.myLikeList!.containsValue(true)?
                                  Colors.blue
                                  : Colors.black54
                      ),
                    ),
                    Text(widget.commentInfo.get('like-count').toString())
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(left: 10.0)),
                  Expanded(
                    child: Container(
                            decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
                                ],
                            ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          //commenter name
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.commentInfo.get('commenter-firstName') + ' ' + widget.commentInfo.get('commenter-lastName')
                              ,style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                              Spacer(),
                              Container(
                              child: widget.userId == widget.commentInfo.get('commenter-id')
                                            ? Transform.translate(
                                              offset: Offset(15,0),
                                              child: PopupMenuButton<int>(
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
                                                                        // AuthService().deletePost(
                                                                        //     widget.commentInfo.id, context);
                                                                      },
                                                                      child: Text('Continue'))
                                                                ],
                                                              ));
                                                    } else if (value == 1) {
                                                      print('sample');
                                                    //   Navigator.of(context).push(MaterialPageRoute(
                                                    //       builder: (context) => AddPostForm(
                                                    //             title: widget.postInfo['title'],
                                                    //             description:
                                                    //                 widget.postInfo['description'],
                                                    //             postUid: widget.postInfo.id,
                                                    //             contextFromPopUp: context,
                                                    //           )));
                                                    }
                                                  },
                                                ),
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
                                                      builder: (BuildContext context) => AlertDialog(
                                                        title: Text('sample text'),
                                                      ),
                                                  );
                                                },
                                            )
                                  )
                              ],
                          ),
                          //commenter school
                          Text(widget.commentInfo.get('commenter-school'),
                          style: TextStyle(fontSize: 12)),
                          //timeStamp
                          Text(TimeManage.readTimestamp(widget.commentInfo.get('published-time')),style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
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
handleUpVote(){
      if (widget.myLikeList == null || !widget.myLikeList!.containsKey(widget.commentInfo.id)){
      FirebaseFirestore.instance.collection("thread").doc(widget.postId).collection('comment').doc(widget.commentInfo.id).update({"like-count": FieldValue.increment(1)});
      FirebaseFirestore.instance.collection("users").doc(widget.userId).collection('myLikeList').doc(widget.userId).update({widget.commentInfo.id: true});     
      if(widget.myLikeList == null){
    setState(() {
      widget.myLikeList = {widget.commentInfo.id:true};
    });
      } else{
      setState(() {
        widget.myLikeList!.addEntries([
        MapEntry(widget.commentInfo.id,true)
      ]);
      });
      }
      } else if (widget.myLikeList != null || widget.myLikeList!.containsKey(widget.commentInfo.id)){
      FirebaseFirestore.instance.collection("thread").doc(widget.postId).collection('comment').doc(widget.commentInfo.id).update({"like-count": FieldValue.increment(-1)});
      FirebaseFirestore.instance.collection("users").doc(widget.userId).collection('myLikeList').doc(widget.userId).update({widget.commentInfo.id: FieldValue.delete()});
      setState(() {
        widget.myLikeList!.remove(widget.commentInfo.id);
      });
      }                     
}


}