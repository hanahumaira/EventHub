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
    return Event(
      id: snapshot.id,
      imageURL: data['imageURL'] ?? 'lib/images/mainpage.png',
      event: data['event'],
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      location: data['location'],
      fee: (data['fee'] as num).toDouble(),
      paymentLink: data['paymentLink'],
      category: data['category'],
      details: data['details'],
      organiser: data['organiser'],
      timestamp: data['timestamp'],
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
