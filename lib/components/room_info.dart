// This class is only used to store relevant room information 
// to display in text fields etc in 'room_details_page.dart'.
import 'package:intl/intl.dart';

class RoomInfo {
  String id = "";
  String name = "";
  String type = "";
  String location = "";
  String floor = "";
  List bookings = new List();
  List checkedBookings =
      new List<bool>.filled(15, false); // Checked items will be saved here
  String chosenDateToBook = new DateFormat('y-MM-d').format(new DateTime.now());
}
