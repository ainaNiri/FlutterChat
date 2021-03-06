import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';

class FriendsModel extends ChangeNotifier{
  List <Friend> _friends = [];
  final _db = FirebaseDatabase.instance.reference().child("chats");
  final _userRef = FirebaseDatabase.instance.reference().child("users");

  late StreamSubscription<Event>_stream;
  List<StreamSubscription<Event>> _friendStream = [];
  List<StreamSubscription<Event>> _lastMessageStream = [];
  List<StreamSubscription<Event>> _connectedStream = [];
  List<StreamSubscription<Event>> _messageTypeStream = [];

  List <Friend> get friends => _friends;

  FriendsModel() {
    _listenToLastMessage();
  }

  Future <void> _listenToLastMessage() async{
    _stream = _userRef.child("users_friends").child(currentUser.id).onChildAdded.listen((data) {
      _friends.add(new Friend(id:" ", chatId: data.snapshot.value["chatId"], name: " ", image: " ", lastMessageContent: " ", lastMessageTime: DateTime.now().toString(), lastMessageType: false, connected: true, token: ""));
      _friendStream.add(_userRef.child("users_friends").child(currentUser.id).child(data.snapshot.key!).onValue.listen((event) {
        int index = whereChatId(data.snapshot.value["chatId"].toString());
        if(data.snapshot.value["chatId"].toString().startsWith("grp")){             
          _friends[index].id = event.snapshot.key!;
          _friends[index].chatId = event.snapshot.value["chatId"];
          _friends[index].name = event.snapshot.value["name"];
          _friends[index].image =  event.snapshot.value["image"];
        }
        else {
          _friends[index].id = event.snapshot.key!;
          _friends[index].chatId = event.snapshot.value["chatId"];
          _friends[index].name = event.snapshot.value["name"];
          _friends[index].image = event.snapshot.value["image"];
        }
        notifyListeners();
      }));
      _connectedStream.add(_userRef.child("users_connected").child(data.snapshot.key!).onValue.listen((event){
        int index = whereChatId( data.snapshot.value["chatId"].toString());
        if(!data.snapshot.value["chatId"].toString().startsWith("grp")){
          _friends[index].connected = event.snapshot.value['connected'];
          _friends[index].token = event.snapshot.value['token'];
        }
        notifyListeners();
      }));
      _messageTypeStream.add(_db.child("chat_lastMessage").child(data.snapshot.value['chatId']).child(currentUser.id).onValue.listen((event){
        int index = whereChatId( data.snapshot.value["chatId"].toString());
        _friends[index].lastMessageType = event.snapshot.value;
        notifyListeners();
      }));
      _lastMessageStream.add(_db.child('chatsroom').child(data.snapshot.value["chatId"]).onValue.listen((event){
        int index = whereChatId( data.snapshot.value["chatId"].toString());
        _friends[index].lastMessageContent = event.snapshot.value["lastMessage"];
        _friends[index].lastMessageTime = event.snapshot.value["timestamp"];
        Friend first = _friends.removeAt(index);
        _friends.insert(0, first);
        notifyListeners();
      }));
    });
  }

  @override
  void dispose(){
    _stream.cancel();
    for(int i = 0; i < _lastMessageStream.length; i++){
      _lastMessageStream[i].cancel();
      _friendStream[i].cancel();
      _connectedStream[i].cancel();
      _messageTypeStream[i].cancel();
    }
    super.dispose();
  }

  bool get isEmpty => friends.isEmpty;

  int get length => _friends.length;
  
  List <User> toUsers(){
    return List.generate(_friends.length, (index) {
      return _friends[index].toUser();
    });
  }

  int whereChatId(String chatId){
    return _friends.indexWhere((element) => element.chatId == chatId);
  }

  void sort(){
    _friends.sort((a, b) => DateTime.parse(b.lastMessageTime).compareTo( DateTime.parse(a.lastMessageTime)));
  }

  Friend whereId(String id){
    return _friends.firstWhere((element) => element.id == id);
  }
}