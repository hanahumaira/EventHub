//firebase related import
import 'package:cloud_firestore/cloud_firestore.dart';

//page or model related import
import 'package:eventhub/model/event.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/user/user_widget.dart';
import 'package:eventhub/screen/user/myevent_edit.dart';
import 'package:eventhub/screen/login_page.dart';

//dart import
import 'package:flutter/material.dart';

class MyEventReg extends StatefulWidget {
  final User passUser;
  final String appBarTitle;

  const MyEventReg(
      {super.key, required this.passUser, required this.appBarTitle});

  @override
  State<MyEventReg> createState() => _MyEventRegState();
}

class _MyEventRegState extends State<MyEventReg> {
  List<Event> _myRegEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      print('Fetching registrations for user: ${widget.passUser.name}');
      final querySnapshot = await FirebaseFirestore.instance
          .collection('registrations')
          .where('full_name', isEqualTo: widget.passUser.name)
          .get();

      final eventIds =
          querySnapshot.docs.map((doc) => doc['event_id']).toList();
      print('Event IDs retrieved: $eventIds');

      if (eventIds.isNotEmpty) {
        final eventsQuery = await FirebaseFirestore.instance
            .collection('eventData')
            .where(FieldPath.documentId, whereIn: eventIds)
            .get();

        print('Events query docs length: ${eventsQuery.docs.length}');
        eventsQuery.docs.forEach((doc) {
          print('Event document data: ${doc.data()}');
        });

        final events = eventsQuery.docs.map((doc) {
          final event = Event.fromSnapshot(doc);
          print('Event created: ${event.event}');
          return event;
        }).toList();

        setState(() {
          _myRegEvents = events;
        });
        print('_myRegEvents: $_myRegEvents');
      } else {
        print('No registered events!');
      }
      print('Successfully fetched registered events!');
    } catch (e) {
      print('Error fetching registered events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: widget.appBarTitle,
        onNotificationPressed: () {},
        onLogoutPressed: () => _logoutAndNavigateToLogin(context),
      ),
      body: _myRegEvents.isEmpty
          ? const Center(
              child: Text(
                'No events registered.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _myRegEvents.length,
              itemBuilder: (context, index) {
                final event = _myRegEvents[index];
                return EventCard(event: event);
              },
            ),
      bottomNavigationBar: CustomFooter(passUser: widget.passUser),
    );
  }

  void _logoutAndNavigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            leading: Image.network(
               (event.imageURLs != null && event.imageURLs!.isNotEmpty)
      ? event.imageURLs![0]
      : 'lib/images/mainpage.png',
              fit: BoxFit.cover,
              width: 80,
            ),
            title: Text(
              event.event,
              style: const TextStyle(color: Colors.white),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditEventRegPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: Color.fromARGB(255, 241, 210, 247),
                ),
              ),
              IconButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
    );
  }

  void _editEvent(BuildContext context) {
    // Navigate to edit event page
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this event?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform delete operation here
                _deleteEvent(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(BuildContext context) {
    // Perform delete operation here, e.g., remove the event from the list
    // Update the UI accordingly
  }
}

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({super.key, required this.event});

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
            Image.asset( (event.imageURLs != null && event.imageURLs!.isNotEmpty)
      ? event.imageURLs![0]
      : 'lib/images/mainpage.png'),
            const SizedBox(height: 16),
            Text(
              event.event,
              style: const TextStyle(
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
              event.fee!.toStringAsFixed(2),
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
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
