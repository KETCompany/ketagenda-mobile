import 'dart:async';
import 'dart:convert';
import 'package:KETAgenda/models/timeslots.dart';
import 'package:KETAgenda/services/api_tools.dart';
import 'package:flutter/material.dart';
import '../components/room_info.dart';
import 'package:KETAgenda/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:KETAgenda/components/modal_server_offline.dart';

class RoomBookingPage extends StatefulWidget {
  RoomBookingPage({Key key, this.roomInfo}) : super(key: key);
  final RoomInfo roomInfo;

  @override
  _RoomBookingPage createState() => new _RoomBookingPage(roomInfo);
}

class _RoomBookingPage extends State<RoomBookingPage> {
  _RoomBookingPage(this.roomInfo);
  final RoomInfo roomInfo;
  String url = globals.baseAPIURL + '/api/rooms/';

  //Controllers
  TimeSlotsInfo _timeSlotsInfo = new TimeSlotsInfo();
  List<String> _bookedTimeSlots = new List<String>();
  List listOfBookings = new List();

  // Specify the amount of elements that are displayed BEFORE the actual bookings itself
  // example: 4 cards (Kamer, Type, Locatie & Verdiepingsnummmer) and the 3 titles etc..
  int amountOfElementsAboveBookings = 8;

  bool apiIsOnline = true;
  Future<Null> checkAPI() async {
    // Check if I can get status code 200 back
    bool isOnline = await new API().urlResponseOK(globals.baseAPIURL);
    bool isReturningHelloWorld =
        await new API().retrieveHelloWorldJSON(globals.baseAPIURL);
    setState(() {
      apiIsOnline = isOnline && isReturningHelloWorld ? true : false;
    });
  }

  Future getSWData() async {
    setState(() {
      for (int i = 0; i < roomInfo.checkedBookings.length; i++) {
        if (roomInfo.checkedBookings[i]) {
          // Add the bookings to a list so it can be sent at once.
          listOfBookings.add({
            "start": ((DateTime
                        .parse(roomInfo.chosenDateToBook +
                            "T" +
                            _timeSlotsInfo.timeslotsOfADayStarting[i])
                        .millisecondsSinceEpoch) ~/
                    1000)
                .toInt(),
            "end": ((DateTime
                        .parse(roomInfo.chosenDateToBook +
                            "T" +
                            _timeSlotsInfo.timeslotsOfADayEnding[i])
                        .millisecondsSinceEpoch) ~/
                    1000)
                .toInt(),
            "room": roomInfo.id
          });
          // Found checked timeslot, add it to list as text to display later
          _bookedTimeSlots.add(_timeSlotsInfo.timeslotsOfADayStarting[i] +
              " tot " +
              _timeSlotsInfo.timeslotsOfADayEnding[i]);
        }
      }
      print("List of bookings2:");
      print(listOfBookings);
    });
  }

