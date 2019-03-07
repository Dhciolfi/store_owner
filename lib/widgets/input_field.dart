import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  InputField({this.icon, this.hint, this.obscure});

  final IconData icon;
  final String hint;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.white)
          )
      ),
      child: TextFormField(
        decoration: InputDecoration(
            icon: Icon(icon, color: Colors.white,),
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(
                left: 5,
                right: 30,
                bottom: 30,
                top: 30
            ),
            hintText: hint,
            hintStyle: TextStyle(
                color: Colors.white
            ),
        ),
        style: TextStyle(
            color: Colors.white
        ),
        obscureText: obscure,
      ),
    );
  }
}
