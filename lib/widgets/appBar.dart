import 'package:flutter/material.dart';
import 'package:myapp/screens/searchPage.dart';

PreferredSizeWidget buildAppBar (BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.grey),
      elevation: 4,
      backgroundColor: Colors.white,
      title:Container(
        width: double.infinity,
        child: GestureDetector(
          onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));},
          child: Text('Search...', style: TextStyle(fontSize: 15, color: Colors.grey[400]),),
        )
      ),
      actions: <Widget>[
        IconButton(
          onPressed: (){},
          icon: Icon(Icons.settings, color: Colors.grey[400]), iconSize: 28
        ),         
      ]
    );
  }
