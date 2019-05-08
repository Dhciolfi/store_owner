import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class CategoryBloc extends BlocBase {

  final _imageController = BehaviorSubject();
  final _titleController = BehaviorSubject<String>();
  final _deleteController = BehaviorSubject<bool>();

  Stream get outImage => _imageController.stream;
  Stream<String> get outTitle => _titleController.stream.transform(
    StreamTransformer<String, String>.fromHandlers(
      handleData: (title, sink) {
        if (title.isNotEmpty) {
          sink.add(title);
        } else {
          sink.addError('Insira um título');
        }
      })
  );
  Stream<bool> get outDelete => _deleteController.stream;

  Stream<bool> get submitValid => Observable.combineLatest2(
      outImage, outTitle, (a, b) => true);

  DocumentSnapshot category;

  String title;
  File loadedImage;

  CategoryBloc(this.category){
    if(category != null){
      title = category.data["title"];

      _imageController.add(category.data["icon"]);
      _titleController.add(category.data["title"]);
      _deleteController.add(true);
    } else {
      _deleteController.add(false);
    }
  }

  void setTitle(String title){
    this.title = title;
    _titleController.add(title);
  }

  void setImage(File image){
    loadedImage = image;
    _imageController.add(image);
  }

  void delete(){
    category.reference.delete();
  }

  Future saveData() async {
    if(loadedImage == null && category != null && title == category.data["title"]) return;

    Map<String, dynamic> dataToUpdate = {};

    if(loadedImage != null){
      StorageUploadTask task = FirebaseStorage.instance.ref().child("icons")
          .child(title).putFile(loadedImage);

      StorageTaskSnapshot snap = await task.onComplete;
      dataToUpdate["icon"] = await snap.ref.getDownloadURL();
    }

    if(category == null || title != category.data["title"]){
      dataToUpdate["title"] = title;
    }

    if(category == null){
      await Firestore.instance.collection("products")
          .document(title.toLowerCase()).setData(dataToUpdate);
    } else {
      await category.reference.updateData(dataToUpdate);
    }
  }

  @override
  void dispose() {
    _imageController.close();
    _titleController.close();
    _deleteController.close();
  }

}