// This class is mapping incoming JSON to the properties
// It gets passed from 'room_details_page.dart' page to 'room_booking_page.dart' page
class Room {
  final List displayKeys;
  final String id;
  final String name;
  final String type;
  final List bookings;
  final String location;
  final String floor;

  Room(this.displayKeys, this.id, this.name, this.type, this.bookings, 
  this.location, this.floor);

  Room.fromJson(Map<String, dynamic> json)
      : // Strings
        id = json['_id'] != null ? json['_id'].toString() : "Onbekend",
        name = json['name'] != null ? json['name'].toString() : "Onbekend",
        type = json['type'] != null ? json['type'].toString() : "Onbekend",
        location = json['location'] != null ? json['location'].toString() : "Onbekend",
        floor = json['floor'] != null ? json['floor'].toString() : "Onbekend",

        // Arrays
        bookings = json['bookings'] != null ? json['bookings'] : [],
        displayKeys = json['displayKeys'] != null ? json['displayKeys'] : [];

  Map<String, dynamic> toJson() => {
        'displayKeys': displayKeys,
        '_id': id,
        'name': name,
        'type': type,
        'bookings': bookings,
        'location': location,
        'floor': floor
      };
}
