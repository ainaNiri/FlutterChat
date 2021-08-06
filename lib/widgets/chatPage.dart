import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatMessageModel.dart';
import 'package:myapp/widgets/conversationList.dart';
import '../models/chatUsersModel.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget{
  
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        color: Colors.grey.shade100,
        margin: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top:10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Conversation", style:TextStyle(fontSize: 32, fontWeight: FontWeight.bold), ),
                  ]
                )
              )
            ),
            SizedBox(height: 15.0,),
            Container(
              child: !friendAdded ? StreamBuilder(
                stream:FirebaseDatabase.instance.reference().child('users').child(currentUser['id']).child("friends").onValue,
                builder:(context, AsyncSnapshot<Event> snapshot){        
                  if (snapshot.hasData) {
                    chatPagefirstRendering = true;
                    friendAdded = false;
                    if(snapshot.data!.snapshot.value != null){
                      //lists.clear();
                      friend = snapshot.data!.snapshot.value;
                      friend.forEach((key, value) {
                        friend[key]['id'] = key;
                      });
                    return ConversationList(
                      range: friend.length,
                      person: friend,
                    );
                  }}
                  return Center(child: CircularProgressIndicator(),);
                }
              ) : ConversationList(
                  range: friend.length,
                  person: friend,
                )
            ) 
          ]
        )
      )   
    );
  }
}
