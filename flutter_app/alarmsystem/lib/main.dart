import 'package:flutter/material.dart';
import 'package:alarmsystem/screen/home.dart';
import 'package:alarmsystem/screen/loginPage.dart';
import 'screen/registerPage.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

