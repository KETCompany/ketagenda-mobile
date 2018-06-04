import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginButton extends StatefulWidget {
  @override
  _LoginButton createState() => new _LoginButton();
}

class _LoginButton extends State<LoginButton> {
  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  AlertDialog isLoggedIn;

  Future<Null> _handleSignIn() async {
    await _googleSignIn.signOut();
    await _googleSignIn.signIn();
    if (_googleSignIn.currentUser.email != "") {
      if(_googleSignIn.currentUser.email.split("@")[1] == "hr.nl"){
        Navigator.of(context).pushNamed('/FirstTimePage');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 50.0,
      width: double.infinity,
      margin: new EdgeInsets.only(left: 5.0, right: 5.0, bottom: 0.0),
      child: new FlatButton(
        onPressed: () {
          _handleSignIn();
        },
        child: new Text("Inloggen"),
        color: Colors.lightBlue,
        textColor: Colors.white,
      ),
    );
  }
}
