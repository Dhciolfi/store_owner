import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store_owner/models/users_model.dart';
import 'package:store_owner/widgets/user_tile.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            style: TextStyle(color: Colors.white),
            controller: TextEditingController(text: ScopedModel.of<UsersModel>(context).search),
            decoration: InputDecoration(
              hintText: "Pesquisar",
              hintStyle: TextStyle(
                  color: Colors.white
              ),
              icon: Icon(Icons.search, color: Colors.white,),
              border: InputBorder.none,
            ),
            onChanged: (name){
              UsersModel usersModel = ScopedModel.of<UsersModel>(context);

              if(name.trim().isNotEmpty) usersModel.searchName(name);
              else usersModel.cancelSearch();
            },
          ),
        ),
        Expanded(
          child: ScopedModelDescendant<UsersModel>(
            builder: (context, child, model){
              if(model.users.isEmpty && model.search.isEmpty)
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                  ),
                );
              else if(model.users.isEmpty)
                return Center(
                  child: Text(
                    "Nenhum usuário encontrado!",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  )
                );
              else
                return ListView.separated(
                  separatorBuilder: (context, index){
                    return Divider(height: 0.5, color: Colors.white,);
                  },
                  itemCount: model.users.length,
                  itemBuilder: (context, index){
                    return UserTile(model.users[index]);
                  },
                );
            }
          )
        )
      ],
    );
  }
}
