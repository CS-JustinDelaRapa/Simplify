import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReportComment extends StatefulWidget {
  final String commentContent;
  final String commentId;
  final String reporterUID;
  final String commenterUID;
  final String commenterFirstName;
  final String commenterLastName;
  const ReportComment({
    Key? key,
    required this.commentContent,
    required this.commentId,
    required this.reporterUID,
    required this.commenterUID,
    required this.commenterFirstName,
    required this.commenterLastName,
  }) : super(key: key);

  @override
  _ReportCommentState createState() => _ReportCommentState();
}

final CollectionReference reportCommentsCollection =
    FirebaseFirestore.instance.collection('report-comments');

class _ReportCommentState extends State<ReportComment> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Report Comment"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
              "Post Author: ${widget.commenterFirstName} ${widget.commenterLastName}\n\nPlease choose why do you want to report the post\n"),
          _blockButton('Possible Spam Comment.'),
          SizedBox(
            height: 5,
          ),
          _blockButton('Inappropriate Comment'),
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
    await reportCommentsCollection.doc().set({
      'comment-content': widget.commentContent,
      'comment-Id': widget.commentId,
      'commenter-Id': widget.commentId,
      'reporter-Id': widget.reporterUID,
      'report-reason': reportReason,
    });
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
