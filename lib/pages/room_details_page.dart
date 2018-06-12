import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'room_booking_page.dart';
import '../components/room_info.dart';
import '../components/room.dart';
import 'package:KETAgenda/globals.dart' as globals; 

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

class RoomDetailsPage extends StatefulWidget {
  RoomDetailsPage({Key key, this.roomId}) : super(key: key);
  final String roomId;

  @override
  _RoomDetailsPage createState() => new _RoomDetailsPage(roomId);
}

class _RoomDetailsPage extends State<RoomDetailsPage> {
  _RoomDetailsPage(this.roomId);
  final String roomId;
  String url = globals.baseAPIURL + '/api/rooms/';

  //Controllers
  RoomInfo _roomInfo = new RoomInfo();
  TimeSlotsInfo _timeSlotInfo = new TimeSlotsInfo();
  List<bool> timeslotsSelectedWithCheckboxes = new List<bool>.filled(15, false);

  // Date of today
  DateTime now = new DateTime.now();
  int todayDateNumber = 0;
  String todayDate = "";

  bool checkBoxState = true;
  Future getSWData() async {
    changeDate();
    // print(roomId);
    var res = await http.get(Uri.encodeFull(url + roomId),
        headers: {"Accept": "application/json"});
    setState(() {
      Map roomMap = json.decode(res.body);
      var room = new Room.fromJson(roomMap);
      _roomInfo.id = roomId;
      _roomInfo.name = room.name;
      _roomInfo.type = room.type;
      _roomInfo.location = room.location;
      _roomInfo.floor = room.floor;
      _roomInfo.bookings = room.bookings;
    });
  }

  void changeDate() {
    setState(() {
      // Change the date to search for
      todayDate =
          new DateFormat.yMd().format(now.add(Duration(days: todayDateNumber)));

      // Clear all checkboxes
      timeslotsSelectedWithCheckboxes = new List<bool>.filled(15, false);
      _roomInfo.checkedBookings = new List<bool>.filled(15, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Terug naar vorige pagina')),
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
                  text: "Gegevens over deze kamer",
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
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new IconButton(
                    icon: new Icon(Icons.arrow_left),
                    onPressed: () {
                      this.setState(() {
                        if (todayDateNumber > 0) {
                          todayDateNumber = todayDateNumber - 1;
                          changeDate();
                        }
                      });
                    },
                  ),
                ),
                new Container(
                  child: new RichText(
                    text: new TextSpan(
                      text: todayDateNumber == 0
                          ? "Rooster van vandaag"
                          : "Rooster",
                      style: new TextStyle(color: Colors.white, fontSize: 28.0),
                    ),
                  ),
                ),
                new Expanded(
                  child: new IconButton(
                    icon: new Icon(Icons.arrow_right),
                    onPressed: () {
                      this.setState(() {
                        if (todayDateNumber < 7) {
                          todayDateNumber = todayDateNumber + 1;
                          changeDate();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          new Center(
            child: new Container(
              padding: new EdgeInsets.only(top: 10.0),
              child: new RichText(
                text: new TextSpan(
                  text: todayDate,
                  style: new TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            ),
          ),
          new Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _timeSlotInfo.timeslotsOfADayStarting
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
                              _roomInfo.checkedBookings[index] = value;
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
                      this.setState(() {
                        timeslotsSelectedWithCheckboxes[index] =
                            !timeslotsSelectedWithCheckboxes[index];
                        _roomInfo.checkedBookings[index] =
                            !_roomInfo.checkedBookings[index];
                      });
                    },
                  );

                  // Check if current day and timeslot can be found in the bookings
                  bool foundReserved = false;
                  if (index <
                      _timeSlotInfo.timeslotsOfADayStarting.length - 1) {
                    int selectedTimeHour = int.parse(_timeSlotInfo
                        .timeslotsOfADayStarting[index]
                        .toString()
                        .split(":")[0]);
                    int selectedTimeMinute = int.parse(_timeSlotInfo
                        .timeslotsOfADayStarting[index]
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
                      if (
                          // Booking is from today
                          retrievedDate == todayDate &&
                              // Booking is between this timeslot
                              ((selectedTimeHour * 60) + selectedTimeMinute) >=
                                  ((startDate.hour * 60) + startDate.minute) &&
                              ((selectedTimeHour * 60) + selectedTimeMinute) <=
                                  ((endDate.hour * 60) + endDate.minute)) {
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
                      subtitle: new Text(
                        "Dit tijdblok is al gereserveerd",
                        style: new TextStyle(color: Colors.white70),
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
                if (timeslotsSelectedWithCheckboxes.where((x) => x).length >
                    0) {
                  Navigator.push(
                    context,
                    new MyCustomRoute(
                      builder: (_) => new RoomBookingPage(roomInfo: _roomInfo),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                          title: new Text("Foutmelding"),
                          content: new SingleChildScrollView(
                            child: new ListBody(
                              children: <Widget>[
                                new Text(
                                    'U dient minstens 1 tijdblok te selecteren!')
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
                }
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
