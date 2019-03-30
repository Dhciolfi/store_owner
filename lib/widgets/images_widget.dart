import 'package:flutter/material.dart';
import 'package:store_owner/widgets/image_source_sheet.dart';
import 'package:store_owner/validators/product_validators.dart';

class ImagesWidget extends StatefulWidget {

  final List images;

  ImagesWidget(this.images);

  @override
  _ImagesWidgetState createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> with ProductValidators {

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: validateImages,
      initialValue: widget.images,
      builder: (formFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 124,
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: (widget.images != null ? widget.images.map<Widget>((i){
                return Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      child: i is String ? Image.network(i, fit: BoxFit.cover,) : Image.file(i, fit: BoxFit.cover,),
                      onLongPress: (){
                        setState(() {
                          widget.images.remove(i);
                        });
                      },
                    )
                );
              }).toList() : [])..add(
                  GestureDetector(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Icon(Icons.camera_enhance, color: Colors.white,),
                      color: Colors.white.withAlpha(50),
                    ),
                    onTap: (){
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => ImageSourceSheet((image){
                            Navigator.of(context).pop();
                            setState(() {
                              widget.images.add(image);
                            });
                          })
                      );
                    },
                  )
              ),
            ),
          ),
          formFieldState.hasError ? Text(
              formFieldState.errorText,
            style: TextStyle(
              color: Colors.red,
              fontSize: 12
            ),
          ) : Container()
        ],
      )
    );
  }
}
