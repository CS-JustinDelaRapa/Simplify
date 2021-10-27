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
        'userIcon': '001-panda.png',
      });
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

  //to add post in database
  Future addItem(
    String title,
    String description,
    String? postUid,
    String publisherSchool,
    String publisherFirstName,
    String publisherLastName,
    String publisherUserIcon,
  ) async {
    try {
      User? user = _auth.currentUser;
      await threadCollection.doc(postUid).set({
        'title': title,
        'description': description,
        'publisher-Id': user!.uid,
        'published-time': DateTime.now().millisecondsSinceEpoch,
        'up-votes': 0,
        'down-votes': 0,
        'comment-count': 0,
        'publisher-UserIcon': publisherUserIcon,
        'publisher-FirstName': publisherFirstName,
        'publisher-LastName': publisherLastName,
        'publisher-School': publisherSchool,
      });
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

      var querySnapshots = await threadCollection
          .where('publisher-Id', isEqualTo: user!.uid)
          .get();
      for (var doc in querySnapshots.docs) {
        await doc.reference.update({
          'publisher-UserIcon': userIcon,
        });
      }

      await userCollection.doc(user.uid).update(data);
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
}
