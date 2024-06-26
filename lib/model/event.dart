import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String? imageURL;
  String event;
  DateTime dateTime;
  String location;
  double fee;
  String? paymentLink;
  String category;
  String details;
  String organiser;
  Timestamp timestamp;

  Event({
    required this.id,
    this.imageURL,
    required this.event,
    required this.dateTime,
    required this.location,
    required this.fee,
    this.paymentLink,
    required this.category,
    required this.details,
    required this.organiser,
    required this.timestamp,
  });

  factory Event.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    // Check if 'fee' is a String and convert to double if necessary
    double fee;
    if (data['fee'] is String) {
      fee = double.tryParse(data['fee']) ?? 0.0;
    } else if (data['fee'] is num) {
      fee = (data['fee'] as num).toDouble();
    } else {
      fee = 0.0;
    }

    // Convert 'dateTime' string to DateTime
    DateTime dateTime = DateTime.now(); // Default value if conversion fails
    if (data['dateTime'] is String) {
      try {
        dateTime = DateTime.parse(data['dateTime']);
      } catch (e) {
        print('Error parsing dateTime: $e');
      }
    }

    // Extract 'timestamp' field as Timestamp
    Timestamp timestamp = data['timestamp'] ?? Timestamp.now();

    return Event(
      id: snapshot.id,
      imageURL: data['imageURL'] ?? 'lib/images/mainpage.png',
      event: data['event'] ?? '',
      dateTime: dateTime,
      location: data['location'] ?? '',
      fee: fee,
      paymentLink: data['paymentLink'],
      category: data['category'] ?? '',
      details: data['details'] ?? '',
      organiser: data['organiser'] ?? '',
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageURL': imageURL,
      'event': event,
      'dateTime': dateTime,
      'location': location,
      'fee': fee,
      'paymentLink': paymentLink,
      'category': category,
      'details': details,
      'organiser': organiser,
      'timestamp': timestamp,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageURL': imageURL,
      'event': event,
      'dateTime': dateTime,
      'location': location,
      'fee': fee,
      'paymentLink': paymentLink,
      'category': category,
      'details': details,
      'organiser': organiser,
      'timestamp': timestamp,
    };
  }
}
