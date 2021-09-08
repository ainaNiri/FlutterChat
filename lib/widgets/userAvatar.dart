import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget UserAvatar(dynamic image, bool connected, double radius){
  return Container(
    child: Stack(
      children: [
        CircleAvatar(
          maxRadius: 27,
          backgroundImage: NetworkImage(image)
        ),
        if(connected)
          Positioned(
            bottom: 2.0,
            right: 2.5,
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green.shade500
              ),
            )
          ),
      ]
    ),
  );
}