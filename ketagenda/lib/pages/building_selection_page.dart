import 'package:flutter/material.dart';
import '../components/login_button.dart';

class BuildingSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(
          //Top white part
          child: new Material(
            color: Colors.white,
            child: new Center(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new RichText(
                        text: new TextSpan(
                          text: "Gebouw",
                          style: new TextStyle(
                              color: Colors.blueAccent, fontSize: 60.0),
                        ),
                      ),
                      new RichText(
                        text: new TextSpan(
                          text: "Kies de vestiging waar u wilt gaan boeken",
                          style: new TextStyle(
                              color: Colors.blueAccent, fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        new Expanded(
          child: new Material(
            color: Colors.red,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //Add content
              ],
            ),
          ),
        ),
      ],
    );
  }
}
