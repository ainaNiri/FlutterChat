import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/screens/FriendsPage.dart';
import 'package:myapp/screens/notificationsPage.dart';
import 'package:myapp/screens/profilePage.dart';
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
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context
      ),
      drawer: BuildDrawer(

      ),
      body: _widgetOptions.elementAt(widget.index ?? 0),
      bottomNavigationBar: BottomNavigationBar( 
        unselectedItemColor: Colors.black87,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w800),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_outlined, size: 28,),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: new Stack(
              children: <Widget> [
                Icon(Icons.notifications, size: 25),
                notificationCounter != 0 ? new Positioned(
                  left: 10,
                  bottom: 10,
                  child: StreamBuilder(
                    stream:FirebaseDatabase.instance.reference().child('notifications').child(currentUser['id']).onValue,
                    builder:(context, AsyncSnapshot<Event> snapshot){        
                      if (snapshot.hasData) {
                        if(snapshot.data!.snapshot.value != null){
                          notificationCounter = snapshot.data!.snapshot.value.length;
                          return  Container(
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
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
                        }
                      }
                      return Text(""); 
                    }
                  )                  
                ) : new Container()
              ],
            ),
            label: 'Notifications',
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