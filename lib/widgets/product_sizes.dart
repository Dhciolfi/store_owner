import 'package:flutter/material.dart';
import 'package:store_owner/widgets/add_size_dialog.dart';

class ProductSizes extends FormField<List> {

  ProductSizes({
    BuildContext context,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
    List initialValue,
    bool autoValidate = false
  }) : super(
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      autovalidate: autoValidate,
      builder: (FormFieldState<List> state) {
        return SizedBox(
            height: 34.0,
            child: GridView(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.5
              ),
              children: state.value.map(
                      (s){
                    return GestureDetector(
                      onLongPress: (){
                        state.didChange(state.value..remove(s));
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
                      if(size != null) state.didChange(state.value..add(size));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          border: Border.all(
                              color: state.hasError ? Colors.red : Colors.pinkAccent,
                              width: 3.0
                          )
                      ),
                      width: 50.0,
                      alignment: Alignment.center,
                      child: Text("+", style: TextStyle(color: Colors.white),),
                    ),
                  )
              ),
            )
        );
      }
  );

}