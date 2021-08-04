import 'package:flutter/material.dart';
import 'package:myapp/screens/actualityPage.dart';

class BuildDrawer extends StatelessWidget {
  const BuildDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
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
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context){ return ActualityPage(index: 2);})
                );
              }
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      );
  }
}