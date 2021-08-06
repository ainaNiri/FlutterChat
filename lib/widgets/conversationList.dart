import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatMessageModel.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:provider/provider.dart';
import '../screens/chatDetailPage.dart';

// ignore: must_be_immutable
class ConversationList extends StatelessWidget{
  int range;
  Map<dynamic, dynamic> person;
  ConversationList({required this.range, required this.person});
  String userId = "";
  String userName = "";
  String userImage = "";
  String messageContent = "";
  String messageTime= "";

  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Container(
          height: 120,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 10.0),
            itemCount: range,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              userId = person.keys.elementAt(index);
              userName = person[person.keys.elementAt(index)]["name"];
              userImage = person[person.keys.elementAt(index)]["image"];
              return GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatDetailPage(id: userId, person: person,)));
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        maxRadius: 30,
                        backgroundImage:NetworkImage(userImage),
                      ),
                      SizedBox(height: 10,),
                      Text(userName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))                    
                    ],
                  )
                )
              );
            }
          ),
        ),
        Container(
          padding: EdgeInsets.all(6),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: range,
            shrinkWrap: true,
            itemBuilder: (context, index){
              userId = person.keys.elementAt(index);

              userName = person[person.keys.elementAt(index)]["name"];
              userImage = person[person.keys.elementAt(index)]["image"];
              messageContent = person[person.keys.elementAt(index)]["lastMessages"]["content"];
              messageTime = person[person.keys.elementAt(index)]["lastMessages"]["time"];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){return ChatDetailPage(id: userId, person: person,);}));
                },
                child: Container(
                  color: Colors.white70,
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10 ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[                           
                            CircleAvatar(
                              maxRadius: 30,
                              backgroundImage:NetworkImage(userImage),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                color: Colors.transparent,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(userName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),                                     
                                      SizedBox(height: 6),
                                      Container(
                                        constraints: BoxConstraints(maxHeight: 16, maxWidth: MediaQuery.of(context).size.width/2),
                                        child: Text(
                                          messageContent, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.normal )
                                        )                                                                                       
                                      )                                                                     
                                  ],                                 
                                )
                              )
                            )
                          ]
                        )
                      ),
                      Text(
                          DateTime.parse(messageTime).hour.toString() + " : " + DateTime.parse(messageTime).minute.toString(),
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)
                        )                                                                            
                    ] 
                  
                )
              ));
            }
          )
        )
      ]
    );
  }
}

