import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/screen/home/homeTab/add_post_form.dart';
import 'package:simplify/page/boosterCommunity/screen/home/reportPost/reportPost.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String userId;

  @override
  void initState() {
    userId = _auth.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        //get data from collection posts
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('time-stamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return snapshot.data!.docs.length > 0
                    ? MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot postInfo) {
                            return FutureBuilder<DocumentSnapshot>(
                                future: userCollection
                                    .doc(postInfo.get('publisher-Id'))
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    Map<String, dynamic> userInfo =
                                        snapshot.data!.data()
                                            as Map<String, dynamic>;
                                    // print('${postInfo['time-stamp']}');
                                    Timestamp timer = postInfo['time-stamp'];
                                    DateTime time =
                                        DateTime.fromMicrosecondsSinceEpoch(
                                            timer.microsecondsSinceEpoch);
                                    print(timer);
                                    DateTime dt =
                                        (postInfo['time-stamp'] as Timestamp)
                                            .toDate();
                                    //print(dt);
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 4,
                                                offset: Offset(2, 2)),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 5),
                                            ListTile(
                                              leading: Container(
                                                  height: 40,
                                                  width: 40,
                                                  child: Image.asset(
                                                      'assets/images/${userInfo['userIcon']}')),
                                              title: Text(
                                                  userInfo['first-name'] +
                                                      ' ' +
                                                      userInfo['last-name'],
                                                  style:
                                                      TextStyle(fontSize: 14)),
                                              subtitle: Text(time.toString(),
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              trailing: PopupMenuButton<int>(
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    value: 1,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8.0,
                                                                  left: 8.0),
                                                          child: Icon(
                                                              Icons.report),
                                                        ),
                                                        Text("Report"),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                                onSelected: (value) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          ReportPost(
                                                              userFirstName:
                                                                  userInfo[
                                                                      'first-name'],
                                                              userLastName:
                                                                  userInfo[
                                                                      'last-name'],
                                                              publisherUID:
                                                                  postInfo[
                                                                      'publisher-Id'], //publisher id
                                                              postID: postInfo
                                                                  .id, //post id
                                                              postTitle: postInfo[
                                                                  'title'], //post title
                                                              postContent: postInfo[
                                                                  'description'], //post content
                                                              reporterUID:
                                                                  userId //current user id
                                                              ));
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 0, 8.0, 0),
                                              child: Divider(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          12, 8, 12, 0),
                                                  child: Text(
                                                      postInfo.get('title'),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Text(postInfo
                                                      .get('description')),
                                                ),
                                                // ListTile(
                                                //   leading: Wrap(
                                                //     children: [
                                                //       Icon(Icons.vot)
                                                //     ],
                                                //   )
                                                //   title:
                                                //   trailing:
                                                // )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Center();
                                  }
                                });
                          }).toList(),
                        ))
                    : Center(child: Text('No Post'));
              }
            }),
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.blueGrey[900],
            child: Icon(
              Icons.add,
              size: 30.0,
            ),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddPostForm()),
              );
            },
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
