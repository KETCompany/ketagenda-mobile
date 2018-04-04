import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Widget navigateToPage;

  LoginButton(this.navigateToPage);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 50.0,
      width: double.infinity,
      margin: new EdgeInsets.only(left: 5.0, right: 5.0, bottom: 0.0),
      child: new FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/FirstTimePage');
        },
        child: new Text("Inloggen"),
        color: Colors.lightBlue,
        textColor: Colors.white,
      ),
    );
  }
}
