import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:alarmsystem/screen/SecondPage.dart';
import 'package:alarmsystem/screen/historyPage.dart';
import 'package:alarmsystem/screen/loginPage.dart';
import 'CustomClipper.dart';
import 'color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'icon_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class _HomeState extends State<Home> {
  //Explicit (ตัวแปร)
  Color _buttonColor1 = ColorPalette.grey10;
  final databaseReference = FirebaseDatabase.instance.reference();

  String textValue = 'Hello World !';
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  // Method

  @override
  void initState() {
    super.initState();

    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print(" onLaunch called ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) {
        print(" onResume called ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) {
        showNotification(msg);
        print(" onMessage called ${(msg)}");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    firebaseMessaging.getToken().then((token) {
      update(token);
    });
  }

  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'ticker',
      playSound: true,
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, "This is title", "this is demo", platform);
  }

  update(String token) {
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/${token}').set({"token": token});
    textValue = token;
    setState(() {});
  }

  void readData() {
    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }

  Widget signoutButton() {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      tooltip: 'Sign Out', //คลิกค้างจะมีข้อความขึ้น
      onPressed: () {
        myAlert();
      },
    );
  }

  //button log out

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to sign out?'),
            actions: <Widget>[
              cancleButton(),
              okButton(),
            ],
          );
        });
  }

  Widget cancleButton() {
    return FlatButton(
      child: Text(
        'Cancle',
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget okButton() {
    return FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();
        processSignOut();
      },
    );
  }

  Future<void> processSignOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((response) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => LoginPage());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  //end button log out

  Widget OnOff() {
    return Container(
      child: Card(
        margin: EdgeInsets.only(top: 20.0, right: 127.0, left: 105.0),
        color: _buttonColor1,
        elevation: 0.0,
        shape: CircleBorder(),
        child: FlatButton(
          height: 120.0,
          minWidth: 100.0,
          onPressed: () {
            setState(() {
              _buttonColor1 = Colors.green.shade800;
            });
//            Navigator.push(
//                context, MaterialPageRoute(builder: (context) => SecondPage()));
          },
          child: Icon(
            Icons.power_settings_new,
            color: ColorPalette.black,
            size: 45.0,
          ),
        ),
      ),
    );
  }

  Widget Alert() {
    return Container(
      padding: EdgeInsets.only(top: 80.0, right: 25.0, left: 25.0),
      alignment: Alignment.center,
      child: Card(
//        margin: EdgeInsets.only(top: 20.0, left: 200.0),
        color: ColorPalette.grey10,
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        child: FlatButton(
          height: 90.0,
          minWidth: 50.0,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => historyPage()));
          },
          child: ListTile(
            //จัดวางองค์ประกอบใน card
            leading: Icon(
              //การแสดง icon ใน card
              Icons.history,
              size: 45.0,
              color: ColorPalette.grey60,
            ),
            title: Text(
              //การแสดงข้อความใน card
              'History Alert',
//              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87, fontSize: 20.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget checkStatus() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
          top: 20.0, right: 25.0, left: 25.0, bottom: 10.0),
      child: Card(
        color: ColorPalette.grey10,
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        child: FlatButton(
          height: 90.0,
          minWidth: 50.0,
          onPressed: () {
            readData();
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => SecondPage()));
          },
          child: ListTile(
            //จัดวางองค์ประกอบใน card
            leading: Icon(
              //การแสดง icon ใน card
              Icons.check,
              size: 45.0,
              color: ColorPalette.grey60,
            ),
            title: Text(
              //การแสดงข้อความใน card
              'Check Status',
              style: TextStyle(color: Colors.black87, fontSize: 20.0),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.green,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Tracking And Alarm System'),
        actions: <Widget>[
          signoutButton(),
        ],
      ),

      body: Center(
        child: Container(
          child: Stack(
            children: <Widget>[
              // The containers in the background
              new Container(color: ColorPalette.grey90),
              ClipPath(
                clipper: BottomWaveClipper(),
                child: Container(
                  color: ColorPalette.green,
                ),
              ),
              new Container(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: <Widget>[
                      OnOff(),
                      Alert(),
                      checkStatus(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
//      floatingActionButton: Container(
//        height: 75.0,
//        width: 75.0,
//        child: FittedBox(
//          child: FloatingActionButton(
//            elevation: 0.0,
//            backgroundColor: ColorPalette.grey60,
//            child: Icon(Icons.home),
//            onPressed: () {
////              Navigator.pop(context);
//            },
//          ),
//        ),
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
