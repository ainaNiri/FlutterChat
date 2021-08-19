import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/friendModel.dart';
import 'package:myapp/screens/chatDetailPage.dart';
import 'package:myapp/models/constants.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ConversationList extends StatelessWidget{
  int range;

  ConversationList({required this.range});

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
                  var _friends = context.read<FriendsModel>();
                  _friends.friends[index].lastMessageType = "read";
                   Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (contenxt ) => ChatDetailPage(id: _friends.friends[index].chatId, friend: _friends.friends[index].toUser()))
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Consumer<FriendsModel>(
                    builder: (context, model, child){
                      return Column(
                        children: <Widget>[
                          CircleAvatar(
                            maxRadius: 30,
                            backgroundImage:NetworkImage(model.friends[index].image),
                          ),
                          SizedBox(height: 10,),
                          Text(model.friends[index].name, style: TextStyle(color: textPrimaryColor, fontSize: 15, fontWeight: FontWeight.w600))                    
                        ],
                      );
                    }
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
                child: InkWell(
                  hoverColor: Colors.grey.shade100,
                  //splashColor: Colors.transparent,
                  highlightColor: Colors.white12,
                  onTap: () async {
                    var _friends = context.read<FriendsModel>();
                    _friends.friends[index].lastMessageType = "read";
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (contenxt ) => ChatDetailPage(id:_friends.friends[index].chatId, friend: _friends.friends[index].toUser()))
                    );
                  },
                  child:Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10 ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[                           
                              Consumer<FriendsModel>(
                                builder:(context, model, child){
                                  return CircleAvatar(
                                    maxRadius: 30,
                                    backgroundImage:NetworkImage(model.friends[index].image),
                                  );
                                }
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Consumer<FriendsModel>(
                                      builder:(context, model, child){
                                        return Text(model.friends[index].name, style: TextStyle(
                                          color: textPrimaryColor,
                                          fontSize: 15, 
                                          fontWeight: model.friends[index].lastMessageType == "read" ? FontWeight.w600 :FontWeight.bold
                                        ));
                                      }
                                    ),                                     
                                    SizedBox(height: 6),
                                    Container(
                                      constraints: BoxConstraints(maxHeight: 16, maxWidth: MediaQuery.of(context).size.width/2),
                                      child: Consumer<FriendsModel>(
                                        builder:(context, model, child){
                                          return Text(
                                            model.friends[index].lastMessageContent, 
                                            overflow: TextOverflow.ellipsis, 
                                            style: TextStyle(
                                              fontSize: 13, 
                                              color: textSecondaryColor, 
                                              fontWeight: model.friends[index].lastMessageType == "read" ? FontWeight.normal : FontWeight.bold 
                                            )                                         
                                          );
                                        }                                                                                    
                                      )
                                    )                                                                     
                                  ],                                 
                                )                               
                              )
                            ]
                          )
                        ),
                        Consumer<FriendsModel>(
                          builder:(context, model, child){
                            return Text(
                              DateTime.parse(model.friends[index].lastMessageTime).hour.toString() + " : " + DateTime.parse(model.friends[index].lastMessageTime).minute.toString(),
                              style: TextStyle(color: textPrimaryColor ,fontSize: 12, fontWeight: model.friends[index].lastMessageType == "read" ? FontWeight.normal : FontWeight.bold)                       
                            );
                          }
                        )                                                                            
                      ] 
                    
                  )
                ))
              );
            }
          )
        )
      ]
    );
  }
}

