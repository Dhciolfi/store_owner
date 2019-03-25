import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel extends Model {

  String categoryId;
  DocumentSnapshot product;

  Map<String, dynamic> unsavedData;

  bool createdProduct;
  bool loading = false;

  ProductModel({this.categoryId, this.product}){
    if(product != null){
      unsavedData = Map.of(product.data);
      unsavedData["images"] = List.of(product.data["images"]);
      unsavedData["sizes"] = List.of(product.data["sizes"]);

      createdProduct = true;
    } else {
      unsavedData = {
        "title": null, "description": null, "price": null, "images": [], "sizes": []
      };
      
      createdProduct = false;
    }
  }

  Future uploadImages(String productId) async {
    for(int i = 0; i < unsavedData["images"].length ; i++){
      if(unsavedData["images"][i] is String) continue;

      StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child(categoryId).
        child(productId).child(DateTime.now().millisecondsSinceEpoch.toString()).putFile(unsavedData["images"][i]);
      StorageTaskSnapshot s = await uploadTask.onComplete;
      String downloadUrl = await s.ref.getDownloadURL();

      unsavedData["images"][i] = downloadUrl;
    }
  }

  void deleteProduct(){
    product.reference.delete();
  }

  Future<bool> saveProduct() async {
    loading = true;
    notifyListeners();

    try {
      if(product != null){
        await uploadImages(product.documentID);
        await product.reference.updateData(unsavedData);
      } else {
        DocumentReference dr = await Firestore.instance.collection("products").document(categoryId).
          collection("items").add(Map.from(unsavedData)..remove("images"));
        await uploadImages(dr.documentID);
        await dr.updateData(unsavedData);
      }

      createdProduct = true;
      loading = false;
      notifyListeners();

      return true;
    } catch (e){
      loading = false;
      notifyListeners();
      return false;
    }
  }
}