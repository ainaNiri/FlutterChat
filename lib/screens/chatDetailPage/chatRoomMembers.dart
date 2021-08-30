import 'package:myapp/models/chatMembersModel.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/widgets/userList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomMembers extends StatelessWidget {
  final String chatId;
  ChatRoomMembers({ Key? key, required this.chatId }) : super(key: key);

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
              Consumer<ChatMembersModel>(
                builder: (context, model, child){
                  if(!model.isEmpty()){
                    return ListUser(users: model.members, isForSearch: true,);               
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