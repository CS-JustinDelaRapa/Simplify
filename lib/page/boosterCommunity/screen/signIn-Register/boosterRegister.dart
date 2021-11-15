import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

class BoosterRegister extends StatefulWidget {
  const BoosterRegister({Key? key}) : super(key: key);

  @override
  _BoosterRegisterState createState() => _BoosterRegisterState();
}

class _BoosterRegisterState extends State<BoosterRegister> {
  final _formKey = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;
  String _email = '',
      _password = '',
      _lastName = '',
      _firstName = '',
      _school = '';
//comment
  String _confirmPassword = '';
  final List<String> schools = [
    'Don Honorio Ventura State University',
    'Our Lady Of Fatima University',
    'Holy Angel University',
    'AMA',
    'Angeles University',
    'University of the Assumption'
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      //background image
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/testing/testing.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Text('Register',
                        style: TextStyle(fontSize: 35, color: Colors.white)),
                  ),
                  //First Name
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'First Name',
                          filled: true,
                          fillColor: Colors.white70,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)))),
                      validator: (value) => value != null && value.isEmpty
                          ? 'Required First Name'
                          : null,
                      onChanged: (value) {
                        setState(() {
                          _firstName = value.trim();
                        });
                      },
                    ),
                  ),
                  //Last Name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
                          hintText: 'Last Name',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)))),
                      validator: (value) => value != null && value.isEmpty
                          ? 'Required Last name'
                          : null,
                      onChanged: (value) {
                        setState(() {
                          _lastName = value.trim();
                        });
                      },
                    ),
                  ),
                  //Email
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          fillColor: Colors.white70,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)))),
                      validator: (value) => value != null && value.isEmpty
                          ? 'Required Email'
                          : null,
                      onChanged: (value) {
                        setState(() {
                          _email = value.trim();
                        });
                      },
                    ),
                  ),
                  //First Name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: TextFormField(
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.white70,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)))),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Required a Password';
                        }
                        if (value.trim().length < 8) {
                          return 'Password must be at least 8 characters in length';
                        }
                        if (!value.trim().contains(RegExp(r"[A-Z]")) ||
                            !value.trim().contains(RegExp(r"[0-9]"))) {
                          return 'Password must have a Upper Case and a Number ';
                        }

                        // Return null if the entered password is valid
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _password = value.trim();
                        });
                      },
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     TextFormField(
                  //       decoration:
                  //           InputDecoration(labelText: 'Confirm Password'),
                  //       obscureText: true,
                  //       validator: (value) {
                  //         if (value!.isEmpty) {
                  //           return 'This field is required';
                  //         }

                  //         if (value != _password) {
                  //           return 'Confimation password does not match the entered password';
                  //         }
                  //         return null;
                  //       },
                  //       onChanged: (value) => _confirmPassword = value,
                  //     ),
                  //   ],
                  // ),
                  //school
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)))),
                      validator: (value) =>
                          value == null ? 'Required School' : null,
                      isDense: true,
                      hint: Text('School'),
                      isExpanded: true,
                      items: schools.map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(
                            val,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _school = value!;
                        });
                      },
                    ),
                  ),
                  //sign in button
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      height: 50,
                      width: size.width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ))),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            AuthService().registerWithEmailandPassword(
                                _email,
                                _password,
                                _firstName,
                                _lastName,
                                _school,
                                context);
                          }
                        },
                        child: Text('Register',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
