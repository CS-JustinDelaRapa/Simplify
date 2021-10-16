import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/screen/home/homeTab/add_post_form.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin{
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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
                          children:
                              snapshot.data!.docs.map((DocumentSnapshot postInfo) {
                            return FutureBuilder<DocumentSnapshot>(
                                future: userCollection.doc(postInfo.get('publisher-Id')).get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    Map<String, dynamic> userInfo = snapshot.data!
                                        .data() as Map<String, dynamic>;
                                    return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2)),
                    ],
                ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(userInfo['first-name'] + ' ' + userInfo['last-name'], style: TextStyle(fontWeight:  FontWeight.bold),),
                          subtitle: Text(userInfo['school']),
                          trailing: Icon(Icons.more_vert),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0,0),
                          child: Divider(color: Colors.grey,),
                        ),
                        ListTile(
                          title: Text(postInfo.get('title')),
                          subtitle: Text(postInfo.get('title')),
                          
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
