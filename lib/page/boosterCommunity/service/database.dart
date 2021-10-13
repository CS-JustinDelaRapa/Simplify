import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference userCollection = _firestore.collection('notes');

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  Stream<QuerySnapshot> get brews {
    return userCollection.snapshots();
  }

  //brew list from the snapshot
  //get brew streams
  // user data from snapshots
  // get user doc stream

  Future<void> updateUserData(String fname, String lname, String school) async {
    return await userCollection.doc(uid).set({
      'first-name': fname,
      'last-name': lname,
      'school': school,
    });
  }
}

// add post
  Future<void> addItem({
    required String title,
    required String description,
    required String uid
  }) async {
    DocumentReference documentReferencer =
        userCollection.doc(uid).collection('items').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }
