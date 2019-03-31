import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
          padding: EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: controller,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop(controller.text);
                  },
                  child: Text("Add"),
                  textColor: Colors.pinkAccent,
                  padding: EdgeInsets.zero,
                ),
              )
            ],
          ),
        )
    );
  }
}
