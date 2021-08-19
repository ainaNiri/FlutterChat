import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';

class FriendsModel extends ChangeNotifier{
  List <Friend> _friends = [];
  final _db = FirebaseDatabase.instance.reference().child("chats").child("chatsroom");

  late StreamSubscription<Event>_lastMessageStream;

  List <Friend> get friends => _friends;

  FriendsModel() {
    _listenToLastMessage();
  }

  Future <void> _listenToLastMessage() async{
    _lastMessageStream = FirebaseDatabase.instance.reference().child("user_friends").child(currentUser.id).onValue.listen((event) {
      //print(event.snapshot.key);
      if( event.snapshot.value != null){
        event.snapshot.value!.forEach((key, value) { 
          _db.child(value["chatId"]).onValue.listen((snapshot) {
            _friends.clear();
            _friends.add(Friend(
              id: key,
              chatId: snapshot.snapshot.key!,
              name: value["name"],
              image:  value["image"],
              lastMessageContent: snapshot.snapshot.value["lastMessage"],
              lastMessageTime: snapshot.snapshot.value["timestamp"],
              lastMessageType: "read"
            ));
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
}

