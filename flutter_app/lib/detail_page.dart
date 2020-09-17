import 'color_palette.dart';
import 'icon_data.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class DetailPage extends StatefulWidget {
  final IconModel iconData;


  DetailPage({Key key, @required this.iconData}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  get builder => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.grey90,
      body: SafeArea(
        child: Card(
            margin: EdgeInsets.all(10),
            clipBehavior: Clip.antiAlias,
            elevation: 0.0,
            color: ColorPalette.grey10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            child: Stack(children: <Widget>[
              Positioned.fill(
                  bottom: -90,
                  right: -90,
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        widget.iconData.icon,
                        size: 400,
                        color: ColorPalette.grey30,
                      ))),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 500,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).pop(true);
                                  return Future.value(false);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                )),
                            Text(
                              widget.iconData.title,
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 60.0),
                            ),
                          ]))),
            ])),
      ),
//      floatingActionButton: Container(
//        height: 75.0,
//        width: 75.0,
//        child: FittedBox(
//          child: FloatingActionButton(
//              elevation: 0.0,
//              backgroundColor: ColorPalette.grey60,
//              child: Icon(Icons.home),
//              onPressed: () => Navigator.pushNamed(context, '/home')
//          ),
//        ),
//      ),floatingActionButtonLocation:
//    FloatingActionButtonLocation.centerFloat,
    );
  }
}