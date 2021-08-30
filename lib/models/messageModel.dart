class Message{
  String content;
  String sender;
  String createAt;

  Message({required this.content, required this.sender, required this.createAt});

  bool isImage(){
    if(content.startsWith("http"))
      return true;
    return false;
  }
}
 
