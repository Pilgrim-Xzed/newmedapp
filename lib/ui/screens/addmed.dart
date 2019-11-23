import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:newapp/business/firebasenotification.dart';
import 'package:newapp/ui/screens/local_notification.dart';
import 'package:newapp/ui/screens/main_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


  
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:scheduled_notifications/scheduled_notifications.dart';

  
enum days { MON, TUE, WED, THURS, FRI, SAT, SUN }

class AddMed extends StatefulWidget {
  final FirebaseUser firebaseUser;
  AddMed(this.firebaseUser);
  @override
  _AddMedState createState() => _AddMedState();
}

class _AddMedState extends State<AddMed> {
  
  String dropdownvalue = "Once daily";
  String selected = "Every day";
  List<String> itemlist = ['Every day', 'Specific days of the week'];
  String answer = '';
  bool _isChecked = false;
  bool _monval = false;
  final db = Firestore.instance;
  final notifications = FlutterLocalNotificationsPlugin();
  final _formKey = GlobalKey<FormState>();

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
  

  void _dialogResult(String val) {
    if (val == 'quit') {
      Navigator.of(context).pushNamed('/main');
    } else {
      Navigator.of(context).pop();
    }
    
  }

  void showAlertDialog() {
    AlertDialog dialog = new AlertDialog(
      content:
          new Text('Sweetie, are you sure you want to discard unsaved changes?'),
      //style: new TextStyle(fontSize: 30.0,),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            _dialogResult('quit');
          },
          child: new Text("Quit"),
        ),
        new FlatButton(
          onPressed: () {
            _dialogResult('no');
          },
          child: new Text("No"),
        ),
      ],
    );
    showDialog<void>(
      context: context,
      child: dialog,
      barrierDismissible: false,
    );
  }


  TimeOfDay time = new TimeOfDay.now();
  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: time,
    );

    if (picked != null && picked != time) {
      print('${time.toString()}');
      setState(() {
        time = picked;
      });
    }
    
  }


  List<Widget> makeradios(List<String> elemlist) {
    List<Widget> list = new List<Widget>();

    list.add(
      new RadioListTile(
        onChanged: (String value) {
          onChangedradio(value);
        },
        value: elemlist.elementAt(0),
        title: new Text(elemlist.elementAt(0)),
        groupValue: selected,
      ),
    );
    list.add(
      new RadioListTile(
        onChanged: (String value) {
          onChangedradio(value);
          _askdays();
        },
        value: elemlist.elementAt(1),
        title: new Text(elemlist.elementAt(1)),
        groupValue: selected,
      ),
    );

    return list;
  }

  void onChangedradio(String value) {
    setState(() {
      selected = value;
    });
  }

  void setAnswer(String dialogvalue) {
    setState(() {
      answer = dialogvalue;
    });
  }

  Future<void> _askdays() async {
    //days dialog
    switch (await showDialog<days>(
      context: context,
      child: new SimpleDialog(
        title: new Text('Select days'),
        children: <Widget>[
          new SimpleDialogOption(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('MON'),
              value: _monval,
              onChanged: (bool value) {
                setState(() {
                  _monval = value;
                });
              },
            ),
            onPressed: () {
              Navigator.pop(context, days.MON);
            },
          ),
          new SimpleDialogOption(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('TUE'),
              value: _isChecked,
              onChanged: (bool value) {
                setState(() {
                  _isChecked = value;
                });
              },
            ),
            onPressed: () {
              Navigator.pop(context, days.TUE);
            },
          ),
          new SimpleDialogOption(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('WED'),
              value: _isChecked,
              onChanged: (bool value) {
                setState(() {
                  _isChecked = value;
                });
              },
            ),
            onPressed: () {
              Navigator.pop(context, days.WED);
            },
          ),
          new SimpleDialogOption(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('THURS'),
              value: _isChecked,
              onChanged: (bool value) {
                setState(() {
                  _isChecked = value;
                });
              },
            ),
            onPressed: () {
              Navigator.pop(context, days.THURS);
            },
          ),
          new SimpleDialogOption(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('FRI'),
              value: _isChecked,
              onChanged: (bool value) {
                setState(() {
                  _isChecked = value;
                });
              },
            ),
            onPressed: () {
              Navigator.pop(context, days.FRI);
            },
          ),
          new SimpleDialogOption(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('SAT'),
              value: _isChecked,
              onChanged: (bool value) {
                setState(() {
                  _isChecked = value;
                });
              },
            ),
            onPressed: () {
              Navigator.pop(context, days.SAT);
            },
          ),
          new SimpleDialogOption(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('SUN'),
              value: _isChecked,
              onChanged: (bool value) {
                setState(() {
                  _isChecked = value;
                });
              },
            ),
            onPressed: () {
              Navigator.pop(context, days.SUN);
            },
          ),
        ],
      ),
    )) {
      case days.MON:
        setAnswer('mon');
        break;
      case days.TUE:
        setAnswer('tue');
        break;
      case days.WED:
        setAnswer('wed');
        break;
      case days.THURS:
        setAnswer('thurs');
        break;
      case days.FRI:
        setAnswer('fri');
        break;
      case days.SAT:
        setAnswer('sat');
        break;
      case days.SUN:
        setAnswer('sun');
        break;
    }
  }

  final _medName = TextEditingController();
  final _dosageName = TextEditingController();
