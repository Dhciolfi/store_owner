import 'package:flutter/material.dart';
import 'package:store_owner/widgets/input_field.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Stack(
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
                  ),
                  InputField(
                    hint: "Senha",
                    icon: Icons.lock_outline,
                    obscure: true,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Material(
                    color: Colors.grey[800],
                    child: InkWell(
                      onTap: (){

                      },
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
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
              ),
            ),
          )
        ],
      )
    );
  }

}
