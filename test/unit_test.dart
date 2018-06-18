// Default test framework 
import 'dart:async'; 
import 'package:KETAgenda/services/api_tools.dart';
import 'package:test/test.dart'; 
 
// Retrieve global states 
import 'package:KETAgenda/globals.dart' as globals; 
 
// Components/services to be tested 
 
// Unit tests start here, the async tests will run first 
void main() async { 
  await checkAPI(); 
  nonAsyncTests(); 
} 
 
Future<bool> checkAPI() async { 
  // Check if I can get status code 200 back 
  bool isOnline = await new API().urlResponseOK(globals.baseAPIURL, {}); 
  test('Checking the API Status Code', () { 
    expect(isOnline, true); 
  }); 
 
  // Check if I get value 'world' back from key 'hello' 
  bool gotHelloWorld = await new API().retrieveHelloWorldJSON(); 
  test('Checking API Hello World result', () { 
    expect(gotHelloWorld, true); 
  }); 
  return true; 
} 
 
void nonAsyncTests() { 
  // TODO 
  test('1 == 1', () { 
    expect(1, 1); 
  }); 
}