import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Exemple extends StatefulWidget {
  const Exemple({ Key? key }) : super(key: key);

  @override
  _ExempleState createState() => _ExempleState();
}

class _ExempleState extends State<Exemple> {
  final ScrollController _controller = ScrollController();
  bool _needsScroll = false;
  List <String> messages = [
    "azerzarfsqdfsdqfsqdfwaer",
    "azerzarfsqdfsdqfsqdfwaer",
    "azerzarfsqdfsdqfsqdfwaer",
    "azerzarfsqdfsdqfsqdfwaer",
    "azerzarfsqdfsdqfsqdfwaer",
    "azerzarfsqdfsdqfsqdfwaer",
    "azerzarfsqdfsdqfsqdfwaer",
    "azerzarfsqdfsdqfsqdfwaer",
    "azerzarfsqdfsdqfsqdfwaer",
    "azerzarfsqdfsdqfsqdfwaer",
    "azerzarfsqdfsdqfsqdfwaer",
    "azerzarfsqdfsdqfsqdfwaer",
    "azerzarfsqdfsdqfsqdfwaer",
    "azerzarfsqdfsdqfsqdfwaer",
  ];
  void initState(){
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if(_controller.hasClients){
        print("ok");
        _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,);
      }}
    );
  }
  @override
  Widget build(BuildContext context) {
      if (_needsScroll) {
      WidgetsBinding.instance!.addPostFrameCallback(
        (_) {if(_controller.hasClients){
          _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,);
        }});
      _needsScroll = false;
    }
    return Scaffold(        
        body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
        child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              controller: _controller,
              itemCount: messages.length,
              itemBuilder: (context, index){
                return Card(
                  child: Container (
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(25),
                    child: Text( index.toString()+"       "+messages[index]),
                  )
                );
              },
            )
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: Row(children: <Widget>[
                  IconButton(
                    iconSize: 25,
                    color: Colors.black45,
                    splashRadius: 30.0,
                    onPressed: () {
                     
                    },
                    icon: Icon(Icons.add),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none
                      ),
                    )
                  ),
                  SizedBox(width: 15),
                  FloatingActionButton(
                      onPressed: (){
                       _needsScroll = true;
                          setState(() {
                          messages.add("zaezaeazesqdsqd");
                          });
                      },
                      child: Icon(Icons.send, color: Colors.white, size: 18),
                      backgroundColor: Colors.blue,
                      elevation: 0)
                ]
              )
            )
            )
        ]
      ))),
    );
  }
}