import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/screens/FriendsPage.dart';
import 'package:myapp/customIcon/app_icons.dart';
import 'package:myapp/screens/notificationsPage.dart';
import 'package:myapp/screens/profilePage.dart';
import 'package:myapp/utilities/notifications.dart';
import 'package:myapp/widgets/appBar.dart';
import 'package:myapp/widgets/chatPage.dart';
import 'package:myapp/widgets/drawer.dart';

// ignore: must_be_immutable
class ActualityPage extends StatefulWidget{
  int ?index;
  ActualityPage({Key ?key, this.index}) :super(key: key);
  
  @override
  _ActualityPage createState() => _ActualityPage();
}

class _ActualityPage extends State<ActualityPage>{

  int notificationCounter = 2;
  static  List<Widget> _widgetOptions = <Widget>[
    ChatPage(),
    FriendsPage(),
    ProfilePage(icon: Icon(Icons.person), person: currentUser),
    NotificationsPage(),    
  ];

  void initState() {
    super.initState();
    initFirebaseMessaging();
  }
  
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kPrimaryColor,
      appBar: buildAppBar(
        context,
        _scaffoldKey
      ),
      drawer: buildDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[Colors.indigo.shade600, Colors.indigo.shade300]),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          child: Container(
            color: kPrimaryColor,
            child: _widgetOptions.elementAt(widget.index ?? 0)
          ),
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        unselectedItemColor: darkMode ? Colors.white : Colors.black,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w800),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(AppIcons.chat, size: 25),
            label: 'Message',
            backgroundColor: kPrimaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Friends',
            backgroundColor: kPrimaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_outlined, size: 28,),
            label: 'Profile',
            backgroundColor: kPrimaryColor,
          ),
          BottomNavigationBarItem(
            icon: new Stack(
              children: <Widget> [
                Icon(Icons.notifications, size: 27),
                Positioned(
                  top: 2.0,
                  right: 2.0,
                  child: StreamBuilder(
                    stream:FirebaseDatabase.instance.reference().child('notifications').child("sendBy").child(currentUser.id).child("number").onValue,
                    builder:(context, AsyncSnapshot<Event> event){        
                      if (event.hasData) {
                        if(event.data!.snapshot.value != null){
                          notificationCounter = event.data!.snapshot.value;
                          if(notificationCounter != 0)
                            return  Container(
                              padding: EdgeInsets.all(2),
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                notificationCounter.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              )                                                                
                            );
                          return Text("");
                        }
                      }
                      return Text(""); 
                    }
                  )                  
                )
              ],
            ),
            label: 'Notifications',
            backgroundColor: kPrimaryColor,
          ),
        ],
        currentIndex: widget.index ?? 0,
        selectedItemColor: Colors.red,
        onTap: (index) {
          setState(() {
            widget.index = index;
          }
        );}          
      )      
    );
  }
}
