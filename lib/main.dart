import 'package:flutter/material.dart';
import 'package:store_owner/screens/home_screen.dart';
import 'package:store_owner/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Store Owner',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

}

