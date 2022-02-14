import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/screens/createChatGroupPage.dart';
import 'package:myapp/utilities/variables.dart';
import 'package:myapp/providers/friendModel.dart';
import 'package:myapp/widgets/conversationList.dart';
import 'package:myapp/widgets/routeAnimation.dart';
import 'package:provider/provider.dart';


// ignore: must_be_immutable
class ChatPage extends StatefulWidget{

  @override
  _ChatPageState createState() => _ChatPageState();
  
}

class _ChatPageState extends State<ChatPage>{

  DateTime _lastQuitTime = DateTime.now();

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async {
        if (DateTime.now().difference(_lastQuitTime).inSeconds > 3) {
          print ('press the back button again to exit ');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Press back button again ')));
          _lastQuitTime = DateTime.now();
          return false;
        } else {
          print ('exit ');
          SystemNavigator.pop();
          return true;
        }
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top:15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text("Conversation", style:TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimaryColor), )
                      ),
                      TextButton.icon(
                        onPressed: () =>
                          Navigator.of(context).push(
                            createRoute(CreateChatGroupPage())
                        ),
                        icon: Icon(Icons.add, color: Colors.red),
                        label: Text("Add new", style: TextStyle(color: Colors.red, fontSize: 15)),
                      )
                    ]
                  )
                )
              ),
              SizedBox(height: 20.0,),
              Container(
                child:Consumer<FriendsModel>(
                  builder: (context, model, child){
                    chatPagefirstRendering = false;
                    if(model.isEmpty)
                      // return Center(child: CircularProgressIndicator());
                      return _buildAlias();                   
                    else{
                      if(model.friends.last.lastMessageContent == " ")
                        return _buildAlias();
                      model.sort();
                      return ConversationList(range: model.length, friends: model);
                    }                  
                  },
                )                                          
              )            
            ]
          )
        )   
      ),
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

