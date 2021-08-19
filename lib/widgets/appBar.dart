import 'package:flutter/material.dart';
import 'package:myapp/models/friendModel.dart';
import 'package:myapp/screens/searchPage.dart';
import 'package:myapp/models/constants.dart';
import 'package:myapp/screens/settingPage.dart';
import 'package:provider/provider.dart';

PreferredSizeWidget buildAppBar (BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.grey),
      elevation: 4,
      backgroundColor: kPrimaryColor,
      title:Container(
        width: double.infinity,
        child: GestureDetector(
          onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider<FriendsModel>(create: (_) => FriendsModel(), child:SearchPage())));},
          child: Text('Search...', style: TextStyle(fontSize: 15, color: hintColor),),
        )
      ),
      actions: <Widget>[
        IconButton(
          onPressed: (){
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => SettingPage())
            );           
          },
          icon: Icon(Icons.settings, color: iconColor), iconSize: 28
        ),         
      ]
    );
  }
