import 'package:flutter/material.dart';
import "package:newapp/ui/widgets/custom_flat_button.dart";
import "package:newapp/ui/widgets/custom_text_field.dart";
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                     decoration: InputDecoration(
                       hintText: 'Title'
                     ),
                    ),
                    SizedBox(height: 12.0,),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                       hintText: 'Description'
                     ),
                    ),
                    SizedBox(height: 12.0,),
                    FlatButton(
                      onPressed: createNotification,
                      child:Text('Add Reminder'),
                    )
                  ], 
                ),
              ),
              )
            )
          ],
        ),
    );
  }

  Future<void> selectTime() async{
      final time = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
        setState(() {
          selectedTime = time;
        });
    }
  void createNotification(){
    final title = _titleController.text;
    final description = _descriptionController.text;
    final time = Time(selectedTime.hour, selectedTime.minute);
    
    final notificationData = NotificationData(title, description, time);
    Navigator.of(context).pop(notificationData);

  }
}