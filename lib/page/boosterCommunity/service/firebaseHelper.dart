import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplify/page/boosterCommunity/model/myuser.dart';
import 'package:simplify/page/boosterCommunity/service/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //getter for userInfo
  MyUser? _userfromFirebase(User user) {
    // ignore: unnecessary_null_comparison
    return user != null
        ? MyUser(uid: user.uid, verified: user.emailVerified)
        : null;
  }

  //auth change user stream
  Stream<MyUser?> get user {
    return _auth.userChanges().map((User? user) => _userfromFirebase(user!));
  }

  Future registerWithEmailandPassword(String email, String password,
      String firstName, String lastName, String school, BuildContext context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(uid: user!.uid)
          .updateUserData(firstName, lastName, school);
      Navigator.pop(context);
      return _userfromFirebase(user);
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message.toString());
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
}
