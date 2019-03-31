import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/blocs/product_bloc.dart';
import 'package:store_owner/validators/product_validators.dart';
import 'package:store_owner/widgets/images_widget.dart';
import 'package:store_owner/widgets/product_sizes.dart';

class ProductScreen extends StatefulWidget {

  final DocumentSnapshot product;
  final String categoryId;

  ProductScreen({this.product, this.categoryId});

  @override
  _ProductScreenState createState() => _ProductScreenState(product, categoryId);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidators{

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final ProductBloc _productBloc;

  _ProductScreenState(DocumentSnapshot product, String categoryId) :
        _productBloc = ProductBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {

    InputDecoration _buildDecoration(String label){
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
      );
    }

    final _fieldStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
          stream: _productBloc.outCreatedProduct,
          builder: (context, snapshot){
            if(snapshot.hasData) return Text(snapshot.data ? "Editar Produto" : "Criar Produto");
            return Container();
          },
        ),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _productBloc.outCreatedProduct,
            initialData: false,
            builder: (context, snapshot){
              return snapshot.data ?
              StreamBuilder<bool>(
                stream: _productBloc.outLoading,
                initialData: false,
                builder: (context, snapshot){
                  return IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: snapshot.data ? null : (){
                      _productBloc.deleteProduct();
                      Navigator.of(context).pop();
                    },
                  );
                },
              ):
              Container();
            },
          ),
          StreamBuilder<bool>(
            stream: _productBloc.outLoading,
            initialData: false,
            builder: (context, snapshot){
              return IconButton(
                  icon: Icon(Icons.save),
                  color: Colors.white,
                  onPressed: snapshot.data ? null : saveProduct
              );
            },
          )
        ],
      ),
      body: Stack(
          children: [
            Form(
              key: _formKey,
              child: StreamBuilder<Map>(
                stream: _productBloc.outData,
                builder: (context, snapshot) {
                  if(!snapshot.hasData) return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),);
                  return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      Text(
                        "Images",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      ImagesWidget(snapshot.data["images"]),
                      SizedBox(height: 16,),
                      TextFormField(
                        style: _fieldStyle,
                        decoration: _buildDecoration("Título"),
                        initialValue: snapshot.data["title"],
                        onSaved: _productBloc.setTitle,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        maxLines: 6,
                        style: _fieldStyle,
                        decoration: _buildDecoration("Descrição"),
                        initialValue: snapshot.data["description"],
                        onSaved: _productBloc.setDescription,
                        validator: validateDescription,
                      ),
                      TextFormField(
                        style: _fieldStyle,
                        decoration: _buildDecoration("Preço"),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        initialValue: snapshot.data["price"]?.toStringAsFixed(2),
                        onSaved: _productBloc.setPrice,
                        validator: validatePrice
                      ),
                      SizedBox(height: 16,),
                      Text(
                        "Tamanhos",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      ProductSizes(_productBloc)
                    ],
                  );
                }
              ),
            ),
            StreamBuilder<bool>(
              stream: _productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              },
            ),
          ]
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

      bool success = await _productBloc.saveProduct();

      s.close();

      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(success ? "Produto salvo!" : "Erro ao salvar produto!", style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.pinkAccent,
          )
      );
    }
  }

  @override
  void dispose() {
    _productBloc.dispose();
    super.dispose();
  }
}
