import 'package:flutter/material.dart';

import './pages/login_page.dart';
import 'pages/building_selection_page.dart';
import 'pages/first_time_page.dart';
import 'pages/qrscan_result_page.dart';

void main() {
  runApp(new MaterialApp(
    routes: <String, WidgetBuilder> {
        "/": (BuildContext context) => new LoginPage(),
        "/QRPage": (BuildContext context) => new QRPage(),
        "/FirstTimePage": (BuildContext context) => new FirstTimePage(),
        "/BuildingSelectionPage": (BuildContext context) => new BuildingSelectionPage(),
      },
  ));
}