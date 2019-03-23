import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel extends Model {

  Firestore _firestore = Firestore.instance;

  Map<String, Map<String, dynamic>> _users = Map();

  String search;

  UsersModel(){
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
            notifyListeners();
            break;
          case DocumentChangeType.removed:
            _unsubscribeToOrders(uid);
            _users.remove(uid);
            notifyListeners();
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

      notifyListeners();

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

  List<Map<String, dynamic>> get users {
    return search == null ? _users.values.toList() : _filter(search);
  }

  Map<String, Map<String, dynamic>> get allUsers {
    return _users;
  }
  
  void searchName(String name){
    search = name;
    notifyListeners();
  }

  void cancelSearch(){
    search = null;
    notifyListeners();
  }

}