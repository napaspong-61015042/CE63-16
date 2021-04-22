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
import 'package:flutter_switch/flutter_switch.dart';
import 'package:custom_switch/custom_switch.dart';
import 'dart:async';

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

  String textValue = '';
  String uidValue = '';
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  bool alertStatus;

  // Method

  @override
  void initState() {
    uidStatus();
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
      update(token,uidValue);
    });
  }

  Future<void> uidStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User user = await firebaseAuth.currentUser;
    if (user != null) {
      //print(user);
      uidValue = user.uid;
      DatabaseReference getStatusAlert = new FirebaseDatabase().reference().child('users/${uidValue}/alert_status');
      getStatusAlert.once().then((DataSnapshot alertValue) {

        setState(() {
          alertStatus = alertValue.value;
          print('db: ${alertStatus}');
        });
      });
    }else{

    }
  }

  showNotification(Map<String, dynamic> msg) async {
    print(msg);
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
        0, msg['notification']['title'], msg['notification']['body'], platform);
  }

  update(String token,String uid) {
    print(token);
    DatabaseReference updateToken = new FirebaseDatabase().reference();
    updateToken.child('users/${uid}/fcm-token/').set({"token": token});
    textValue = token;
    setState(() {});
  }

  // void readData() {
  //   databaseReference.once().then((DataSnapshot snapshot) {
  //     print('Data : ${snapshot.value}');
  //   });
  // }

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

    DatabaseReference setSignout = new FirebaseDatabase().reference().child('users/${uidValue}');

    await firebaseAuth.signOut().then((response) {
      setSignout.update({'login_status': false});
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => LoginPage());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  //end button log out

  Widget OnOff() {
    return Container(
        padding: EdgeInsets.only(top: 50.0),
        alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlutterSwitch(
            width: 110.0,
            height: 47.0,
            activeColor: Colors.green,
            valueFontSize: 18.0,
            toggleSize: 40.0,
            value: alertStatus,
            borderRadius: 30.0,
            //padding: 8.0,
            showOnOff: true,
            onToggle: (val) {
              setState(() {
                alertStatus = val;
              });
            },
          ),
        ],
      )
    );
  }

  // button History Alert

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
                MaterialPageRoute(builder: (context) => HistoryPage()));
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

  // button check status

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
            showCkeckStatus();
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



  void showCkeckStatus() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Center(
              child: Text(
                'motorcycle status',
                style: new TextStyle(fontSize: 18.0,color: ColorPalette.black),
              ),
            ),
            content: Text('The motorcycle is connected to Base station 1.'),
            actions: <Widget>[
              ckeckStatusokButton(),
            ],
          );
        });
  }

  Widget ckeckStatusokButton() {

    return FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();

      },
    );
  }


  //end button check status

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
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        OnOff(),
                        Alert(),
                        checkStatus(),
                      ],
                    ),
                  )
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
