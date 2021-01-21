import 'package:flutter/material.dart';
import 'CustomClipper.dart';
import 'color_palette.dart';

class historyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Alert'),
        backgroundColor: ColorPalette.green,
        elevation: 0.0,
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
            ],
          ),
        ),
      ),
    );
  }
}
