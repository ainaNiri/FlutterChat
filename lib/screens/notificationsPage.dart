import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/screens/profilePage.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({ Key? key }) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  List<User> notifications = [];
  List<String> text =[];
  List<bool> isFriend = [];

  @override
  void initState(){
    super.initState();
    FirebaseDatabase.instance.reference().child("notifications/sendBy").child(currentUser.id).child("number").set(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 5),
        child: FutureBuilder(
          future: FirebaseDatabase.instance.reference().child("notifications").child("sendBy").child(currentUser.id).once(),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.data?.value != null){
                notifications.clear();
                text.clear();
                Map<dynamic, dynamic> friends = snapshot.data!.value;
                friends.forEach((key, value) {
                  if(key != "number"){
                    notifications.add(User(
                      id: key,
                      image: value["image"],
                      name: value["name"]
                      )
                    );
                    text.add("Accept");
                    isFriend.add(value["isFriend"]);
                  }
                });
              if(notifications.isNotEmpty)
                return ListView.builder(
                  itemCount: notifications.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    if(isFriend[index])  
                      return _acceptedInvitation(notifications[index]);
                    else return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(notifications[index].image),
                        radius: 25,
                      ),
                      focusColor: Colors.grey[50],
                      title: Text(notifications[index].name, style: TextStyle(color: textPrimaryColor)),
                      onTap: () async {
                        if(isFriend[index])
                          await FirebaseDatabase.instance.reference().child('notifications').child("sendBy").child(notifications[index].id).child(currentUser.id).remove();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage(icon: Icon(Icons.message), person: notifications[index], friend: text[index]))
                        );
                      },
                      trailing: ElevatedButton(
                        onPressed: ()async {
                          await addFriend(notifications[index]);                      
                          text[index] = "Message";
                          setState((){
                            
                          });
                        },
                        child: Text(text[index], style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        style: smallButtonStyle(Colors.indigo)
                      ),
                    );
                  },
                );
                else
                  return Center(child: Text("You don't have any notifications", style: TextStyle(color: textPrimaryColor)));
              }
              return Center(child: Text("You don't have any notifications", style: TextStyle(color: textPrimaryColor)));
            }
            return Center(child: CircularProgressIndicator.adaptive());
          }
        )
      )
    );
  }

  Future <void> addFriend(User friend) async{
    late String chatId;
    final chatRef = FirebaseDatabase.instance.reference().child("chats");
    final userRef =  FirebaseDatabase.instance.reference().child("users/users_friends");

    chatId = chatRef.child("chatsroom").push().key; 
    await chatRef.child("chatsroom").child(chatId).set({
      "lastMessage": " ",
      "timestamp": DateTime.now().toString(),
    });

    await chatRef.child("members").child(chatId).set({
      currentUser.id: true,
      friend.id: true
    });

    await userRef.child(currentUser.id).child(friend.id).set({
      "name": friend.name,
      "image": friend.image,
      "chatId": chatId 
    });
    await userRef.child(friend.id).child(currentUser.id).set({
      "name": currentUser.name,
      "image": currentUser.image,
      "chatId": chatId
    });
    await FirebaseDatabase.instance.reference().child("notifications/sendBy").child(friend.id).child(currentUser.id).set({
      "name": currentUser.name,
      "image": currentUser.image,
      "chatId": chatId,
      "isFriend": true, 
    });
    await FirebaseDatabase.instance.reference().child("notifications/sendBy").child(friend.id).child("number").once().then((value) async {
      await  FirebaseDatabase.instance.reference().child("notifications/sendBy").child(currentUser.id).child("number").set((value.value)+1);     
    });

    await FirebaseDatabase.instance.reference().child("notifications/sendTo").child(currentUser.id).set({friend.id : true});
    await FirebaseDatabase.instance.reference().child("notifications/sendTo").child(friend.id).child(currentUser.id).remove();
  }

  Widget _acceptedInvitation(User user){
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.image),
        radius: 25,
      ),
      focusColor: Colors.grey[50],
      title: Text(user.name, style: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w500)),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(icon: Icon(Icons.message), person: user, friend: "Message"))
      ),
      subtitle: Text("has accepted your invitation", style: TextStyle(color: textSecondaryColor)),
    );   
  }
}