class Message{
  String content;
  String? sender;
  String? fileName;
  String createAt;

  Message({required this.content, this.sender, required this.createAt, this.fileName});

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
 
