import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/screens/profilePage.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({ Key? key }) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Text("Friends", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 30)),
              )
            ),         
            Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 5),
            child: ListView.builder(
              itemCount: friend.length,
              shrinkWrap: true,
              itemBuilder: (context, index){
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(friend[friend.keys.elementAt(index)]["image"]),
                    radius: 25,
                  ),
                  title: Text(friend[friend.keys.elementAt(index)]["name"]),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage(icon: Icon(Icons.message), person: friend[friend.keys.elementAt(index)], friend: "Message"))
                  )
                );
              },
            )
          )
        ]
      ))
    );
  }
}