import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/blocs/users_bloc.dart';
import 'package:store_owner/widgets/user_tile.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final usersBloc = BlocProvider.of<UsersBloc>(context);

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
            onChanged: usersBloc.onSearchChanged,
          ),
        ),
        Expanded(
          child: StreamBuilder<List>(
            stream: usersBloc.outUsers,
            builder: (context, snapshot){
              if(!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                  ),
                );
              else if(snapshot.data.isEmpty)
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
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    return UserTile(snapshot.data[index]);
                  },
                );
            }
          )
        )
      ],
    );
  }
}
