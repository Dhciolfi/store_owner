import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {

  final DocumentSnapshot product;

  ProductScreen({this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {

  TextEditingController _titleController;
  TextEditingController _descController;
  TextEditingController _priceController;

  DocumentSnapshot product;

  _ProductScreenState(this.product);

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: product.data["title"]);
    _descController = TextEditingController(text: product.data["description"]);
    _priceController = TextEditingController(text: product.data["price"].toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.product != null ? "Editar Produto" : "Criar Produto"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            color: Colors.white,
            onPressed: (){},
          )
        ],
      ),
      body: ListView(
        shrinkWrap: true,
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
              children: widget.product.data["images"].map<Widget>((i){
                return Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    child: Image.network(i, fit: BoxFit.cover,),
                    onLongPress: (){

                    },
                  )
                );
              }).toList()..add(
                Container(
                  height: 100,
                  width: 100,
                  child: Icon(Icons.camera_enhance, color: Colors.white,),
                  color: Colors.white.withAlpha(50),
                )
              ),
            ),
          ),
          SizedBox(height: 16,),
          TextField(
            style: TextStyle(color: Colors.white,
                fontSize: 16),
            decoration: InputDecoration(
                hintText: "Título",
                hintStyle: TextStyle(color: Colors.grey),
            ),
            controller: _titleController,
          ),
          TextField(
            style: TextStyle(color: Colors.white,
                fontSize: 16),
            maxLines: 6,
            decoration: InputDecoration(
                hintText: "Descrição",
                hintStyle: TextStyle(color: Colors.grey)
            ),
            controller: _descController,
          ),
          TextField(
            style: TextStyle(color: Colors.white,
                fontSize: 16),
            decoration: InputDecoration(
                hintText: "Preço",
                hintStyle: TextStyle(color: Colors.grey)
            ),
            controller: _priceController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      backgroundColor: Colors.grey[850],
    );
  }
}
