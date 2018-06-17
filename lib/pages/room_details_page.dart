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
  DateTime todayDate = new DateTime.now();

  bool checkBoxState = true;
  Future getSWData() async {
    // changeDate();
    // print(url + roomId);
    var resBookings =
        await http.get(Uri.encodeFull(url + roomId + "?populate"));
    var res = await http.get(Uri.encodeFull(url + roomId),
        headers: {"Accept": "application/json"});
    setState(() {
      List bookingsList = json.decode(resBookings.body)['bookings'] != null
          ? json.decode(resBookings.body)['bookings']
          : new List();
      Map roomMap = json.decode(res.body);
      // var bookings = new Bookings.fromJson(bookingsList);
      var room = new Room.fromJson(roomMap);
      _roomInfo.id = room.id;
      _roomInfo.name = room.name;
      _roomInfo.type = room.type;
      _roomInfo.location = room.location;
      _roomInfo.floor = room.floor;
      _roomInfo.bookings = bookingsList;
    });
  }

  void changeDate(addDay) {
    setState(() {
      // Change the date to search for
      todayDate = addDay
          ? todayDate.add(Duration(days: 1))
          : todayDate.add(Duration(days: -1));

      // Clear all checkboxes
      timeslotsSelectedWithCheckboxes = new List<bool>.filled(15, false);
      _roomInfo.checkedBookings = new List<bool>.filled(15, false);

      // Save last date in case user goes to booking page
      _roomInfo.chosenDateToBook = new DateFormat('y-MM-d').format(todayDate);
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
                          changeDate(false);
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
                          changeDate(true);
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
                  text: new DateFormat('d MMMM y').format(todayDate),
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
                            child: new Text(
                                _timeSlotInfo.timeslotsOfADayStarting[index] +
                                    " tot " +
                                    _timeSlotInfo.timeslotsOfADayEnding[index],
                                style: new TextStyle(color: Colors.white))),
                        new Checkbox(
                          value: timeslotsSelectedWithCheckboxes[index],
                          onChanged: (bool value) {
                            if (_roomInfo.id != "") {
                              this.setState(() {
                                timeslotsSelectedWithCheckboxes[index] = value;
                                _roomInfo.checkedBookings[index] = value;
                              });
                            }
                          },
                        )
                      ],
                    ),
                    subtitle: new Text(
                      "Dit tijdblok is vrij om te reserveren",
                      style: new TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      if (_roomInfo.id != "") {
                        this.setState(() {
                          timeslotsSelectedWithCheckboxes[index] =
                              !timeslotsSelectedWithCheckboxes[index];
                          _roomInfo.checkedBookings[index] =
                              !_roomInfo.checkedBookings[index];
                        });
                      }
                    },
                  );

                  // Check if current day and timeslot can be found in the bookings
                  bool foundReserved = false;
                  if (index < _timeSlotInfo.timeslotsOfADayStarting.length) {
                    print("Trying to find reserved timeslots..");
                    int selectedTimeStartHour = int.parse(_timeSlotInfo
                        .timeslotsOfADayStarting[index]
                        .toString()
                        .split(":")[0]);
                    int selectedTimeStartMinute = int.parse(_timeSlotInfo
                        .timeslotsOfADayStarting[index]
                        .toString()
                        .split(":")[1]);
                    int selectedTimeEndHour = int.parse(_timeSlotInfo
                        .timeslotsOfADayEnding[index]
                        .toString()
                        .split(":")[0]);

                    int selectedTimeEndMinute = int.parse(_timeSlotInfo
                        .timeslotsOfADayEnding[index]
                        .toString()
                        .split(":")[1]);
                    print("selectedTimeStartHour: " +
                        selectedTimeStartHour.toString());
                    print("selectedTimeStartMinute: " +
                        selectedTimeStartMinute.toString());
                    print("selectedTimeEndHour: " +
                        selectedTimeEndHour.toString());
                    print("selectedTimeStartMinute: " +
                        selectedTimeEndMinute.toString());

                    for (final item in _roomInfo.bookings) {
                      // Timezone is by default UTC, so add 2 hours to make up with Amsterdam.
                      DateTime startDate = DateTime
                          .parse(item["start"])
                          .toUtc()
                          .add(Duration(hours: 2));
                      DateTime endDate = DateTime
                          .parse(item["end"])
                          .toUtc()
                          .add(Duration(hours: 2));
                      // DEL? String retrievedDate =
                      //     new DateFormat.yMd().format(startDate);
                      print("Startdate: " + startDate.toString());
                      print("Enddate: " + endDate.toString());
                      // DEL? print("Retrieveddate: " + retrievedDate);

                      // Check if current booking is from today and also check if
                      // the time is this timeslot, than display it is reserved.
                      // print("---DATE DETAILS---");
                      // print("Retrieveddate:  " + retrievedDate + " - todayDate: " + todayDate);
                      // print("Selectedtimehour*60: " + (selectedTimeHour*60).toString());
                      // print("Selectedtimeminute: " + (selectedTimeHour*60).toString());

                      String formattedStart =
                          new DateFormat.yMMMd().format(startDate);
                      String formattedToday =
                          new DateFormat.yMMMd().format(todayDate);
                      if (formattedStart == formattedToday) {
                        // Booking is from today
                        print("****Booking is from today!****");
                        print('TIMESLOT START: ' +
                            selectedTimeStartHour.toString() +
                            ":" +
                            selectedTimeStartMinute.toString());
                        print('TIMESLOT END: ' +
                            selectedTimeEndHour.toString() +
                            ":" +
                            selectedTimeEndMinute.toString());

                        print((startDate.hour).toString());
                        print((startDate.minute).toString());

                        print((endDate.hour).toString());
                        print((endDate.minute).toString());
                        print("****END Booking is from today!****");

                        if (((selectedTimeStartHour * 60) +
                                    selectedTimeStartMinute) >=
                                ((startDate.hour * 60) + startDate.minute) &&
                            ((selectedTimeEndHour * 60) +
                                    selectedTimeEndMinute) <=
                                ((endDate.hour * 60) + endDate.minute)) {
                          // Booking is between this timeslot
                          print(
                              "*******Booking is from today and within a timeslot********");
                          foundReserved = true;
                          break;
                        }
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
