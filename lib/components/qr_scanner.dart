// import 'dart:async';
// import '../plugins/barcode_scan.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class QRScanner extends StatefulWidget {
//   @override
//   _QRScanner createState() => new _QRScanner();
// }

// class _QRScanner extends State<QRScanner> {
//   String barcode = "";

//   @override
//   initState() {
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     return new Container(
//       height: 50.0,
//       width: double.infinity,
//       margin: new EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 5.0),
//       child: new FlatButton(
//         onPressed: () {
//           scan();
//         },
//         child: new Text("Scan QR code"),
//         color: Colors.lightBlue,
//         textColor: Colors.white,
//       ),
//     );
//   }

//   Future scan() async {
//     try {
//       String barcode = await BarcodeScanner.scan();
//       setState(() => this.barcode = barcode);
      
//     } on PlatformException catch (e) {
//       if (e.code == BarcodeScanner.CameraAccessDenied) {
//         setState(() {
//           this.barcode = 'The user did not grant the camera permission!';
//         });
//       } else {
//         setState(() => this.barcode = 'Unknown error: $e');
//       }
//     } on FormatException {
//       setState(() => this.barcode =
//           'null (User returned using the "back"-button before scanning anything. Result)');
//     } catch (e) {
//       setState(() => this.barcode = 'Unknown error: $e');
//     }
//   }
// }
