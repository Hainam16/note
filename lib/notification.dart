// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_core/firebase_core.dart';
//
//
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   if(empty(message.data['notRefresh']) && factories['notificationRefresh'] != null){
//     factories['notificationRefresh']();
//   }
//   //await Firebase.initializeApp();
//   print("Handling a background message $message");
// }
//
//
// const AndroidNotificationChannel _defaultChannel = AndroidNotificationChannel(
//   'default',
//   'System Notifications',
//   description: 'System Notifications',
//   importance: Importance.max,
//   enableVibration: true,
//   playSound: true,
// );
// hasSupportPushNotification(){
//   return (isWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS);
// }
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
// class PushNotificationLib {
//   Future<void> initFirebase(
//       [List<AndroidNotificationChannel>? channels]) async {
//     print('initFirebase');
//     if (hasSupportPushNotification()) {
//       await Firebase.initializeApp();
//       print('initFirebase2');
//       const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('app_icon');
//       final IOSInitializationSettings initializationSettingsIOS =
//       IOSInitializationSettings(
//           requestAlertPermission: true,
//           requestBadgePermission: true,
//           requestSoundPermission: true,
//           onDidReceiveLocalNotification:
//               (int id, String? title, String? body, String? payload) async {}
//       );
//       const MacOSInitializationSettings initializationSettingsMacOS =
//       MacOSInitializationSettings(
//           requestAlertPermission: false,
//           requestBadgePermission: false,
//           requestSoundPermission: false);
//       final InitializationSettings initializationSettings = InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: initializationSettingsIOS,
//           macOS: initializationSettingsMacOS
//       );
//       await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//           onSelectNotification: (String? payload) async {
//             if (payload != null) {
//               final _payload = (payload is String && payload.startsWith('{') &&
//                   payload.endsWith('}')) ? jsonDecode(payload) : payload;
//               _handlerMessage(_payload);
//             }
//           }
//       );
//       print('initFirebase3');
//       FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//       print('initFirebase4');
//       if (Platform.isAndroid) {
//         final localNotificationAndroid = flutterLocalNotificationsPlugin
//             .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();
//         if (localNotificationAndroid != null) {
//           await localNotificationAndroid.createNotificationChannel(
//               _defaultChannel);
//           if (!empty(channels)) {
//             await Future.forEach(
//                 channels!, (AndroidNotificationChannel element) async {
//               await localNotificationAndroid.createNotificationChannel(element);
//             });
//           }
//         }
//       }
//       print('initFirebase5');
//       await FirebaseMessaging.instance
//           .setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//       print('initFirebase done');
//     }
//   }
// }