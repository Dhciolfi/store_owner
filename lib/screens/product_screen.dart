import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store_owner/models/product_model.dart';
import 'package:store_owner/widgets/images_widget.dart';

class ProductScreen extends StatefulWidget {

  final DocumentSnapshot product;
  final String categoryId;

  ProductScreen({this.product, this.categoryId});

  @override
  _ProductScreenState createState() => _ProductScreenState(product, categoryId);
}

class _ProductScreenState extends State<ProductScreen> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final ProductModel _productModel;

  _ProductScreenState(DocumentSnapshot product, String categoryId) :
        _productModel = ProductModel(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ProductModel>(
      model: _productModel,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          elevation: 0,
          title: ScopedModelDescendant<ProductModel>(
            builder: (context, child, model){
              return Text(model.createdProduct ? "Editar Produto" : "Criar Produto");
            },
          ),
          actions: <Widget>[
            ScopedModelDescendant<ProductModel>(
              builder: (context, child, model){
                return model.createdProduct ?
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: model.loading ? null : (){
                    model.deleteProduct();
                    Navigator.of(context).pop();
                  },
                ):
                Container();
              },
            ),
            ScopedModelDescendant<ProductModel>(
              builder: (context, child, model){
                return IconButton(
                    icon: Icon(Icons.save),
                    color: Colors.white,
                    onPressed: model.loading ? null : saveProduct
                );
              },
            )
          ],
        ),
        body: Stack(
          children: [
            Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Text(
                  "Imagens",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                ImagesWidget(_productModel.unsavedData["images"]),
                SizedBox(height: 16,),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: "Título",
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  initialValue: _productModel.unsavedData["title"],
                  onSaved: (text){_productModel.unsavedData["title"] = text;},
                  validator: (text){
                    if(text.trim().isEmpty) return "Preencha o título do produto";
                  },
                ),
                TextFormField(
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16),
                  maxLines: 6,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      labelStyle: TextStyle(color: Colors.grey)
                  ),
                  initialValue: _productModel.unsavedData["description"],
                  onSaved: (text){_productModel.unsavedData["description"] = text;},
                  validator: (text){
                    if(text.trim().isEmpty) return "Preencha a descrição do produto";
                  },
                ),
                TextFormField(
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16),
                  decoration: InputDecoration(
                    labelText: "Preço",
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  initialValue: _productModel.unsavedData["price"]?.toStringAsFixed(2),
                  onSaved: (text){_productModel.unsavedData["price"] = double.parse(text);},
                  validator: (text){
                    double price = double.tryParse(text);
                    if(price != null){
                      if(!text.contains(".") || text.split(".")[1].length != 2)
                        return "Utilize 2 casas decimais";
                    } else {
                      return "Preço inválido";
                    }
                  },
                ),
              ],
            ),
          ),
          ScopedModelDescendant<ProductModel>(
            builder: (context, child, model) {
              return IgnorePointer(
                ignoring: !model.loading,
                child: Container(
                  color: model.loading ? Colors.black54 : Colors.transparent,
                ),
              );
            },
          )
        ]
        ),
      ),
    );
  }

  void saveProduct () async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();

      ScaffoldFeatureController s = _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Salvando produto...", style: TextStyle(color: Colors.white),),
          duration: Duration(minutes: 1),
          backgroundColor: Colors.pinkAccent,
        )
      );

      bool success = await _productModel.saveProduct();

      s.close();

      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(success ? "Produto salvo!" : "Erro ao salvar produto!", style: TextStyle(color: Colors.white),),
            duration: Duration(minutes: 1),
            backgroundColor: Colors.pinkAccent,
          )
      );
    }
  }
}
