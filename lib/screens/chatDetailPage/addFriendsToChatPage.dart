import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/utilities/variables.dart';
import 'package:myapp/providers/friendModel.dart';
import 'package:myapp/utilities/firebaseStorage.dart';
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
    var friendsModel = context.watch<FriendsModel>();
    return Material(
      color: kPrimaryColor,
      child: Container(
        padding: EdgeInsets.all(widget.isNew ? 0.0 : 10),
        margin: EdgeInsets.only(top: 20, bottom: widget.isNew ? 0.0 : 20),
        color: kPrimaryColor,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: FirebaseDatabase.instance.reference().child("chats/members").child(widget.chatId).once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot){
                  if(snapshot.hasData || widget.isNew){
                    if(snapshot.data != null){
                      Map<dynamic, dynamic> members = snapshot.data!.value;
                      return ListView.builder(
                        itemCount: friendsModel.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index){
                          if(!friendsModel.friends[index].isInChat(members) && !friendsModel.friends[index].chatId.startsWith("grp"))
                            return CheckboxListTile(
                              activeColor: Colors.blue,
                              value: selectedFriendsId.contains(friendsModel.friends[index].id),
                              title: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(friendsModel.friends[index].image),
                                    maxRadius: 30,
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.04,),
                                  Text(
                                    friendsModel.friends[index].name,
                                    style: TextStyle(color: textPrimaryColor)
                                  )
                                ],
                              ),
                              onChanged: (selected){
                                setState((){
                                  if (selected == true) {
                                    setState(() {
                                      selectedFriendsId.add(friendsModel.friends[index].id);
                                    });
                                  }
                                  else{
                                    setState(() {
                                      selectedFriendsId.remove(friendsModel.friends[index].id);
                                    });
                                  }
                                });
                              },
                            );
                          else
                            return Container();
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator()); 
                  }
                  else{ 
                    return Center(child: CircularProgressIndicator());                   
                  }
                }
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
