import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';

class FriendsModel extends ChangeNotifier{
  List <Friend> _friends = [];
  final _db = FirebaseDatabase.instance.reference().child("chats/chatsroom");

  late StreamSubscription<Event>_lastMessageStream;

  List <Friend> get friends => _friends;


  FriendsModel() {
    _listenToLastMessage();
  }

  Future <void> _listenToLastMessage() async{
    _lastMessageStream = FirebaseDatabase.instance.reference().child("users/users_friends").child(currentUser.id).onValue.listen((event) {
      _friends.clear();
      if( event.snapshot.value != null){
        event.snapshot.value!.forEach((key, value) {
          _friends.add(new Friend(id:" ", chatId: value["chatId"], name: " ", image: " ", lastMessageContent: " ", lastMessageTime: DateTime.now().toString(), lastMessageType: " "));
          _db.child(value["chatId"]).onValue.listen((snapshot) {
            int index = whereChatId(value["chatId"].toString());
            if(value["name"] == null){             
              _friends[index].id = key;
              _friends[index].chatId = snapshot.snapshot.key!;
              _friends[index].name = snapshot.snapshot.value["name"];
              _friends[index].image =  snapshot.snapshot.value["image"];
              _friends[index].lastMessageContent = snapshot.snapshot.value["lastMessage"];
              _friends[index].lastMessageTime = snapshot.snapshot.value["timestamp"];
              _friends[index].lastMessageType = "read";
            }
            else {
              _friends[index].id = key;
              _friends[index].chatId= snapshot.snapshot.key!;
              _friends[index].name= value["name"];
              _friends[index].image=  value["image"];
              _friends[index].lastMessageContent= snapshot.snapshot.value["lastMessage"];
              _friends[index].lastMessageTime= snapshot.snapshot.value["timestamp"];
              _friends[index].lastMessageType= "read";
            }
            notifyListeners();
          });
        });
      }
    });

  }

  @override
  void dispose(){
    _lastMessageStream.cancel();
    super.dispose();
  }

  bool isEmpty(){
    if(_friends.isEmpty)
      return true;
    return false;
  }

  int length(){
    return _friends.length;
  }

  List <User> toUsers(){
    return List.generate(_friends.length, (index) {
      return _friends[index].toUser();
    });
  }

  int whereChatId(String chatId){
    return _friends.indexWhere((element) => element.chatId == chatId);
  }
}

