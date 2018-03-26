import 'package:flutter/material.dart';

import './pages/login_page.dart';
import 'components/qr_scanner.dart';

void main() {
  runApp(new MaterialApp(
    home: new QRScanner(),
  ));
}