  bool postIsAccepted = false;
  // Post to
  Future postData() async {
    var idAndBooking = {
      "name": globals.user.displayName,
      "description": "Student Reservering (" + globals.user.email + ")",
      "groups": [],
      "bookings": listOfBookings
      // "bookings":  [
      //   {
      //   "start": new DateTime.now().millisecondsSinceEpoch,
      //   "end": new DateTime.now().millisecondsSinceEpoch + 3600,
      //   "room": roomInfo.id
      // }
      // ]
    };
    String idAndBookingJSON = json.encode(idAndBooking);
    print("idAndBookingJSON THAT GOT SENT:");
    print(idAndBookingJSON);
    http.Response res = await http.post("http://keta.superict.nl/api/events",
        body: idAndBookingJSON, headers: {"Content-Type": "application/json"});
    if (res.statusCode == 200) {
      setState(() {
        postIsAccepted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(apiIsOnline){
      return new Scaffold(
      appBar: new AppBar(title: new Text('Terug naar vorige pagina')),
      backgroundColor: Colors.redAccent[700],
      body: new Column(
        children: <Widget>[
          new Container(
            height: 175.0,
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
                            text: "Reserveren",
                            style: new TextStyle(
                                color: Colors.blueAccent, fontSize: 60.0),
                          ),
                        ),
                        new RichText(
                          text: new TextSpan(
                            text: "Bevestig uw gegevens voor ${roomInfo.name}",
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
            child: ListView.builder(
              padding: new EdgeInsets.only(top: 10.0),
              shrinkWrap: true,
              itemCount:
                  // Amount of selected timeslots + amount of extra elements + 1 because it is 0 based
                  roomInfo.checkedBookings.where((x) => x == true).length +
                      amountOfElementsAboveBookings +
                      1,
              itemBuilder: (BuildContext context, int index) {
                //0, 1, 2, 3, 4, 5 (And thus 5 items)
                switch (index) {
                  case 0:
                    return new Center(
                      child: new Container(
                        child: new RichText(
                          text: new TextSpan(
                            text: "Gegevens",
                            style: new TextStyle(
                                color: Colors.white, fontSize: 28.0),
                          ),
                        ),
                      ),
                    );
                  case 1:
                    return new Card(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            title: new Text(roomInfo.name),
                            subtitle: new Text("Kamer"),
                          ),
                        ],
                      ),
                    );
                  case 2:
                    return new Card(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            title: new Text(roomInfo.type),
                            subtitle: new Text("Type"),
                          ),
                        ],
                      ),
                    );
                  case 3:
                    return new Card(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            title: new Text(roomInfo.location),
                            subtitle: new Text("Locatie"),
                          ),
                        ],
                      ),
                    );
                  case 4:
                    return new Card(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            title: new Text(roomInfo.floor),
                            subtitle: new Text("Verdiepingsnummer"),
                          ),
                        ],
                      ),
                    );
                  case 5:
                    return new Center(
                      child: new Container(
                        child: new RichText(
                          text: new TextSpan(
                            text: "Persoongegevens",
                            style: new TextStyle(
                                color: Colors.white, fontSize: 28.0),
                          ),
                        ),
                      ),
                    );
                  case 6:
                    return new Card(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            leading: const Icon(Icons.perm_identity),
                            title: new Text(globals.user.displayName),
                            subtitle: new Text("Naam"),
                          ),
                        ],
                      ),
                    );
                  case 7:
                    return new Card(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            leading: const Icon(Icons.email),
                            title: new Text(globals.user.email),
                            subtitle: new Text("E-Mailadres"),
                          ),
                        ],
                      ),
                    );
                  case 8:
                    return new Center(
                      child: new Container(
                        child: new RichText(
                          text: new TextSpan(
                            text: "Gekozen Tijden",
                            style: new TextStyle(
                                color: Colors.white, fontSize: 28.0),
                          ),
                        ),
                      ),
                    );
                  default:
                    return new Card(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            leading: const Icon(Icons.access_time),
                            title: new Text(
                                "${_bookedTimeSlots.length > 0 ? _bookedTimeSlots[index - (amountOfElementsAboveBookings + 1)] : 'Laden..'}"),
                          ),
                        ],
                      ),
                    );
                }
              },
            ),
          ),
          new Container(
            height: 50.0,
            width: double.infinity,
            child: new FlatButton(
              onPressed: () {
                postData().then((_) => (showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                            title: new Text(this.postIsAccepted
                                ? "Gelukt!"
                                : "Probeer het later opnieuw"),
                            content: new SingleChildScrollView(
                              child: new ListBody(
                                children: <Widget>[
                                  new Text(this.postIsAccepted
                                      ? "Het is gelukt, jouw reservering staat nu vast! Wij hebben een e-mail verstuurd met de bevestiging."
                                      : "Op dit moment kunt u niet reserveren.")
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
                    )));

                // Navigator.push(
                //   context,
                //   new MyCustomRoute(
                //     builder: (_) =>
                //         new RoomDetailsPage(roomId: data[index]["_id"]),
                //   ),
                // );
              },
              child: new Text("Reservering plaatsen"),
              color: Colors.lightBlue,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
    } else {
      // Server is offline
      return ServerOffline();
    }
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
    this.checkAPI();
  }
}
