import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'CustomClipper.dart';
import 'color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  //String uidValue = '';
  String uidValue;
  String device_id = '';
  String getStatusText = '';

  List<dynamic> listHistory = [];
  final FirebaseAuth firebaseAuth = FirebaseAuth
      .instance; //class ที่ชื่อว่า FirebaseAuth ซึ่งเราต้องสร้าง instance ก่อนใช้งาน
  //method
  @override
  void initState() {

    super.initState();
    historyStatus();

  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('dd/MM/yyyy  HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';
    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' Week ago';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' Weeks ago';
      }
    }
    return time;
  }

  String textStatus(int status) {
    String textStatus = '';
    if (status == 1) {
      textStatus = 'The motorcycle default';
    } else if (status == 2) {
      textStatus = 'The motorcycle has crashed down';
    } else if (status == 3) {
      textStatus = 'The motorcycle has lift';
    }
    return textStatus;
  }

  String checkStatus(String status) {
    String checkStatus = '';
    if (status == "24:0A:C4:AA:14:94") {
      checkStatus = 'form Base station 1';
    } else if (status == "24:0A:C4:AA:CD:E8") {
      checkStatus = 'form Base station 2';
    } else {
      checkStatus = ' is disconnected from Base station';
    }
    return checkStatus;
  }

  

  Future<void> historyStatus() async {
    String device = '';
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User user = await firebaseAuth.currentUser;

    if (user != null) {
      final databaseReferenceUser =
          FirebaseDatabase.instance.reference().child('users/' + user.uid);
      databaseReferenceUser.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        device = values['device_id'];
        final databaseReference = FirebaseDatabase.instance
            .reference()
            .child('device/' + device + '/history')
            .orderByChild('device_status_uptime');
        databaseReference.once().then((DataSnapshot snapshot) {
          //print(snapshot.value);
          Map<dynamic, dynamic> histories = snapshot.value;

          setState(() {
            listHistory = histories.values.toList()
              ..sort((a, b) => b['device_status_uptime']
                  .compareTo(a['device_status_uptime']));
          });
        });
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.green,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('History Alert'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12.0),
              itemCount: listHistory.length,
              itemBuilder: (context, index) {
                return Container(
                  height: MediaQuery.of(context).size.width * 0.3,
                  child: Card(
                    color: ColorPalette.grey10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 8,
                    child: ListTile(
                      title: Text(
                        '${readTimestamp(listHistory[index]['device_status_uptime'])}',
                        style: new TextStyle(fontSize: 15.0),
                      ),
                      subtitle: new Center(
                        child: Text(
                          '${textStatus(listHistory[index]['device_status'])},${checkStatus(listHistory[index]['device_connect'])}',
                          style: new TextStyle(fontSize: 18.0,color: ColorPalette.black),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
