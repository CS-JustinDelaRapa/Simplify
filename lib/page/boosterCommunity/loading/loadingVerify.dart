import 'package:flutter/material.dart';

class LoadingVerify extends StatelessWidget {
  const LoadingVerify({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularProgressIndicator(),
          Text('Plase Verfy your email...')
        ],
      )
    );
  }
}