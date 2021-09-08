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
  String lastMessageType;
  bool connected;

  Friend({required this.id, required this.chatId, 
    required this.image, required this.name, 
    required this.lastMessageContent, required this.lastMessageTime, 
    required this.lastMessageType, required this.connected
  });

  User toUser(){
    return User(
      id: id,
      name: name,
      image: image
    );
  }

  bool isInChat(ChatMembersModel chatMembers){
    if(chatMembers.members.where((element) => element.id == this.id).isNotEmpty)
      return true;
    return false;
  }

}


