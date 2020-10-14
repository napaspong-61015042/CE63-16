import 'package:flutter/material.dart';
import 'package:myapp/screen/SecondPage.dart';
import 'color_palette.dart';
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
  // Method


//  Widget showMenu1() {
//    return Container(
//      width: 160.0,
//      height: 160.0,
//      child: Image.asset('images/on-off.png'),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.grey60,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('tracking and alarm system'),
      ),

      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
//                RaisedButton(
//                    child: showMenu1(),
//                    onPressed: () {
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (context) => SecondPage()));
//                    }
//                ),
                Card(
                  color: ColorPalette.grey10,
                  margin: EdgeInsets.all(10),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  child: FlatButton(
                    height: 80.0,
                    minWidth: 350.0,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SecondPage()));
                    },
                    child: ListTile(
                      //จัดวางองค์ประกอบใน card
                      leading: Icon(
                        //การแสดง icon ใน card
                        Icons.add_to_home_screen,
                        size: 45.0,
                        color: ColorPalette.grey60,
                      ),
                      title: Text(
                        //การแสดงข้อความใน card
                        'ON-OFF System',
                        style: TextStyle(color: Colors.black87, fontSize: 20.0),
                      ),
                    ),
                  ),
                ),

                Card(
                  color: ColorPalette.grey10,
                  margin: EdgeInsets.all(10),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  child: FlatButton(
                    height: 80.0,
                    minWidth: 350.0,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SecondPage()));
                    },
                    child: ListTile(
                      //จัดวางองค์ประกอบใน card
                      leading: Icon(
                        //การแสดง icon ใน card
                        Icons.add_alert,
                        size: 45.0,
                        color: ColorPalette.grey60,
                      ),
                      title: Text(
                        //การแสดงข้อความใน card
                        'Alert',
                        style: TextStyle(color: Colors.black87, fontSize: 20.0),
                      ),
                    ),
                  ),
                ),

                Card(
                  color: ColorPalette.grey10,
                  margin: EdgeInsets.all(10),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  child: FlatButton(
                    height: 80.0,
                    minWidth: 350.0,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SecondPage()));
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

                Card(
                  color: ColorPalette.grey10,
                  margin: EdgeInsets.all(10),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  child: FlatButton(
                    height: 80.0,
                    minWidth: 350.0,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SecondPage()));
                    },
                    child: ListTile(
                      //จัดวางองค์ประกอบใน card
                      leading: Icon(
                        //การแสดง icon ใน card
                        Icons.account_circle,
                        size: 45.0,
                        color: ColorPalette.grey60,
                      ),
                      title: Text(
                        //การแสดงข้อความใน card
                        'Setting',
                        style: TextStyle(color: Colors.black87, fontSize: 20.0),
                      ),
                    ),
                  ),
                ),



//              Container(
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  mainAxisSize: MainAxisSize.min,
//                  children: [showMenu2(), showMenu4()],
//                ),
//              )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 75.0,
        width: 75.0,
        child: FittedBox(
          child: FloatingActionButton(
            elevation: 0.0,
            backgroundColor: ColorPalette.grey60,
            child: Icon(Icons.home),
            onPressed: () {
//              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
