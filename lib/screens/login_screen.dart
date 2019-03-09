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

  bool loading = false;


  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user){
      if(user != null){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context)=>HomeScreen())
        );
      }
    });
  }

  void _login() async {
    setState(() {
      loading = true;
    });
    FirebaseUser user;
    try {
      user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passController.text,
      );
    } catch (e){
      setState(() {
        loading = false;
      });
    }
    if(user != null){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context)=>HomeScreen())
      );
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: loading ? Center(child: CircularProgressIndicator(),) : Stack(
        alignment: Alignment.center,
        children: <Widget>[
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
                    color: Colors.white,
                    size: 160,
                  ),
                  InputField(
                    hint: "Usuário",
                    icon: Icons.person_outline,
                    obscure: false,
                    controller: _emailController
                  ),
                  InputField(
                    hint: "Senha",
                    icon: Icons.lock_outline,
                    obscure: true,
                    controller: _passController
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Material(
                    color: Colors.grey[800],
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
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.white24],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  )
              ),
            ),
          )
        ],
      )
    );
  }
}
