import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String _buttonText;
  final Widget navigateToPage;

  LoginButton(this._buttonText, this.navigateToPage);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 50.0,
      width: double.infinity,
      margin: new EdgeInsets.all(10.0),
      child: new FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => this.navigateToPage),
          );
        },
        child: new Text(_buttonText),
        color: Colors.lightBlue,
        textColor: Colors.white,
      ),
    );
  }
}
