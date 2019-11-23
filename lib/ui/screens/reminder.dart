import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:newapp/models/notification_data.dart';
import 'package:newapp/ui/screens/create_notification_page.dart';
import 'package:newapp/business/notification.dart';

class Reminder extends StatefulWidget{

  /*final String payload;

  const Reminder({
    @required this.payload,
    Key key,
  }) : super(key: key);*/

  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {

  final NotificationPlugin _notificationPlugin =  NotificationPlugin();
  Future<List<PendingNotificationRequest>> notificationFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationFuture = _notificationPlugin.getScheduledNotifications();
  }
  int id= 0;
  //final reminderName = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[IconButton(
                onPressed: () {Navigator.of(context).pop();},
                icon: Icon(Icons.arrow_back),
              ),],),
            FutureBuilder<List<PendingNotificationRequest>>(
              future: notificationFuture,
              initialData: [],
              builder: (context, snapshot) {
                final notifications = snapshot.data;
                return Expanded(
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return NotificationTile(
                        notification: notification,
                        deleteNotification: dismissNotification,
                        );
                    },
                  ),
                );
              },
            ),
          SizedBox(width: 300.0,
          child: RaisedButton(
            child: Text('Add Reminder'),
            color: Color(0xFF21BFBD),
            onPressed: navigateToNotificationCreation,
             )
          ),
        ],),
      ),);
  }
          //List<NotificationData> _notifications = List();
          Future<void> dismissNotification(int id) async {
            await _notificationPlugin.cancelNotifications(id);
            refreshNotification();
          }
          void refreshNotification(){
            setState((){
              notificationFuture = _notificationPlugin.getScheduledNotifications();
            });
          }

          Future<void> navigateToNotificationCreation() async{
            NotificationData notificationData = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreateNotificationPage(),
              ),
            );
            
            if (notificationData != null) {
              final notificationList = await _notificationPlugin.getScheduledNotifications();
              //int id =0;
              /*for(var i =0; i < 100; i++){
                bool exists = _notificationPlugin.checkifIdExists(notificationList, i);
                if(!exists){
                  id = i;
                }
              }*/
              await _notificationPlugin.showDailyAtTime(
                notificationData.time, 
                id, 
                notificationData.title, 
                notificationData.description
                );
                id++;
                setState(() {
                  notificationFuture = _notificationPlugin.getScheduledNotifications();
                });
            }
          }
}
class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key key,
    @required this.notification,
    @required this.deleteNotification,
  }) : super(key: key);

  final PendingNotificationRequest notification;
  final Function(int id) deleteNotification;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          title: Text(notification.title),
          subtitle: Text(notification.body),
          trailing: IconButton(
            onPressed: () => deleteNotification(notification.id),
            icon: Icon(Icons.delete),
          )
        ),
    );
  }
}
