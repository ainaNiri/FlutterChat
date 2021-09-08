import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/models/chatMembersModel.dart';
import 'package:myapp/screens/chatDetailPage/addFriendsToChatPage.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/utilities/firebaseStorage.dart';
import 'package:provider/provider.dart';

class CreateChatGroupPage extends StatefulWidget {
  const CreateChatGroupPage({ Key? key }) : super(key: key);

  @override
  _CreateChatGroupPageState createState() => _CreateChatGroupPageState();
}

class _CreateChatGroupPageState extends State<CreateChatGroupPage> {
  TextEditingController nameController = new TextEditingController();
  File _image = new File("");
  final _formKey = GlobalKey<FormState>();
  bool _imageChanged = false;

  @override
  void dispose(){
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: _imageChanged ? FileImage(_image) : AssetImage("assets/images/chat.jpeg") as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0.1,                   
                    right: 0.1,
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(Icons.add_a_photo, color: iconSecondaryColor,),
                      onPressed: () async {
                        _image = await getImage();
                        setState((){                 
                          _imageChanged = true;
                        });
                      },
                    )
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height - 260,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter a name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(color: textSecondaryColor),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textPrimaryColor)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: textPrimaryColor))
                      ),
                      style: TextStyle(color: textPrimaryColor),
                      controller: nameController,
                    ),
                    Flexible(
                      child: ChangeNotifierProvider(create: (_) => 
                        ChatMembersModel("") ,child: AddFriendsToChat(formkey: _formKey, chatId: "", chatName: nameController.text, chatImage: _image, isNew: true,)
                      )
                    )
                  ]
                ),
              )
            )
          ],
        )
      ),
    );
  }
}