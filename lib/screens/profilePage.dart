import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/models/constants.dart';
import 'package:myapp/models/function.dart';
import 'package:myapp/models/listModel.dart';
import 'package:myapp/screens/chatDetailPage.dart';
import 'package:myapp/widgets/widgetList.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  String? chatId; 
  Icon icon = Icon(Icons.add);
  User person = new User(
    image: "",
    name: "",
    id: ""
  );
  String? friend;
  
  ProfilePage({required this.icon, required this.person, this.friend, this.chatId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<dynamic> lists = [];
  List <IconData> icon = [
    Icons.holiday_village,
    Icons.location_on,
    Icons.person_outlined,
    Icons.school,
  ];
  List <String> section = [
    "Hobby",
    "Location",
    "Profile",
    "School",
  ];

  @override
  Widget build(BuildContext context) {
    var lists = context.watch<ListModel>();
    return SingleChildScrollView(
        child: Container(
        margin: EdgeInsets.only(top: 20),
        color: kPrimaryColor,
        padding: EdgeInsets.all(15),
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              color: kSecondaryColor,
              margin: EdgeInsets.all(3),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.person.image),
                      maxRadius: 70,
                    ),
                    SizedBox(height: 20), 
                    Text(widget.person.name ,style: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold, fontSize: 20)),
                  ]
                )
              )
            ),
            SizedBox(height: 35),
            if(widget.person.name != currentUser.name) Align(
              child: TextButton.icon(
                icon: widget.icon,
                onPressed: () async{
                  if(widget.icon.icon == Icons.add) {
                    await updateNotifications();
                  }
                  else
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){ return ChatDetailPage(id: widget.chatId!, friend: widget.person);})
                    );  
                },
                label: Text( widget.friend ?? "Add"),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(2),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  backgroundColor: MaterialStateProperty.resolveWith(getColor),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  minimumSize: MaterialStateProperty.all(Size(180, 20)),
                )
              )
            ),
            SizedBox(height: 20),
            if(firstRendering && widget.person.name == currentUser.name)FutureBuilder(
              future : FirebaseDatabase.instance.reference().child('users').child(widget.person.id).child('about').once(),
              builder:(context, AsyncSnapshot<DataSnapshot> snapshot){ 
                if(snapshot.hasData){
                  firstRendering = false;
                  lists.clear();
                  Map<dynamic, dynamic> value1 = snapshot.data!.value;
                  value1.forEach((key, value){
                    lists.add(value);
                  });
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    //key: _listKey,
                    itemCount: 4,
                    itemBuilder: (context, index){
                      return  WidgetOption(
                        icon: icon[index],
                        section: section[index],
                        index: index,
                      );
                    }                    
                  );          
                }
                return Center(child: CircularProgressIndicator());
              }
            )
            else if(widget.person.name != currentUser.name)
              FutureBuilder(
                future : FirebaseDatabase.instance.reference().child('users').child(widget.person.id).child('about').once(),
                builder:(context, AsyncSnapshot<DataSnapshot> snapshot){ 
                  if(snapshot.hasData){
                    lists.clear();
                    Map<dynamic, dynamic> value1 = snapshot.data!.value;
                    value1.forEach((key, value){
                      lists.add(value);
                    });
                    return buildList();
                  }
                  return Center(child: CircularProgressIndicator());
                }
              )           
            else 
              buildList()
          ]
        )
        )
    );
  }
  Widget buildList(){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      //key: _listKey,
      itemCount: 4,
      itemBuilder: (context, index){
        return  WidgetOption(
          icon: icon[index],
          section: section[index],
          index: index,
        );
      }                    
    );            
  }

  Widget editProfile(File image){
    String profileImage = "";
    File image;
    TextEditingController nameController = new TextEditingController();
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset(
              profileImage,
              width: double.infinity,
              height: 50,
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: ()async {
                image = await getImage();
                profileImage = await uploadPic(image) ;
              },
              child: Center(
                child: Text("Change"),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(getColor)
              )
            ),
            SizedBox(height: 40,),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Name"
              ),
              controller: nameController,
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                if(nameController.text.isNotEmpty || profileImage.isNotEmpty){
                 await updateProfile("user_friends", "user_friends", nameController.text, profileImage, true);
                 await updateProfile("user_notifications", "notifications", nameController.text, profileImage, false);
                }
              },
              child: Center(
                child: Text("Save"),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(getColor),
                fixedSize: MaterialStateProperty.all(Size(350, 50))
              )
            )
          ]
        )
      ),
    );
  }

  Future <void> updateNotifications() async{
    await FirebaseDatabase.instance.reference().child('notifications').child(widget.person.id).child(currentUser.id).set({
      "id": currentUser.id,
      "name": currentUser.name,
      "image": currentUser.image
    });
    await FirebaseDatabase.instance.reference().child('user_notifications').child(currentUser.id).set({
      widget.person.id : true
    });
  }

  Future <void> updateProfile(String dbRef, String updateRef, String name, String image, bool changeUserRef) async {
    await FirebaseDatabase.instance.reference().child(dbRef).child(currentUser.id).once().then((snap) async {
      Map <String, dynamic> updateName = Map();
      Map <String, dynamic> updateImage = Map();
      snap.value.forEach((key, value){
        if(name.isNotEmpty){
          updateName["$updateRef/$key/${currentUser.id}/name"] = name;
          currentUser.name = name;
        }
        if(image.isNotEmpty){
          updateImage["$updateRef/$key/${currentUser.id}/image"] = image;
          currentUser.image = image;
        }
      });
      if(changeUserRef){
        updateName["users/${currentUser.id}/user/name"] = name;
        updateImage["users/${currentUser.id}/user/image"] = image;
      }
      await FirebaseDatabase.instance.reference().update(updateName);
      await FirebaseDatabase.instance.reference().update(updateName);
    });
  }
}