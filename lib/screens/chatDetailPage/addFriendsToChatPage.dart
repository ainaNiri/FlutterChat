import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatMembersModel.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/models/friendModel.dart';
import 'package:myapp/utilities/function.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddFriendsToChat extends StatefulWidget {
  String chatId;
  String? chatName;
  File? chatImage;
  bool isNew;
  GlobalKey<FormState>? formkey;
  AddFriendsToChat({ Key? key , required this.chatId, this.chatName, this.isNew = false, this.chatImage, this.formkey}) : super(key: key);

  @override
  _AddFriendsToChatState createState() => _AddFriendsToChatState();
}

class _AddFriendsToChatState extends State<AddFriendsToChat> {
  List<String> selectedFriendsId = [];

  @override
  Widget build(BuildContext context) {
    var chatMembers = context.watch<ChatMembersModel>();
    return Material(
      child: Container(
        padding: EdgeInsets.all(widget.isNew ? 0.0 : 10),
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<FriendsModel>(
                  builder: (context, model, child) => ListView.builder(
                  //primary: true,
                  itemCount: model.length(),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    if(!model.friends[index].isInChat(chatMembers) && !widget.isNew && !model.friends[index].chatId.startsWith("grp"))
                      return CheckboxListTile(
                        activeColor: Colors.blue,
                        value: selectedFriendsId.contains(model.friends[index].id),
                        title: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(model.friends[index].image),
                              maxRadius: 30,
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.04,),
                            Text(
                              model.friends[index].name,
                              style: TextStyle(color: textPrimaryColor)
                            )
                          ],
                        ),
                        onChanged: (selected){
                          setState((){
                            if (selected == true) {
                              setState(() {
                                selectedFriendsId.add(model.friends[index].id);
                              });
                            }
                            else{
                              setState(() {
                                selectedFriendsId.remove(model.friends[index].id);
                              });
                            }
                          });
                        },
                      );
                    else
                      return Container();
                  },
                  )
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async {
                  if (widget.formkey!.currentState!.validate() && widget.chatName != null){
                    widget.chatId = FirebaseDatabase.instance.reference().child("chats/chatsroom").push().key;
                    String? image; 
                    if(widget.chatImage != null){
                      image = await uploadPic(widget.chatImage ?? File(""), widget.chatId);
                    }
                    addFriendsToChat(selectedFriendsId, widget.chatId, widget.chatName, image);
                  }
                  else if(widget.chatName == null)
                    addFriendsToChat(selectedFriendsId, widget.chatId, widget.chatName, widget.chatImage.toString());
                },
                child: Text(widget.isNew ? "Create" : "Add"),
                style: buttonStyle
              )
            )
          ]
        ),
      ),
    );
  }
}
