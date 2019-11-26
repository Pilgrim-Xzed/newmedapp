import 'package:flutter/material.dart';
import 'package:newapp/business/notification.dart';
import 'package:newapp/ui/screens/local_notification.dart';
import 'package:scheduled_notifications/scheduled_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:newapp/models/notification_data.dart';

List<String> selectedDays = List();

class CreateNotificationPage extends StatefulWidget {
  @override 
  _CreateNotificationPageState createState() => _CreateNotificationPageState();
}

class _CreateNotificationPageState extends State<CreateNotificationPage> {

  final NotificationPlugin _notificationPlugin =  NotificationPlugin();
  Future<List<PendingNotificationRequest>> notificationFuture;
  
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
  
List<String> days = [
    "Mon",
    "Tue",
    "Wed",
    "Thurs",
    "Fri",
    "Sat",
    "Sun"
  ];


  


_showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Days"),
            content: MultiSelectChip(
              days,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedDays = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Done"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }
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
                Row(
                  children: <Widget>[
                    Text("Specify "),
                    InkWell(
                        onTap:(){
                          _showReportDialog();
                        },
                                              child: new Text(
                          'Days:${selectedDays}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                  ]
                ),
              SizedBox(height: 12.0,),
              RaisedButton(
                onPressed: (){if (_formKey.currentState.validate()){
                  createNotification();
                  
                }}, 
                child: Text('Add Reminder'),
              ),/*
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
         _notificationPlugin.showDailyAtTime(time, 0, title, description);
        //showOngoingNotification(notifications,title:title,body:description,time:selectedTime);
        Navigator.of(context).pop(notificationData);
    //Navigator.of(context).pop(notificationData);

  }
}
class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.reportList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices = List();

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item,style: TextStyle(color: Colors.green),),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}