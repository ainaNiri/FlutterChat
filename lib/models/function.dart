import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

Future<String> uploadPic(File image) async {
  String url= "";
   FirebaseStorage storage =  FirebaseStorage.instance;
   // ignore: await_only_futures
   Reference ref = await storage.ref().child("profile/"+path.basename(image.toString()));
   UploadTask uploadTask = ref.putFile(image);
   url = await(await uploadTask).ref.getDownloadURL();
    print(image);
    return url;
}

Future<File> getImage() async {
  File image = File ("");
  final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  return image;
}