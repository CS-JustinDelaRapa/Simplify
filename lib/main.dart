// @dart=2.9

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:simplify/page/NavBar.dart';

StreamController<bool> listController = StreamController<bool>();
StreamController<bool> homeController = StreamController<bool>();
StreamController<bool> calendarController = StreamController<bool>();
StreamController<bool> unfinishedController = StreamController<bool>();
StreamController<bool> mainController = StreamController<bool>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(      
      debugShowCheckedModeBanner: false,
      title: 'Simplify!',
      theme: ThemeData(
        textTheme: TextTheme(
        bodyText1: TextStyle(),
        bodyText2: TextStyle(),
        ).apply(
        bodyColor: Colors.grey[800],  
        ),
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: HomePage(listController: listController, calendarController: calendarController, homeController: homeController, unfinishedController:unfinishedController, mainController: mainController,),
    );
  }
}