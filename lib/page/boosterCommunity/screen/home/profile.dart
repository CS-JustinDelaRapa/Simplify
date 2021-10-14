import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplify/page/boosterCommunity/model/myuser.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

class Profile extends StatefulWidget {

  const Profile({ Key? key }) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

late String userId;

@override
  void initState() {
    userId = AuthService().userID.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder<CurrentUserInfo?>(
        stream: AuthService().userInfo,
        builder: (context, snapshot) {
          if(snapshot.hasData){     
            CurrentUserInfo? currentUserInfo = snapshot.data;
          return Column(
            children: [
              Padding(
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
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 80,
                          width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Icon(Icons.person, size: 35)
                          )
                        ),
                      ),
                      Column(
                        children: [
                          Text(currentUserInfo!.firstName.toString()),
                          Text(currentUserInfo.school.toString())
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
                    }else{
                      return Center(child: CircularProgressIndicator());
                    }
        }
      ),
    );
  }
}