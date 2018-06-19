import 'dart:async';

import 'package:KETAgenda/services/api_tools.dart';
import 'package:KETAgenda/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:KETAgenda/globals.dart' as globals;

class LoginButton extends StatefulWidget {
  @override
  _LoginButton createState() => new _LoginButton();
}

class _LoginButton extends State<LoginButton> {

  bool apiIsOnline = true;
  Future<Null> checkAPI() async {
    new Authentication().handleSignOut();
    // Check multiple endpoints to see if API is responding correctly
    bool isOnline = await new API().checkAPI(globals.baseAPIURL, {});
    setState(() {
      apiIsOnline = isOnline ? true : false;
    });
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
            new Authentication().handleSignIn()
                .then((x) {
                  if(globals.user.apiToken != ""){
                    Navigator.of(context).pushNamed('/BuildingSelectionPage'); 
                  }
                })
                .catchError((e) => print(e));
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
