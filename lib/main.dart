import 'package:agridex/ui/sheep_list.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(new SheepBoxApp());
}

class SheepBoxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.amberAccent,
          fontFamily: 'Ubuntu'),
      home: new SheepList(),
    );
  }
}
