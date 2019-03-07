import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            "Em preparação #12345224",
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
                            Text("Daniel Ciolfi", ),
                            Text("Av. Brasil", ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      Text(
                        "R\$59,99",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8,),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.network(
                        "https://http2.mlstatic.com/kit-3-camiseta-branca-lisa-basica-camisa-malha-100-algodo-D_NQ_NP_165825-MLB25518372180_042017-F.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text("Camiseta Branca"),
                    trailing: Text(
                      "2",
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.network(
                        "https://http2.mlstatic.com/kit-6-camiseta-preta-basica-100-algodo-fio-30-fabrica-D_NQ_NP_535905-MLB25098889175_102016-F.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text("Camiseta Preta"),
                    trailing: Text(
                      "1",
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
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
