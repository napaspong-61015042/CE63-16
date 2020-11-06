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
  //ประกาศตัวแปร
  final FirebaseAuth firebaseAuth = FirebaseAuth
      .instance; //class ที่ชื่อว่า FirebaseAuth ซึ่งเราต้องสร้าง instance ก่อนใช้งาน
  String emailString, passwordString;
  final formKey = GlobalKey<FormState>(); //รับค่า email และ password
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

//method
  @override
  void initState() {
    //ทำงานอันดับแรก check สถานะ login
    super.initState();
    checkStatus();
  }

  Future<void> checkStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User user = await firebaseAuth.currentUser;
    if (user != null) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Home());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }
  }

  Future<User> checkAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .signInWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((response) {
      print('Authen Success');
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Home());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }).catchError((response) {
      String title = response.code; //หัวข้อของ error
      String message = response.message;
      myAlert(title, message);
    });
  }

  void myAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: ListTile(
            leading: Icon(
              Icons.add_alert,
              color: Colors.red,
              size: 36.0,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Container buildButtonSignIn() {
    return Container(
      child: InkWell(
        child: Container(
          constraints: BoxConstraints.expand(height: 50),
          child: FlatButton(
            child: Text(
              "Log in",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () {
              formKey.currentState.save();
              print('email = $emailString, password = $passwordString');
              checkAuthen(); //เมื่อรับค่า String จะมา check Authen
            },
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.green[300]),
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.all(12),
        ),
      ),
    );
  }

  Container buildTextFieldEmail() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.yellow[50], borderRadius: BorderRadius.circular(16),),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
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
        controller: passwordController,
        onSaved: (String value) {
          passwordString = value.trim();
        },
      ),
    );
  }

  Container buildOtherLine() {
    return Container(
        margin: EdgeInsets.only(top: 16),
        child: Row(children: <Widget>[
          Expanded(child: Divider(color: Colors.white)), //เส้นคั่น
          Padding(
              padding: EdgeInsets.all(6),
              child: Text("Don’t have an account?",
                  style: TextStyle(color: Colors.white))),
          Expanded(child: Divider(color: Colors.white)), //เส้นคั่น
        ]));
  }

  Container buildButtonRegister() {
    return Container(
      child: InkWell(
        child: Container(
          constraints: BoxConstraints.expand(height: 50),
          child: FlatButton(
            child: Text(
              "Sign up",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
//            onPressed: () {
//              formKey.currentState.save();
//              print('email = $emailString, password = $passwordString');
//              checkAuthen(); //เมื่อรับค่า String จะมา check Authen
//            },
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.orange[300]),
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.all(12),
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterPage()));
        },
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 220.0,
      height: 220.0,
      child: Image.asset('images/2-logo-2.png'),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.transparent,
//        elevation: 0.0,
//        title: Text('Sign In'),
//      ),
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(
                  0.8, 0.0), // 10% of the width, so there are ten blinds.
              colors: [
                const Color(0xFF34e89e),
                const Color(0xFF0f3443),
              ], // green to grey
//              tileMode: TileMode.repeated, // repeats the gradient over the canvas
            ),
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient:
                    LinearGradient(colors: [Colors.white12, Colors.white12]),
              ),
              margin: EdgeInsets.all(32),
              padding: EdgeInsets.all(22),
              child: ListView(
                children: <Widget>[
                  showLogo(),
                  buildTextFieldEmail(),
                  buildTextFieldPassword(),
                  buildButtonSignIn(),
                  buildOtherLine(),
                  buildButtonRegister()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
