import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/screen/signIn-Register/boosterRegister.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

class BoosterSignIn extends StatefulWidget {
  const BoosterSignIn({Key? key}) : super(key: key);

  @override
  _BoosterSignInState createState() => _BoosterSignInState();
}

class _BoosterSignInState extends State<BoosterSignIn> {
  final _formKey = GlobalKey<FormState>();

  String _email = '', _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Sign In'),
      ),  
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Center(
                child: Text('SIMPLIFY!', style: TextStyle(fontSize: 35)),
              ),
              //email Address
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                    ),
                    validator: (title) => title != null && title.isEmpty
                        ? 'Required Email'
                        : null,
                    onChanged: (value){
                      setState(() {
                        _email = value.trim();
                      });
                    },
                  ),
                ),       
              //password
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                    ),
                    validator: (title) => title != null && title.isEmpty
                        ? 'Required password'
                        : null,
                    onChanged: (value){
                      setState(() {
                        _password = value.trim();
                      });
                    },
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
                if(_formKey.currentState!.validate()){
                  AuthService().signInWithEmailandPassword(_email, _password);
                }
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
              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child: SignInButton(
              //     Buttons.Google,
              //     onPressed: (){}),
              // ),
              // //sign in with facebook
              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child: SignInButton(
              //     Buttons.Facebook,
              //     onPressed: (){}),
              // ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
              onPressed: (){
                AuthService().signInAnon();
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
}
