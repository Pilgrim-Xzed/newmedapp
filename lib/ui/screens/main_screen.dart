import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:newapp/business/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newapp/ui/screens/addmed.dart';
import 'package:newapp/ui/screens/reminder.dart';
import 'package:newapp/ui/screens/root_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
 
FirebaseUser firebaseUserMain ;
class MainScreen extends StatefulWidget {
  final FirebaseUser firebaseUser;

  MainScreen({this.firebaseUser});
  
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    Medications(),
    NotePad(),
    Measurements()
  ];

@override
  void initState() {
   firebaseUserMain = widget.firebaseUser;
    super.initState();
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.5,
        leading: new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        title: Text("Home"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF21BFBD),
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.medkit),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.notesMedical),
            title: Text("Notes  "),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            title: Text("Measurments"),
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF21BFBD),
                ),
                currentAccountPicture: Container(
                  height: 100.0,
                  width: 100.0,
                  child: CircleAvatar(
                    child: Icon(FontAwesomeIcons.user),
                  ),
                ),
                accountName: new Text(
                  '',
                  style: new TextStyle(),
                ),
                accountEmail: new Text(
                  widget.firebaseUser.email,
                  style: new TextStyle(),
                )),
            ListTile(
              title: Text('Measurement Reminder'),
              onTap: (){
                Reminder();
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                _logOut();
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  void _logOut() async {
    Auth.signOut();
  }
}

class Medications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('info').where("infoid",isEqualTo: firebaseUserMain.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return Scaffold(
              body: new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return new ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(
                                    width: 1.0, color: Colors.black))),
                        child: Icon(Icons.healing, color: Color(0xFF21BFBD)),
                      ),
                      title: Text(
                        document['name'].toString().toUpperCase(),
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                      subtitle: Row(
                        children: <Widget>[
                          Icon(Icons.linear_scale, color: Colors.green),
                          Text(document['interval'].toString(),
                              style: TextStyle(color: Colors.black))
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Firestore.instance
                              .collection('info')
                              .document(document.documentID)
                              .delete();
                        },
                        icon: Icon(Icons.delete, color: Color(0xFF21BFBD), size: 30.0),
                      ));
                }).toList(),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddMed(firebaseUserMain)),
                  );
                },
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: Color(0xFF21BFBD),
                ),
                backgroundColor: Colors.white,
              ),
            );
        }
      },
    );
  }
}

class NotePad extends StatefulWidget {
  @override
  _NotePadState createState() => _NotePadState();
}

class _NotePadState extends State<NotePad> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('notes').where("nid", isEqualTo:firebaseUserMain.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return Scaffold(
              body: new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingleDetailView(document)),
                        );
                      },
                      child: new ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(
                                        width: 1.0, color: Colors.black))),
                            child: Icon(Icons.textsms, color: Color(0xFF21BFBD)),
                          ),
                          title: Text(
                            document['title'].toString().toUpperCase(),
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                          trailing: IconButton(
                            onPressed: () {
                              Firestore.instance
                                  .collection('notes')
                                  .document(document.documentID)
                                  .delete();
                            },
                            icon: Icon(Icons.delete,
                                color: Color(0xFF21BFBD), size: 30.0),
                          )));
                }).toList(),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddNote()),
                  );
                },
                child: Icon(
                  FontAwesomeIcons.pencilAlt,
                  color: Color(0xFF21BFBD),
                ),
                backgroundColor: Colors.white,
              ),
            );
        }
      },
    );
  }
}

class AddNote extends StatelessWidget {
  final TextEditingController title = new TextEditingController();
  final TextEditingController note = new TextEditingController();
  final db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF21BFBD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextFormField(
                    controller: title,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Note Title",
                    ))),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextFormField(
                    maxLines: null,
                    controller: note,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter note here",
                    ))),
            RaisedButton(
              onPressed: () async {
                var data = {
                  "title": title.text,
                  "note": note.text,
                  "nid":firebaseUserMain.uid
                };
                await db.collection('notes').add(data);
                Navigator.of(context).pop();
              },
              child: Text("Add Note"),
            )
          ],
        ),
      ),
    );
  }
}

class Measurements extends StatefulWidget {
  @override
  _MeasurementsState createState() => _MeasurementsState();
}

enum FormType { isBloodPreasure, isWeight, isBloodSuger }

class _MeasurementsState extends State<Measurements> {
  FormType state;

  String _selected;

  @override
  void initState() {
    state = FormType.isBloodPreasure;

    super.initState();
  }

  _onAlertWithCustomContentPressed(context) {
    Alert(
        context: context,
        title: "MEASUREMENT",
        content: Column(
          children: <Widget>[
            RadioButtonGroup(
              labels: ["Weight", "Pulse", "Blood Pressure"],
              onChange: (String label, int index) {
                print("label: $label index: $index");
                setState(() {
                  _selected = label;
                });
              },
              onSelected: (String label) => print(label),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MeasurementPage(_selected)),
              );
            },
            child: Text(
              "ADD MEASUREMENT",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('measurements').where("mid",isEqualTo: firebaseUserMain.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return Scaffold(
              body: new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingleDetailView(document)),
                        );
                      },
                      child: new ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(
                                        width: 1.0, color: Colors.black))),
                            child: Icon(Icons.view_headline, color: Color(0xFF21BFBD)),
                          ),
                          title: Text(
                            "${document['type'].toString().toUpperCase()} -> ${document['measurement']}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                          trailing: IconButton(
                            onPressed: () {
                              Firestore.instance
                                  .collection('measurements')
                                  .document(document.documentID)
                                  .delete();
                            },
                            icon: Icon(Icons.delete,
                                color: Color(0xFF21BFBD), size: 30.0),
                          )));
                }).toList(),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _onAlertWithCustomContentPressed(context);
                },
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: Color(0xFF21BFBD),
                ),
                backgroundColor: Colors.white,
              ),
            );
        }
      },
    );
  }
}

