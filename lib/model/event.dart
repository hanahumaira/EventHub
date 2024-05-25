import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String? id; // Optional, as it might be assigned by Firestore
  String imageURL;
  String event;
  DateTime dateTime;
  String location;
  double fee;
  String category;
  String details;
  String organiser;
  Timestamp? timestamp;

  Event({
    this.id,
    required this.imageURL,
    required this.event,
    required this.dateTime,
    required this.location,
    required this.fee,
    required this.category,
    required this.details,
    required this.organiser,
    required this.timestamp,
  });

  factory Event.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Event(
      id: snapshot.id,
      imageURL: data['imageURL'],
      event: data['event'],
      dateTime: data['dateTime'].toDate(),
      location: data['location'],
      fee: data['fee'].toDouble(),
      category: data['category'],
      details: data['details'],
      organiser: data['organiser'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageURL': imageURL,
      'event': event,
      'dateTime': dateTime,
      'location': location,
      'fee': fee,
      'category': category,
      'details': details,
      'organiser': organiser,
      'timestamp': timestamp,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'imageURL': imageURL,
      'event': event,
      'dateTime': dateTime,
      'location': location,
      'fee': fee,
      'category': category,
      'details': details,
      'organiser': organiser,
      'timestamp': timestamp,
    };
  }
}
