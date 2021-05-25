import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:alarmsystem/screen/SecondPage.dart';
import 'package:alarmsystem/screen/historyPage.dart';
import 'package:alarmsystem/screen/loginPage.dart';
import 'CustomClipper.dart';
import 'color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_switch/flutter_switch.dart';
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
  dynamic result = '';
  bool _network = false;
  String uidValue;
  String device_id = '';
  String getStatusText = '';
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  bool alertStatus = false;



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
        print('Auth Success: ${uidValue}');
        try {
          result = await InternetAddress.lookup('www.google.com').timeout(const Duration(seconds: 2));
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            DatabaseReference updateLoginStatus = new FirebaseDatabase()
                .reference()
                .child('users/${uidValue}/');
            updateLoginStatus.update({'login_status': true}).then((result){
              print('login_status: ${true}');
            }).catchError((result){
              print('login_status: ${false}');
            });

            DatabaseReference getStatusAlert = new FirebaseDatabase()
                .reference()
                .child('users/${uidValue}/alert_status');
            getStatusAlert.once().then((DataSnapshot alertValue) {
              setState(() {
                alertStatus = alertValue.value;
                print('AlertDefault From: ${alertStatus}');
              });
            }).catchError((result) {
              print('AlertDefault From: false (Can\'t get)');
            });
            print('connected');
          }
        } on TimeoutException catch (e) {
          print('not connected timeout');
          showError('Please check your internet connection !');
        } on SocketException catch (_) {
          print('not connected');
        }
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

  update(String token,String uid,) {
    print(token);
    DatabaseReference updateToken = new FirebaseDatabase().reference();
    updateToken.child('users/${uid}/fcm_token/').set({"token": token});
    setState(() {});
  }

  setAlert(bool value) {
      DatabaseReference setAlert = new FirebaseDatabase().reference().child('users/${uidValue}/');
      setAlert.update({'alert_status' : value}).then((result) {
        print('setAlertSuccess ${value}');
        setState(() {
          alertStatus = value;
        });
      }).catchError((result){
        print('error setAlert');
      });


  }

  readStatus() {

    DatabaseReference readDeviceId = new FirebaseDatabase().reference().child('users/${uidValue}/device_id');
    readDeviceId.once().then((DataSnapshot snapshot) {
       device_id = snapshot.value;
       DatabaseReference readStatus = new FirebaseDatabase().reference().child('device/${device_id}/');
       readStatus.once().then((DataSnapshot snapshot){
         if(snapshot.value['device_connect'] == "24:0A:C4:AA:14:94"){
           getStatusText = 'The motorcycle is connected to Base station 1';
         }else if(snapshot.value['device_connect'] == "24:0A:C4:AA:CD:E8") {
           getStatusText = 'The motorcycle is connected to Base station 2';
         }else{
           getStatusText = 'The motorcycle is disconnected from Base station';
         }
         showCkeckStatus(getStatusText);
         print(getStatusText);
       });
     }).catchError((result){
      getStatusText = 'Can\'t connected to network !';
      showError(getStatusText);
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
        padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
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
              setAlert(val);
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
            readStatus();
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



  void showCkeckStatus(String status) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Center(
              child: Text(
                'Motorcycle Status',
                style: new TextStyle(fontSize: 18.0,color: ColorPalette.black),
              ),
            ),
            content: Text('${status}'),
            actions: <Widget>[
              ckeckStatusokButton(),
            ],
          );
        });
  }

  void showError(String error) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Center(
              child: Text(
                'Error',
                style: new TextStyle(fontSize: 18.0,color: ColorPalette.black),
              ),
            ),
            content: Text('${error}'),
            actions: <Widget>[
              ckeckErrorButton(),
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

  Widget ckeckErrorButton() {

    return FlatButton(
      child: Text('OK'),
      onPressed: () {

        Navigator.of(context).pop();
        uidStatus();
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
