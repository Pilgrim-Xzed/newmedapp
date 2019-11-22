import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';

NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: true,
      autoCancel: false);
  final iOSChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}

Future showOngoingNotification(FlutterLocalNotificationsPlugin notifications,{ @required title,@required body,TimeOfDay time}) async{
  var scheduledNotificationDateTime =
      new DateTime.now().add(new Duration(seconds: time.minute));
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your other channel id', 
      'your other channel name',
      'your other channel description');
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  NotificationDetails platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  
  await notifications.schedule(
    0,
    title,
    body,
    scheduledNotificationDateTime,
    platformChannelSpecifics);
}

Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  int id = 0,
}) =>
    notifications.show(id, title, body, type);
