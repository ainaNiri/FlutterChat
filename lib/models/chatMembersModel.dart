import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';

class ChatMembersModel extends ChangeNotifier{
  List <User> _members = [];

  List <User> get members => _members;

   ChatMembersModel(String chatId) {
    _getChatMembers(chatId);
  }

  Future <void> _getChatMembers(String chatId) async{
    FirebaseDatabase.instance.reference().child("chats/members").child(chatId).once().then((snapshot) {
      snapshot.value.forEach((key, value){
        _members.add(User(
          id: key,
          name: value["name"],
          image: value["image"]
        ));
        notifyListeners();
      });
    });
  }

  void dispose(){
    super.dispose();
  }

  bool isEmpty(){
    if(_members.isEmpty)
      return true;
    return false;
  }

  int length(){
    return _members.length;
  }
}

