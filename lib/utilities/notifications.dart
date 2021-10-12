import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/screens/chatDetailPage/messagePage.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
  BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
  BehaviorSubject<String?>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

Future<void> saveTokenToDatabase(String? token) async {
  await FirebaseDatabase.instance.reference().child("users/users_connected/${currentUser.id}").set({
      'token': token,
      'connected': true
    });
}
Future<void> sendPushMessage(String? token, String id, String name, String message) async {
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/flutterchat-bda44/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(token, id, name, message),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
}

Future<void> initFirebaseMessaging()async{
  String? token = await FirebaseMessaging.instance.getToken();
  await saveTokenToDatabase(token);
  FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
}

/// The API endpoint here accepts a raw FCM payload for demonstration purposes.
String constructFCMPayload(String? token, String id, String name, String message) {
  return jsonEncode({
    'token': token,
    'data': {
      'via': 'FlutterChat Cloud Messaging!!!',
      'id': id,
    },
    'notification': {
      'title': name,
      'body': message,
    },
  });
}

void getNotifications(BuildContext context){
  FirebaseMessaging.instance
    .getInitialMessage()
    .then((RemoteMessage? message) {
    if (message != null) {
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context){
          return ChatDetailPage(id: message.data['id'], friend: message.data['friend'], friendConnected: message.data['friend']);
        })
      );
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            'channel description',
            priority: Priority.high,
            //icon: 'launch_image'
          ),
        )
      );
      }
    }
  );

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context){
        return ChatDetailPage(id: message.data['id'], friend: message.data['friend'], friendConnected: message.data['friend']);
      })
    );
  });
}