import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/constants.dart';
import 'package:myapp/models/friendModel.dart';
import 'package:myapp/widgets/conversationList.dart';
import 'package:provider/provider.dart';


// ignore: must_be_immutable
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
        color: kPrimaryColor,
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
                    Text("Conversation", style:TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimaryColor), ),
                  ]
                )
              )
            ),
            SizedBox(height: 15.0,),
            Container(
              child: chatPagefirstRendering ? Consumer<FriendsModel>(
                builder: (context, model, child){
                  chatPagefirstRendering = true;
                  if(model.isEmpty())
                    // return Center(child: CircularProgressIndicator());
                    return _buildAlias();                   
                  else 
                    return ConversationList(range: model.length());                  
                },
              ) : ConversationList(range: Provider.of<FriendsModel>(context, listen: false).length())                                             
            )            
          ]
        )
      )   
    );
  }
  
  Widget _buildAlias(){
    return Container(
      child: Column(
      children: <Widget>[
        Container(
          height: 120,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 15.0),
            itemCount: 2,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.grey.shade100
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: 70,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade100
                        ),
                      ),          
                    ],
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
            itemCount: 2,
            shrinkWrap: true,
            itemBuilder: (context, index){
              return Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10 ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[                           
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.grey.shade100
                                ),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 70,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey.shade100
                                    ),
                                  ),                                     
                                  SizedBox(height: 6),
                                  Container(
                                    width: 110,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey.shade100
                                    ),
                                  ),                                                            
                                ],                                 
                              )                                                            
                            ]
                          )
                        ),
                        Container(
                          width: 70,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.shade100
                          ),
                        ),                                                                          
                      ]                     
                  )
                );
              }
            )
          )
        ]
      )
    );
  }
}

