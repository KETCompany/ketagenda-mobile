import 'dart:async';
import 'dart:convert';
import 'package:KETAgenda/pages/login_page.dart';
import 'package:KETAgenda/pages/room_details_page.dart';
import 'package:flutter/material.dart';
import '../plugins/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:KETAgenda/globals.dart' as globals;

class QRPage extends StatefulWidget {
  @override
  _QRPage createState() => new _QRPage(barcode: "");
}

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

class _QRPage extends State<QRPage> {
  _QRPage({this.barcode});
  String barcode;
  String url = globals.baseAPIURL + "/api/rooms/";
  List data;
  String pageTitle = "Laden..";
  TextEditingController _controllerRoomName;
  TextEditingController _controllerRoomType;
  TextEditingController _controllerRoomLocation;
  TextEditingController _controllerRoomFloor;

  Future getSWData(roomnumber) async {
    var res = await http.get(Uri.encodeFull(url + roomnumber),
        headers: {"Accept": "application/json", "Authorization": "Bearer " + globals.user.apiToken});

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

  @override
  Widget build(BuildContext context) {
    if (barcode.contains("null")) {
      //User pressed back btn of device during scan
      return new LoginPage();
    } else {
      if (barcode.isEmpty) {
        scan();
      }
    }
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("data"),
          leading: new IconButton(
            icon: new Icon(Icons.ac_unit),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }
  // // Build
  // @override
  // Widget build(BuildContext context) {
  //   print("Barcode status: " + barcode);
  //   if (barcode.contains("null")) {
  //     //User pressed back btn of device during scan
  //     return new LoginPage();
  //   } else {
  //     if (barcode.isEmpty) {
  //       scan();
  //       return new Material(
  //         color: Colors.red,
  //         child: new Text("Scan de QR code"),
  //       );
  //     } else {
  //       return new Scaffold(
  //         backgroundColor: Colors.redAccent[700],
  //         body: new Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           mainAxisSize: MainAxisSize.max,
  //           children: <Widget>[
  //             new Expanded(
  //               child: new Container(
  //                 color: Colors.white,
  //                 child: new Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: <Widget>[
  //                     new RichText(
  //                       text: new TextSpan(
  //                         text: this.pageTitle,
  //                         style: new TextStyle(
  //                             color: Colors.blueAccent, fontSize: 60.0),
  //                       ),
  //                     ),
  //                     new RichText(
  //                       text: new TextSpan(
  //                         text: "Kamer initialiseren",
  //                         style: new TextStyle(
  //                             color: Colors.blueAccent, fontSize: 20.0),
  //                       ),
  //                     ),
  //                     new Container(
  //                       height: 150.0,
  //                       child: new Hero(
  //                         tag: 'imageHero',
  //                         child: new Image.asset("assets/logohr.png"),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             new Expanded(
  //               child: new SingleChildScrollView(
  //                 child: new Container(
  //                   color: Colors.redAccent[700],
  //                   child: new Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.stretch,
  //                     children: <Widget>[
  //                       new Center(
  //                         child: new Container(
  //                           padding: new EdgeInsets.all(5.0),
  //                           child: new RichText(
  //                             text: new TextSpan(
  //                               text: "Gegevens instellen",
  //                               style: new TextStyle(
  //                                   color: Colors.white, fontSize: 28.0),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       new Card(
  //                         child: new Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: <Widget>[
  //                             new ListTile(
  //                               onTap: () {
  //                                 _controllerRoomName.clear();
  //                               },
  //                               leading: const Icon(Icons.title),
  //                               title: new TextField(
  //                                 controller: _controllerRoomName,
  //                                 decoration: new InputDecoration(
  //                                   hintText: "Wat is de code van de kamer?",
  //                                   labelText: "Kamer code",
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       new Card(
  //                         child: new Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: <Widget>[
  //                             new ListTile(
  //                               onTap: () {
  //                                 _controllerRoomType.clear();
  //                               },
  //                               leading: const Icon(Icons.title),
  //                               title: new TextField(
  //                                 controller: _controllerRoomType,
  //                                 decoration: new InputDecoration(
  //                                   hintText: "Wat voor type kamer is het?",
  //                                   labelText: "Kamer type",
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       new Card(
  //                         child: new Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: <Widget>[
  //                             new ListTile(
  //                               onTap: () {
  //                                 _controllerRoomLocation.clear();
  //                               },
  //                               leading: const Icon(Icons.title),
  //                               title: new TextField(
  //                                 controller: _controllerRoomLocation,
  //                                 decoration: new InputDecoration(
  //                                   hintText:
  //                                       "Op welke locatie bevind deze kamer zich?",
  //                                   labelText: "Kamer locatie",
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       new Card(
  //                         child: new Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: <Widget>[
  //                             new ListTile(
  //                               onTap: () {
  //                                 _controllerRoomFloor.clear();
  //                               },
  //                               leading: const Icon(Icons.title),
  //                               title: new TextField(
  //                                 controller: _controllerRoomFloor,
  //                                 decoration: new InputDecoration(
  //                                   hintText:
  //                                       "Op welke verdieping bevind deze kamer zich?",
  //                                   labelText: "Kamer verdieping",
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             new Container(
  //               margin: new EdgeInsets.all(5.0),
  //               child: new RaisedButton(
  //                 child: new Padding(
  //                   padding: new EdgeInsets.all(15.0),
  //                   child: new Text(
  //                     'Opslaan',
  //                     style: new TextStyle(color: Colors.white, fontSize: 20.0),
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).pushNamed("/");
  //                 },
  //                 color: Colors.blueAccent,
  //                 splashColor: Colors.blueAccent[50],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   }
  // }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();

      // Send user to the details page of this room
      Navigator.push(
        context,
        new MyCustomRoute(
          builder: (_) => new RoomDetailsPage(roomId: barcode),
        ),
      );

      // Save barcode for this page
      setState(() => this.barcode = barcode);
      this.getSWData(barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
          Navigator.pushNamed(context, "/");
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
        Navigator.pushNamed(context, "/");
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
      Navigator.pushNamed(context, "/");
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
      Navigator.pushNamed(context, "/");
    }
  }
}
