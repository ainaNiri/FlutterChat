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

  Friend({required this.id, required this.chatId, required this.image, required this.name, required this.lastMessageContent, required this.lastMessageTime, required this.lastMessageType});

  User toUser(){
    return User(
      id: id,
      name: name,
      image: image
    );
  }

}


