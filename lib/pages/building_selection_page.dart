import 'dart:async';
import 'dart:convert';
import 'package:KETAgenda/components/user_info.dart';
import 'package:KETAgenda/pages/room_details_page.dart';
import 'package:KETAgenda/services/api_tools.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:KETAgenda/globals.dart' as globals;
import 'package:KETAgenda/components/modal_server_offline.dart';

class BuildingSelectionPage extends StatefulWidget {
  @override
  _BuildingSelectionPage createState() => new _BuildingSelectionPage();
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

class _BuildingSelectionPage extends State<BuildingSelectionPage> {
  String url = globals.baseAPIURL + '/api/rooms?name=';
  List data = new List();

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
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      data = resBody;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (apiIsOnline) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Uitloggen'),
          leading: new IconButton(
            icon: new Icon(Icons.exit_to_app),
            onPressed: () {
              globals.user = new UserInfo();
              Navigator.pushNamed(context, "/");
            },
          ),
        ),
        backgroundColor: Colors.redAccent[700],
        body: new Column(
          children: <Widget>[
            new Container(
              height: 200.0,
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
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Column(
                                children: <Widget>[
                                  new RichText(
                                    text: new TextSpan(
                                      text: "Kamer",
                                      style: new TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 60.0),
                                    ),
                                  ),
                                  new RichText(
                                    text: new TextSpan(
                                      text: "Kies de gewenste kamer",
                                      style: new TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                ],
                              ),
                              new Container(
                                height: 100.0,
                                child: new Hero(
                                  tag: 'imageHero',
                                  child: new Image.asset("assets/logohr.png"),
                                ),
                              )
                            ],
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
                backgroundColor: Colors.redAccent[700],
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
                      title: new Text(
                        data[index]["name"].toString(),
                        style: new TextStyle(color: Colors.white),
                      ),
                      subtitle: new Text(
                        'Type: ' + data[index]["type"].toString().toUpperCase(),
                        style: new TextStyle(color: Colors.white70),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          new MyCustomRoute(
                            builder: (_) =>
                                new RoomDetailsPage(roomId: data[index]["_id"]),
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
