import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'icon_data.dart';
import 'home.dart';
import 'SecondPage.dart';

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
        labelText: 'Name : ',
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
        helperText: 'Type your Password more than 6 character',
        helperStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        )),
  );
}

Widget idcardText() {
  return TextFormField(
    decoration: InputDecoration(
        icon: Icon(
          Icons.credit_card,
          color: Colors.white,
          size: 36.0,
        ),
        labelText: 'ID card number : ',
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        helperText: 'Type your ID card number 13 digits',
        helperStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        )),
  );
}

Widget telephoneText() {
  return TextFormField(
    decoration: InputDecoration(
        icon: Icon(
          Icons.phone,
          color: Colors.white,
          size: 36.0,
        ),
        labelText: 'Telephone Number : ',
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        helperText: 'Type your Telephone number 10 digits',
        helperStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        )),
  );
}

Widget motorcyclebrandsText() {
  return TextFormField(
    decoration: InputDecoration(
        icon: Icon(
          Icons.motorcycle,
          color: Colors.white,
          size: 36.0,
        ),
        labelText: 'Motorcycle Brands : ',
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        helperText: 'Ex. Honda Click, Yamaha Fino, Honda Zoomer-X',
        helperStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        )),
  );
}

Widget motorcyclelicenseplateText() {
  return TextFormField(
    decoration: InputDecoration(
        icon: Icon(
          Icons.web,
          color: Colors.white,
          size: 36.0,
        ),
        labelText: 'Motorcycle license plate : ',
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
        helperText: 'Type your Motorcycle license plate',
        helperStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        )),
  );
}

Widget registerButton() {
  return Container(
    child: Padding(
      padding: EdgeInsets.all(30.0),
      child: MaterialButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        onPressed: () {},
        child:
//          isloading ? CupertinoActivityIndicator() :
            Text('Register'),
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
//          Navigator.push(context,
//              MaterialPageRoute(builder: (context) => SecondPage()));
        },
        child: Text('Already a User? Login'),
        textColor: Colors.white,
      ),
    ),
  );
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: ColorPalette.grey90,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Register',
          textAlign: TextAlign.center,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          nameText(),
          emailText(),
          passwordText(),
          idcardText(),
          telephoneText(),
          motorcyclebrandsText(),
          motorcyclelicenseplateText(),
          registerButton(),
          loginButton(),
        ],
      ),
    );
  }
}
