import 'package:flutter/material.dart';
import 'package:myapp/models/constants.dart';
import 'package:myapp/models/friendModel.dart';
import 'package:myapp/screens/profilePage.dart';
import 'package:provider/provider.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({ Key? key }) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {

  @override
  Widget build(BuildContext context) {
    var _friends = context.watch<FriendsModel>();
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Text("Friends", style: TextStyle(color: textSecondaryColor, fontWeight: FontWeight.bold, fontSize: 30)),
              )
            ),
            !_friends.isEmpty() ?   
                Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 5),
                child: ListView.builder(
                  itemCount: _friends.length(),
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    if(_friends.friends[index].id.isNotEmpty)
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(_friends.friends[index].image),
                          radius: 25,
                        ),
                        title: Text(_friends.friends[index].name, style: TextStyle(color: textPrimaryColor)),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage(icon: Icon(Icons.message), person: _friends.friends[index].toUser(), friend: "Message"))
                        )
                      );
                    else return Container();
                  },
                )
             ) :Consumer<FriendsModel>(
                builder:(context, model, child){        
                  if(!model.isEmpty()){
                    return ListView.builder(
                      itemCount: model.length(),
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        if(_friends.friends[index].id.isNotEmpty)
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(model.friends[index].image),
                              radius: 25,
                            ),
                            title: Text(model.friends[index].name, style: TextStyle(color: textPrimaryColor)),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfilePage(icon: Icon(Icons.message), person: model.friends[index].toUser(), friend: "Message"))
                            )
                          );
                        else return Container();
                      },
                    );
                  }
                  else
                    return Container();               
                }             
             )
          ]
        ) 
      )
    );
  }
}