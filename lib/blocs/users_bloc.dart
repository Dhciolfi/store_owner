import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UsersBloc extends BlocBase {

  final _usersController = BehaviorSubject<List>();

  Stream<List> get outUsers => _usersController.stream;


  Firestore _firestore = Firestore.instance;

  Map<String, Map<String, dynamic>> _users = Map();

  UsersBloc(){
    _addUsersListener();
  }

  void _addUsersListener(){
    _firestore.collection("users").snapshots().listen((snapshot){
      snapshot.documentChanges.forEach((change){

        String uid = change.document.documentID;

        switch(change.type){
          case DocumentChangeType.added:
            _users[change.document.documentID] = change.document.data;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[change.document.documentID].addAll(change.document.data);
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _unsubscribeToOrders(uid);
            _users.remove(uid);
            _usersController.add(_users.values.toList());
            break;
        }
      });
    });
  }

  void _subscribeToOrders(String uid) {
    _users[uid]["subscription"] = _firestore.collection("users").document(uid).
    collection("orders").snapshots().listen((orders) async {

      int numOrders = orders.documents.length;

      double money = 0.0;

      for(DocumentSnapshot d in orders.documents){
        DocumentSnapshot order = await _firestore.collection("orders").
        document(d.documentID).get();

        if(order.data == null) continue;

        money += order.data["totalPrice"];
      }

      _users[uid].addAll({
        "money": money, "orders": numOrders,
      });

      _usersController.add(_users.values.toList());

    });
  }

  void _unsubscribeToOrders(String uid){
    _users[uid]["subscription"].cancel();
  }

  List<Map<String, dynamic>> _filter(String name){
    List<Map<String, dynamic>> filteredUsers = List.from(_users.values.toList());
    filteredUsers.retainWhere((user){
      return user["name"].toUpperCase().contains(name.toUpperCase());
    });
    return filteredUsers;
  }

  void _searchName(String name){
    _usersController.add(_filter(name));
  }

  void _cancelSearch(){
    _usersController.add(_users.values.toList());
  }

  void onSearchChanged(String text){
    if(text.trim().isNotEmpty) _searchName(text);
    else _cancelSearch();
  }

  Map<String, Map<String, dynamic>> get allUsers {
    return _users;
  }

  @override
  void dispose() {
    _usersController.close();
  }


}