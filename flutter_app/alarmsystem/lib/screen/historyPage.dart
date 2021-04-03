import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'CustomClipper.dart';
import 'color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>{

  String uidValue = '';
  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth firebaseAuth = FirebaseAuth
      .instance; //class ที่ชื่อว่า FirebaseAuth ซึ่งเราต้องสร้าง instance ก่อนใช้งาน

  //method
  @override
  void initState() {
    //ทำงานอันดับแรก check สถานะ login
    super.initState();
    historyStatus();
  }

  Future<void> historyStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User user = await firebaseAuth.currentUser;
    if (user != null) {
      print(user.uid);
      uidValue = user.uid;
      databaseReference.once().then((DataSnapshot snapshot) {
        print('${snapshot.value}');
      });
    }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.green,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Tracking And Alarm System'),
      ),

      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        height: MediaQuery.of(context).size.width * 0.5,
                        child: Card(
                          color: Colors.white60,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 8,
                          child: ListTile(
                            title: Text('ssssssssssssss'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}