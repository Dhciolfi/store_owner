import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

class OrderTile extends StatelessWidget {

  OrderTile(this.order);

  final DocumentSnapshot order;

  static final states = ["", "Em preparação",
    "Em transporte",
    "Aguardando Entrega",
    "Entregue"
    ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: ExpansionTile(
          initiallyExpanded: order.data["status"] != 4,
          title: Text(
            "#${order.documentID.substring(order.documentID.length - 7, order.documentID.length)} - ${states[order.data["status"]]}",
            style: TextStyle(color: order.data["status"] == 4 ? Colors.green : Colors.grey[850],),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
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
                  ),
                  SizedBox(height: 8,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: order.data["products"].map<Widget>((p){
                      return ListTile(
                        title: Text(p["product"]["title"] + " " + p["size"]),
                        subtitle: Text(p["category"] + "/" + p["pid"]),
                        trailing: Text(
                          p["quantity"].toString(),
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                          order.reference.delete();
                          Firestore.instance.collection("users").
                            document(order["clientId"]).collection("orders").
                            document(order.documentID).delete();
                        },
                        textColor: Colors.red,
                        child: Text("Excluir"),
                      ),
                      FlatButton(
                        onPressed: order.data["status"] > 1 ? (){
                          order.reference.updateData({"status": order.data["status"]-1});
                        } : null,
                        textColor: Colors.grey[850],
                        child: Text("Regredir"),
                      ),
                      FlatButton(
                        onPressed: order.data["status"] < 4 ? (){
                          order.reference.updateData({"status": order.data["status"]+1});
                        } : null,
                        textColor: Colors.green,
                        child: Text("Avançar"),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
