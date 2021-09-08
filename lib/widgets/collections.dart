import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
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
      height: 150,
      margin: EdgeInsets.only(bottom: 25, top: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: List.generate(2, (index) => 
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context){return ImageCollection(userId: this.userId, imageCollection: collection[index],);})
              );
            },
            child: Card(
              elevation: 2,
              child: Container(
                width: 120,
                height: 100,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      currentUser.image,
                      fit: BoxFit.cover
                    ),
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
          )
        )
      ),
    );
  }
}