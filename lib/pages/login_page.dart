import 'dart:async';

import 'package:KETAgenda/pages/room_details_page.dart';
import 'package:KETAgenda/plugins/barcode_scan.dart';
import 'package:flutter/material.dart';
import '../components/login_button.dart';

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }
}

class LoginPage extends StatelessWidget {
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
                      new Container(
                        height: 150.0,
                        child: new Hero(
                          tag: 'imageHero',
                          child: new Image.asset("assets/logohr.png"),
                        ),
                      ),
                      new RichText(
                        text: new TextSpan(
                          text: "KET Agenda",
                          style: new TextStyle(
                              color: Colors.blueAccent, fontSize: 60.0),
                        ),
                      ),
                      new RichText(
                        text: new TextSpan(
                          text: "Reserveer ruimte met gemak",
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
            color: Colors.redAccent[700],
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // Login button with logic
                new LoginButton(),

                // Simple button
                new Container(
                  padding: new EdgeInsets.all(5.0),
                  height: 55.0,
                  width: double.infinity,
                  child: new FlatButton(
                    child: new Text("Scan QR code"),
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    onPressed: () {
                      Future startScan() async {
                        String barcode = await BarcodeScanner.scan();
                        Navigator.push(
                          context,
                          new MyCustomRoute(
                            builder: (_) => new RoomDetailsPage(roomId: barcode),
                          ),
                        );
                      }
                      startScan();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
