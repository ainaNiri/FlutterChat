import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:myapp/models/chatMessageModel.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/models/constants.dart';
import 'package:myapp/models/function.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:image_gallery_saver/image_gallery_saver.dart';

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

  late File _image;
  late String _url;

  Future<void> uploadPic() async {
   FirebaseStorage storage =  FirebaseStorage.instance;
   // ignore: await_only_futures
   Reference ref = await storage.ref().child("chats/" + widget.id +"/"+path.basename(_image.toString()));
   UploadTask uploadTask = ref.putFile(_image);
   _url = await(await uploadTask).ref.getDownloadURL();
}

  
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
                  CircleAvatar(
                    maxRadius: 25,
                    backgroundImage:NetworkImage(widget.friend.image ),
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
                IconButton(
                  onPressed: () {},
                  splashRadius: 20.0,
                  icon: Icon(Icons.settings, color: iconColor)
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
                  stream:FirebaseDatabase.instance.reference().child('chats').child("messages").child(widget.id).onValue,
                  builder: (context, AsyncSnapshot<Event> snapshot) {
                    if (snapshot.hasData){
                    messages.clear();
                    if(snapshot.data!.snapshot.value != null)
                    {              
                      snapshot.data!.snapshot.value.forEach((key, value){
                        messages.add(new Message(
                          content: value["content"],
                          sender: value["userSender"]
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
                            return buildImage(
                              Alignment.bottomRight, 
                              index
                            );
                          }
                          else{
                            return buildImage(
                              Alignment.bottomLeft, 
                              index
                            );
                          }
                        }
                        else{ 
                          if(messages[index].sender == currentUser.name){ 
                            return buildMessage(
                              Alignment.bottomRight, 
                              messageUserColor, 
                              messages[index].content
                            );
                          }
                          else{
                            return buildMessage(
                              Alignment.bottomLeft, 
                              messageFriendColor,
                              messages[index].content                                              
                            ); 
                          }                        
                        }
                      }
                    );}
                    return Center(
                        child: CircularProgressIndicator()
                      );}
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
                          showModalBottomSheet(context: context, builder: (ctx)=> buildChoice(ctx));
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

  void _showHero(BuildContext context, String image, String index)
  {
    Navigator.push(
      context,
      MaterialPageRoute(builder : (context){
        return Scaffold(
          body: Center(
            child: Hero(
              tag: 'image'+index,
              child: Image.network(image)
            )
          )
        );})
    );
  }
   _showDialog(BuildContext context, String imagePath)
  {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: kPrimaryColor,
          title: Text('Save', style: TextStyle(color: textPrimaryColor)),
          content: Text('Do you want to save the image?', style: TextStyle(color: textPrimaryColor)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: textPrimaryColor)),
            ),
            TextButton(
              onPressed: () async {
                await _requestPermission();
                await _saveNetworkImage(imagePath); 
                Navigator.pop(context, 'OK');
              },
              child: Text('OK', style: TextStyle(color: textPrimaryColor)),
            ),
          ],
        ),
    );
  }
  Future<void> _saveNetworkImage(String imagePath) async {
    var response = await Dio().get(imagePath,
    options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
      name: "hello");
    print(result);
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    
  }

  Future<void> addData(String data) async{
    db..child("chats").child('messages').child(widget.id).child(DateTime.now().toString().replaceAll(".", "")).set({
      'content': data,
      'userSender': currentUser.name,
    });
    if(data.startsWith("https"))
    {
      await FirebaseDatabase.instance.reference().child("chats").child("chatsroom").child(widget.id).set({
        "lastMessage": "photo",
        "timestamp": DateTime.now().toString()
      });
    }
    else{
      await FirebaseDatabase.instance.reference().child("chats").child("chatsroom").child(widget.id).set({
        "lastMessage": data,
        "timestamp": DateTime.now().toString()
      });
    }
  }


  Widget buildMessage(Alignment alignment, Color color, String message){
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
            style: TextStyle(color: textPrimaryColor, fontSize: 16),
          ),
        ),
      )
    );
  }

  Widget buildImage(Alignment alignment, int index){
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onLongPress: (){_showDialog(context, messages[index].content);},
        onTap: (){_showHero(context, messages[index].content, index.toString());},
        child: Hero(
          tag: "image"+index.toString(),
          child: Container(
            margin: EdgeInsets.only(top: 15.5, left: 5),
            child: Image.network(
              messages[index].content,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Container(
                  width: 150,
                  height: 200,
                  color: Colors.grey[300],
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
              alignment: alignment,
              width: 150,
              height: 200,
            )
          )
        ),
      )
    );
  }

  Widget buildChoice(BuildContext context){
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
              _image = await getImage();
              await uploadPic();
              await addData(_url);
              Navigator.pop(context);
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
