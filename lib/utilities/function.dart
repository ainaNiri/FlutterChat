import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';

Future<String> uploadPic(File image, String storageRef) async {
  String url= "";
  FirebaseStorage storage =  FirebaseStorage.instance;
   // ignore: await_only_futures
  Reference ref = await storage.ref().child("$storageRef/"+path.basename(image.toString()));
  UploadTask uploadTask = ref.putFile(image);
  url = await(await uploadTask).ref.getDownloadURL();
  print(image);
  return url;
}

Future<File> getImage() async {
  File image = File ("");
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  return image;
}

void addFriendsToChat(List<String> selectedFriendsId, String chatId, String? name, String? image,) async {
  final chatRef = FirebaseDatabase.instance.reference().child("chats");
  if(name != null){
    await chatRef.child("chatsroom").child("grp" + chatId).set({
      "image": image,
      "name": name,
      "lastMessage": " ",
      "timestamp": DateTime.now().toString(),
    });
  }
  selectedFriendsId.add(currentUser.id);
  await chatRef.child("members").child("grp" + chatId).set(Map.fromIterable(selectedFriendsId, key: (e) => e, value: (e) => true));
  for(int i = 0; i < selectedFriendsId.length; i++){
    await FirebaseDatabase.instance.reference().child("users/users_friends/"+selectedFriendsId[i]).child("grp$chatId").set({"chatId": "grp$chatId"});;
  }
  await FirebaseDatabase.instance.reference().child("users/users_friends/${currentUser.id}").child("grp$chatId").set({"chatId": "grp$chatId"});
}

Future <void> saveNetworkImage(String imagePath) async {
  var response = await Dio().get(imagePath,
  options: Options(responseType: ResponseType.bytes));
  final result = await ImageGallerySaver.saveImage(
    Uint8List.fromList(response.data),
    quality: 60,
    name: "hello");
  print(result);
}

requestPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();

  final info = statuses[Permission.storage].toString();
  print(info);
  
}

// Future<void> downloadFile() async {
//   Directory appDocDir = await getApplicationDocumentsDirectory();
//   File downloadToFile = File('${appDocDir.path}/download-logo.png');

//   try {
//     await firebase_storage.FirebaseStorage.instance
//         .ref('uploads/logo.png')
//         .writeToFile(downloadToFile);
//   } on firebase_core.FirebaseException catch (e) {
//     // e.g, e.code == 'canceled'
//   }
// }