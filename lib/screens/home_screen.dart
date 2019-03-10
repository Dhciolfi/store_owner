import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_owner/screens/edit_category_screen.dart';
import 'package:store_owner/screens/login_screen.dart';
import 'package:store_owner/tabs/orders_tab.dart';
import 'package:store_owner/tabs/products_tab.dart';
import 'package:store_owner/tabs/users_tab.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PageController _pageController;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context)=>LoginScreen())
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.pinkAccent,
              primaryColor: Colors.white,
              textTheme: Theme
                  .of(context)
                  .textTheme
                  .copyWith(caption: TextStyle(color: Colors.white54))),
          child: BottomNavigationBar(
            currentIndex: _page,
              onTap: (p){
                _pageController.animateToPage(p, duration: Duration(milliseconds: 500), curve: Curves.ease);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    title: Text("Clientes")
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart),
                    title: Text("Pedidos")
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    title: Text("Produtos")
                ),
              ]
          ),
        ),
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            onPageChanged: (p){
              setState(() {
                _page = p;
              });
            },
            children: <Widget>[
              UsersTab(),
              OrdersTab(),
              ProductsTab(),
            ],
          )
        ),
        floatingActionButton: _page != 2 ? null:
         FloatingActionButton(
           child: Icon(Icons.add),
           backgroundColor: Colors.pinkAccent,
           onPressed: (){
             Navigator.of(context).push(
                 MaterialPageRoute(builder: (context)=>
                     EditCategoryScreen()
                 )
             );
           },
         ),
      ),
    );
  }
}