var _dateTime;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: new AppBar(
        
        /*leading: new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () {
              showAlertDialog();
            }),*/
        title: new Text('Add Medication'),
        backgroundColor: Color(0xFF21BFBD),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
          decoration: BoxDecoration(color: Color(0xffcccccc)),
          padding: EdgeInsets.all(20.0),
          child: new Column(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    new Text(
                      'Medication Name',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    new TextFormField(
                      controller: _medName,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Add medication/ treatment',
                      ),
                    ),
                  ],
                ),
              ),
              new SizedBox(
                height: 12.0,
              ),
              Card(
                  child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Center(
                      child: new Text(
                        'Reminder',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    new TextFormField(
                      controller:_dosageName ,
                      validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Dosage',
                        
                      ),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: DropdownButton<String>(
                          value: dropdownvalue,
                          onChanged: (String newvalue) {
                            setState(() {
                              dropdownvalue = newvalue;
                              //sonaddtime(dropdownvalue);
                            });
                          },
                          items: <String>[
                            "Once daily",
                            "Twice daily",
                            "Three times daily",
                            "Every 6 hours",
                            "Every 4 hours",
                            "Every 3 hours",
                            "Every 2 hours",
                            "Every hour"
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )
                    ]),
                   TimePickerSpinner(
    is24HourMode: false,
    normalTextStyle: TextStyle(
      fontSize: 24,
      color: Colors.deepOrange
    ),
    highlightedTextStyle: TextStyle(
      fontSize: 24,
      color: Colors.blueAccent,
    ),
    spacing: 50,
    itemHeight: 80,
    isForce2Digits: true,
    onTimeChange: (time) {
      setState(() {
        _dateTime = time;
      });
    },
  )
                  ],
                ),
              )),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //padding: EdgeInsets.all(10.0),
                    children: <Widget>[
                      new Center(
                        child: new Text(
                          'Schedule',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      new Row(
                        children: <Widget>[
                          new Text(
                            'Specify:',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                         
                        ],
                      ),
                      Divider(height: 12.0),
                      new Text(
                        'Days',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      Column(
                        children: makeradios(itemlist),
                      )
                      //addradio(['Every day', 'Selected days of the week']),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.grey,
                    child: new Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    onPressed: (){Navigator.of(context).pop();}
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  RaisedButton(
                    color: Colors.white,
                    child: new Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()){      
                        var data = {
                          "name": _medName.text,
                          "dosage": _dosageName.text,
                          "time": _dateTime,
                          "interval":dropdownvalue,
                          "infoid":widget.firebaseUser.uid
                          
                        };
                        await db.collection('info').add(data).then((onValue)=>{
                          showOngoingNotification(notifications,title:_medName.text,body:_dosageName.text,time:time),
                        });
                        Navigator.of(context).pop();
                    }},//asynclose
                  ),//where raisedbutton ended
                ],
              ),
            ],
          ),
        ),
      ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}