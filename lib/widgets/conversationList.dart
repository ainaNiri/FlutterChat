import 'package:flutter/material.dart';
import 'package:myapp/models/friendModel.dart';
import 'package:myapp/screens/chatDetailPage/messagePage.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/utilities/date.dart';
import 'package:myapp/widgets/userAvatar.dart';

// ignore: must_be_immutable
class ConversationList extends StatelessWidget{
  int range;
  FriendsModel friends;
  ConversationList({required this.range, required this.friends});

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
              return GestureDetector(
                onTap: ()async {
                  this.friends.friends[index].lastMessageType = "read";
                   Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (contenxt ) => ChatDetailPage(id: this.friends.friends[index].chatId, friend: this.friends.friends[index].toUser(), friendConnected: this.friends.friends[index].connected,))
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                        children: <Widget>[
                          UserAvatar(
                            this.friends.friends[index].image,
                            this.friends.friends[index].connected,
                            30
                          ),
                          SizedBox(height: 10,),
                          Text(this.friends.friends[index].name, style: TextStyle(color: textPrimaryColor, fontSize: 15, fontWeight: FontWeight.w600))                    
                        ],
                      )                 
                )
              );
            }
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.only(left: 5, right: 5),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: range,
            shrinkWrap: true,
            itemBuilder: (context, index){
              return Material(
                color: kPrimaryColor,
                child: Container(
                  child: ListTile(
                    contentPadding: EdgeInsets.fromLTRB(12, 0, 18, 0),
                    focusColor: Colors.grey[50],
                    onTap: () async {                    
                      this.friends.friends[index].lastMessageType = "read";
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (contenxt ) => ChatDetailPage(id:this.friends.friends[index].chatId, friend: this.friends.friends[index].toUser(), friendConnected: this.friends.friends[index].connected,))
                      );
                    },
                    leading: UserAvatar(
                      this.friends.friends[index].image,
                      this.friends.friends[index].connected,
                      30                                           
                    ),
                    title: Text(this.friends.friends[index].name, style: TextStyle(
                        color: textPrimaryColor,
                        fontSize: 15, 
                        fontWeight: this.friends.friends[index].lastMessageType == "read" ? FontWeight.w600 :FontWeight.bold
                      )                 
                    ),                                     
                    subtitle:  Container(
                      constraints: BoxConstraints(maxHeight: 16, maxWidth: MediaQuery.of(context).size.width/2),
                      child: Text(
                        this.friends.friends[index].lastMessageContent == " " ? "Say hello to your new friend" : this.friends.friends[index].lastMessageContent, 
                        overflow: TextOverflow.ellipsis, 
                        style: TextStyle(
                          fontSize: 13, 
                          color: textSecondaryColor, 
                          fontWeight: this.friends.friends[index].lastMessageType == "read" ? FontWeight.normal : FontWeight.bold 
                        )                                                                  
                      )                                                                                                                                       
                    ),                                                      
                    trailing: Text(
                      getDate(this.friends.friends[index].lastMessageTime),
                      style: TextStyle(color: textPrimaryColor ,fontSize: 12, fontWeight: this.friends.friends[index].lastMessageType == "read" ? FontWeight.normal : FontWeight.bold)                                            
                    )                                                                                                                    
                  ),
                ),
              );
            }
          )                                
        )
      ]
    );
  }
}

