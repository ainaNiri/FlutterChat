// import 'package:flutter/material.dart';
// import 'package:myapp/models/chatMessageModel.dart';
// import 'package:myapp/screens/signInAndRegisterPage.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';

// class HomePage extends StatefulWidget{
//   HomePage({Key ?key}) :super(key: key);

//   @override
//   _HomePage createState() => _HomePage();
// }
// class _HomePage extends State<HomePage>{

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "Chat",
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Center(
//           child: Container(
//             width: 400,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 SizedBox(
//                   child: DefaultTextStyle(
//                     style: const TextStyle(
//                       fontSize: 70.0,
//                       color: Colors.black,
//                       fontFamily: 'Bobbers',
//                     ),
//                     child: AnimatedTextKit(
//                       animatedTexts: [
//                         TyperAnimatedText('MyChat', speed: Duration(milliseconds: 500)),
//                       ],
//                       onTap: () {
//                         print("Tap Event");
//                       },
//                     ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     ElevatedButton(
//                       onPressed: (){
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => SignInAndRegisterPage()));
//                         signIn = false;
//                       },  
//                       style: ElevatedButton.styleFrom(
//                         elevation: 2,
//                         padding: EdgeInsets.zero,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10))),
//                       child: Ink(
//                         decoration: BoxDecoration(
//                             gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)]),
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Container(
//                           width: 150,
//                           height: 60,
//                           alignment: Alignment.center,
//                           child: Text(
//                             'Register',
//                             style: TextStyle(fontSize: 24),
//                           ),
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => SignInAndRegisterPage()));signIn = true;}, 
//                       style: ElevatedButton.styleFrom(
//                         elevation: 2,
//                         padding: EdgeInsets.zero,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10))),
//                       child: Ink(
//                         decoration: BoxDecoration(
//                             gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)]),
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Container(
//                           width: 150,
//                           height: 60,
//                           alignment: Alignment.center,
//                           child: Text(
//                             'Sign In',
//                             style: TextStyle(fontSize: 24),
//                           ),
//                         ),
//                       ),
//                     )
//                   ]
//                 )
//               ]
//             )
//           )
//         )
//       )
//     );
//   }
// }