import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/models/listModel.dart';
import 'package:myapp/screens/chatDetailPage/messagePage.dart';
import 'package:myapp/widgets/collections.dart';
import 'package:myapp/widgets/editProfile.dart';
import 'package:myapp/widgets/hero.dart';
import 'package:myapp/widgets/widgetList.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  String? chatId; 
  Icon? icon;
  User person = new User(
    image: "",
    name: "",
    id: ""
  );
  String? friend;
  
  ProfilePage({this.icon, required this.person, this.friend, this.chatId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    return Container(
      height: MediaQuery.of(context).size.height,
      color: kPrimaryColor,
      padding: EdgeInsets.only(left: 15, right: 15, top: widget.person.id == currentUser.id ? 20 : 60),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
                    GestureDetector(
                      child: Hero(
                        tag: "image",
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.person.image),
                          maxRadius: 70,
                        ),
                      ),
                      onTap: () => showHero(context, widget.person.image, ""),
                    ),
                    SizedBox(height: 20),
                    Text(widget.person.name ,style: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold, fontSize: 20)),                   
                    if(currentUser.id == widget.person.id)
                      Align(
                        alignment: Alignment.bottomRight,
                        child:IconButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(isForChat: false, image: currentUser.image,))), 
                          icon: Icon(Icons.edit, color: iconSecondaryColor)
                        )
                      )
                  ]
                )
              )
            ),
            SizedBox(height: 35),
            if(widget.person.name != currentUser.name) Align(
              child: ElevatedButton.icon(
                icon: widget.icon! ,
                onPressed: () async{
                  if(widget.icon!.icon == Icons.add) {
                    await _updateNotifications();
                  }
                  else
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){ return ChatDetailPage(id: widget.chatId!, friend: widget.person);})
                    );  
                },
                label: Text( widget.friend ?? "Add"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(getColor),
                  padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(25, 10, 25, 10))
                ),
              )
            ),
            SizedBox(height: 20),
            if(firstRendering && widget.person.name == currentUser.name)FutureBuilder(
              future : FirebaseDatabase.instance.reference().child('users').child("users_about").child(widget.person.id).once(),
              builder:(context, AsyncSnapshot<DataSnapshot> snapshot){ 
                if(snapshot.hasData){
                  firstRendering = false;
                  lists.clear();
                  Map<dynamic, dynamic> value1 = snapshot.data!.value;
                  value1.forEach((key, value){
                    lists.add(value);
                  });
                  return _buildList();  
                }
                return Center(child: CircularProgressIndicator());
              }
            )
            else if(widget.person.name != currentUser.name)
              FutureBuilder(
                future : FirebaseDatabase.instance.reference().child('users').child("users_about").child(widget.person.id).once(),
                builder:(context, AsyncSnapshot<DataSnapshot> snapshot){ 
                  if(snapshot.hasData){
                    lists.clear();
                    Map<dynamic, dynamic> value1 = snapshot.data!.value;
                    value1.forEach((key, value){
                      lists.add(value);
                    });
                    return _buildList();
                  }
                  return Center(child: CircularProgressIndicator());
                }
              )           
            else 
              _buildList(),
            Collection()
          ]
        ),
      )       
    );
  }
  
  Widget _buildList(){
    return ListView(
      padding: EdgeInsets.only(bottom: 10),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      //key: _listKey,
      children: List.generate(4, (index){
        return  WidgetOption(
          icon: icon[index],
          section: section[index],
          index: index,
          isMe: widget.person.id == currentUser.id ? true : false
        );
      }                    
    ));            
  }

  Future <void> _updateNotifications() async{
    await FirebaseDatabase.instance.reference().child('notifications').child("sendBy").child(widget.person.id).child(currentUser.id).set({
      "id": currentUser.id,
      "name": currentUser.name,
      "image": currentUser.image
    });
    await FirebaseDatabase.instance.reference().child('notifications').child("sendTo").child(currentUser.id).set({
      widget.person.id : true
    });
  }
}
