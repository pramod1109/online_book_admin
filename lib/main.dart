import 'package:flutter/material.dart';
import 'package:onlinebooksadmin/home.dart';
import 'package:onlinebooksadmin/request.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
