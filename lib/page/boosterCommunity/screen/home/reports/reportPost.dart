import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

class ReportPost extends StatefulWidget {
  final String postContent;
  final String postTitle;
  final String postID;
  final String reporterUID;
  final String publisherUID;
  final String userFirstName;
  final String userLastName;
  final bool isFreeze;
  const ReportPost({
    Key? key,
    required this.postContent,
    required this.postID,
    required this.reporterUID,
    required this.publisherUID,
    required this.postTitle,
    required this.userFirstName,
    required this.userLastName,
    required this.isFreeze,
  }) : super(key: key);

  @override
  _ReportPostState createState() => _ReportPostState();
}

final CollectionReference reportCollection =
    FirebaseFirestore.instance.collection('reports');

class _ReportPostState extends State<ReportPost> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Report Post"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
              "Post Author: ${widget.userFirstName} ${widget.userLastName}\n\nPlease choose why do you want to report the post\n"),
          _blockButton('Possible Spam Post.'),
          SizedBox(
            height: 5,
          ),
          _blockButton('Inappropriate Post'),
          SizedBox(
            height: 5,
          ),
          _blockButton('Not relative about subject'),
          SizedBox(
            height: 5,
          ),
          _blockButton('Impersonation.')
        ],
      ),
      actions: <Widget>[
        new TextButton(
          child: Text("Close"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _blockButton(String buttonText) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(style: BorderStyle.solid)),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
          backgroundColor: MaterialStateProperty.all<Color>(
            Colors.transparent,
          ),
        ),
        onPressed: () => _sendReport(buttonText), //_reportUser(buttonText),
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12),
          child: Container(
            width: double.infinity,
            child: Text(
              buttonText,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void _sendReport(String reportReason) async {
    showToastMessage();
    await reportCollection.doc().set({
      'post-title': widget.postTitle,
      'post-description': widget.postContent,
      'post-Id': widget.postID,
      'publisher-Id': widget.publisherUID,
      'reporterUId': widget.reporterUID,
      'report-reason': reportReason,
    });
    await threadCollection.doc(widget.postID).update({'isFreeze': true});
    Navigator.of(context).pop();
  }

  static void showToastMessage() {
    Fluttertoast.showToast(
        msg:
            'Thank you for reporting. We will determine the user\'s information within 24 hours and delete the account or take action to stop it.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
