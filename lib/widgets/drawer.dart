import 'package:flutter/material.dart';
import 'package:myapp/screens/actualityPage.dart';
import 'package:myapp/screens/settingPage.dart';

Widget buildDrawer(BuildContext context){
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20))),
    elevation: 3,
    child: Container(
      width: MediaQuery.of(context).size.width/(1.5),
      height: MediaQuery.of(context).size.height/(1.15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20))
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20))
            ),
            child: Text(
              'Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Messages'),
            onTap: (){
              Navigator.pop(context); 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context){ return ActualityPage(index: 0);})
              );
            }
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: (){ 
              Navigator.pop(context);
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context){ return ActualityPage(index: 2);})
              );
            }
          ),
          ListTile(
            onTap: (){
              Navigator.pop(context); 
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => SettingPage())
              );
            },
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    ),
  );
}