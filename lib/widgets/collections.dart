import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';

class Collection extends StatelessWidget {
  const Collection({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.only(bottom: 25, top: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: List.generate(1, (index) => 
          Card(
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
                      child: Center(child: Text("Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),)
                    ),
                  )
                ],
              ),
            ),
          )
        )
      ),
    );
  }
}