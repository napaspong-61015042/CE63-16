import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'icon_data.dart';
import 'home.dart';
import 'loginPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  final formKey = GlobalKey<FormState>(); //รับค่า email และ password
  String nameString, emailString, passwordString, passwordConfirmString;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController _uid = TextEditingController();




  sendMessage(String uid,String name) {
  print(uid);
    var _firebaseRef = FirebaseDatabase().reference().child('users').child(uid);
    _firebaseRef.set({
      "name": name,
      'login_status' : true,
      'alert_status' : true,
      "user_create": DateTime.now().millisecondsSinceEpoch
      
    });
  }

  Widget nameText() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
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
//        hintText: 'Harry Potter',
//        hintStyle: TextStyle(
//          color: Colors.white,
//        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please fill your Full Name in The Blank ';
        } else {
          return null;
        }
      },
      controller: nameController,
    );
  }

  Widget emailText() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
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
        helperText: 'Ex. 60000000@kmitl.ac.th',
        helperStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        ),
//        hintText: '60000000@kmitl.ac.th',
//        hintStyle: TextStyle(
//          color: Colors.white,
//        ),
      ),
      validator: (String value) {
        if (!((value.contains('@')) && (value.contains('.')))) {
          return 'Please type Email in Ex. 60000000@kmitl.ac.th';
        } else {
          return null;
        }
      },
      controller: emailController,
    );
  }

  Widget passwordText() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      obscureText: true,
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
      controller: passwordController,
    );
  }

  Widget passwordConfirmText() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      obscureText: true,
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
      controller: confirmController,
    );
  }

  Widget registerButton() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(30.0),
        child: MaterialButton(
          height: 50.0,
          onPressed: () {
            print('You click upload');
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              print(
                  'name = $nameString, email = $emailString, pass = $passwordString');
              registerThread(); //เป็นการคอฟังก์ชั่น เมื่อไหรที่ได้รับname email pass จะมาทำงานที่ registerThread ต่อทันที

//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => LoginPage()));
            }
          },
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child:
//          isloading ? CupertinoActivityIndicator() :
              Text(
            'Register',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: FlatButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: Text('Already a User? Login',style: TextStyle(fontSize: 16.0),),
          textColor: Colors.orange,
        ),
      ),
    );
  }


  Future<void> registerThread() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmController.text.trim();
    String name = nameController.text.trim();
    if (password == confirmPassword && password.length >= 6) {
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((response) {
            sendMessage(response.user.uid,name);
        print('Register Success for Email = $email');

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginPage()));
      }).catchError((response) {
        String title = response.code;
        String message = response.message;
        print('title = $title, message = $message');
        myAlert(title, message); //คอร์ method
      });
    } else {
      String title2 = "";
      String message2 = "Password and Confirm-password is not match.";
      print("Password and Confirm-password is not match.");
      passwordNotMatch(title2, message2);
    }
  }


  void passwordNotMatch(String title2, String message2) {
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
              title2,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          content: Text(message2),
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


  Widget textRegister() {
    return Container(
      padding: EdgeInsets.only(left: 0.0, top: 20.0, bottom: 20.0),
      child: Text(
        'Create Account',
        style: TextStyle(fontSize: 30.0, color: Colors.white),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
//      backgroundColor: ColorPalette.grey60,
//      appBar: AppBar(
//        backgroundColor: Colors.transparent,
//        elevation: 0.0,
//        title: Text(
//          'Register',
//          textAlign: TextAlign.center,
//        ),
//      ),
      body: Form(
        key: formKey,
        child: Container(
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
          child: ListView(
            padding: EdgeInsets.all(30.0),
            children: <Widget>[
              textRegister(),
              nameText(),
              emailText(),
              passwordText(),
              passwordConfirmText(),
              registerButton(),
              loginButton(),
            ],
          ),
        ),
      ),
    );
  }
}
