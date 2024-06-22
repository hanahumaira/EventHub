import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  final List<String>? imageURLs;
  String event;
  DateTime dateTime;
  String location;
  double? fee;
  String? paymentLink;
  String category;
  String details;
  String organiser;
  Timestamp timestamp;
  int? registration;
  int? slots;
  int? shared;
  int? saved;

  Event({
    required this.id,
    this.imageURLs,
    required this.event,
    required this.dateTime,
    required this.location,
    this.fee,
    this.paymentLink,
    required this.category,
    required this.details,
    required this.organiser,
    required this.timestamp,
    this.registration,
    this.slots,
    this.shared,
    this.saved,
  });

  factory Event.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    // Check if 'fee' is a String and convert to double if necessary
    double fee;
    if (data['fee'] is String) {
      fee = double.tryParse(data['fee']) ?? 0.00;
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

    // Extract 'registration' field, allow null if missing or invalid
    int? registration =
        data['registration'] is int ? data['registration'] as int : null;

    // Extract 'slots' field, allow null if missing or invalid
    int? slots = data['slots'] is int ? data['slots'] as int : null;

    int? shared = data['shared'] is int ? data['shared'] as int : null;
    int? saved = data['saved'] is int ? data['saved'] as int : null;

    return Event(
      id: snapshot.id,
      imageURLs: data['imageURL'] != null
          ? (data['imageURL'] is String
              ? [data['imageURL']] // Convert single string to list of strings
              : List<String>.from(data['imageURL']))
          : null,
      event: data['event'] ?? '',
      dateTime: dateTime,
      location: data['location'] ?? '',
      fee: fee,
      paymentLink: data['paymentLink'] ?? '',
      category: data['category'] ?? '',
      details: data['details'] ?? '',
      organiser: data['organiser'] ?? '',
      timestamp: timestamp,
      registration: registration,
      slots: slots,
      shared: shared,
      saved: saved,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageURLs': imageURLs,
      'event': event,
      'dateTime': dateTime,
      'location': location,
      'fee': fee,
      'paymentLink': paymentLink,
      'category': category,
      'details': details,
      'organiser': organiser,
      'timestamp': timestamp,
      'registration': registration,
      'slots': slots,
      'shared': shared,
      'saved': saved
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageURLs': imageURLs,
      'event': event,
      'dateTime': dateTime,
      'location': location,
      'fee': fee,
      'paymentLink': paymentLink,
      'category': category,
      'details': details,
      'organiser': organiser,
      'timestamp': timestamp,
      'registration': registration,
      'slots': slots,
      'shared': shared,
      'saved': saved
    };
  }
}
