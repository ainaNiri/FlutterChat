class Message{
  String content;
  String sender;

  Message({required this.content, required this.sender});

  bool isImage(){
    if(content.startsWith("http"))
      return true;
    return false;
  }
}
 
