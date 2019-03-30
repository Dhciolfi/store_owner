import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/blocs/users_bloc.dart';

class OrderHeader extends StatelessWidget {

  final DocumentSnapshot order;

  OrderHeader(this.order);

  @override
  Widget build(BuildContext context) {

    final usersBloc = BlocProvider.of<UsersBloc>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: usersBloc.allUsers.containsKey(order.data["clientId"]) ? Column(
            children: <Widget>[
              Text("${usersBloc.allUsers[order.data["clientId"]]["name"]}", ),
              Text("${usersBloc.allUsers[order.data["clientId"]]["address"]}", ),
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
