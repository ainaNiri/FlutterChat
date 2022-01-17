// import 'dart:async';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:myapp/models/chatUsersModel.dart';

// class ChatMembersModel extends ChangeNotifier{
//   List <User> _members = [];

//   List <User> get members => _members;

//    ChatMembersModel(String chatId) {
//     _getChatMembers(chatId);
//   }

//   Future <void> _getChatMembers(String chatId) async{
//     FirebaseDatabase.instance.reference().child("chats/members").child(chatId).once().then((snapshot) {
//       Map<dynamic, dynamic> members = snapshot.value as Map;
//       print(members);
//       if(members.isNotEmpty){
//         members.forEach((key, value){
//           // _members.add(User(
//           //   id: key,
//           //   name: value["name"],
//           //   image: value["image"]
//           // ));
//           notifyListeners();
//         });
//       }
//     });
//   }

//   void dispose(){
//     super.dispose();
//   }

//   bool get isEmpty => _members.isEmpty;

//   int get length =>
//  _members.length;
  
// }

