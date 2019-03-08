import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text("Criação de Produto"),
        backgroundColor: Colors.grey[800],
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (){},
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          Text(
            "Imagens",
            style: TextStyle(
                color: Colors.white,
              fontSize: 16,
            ),
          ),
          Container(
            height: 124,
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  child: Icon(Icons.camera_enhance, color: Colors.white,),
                  color: Colors.white.withAlpha(50),
                )
              ],
            ),
          ),
          SizedBox(height: 16,),
          TextField(
            style: TextStyle(color: Colors.white,
                fontSize: 16),
            decoration: InputDecoration(
              hintText: "Título",
                hintStyle: TextStyle(color: Colors.white)
            ),
          ),
          TextField(
            style: TextStyle(color: Colors.white,
                fontSize: 16),
            maxLines: 6,
            decoration: InputDecoration(
              hintText: "Descrição",
              hintStyle: TextStyle(color: Colors.white)
            ),
          )
        ],
      )
    );
  }

}
