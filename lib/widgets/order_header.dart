import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OrderHeader extends StatelessWidget {

  final DocumentSnapshot order;

  OrderHeader(this.order);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: FutureBuilder(
              future: Firestore.instance.collection("users").document(order.data["clientId"]).get(),
              builder: (context, snapshot){
                if(snapshot.hasData)
                  return Column(
                    children: <Widget>[
                      Text("${snapshot.data["name"]}", ),
                      Text("${snapshot.data["address"]}", ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  );
                else
                  return Column(
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
                            highlightColor: Colors.grey
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
                            highlightColor: Colors.grey
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  );
              }
          )
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
