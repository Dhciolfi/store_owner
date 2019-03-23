import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store_owner/models/orders_model.dart';
import 'package:store_owner/widgets/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: ScopedModelDescendant<OrdersModel>(
        builder: (context, child, model){
          if(model.orders.isEmpty)
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
              ),
            );

          return ListView(
            children: model.orders.map((order){
              return OrderTile(order);
            }).toList(),
          );
        },
      ),
    );
  }
}
