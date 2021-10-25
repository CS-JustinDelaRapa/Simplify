import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/screen/home/comment/viewPostHeader.dart';

class CommentSection extends StatefulWidget {
  final DocumentSnapshot postInfo;
  final String postId;
  final String userId;
  const CommentSection({ Key? key , required this.postInfo, required this.userId, required this.postId }) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<CommentSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Support Community'),
      ),
      body: Column(
        children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('thread')
              .doc(widget.postId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            return PostHeader(postInfo: snapshot.data!, userId: widget.userId);
          }
        ),
            
          // StreamBuilder<DocumentSnapshot>(
          //   stream: FirebaseFirestore.instance.collection('thread').doc(widget.postId).snapshots(),
          //   builder: (context, snapshot){
          //     if(snapshot.connectionState == ConnectionState.done){                
          //       return PostHeader(postInfo: snapshot.data! , userId: widget.userId);
          //     } 
          //     else {
          //         return Padding(
          //           padding: const EdgeInsets.only(top: 30),
          //           child: Center(child: CircularProgressIndicator()),
          //         );
          //       }
          //   }
          //   ),
        ],
      )
    );
  }
}