import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  Stream<QuerySnapshot> get brews {
    return userCollection.snapshots();
  }

  //get brews stream
  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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
