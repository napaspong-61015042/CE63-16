import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myapp/screen/SecondPage.dart';
import 'package:myapp/screen/loginPage.dart';
import 'CustomClipper.dart';
import 'color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'icon_data.dart';

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

  // Method

  Widget signoutButton() {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      tooltip: 'Sign Out', //คลิกค้างจะมีข้อความขึ้น
      onPressed: () {
        myAlert();
      },
    );
  }

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

  Widget OnOff() {
    return Container(
      child: Card(
        margin: EdgeInsets.only(top: 20.0, right: 130.0, left: 130.0),
        color: ColorPalette.grey10,
        elevation: 0.0,
        shape: CircleBorder(),
        child: FlatButton(
          height: 120.0,
          minWidth: 100.0,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SecondPage()));
          },
          child: Icon(
            Icons.power_settings_new,
            color: ColorPalette.grey60,
            size: 45.0,
          ),
        ),
      ),
    );
  }

  Widget Alert() {
    return Container(
      child: Card(
        margin: EdgeInsets.only(top: 20.0, left: 200.0),
        color: ColorPalette.grey10,
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        child: FlatButton(
          height: 50.0,
          minWidth: 50.0,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SecondPage()));
          },
          child: ListTile(
            //จัดวางองค์ประกอบใน card
            leading: Icon(
              //การแสดง icon ใน card
              Icons.add_alert,
              size: 35.0,
              color: ColorPalette.grey60,
            ),
            title: Text(
              //การแสดงข้อความใน card
              'Alert',
              style: TextStyle(color: Colors.black87, fontSize: 18.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget checkStatus() {
    return Container(
      padding: const EdgeInsets.only(
          top: 10.0, right: 15.0, left: 15.0, bottom: 10.0),
      child: Card(
        color: ColorPalette.grey10,
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        child: FlatButton(
          height: 100.0,
          minWidth: 350.0,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SecondPage()));
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
        title: Text('tracking and alarm system'),
        actions: <Widget>[
          signoutButton(),
        ],
      ),

      body: Center(
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(color: ColorPalette.grey30),
              ClipPath(
                clipper: BottomWaveClipper(),
                child: Container(
                  color: ColorPalette.green,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: <Widget>[
                        OnOff(),
                      ],
                    ),
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
