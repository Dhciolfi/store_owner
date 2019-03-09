import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/widgets/category_tile.dart';
import 'package:store_owner/widgets/drag_n_drop_list.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("products").orderBy("order").getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
        return DragAndDropList<DocumentSnapshot>(
          snapshot.data.documents,
          itemBuilder: (BuildContext context, DocumentSnapshot doc) {
            return CategoryTile(doc);
          },
          onDragFinish: (before, after) {
            /*String data = items[before];
            items.removeAt(before);
            items.insert(after, data);*/
          },
          canBeDraggedTo: (one, two) => true,
          dragElevation: 8.0,
        );
      },
    );
  }
}
