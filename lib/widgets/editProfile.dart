import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/utilities/variables.dart';
import 'package:myapp/utilities/firebaseStorage.dart';
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
  void dispose(){
    nameController.dispose();
    super.dispose();
  }

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
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context){ return ImageView(image: _imageChanged ? _imageFile : _imageNetwork, index: "",);})
                ),
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
                    if(nameController.text.isNotEmpty || _imageChanged)
                      await _updateProfile("chats/members", "users/users_friends",  nameController.text, _imageNetwork, widget.chatId!, "name", "image", false);                 
                  }
                  else
                    if(nameController.text.isNotEmpty || _imageChanged){
                      await _updateProfile("users/users_friends", "users/users_friends",  nameController.text, _imageNetwork, currentUser.id, "name", "image", true);
                      await _updateProfile("notifications/sendTo", "notifications/sendBy",  nameController.text, _imageNetwork, currentUser.id, "name", "image", false);
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

   Future <void> _updateProfile(String dbRef, String updateRef ,String  updateName, String updateImage, String dbPath, String namePath, String imagePath, bool changeUser) async {
    await FirebaseDatabase.instance.reference().child(dbRef).child(dbPath).once().then((snap) async {
      Map <String, dynamic> nameUpdate = Map();
      Map <String, dynamic> imageUpdate = Map();
      snap.value.forEach((key, value){
        if(value["chatId"].toString().startsWith("grp") && dbRef == "users/users_friends"){
          if(updateName.isNotEmpty)
          nameUpdate["chats/members/$key/$dbPath/name"] = updateName;
          if(_imageChanged)
            imageUpdate["chats/members/$key/$dbPath/image"] = updateImage;  
        }
        else{
          if(updateName.isNotEmpty)
            nameUpdate["$updateRef/$key/$dbPath/name"] = updateName;
          if(_imageChanged)
            imageUpdate["$updateRef/$key/$dbPath/image"] = updateImage;
        }       
        });
      if(changeUser){
        if(updateName.isNotEmpty){
          nameUpdate["users/users_profile/${currentUser.id}/name"] = updateName;     
        }
        if(_imageChanged){
          imageUpdate["users/users_profile/${currentUser.id}/image"] = updateImage;     
        }
      }
      if(updateName.isNotEmpty)
        await FirebaseDatabase.instance.reference().update(nameUpdate);
      if(_imageChanged)
        await FirebaseDatabase.instance.reference().update(imageUpdate);
    });
  }
}