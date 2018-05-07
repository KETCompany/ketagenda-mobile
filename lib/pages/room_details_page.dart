import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RoomDetailsPage extends StatefulWidget {
  RoomDetailsPage({Key key, this.roomId}) : super(key: key);
  final String roomId;

  @override
  _RoomDetailsPage createState() => new _RoomDetailsPage(roomId);
}

class RoomInfo {
  String name = "...";
  String type = "...";
  String location = "...";
  String floor = "...";
  List booked = new List();
}

class _RoomDetailsPage extends State<RoomDetailsPage> {
  _RoomDetailsPage(this.roomId);
  final String roomId;

  //Get info from room number (result of QR code scan)
  String url = 'http://keta.superict.nl/api/rooms/';

  //Controllers
  RoomInfo _roomInfo = new RoomInfo();

  List data = new List();

  Future getSWData() async {
    var res = await http.get(Uri.encodeFull(url + roomId),
        headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      data = resBody;
      _roomInfo.name =
          data[0]["name"] != null ? data[0]["name"].toString() : "Unknown";
      _roomInfo.type =
          data[0]["type"] != null ? data[0]["type"].toString() : "Unknown";
      _roomInfo.location = data[0]["location"] != null
          ? data[0]["location"].toString()
          : "Unknown";
      _roomInfo.floor =
          data[0]["floor"] != null ? data[0]["floor"].toString() : "Unknown";
      _roomInfo.booked = data[0]["booked"];
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
                            text: "Kamer Details",
                            style: new TextStyle(
                                color: Colors.blueAccent, fontSize: 60.0),
                          ),
                        ),
                        new RichText(
                          text: new TextSpan(
                            text: "Alle gegevens van ${_roomInfo.name}",
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
          new Center(
            child: new Container(
              padding: new EdgeInsets.all(5.0),
              child: new RichText(
                text: new TextSpan(
                  text: "Gegevens",
                  style: new TextStyle(color: Colors.white, fontSize: 28.0),
                ),
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
                    new Card(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            leading: const Icon(Icons.title),
                            title: new Text(_roomInfo.name),
                            subtitle: new Text("Kamer"),
                          ),
                        ],
                      ),
                    ),
                    new Card(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            leading: const Icon(Icons.title),
                            title: new Text(_roomInfo.type),
                            subtitle: new Text("Type"),
                          ),
                        ],
                      ),
                    ),
                    new Card(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            leading: const Icon(Icons.title),
                            title: new Text(_roomInfo.location),
                            subtitle: new Text("Locatie"),
                          ),
                        ],
                      ),
                    ),
                    new Card(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            leading: const Icon(Icons.title),
                            title: new Text(_roomInfo.floor),
                            subtitle: new Text("Verdiepingsnummer"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          new Center(
            child: new Container(
              padding: new EdgeInsets.all(5.0),
              child: new RichText(
                text: new TextSpan(
                  text: "Rooster",
                  style: new TextStyle(color: Colors.white, fontSize: 28.0),
                ),
              ),
            ),
          ),
          new Expanded(
            child: ListView.builder(
              itemCount: _roomInfo.booked.length,
              itemBuilder: (BuildContext context, int index) {
                return new ListTile(
                  leading: new CircleAvatar(
                    child: new Text(_roomInfo.booked[index]["duration"] != null
                        ? _roomInfo.booked[index]["duration"].toString() + "u"
                        : "?"),
                    backgroundColor: Colors.blueAccent,
                  ),
                  title: new Text(
                    "Klas: ${_roomInfo.booked[index]["class"]}",
                    style: new TextStyle(color: Colors.white),
                  ),
                  subtitle: new Text(
                    'Lescode: ${_roomInfo.booked[index]["subjectCode"]}',
                    style: new TextStyle(color: Colors.white70),
                  ),
                );
              },
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
