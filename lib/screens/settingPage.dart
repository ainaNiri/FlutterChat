import 'package:flutter/material.dart';
import 'package:myapp/models/constants.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({ Key? key }) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  bool _switchVal = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  child: Text("Dark mode", style: TextStyle(color: textPrimaryColor, fontSize: 17),),
                ),
                Switch(
                  value: this._switchVal, 
                  onChanged: (bool value){
                    if(darkMode){
                      setState(() {
                        this._switchVal = value;
                        kPrimaryColor = Colors.white;
                        kSecondaryColor = Colors.white70;
                        iconColor = Colors.grey.shade600;
                        iconSecondaryColor = Colors.black;
                        textPrimaryColor = Colors.black;
                        textSecondaryColor = Colors.grey.shade600;
                        inputColor = Colors.white;
                        hintColor = Colors.grey.shade400;
                        messageUserColor = Colors.lightBlue.shade200;
                        messageFriendColor = Colors.grey.shade300;
                        darkMode = false;
                      });
                    }
                    else{
                      setState((){
                        this._switchVal = value;
                        kPrimaryColor = Colors.black87;
                        kSecondaryColor = Colors.black38;
                        textPrimaryColor = Colors.white;
                        textSecondaryColor = Colors.grey.shade200;
                        iconColor = Colors.white70;
                        iconSecondaryColor = Colors.white;
                        inputColor = Colors.black87;
                        messageFriendColor = Colors.grey.shade700;
                        messageUserColor = Colors.blue.shade300;
                        darkMode = true;
                      });
                    }
                  }                                     
                )
              ],)
            ],
          )
        )
      )
    );
  }
}