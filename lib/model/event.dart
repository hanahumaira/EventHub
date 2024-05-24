import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String? id; // Optional, as it might be assigned by Firestore
  String event;
  DateTime date;
  String location;
  int registration;
  String organiser;
  String details;
  double fee;
  String image;
  String category;

  Event({
    this.id,
    required this.event,
    required this.date,
    required this.location,
    required this.registration,
    required this.organiser,
    required this.details,
    required this.fee,
    required this.image,
    required this.category,
  });

  factory Event.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Event(
      id: snapshot.id,
      event: data['event'],
      date: (data['date'] as Timestamp).toDate(),
      location: data['location'],
      registration: data['registration'],
      organiser: data['organiser'],
      details: data['details'],
      fee: data['fee'].toDouble(),
      image: data['image'],
      category: data['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'date': date,
      'location': location,
      'registration': registration,
      'organiser': organiser,
      'details': details,
      'fee': fee,
      'image': image,
      'category':category,
    };
  }
}
