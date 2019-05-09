import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    FirebaseAuth.instance.signOut();

    return MaterialApp(
      title: 'Store Owner',
      home: LoginScreen(),
      theme: ThemeData(primaryColor: Colors.pinkAccent,),
      debugShowCheckedModeBanner: false,
    );
  }

}

