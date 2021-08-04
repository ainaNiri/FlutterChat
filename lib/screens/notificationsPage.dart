import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatMessageModel.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/models/colorModel.dart';
import 'package:myapp/screens/profilePage.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({ Key? key }) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  List<dynamic> notifications = [];
  List<String> text =[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 5),
        child: StreamBuilder(
          stream: FirebaseDatabase.instance.reference().child("notifications").child(currentUser["id"]).onValue,
          builder: (context, AsyncSnapshot<Event> snapshot){
            if(snapshot.hasData){
              if(snapshot.data!.snapshot.value != null){
                notifications.clear();
                text.clear();
                Map<dynamic, dynamic> friends = snapshot.data!.snapshot.value;
                friends.forEach((key, value) {
                  notifications.add(value);
                  text.add("Accept");
                });
              }
              return ListView.builder(
                itemCount: notifications.length,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(notifications[index]['image']),
                      radius: 25,
                    ),
                    title: Text(notifications[index]["name"]),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage(icon: Icon(Icons.message), person: notifications[index], friend: text[index]))
                    ),
                    trailing: ElevatedButton(
                      onPressed: ()async {
                        addFriend(notifications[index]);
                        await FirebaseDatabase.instance.reference().child("notifications").child(currentUser["id"]).child(notifications[index]["id"]).remove();
                        setState((){ text[index] = "Message";});
                      },
                      child: Text( text[index], style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(getColor),
                      )
                    ),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator.adaptive());
          }
        )
      )
    );
  }
  void addFriend(dynamic friend) async{
    // ignore: await_only_futures
    final db =  await FirebaseDatabase.instance.reference();
    await db.child('users').child(currentUser['id']).child('friends').child(friend['id']).set({
      'image': friend['image'],
      'lastMessages': {'content': " ", 'time': " "},
      'name': friend['name']
    });
     await db.child('users').child(friend['id']).child('friends').child(currentUser['id']).set({
      'image': currentUser['image'],
      'lastMessages': {'content': " ", 'time': " "},
      'name': currentUser['name']
    });
  }
}