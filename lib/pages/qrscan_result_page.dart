import 'dart:async';
import 'dart:convert';
import 'package:KETAgenda/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../plugins/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class QRPage extends StatefulWidget {
  @override
  _QRPage createState() => new _QRPage(barcode: "");
}

class _QRPage extends State<QRPage> {
  _QRPage({this.barcode});
  String barcode;

  //Get info from room number (result of QR code scan)
  String url = "http://keta.superict.nl/api/rooms/";
  List data;
  String pageTitle = "Laden..";
  TextEditingController _controllerRoomName;
  TextEditingController _controllerRoomType;
  TextEditingController _controllerRoomLocation;
  TextEditingController _controllerRoomFloor;

  Future getSWData(roomnumber) async {
    var res = await http.get(Uri.encodeFull(url + roomnumber),
        headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      data = resBody;
      _controllerRoomName = new TextEditingController.fromValue(
          new TextEditingValue(text: data[0]["name"].toString()));
      _controllerRoomType = new TextEditingController.fromValue(
          new TextEditingValue(text: data[0]["type"].toString()));
      _controllerRoomLocation = new TextEditingController.fromValue(
          new TextEditingValue(text: data[0]["location"].toString()));
      _controllerRoomFloor = new TextEditingController.fromValue(
          new TextEditingValue(text: data[0]["floor"].toString()));
      pageTitle = data[0]["name"].toString();
    });
  }

  // Build
  @override
  Widget build(BuildContext context) {
    print("Barcode status: " + barcode);
    if (barcode.contains("null")) {
      //User pressed back btn of device during scan
      return new LoginPage();
    } else {
      if (barcode.isEmpty) {
        scan();
        return new Material(
          color: Colors.red,
          child: new Text("Scan de QR code"),
        );
      } else {
        return new Scaffold(
          backgroundColor: Colors.redAccent[700],
          body: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Expanded(
                child: new Container(
                  color: Colors.white,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new RichText(
                        text: new TextSpan(
                          text: this.pageTitle,
                          style: new TextStyle(
                              color: Colors.blueAccent, fontSize: 60.0),
                        ),
                      ),
                      new RichText(
                        text: new TextSpan(
                          text: "Kamer initialiseren",
                          style: new TextStyle(
                              color: Colors.blueAccent, fontSize: 20.0),
                        ),
                      ),
                      new Container(
                        height: 150.0,
                        child: new Hero(
                          tag: 'imageHero',
                          child: new Image.asset("assets/logohr.png"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              new Expanded(
                child: new SingleChildScrollView(
                  child: new Container(
                    color: Colors.redAccent[700],
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Center(
                          child: new Container(
                            padding: new EdgeInsets.all(5.0),
                            child: new RichText(
                              text: new TextSpan(
                                text: "Gegevens instellen",
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 28.0),
                              ),
                            ),
                          ),
                        ),
                        new Card(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new ListTile(
                                onTap: () {
                                  _controllerRoomName.clear();
                                },
                                leading: const Icon(Icons.title),
                                title: new TextField(
                                  controller: _controllerRoomName,
                                  decoration: new InputDecoration(
                                    hintText: "Wat is de code van de kamer?",
                                    labelText: "Kamer code",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Card(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new ListTile(
                                onTap: () {
                                  _controllerRoomType.clear();
                                },
                                leading: const Icon(Icons.title),
                                title: new TextField(
                                  controller: _controllerRoomType,
                                  decoration: new InputDecoration(
                                    hintText: "Wat voor type kamer is het?",
                                    labelText: "Kamer type",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Card(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new ListTile(
                                onTap: () {
                                  _controllerRoomLocation.clear();
                                },
                                leading: const Icon(Icons.title),
                                title: new TextField(
                                  controller: _controllerRoomLocation,
                                  decoration: new InputDecoration(
                                    hintText:
                                        "Op welke locatie bevind deze kamer zich?",
                                    labelText: "Kamer locatie",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Card(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new ListTile(
                                onTap: () {
                                  _controllerRoomFloor.clear();
                                },
                                leading: const Icon(Icons.title),
                                title: new TextField(
                                  controller: _controllerRoomFloor,
                                  decoration: new InputDecoration(
                                    hintText:
                                        "Op welke verdieping bevind deze kamer zich?",
                                    labelText: "Kamer verdieping",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new Container(
                margin: new EdgeInsets.all(5.0),
                child: new RaisedButton(
                  child: new Padding(
                    padding: new EdgeInsets.all(15.0),
                    child: new Text(
                      'Opslaan',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/");
                  },
                  color: Colors.blueAccent,
                  splashColor: Colors.blueAccent[50],
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      this.getSWData(barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
