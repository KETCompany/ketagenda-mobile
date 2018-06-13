import 'dart:async';

// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Tapping buttons test', () {
    FlutterDriver driver;

    setUpAll(() async {
      // Connects to the app
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        // Closes the connection
        driver.close();
      }
    });

    test('Inloggen', () async {
      await new Future<Null>.delayed(new Duration(milliseconds: 1500));
      await driver.tap(find.text("Inloggen"));
      await new Future<Null>.delayed(new Duration(milliseconds: 1500));
    });

    test('Scan QR code', () async {
      await new Future<Null>.delayed(new Duration(milliseconds: 1500));
      await driver.tap(find.text("Scan QR code"));
      await new Future<Null>.delayed(new Duration(milliseconds: 1500));
    });
  });
}
