import 'package:flutter/material.dart';

class Data {
  final String name;
  final double percent;
  final Color color;
  Data({required this.name, required this.percent, required this.color});
}

class PieData {
  static List<Data> data = [
    Data(name: 'Finished task', percent: 40, color: Colors.black),
    Data(name: 'Unfinished task', percent: 60, color: Colors.white),
  ];
}
