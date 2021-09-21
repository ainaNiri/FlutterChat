import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:myapp/models/chatMembersModel.dart';
import 'package:myapp/models/friendModel.dart';
import 'package:myapp/models/messageModel.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/screens/chatDetailPage/optionsPage.dart';
import 'package:myapp/screens/profilePage.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/utilities/date.dart';
import 'package:myapp/utilities/firebaseStorage.dart';
import 'package:myapp/screens/chatDetailPage/addFriendsToChatPage.dart';
import 'package:myapp/utilities/function.dart';
import 'package:myapp/widgets/dialog.dart';
import 'package:myapp/widgets/hero.dart';
import 'package:myapp/widgets/userAvatar.dart';
import 'dart:async';

import 'package:provider/provider.dart';


// ignore: must_be_immutable
class ChatDetailPage extends StatefulWidget {
  String id;
  User friend;
  bool friendConnected;
  ChatDetailPage({required this.id, required this.friend, required this.friendConnected});

  @override
  _ChatDetailPage createState() => _ChatDetailPage();
}

class _ChatDetailPage extends State<ChatDetailPage> {
  List<Message> messages = [];
  final ScrollController _controller = ScrollController();
  final messageController = TextEditingController();
  final db = FirebaseDatabase.instance.reference();
  late final keyboardVisibilityController = KeyboardVisibilityController();
  bool _needsScroll = false;
  
  void initState(){
    super.initState();
  }

