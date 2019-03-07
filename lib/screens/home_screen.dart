import 'package:flutter/material.dart';
import 'package:store_owner/widgets/category_tile.dart';
import 'package:store_owner/widgets/drag_n_drop_list.dart';
import 'package:store_owner/widgets/order_tile.dart';

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

  List<String> items = ["1", "2", "3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.grey[800],
            primaryColor: Colors.white,
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.white24))),
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
            Column(
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
                  child: ListView.separated(
                    separatorBuilder: (context, index){
                      return Divider();
                    },
                    itemCount: 15,
                    itemBuilder: (context, index){
                      return ListTile(
                        title: Text(
                          "Daniel",
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          "R\$159.00 gastos",
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          "15",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            ListView(
              children: <Widget>[
                OrderTile(),
                OrderTile()
              ],
            ),
            DragAndDropList<String>(
              items,
              itemBuilder: (BuildContext context, item) {
                return CategoryTile();
              },
              onDragFinish: (before, after) {
                String data = items[before];
                items.removeAt(before);
                items.insert(after, data);
              },
              canBeDraggedTo: (one, two) => true,
              dragElevation: 8.0,
            ),
          ],
        )
      ),
      floatingActionButton: _page != 2 ? null:
       FloatingActionButton(
         child: Icon(Icons.add),
         backgroundColor: Colors.pinkAccent,
         onPressed: (){},
       ),
    );
  }
}
