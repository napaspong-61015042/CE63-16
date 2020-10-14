import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screen/home.dart';
import 'color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'registerPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth
      .instance; //class ที่ชื่อว่า FirebaseAuth ซึ่งเราต้องสร้าง instance ก่อนใช้งาน
  String emailString, passwordString;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign In", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green[200],
        ),
        body: Container(
            color: Colors.green[50],
            child: Center(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                          colors: [Colors.yellow[100], Colors.green[100]])),
                  margin: EdgeInsets.all(32),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildTextFieldEmail(),
                      buildTextFieldPassword(),
                      buildButtonSignIn(),
                    ],
                  )),
            )));
  }

  Container buildButtonSignIn() {
    return Container(
      child: InkWell(
        child: Container(
          constraints: BoxConstraints.expand(height: 50),
          child: Text(
            "Sign in",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.green[200]
          ),
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.all(12),
        ),
        onTap: () {
          Home();
        },
      ),
    );
  }

  Container buildTextFieldEmail() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
      child: TextFormField(
        decoration: InputDecoration.collapsed(hintText: "Email"),
        style: TextStyle(fontSize: 18),
        controller: emailController,
        onSaved: (String value) {
          emailString = value.trim();
        },
      ),
    );
  }

  Container buildTextFieldPassword() {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration.collapsed(hintText: "Password"),
        style: TextStyle(fontSize: 18),
        onSaved: (String value) {
          passwordString = value.trim();
        },
      ),
    );
  }

  Future<void> signIn() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth
        .signInWithEmailAndPassword(
      email: passwordString,
      password: passwordString,
    )
        .then((response) {
      print("signed in $emailString");
    }).catchError((error) {
      print(error);
    });
  }
}
