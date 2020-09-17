import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'package:flutter/cupertino.dart';
import 'detail_page.dart';
import 'icon_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tracking and alarm system',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'tracking and alarm system'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.grey60,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          widget.title,
          style: TextStyle(color: ColorPalette.grey10),
        ),
      ),
      body: Container(
//        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            colors: [const Color(0xFF73C8A9), const Color(0xFF373B44)])
//        ),
        child: ListView.builder(
          itemCount: iconList.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailPage(
                  iconData: iconList[index],
                ))),

            child: Card(
              color: ColorPalette.grey10,
              margin: EdgeInsets.all(10),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: ListTile(
                  //จัดวางองค์ประกอบใน card
                  leading: Icon(
                    //การแสดง icon ใน card
                    iconList[index].icon,
                    size: 45.0,
                    color: ColorPalette.grey60,
                  ),
                  title: Text(
                    //การแสดงข้อความใน card
                    iconList[index].title,
                    style: TextStyle(color: Colors.black87, fontSize: 20.0),
                  ),
                ),
              ),
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
//                onPressed: () => Navigator.pushNamed(context, '/home')
        ),
      ),
    ),floatingActionButtonLocation:
    FloatingActionButtonLocation.centerFloat,
    );
  }
}
