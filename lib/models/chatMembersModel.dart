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
    FirebaseDatabase.instance.reference().child("chats/members").child(chatId).once().then((snapshot){
      snapshot.value.forEach((key, value) async {
        await FirebaseDatabase.instance.reference().child("users").child("users_profile").child(key).once().then((data) {
          _members.add(User(
            id: data.value["id"],
            name: data.value["name"],
            image: data.value["image"]
          ));
          notifyListeners();
        });
      });
    });
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

