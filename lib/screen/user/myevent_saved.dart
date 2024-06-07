import 'package:flutter/material.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/model/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyEventSaved extends StatefulWidget {
  final User passUser;

  const MyEventSaved({Key? key, required this.passUser}) : super(key: key);

  @override
  _MyEventSavedState createState() => _MyEventSavedState();
}

class _MyEventSavedState extends State<MyEventSaved> {
  List<Event>? _savedEvents;

  @override
  void initState() {
    super.initState();
    _fetchSavedEvents();
  }

  Future<void> _fetchSavedEvents() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('mysave_event')
          .doc(widget.passUser.name)
          .get();

      if (querySnapshot.exists) {
        final eventData = querySnapshot.data();
        final List<Event> events = [];

        eventData!.forEach((eventId, eventData) {
          final event = Event(
            id: eventId,
            event: eventData['eventName'] ?? '',
            dateTime: (eventData['eventDateTime'] as Timestamp).toDate(),
            location: eventData['eventLocation'] ?? '',
            fee: eventData['eventFee']?.toDouble() ?? 0.0,
            organiser: eventData['eventOrganiser'] ?? '',
            category: eventData['eventCategory'] ?? '',
            details: eventData['eventDetails'] ?? '',
            timestamp: eventData['timestamp'] ?? Timestamp.now(),
            imageURL: eventData['eventImage'] ?? 'lib/images/mainpage.png',
          );
          events.add(event);
        });

        setState(() {
          _savedEvents = events;
        });
        print('Successfully fetched saved events: $_savedEvents');
      } else {
        print('No events found for user: ${widget.passUser.name}');
      }
    } catch (e) {
      print('Error fetching saved events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Events'),
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      ),
      body: _savedEvents != null
          ? ListView.builder(
        itemCount: _savedEvents!.length,
        itemBuilder: (context, index) {
          final event = _savedEvents![index];
          return EventCard(event: event);
        },
      )
          : Center(child: CircularProgressIndicator()),
      backgroundColor: Colors.black,
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: SizedBox(
          width: 80,
          child: Image.network(
            event.imageURL ?? 'lib/images/mainpage.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'lib/images/mainpage.png',
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        title: Text(
          event.event,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          '${event.dateTime}',
          style: const TextStyle(color: Colors.white70),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(event: event),
            ),
          );
        },
      ),
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.event),
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(event.imageURL ?? 'lib/images/mainpage.png'),
            const SizedBox(height: 16),
            Text(
              event.event,
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${event.dateTime}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Text(
              event.location,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${event.fee.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Text(
              event.organiser,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Text(
              event.category,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Details: ${event.details}',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Remove Event',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Event"),
          content: Text("Are you sure you want to remove this event?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform delete action here
                // Once deleted, you can navigate back or perform any other action
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
