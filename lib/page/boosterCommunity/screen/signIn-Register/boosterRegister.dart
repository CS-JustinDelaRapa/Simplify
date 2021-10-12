import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplify/page/boosterCommunity/screen/home/boosterHome.dart';
import 'package:simplify/page/boosterCommunity/screen/verifyScreen.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

class BoosterRegister extends StatefulWidget {
  const BoosterRegister({Key? key}) : super(key: key);

  @override
  _BoosterRegisterState createState() => _BoosterRegisterState();
}

class _BoosterRegisterState extends State<BoosterRegister> {
  final auth = FirebaseAuth.instance;
  String _email = '', _password = '', _lastName = '', _firstName = '', _school = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Center(
                child: Text('SIMPLIFY!', style: TextStyle(fontSize: 35)),
              ),
              //First Name
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'First Name',
                      labelText: 'First Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _firstName = value.trim();
                      });
                    },
                  ),
                ),
              ),
              //Last name
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                      labelText: 'Last Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _lastName = value.trim();
                      });
                    },
                  ),
                ),
              ),
              //email Address
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value.trim();
                      });
                    },
                  ),
                ),
              ),
              //password
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _password = value.trim();
                      });
                    },
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'School',
                      labelText: 'School',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _school = value.trim();
                      });
                    },
                  ),
                ),
              ),
              //sign in button
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                child: ElevatedButton(
                  onPressed: () {
                    AuthService().registerWithEmailandPassword(_email, _password);
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),

              //or separator
              // Row(children: <Widget>[
              //   Expanded(child: Divider(color: Colors.blueGrey)),
              //   Text("OR"),
              //   Expanded(child: Divider(color: Colors.blueGrey)),
              // ]),
              // //sign in with Google
              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child: SignInButton(Buttons.Google, onPressed: () {}),
              // ),
              // //sign in with facebook
              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child: SignInButton(Buttons.Facebook, onPressed: () {}),
              // ),              
            ],
          ),
        ),
      ),
    );
  }
}
