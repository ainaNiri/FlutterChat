import 'package:flutter/material.dart';

//Color for the background
Color kPrimaryColor = Colors.white;
Color kSecondaryColor = Colors.white;

//Color for the icon
Color iconColor = Colors.grey.shade600;
Color iconSecondaryColor = Colors.black;

//Color for the text
Color textPrimaryColor = Colors.black;
Color textSecondaryColor = Colors.grey.shade600;

//Color for the input
Color inputColor = Colors.white;
Color hintColor = Colors.grey.shade400;

//Color for the messageContainer
Color messageUserColor = Colors.lightBlue.shade200;
Color messageFriendColor = Colors.grey.shade300;

bool darkMode = false;
bool firstRendering = true;
bool chatPagefirstRendering = true;

//Color for the button
Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue.shade100;
    }
    return Colors.indigo.shade600;
}