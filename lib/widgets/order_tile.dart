import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTile extends StatelessWidget {

  OrderTile(this.order);

  final DocumentSnapshot order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            "#${order.documentID.substring(order.documentID.length - 7, order.documentID.length)} - Em preparação",
            style: TextStyle(color: Colors.grey[850]),
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
                        child: Column(
                          children: <Widget>[
                            Text("${order.data["clientId"]}", ),
                            Text("Av. Brasil", ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      Text(
                        "R\$${order.data["totalPrice"].toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500
                        ),
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
                        onPressed: (){},
                        textColor: Colors.red,
                        child: Text("Excluir"),
                      ),
                      FlatButton(
                        onPressed: (){},
                        textColor: Colors.grey[850],
                        child: Text("Regredir"),
                      ),
                      FlatButton(
                        onPressed: (){},
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
