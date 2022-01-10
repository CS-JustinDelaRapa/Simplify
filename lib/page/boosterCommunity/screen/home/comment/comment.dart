import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:simplify/page/boosterCommunity/screen/home/comment/commentItem.dart';
import 'package:simplify/page/boosterCommunity/screen/home/comment/viewPostHeader.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';
import '../../../../../algo/globals.dart' as globals;

class CommentSection extends StatefulWidget {
  final DocumentSnapshot postInfo;
  final String postId;
  final String userId;
  final Map<String, dynamic>? myLikeList;
  const CommentSection(
      {Key? key,
      required this.postInfo,
      required this.userId,
      required this.postId,
      required this.myLikeList})
      : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _msgTextController = new TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  //upload to firebase
  String _commenterSchool = '';
  String _commenterFirstName = '';
  String _commenterLastName = '';
  String _commenterIcon = '';

  @override
  void initState() {
    super.initState();
    getInfo(_auth.currentUser!.uid);
  }

  Future getInfo(String publisherUid) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(publisherUid)
        .get()
        .then((value) {
      setState(() {
        _commenterSchool = value.get('school');
        _commenterFirstName = value.get('first-name');
        _commenterLastName = value.get('last-name');
        _commenterIcon = value.get('userIcon');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo.shade800,
        elevation: 0,
        title: Text('Booster Community',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/testing/testing.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('thread')
                      .doc(widget.postId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Center();
                    return PostHeader(
                        postInfo: snapshot.data!, userId: widget.userId);
                  }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('comment')
                        .where('postUid', isEqualTo: widget.postId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      return Stack(children: <Widget>[
                        ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot commentInfo) {
                            return CommentItem(
                              myLikeList: widget.myLikeList,
                              postId: widget.postId,
                              commentInfo: commentInfo,
                              userId: widget.userId,
                            );
                          }).toList(),
                        )
                      ]);
                    }),
              ),
            ),
            //if global is Editing is false, return create comment
            globals.isEditing == false
                ? _buildTextComposer()
                //if true return null widget
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).backgroundColor),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  focusNode: FocusNode(),
                  controller: _msgTextController,
                  onSubmitted: null,
                  decoration: InputDecoration.collapsed(
                      hintText: "Write a comment",
                      hintTextDirection: TextDirection.ltr),
                ),
              ),
            ),
            Container(
              child: IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: () async {
                    final additionalWords = ProfanityFilter.filterAdditionally(
                        globals.badWordsList);
                    additionalWords.toString().toLowerCase();
                    bool hasProfanity =
                        additionalWords.hasProfanity(_msgTextController.text);

                    // bool hasProfanity = filter.hasProfanity(_msgTextController.text);
                    if (hasProfanity) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text("Offensive Word Alert"),
                                content: Text(
                                    "Seems like your comment contains inapropriate or improper words, Please consider reconstructiong your comment."),
                                actions: [
                                  ElevatedButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ));
                    } else {
                      AuthService().addComment(
                          _msgTextController.text,
                          widget.postId,
                          _commenterFirstName,
                          _commenterLastName,
                          _commenterIcon,
                          _commenterSchool);
                      FocusScope.of(context).requestFocus(FocusNode());
                      _msgTextController.text = '';
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
