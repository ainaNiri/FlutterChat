import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/models/colorModel.dart';
import 'package:myapp/models/listModel.dart';
import 'package:myapp/screens/chatDetailPage.dart';
import 'package:myapp/widgets/widgetList.dart';
import 'package:provider/provider.dart';

List<dynamic> lists = [];
// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  Icon icon = Icon(Icons.add);
  Map<dynamic, dynamic> person = ({
    'image': "",
    'name': "",
    'id': ""
  });
  String? friend;
  
  ProfilePage({required this.icon, required this.person, this.friend,});

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
    return SingleChildScrollView(
        child: Container(
        margin: EdgeInsets.only(top: 20),
        color: Colors.white,
        padding: EdgeInsets.all(15),
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              color: Colors.white70,
              margin: EdgeInsets.all(3),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.person['image']),
                      maxRadius: 70,
                    ),
                    SizedBox(height: 20), 
                    Text(widget.person['name'] ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ]
                )
              )
            ),
            SizedBox(height: 35),
            if(widget.person['name'] != currentUser['name']) Align(
              child: TextButton.icon(
                icon: widget.icon,
                onPressed: () async{
                  if(widget.icon.icon == Icons.add) {
                    await FirebaseDatabase.instance.reference().child('notifications').child(widget.person['id']).child(currentUser['id']).set({
                      "id": currentUser['id'],
                      "name": currentUser['name'],
                      "image": currentUser['image']
                    });
                    print("ok");
                  }
                  else
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){ return ChatDetailPage(id: widget.person['id'], person: friend);})
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
            if(firstRendering && widget.person["name"] == currentUser["name"])FutureBuilder(
              future : FirebaseDatabase.instance.reference().child('users').child(widget.person['id']).child('about').once(),
              builder:(context, AsyncSnapshot<DataSnapshot> snapshot){ 
                if(snapshot.hasData){
                  firstRendering = false;
                  var lists = context.read<ListModel>();
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
            else if(widget.person["name"] != currentUser["name"])
              FutureBuilder(
                future : FirebaseDatabase.instance.reference().child('users').child(widget.person['id']).child('about').once(),
                builder:(context, AsyncSnapshot<DataSnapshot> snapshot){ 
                  if(snapshot.hasData){
                    var lists = context.read<ListModel>();
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
}