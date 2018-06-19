import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import './pages/login_page.dart';
import 'pages/building_selection_page.dart';
import 'pages/first_time_page.dart';

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (settings.isInitialRoute)
      return child;
    // Fades between routes. (If you don't want any animation, 
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }
}

void main() async {
  enableFlutterDriverExtension();
  runApp(new MaterialApp(
    title: "KET Agenda",
    onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/': return new MyCustomRoute(
            builder: (_) => new LoginPage(),
            settings: settings,
          );
          case '/FirstTimePage': return new MyCustomRoute(
            builder: (_) => new FirstTimePage(),
            settings: settings,
          );
          case '/BuildingSelectionPage': return new MyCustomRoute(
            builder: (_) => new BuildingSelectionPage(),
            settings: settings,
          );
        }
      },
  ));
}