import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class CustomNotifications {
  initInfo() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          playSound: true,
          channelKey: 'Unza Pay',
          channelName: 'Unza Pay',
          channelDescription: 'Notification channel for Unza Pay',
          //defaultColor: primaryAppColor,
          //ledColor: const Color(0xFF9D50DD),
          importance: NotificationImportance.High,
          icon: 'resource://drawable/notifications_logo.png',
        )
      ],
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('..................onMessage...................');
      log(
          'onMessage: ${message.notification?.title}/${message.notification?.body}');

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 0,
          channelKey: 'Unza Pay',
          title: message.notification?.title,
          body: message.notification?.body,
          largeIcon: "asset://assets/images/notifications_logo.png",
        ),
      );
    });
  }

  void requestPermission() async {
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
      log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log("User declined or has accepted permission");
    }
  }
}
