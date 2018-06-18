import 'dart:async';
import 'package:KETAgenda/pages/login_page.dart';
import 'package:KETAgenda/pages/room_details_page.dart';
import 'package:flutter/material.dart';
import '../plugins/barcode_scan.dart';

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
          title: new Text("QR Code Scan " + barcode),
          leading: new IconButton(
            icon: new Icon(Icons.exit_to_app),
            onPressed: () => Navigator.pushNamed(context, "/"),
          ),
        ),
      ),
    );
  }

  Future scan() async {
   
      String barcode = await BarcodeScanner.scan();
      print("barcode: " + barcode);
      // Send user to the details page of this room
      Navigator.push(
        context,
        new MyCustomRoute(
          builder: (_) => new RoomDetailsPage(roomId: barcode),
        ),
      );

      // Save barcode for this page
      setState(() => this.barcode = barcode);
    // on PlatformException catch (e) {
    //   if (e.code == BarcodeScanner.CameraAccessDenied) {
    //     setState(() {
    //       this.barcode = 'The user did not grant the camera permission!';
    //       Navigator.pushNamed(context, "/");
    //     });
    //   } else {
    //     setState(() => this.barcode = 'Unknown error: $e');
    //     Navigator.pushNamed(context, "/");
    //   }
    // } on FormatException {
    //   setState(() => this.barcode =
    //       'null (User returned using the "back"-button before scanning anything. Result)');
    //   Navigator.pushNamed(context, "/");
    // } catch (e) {
    //   setState(() => this.barcode = 'Unknown error: $e');
    //   Navigator.pushNamed(context, "/");
    // }
   }
}