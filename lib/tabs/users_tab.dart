import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/widgets/user_tile.dart';

class UsersTab extends StatefulWidget {
  @override
  _UsersTabState createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> with AutomaticKeepAliveClientMixin{

  Future usersQuery;

  String search;

  @override
  void initState() {
    super.initState();
    usersQuery = Firestore.instance.collection("users").getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            onSubmitted: (name){
              setState(() {
                if(name.trim().isNotEmpty) search = name;
                else search = null;
              });
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<QuerySnapshot>(
            future: usersQuery,
            builder: (context, snapshot){
              if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);

              List<DocumentSnapshot> users = snapshot.data.documents;

              if(search != null){
                List<DocumentSnapshot> result = [];
                users.forEach((d){
                  if(d.data["name"].toUpperCase().contains(search.toUpperCase())) result.add(d);
                });
                users = result;
              }

              return ListView.separated(
                separatorBuilder: (context, index){
                  return Divider(height: 0.5, color: Colors.white,);
                },
                itemCount: users.length,
                itemBuilder: (context, index){
                  return UserTile(users[index]);
                },
              );
            }
          )
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
