import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserTile extends StatelessWidget {

  final DocumentSnapshot user;

  UserTile(this.user);

  Future<Map> calcTotal() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("users").
    document(user.documentID).collection("orders").getDocuments();

    double money = 0;
    int orders = querySnapshot.documents.length;
    int finishedOrders = 0;

    for(DocumentSnapshot d in querySnapshot.documents){
      DocumentSnapshot order = await Firestore.instance.collection("orders").
        document(d.documentID).get();
      money += order.data["totalPrice"];
      if(order.data["status"] == 4) finishedOrders += 1;
    }

    return {"money": money, "orders": orders, "finishedOrders": finishedOrders};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: calcTotal(),
      builder: (context, snapshot){
        if(snapshot.hasData) {
          return ListTile(
            title: Text(
              user["name"],
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              user["email"],
              style: TextStyle(color: Colors.white),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Pedidos: ${snapshot.data["orders"]}",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Completos: ${snapshot.data["finishedOrders"]}",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Gasto: R\$${snapshot.data["money"]}",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            onTap: (){

            },
          );
        } else return Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 200,
                  height: 20,
                  child: Shimmer.fromColors(
                      child: Container(
                        color: Colors.white.withAlpha(50),
                        margin: EdgeInsets.symmetric(vertical: 4),
                      ),
                      baseColor: Colors.white,
                      highlightColor: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 20,
                  child: Shimmer.fromColors(
                    child: Container(
                      color: Colors.white.withAlpha(50),
                      margin: EdgeInsets.symmetric(vertical: 4),
                    ),
                    baseColor: Colors.white,
                    highlightColor: Colors.grey,
                  ),
                ),
              ],
            ),
          );
      },
    );
  }
}
