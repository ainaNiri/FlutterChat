import 'package:flutter/material.dart';
import 'package:myapp/screens/actualityPage.dart';
import 'package:myapp/utilities/constants.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({ Key? key }) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context, MaterialPageRoute(builder: (context) => ActualityPage(index: 0)));
        return true;
      },
      child: Scaffold(
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
                    value: darkMode, 
                    onChanged: (bool value){
                      if(darkMode){
                        setState(() {
                          kPrimaryColor = Colors.white;
                          kSecondaryColor = Colors.white70;
                          iconColor = Colors.grey.shade600;
                          inputMessageColor = Colors.white60;
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
                          kPrimaryColor = Colors.black87;
                          kSecondaryColor = Colors.white10;
                          textPrimaryColor = Colors.white;
                          textSecondaryColor = Colors.grey.shade400;
                          inputMessageColor = Colors.black12;
                          iconColor = Colors.white;
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
      ),
    );
  }
}