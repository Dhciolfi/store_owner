import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/blocs/login_bloc.dart';
import 'package:store_owner/screens/home_screen.dart';
import 'package:store_owner/widgets/input_field.dart';

class LoginScreen extends StatelessWidget {
  final LoginBloc _loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {

    _loginBloc.outState.listen((state) {
      switch(state){
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context)=>HomeScreen())
          );
          break;
        case LoginState.FAIL:
          showDialog(context: context, builder: (context)=>AlertDialog(
            title: Text("Erro"),
            content: Text("Você não possui os privilégios necessários"),
          ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });

    return BlocProvider<LoginBloc>(
      bloc: _loginBloc,
      child: Scaffold(
          backgroundColor: Colors.grey[850],
          body: StreamBuilder<LoginState>(
              stream: _loginBloc.outState,
              initialData: LoginState.LOADING,
              builder: (context, snapshot) {
                switch(snapshot.data){
                  case LoginState.LOADING:
                    return Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),),
                    );
                  case LoginState.SUCCESS:
                  case LoginState.FAIL:
                  case LoginState.IDLE:
                    return Stack(
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
                                    hint: "Usuário",
                                    icon: Icons.person_outline,
                                    obscure: false,
                                    stream: _loginBloc.outEmail,
                                    onChanged: _loginBloc.changeEmail
                                ),
                                InputField(
                                    hint: "Senha",
                                    icon: Icons.lock_outline,
                                    obscure: true,
                                    stream: _loginBloc.outPassword,
                                    onChanged: _loginBloc.changePassword
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                StreamBuilder<bool>(
                                  stream: _loginBloc.outSubmitValid,
                                  builder: (context, snapshot){
                                    return SizedBox(
                                      height: 60,
                                      child: RaisedButton(
                                        color: Colors.pinkAccent,
                                        child: Text("Entrar"),
                                        onPressed: snapshot.hasData ? _loginBloc.submit : null,
                                        disabledColor: Colors.pinkAccent.withAlpha(140),
                                        textColor: Colors.white,
                                        disabledTextColor: Colors.white,
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                }
              }
          )
      ),
    );
  }
}
