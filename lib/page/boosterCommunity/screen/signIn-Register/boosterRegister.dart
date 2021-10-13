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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        foregroundColor: Colors.black,
        // title: Text('Register', style: TextStyle(fontSize: 35, fontWeight: FontWeight.normal)),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Center(
                  child: Text('Register', style: TextStyle(fontSize: 35)),
                ),
                //First Name
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                      labelText: 'First Name',
                    ),
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
                      hintText: 'Last Name',
                      labelText: 'Last Name',
                    ),
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
                      labelText: 'Email',
                    ),
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
                      labelText: 'Password',
                    ),
                    validator: (value) => value != null && value.isEmpty
                        ? 'Required password'
                        : null,
                    onChanged: (value) {
                      setState(() {
                        _password = value.trim();
                      });
                    },
                  ),
                ),
                //school
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: DropdownButtonFormField<String>(
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
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        AuthService().registerWithEmailandPassword(_email,
                            _password, _firstName, _lastName, _school, context);
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 15),
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
