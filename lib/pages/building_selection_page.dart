import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BuildingSelectionPage extends StatefulWidget {
  @override
  _BuildingSelectionPage createState() => new _BuildingSelectionPage();
}

class _BuildingSelectionPage extends State<BuildingSelectionPage> {
  //Get info from room number (result of QR code scan)
  String url = 'http://keta.superict.nl/api/rooms?name=';
  List data = new List();

  Future getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      data = resBody;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.redAccent[700],
      body: new Column(
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
                            text: "Kamer",
                            style: new TextStyle(
                                color: Colors.blueAccent, fontSize: 60.0),
                          ),
                        ),
                        new RichText(
                          text: new TextSpan(
                            text: "Kies de gewenste kamer",
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
            child: new Scaffold(
              backgroundColor: Colors.redAccent[50],
              body: new ListView.builder(
                itemCount: data.length > 0 ? data.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return new ListTile(
                    leading: new CircleAvatar(
                      child: new Text(data[index]["location"] != null
                          ? data[index]["location"]
                          : "?"),
                      backgroundColor: Colors.blueAccent,
                    ),
                    title: new Text(data[index]["name"].toString()),
                    subtitle: new Text('Type: ' +
                        data[index]["type"].toString().toUpperCase()),
                    onTap: () {
                      showDialog(
                        context: context,
                        child: new AlertDialog(
                          title: new Text("Nog niet beschikbaar!"),
                          content: new Text("Binnenkort kunt u hiervan gebruik maken."),
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }
}