  void dispose(){
    _controller.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> _postInit() async {
    await Future.delayed(Duration(milliseconds: 100));
  _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {

    if(_needsScroll){
      SchedulerBinding.instance!.addPostFrameCallback(
        (_) {if(_controller.hasClients){
          _controller.jumpTo(_controller.position.maxScrollExtent);
        }});
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
                  splashRadius: 28,
                  icon: UserAvatar(
                    widget.friend.image,
                    widget.friendConnected,
                    30
                  ),
                  onPressed: () {
                    var friends = context.read<FriendsModel>();
                    if(widget.id.startsWith("grp"))
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => OptionsPage(chatId: widget.id, chatName: widget.friend.name, chatImage:  widget.friend.image))
                      );
                    else 
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => ProfilePage(icon: Icon(Icons.message), person: widget.friend, friend: "Message", chatId: widget.id, friendConnected: friends.friends[friends.whereChatId(widget.id)].connected,))
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
                      Text(widget.friendConnected ? "Online" : "Offline",
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
                if(widget.id.startsWith("grp"))
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
        body: Container(
          height: MediaQuery.of(context).size.height - 50,
          padding: EdgeInsets.only(bottom: 15),
          child: Column(children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: StreamBuilder(
                    stream:FirebaseDatabase.instance.reference().child('chats/messages').child(widget.id).onValue,
                    builder: (context, AsyncSnapshot<Event> snapshot) {
                      if (snapshot.hasData){
                        messages.clear();
                        if(snapshot.data?.snapshot.value != null)
                        {              
                          snapshot.data!.snapshot.value.forEach((key, value){
                            messages.add(new Message(
                              content: value["content"],
                              sender: value["userSender"],
                              createAt: value["file_name"] != null ? value["file_name"] : key.toString().substring(0, 19) + "." + key.toString().substring(19)
                            ));
                          });            
                          _postInit();
                          return ListView.builder(
                            shrinkWrap: true,
                            controller: _controller,
                            itemCount: messages.length,
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            itemBuilder: (context, index) {
                              if(messages[index].sender == currentUser.name){
                                return Align(
                                  alignment: Alignment.bottomRight,
                                  child: messages[index].isImage() ? _buildImage(index) : 
                                  (messages[index].isFile() ? _buildFile(messages[index].createAt, messages[index].content) : 
                                    _buildMessage(messageUserColor, messages[index].content,messages[index].createAt,))
                                );                                   
                              }
                              else if(messages[index].sender == null)
                                return _buildDate(messages[index].content);
                              else {
                                return Align(
                                  alignment: Alignment.bottomLeft,
                                  child: messages[index].isImage() ? _buildImage(index) : 
                                  (messages[index].isFile() ? _buildFile(messages[index].createAt, messages[index].content) : 
                                    _buildMessage(messageFriendColor, messages[index].content,messages[index].createAt,))
                                );                                   
                              }
                            }                             
                          );
                        }
                        return Center(
                          child: Column(
                            children: [
                              Image.asset("assets/images/hello.jpg"),
                              SizedBox(height: 40,),
                              Text("Say hello to your new friend", style: TextStyle(color: textPrimaryColor,  fontSize: 17, fontWeight: FontWeight.w300))
                            ],
                          )
                        );
                      }
                      return Center(
                          child: CircularProgressIndicator()
                      );
                    }
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                margin: EdgeInsets.only(bottom: 6),
                elevation: 1,
                shadowColor: Colors.grey.shade50,
                color: inputMessageColor,
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
                            keyboardVisibilityController.onChange.listen((bool visible){
                              if(visible)
                                setState((){
                                  _needsScroll = true;
                                });
                            });
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
                          if(messageController.text.trim().isNotEmpty){
                            await addData(messageController.text, null);                     
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
        )
    );
  }

  Future<void> addData(String data, String? fileName) async{

    if(messages.isNotEmpty){
      String date = dateDifference(messages.last.createAt);

      if(date != ""){
        await db.child("chats").child('messages').child(widget.id).child(DateTime.now().toString().replaceAll(".", "")).set({
          'content': DateTime.now().toString(),
        });
      }
    }

    await db.child("chats").child('messages').child(widget.id).child(DateTime.now().toString().replaceAll(".", "")).set({
    'content': data,
    'userSender': currentUser.name,
    });

    if(data.startsWith("https"))
    {
      await FirebaseDatabase.instance.reference().child("chats/chatsroom").child(widget.id).update({
        "lastMessage": "photo",
        "timestamp": DateTime.now().toString()
      });
    }
    else{
      await FirebaseDatabase.instance.reference().child("chats/chatsroom").child(widget.id).update({
        "lastMessage": fileName != null ? data.substring(10) : data,
        "timestamp": DateTime.now().toString(),
        if(fileName != null) "file_name": fileName
      });
    }
  }

  Widget _buildMessage(Color color, String message, String messageDate){
    return Column(
      children: [
        // if(printDate(messageDate).isNotEmpty && ) Center(
        //   heightFactor: 3,
        //   child: Text(printDate(messageDate), style: TextStyle(color: textSecondaryColor, fontSize: 13)),
        // ),
        Card(
          margin: EdgeInsets.only(right: 6, top: 7.5, left: 6, bottom: 7.5),
          color: color,
          shadowColor: Colors.black54,
          elevation: 2,
          shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.5,
            ),
            child: Text(
              message,
              style: TextStyle(color: textPrimaryColor, fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDate(String date){
    date = printDate(date);
    return Center(
      heightFactor: 3,
      child: Text(date, style: TextStyle(color: textSecondaryColor, fontSize: 13)),
    );
  }

  Widget _buildFile(String fileName, String urlFile){
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextButton(
        onPressed: () async {
          try{
            Dio dio = Dio();
            await requestPermission();
            await download2(dio, urlFile.substring(10), fileName);
          }catch(e) {
            print(e.toString());
          }
        },
        child: Text(
          fileName,
          style: TextStyle(color: Colors.blue, fontSize: 16, decoration: TextDecoration.underline, decorationColor: Colors.blue)
        ),
      ),
    );
  }

  Widget _buildImage(int index){
    return GestureDetector(
      onLongPress: (){BuildDialog(context, messages[index].content);},
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context){ return ImageView(image: messages[index].content, index: index.toString(),);})
        );
      },
      child: Hero(
        tag: "image" + index.toString(),
        child: Container(
          width: 150,
          height: 200,
          color: Colors.grey[200],
          margin: EdgeInsets.only(top: 7.5, left: 5, right: 5, bottom: 7.5),
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
            onTap: ()async{
              FilePickerResult? result;
              late String urlFile;
              late String fileName;
              result = await getFile();
              if(result != null){
                fileName = getFileName(result);
                urlFile = await uploadFile(result , "chats/${widget.id}");
              }
              Navigator.pop(context);
              await addData('#fileAina.' + urlFile, fileName);
            },
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
              await addData(urlImage, null);
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
