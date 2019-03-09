import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/widgets/user_tile.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Pesquisar",
              hintStyle: TextStyle(
                  color: Colors.white
              ),
              icon: Icon(Icons.search, color: Colors.white,),
              border: InputBorder.none,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection("users").getDocuments(),
            builder: (context, snapshot){
              if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
              return ListView.separated(
                separatorBuilder: (context, index){
                  return Divider();
                },
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                  return UserTile(snapshot.data.documents[index]);
                },
              );
            }
          )
        )
      ],
    );
  }
}
