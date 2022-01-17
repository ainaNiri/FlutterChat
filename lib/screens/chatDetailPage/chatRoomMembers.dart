import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/widgets/userList.dart';
import 'package:flutter/material.dart';

class ChatRoomMembers extends StatelessWidget {
  final String chatId;
  ChatRoomMembers({ Key? key, required this.chatId }) : super(key: key);

  List<User> members = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container (
          padding: EdgeInsets.only(top: 20),
          color: kPrimaryColor,
          child: Column(
            children: [
              Center(
              child: Container(
                margin: EdgeInsets.only(top: 35, bottom: 15),
                child: Text("Members", style: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold, fontSize: 30)),
              )
              ),
             FutureBuilder(
                future: FirebaseDatabase.instance.reference().child("chats/members").child(chatId).once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot){
                  if(snapshot.hasData){
                    if(snapshot.data != null){
                      snapshot.data!.value.forEach((key, value){
                        members.add(new User(id: key, name: value["name"], image: value["image"]));
                      });
                      return ListUser(users: members, isForSearch: true,);
                    }               
                  }
                  return Container();
                },
              ),
            ],
          ),
        )
      )
    );
  }
}