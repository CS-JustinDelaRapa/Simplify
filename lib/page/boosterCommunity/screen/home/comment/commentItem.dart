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
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 2.0, 10.0, 2.0),
                child: Container(
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/images/' +
                        widget.commentInfo.get('commenter-icon'))),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              widget.commentInfo.get('commenter-firstName') +
                                  ' ' +
                                  widget.commentInfo.get('commenter-lastName'),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                widget.commentInfo.get('commentContent'),
                                maxLines: null,
                              )),
                        ],
                      ),
                    ),
                    // width: size.width - 90,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Container(
                      width: size.width * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text('Like',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700])),
                          Text(TimeManage.readTimestamp(
                              widget.commentInfo.get('published-time'))),
//                           GestureDetector(
//                               onTap: (){
//                                 widget.replyComment([widget.data['userName'],widget.data['commentID'],widget.data['FCMToken']]);
// //                                _replyComment(widget.data['userName'],widget.data['commentID'],widget.data['FCMToken']);
//                                 print('leave comment of commnet');
//                               },
//                               child: Text('Reply',style:TextStyle(fontWeight: FontWeight.bold,color:Colors.grey[700]))
//                           ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // widget.data['commentLikeCount'] > 0 ? Positioned(
          //   bottom: 10,
          //   right:0,
          //   child: Card(
          //       elevation:2.0,
          //       child: Padding(
          //         padding: const EdgeInsets.all(2.0),
          //         child: Row(
          //           children: <Widget>[
          //             Icon(Icons.thumb_up,size: 14,color: Colors.blue[900],),
          //             Text('${widget.data['commentLikeCount']}',style:TextStyle(fontSize: 14)),
          //           ],
          //         ),
          //       )
          //   ),
          // ) :
          Container(),
        ],
      ),
    );
  }
}

// GestureDetector(
//       // onTap: (){
//       //   Navigator.of(context).push(MaterialPageRoute(
//       //                             builder: (context) => CommentSection(
//       //                               postInfo: widget.postInfo,
//       //                               postId: widget.postInfo.id,
//       //                               userId: widget.userId,
//       //                                 )));
//       // },
//       child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 4,
//                       offset: Offset(2, 2)),
//                 ],
//               ),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 5),
//                     ListTile(
//                       leading: Container(
//                           height: 40,
//                           width: 40,
//                           child: Image.asset('assets/images/' +
//                               widget.commentInfo.get('commenter-icon'))),
//                       title: Text(
//                           widget.commentInfo.get('commenter-firstName') +
//                               ' ' +
//                               widget.commentInfo.get('commenter-lastName'),
//                           style: TextStyle(fontSize: 14)),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(widget.commentInfo.get('commenter-school'),
//                               style: TextStyle(fontSize: 12)),
//                           Text(
//                               TimeManage.readTimestamp(
//                                   widget.commentInfo.get('published-time')),
//                               style: TextStyle(fontSize: 12))
//                         ],
//                       ),
//                       // trailing: widget.userId == widget.postInfo.get('publisher-Id')
//                       //     ? PopupMenuButton<int>(
//                       //         itemBuilder: (context) => [
//                       //           PopupMenuItem(
//                       //             value: 1,
//                       //             child: Row(
//                       //               children: [
//                       //                 Padding(
//                       //                   padding: const EdgeInsets.only(
//                       //                       right: 8.0, left: 8.0),
//                       //                   child: Icon(Icons.edit),
//                       //                 ),
//                       //                 Text("Edit"),
//                       //               ],
//                       //             ),
//                       //           ),
//                       //           PopupMenuItem(
//                       //             value: 2,
//                       //             child: Row(
//                       //               children: [
//                       //                 Padding(
//                       //                   padding: const EdgeInsets.only(
//                       //                       right: 8.0, left: 8.0),
//                       //                   child: Icon(Icons.delete_forever),
//                       //                 ),
//                       //                 Text("Delete"),
//                       //               ],
//                       //             ),
//                       //           ),
//                       //         ],
//                       //         onSelected: (value) {
//                       //           if (value == 2) {
//                       //             showDialog(
//                       //                 context: context,
//                       //                 builder: (BuildContext context) => AlertDialog(
//                       //                       title: Text('Delete Post?'),
//                       //                       content: Text(
//                       //                           "By continuing this post will be deleted permanently."),
//                       //                       actions: [
//                       //                         TextButton(
//                       //                             onPressed: () {
//                       //                               Navigator.of(context).pop();
//                       //                             },
//                       //                             child: Text('Cancel')),
//                       //                         TextButton(
//                       //                             onPressed: () {
//                       //                               AuthService().deletePost(
//                       //                                   widget.postInfo.id, context);
//                       //                             },
//                       //                             child: Text('Continue'))
//                       //                       ],
//                       //                     ));
//                       //           } else if (value == 1) {
//                       //             Navigator.of(context).push(MaterialPageRoute(
//                       //                 builder: (context) => AddPostForm(
//                       //                       title: widget.postInfo['title'],
//                       //                       description:
//                       //                           widget.postInfo['description'],
//                       //                       postUid: widget.postInfo.id,
//                       //                       contextFromPopUp: context,
//                       //                     )));
//                       //           }
//                       //         },
//                       //       )
//                       //     //when post is not from the current user
//                       //     : PopupMenuButton<int>(
//                       //         itemBuilder: (context) => [
//                       //           PopupMenuItem(
//                       //             value: 1,
//                       //             child: Row(
//                       //               children: [
//                       //                 Padding(
//                       //                   padding: const EdgeInsets.only(
//                       //                       right: 8.0, left: 8.0),
//                       //                   child: Icon(Icons.report),
//                       //                 ),
//                       //                 Text("Report"),
//                       //               ],
//                       //             ),
//                       //           ),
//                       //         ],
//                       //         onSelected: (value) {
//                       //           showDialog(
//                       //               context: context,
//                       //               builder: (BuildContext context) => ReportPost(
//                       //                   userFirstName:
//                       //                       widget.postInfo.get('publisher-FirstName'),
//                       //                   userLastName:
//                       //                       widget.postInfo.get('publisher-LastName'),
//                       //                   publisherUID: widget
//                       //                       .postInfo['publisher-Id'], //publisher id
//                       //                   postID: widget.postInfo.id, //post id
//                       //                   postTitle:
//                       //                       widget.postInfo['title'], //post title
//                       //                   postContent: widget
//                       //                       .postInfo['description'], //post content
//                       //                   reporterUID: widget.userId //current user id
//                       //                   ));
//                       //         },
//                       //       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
//                       child: Divider(
//                         color: Colors.grey,
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Text(widget.commentInfo.get('commentContent')),
//                         ),
//                       ],
//                     ),
//                   ]))),
//     );