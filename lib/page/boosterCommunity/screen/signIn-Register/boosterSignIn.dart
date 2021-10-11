import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplify/page/boosterCommunity/screen/home/boosterHome.dart';
import 'package:simplify/page/boosterCommunity/screen/signIn-Register/boosterRegister.dart';

class BoosterSignIn extends StatefulWidget {
  const BoosterSignIn({Key? key}) : super(key: key);

  @override
  _BoosterSignInState createState() => _BoosterSignInState();
}

class _BoosterSignInState extends State<BoosterSignIn> {
  final auth = FirebaseAuth.instance;
  String _email = '', _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sign In'),
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
              //email Address
              Container(
                child: Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                ),
              onChanged: (value){
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
                onChanged: (value){
                  setState(() {
                    _password = value.trim();
                  });
                },
              ),
                ),
              ),
              //register text
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: new TextSpan(
                      text: 'Don\'t have an account yet? ',
                      style: TextStyle(color: Colors.grey[800], fontSize: 15),
                      children: [
                        new TextSpan(
                          text: 'Register Here',
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () =>  
                             Navigator.of(context).push(MaterialPageRoute(builder: (context) => BoosterRegister())),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.blue[300]),
                        )
                      ]),
                ),
              ),
        
              //sign in button
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                child: ElevatedButton(
              onPressed: (){
                signIn(_email, _password);
              },
              child: Text(
                'Sign In',
                style: TextStyle(fontSize: 15),
              ),
                ),
              ),
        
              //or separator
              Row(children: <Widget>[
                Expanded(child: Divider(color: Colors.blueGrey)),
                Text("OR"),
                Expanded(child: Divider(color: Colors.blueGrey)),
              
              ]
              ),
              //sign in with Google
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SignInButton(
                  Buttons.Google,
                  onPressed: (){}),
              ),
              //sign in with facebook
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SignInButton(
                  Buttons.Facebook,
                  onPressed: (){}),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
              onPressed: (){
                auth.signInAnonymously().then((_){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => BoosterHome())
                    );
                });
              },
              child: Text(
                'Sign In Anonymously',
                style: TextStyle(fontSize: 15),
              ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  signIn(String _email, String _password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: _email, password: _password);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BoosterHome()));
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message.toString());
    }
  }
}
