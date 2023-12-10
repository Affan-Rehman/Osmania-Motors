import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('onBackgroundMessage: $message');
  print('onBackgroundMessage: ${message.notification!.body}');
  print('onBackgroundMessage: ${message.data.toString()}');
  print('onBackgroundMessage: ${message.notification!.title}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.defaultImportance,
  );
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  void handleMessage(RemoteMessage? message) async {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null || android != null) {
        print('onMessage: $message');
      }
    });
  }

  Future initLocalNotifications() async {
    const IOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('launch_background');
    final settings = InitializationSettings(iOS: IOS, android: android);
    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) async {
        final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
        print('onDidReceiveNotificationResponse: $message');
        handleMessage(message);
      },
    );
    final platform =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(_androidChannel);
    final platformIos =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    await platformIos?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: 'launch_background',
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );
      }
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    try {
      final token = await _firebaseMessaging.getToken();
      print('token: $token');
      initPushNotifications();
    } catch (e) {
      log(e.toString());
    }
    initLocalNotifications();
  }
}
