import 'dart:async';

import 'package:KETAgenda/services/api_tools.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../globals.dart' as globals;

class LoginButton extends StatefulWidget {
  @override
  _LoginButton createState() => new _LoginButton();
}

StreamSubscription periodicSub;

class _LoginButton extends State<LoginButton> {
  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  bool apiIsOnline = false;
  Future<Null> checkAPI() async {
    // Check if I can get status code 200 back
    bool isOnline = await new API().urlResponseOK(globals.baseAPIURL);
    bool isReturningHelloWorld =
        await new API().retrieveHelloWorldJSON(globals.baseAPIURL);
    setState(() {
      apiIsOnline = isOnline && isReturningHelloWorld ? true : false;
    });
  }

  Future<Null> _handleSignIn() async {
    await checkAPI();
    if (apiIsOnline) {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn();
      if (_googleSignIn.currentUser.email != "") {
        if (_googleSignIn.currentUser.email.split("@")[1] == "hr.nl") {
          globals.user.displayName = _googleSignIn.currentUser.displayName;
          globals.user.email = _googleSignIn.currentUser.email;
          // TODO: Check if its the first using the app
          // If thats the case, show /FirstTimePage. Else continue to rooms overview.
          Navigator.of(context).pushNamed('/FirstTimePage');
        }
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
          if (apiIsOnline) {
            _handleSignIn();
          } else {
            checkAPI();
          }
        },
        child: new Text(
            apiIsOnline ? "Inloggen" : "Server offline. Probeer opnieuw."),
        color: Colors.lightBlue,
        textColor: Colors.white,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkAPI();
  }
}
