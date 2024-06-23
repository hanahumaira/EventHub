import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub/model/event.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/user/myevent_edit.dart';
import 'package:eventhub/screen/user/user_widget.dart';
import 'package:eventhub/screen/login_page.dart';

class MyEventReg extends StatefulWidget {
  final User passUser;
  final String appBarTitle;

  MyEventReg({Key? key, required this.passUser, required this.appBarTitle})
      : super(key: key);

  @override
  _MyEventRegState createState() => _MyEventRegState();
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
          .where('email', isEqualTo: widget.passUser.email)
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

  Future<void> _deleteRegistration(Event event) async {
    void _performDelete(Event event) async {
      try {
        // Query to find the registration document
        final querySnapshot = await FirebaseFirestore.instance
            .collection('registrations')
            .where('email', isEqualTo: widget.passUser.email)
            .where('event_id', isEqualTo: event.id)
            .get();

        // Check if there is exactly one matching document
        if (querySnapshot.size == 1) {
          final registrationDoc = querySnapshot.docs.first;

          // Delete the registration document
          // await registrationDoc.reference.delete();
          await FirebaseFirestore.instance.runTransaction((transaction) async {
             transaction.delete(registrationDoc.reference);
             final eventDocRef = FirebaseFirestore.instance.collection('eventData').doc(event.id);
             transaction.update(eventDocRef, {'registration': FieldValue.increment(-1)});
          });
          // Update local state to reflect the deletion
          setState(() {
            _myRegEvents.remove(event);
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration deleted successfully')),
          );
        } else {
          // Handle case where no registration document was found or more than one was found
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Error: Registration not found or multiple registrations found')),
          );
        }
      } catch (e) {
        // Show error message if deletion fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting registration: $e')),
        );
      }
    }

    // Function to show the confirmation dialog
    Future<void> _showConfirmationDialog(BuildContext context) async {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm Delete"),
            content: Text("Are you sure you want to delete this registration?"),
            actions: <Widget>[
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
              TextButton(
                child: Text("Delete"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  _performDelete(event); // Proceed with delete action
                },
              ),
            ],
          );
        },
      );
    }

    // Function to perform the deletion after confirmation

    // Show confirmation dialog before deletion
    _showConfirmationDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logoutAndNavigateToLogin(context),
          ),
        ],
      ),
      body: _myRegEvents.isEmpty
          ? Center(
              child: Text(
                'No events registered.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _myRegEvents.length,
              itemBuilder: (context, index) {
                final event = _myRegEvents[index];
                return EventCard(
                  event: event,
                  passUser: widget.passUser,
                  onDelete: () => _deleteRegistration(event),
                );
              },
            ),
      bottomNavigationBar: CustomFooter(passUser: widget.passUser),
    );
  }

  void _logoutAndNavigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final User passUser;
  final VoidCallback onDelete;

  EventCard({
    Key? key,
    required this.event,
    required this.passUser,
    required this.onDelete,
  }) : super(key: key);

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
              (event.imageURL != null && event.imageURL!.isNotEmpty)
                  ? event.imageURL![0]
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
                onPressed: () => _editEvent(context, event),
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

  void _editEvent(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventRegPage(
          user: passUser,
          event: event,
          event_id: event.id,
        ),
      ),
    );
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
                Navigator.pop(context); // Close the dialog
                onDelete();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  final Event event;

  EventDetailsPage({Key? key, required this.event}) : super(key: key);

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
            Image.asset((event.imageURL != null && event.imageURL!.isNotEmpty)
                ? event.imageURL![0]
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
