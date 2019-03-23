import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/widgets/image_source_sheet.dart';

class EditCategoryScreen extends StatefulWidget {

  final DocumentSnapshot category;

  EditCategoryScreen({this.category});

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState(category);
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _titleController = TextEditingController();

  final DocumentSnapshot category;

  File loadedImage;

  _EditCategoryScreenState(this.category);

  @override
  void initState() {
    super.initState();

    if(category != null){
      _titleController.text = category.data["title"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      body: Center(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: GestureDetector(
                    onTap: (){
                      showModalBottomSheet(context: context,
                        builder: (context)=>ImageSourceSheet((image){
                          Navigator.of(context).pop();
                          setState(() {
                            loadedImage = image;
                          });
                        }));
                    },
                    child: category != null || loadedImage != null ?
                      CircleAvatar(
                        child: loadedImage != null ? Image.file(loadedImage, fit: BoxFit.cover,) :
                        Image.network(category.data["icon"], fit: BoxFit.cover,),
                        backgroundColor: Colors.transparent,
                      ) :
                        Icon(Icons.image)
                  ),
                  title: TextFormField(
                    controller: _titleController,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Excluir"),
                      textColor: Colors.red,
                      onPressed: category == null ? null : (){
                        showDialog(context: context, builder: (context)=>
                          AlertDialog(
                            title: Text("Excluir"),
                            content: Text("Deseja excluir a categoria? Todos os produtos "
                                "serão removidos!"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Cancelar"),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("Excluir"),
                                textColor: Colors.red,
                                onPressed: (){
                                  category.reference.delete();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          )
                        );
                      },
                    ),
                    FlatButton(
                      child: Text("Salvar"),
                      onPressed: () async {
                        ScaffoldFeatureController c = _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Salvando..."),
                            backgroundColor: Colors.pinkAccent,
                            duration: Duration(minutes: 1),
                          )
                        );

                        if(loadedImage != null){
                          StorageUploadTask task = FirebaseStorage.instance.ref().child("icons").
                            child(_titleController.text)
                              .putFile(loadedImage);
                          StorageTaskSnapshot snap = await task.onComplete;
                          String url = await snap.ref.getDownloadURL();

                          if(category == null){
                            await Firestore.instance.collection("products").
                                document(_titleController.text.toLowerCase()).setData({
                              "title": _titleController.text,
                              "icon": url,
                              "order": -1
                            });
                          } else {
                            await category.reference.updateData({
                              "title": _titleController.text,
                              "icon": url
                            });
                          }
                        } else {
                          await category.reference.updateData({
                            "title": _titleController.text,
                          });
                        }

                        c.close();
                        Navigator.of(context).pop();

                      },
                    )
                  ],
                ),
              ],
            )
          ),
        )
      ),
    );
  }
}
