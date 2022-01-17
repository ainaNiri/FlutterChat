import 'package:flutter/material.dart';
import 'package:myapp/screens/chatDetailPage/chatRoomMembers.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/widgets/editProfile.dart';
import 'package:myapp/widgets/hero.dart';

class OptionsPage extends StatelessWidget {
  String chatId;
  String chatName;
  String chatImage;
  OptionsPage({ Key? key , required this.chatName, required this.chatImage, required this.chatId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(top: 40, bottom: 10),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        IconButton(
                          iconSize: 120,
                          splashRadius: 68,
                          icon: Hero(
                            tag: "image",
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(this.chatImage),
                              radius: 70,
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context){ return ImageView(image: this.chatImage, index: "",);})
                          ),
                        ),
                        SizedBox(height: 15,),
                        Text(this.chatName, style: TextStyle(color: textPrimaryColor, fontSize: 25, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  SizedBox(height: 25,),
                  ListTile(
                    title: Text("Members", style: TextStyle(color: textPrimaryColor),),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatRoomMembers(chatId: this.chatId)
                        )
                      );
                    }
                  ),
                  Divider(color: textSecondaryColor),
                  ListTile(
                    title: Text("Change name or image", style: TextStyle(color: textPrimaryColor),),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                          EditProfile(isForChat: true, chatId: this.chatId, image: this.chatImage,)                       
                        )
                      );
                    }
                  )
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}