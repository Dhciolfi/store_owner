import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/widgets/category_tile.dart';
import 'package:store_owner/widgets/drag_n_drop_list.dart';

class ProductsTab extends StatefulWidget {
  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> with AutomaticKeepAliveClientMixin{

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
            DocumentSnapshot d = snapshot.data.documents[before];
            snapshot.data.documents.removeAt(before);
            snapshot.data.documents.insert(after, d);

            for(int i = 0; i < snapshot.data.documents.length; i++){
              DocumentSnapshot d = snapshot.data.documents[i];
              d.reference.updateData({"order": i});
            }
          },
          canBeDraggedTo: (one, two) => true,
          dragElevation: 8.0,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
