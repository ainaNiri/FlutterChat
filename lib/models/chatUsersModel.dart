import 'package:myapp/models/chatMembersModel.dart';

class User{
  String id;
  String image;
  String name;

  User({ required this.id, required this.image, required this.name});

}

User currentUser = new User(
  id: "",
  name:"",
  image:""

);

class Friend  {
  String id;
  String image;
  String chatId;
  String name;
  String lastMessageContent;
  String lastMessageTime;
  bool? lastMessageType;
  bool connected;
  String token;

  Friend({required this.id, required this.chatId, required this.token,
    required this.image, required this.name, 
    required this.lastMessageContent, required this.lastMessageTime,
    this.lastMessageType, required this.connected
  });

  User toUser(){
    return User(
      id: id,
      name: name,
      image: image
    );
  }

  bool isInChat(Map chatMembers){
    bool isIn = false;
    chatMembers.forEach((key, value) {
      if(key == this.id){
        isIn = true;
        return;
      }
     });
    return isIn;
  }

}


