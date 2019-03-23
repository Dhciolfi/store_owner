import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store_owner/models/users_model.dart';

class OrderHeader extends StatelessWidget {

  final DocumentSnapshot order;

  OrderHeader(this.order);

  @override
  Widget build(BuildContext context) {

    UsersModel usersModel = ScopedModel.of<UsersModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: usersModel.allUsers.containsKey(order.data["clientId"]) ? Column(
            children: <Widget>[
              Text("${usersModel.allUsers[order.data["clientId"]]["name"]}", ),
              Text("${usersModel.allUsers[order.data["clientId"]]["address"]}", ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ) : Container()
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "Products: R\$${order.data["productsPrice"].toStringAsFixed(2)}",
              style: TextStyle(
                  fontWeight: FontWeight.w500
              ),
            ),
            Text(
              "Total: R\$${order.data["totalPrice"].toStringAsFixed(2)}",
              style: TextStyle(
                  fontWeight: FontWeight.w500
              ),
            )
          ],
        )
      ],
    );
  }
}
