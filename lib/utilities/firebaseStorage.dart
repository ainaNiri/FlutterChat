import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;


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

Future<FilePickerResult?> getFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true);
  print(result);
  return result;
}

String getFileName(FilePickerResult file){
  String fileName = file.files.first.name;
  return fileName;
}

Future<String> uploadFile(FilePickerResult file, String storageRef) async {

  Uint8List? fileBytes = file.files.first.bytes;
  String fileName = file.files.first.name;
  print(fileBytes);
  String url= "";
  FirebaseStorage storage =  FirebaseStorage.instance;
   // ignore: await_only_futures
  Reference ref = await storage.ref().child("$storageRef/"+fileName);
  UploadTask uploadTask = ref.putData(fileBytes!);
  url = await(await uploadTask).ref.getDownloadURL();
  print(url);
  return url;
}

Future download2(Dio dio, String url, String fileName) async {
  try {
    Response response = await dio.get(
      url,
      onReceiveProgress: showDownloadProgress,
      //Received data with List<int>
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        }),
    );
    print(response.headers);
    File file = File("/storage/emulated/0/Download/flutterChat/files/$fileName");
    var raf = file.openSync(mode: FileMode.write);
    // response.data is List<int> type
    raf.writeFromSync(response.data);
    await raf.close();
  } catch (e) {
    print(e);
  }
}

void showDownloadProgress(received, total) {
  if (total != -1) {
    print((received / total * 100).toStringAsFixed(0) + "%");
  }
}