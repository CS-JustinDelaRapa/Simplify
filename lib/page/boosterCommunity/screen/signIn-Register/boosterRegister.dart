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

  bool isAgree = false;

  final auth = FirebaseAuth.instance;
  String _email = '',
      _password = '',
      _lastName = '',
      _firstName = '',
      _school = '';
  // ignore: unused_field
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
                  Center(
                    child: Text('Register',
                        style: TextStyle(fontSize: 35, color: Colors.white)),
                  ),
                  //First Name
                  SizedBox(height: 5),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: TextFormField(
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Confirm Password',
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
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }

                        if (value != _password) {
                          return 'Confimation password does not match';
                        }
                        return null;
                      },
                      onChanged: (value) => _confirmPassword = value,
                    ),
                  ),
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
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,                                        
                      children: [
                      Checkbox(
                            value: isAgree,
                            onChanged: (value) {
                              setState(() {
                                isAgree = !isAgree;
                              });
                            },
                          ),
                      TextButton(onPressed: (){
                        showTerms();
                      }, child: Text('Terms and Conditions',
                      style: TextStyle(color: Colors.black,),))
                    ],),
                  ),
                  //sign in button
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
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
                            if(isAgree == true){
                                AuthService().registerWithEmailandPassword(
                                _email,
                                _password,
                                _firstName,
                                _lastName,
                                _school,
                                context);
                            }else{
                              showCheck();
                            }
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

 showTerms(){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Text('Terms And Conditions', style: TextStyle(fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Terms of Use',style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('''Thank you for joining Simplify! ("We," "Us," "Company"). These Terms of Use, along with the Privacy Policy and any other documents expressly included by reference, establish the terms and conditions under which you may access and use the task organizer and scheduler services, mobile application, and Service provided or maintained by Simplify! ("Service"), which includes any content and functionality made available through the Service. ("Terms and Conditions" or "Agreement")'''),
                SizedBox(height: 10),
                Text('''PLEASE READ THE TERMS OF USE CAREFULLY BEFORE YOU START TO USE THE SERVICE. BY USING THE SERVICE, YOU ACCEPT AND AGREE TO BE BOUND AND ABIDE BY THESE TERMS OF USE. IF YOU DO NOT WANT TO AGREE TO THESE TERMS OF USE, YOU MUST NOT ACCESS OR USE THE SERVICE. WE RESERVE THE RIGHT TO CHANGE, ADD OR REMOVE PORTIONS OF THESE TERMS OF USE AND ANY DOCUMENTS INCORPORATED HEREIN AT ANY TIME AND AT OUR SOLE DISCRETION. YOUR CONTINUED USE OF THE SERVICE FOLLOWING THE POSTING OF ANY CHANGES MEANS THAT YOU ACCEPT AND AGREE TO SUCH CHANGES. IT IS YOUR RESPONSIBILITY TO CHECK THESE TERMS OF USE PERIODICALLY FOR CHANGES.''', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('General',style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('''The Service has been designed by Simplify with the purpose of assisting people to achieve productive day through organizing and scheduling tasks effectively. The Service requires your active engagement and participation. You understand that, despite your efforts, individual users' results will vary for a variety of reasons and Simplify cannot guarantee that you will achieve your goals without your willingness to cooperate.'''),
                SizedBox(height: 10),
                Text('Registration',style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),  
                Text('''You are required to register for the Service and provide certain information about yourself. All information we collect about you in connection with the Services is subject to our Privacy Policy. By using the Service, you consent to all actions taken by us with respect to your information in compliance with the Privacy Policy, including being contacted via email. You will receive a user account for our personal use that requires an e-mail and password. You are responsible for all activities that occur under your user account. You shall: (i) have sole responsibility for the accuracy, quality, integrity, legality, reliability, and appropriateness of all data you provide; (ii) maintain the confidentiality of your password and user account information; (iii) use commercially reasonable efforts to prevent unauthorized access to, and (iv) comply with all applicable local, state, and federal laws in using the Service'''),              
                SizedBox(height: 10),
                Text('Terms and Termination',style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10), 
                Text('''The term of this Agreement will begin upon your successful registration for the Service and will continue indefinitely unless terminated by either party as permitted herein. The Company may suspend or terminate your access to the Service if you (a) breach any term of this Agreement, or (b) engage in any conduct that the Company determines in its discretion may have an adverse effect on the Company or its reputation. Upon termination, you will no longer have access to the Service, mobile application, or content provided through the Services. In addition to termination, the Company reserves the right to pursue any and all remedies available to it.''')                 
                ,SizedBox(height: 10), 
                Text('Conditions of Community Booster',style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10), 
                Text('''The conditions given in the Community Booster are as follows:'''),
                SizedBox(height: 5),
                Text('''(a)	Any offensive or swear words detected by the application and checked thoroughly by the moderator or administrator will be deleted accordingly.'''),                
                SizedBox(height: 5),
                Text('''(b)	A message through email given upon registration will be sent to the user whenever warnings and offenses were made'''),
                SizedBox(height: 5),
                Text('''(c)	There are 3 warnings for the account if a report is made by another user whenever a post in the community booster slipped through the profanity checker.'''),
                SizedBox(height: 5),
                Text('''(d)	In addition, if the user receives more than three warnings, the account will be terminated.'''),
                SizedBox(height: 10), 
                Text('Warnings of Community Booster',style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10), 
                Text('''(a)	FIRST WARNING: Any foul or swear word placed in the community booster that slipped past the profanity checker and was reported by another user will result in the post being frozen and will be under review. If the post indeed contains offensive language, the moderator or administrator will delete it immediately and send the first warning to the user's email address.'''),
                SizedBox(height: 5),
                Text('''(b)	SECOND WARNING: If another foul or swear word placed in the community booster that slipped past the profanity checker and was reported by another user will result in the post being frozen and will be under review. If the post indeed contains offensive language, the moderator or administrator will delete it immediately and send the second warning to the user's email address.'''),
                SizedBox(height: 5),
                Text('''(c) THIRD WARNING: If another foul or swear phrase is posted in the community booster that slipped past the profanity checker and is reported by another user, the post will be frozen and reviewed. If the post does actually contain foul language, the moderator or administrator will promptly delete the account and send a message to the user's email address.'''),
                SizedBox(height: 10),
                Text('Trademarks',style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('''Trademarks, service marks, graphics, and logos used in connection with the Service are the trademarks of their respective owners. You are granted no right or license with respect to any of the trademarks mentioned above and any use of such trademarks. You acknowledge and agree that all text, graphics, photographs, trademarks, logos, visual interfaces, artwork, computer code, and all other related content contained on the Service is owned by the Company or third parties and is protected by trade dress, copyright, patent and trademark laws, and various other intellectual property rights and unfair competition laws. Any reproduction, publication, further distribution, or public exhibition of materials provided through the Service, in whole or in part, is strictly prohibited. Except as expressly provided in these Terms of Use, no part of the Service and no content may be copied, reproduced, republished, uploaded, posted, publicly displayed, encoded, translated, distributed, or transmitted in any way (including “mirroring”) to any other computer, server, Service or another medium for publication or distribution or for any commercial enterprise, without the express prior written consent of the Company.'''),              
                SizedBox(height: 10),
                Text('EFFECTIVE: January 15, 2022',style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('Okay'))
          ],
        );
      });
  }

 showCheck(){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          content: Text('You must read and agree to our Community Terms and Condition to continue.', 
          textAlign: TextAlign.center,),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('Okay'))
          ],
        );
      });
  }
}
