import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/utilities/variables.dart';
import 'package:myapp/widgets/imageView.dart';

// ignore: must_be_immutable
class Collection extends StatelessWidget {
  String userId;
  Collection({ Key? key , required this.userId}) : super(key: key);

  List<String> collection = [
    "profile",
    "album",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.only(bottom: 15, top: 20),
      padding: EdgeInsets.only(left: 10, right: 10),
      color: kPrimaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), 
                    color: Color(0xFF5B9FDE)
                  ),
                  child: Icon(Icons.image, size: 15, color: kPrimaryColor,)
                ),
                SizedBox(width: 13,),
                Material(color: kPrimaryColor,child: Text("Photos", style: TextStyle(color: Color(0xFF5B9FDE), fontSize: 15, fontWeight: FontWeight.w300),)),
              ],
            ),
          ),
          Container(
            height: 150,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              children: List.generate(2, (index) => 
                FutureBuilder(
                  future: FirebaseDatabase.instance.reference().child("images/${collection[index]}/${this.userId}").limitToFirst(1).once(),
                  builder:(context, AsyncSnapshot<DataSnapshot> snapshot) {
                    if(snapshot.hasData){
                      if(snapshot.data!.value != null  || this.userId == currentUser.id){
                        Map<dynamic, dynamic> image = snapshot.data!.value ?? new Map();
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context){return ImageCollection(userId: this.userId, imageCollection: collection[index],);})
                            );
                          },
                          child: Card(
                            elevation: 2,
                            child: SizedBox(
                              width: 120,
                              height: 150,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  snapshot.data!.value != null ? Image.network(
                                    image[image.keys.elementAt(0)]["urlImage"],
                                    fit: BoxFit.cover,
                                  ) : Container(), 
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      color: Color.fromRGBO(0, 0, 0, 0.4),
                                      height: 30,
                                      child: Center(child: Text(collection[index], style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),)
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      else return Center();
                    } else return Center();
                  }
                )
              )
            ),
          ),
        ],
      ),
    );
  }
}