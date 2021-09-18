import 'package:flutter/material.dart';

class Exemple extends StatefulWidget {
  const Exemple({ Key? key }) : super(key: key);

  @override
  _ExempleState createState() => _ExempleState();
}

class _ExempleState extends State<Exemple> {
  final ScrollController _controller = ScrollController();
  bool _needsScroll = true;
  double height = 0.0;
  List <String> messages = [
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
        _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,);
      }}
    );
  }
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
      if (_needsScroll) {
      Future.delayed(Duration(microseconds: 
      500),(){
      WidgetsBinding.instance!.addPostFrameCallback(
        (_) {if(_controller.hasClients){
          _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,);
        }});});
      _needsScroll = false;
    }
    return Scaffold(        
      resizeToAvoidBottomInset: true,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
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
                ),
              ),
            ),
            //Expanded(
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(top: 20),
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
                        onTap: (){
                          _needsScroll = true;
                          height = 400;
                          setState((){});             
                        },
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
              )//)
          ]
        ),
      )
    );
  }
}