import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:myapp/models/chatMembersModel.dart';
import 'package:myapp/models/messageModel.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/screens/chatDetailPage/optionsPage.dart';
import 'package:myapp/screens/profilePage.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/utilities/function.dart';
import 'package:myapp/screens/chatDetailPage/addFriendsToChatPage.dart';
import 'package:myapp/widgets/dialog.dart';
import 'package:myapp/widgets/hero.dart';
import 'dart:async';

import 'package:provider/provider.dart';


// ignore: must_be_immutable
class ChatDetailPage extends StatefulWidget {
  String id;
  User friend;
  ChatDetailPage({required this.id, required this.friend, });

  @override
  _ChatDetailPage createState() => _ChatDetailPage();
}

class _ChatDetailPage extends State<ChatDetailPage> {
  List<Message> messages = [];
  final ScrollController _controller = ScrollController();
  final messageController = TextEditingController();
  final db = FirebaseDatabase.instance.reference();
  bool _needsScroll = false;
  
  void initState(){
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if(_controller.hasClients){
        _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,);
      }}
    );
  }

  void dispose(){
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     if (_needsScroll) {
      Future.delayed(Duration(microseconds: 
      500),(){
      WidgetsBinding.instance!.addPostFrameCallback(
        (_) {if(_controller.hasClients){
          _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,);
        }});});
      _needsScroll = false;
    }

    return Scaffold(
      backgroundColor: kPrimaryColor,
      resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: inputColor,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: iconColor),
                ),
                SizedBox(width: 2),                 
                IconButton(
                  padding: EdgeInsets.all(1),
                  iconSize: 40,
                  splashRadius: 30,
                  icon: CircleAvatar(
                    maxRadius: 25,
                    backgroundImage:NetworkImage(widget.friend.image ),
                  ),
                  onPressed: () {
                    if(widget.id.startsWith("grp"))
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => OptionsPage(chatId: widget.id, chatName: widget.friend.name, chatImage:  widget.friend.image))
                      );
                    else 
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => ProfilePage(icon: Icon(Icons.message), person: widget.friend, friend: "Message", chatId: widget.id,))
                    );
                  }
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.friend.name ,
                        style: TextStyle(
                          color: textPrimaryColor, fontSize: 15, fontWeight: FontWeight.w600)
                      ),
                      SizedBox(height: 6),
                      Text("Online",
                        style: TextStyle(
                          color: textSecondaryColor, fontSize: 13)
                      ),
                    ]
                  )
                ),
                if(widget.id.startsWith("grp"))
                  IconButton(
                    onPressed: () => Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => 
                        ChangeNotifierProvider(create: (_) => 
                          ChatMembersModel(widget.id) ,child: AddFriendsToChat(chatId: widget.id)
                        )                       
                      )
                    ),
                    splashRadius: 20.0, 
                    icon: Icon(Icons.person_add, color: iconColor)
                  ),
                IconButton(
                  onPressed: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => OptionsPage(chatId: widget.id, chatName: widget.friend.name, chatImage:  widget.friend.image))
                  ),
                  splashRadius: 20.0,
                  icon: Icon(Icons.meeting_room, color: iconColor)
                )
                ]
              )
            )
          ),
        ),
        body: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible){
          return  Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: <Widget>[
            Container(    
              height: isKeyboardVisible ?  MediaQuery.of(context).size.height/2 : MediaQuery.of(context).size.height-70,                 
              child: StreamBuilder(
                stream:FirebaseDatabase.instance.reference().child('chats/messages').child(widget.id).onValue,
                builder: (context, AsyncSnapshot<Event> snapshot) {
                  if (snapshot.hasData){
                    messages.clear();
                    if(snapshot.data!.snapshot.value != null)
                    {              
                      snapshot.data!.snapshot.value.forEach((key, value){
                        messages.add(new Message(
                          content: value["content"],
                          sender: value["userSender"],
                          createAt: key.toString().substring(0, 19) + "." + key.toString().substring(19)
                        ));
                      });            
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      controller: _controller,
                      itemCount: messages.length,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      itemBuilder: (context, index) {
                        if(messages[index].isImage())
                        {
                          if(messages[index].sender == currentUser.name)
                          {
                            return _buildImage(
                              Alignment.bottomRight, 
                              index
                            );
                          }
                          else{
                            return _buildImage(
                              Alignment.bottomLeft, 
                              index
                            );
                          }
                        }
                        else{ 
                          if(messages[index].sender == currentUser.name){ 
                            return _buildMessage(
                              Alignment.bottomRight, 
                              messageUserColor, 
                              messages[index].content
                            );
                          }
                          else{
                            return _buildMessage(
                              Alignment.bottomLeft, 
                              messageFriendColor,
                              messages[index].content                                              
                            ); 
                          }                        
                        }
                      }
                    );
                  }
                  return Center(
                      child: CircularProgressIndicator()
                  );
                }
              )             
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                margin: EdgeInsets.only(bottom: 12),
                elevation: 1,
                shadowColor: Colors.grey.shade50,
                color: Colors.white70,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 60,
                  width: MediaQuery.of(context).size.width-40,
                  child: Center(
                    child: Row(children: <Widget>[
                      IconButton(
                        iconSize: 25,
                        color: iconColor,
                        splashRadius: 30.0,
                        splashColor: Colors.white,
                        onPressed: () {
                          showModalBottomSheet(context: context, builder: (ctx)=> _buildChoice(ctx));
                        },
                        icon: Icon(Icons.add),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          onTap: (){
                            _needsScroll = true;
                            setState((){});             
                          },
                          decoration: InputDecoration(
                            hintText: "Type message...",
                            hintStyle: TextStyle(color: hintColor),
                            border: InputBorder.none
                          ),
                          controller: messageController,
                        )
                      ),
                      SizedBox(width: 15),
                      FloatingActionButton(
                        onPressed: ()async{
                          if(messageController.text.isNotEmpty){
                            await addData(messageController.text);                     
                            messageController.text = "";
                            setState((){
                              _needsScroll = true;
                            });
                          }
                        },
                        child: Icon(Icons.send, color: Colors.white, size: 18),
                        backgroundColor: Colors.blue.shade300,
                        elevation: 0
                      )
                    ]
                  ))
                )
                )
              )
            ]
          )
        );}
      )
    );
  }

  Future<void> addData(String data) async{
    db..child("chats").child('messages').child(widget.id).child(DateTime.now().toString().replaceAll(".", "")).set({
      'content': data,
      'userSender': currentUser.name,
    });
    if(data.startsWith("https"))
    {
      await FirebaseDatabase.instance.reference().child("chats").child("chatsroom").child(widget.id).update({
        "lastMessage": "photo",
        "timestamp": DateTime.now().toString()
      });
    }
    else{
      await FirebaseDatabase.instance.reference().child("chats").child("chatsroom").child(widget.id).update({
        "lastMessage": data,
        "timestamp": DateTime.now().toString()
      });
    }
  }


  Widget _buildMessage(Alignment alignment, Color color, String message){
    return Align(
      alignment: alignment,
      child: Card(
        margin: EdgeInsets.only(right: 5.8, top: 20, left: 5.8),
        color: color,
        shadowColor: Colors.black54,
        elevation: 3,
        shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
        child: Container(
          padding: EdgeInsets.all(15),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
          ),
          child: Text(
            message,
            style: TextStyle(color: textPrimaryColor, fontSize: 15, fontWeight: FontWeight.w400),
          ),
        ),
      )
    );
  }

  Widget _buildImage(Alignment alignment, int index){
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onLongPress: (){BuildDialog(context, messages[index].content);},
        onTap: (){showHero(context, messages[index].content, index.toString());},
        child: Hero(
          tag: "image"+index.toString(),
          child: Container(
            width: 150,
            height: 200,
            color: Colors.grey[200],
            margin: EdgeInsets.only(top: 15.5, left: 5, right: 5),
            child: Image.network(
              messages[index].content,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Container(
                  width: 150,
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    )
                  ),                                       
                );
              },
            )
          )
        ),
      )
    );
  }

  Widget _buildChoice(BuildContext context){
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: 1)
        ),
      ),
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ListTile(
            title: Text("File",style: TextStyle(color: textPrimaryColor)),
            leading: Icon(Icons.folder, color: iconColor),
          ),
          Divider(thickness: 2,),
          ListTile(
            title: Text("Image", style: TextStyle(color: textPrimaryColor)),
            leading: Icon(Icons.image, color: iconColor,),
            onTap: ()async{
              File imagePath;
              late String urlImage;
              imagePath = await getImage();
              urlImage = await uploadPic(imagePath, "chats/${widget.id}");
              Navigator.pop(context);
              await addData(urlImage);
            },
          )
        ]
      )
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
