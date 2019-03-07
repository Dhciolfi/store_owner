import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: CircleAvatar(
            child: Image.network("https://png.icons8.com/color/1600/jumper.png", fit: BoxFit.cover,),
          ),
          title: Text(
            "Camisetas",
            style: TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w500),
          ),
          children: <Widget>[
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
                "R\$19.99",
              ),
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
                "R\$19.99",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
