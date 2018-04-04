import 'dart:async';

import 'package:flutter/material.dart';
import '../plugins/barcode_scan.dart';
import 'package:flutter/services.dart';

class QRPage extends StatefulWidget {
  @override
  _QRPage createState() => new _QRPage(barcode: "");
}

class _QRPage extends State<QRPage> {
  _QRPage({this.barcode});
  String barcode;
  @override
  Widget build(BuildContext context) {
    if (barcode.isEmpty) {
      scan();
      return new Material(
        color: Colors.red,
        child: new Text("Scan de QR code"),
      );
    } else {
      return new Scaffold(
        appBar: new AppBar(
          title: const Text('Reservering'),
        ),
        body: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Expanded(
              child: new Container(
                color: Colors.white,
                child: new Text("Hello"),
              ),
            ),
            new Expanded(
              child: new Container(
                color: Colors.red,
                child: new Text(barcode),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
