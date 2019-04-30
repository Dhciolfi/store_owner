import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {

  final _createdProductController = BehaviorSubject<bool>();
  final _loadingController = BehaviorSubject<bool>();
  final _dataController = BehaviorSubject<Map>();

  Stream<bool> get outCreatedProduct => _createdProductController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<Map> get outData => _dataController.stream;

  DocumentSnapshot product;
  String categoryId;

  Map<String, dynamic> unsavedData;

  bool createdProduct;

  ProductBloc({this.product, this.categoryId}){
    if(product != null){
      unsavedData = Map.of(product.data);
      unsavedData["images"] = List.of(product.data["images"]);
      unsavedData["sizes"] = List.of(product.data["sizes"]);

      _createdProductController.add(true);
    } else {
      unsavedData = {
        "title": null, "description": null, "price": null, "images": [], "sizes": []
      };

      _createdProductController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void setTitle(String text){
    unsavedData["title"] = text;
  }

  void setDescription(String text){
    unsavedData["description"] = text;
  }

  void setPrice(String text){
    unsavedData["price"] = double.parse(text);
  }

  void setImages(List images){
    unsavedData["images"] = images;
  }

  void setSizes(List sizes){
    unsavedData["sizes"] = sizes;
  }

  void deleteProduct(){
    product.reference.delete();
  }

  Future<bool> saveProduct() async {
    _loadingController.add(true);

    try {
      if(product != null){
        await _uploadImages(product.documentID);
        await product.reference.updateData(unsavedData);
      } else {
        DocumentReference dr = await Firestore.instance.collection("products").document(categoryId).
        collection("items").add(Map.from(unsavedData)..remove("images"));
        await _uploadImages(dr.documentID);
        await dr.updateData(unsavedData);
      }

      _createdProductController.add(true);
      _loadingController.add(false);

      return true;
    } catch (e){
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadImages(String productId) async {
    for(int i = 0; i < unsavedData["images"].length ; i++){
      if(unsavedData["images"][i] is String) continue;

      StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child(categoryId).
      child(productId).child(DateTime.now().millisecondsSinceEpoch.toString()).putFile(unsavedData["images"][i]);
      StorageTaskSnapshot s = await uploadTask.onComplete;
      String downloadUrl = await s.ref.getDownloadURL();

      unsavedData["images"][i] = downloadUrl;
    }
  }

  @override
  void dispose(){
    _createdProductController.close();
    _loadingController.close();
    _dataController.close();
  }

}