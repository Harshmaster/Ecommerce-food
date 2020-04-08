
import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificaion{
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void configLocalNotification() {

  var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');

  var initializationSettingsIOS = new IOSInitializationSettings();

  var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
 

}


void showNotification(message) async {

  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(

    'your channel id', 'your channel name', 'your channel description',

    playSound: true,

    enableVibration: true,

    importance: Importance.Max,

    priority: Priority.High,

  );

  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  var platformChannelSpecifics =

  new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(

      0, message['title'].toString(), message['body'].toString(), platformChannelSpecifics,

      payload: json.encode(message));

}


}