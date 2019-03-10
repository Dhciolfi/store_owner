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
    super.build(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("orders").snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
          snapshot.data.documents.sort((a, b){
            if(a.data["status"] == 4) return 1;
            else return 0;
          });
          return ListView(
            children: snapshot.data.documents.map((document){
              return OrderTile(document);
            }).toList(),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
