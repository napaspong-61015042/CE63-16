import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'icon_data.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

Widget nameText() {
  return TextFormField(
    decoration: InputDecoration(
        icon: Icon(
          Icons.face,
          color: Colors.white,
          size: 36.0,
        ),
        labelText: 'Display Name : ',
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        helperText: 'Type your Name for Display',
        helperStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        )),
  );
}

Widget emailText() {
  return TextFormField(
    decoration: InputDecoration(
        icon: Icon(
          Icons.email,
          color: Colors.white,
          size: 36.0,
        ),
        labelText: 'Email : ',
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        helperText: 'Type your Email',
        helperStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        )),
  );
}

Widget passwordText() {
  return TextFormField(
    decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          color: Colors.white,
          size: 36.0,
        ),
        labelText: 'Password : ',
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        helperText: 'Type your Password',
        helperStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        )),
  );
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: ColorPalette.grey60,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Register'),
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          nameText(),
          emailText(),
          passwordText(),
        ],
      ),
    );
  }
}
