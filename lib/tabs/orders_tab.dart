import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/widgets/order_tile.dart';

class OrdersTab extends StatefulWidget {
  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("orders").snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
        return ListView(
          children: snapshot.data.documents.map((document){
            return OrderTile(document);
          }).toList(),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
