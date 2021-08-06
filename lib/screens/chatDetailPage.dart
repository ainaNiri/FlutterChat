import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:provider/provider.dart';
import '../models/chatMessageModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:image_gallery_saver/image_gallery_saver.dart';
// ignore: import_of_legacy_library_into_null_safe


List<dynamic> messages = [];

// ignore: must_be_immutable
class ChatDetailPage extends StatefulWidget {
  String id;
  Map <dynamic, dynamic> person;
  ChatDetailPage({required this.id, required this.person});

  @override
  _ChatDetailPage createState() => _ChatDetailPage();
}

class _ChatDetailPage extends State<ChatDetailPage> {

  final ScrollController _controller = ScrollController();
  final messageController = TextEditingController();
  final db = FirebaseDatabase.instance.reference();
  late String _id;
  bool _needsScroll = false;

  late File _image;
  final picker = ImagePicker();
  late String _url;

  Future <void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      } 
    });
  }

  Future<void> uploadPic() async {
   FirebaseStorage storage =  FirebaseStorage.instance;
   // ignore: await_only_futures
   Reference ref = await storage.ref().child("chats/" + currentUser['id'] + widget.id +"/"+path.basename(_image.toString()));
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
    if(currentUser['id'].compareTo(widget.id) < 0)
      _id = currentUser['id'] + widget.id;
    else
      _id = widget.id + currentUser['id'];

    return Scaffold(
      resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                ),
                SizedBox(width: 2),                 
                  CircleAvatar(
                    maxRadius: 25,
                    backgroundImage:NetworkImage(widget.person[widget.id]["image"]),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.person[widget.id]["name"],
                        style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)
                      ),
                      SizedBox(height: 6),
                      Text("Online",
                        style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13)
                      ),
                    ]
                  )
                ),
                IconButton(
                  onPressed: () {},
                  splashRadius: 20.0,
                  icon: Icon(Icons.settings, color: Colors.black54)
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
                  stream:FirebaseDatabase.instance.reference().child('messages').child(_id).onValue,
                  builder: (context, AsyncSnapshot<Event> snapshot) {
                    if (snapshot.hasData){
                    messages.clear();
                    if(snapshot.data!.snapshot.value != null)
                    {              
                      Map<dynamic, dynamic> values = snapshot.data!.snapshot.value;
                        values.forEach((key, value){
                            messages.add(value);
                      });
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      controller: _controller,
                      itemCount: messages.length,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      itemBuilder: (context, index) {
                        if(messages[index]["content"].startsWith("https"))
                        {
                          if(messages[index]["userSender"] == currentUser['name'])
                          {
                            return Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onLongPress: (){_showDialog(context, messages[index]['content']);},
                                onTap: (){_showHero(context, messages[index]["content"], index.toString());},
                                child: Hero(
                                  tag: "image"+index.toString(),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 15.5, right: 5),
                                    child: Image.network(
                                      messages[index]["content"],
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
                                      alignment: Alignment.bottomRight,
                                      width: 150,
                                      height: 200,
                                    )
                                  )
                                ),
                              )
                            );
                          }
                          else
                          {
                            return Align(
                              alignment: Alignment.bottomLeft,
                              child: GestureDetector(
                                onLongPress: (){_showDialog(context, messages[index]['content']);},
                                onTap: (){_showHero(context, messages[index]["content"], index.toString());},
                                child: Hero(
                                  tag: "image"+index.toString(),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 15.5, left: 5),
                                    child: Image.network(
                                      messages[index]["content"],
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
                                      alignment: Alignment.bottomLeft,
                                      width: 150,
                                      height: 200,
                                    )
                                  )
                                ),
                              )
                            );
                          }
                        }
                        else if(messages[index]["content"] != ' '){
                          if(messages[index]["userSender"] == currentUser['name']){ return Align(
                            alignment: Alignment.topRight,
                            child: Card(
                              margin: EdgeInsets.only(right: 5.8, top: 20),
                              color: Colors.lightBlue.shade200,
                              shadowColor: Colors.black54,
                              elevation: 3,
                              shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
                              child: Container(
                                padding: EdgeInsets.all(15),
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                                ),
                                child: Text(
                                  messages[index]["content"],
                                  style: TextStyle(color: Colors.black, fontSize: 16),
                                ),
                              ),
                            )
                          );}
                          else
                        return Align(
                            alignment: Alignment.topLeft,
                            child: Card(
                              shadowColor: Colors.black54,
                              color: Colors.grey.shade300,
                              shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
                              margin: EdgeInsets.only(left: 5.8, top: 20),
                              elevation: 3, 
                              child: Container(
                                padding: EdgeInsets.all(15),
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                                ),
                                child: Text(
                                  messages[index]["content"],
                                  style: TextStyle(color: Colors.black, fontSize: 16),
                                ),
                              ),
                            )
                          );}
                      else
                      return Container(
                        
                      );
                    }
                    );}
                    return Center(
                        child: CircularProgressIndicator()
                      );}
                )
              
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: Row(children: <Widget>[
                    IconButton(
                      iconSize: 25,
                      color: Colors.black45,
                      splashRadius: 30.0,
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
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
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
                        backgroundColor: Colors.blue,
                        elevation: 0)
                  ]
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
          title: const Text('Save'),
          content: const Text('Do you want to save the image?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _requestPermission();
                await _saveNetworkImage(imagePath); 
                Navigator.pop(context, 'OK');
              },
              child: const Text('OK'),
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
    db.child('messages').child(_id).child(DateTime.now().toString().replaceAll(".", "")).set({
      'content': data,
      'userSender': currentUser['name'],
    });
    if(data.startsWith("https"))
    {
      db.child('users').child(currentUser['id']).child('friends').child(widget.id).child('lastMessages').update({'content': "photo", 'time': DateTime.now().toString()});
      db.child('users').child(widget.id).child('friends').child(currentUser['id']).child('lastMessages').update({'content': "photo", 'time': DateTime.now().toString()});
    }
    else{
      db.child('users').child(currentUser['id']).child('friends').child(widget.id).child('lastMessages').update({'content': data, 'time': DateTime.now().toString()});
      db.child('users').child(widget.id).child('friends').child(currentUser['id']).child('lastMessages').update({'content': data, 'time': DateTime.now().toString()});
    }
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
            title: Text("File"),
            leading: Icon(Icons.file_copy_outlined),
          ),
          Divider(thickness: 2,),
          ListTile(
            title: Text("Image"),
            leading: Icon(Icons.image),
            onTap: ()async{
              await getImage();
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
