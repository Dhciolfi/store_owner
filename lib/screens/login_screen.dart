import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/screens/home_screen.dart';
import 'package:store_owner/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  bool loading = true;

  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    subscription = FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if(user != null){
        if(await verifyPrivileges(user)){
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context)=>HomeScreen())
          );
        } else {
          FirebaseAuth.instance.signOut();

          setLoading(false);

          showDialog(context: context, builder: (context)=>AlertDialog(
            title: Text("Error"),
            content: Text("You don't have admin privileges."),
          ));
        }
      } else {
        setLoading(false);
      }
    });
  }


  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void setLoading(bool l){
    if(loading == l) return;
    setState(() {
      loading = l;
    });
  }

  Future<bool> verifyPrivileges(FirebaseUser user) async {
     return await Firestore.instance.collection("admins").document(user.uid).get().then((doc){
      if(doc.data != null){
        return true;
      } else {
        return false;
      }
    }).catchError((e){
      return false;
    });
  }

  void _login() async {
    setLoading(true);

    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passController.text,
    ).catchError((e){
      setLoading(false);

      showDialog(context: context, builder: (context)=>AlertDialog(
        title: Text("Error"),
        content: Text("${e.message}"),
      ));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        body: loading ?
        Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
        ),) :
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(
                      Icons.store_mall_directory,
                      color: Colors.pinkAccent,
                      size: 160,
                    ),
                    InputField(
                        hint: "User",
                        icon: Icons.person_outline,
                        obscure: false,
                        controller: _emailController
                    ),
                    InputField(
                        hint: "Password",
                        icon: Icons.lock_outline,
                        obscure: true,
                        controller: _passController
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Material(
                      color: Colors.pinkAccent,
                      child: InkWell(
                        onTap: _login,
                        child: Container(
                          height: 60,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}
