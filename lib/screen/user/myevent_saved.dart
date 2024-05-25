import 'package:flutter/material.dart';
import 'package:eventhub/model/event.dart';

class MyEventSaved extends StatelessWidget {
  final List<Event> savedEvents;

  const MyEventSaved({Key? key, required this.savedEvents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Events'),
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      ),
      body: ListView.builder(
        itemCount: savedEvents.length,
        itemBuilder: (context, index) {
          final event = savedEvents[index];
          return EventCard(
            event: event,
            onDelete: () {
              // Implement delete functionality here
              // For example, you can remove the event from the savedEvents list
              // savedEvents.removeAt(index);
              // Then call setState() to update the UI
            },
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onDelete;

  const EventCard({Key? key, required this.event, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: Image.asset(
          event.image,
          fit: BoxFit.cover,
          width: 80,
        ),
        title: Text(
          event.event,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          '${event.date}',
          style: const TextStyle(color: Colors.white70),
        ),
        // trailing: IconButton(
        //   icon: Icon(Icons.delete, color: Colors.red),
        //   onPressed: onDelete,
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
            Image.asset(event.image),
            const SizedBox(height: 16),
            Text(
              event.event,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${event.date}',
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Delete Event',
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
          title: Text("Delete Event"),
          content: Text("Are you sure you want to delete this event?"),
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
