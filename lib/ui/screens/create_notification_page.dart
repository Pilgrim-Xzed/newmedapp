import 'package:flutter/material.dart';
import "package:newapp/ui/widgets/custom_flat_button.dart";
import 'package:newapp/ui/screens/local_notification.dart';
import 'package:scheduled_notifications/scheduled_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:newapp/models/notification_data.dart';

class CreateNotificationPage extends StatefulWidget {
  @override 
  _CreateNotificationPageState createState() => _CreateNotificationPageState();
}

class _CreateNotificationPageState extends State<CreateNotificationPage> {
  
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  String _time = "not set";

  final _formKey = GlobalKey<FormState>();
  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    final settingsAndroid = AndroidInitializationSettings('medical');
    final settingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: ((id,title,body,payload)=>onSelectNotification(payload))

  
    );

        notifications.initialize(
        InitializationSettings(settingsAndroid,settingsIOS),
        onSelectNotification:onSelectNotification);
      
  }


  _scheduleNotification() async {
    int notificationId = await ScheduledNotifications.scheduleNotification(
        new DateTime.now().add(new Duration(seconds: 5)).millisecondsSinceEpoch,
        "Ticker text",
        "Content title",
        "Content");
  }



Future onSelectNotification(String payload) async => await Navigator.push(context, MaterialPageRoute(builder: (context)=>SecondPage()));
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Title",
                )),
              SizedBox(height: 12.0,),
              TextFormField(
                controller: _descriptionController,
                validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Description",
                )),
              SizedBox(height: 12.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.alarm),
                  FlatButton(
                    onPressed: () { selectTime();},
                    child: Text("$_time"),
                  ),
                ]),
              SizedBox(height: 12.0,),
              RaisedButton(
                onPressed: (){if (_formKey.currentState.validate()){
                  createNotification();
                }}, 
                child: Text('Add Reminder'),
              )/*
            CustomTextField(
              controller: _descriptionController,
              hint: 'Description',
            ),
            SizedBox(height: 12.0,),
            CustomFlatButton(
              onPressed: createNotification,
              title: 'Add Reminder',
            )*/
          ],
        ),
      ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<void> selectTime() async{
      final time = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
        if (time != null) {
          setState(() {
            selectedTime = time;
            _time = '${selectedTime.hour} : ${selectedTime.minute}';
        });
        }
    }
  void createNotification(){
    final title = _titleController.text;
    final description = _descriptionController.text;
    final time = Time(selectedTime.hour, selectedTime.minute);
    
    final notificationData = NotificationData(title, description, time);
    showOngoingNotification(notifications,title:title,body:description,time:selectedTime);
    Navigator.of(context).pop(notificationData);

  }
}
class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}