class SingleDetailView extends StatelessWidget {
  final DocumentSnapshot item;
  SingleDetailView(this.item);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.healing,
                color: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                item['title'].toString().toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                item['note'].toString(),
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ));
  }
}

class MeasurementPage extends StatefulWidget {
  final String selected;
  MeasurementPage(this.selected);
  @override
  _MeasurementPageState createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  final TextEditingController weightController = new TextEditingController();
  final TextEditingController sysLow = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            width: double.infinity,
            height: ScreenUtil.getInstance().setHeight(500),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, 15.0),
                      blurRadius: 15.0),
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, -10.0),
                      blurRadius: 10.0)
                ]),
            child: buildForm(),
          ),
        ),
      ),
    );
  }

  buildForm() {
    if (widget.selected == "Weight") {
      return Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Weight in KG",
              style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(45),
                  fontFamily: "Poppins-Bold",
                  letterSpacing: .6),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text(
              "Weight",
              style: TextStyle(
                fontFamily: "Poppins-Medium",
                fontSize: ScreenUtil.getInstance().setSp(26),
              ),
            ),
            TextField(
              controller: weightController,
              decoration: InputDecoration(
                  hintText: "Enter Weight in KG",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Firestore.instance.collection('measurements').add(
                      {"type": "Weight", "measurement": weightController.text,"mid":firebaseUserMain.uid});
                         Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RootScreen()),
                  );
                },
                child: Container(
                  width: ScreenUtil.getInstance().setWidth(350),
                  height: ScreenUtil.getInstance().setHeight(80),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFF6078ea).withOpacity(.1),
                            offset: Offset(0.0, 8.0))
                      ]),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Center(
                        child: Text("ADD",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Comic-sans-ms",
                              fontSize: 18,
                              letterSpacing: 1.0,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (widget.selected == "Pulse") {
      return Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Pulse",
              style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(45),
                  fontFamily: "Poppins-Bold",
                  letterSpacing: .6),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text(
              "Pulse Measurement",
              style: TextStyle(
                fontFamily: "Poppins-Medium",
                fontSize: ScreenUtil.getInstance().setSp(26),
              ),
            ),
            TextField(
              controller: weightController,
              decoration: InputDecoration(
                  hintText: "Enter Pulse Rate",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Firestore.instance.collection('measurements').add(
                      {"type": "Pulse", "measurement": weightController.text,"mid":firebaseUserMain.uid});
                        Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RootScreen()),
                  );
                      
                },
                child: Container(
                  width: ScreenUtil.getInstance().setWidth(350),
                  height: ScreenUtil.getInstance().setHeight(80),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFF6078ea).withOpacity(.1),
                            offset: Offset(0.0, 8.0))
                      ]),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Center(
                        child: Text("ADD",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Comic-sans-ms",
                              fontSize: 18,
                              letterSpacing: 1.0,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Blood Pressure",
              style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(45),
                  fontFamily: "Poppins-Bold",
                  letterSpacing: .6),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text(
              "Sys-High",
              style: TextStyle(
                fontFamily: "Poppins-Medium",
                fontSize: ScreenUtil.getInstance().setSp(26),
              ),
            ),
            TextField(
              controller: weightController,
              decoration: InputDecoration(
                  hintText: "Enter Sys-high",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),


             SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text(
              "Sys-Low",
              style: TextStyle(
                fontFamily: "Poppins-Medium",
                fontSize: ScreenUtil.getInstance().setSp(26),
              ),
            ),
            TextField(
              controller: sysLow,
              decoration: InputDecoration(
                  hintText: "Enter Sys-Low",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Firestore.instance.collection('measurements').add(
                      {"type": "BP", "measurement": "Sys-H:${weightController.text} -> Sys-L${sysLow.text}","mid":firebaseUserMain.uid});
                        double high = double.parse(weightController.text);
                        double low = double.parse(sysLow.text);
                        if(high >180 && low <120){
                          AlertDialog dialog = new AlertDialog(
                          content:new Text('Not to stress you out but do inform your doctor about the situation'),
                          actions: <Widget>[
                          new FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: new Text("Ok"),
                        ),
                          ]);
                        };
                        Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RootScreen()),
                  );
                      
                },
                child: Container(
                  width: ScreenUtil.getInstance().setWidth(350),
                  height: ScreenUtil.getInstance().setHeight(80),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFF6078ea).withOpacity(.1),
                            offset: Offset(0.0, 8.0))
                      ]),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Center(
                        child: Text("ADD",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Comic-sans-ms",
                              fontSize: 18,
                              letterSpacing: 1.0,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
