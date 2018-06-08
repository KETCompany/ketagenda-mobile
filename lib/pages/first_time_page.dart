import 'package:flutter/material.dart';

class FirstTimePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.redAccent[700],
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new Container(
              margin: new EdgeInsets.fromLTRB(40.0, 100.0, 40.0, 100.0),
              child: new Card(
                color: Colors.blueAccent[50],
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        height: 100.0,
                        child: new Hero(
                          tag: 'imageHero',
                          child: new Image.asset("assets/logohr.png"),
                        ),
                      ),
                      new RichText(
                        text: new TextSpan(
                          text: "Welkom",
                          style: new TextStyle(
                              color: Colors.blueAccent, fontSize: 20.0),
                        ),
                      ),
                      new Container(
                        width: 250.0,
                        child: new RichText(
                          text: new TextSpan(
                            text:
                                "Wij zien dat u een nieuwe gebruiker van dit systeem bent. Wilt u de uitleg starten?",
                            style: new TextStyle(
                                color: Colors.blueAccent, fontSize: 12.0),
                          ),
                        ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(top: 100.0),
                                child: new IconButton(
                                  splashColor: Colors.red,
                                  color: Colors.redAccent[700],
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/BuildingSelectionPage"
                                    );
                                  },
                                  icon: new Icon(Icons.thumb_down),
                                  highlightColor: Colors.redAccent[50],
                                ),
                              ),
                            ],
                          ),
                          new Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(top: 100.0),
                                child: new IconButton(
                                  splashColor: Colors.green,
                                  color: Colors.greenAccent[700],
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => new AlertDialog(
                                        title: new Text(
                                            "Probeer het later opnieuw"),
                                        content: new SingleChildScrollView(
                                          child: new ListBody(
                                            children: <Widget>[
                                              new Text(
                                                  'Op dit moment is er nog geen uitleg beschikbaar.'),
                                              new Text(
                                                  'Probeer het later opnieuw.'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: new Icon(Icons.thumb_up),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
