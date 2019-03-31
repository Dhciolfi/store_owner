import 'package:flutter/material.dart';
import 'package:store_owner/blocs/product_bloc.dart';
import 'package:store_owner/widgets/add_size_dialog.dart';
import 'package:store_owner/validators/product_validators.dart';

class ProductSizes extends StatelessWidget with ProductValidators {

  final ProductBloc productBloc;

  ProductSizes(this.productBloc);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34.0,
      child: StreamBuilder<List>(
          stream: productBloc.outSizes,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return Container();
            return FormField<List>(
              initialValue: snapshot.data,
              validator: validateSizes,
              builder: (formFieldState){
                return GridView(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5
                  ),
                  children: snapshot.data.map(
                          (s){
                        return GestureDetector(
                          onLongPress: (){
                            productBloc.removeSize(s);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                border: Border.all(
                                    color: Colors.pinkAccent,
                                    width: 3.0
                                )
                            ),
                            width: 50.0,
                            alignment: Alignment.center,
                            child: Text(s, style: TextStyle(color: Colors.white),),
                          ),
                        );
                      }
                  ).toList()..add(
                      GestureDetector(
                        onTap: () async {
                          String size = await showDialog(context: context, builder: (context) => AddSizeDialog());
                          if(size != null) productBloc.addSize(size);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                  color: formFieldState.hasError ? Colors.red : Colors.pinkAccent,
                                  width: 3.0
                              )
                          ),
                          width: 50.0,
                          alignment: Alignment.center,
                          child: Text("+", style: TextStyle(color: Colors.white),),
                        ),
                      )
                  ),
                );
              },
            );
          }
      ),
    );
  }
}