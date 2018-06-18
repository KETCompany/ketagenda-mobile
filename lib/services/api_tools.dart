// Libraries
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:KETAgenda/globals.dart' as globals;

class API {
  Future<bool> checkAPI(url, myHeaders) async {
    // Check if I can get status code 200 back
    bool isOnline = await new API().urlResponseOK(globals.baseAPIURL, myHeaders);
    bool isGettingAuthentication = await new API().urlResponseOK(url, myHeaders);
    bool isReturningHelloWorld = await new API().retrieveHelloWorldJSON();
    return isOnline && isReturningHelloWorld && isGettingAuthentication ? true : false;
  }

  Future<bool> urlResponseOK(url, myHeaders) async {
    var res = new http.Client().get(url, headers: myHeaders);
    int statusCode = await res
        .then((onValue) => onValue.statusCode)
        .then((onValue) => onValue)
        .catchError((err) => 0);
    return statusCode == 200 ? true : false;
  }

  Future<bool> retrieveHelloWorldJSON() async {
    var res = new http.Client().get(globals.baseAPIURL);
    String result = await res
        .then((result) => json.decode(result.body))
        .then((json) => json['hello'].toString().toLowerCase())
        .catchError((err) => "");
    return result == "world" ? true : false;
  }
}