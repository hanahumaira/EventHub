import 'package:eventhub/screen/organiser/edit_event.dart';
import 'package:eventhub/screen/user/myevent_edit.dart';
import 'package:flutter/material.dart';
import 'package:eventhub/model/event.dart';

class MyEventReg extends StatelessWidget {
  final List<Event> dummyEvents;

  const MyEventReg({Key? key, required this.dummyEvents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Events'),
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      ),
      body: ListView.builder(
        itemCount: dummyEvents.length,
        itemBuilder: (context, index) {
          final event = dummyEvents[index];
          return EventCard(event: event);
        },
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            leading: Image.asset(
              event.imageURL ?? 'lib/images/mainpage.png',
              fit: BoxFit.cover,
              width: 80,
            ),
            title: Text(
              event.event,
              style: const TextStyle(color: Colors.white),
            ),
            // subtitle: Text(
            //   '${event.date}',
            //   style: const TextStyle(color: Colors.white70),
            // ),
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
                      builder: (context) => EditEventRegPage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: Color.fromARGB(255, 241, 210, 247),
                ),
              ),
              IconButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              SizedBox(width: 16),
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
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this event?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform delete operation here
                _deleteEvent(context);
              },
              child: Text("Delete"),
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
            Image.asset(event.imageURL ?? 'lib/images/mainpage.png'),
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
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
