import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  List bookings = new List();
}

class _RoomDetailsPage extends State<RoomDetailsPage> {
  _RoomDetailsPage(this.roomId);
  final String roomId;

  //Get info from room number (result of QR code scan)
  String url = 'http://keta.superict.nl/api/rooms/';

  //Controllers
  RoomInfo _roomInfo = new RoomInfo();
  List timeslotsOfADayStarting = new List();
  List timeslotsOfADayEnding = new List();
  List<bool> timeslotsSelectedWithCheckboxes = new List<bool>.filled(15, false);

  List data = new List();
  bool checkBoxState = true;
  Future getSWData() async {
    // print(roomId);
    var res = await http.get(Uri.encodeFull(url + roomId),
        headers: {"Accept": "application/json"});
    timeslotsOfADayStarting.addAll([
      "8:30",
      "9:20",
      "10:30",
      "11:20",
      "12:10",
      "13:00",
      "13:50",
      "15:00",
      "15:50",
      "17:00",
      "17:50",
      "18:40",
      "19:30",
      "20:20",
      "21:10"
    ]);
    timeslotsOfADayEnding.addAll([
      "9:20",
      "10:10",
      "11:20",
      "12:10",
      "13:00",
      "13:50",
      "14:40",
      "15:50",
      "16:40",
      "17:50",
      "18:40",
      "19:30",
      "20:20",
      "21:10",
      "22:00"
    ]);
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
      _roomInfo.bookings = data[0]["bookings"];
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
                  text: "Rooster van vandaag",
                  style: new TextStyle(color: Colors.white, fontSize: 28.0),
                ),
              ),
            ),
          ),
          new Expanded(
            child: ListView.builder(
              itemCount: timeslotsOfADayStarting
                  .length, // 1 day consists of 15 time blocks
              itemBuilder: (BuildContext context, int index) {
                {
                  // ListTile to display when it is able to be booked:
                  ListTile bookableItem = new ListTile(
                    leading: new CircleAvatar(
                      child: new Text((index + 1).toString()),
                      backgroundColor: Colors.blueAccent,
                    ),
                    title: new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new Text("Beschikbaar",
                                style: new TextStyle(color: Colors.white))),
                        new Checkbox(
                          value: timeslotsSelectedWithCheckboxes[index],
                          onChanged: (bool value) {
                            this.setState(() {
                              timeslotsSelectedWithCheckboxes[index] = value;
                            });
                          },
                        )
                      ],
                    ),
                    subtitle: new Text(
                      "Dit tijdblok is vrij om te reserveren",
                      style: new TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      showTimePicker(
                        initialTime: new TimeOfDay.now(),
                        context: context,
                      );
                    },
                  );

                  // Date of today
                  DateTime now = new DateTime.now();
                  String todayDate = new DateFormat.yMd().format(now);

                  // Check if current day and timeslot can be found in the bookings
                  bool foundReserved = false;
                  if (index < timeslotsOfADayStarting.length - 1) {
                    int selectedTimeHour = int.parse(
                        timeslotsOfADayStarting[index]
                            .toString()
                            .split(":")[0]);
                    int selectedTimeMinute = int.parse(
                        timeslotsOfADayStarting[index]
                            .toString()
                            .split(":")[1]);

                    for (final item in _roomInfo.bookings) {
                      DateTime startDate =
                          DateTime.parse(item["dates"][0]["start"].toString());
                      DateTime endDate =
                          DateTime.parse(item["dates"][0]["end"].toString());
                      String retrievedDate =
                          new DateFormat.yMd().format(startDate);

                      // Check if current booking is from today and also check if
                      // the time is this timeslot, than display it is reserved.
                      if (retrievedDate == todayDate // Booking is from today
                              &&
                              ((selectedTimeHour * 60) + selectedTimeMinute) >=
                                  ((startDate.hour * 60) + startDate.minute)
                              // Booking start time is this one
                              &&
                              ((selectedTimeHour * 60) + selectedTimeMinute) <=
                                  ((endDate.hour * 60) + endDate.minute)
                          // Booking start time is this one
                          ) {
                        //Booking end time
                        foundReserved = true;
                        break;
                      }
                    }
                  }

                  if (foundReserved) {
                    return new ListTile(
                      leading: new CircleAvatar(
                        child: new Text((index + 1).toString()),
                        backgroundColor: Colors.blueAccent,
                      ),
                      title: new Text(
                        "GERESERVEERD",
                        style: new TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return bookableItem;
                  }
                }
              },
            ),
          ),
          new Container(
            height: 50.0,
            width: double.infinity,
            child: new FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/FirstTimePage');
              },
              child: new Text("Doorgaan naar reservering"),
              color: Colors.lightBlue,
              textColor: Colors.white,
            ),
          )
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
