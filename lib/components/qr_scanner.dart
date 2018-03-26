import 'dart:async';

import '../plugins/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScanner createState() => new _QRScanner();
}

class _QRScanner extends State<QRScanner> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return new MaterialButton(onPressed: scan, child: new Text("Scan"));
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
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}