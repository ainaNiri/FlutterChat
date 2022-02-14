import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/screens/chatDetailPage/messagePage.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//   BehaviorSubject<ReceivedNotification>();

// final BehaviorSubject<String?> selectNotificationSubject = BehaviorSubject<String?>();

// const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');

// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });

//   final int id;
//   final String? title;
//   final String? body;
//   final String? payload;
// }

Future <void> initNotification() async{
  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_notification');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //onSelectNotification: onSelectNotification
  );

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
    
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}

Future<void> saveTokenToDatabase(String? token) async {
  await FirebaseDatabase.instance.reference().child("users/users_connected/${currentUser.id}").set({
      'token': token,
      'connected': true
    });
}
Future<void> sendPushMessage(String? token, String chatId, String message, String myId,String name, String image) async {
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      final response = await Dio().post('http://192.168.43.67:8080/api/firebase/send_notification', 
        data: {'token': token, 'title': name, 'chat_id' : chatId, 'id': myId, 'body': message, 'image': image},
        options: Options(method: 'POST', headers: <String, dynamic>{},
        followRedirects: false,
        // will not throw errors
        validateStatus: (status) => true,)
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

void getNotifications(BuildContext context){



  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      User friend = new User(id: message.data["id"], name: message.data["name"], image: message.data["image"]);
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context){
          return ChatDetailPage(id: message.data['chat_id'], friend: friend, friendConnected: message.data['friend']);
        })
      );
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification!.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications', 
            'This channel is used for important notifications.', 
            priority: Priority.high,
          ),
        )
      );
      }
    }
  );

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    User friend = new User(id: message.data["id"], name: message.data["name"], image: message.data["image"]);
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context){
        return ChatDetailPage(id: message.data['chat_id'], friend: friend, friendConnected: true);
      })
    );
  });
}

void showNotification(){
  flutterLocalNotificationsPlugin.show(
    3,
    "title",
    "This is a body",
    NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications', 
        'This channel is used for important notifications.', 
        priority: Priority.high,
      ),
    )
  );
}


