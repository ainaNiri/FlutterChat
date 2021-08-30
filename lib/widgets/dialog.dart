 import 'package:flutter/material.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/utilities/function.dart';

BuildDialog(BuildContext context, String imagePath)
{
  return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: kPrimaryColor,
        title: Text('Save', style: TextStyle(color: textPrimaryColor)),
        content: Text('Do you want to save the image?', style: TextStyle(color: textPrimaryColor)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.lightBlue)),
          ),
          TextButton(
            onPressed: () async {
              await requestPermission();
              await saveNetworkImage(imagePath); 
              Navigator.pop(context, 'OK');
            },
            child: Text('OK', style: TextStyle(color: Colors.lightBlue)),
          ),
        ],
      ),
  );
}