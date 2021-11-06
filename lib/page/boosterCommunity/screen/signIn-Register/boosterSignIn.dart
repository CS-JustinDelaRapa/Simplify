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
        final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/testing/testing.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 150),
                Center(
                    child: Column(
                  children: [
                    Text('SIMPLIFY!',
                        style: TextStyle(
                            fontSize: 35,
                            letterSpacing: 2,
                            color: Colors.white)),
                    Text('Support Community',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ],
                )),
                SizedBox(
                  height: 25,
                ),
                //email Address
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                        hintText: 'Email',
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)
                                )
                                ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)))),
                    validator: (title) => title != null && title.isEmpty
                        ? 'Required Email'
                        : null,
                    onChanged: (value) {
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
                        filled: true,
                        fillColor: Colors.white70,
                        hintText: 'Password',
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)))),
                    validator: (title) => title != null && title.isEmpty
                        ? 'Required password'
                        : null,
                    onChanged: (value) {
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
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                        children: [
                          new TextSpan(
                              text: 'Register Here',
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BoosterRegister())),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ))
                        ]),
                  ),
                ),
                //sign in button
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    width: size.width,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.white
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
      )
      )
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          AuthService()
                              .signInWithEmailandPassword(_email, _password);
                        }
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: 15, color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
