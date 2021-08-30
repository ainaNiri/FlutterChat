import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/utilities/function.dart';
import 'package:myapp/widgets/hero.dart';

// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  String image;
  bool isForChat;
  String? chatId;
  EditProfile({ Key? key , required this.image, required this.isForChat, this.chatId}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _imageNetwork = "";
  File _imageFile = new File("");
  bool _imageChanged = false;
  TextEditingController nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _imageNetwork = widget.image;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height * 0.05)),
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Hero(
                  tag: "image",
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: _imageChanged ? FileImage(_imageFile) : NetworkImage(_imageNetwork) as ImageProvider,
                  ),
                ),
                onTap: () => showHero(context, _imageChanged ? _imageFile : _imageNetwork, ""),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: ()async {
                  _imageFile = await getImage();
                  setState((){
                    _imageChanged = true;
                  });
                },
                child: Center(
                  child: Text("Change"),
                ),
                style: buttonStyle
              ),
              SizedBox(height: 70,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: textSecondaryColor),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textPrimaryColor)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: textPrimaryColor))
                ),
                style: TextStyle(color: textPrimaryColor),
                controller: nameController,
              ),
              SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () async {
                  if(_imageChanged){
                    _imageNetwork = await uploadPic(_imageFile, "profile");
                  }
                  if(widget.isForChat){
                    if(nameController.text.isNotEmpty)
                      await _updateChatProfile("name", nameController.text);
                    if(_imageChanged)
                      await _updateChatProfile("image", _imageNetwork);                    
                  }
                  else
                    if(nameController.text.isNotEmpty || _imageChanged){
                      await _updateProfile("users/users_friends", "users/users_friends",  nameController.text, _imageNetwork);
                      await _updateProfile("notifications/sendTo", "notifications/sendBy",  nameController.text, _imageNetwork);
                    }
                },
                child: Center(
                  child: Text("Save"),
                ),
                style: buttonStyle
              )
            ]
          ),
        )
      ),
    );
  }

   Future <void> _updateProfile(String dbRef, String updateRef ,String  updateName, String updateImage,) async {
    await FirebaseDatabase.instance.reference().child(dbRef).child(currentUser.id).once().then((snap) async {
      Map <String, dynamic> nameUpdate = Map();
      Map <String, dynamic> imageUpdate = Map();
      snap.value.forEach((key, value){
        if(updateName.isNotEmpty)
          nameUpdate["$updateRef/$key/${currentUser.id}/name"] = updateName;
        if(_imageChanged)
          imageUpdate["$updateRef/$key/${currentUser.id}/image"] = updateImage;       
      });
      if(updateName.isNotEmpty){
        nameUpdate["users/users_profile/${currentUser.id}/name"] = updateName;     
        await FirebaseDatabase.instance.reference().update(nameUpdate);
      }
      if(_imageChanged){
        imageUpdate["users/users_profile/${currentUser.id}/image"] = updateImage;     
        await FirebaseDatabase.instance.reference().update(imageUpdate);
      }
    });
  }

  Future <void> _updateChatProfile(String basename, String update) async{
    await FirebaseDatabase.instance.reference().child("chats/chatsroom/${widget.chatId}").update({basename : update});
  }
}