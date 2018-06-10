class RoomInfo {
  String id = "...";
  String name = "...";
  String type = "...";
  String location = "...";
  String floor = "...";
  List bookings = new List();
  List checkedBookings =
      new List<bool>.filled(15, false); // Checked items will be saved here
}

class TimeSlotsInfo {
  List timeslotsOfADayStarting = [
    "8:30",
    "9:20",
    "10:30",
    "11:20",
    "12:10",
    "13:00",
    "13:50",
    "15:00",
    "15:50",
    "17:00",
    "17:50",
    "18:40",
    "19:30",
    "20:20",
    "21:10"
  ];

  List timeslotsOfADayEnding = [
    "9:20",
    "10:10",
    "11:20",
    "12:10",
    "13:00",
    "13:50",
    "14:40",
    "15:50",
    "16:40",
    "17:50",
    "18:40",
    "19:30",
    "20:20",
    "21:10",
    "22:00"
  ];
}
