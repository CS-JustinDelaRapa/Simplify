import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simplify/page/boosterCommunity/service/convertTimeStamp.dart';

class CommentItem extends StatefulWidget {
  final DocumentSnapshot commentInfo;
  final String userId;
  // Map<String, dynamic>? myLikeList;
  CommentItem({Key? key, required this.commentInfo, required this.userId})
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
    return GestureDetector(
      // onTap: (){
      //   Navigator.of(context).push(MaterialPageRoute(
      //                             builder: (context) => CommentSection(
      //                               postInfo: widget.postInfo,
      //                               postId: widget.postInfo.id,
      //                               userId: widget.userId,
      //                                 )));
      // },
      child: Padding(
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    ListTile(
                      leading: Container(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/images/' +
                              widget.commentInfo.get('commenter-icon'))),
                      title: Text(
                          widget.commentInfo.get('commenter-firstName') +
                              ' ' +
                              widget.commentInfo.get('commenter-lastName'),
                          style: TextStyle(fontSize: 14)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.commentInfo.get('commenter-school'),
                              style: TextStyle(fontSize: 12)),
                          Text(
                              TimeManage.readTimestamp(
                                  widget.commentInfo.get('published-time')),
                              style: TextStyle(fontSize: 12))
                        ],
                      ),
                      // trailing: widget.userId == widget.postInfo.get('publisher-Id')
                      //     ? PopupMenuButton<int>(
                      //         itemBuilder: (context) => [
                      //           PopupMenuItem(
                      //             value: 1,
                      //             child: Row(
                      //               children: [
                      //                 Padding(
                      //                   padding: const EdgeInsets.only(
                      //                       right: 8.0, left: 8.0),
                      //                   child: Icon(Icons.edit),
                      //                 ),
                      //                 Text("Edit"),
                      //               ],
                      //             ),
                      //           ),
                      //           PopupMenuItem(
                      //             value: 2,
                      //             child: Row(
                      //               children: [
                      //                 Padding(
                      //                   padding: const EdgeInsets.only(
                      //                       right: 8.0, left: 8.0),
                      //                   child: Icon(Icons.delete_forever),
                      //                 ),
                      //                 Text("Delete"),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //         onSelected: (value) {
                      //           if (value == 2) {
                      //             showDialog(
                      //                 context: context,
                      //                 builder: (BuildContext context) => AlertDialog(
                      //                       title: Text('Delete Post?'),
                      //                       content: Text(
                      //                           "By continuing this post will be deleted permanently."),
                      //                       actions: [
                      //                         TextButton(
                      //                             onPressed: () {
                      //                               Navigator.of(context).pop();
                      //                             },
                      //                             child: Text('Cancel')),
                      //                         TextButton(
                      //                             onPressed: () {
                      //                               AuthService().deletePost(
                      //                                   widget.postInfo.id, context);
                      //                             },
                      //                             child: Text('Continue'))
                      //                       ],
                      //                     ));
                      //           } else if (value == 1) {
                      //             Navigator.of(context).push(MaterialPageRoute(
                      //                 builder: (context) => AddPostForm(
                      //                       title: widget.postInfo['title'],
                      //                       description:
                      //                           widget.postInfo['description'],
                      //                       postUid: widget.postInfo.id,
                      //                       contextFromPopUp: context,
                      //                     )));
                      //           }
                      //         },
                      //       )
                      //     //when post is not from the current user
                      //     : PopupMenuButton<int>(
                      //         itemBuilder: (context) => [
                      //           PopupMenuItem(
                      //             value: 1,
                      //             child: Row(
                      //               children: [
                      //                 Padding(
                      //                   padding: const EdgeInsets.only(
                      //                       right: 8.0, left: 8.0),
                      //                   child: Icon(Icons.report),
                      //                 ),
                      //                 Text("Report"),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //         onSelected: (value) {
                      //           showDialog(
                      //               context: context,
                      //               builder: (BuildContext context) => ReportPost(
                      //                   userFirstName:
                      //                       widget.postInfo.get('publisher-FirstName'),
                      //                   userLastName:
                      //                       widget.postInfo.get('publisher-LastName'),
                      //                   publisherUID: widget
                      //                       .postInfo['publisher-Id'], //publisher id
                      //                   postID: widget.postInfo.id, //post id
                      //                   postTitle:
                      //                       widget.postInfo['title'], //post title
                      //                   postContent: widget
                      //                       .postInfo['description'], //post content
                      //                   reporterUID: widget.userId //current user id
                      //                   ));
                      //         },
                      //       ),
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
                          padding: const EdgeInsets.all(12.0),
                          child: Text(widget.commentInfo.get('commentContent')),
                        ),
                      ],
                    ),
                  ]))),
    );
  }
}
