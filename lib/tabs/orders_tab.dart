import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/blocs/orders_bloc.dart';
import 'package:store_owner/widgets/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
        stream: BlocProvider.of<OrdersBloc>(context).outOrders,
        builder: (context, snapshot){
          if(!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
              ),
            );
          else if(snapshot.data.isEmpty)
            return Center(
              child: Text("Nenhum pedido encontrado!")
            );

          return ListView(
            children: snapshot.data.map((order){
              return OrderTile(order);
            }).toList(),
          );
        },
      ),
    );
  }
}
