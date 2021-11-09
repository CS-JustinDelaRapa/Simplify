import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplify/page/boosterCommunity/model/myuser.dart';

final CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');
final CollectionReference threadCollection =
    FirebaseFirestore.instance.collection('thread');

class AuthService {
  String? uid;
  String? publisherId;

  AuthService({this.uid, this.publisherId});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //getter for userInfo, from firebase to dart object
  MyUser? _userfromFirebase(User user) {
    // ignore: unnecessary_null_comparison
    return user != null
        ? MyUser(uid: user.uid, verified: user.emailVerified)
        : null;
  }

//**Getters */

  //auth change user stream, Sign In value
  Stream<MyUser?> get user {
    return _auth.userChanges().map((User? user) => _userfromFirebase(user!));
  }

//**Account */

  Future registerWithEmailandPassword(
      String email,
      String password,
      String firstName,
      String lastName,
      String school,
      BuildContext context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      // create a new document for the user with the uid
      await userCollection.doc(user!.uid).set({
        'first-name': firstName,
        'last-name': lastName,
        'school': school,
        'userIcon': '001.png',
      });

      await userCollection.doc(user.uid).collection('myLikeList').doc(user.uid).set(
        {'postId': 'value'}
        );
      Navigator.pop(context);
      return _userfromFirebase(user);
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message.toString());
      //push
    }
  }

  //sign in with email and password
  Future signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userfromFirebase(user!);
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userfromFirebase(user!);
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }

//**Data manipulation */
  Future updateItem(String title, String description, String postUid,
      String publisherPostCategory) async {
    try {
      User? user = _auth.currentUser;
      await threadCollection.doc(postUid).update({
        'title': title,
        'description': description,
        'publisher-Id': user!.uid,
        'post-category': publisherPostCategory,
        'published-time': DateTime.now().millisecondsSinceEpoch,
      });
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }

  //to add post in database
  Future addItem(
    String title,
    String description,
    String publisherSchool,
    String publisherFirstName,
    String publisherLastName,
    String publisherUserIcon,
    String publisherPostCategory,
  ) async {
    try {
      User? user = _auth.currentUser;
      await threadCollection.doc().set({
        'title': title,
        'description': description,
        'publisher-Id': user!.uid,
        'published-time': DateTime.now().millisecondsSinceEpoch,
        'view-count': 0,
        'comment-count': 0,
        'publisher-UserIcon': publisherUserIcon,
        'publisher-FirstName': publisherFirstName,
        'publisher-LastName': publisherLastName,
        'publisher-School': publisherSchool,
        'post-category': publisherPostCategory,
      });
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }

  Future addComment(
      String commentContent,
      String? postUid,
      String commenterFirstName,
      String commenterLastName,
      String commenterIcon,
      String commenterSchool) async {
    try {
      User? user = _auth.currentUser;

      await FirebaseFirestore.instance.collection('comment').doc().set({
        'commentContent': commentContent,
        'commenter-id': user!.uid,
        'commenter-firstName': commenterFirstName,
        'commenter-lastName': commenterLastName,
        'commenter-icon': commenterIcon,
        'commenter-school': commenterSchool,
        'like-count': 0,
        'published-time': DateTime.now().millisecondsSinceEpoch,
        'postUid': postUid
      });
      await threadCollection
          .doc(postUid)
          .update({"comment-count": FieldValue.increment(1)});
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }

//update user Icon
  Future updateUserIcon(String userIcon, BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      Map<String, Object> data = new HashMap();
      data['userIcon'] = userIcon;

      //update User profile Icon
      await userCollection.doc(user!.uid).update(data);

      //update all post Icon
      var threadUpdate = await threadCollection
          .where('publisher-Id', isEqualTo: user.uid)
          .get();
      for (var doc in threadUpdate.docs) {
        await doc.reference.update({
          'publisher-UserIcon': userIcon,
        });
      }

      //update all comment Icon
            var commentUpdate = await FirebaseFirestore.instance.collection('comment')
          .where('commenter-id', isEqualTo: user.uid)
          .get();
      for (var doc in commentUpdate.docs) {
        await doc.reference.update({
          'commenter-icon': userIcon,
        });
      }
      Navigator.pop(context);
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }

//delete post
  Future deletePost(String postUid, BuildContext context) async {
    try {
      await threadCollection.doc(postUid).delete();
      Navigator.pop(context);
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }

  //delete comment
  Future deleteComment(
      String commentUID, String postUID, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('comment')
          .doc(commentUID)
          .delete();
      await threadCollection
          .doc(postUID)
          .update({"comment-count": FieldValue.increment(-1)});
      Navigator.pop(context);
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }
}
