import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/models/friendModel.dart';
import 'package:myapp/screens/profilePage.dart';
import 'package:myapp/widgets/userList.dart';
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
                child: ListUser(isForSearch: false, users: _friends.toUsers().where((element) => !element.id.startsWith("grp")).toList())
              ) :Consumer<FriendsModel>(
                builder:(context, model, child){        
                  if(!model.isEmpty()){
                    return  ListUser(isForSearch: false, users: model.toUsers().where((element) => !element.id.startsWith("grp")).toList());                  
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