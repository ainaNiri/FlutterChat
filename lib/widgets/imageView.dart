import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/utilities/firebaseStorage.dart';
import 'package:myapp/widgets/hero.dart';
import 'package:myapp/widgets/loadingDialog.dart';

// ignore: must_be_immutable
class ImageCollection extends StatelessWidget {
  String userId;
  String imageCollection;
  ImageCollection({ Key? key , required this.userId, required this.imageCollection}) : super(key: key);
  
  late File _imageFile;
  late String urlPic;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Container(
          padding: EdgeInsets.only(bottom: 30, top: 30, left: 5, right: 5),
          height: MediaQuery.of(context).size.height,
          color: kPrimaryColor,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FutureBuilder(
                  future: FirebaseDatabase.instance.reference().child("images/${this.imageCollection}/$userId").once(),
                  builder: (context, AsyncSnapshot <DataSnapshot> snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data!.value != null){
                        List<String> images = [];
                        snapshot.data!.value.forEach((key, value){
                          images.add(value["urlImage"]);
                        });
                        return Container(
                          color: kPrimaryColor,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.7
                            ),
                            itemCount: images.length, 
                            itemBuilder: (context, index){
                              return _buildImage(context, images[index], index);
                            }
                          )
                        );
                      }
                      if(this.userId == currentUser.id)  return Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        margin: EdgeInsets.only(top: 30), 
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              child: Image.asset("assets/images/image.jpg"),
                            ),
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Hi  ",
                                    style: TextStyle(color: textPrimaryColor ,fontWeight: FontWeight.w300, fontSize: 25), 
                                  ),
                                  TextSpan(
                                    text: currentUser.name + "!",
                                    style: TextStyle(color: textPrimaryColor ,fontWeight: FontWeight.w400, fontSize: 35,fontStyle: FontStyle.italic)
                                  )
                                ]
                              ),
                            ),
                            Text("Upload your photo here to share it with your friends", style: TextStyle(color: textPrimaryColor ,fontWeight: FontWeight.w300, fontSize: 14),)
                          ] ,
                        ),
                      ); else return Container();
                    }
                    return Container();
                  }
                ),
              ),
              if(this.userId == currentUser.id) ElevatedButton(
                onPressed: ()async {
                  _imageFile = await getImage();
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context){ return _sendImage(context, _imageFile, this.imageCollection);})
                  );
                } ,
                child: Text("Upload"),
                style: buttonStyle
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, String imageNetwork, int index){
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context){ return ImageView(image: imageNetwork, index: index.toString(),);})
        );
      },
      child: Hero(
        tag: "image"+index.toString(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(width: 0.5, color: Colors.black38)
          ),
          child: Image.network(imageNetwork, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _sendImage(BuildContext context, File imageUrl ,String imageRef){
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: InteractiveViewer(
                maxScale: 5,
                minScale: 0.8,
                child: Image.file(imageUrl)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              onPressed: () async {
                showLoadingIndicator(context);
                urlPic = await uploadPic(_imageFile, "profile/${this.imageCollection}");
                await FirebaseDatabase.instance.reference().child("images").child("${this.imageCollection}/${currentUser.id}").child(DateTime.now().toString().replaceAll(".", "")).set({"urlImage" :urlPic});
                Navigator.of(context).pop();
                Future.delayed(Duration(milliseconds: 500));
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context){ return ImageCollection(userId: this.userId, imageCollection: this.imageCollection,);})
                );              
              }, 
              child: Text("Upload"),
              style: buttonStyle,
            ),
          )
        ]
      ),
    );
  }
}