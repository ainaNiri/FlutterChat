class Message{
  String content;
  String? sender;
  String createAt;

  Message({required this.content, this.sender, required this.createAt});

  bool isImage(){
    if(content.startsWith("http"))
      return true;
    return false;
  }
  
  bool isFile(){
    RegExp exp = RegExp(r"^(#fileAina.)");
    if(exp.firstMatch(content) != null)
      return true;
    return false;
  }
}
 
