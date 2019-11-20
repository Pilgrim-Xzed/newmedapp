import 'package:flutter/material.dart';
import 'package:newapp/ui/screens/reminder.dart';
import 'package:newapp/models/notification_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPlugin {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationPlugin(){
    _initializeNotifications();
  }

  void _initializeNotifications() {  
    var settingsAndroid = AndroidInitializationSettings('medical');
    var settingsIOS = IOSInitializationSettings();
    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(settingsAndroid, settingsIOS),
       onSelectNotification: onSelectedNotification);
  }
  Future onSelectedNotification(String payload) async {
    if (payload != null){
      debugPrint('notification payload: ' + payload);
    }
  }
  Future<void> showDailyAtTime(Time time, int id, String title,
  String description) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'show weekly channel id',
      'show weekly channel name',
      'show weeky description',
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
       iOSPlatformChannelSpecifics
    );
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      id, title, description, time, platformChannelSpecifics,
    );
  }

  Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
    final pendingNotifications = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }
  Future cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  bool checkifIdExists(List<NotificationData> notifications, int id) {
    for (final notification in notifications) {
      if (notification.id == id) {
        return true;
      }
    }
    return false;
  }
  
}