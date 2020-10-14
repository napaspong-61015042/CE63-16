import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'icon_data.dart';
import 'home.dart';
import 'loginPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  final formKey = GlobalKey<FormState>();
  String nameString, emailString, passwordString, passwordConfirmString;

  Widget nameText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.face,
          color: Colors.white,
          size: 36.0,
        ),
        labelText: 'Full Name : ',
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        helperText: 'Type your Firstname and Lastname',
        helperStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        ),
        hintText: 'Harry Potter',
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please fill your Full Name in The Blank ';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        nameString =
            value.trim(); //trim = ตัดช่องว่างข้างหน้าและข้างหลังอัตโนมัติ
      },
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
        ),
        hintText: '60000000@kmitl.ac.th',
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      validator: (String value) {
        if (!((value.contains('@')) && (value.contains('.')))) {
          return 'Please type Email in Ex. 60000000@kmitl.ac.th';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        emailString =
            value.trim(); //trim = ตัดช่องว่างข้างหน้าและข้างหลังอัตโนมัติ
      },
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
        helperText: 'Type your Password more than 6 character',
        helperStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value) {
        if (value.length < 6) {
          return 'Password More 6 character';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        passwordString =
            value.trim(); //trim = ตัดช่องว่างข้างหน้าและข้างหลังอัตโนมัติ
      },
    );
  }

  Widget passwordConfirmText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.autorenew,
          color: Colors.white,
          size: 36.0,
        ),
        labelText: 'Re-password : ',
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        helperText: '',
        helperStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value) {
        if (value.length < 6) {
          return 'Password More 6 character';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        passwordConfirmString =
            value.trim(); //trim = ตัดช่องว่างข้างหน้าและข้างหลังอัตโนมัติ
      },
    );
  }

  Widget registerButton() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(30.0),
        child: MaterialButton(
          onPressed: () {
            print('You click upload');
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              print(
                  'name = $nameString, email = $emailString, pass = $passwordString');
              registerThread(); //เป็นการคอฟังก์ชั่น เมื่อไหรที่ได้รับname email pass จะมาทำงานที่ registerThread ต่อทันที
            }
//          Navigator.push(context,
//              MaterialPageRoute(builder: (context) => loginPage()));
          },
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child:
//          isloading ? CupertinoActivityIndicator() :
              Text('Register'),
        ),
      ),
    );
  }

  Future<void> registerThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (passwordString == passwordConfirmString && passwordString.length >= 6) {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: emailString, password: passwordString)
          .then((response) {
        print('Register Success for Email = $emailString');
      }).catchError((response) {
        String title = response.code;
        String message = response.message;
        print('title = $title, message = $message');
        myAlert(title, message); //คอร์ method
      });
    } else {
      print("Password and Confirm-password is not match.");
    }
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

  Widget loginButton() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: FlatButton(
          onPressed: () {
//          Navigator.push(context,
//              MaterialPageRoute(builder: (context) => SecondPage()));
          },
          child: Text('Already a User? Login'),
          textColor: Colors.white,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: ColorPalette.grey60,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Register',
          textAlign: TextAlign.center,
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            nameText(),
            emailText(),
            passwordText(),
            passwordConfirmText(),
            registerButton(),
            loginButton(),
          ],
        ),
      ),
    );
  }
}
