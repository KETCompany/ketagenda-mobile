import 'package:flutter/material.dart';

class ServerOffline extends StatefulWidget {
  @override
  _ServerOffline createState() => new _ServerOffline();
}

class _ServerOffline extends State<ServerOffline> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Naar inlogscherm'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, "/");
            },
          ),
        ),
        backgroundColor: Colors.redAccent[700],
        body: new Column(
          children: <Widget>[
            new Expanded(
              //Top white part
              child: new Material(
                color: Colors.white,
                child: new Center(
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new RichText(
                        text: new TextSpan(
                          text: "Excuses",
                          style: new TextStyle(
                              color: Colors.blueAccent, fontSize: 60.0),
                        ),
                      ),
                      new RichText(
                        text: new TextSpan(
                          text: "De server is op dit moment niet bereikbaar.",
                          style: new TextStyle(
                              color: Colors.blueAccent, fontSize: 20.0),
                        ),
                      ),
                      new RichText(
                        text: new TextSpan(
                          text: "Probeer het later opnieuw.",
                          style: new TextStyle(
                              color: Colors.blueAccent, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
