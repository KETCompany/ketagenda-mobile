// Libraries
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  Future<bool> urlResponseOK(url) async {
    var res = new http.Client().get(url);
    int statusCode = await res
        .then((onValue) => onValue.statusCode)
        .then((onValue) => onValue)
        .catchError((err) => 0);
    return statusCode == 200 ? true : false;
  }

  Future<bool> retrieveHelloWorldJSON(url) async {
    var res = new http.Client().get(url);
    String result = await res
        .then((result) => json.decode(result.body))
        .then((json) => json['hello'].toString().toLowerCase())
        .catchError((err) => "");
    return result == "world" ? true : false;
  }
}