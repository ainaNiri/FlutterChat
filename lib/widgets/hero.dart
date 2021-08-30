  import 'package:flutter/material.dart';
import 'package:myapp/widgets/dialog.dart';

void showHero(BuildContext context, dynamic image, String index)
{
  Navigator.push(
    context,
    MaterialPageRoute(builder : (context){
      return Scaffold(
        body: GestureDetector(
          onLongPress: (){
            BuildDialog(context, image);
          },
          child: InteractiveViewer(
            child: Center(
              child: Hero(
                tag: 'image'+index,
                child: (image is String) ? Image.network(image) : Image.file(image)
              ),
            )
          ),
        )
      );})
  );
}