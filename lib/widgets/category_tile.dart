import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/screens/edit_category_screen.dart';
import 'package:store_owner/screens/product_screen.dart';

class CategoryTile extends StatelessWidget {

  final DocumentSnapshot category;

  CategoryTile(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>
                  EditCategoryScreen(category: category)
                )
              );
            },
            child: CircleAvatar(
              child: Image.network(category.data["icon"], fit: BoxFit.cover,),
              backgroundColor: Colors.transparent,
            ),
          ),
          title: Text(
            category.data["title"],
            style: TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w500),
          ),
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
              future: category.reference.collection("items").getDocuments(),
              builder: (context, snapshot){
                if(!snapshot.hasData) return Container();
                return Column(
                  children: snapshot.data.documents.map((doc){
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.network(
                          doc.data["images"][0],
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(doc.data["title"]),
                      trailing: Text(
                        "R\$${doc.data["price"].toStringAsFixed(2)}",
                      ),
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>ProductScreen(product: doc, categoryId: category.documentID,))
                        );
                      },
                    );
                  }).toList()..add(
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.add, color: Colors.pinkAccent,)
                      ),
                      title: Text("Adicionar"),
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>ProductScreen(categoryId: category.documentID,))
                        );
                      },
                    )
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
